
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
80100050:	68 a0 7e 10 80       	push   $0x80107ea0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 31 4b 00 00       	call   80104b90 <initlock>
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
80100092:	68 a7 7e 10 80       	push   $0x80107ea7
80100097:	50                   	push   %eax
80100098:	e8 b3 49 00 00       	call   80104a50 <initsleeplock>
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
801000e8:	e8 23 4c 00 00       	call   80104d10 <acquire>
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
80100162:	e8 69 4c 00 00       	call   80104dd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 49 00 00       	call   80104a90 <acquiresleep>
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
801001a3:	68 ae 7e 10 80       	push   $0x80107eae
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
801001c2:	e8 69 49 00 00       	call   80104b30 <holdingsleep>
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
801001e0:	68 bf 7e 10 80       	push   $0x80107ebf
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
80100203:	e8 28 49 00 00       	call   80104b30 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 d8 48 00 00       	call   80104af0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 ec 4a 00 00       	call   80104d10 <acquire>
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
80100270:	e9 5b 4b 00 00       	jmp    80104dd0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 7e 10 80       	push   $0x80107ec6
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
801002b1:	e8 5a 4a 00 00       	call   80104d10 <acquire>
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
801002e5:	e8 76 43 00 00       	call   80104660 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 37 00 00       	call   80103ab0 <myproc>
801002ff:	8b 48 30             	mov    0x30(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 bd 4a 00 00       	call   80104dd0 <release>
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
80100365:	e8 66 4a 00 00       	call   80104dd0 <release>
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
801003b6:	68 cd 7e 10 80       	push   $0x80107ecd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 2f 89 10 80 	movl   $0x8010892f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 cf 47 00 00       	call   80104bb0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 7e 10 80       	push   $0x80107ee1
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
8010042a:	e8 61 66 00 00       	call   80106a90 <uartputc>
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
80100515:	e8 76 65 00 00       	call   80106a90 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 65 00 00       	call   80106a90 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 65 00 00       	call   80106a90 <uartputc>
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
80100561:	e8 5a 49 00 00       	call   80104ec0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 48 00 00       	call   80104e20 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 7e 10 80       	push   $0x80107ee5
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
801005c9:	0f b6 92 10 7f 10 80 	movzbl -0x7fef80f0(%edx),%edx
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
8010065f:	e8 ac 46 00 00       	call   80104d10 <acquire>
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
80100697:	e8 34 47 00 00       	call   80104dd0 <release>
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
8010077d:	bb f8 7e 10 80       	mov    $0x80107ef8,%ebx
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
801007bd:	e8 4e 45 00 00       	call   80104d10 <acquire>
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
80100828:	e8 a3 45 00 00       	call   80104dd0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 7e 10 80       	push   $0x80107eff
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
80100877:	e8 94 44 00 00       	call   80104d10 <acquire>
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
801009cf:	e8 fc 43 00 00       	call   80104dd0 <release>
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
801009ff:	e9 1c 3f 00 00       	jmp    80104920 <procdump>
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
80100a20:	e8 fb 3d 00 00       	call   80104820 <wakeup>
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
80100a3a:	68 08 7f 10 80       	push   $0x80107f08
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 47 41 00 00       	call   80104b90 <initlock>

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
80100a90:	e8 1b 30 00 00       	call   80103ab0 <myproc>
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
80100b0c:	e8 ef 70 00 00       	call   80107c00 <setupkvm>
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
80100b73:	e8 a8 6e 00 00       	call   80107a20 <allocuvm>
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
80100ba9:	e8 a2 6d 00 00       	call   80107950 <loaduvm>
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
80100beb:	e8 90 6f 00 00       	call   80107b80 <freevm>
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
80100c32:	e8 e9 6d 00 00       	call   80107a20 <allocuvm>
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
80100c53:	e8 48 70 00 00       	call   80107ca0 <clearpteu>
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
80100ca3:	e8 78 43 00 00       	call   80105020 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 65 43 00 00       	call   80105020 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 34 71 00 00       	call   80107e00 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 6e 00 00       	call   80107b80 <freevm>
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
80100d33:	e8 c8 70 00 00       	call   80107e00 <copyout>
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
80100d71:	e8 6a 42 00 00       	call   80104fe0 <safestrcpy>
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
80100d9d:	e8 1e 6a 00 00       	call   801077c0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 6d 00 00       	call   80107b80 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 7f 10 80       	push   $0x80107f21
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
80100dea:	68 2d 7f 10 80       	push   $0x80107f2d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 97 3d 00 00       	call   80104b90 <initlock>
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
80100e15:	e8 f6 3e 00 00       	call   80104d10 <acquire>
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
80100e41:	e8 8a 3f 00 00       	call   80104dd0 <release>
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
80100e5a:	e8 71 3f 00 00       	call   80104dd0 <release>
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
80100e83:	e8 88 3e 00 00       	call   80104d10 <acquire>
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
80100ea0:	e8 2b 3f 00 00       	call   80104dd0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 7f 10 80       	push   $0x80107f34
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
80100ed5:	e8 36 3e 00 00       	call   80104d10 <acquire>
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
80100f10:	e8 bb 3e 00 00       	call   80104dd0 <release>

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
80100f3e:	e9 8d 3e 00 00       	jmp    80104dd0 <release>
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
80100f8c:	68 3c 7f 10 80       	push   $0x80107f3c
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
8010107a:	68 46 7f 10 80       	push   $0x80107f46
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
80101163:	68 4f 7f 10 80       	push   $0x80107f4f
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
80101199:	68 55 7f 10 80       	push   $0x80107f55
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
80101217:	68 5f 7f 10 80       	push   $0x80107f5f
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
801012d4:	68 72 7f 10 80       	push   $0x80107f72
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
80101315:	e8 06 3b 00 00       	call   80104e20 <memset>
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
8010135a:	e8 b1 39 00 00       	call   80104d10 <acquire>
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
801013c7:	e8 04 3a 00 00       	call   80104dd0 <release>

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
801013f5:	e8 d6 39 00 00       	call   80104dd0 <release>
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
80101422:	68 88 7f 10 80       	push   $0x80107f88
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
801014eb:	68 98 7f 10 80       	push   $0x80107f98
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
80101525:	e8 96 39 00 00       	call   80104ec0 <memmove>
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
80101550:	68 ab 7f 10 80       	push   $0x80107fab
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 31 36 00 00       	call   80104b90 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 7f 10 80       	push   $0x80107fb2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 d4 34 00 00       	call   80104a50 <initsleeplock>
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
801015c1:	68 18 80 10 80       	push   $0x80108018
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
8010165e:	e8 bd 37 00 00       	call   80104e20 <memset>
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
80101693:	68 b8 7f 10 80       	push   $0x80107fb8
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
80101705:	e8 b6 37 00 00       	call   80104ec0 <memmove>
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
80101743:	e8 c8 35 00 00       	call   80104d10 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 78 36 00 00       	call   80104dd0 <release>
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
80101786:	e8 05 33 00 00       	call   80104a90 <acquiresleep>
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
801017f8:	e8 c3 36 00 00       	call   80104ec0 <memmove>
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
8010181d:	68 d0 7f 10 80       	push   $0x80107fd0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ca 7f 10 80       	push   $0x80107fca
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
80101857:	e8 d4 32 00 00       	call   80104b30 <holdingsleep>
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
80101873:	e9 78 32 00 00       	jmp    80104af0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 df 7f 10 80       	push   $0x80107fdf
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
801018a4:	e8 e7 31 00 00       	call   80104a90 <acquiresleep>
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
801018be:	e8 2d 32 00 00       	call   80104af0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 41 34 00 00       	call   80104d10 <acquire>
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
801018e4:	e9 e7 34 00 00       	jmp    80104dd0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 13 34 00 00       	call   80104d10 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 c4 34 00 00       	call   80104dd0 <release>
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
80101b07:	e8 b4 33 00 00       	call   80104ec0 <memmove>
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
80101c03:	e8 b8 32 00 00       	call   80104ec0 <memmove>
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
80101ca2:	e8 89 32 00 00       	call   80104f30 <strncmp>
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
80101d05:	e8 26 32 00 00       	call   80104f30 <strncmp>
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
80101d4a:	68 f9 7f 10 80       	push   $0x80107ff9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 e7 7f 10 80       	push   $0x80107fe7
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
80101d8a:	e8 21 1d 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 6f 2f 00 00       	call   80104d10 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 1f 30 00 00       	call   80104dd0 <release>
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
80101e17:	e8 a4 30 00 00       	call   80104ec0 <memmove>
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
80101ea3:	e8 18 30 00 00       	call   80104ec0 <memmove>
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
80101fd5:	e8 a6 2f 00 00       	call   80104f80 <strncpy>
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
80102013:	68 08 80 10 80       	push   $0x80108008
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 ea 86 10 80       	push   $0x801086ea
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
8010212b:	68 74 80 10 80       	push   $0x80108074
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 6b 80 10 80       	push   $0x8010806b
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
8010215a:	68 86 80 10 80       	push   $0x80108086
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 27 2a 00 00       	call   80104b90 <initlock>
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
801021f2:	e8 19 2b 00 00       	call   80104d10 <acquire>

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
8010224d:	e8 ce 25 00 00       	call   80104820 <wakeup>

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
8010226b:	e8 60 2b 00 00       	call   80104dd0 <release>

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
80102292:	e8 99 28 00 00       	call   80104b30 <holdingsleep>
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
801022cc:	e8 3f 2a 00 00       	call   80104d10 <acquire>

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
80102319:	e8 42 23 00 00       	call   80104660 <sleep>
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
80102336:	e9 95 2a 00 00       	jmp    80104dd0 <release>
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
8010235a:	68 b5 80 10 80       	push   $0x801080b5
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 a0 80 10 80       	push   $0x801080a0
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 8a 80 10 80       	push   $0x8010808a
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
801023ce:	68 d4 80 10 80       	push   $0x801080d4
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
801024a6:	e8 75 29 00 00       	call   80104e20 <memset>

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
801024e0:	e8 2b 28 00 00       	call   80104d10 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 d0 28 00 00       	jmp    80104dd0 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 06 81 10 80       	push   $0x80108106
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
8010256f:	68 0c 81 10 80       	push   $0x8010810c
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 12 26 00 00       	call   80104b90 <initlock>
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
80102663:	e8 a8 26 00 00       	call   80104d10 <acquire>
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
80102691:	e8 3a 27 00 00       	call   80104dd0 <release>
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
801026df:	0f b6 8a 40 82 10 80 	movzbl -0x7fef7dc0(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 40 81 10 80 	movzbl -0x7fef7ec0(%edx),%eax
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
801026ff:	8b 04 85 20 81 10 80 	mov    -0x7fef7ee0(,%eax,4),%eax
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
8010273a:	0f b6 8a 40 82 10 80 	movzbl -0x7fef7dc0(%edx),%ecx
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
80102abf:	e8 ac 23 00 00       	call   80104e70 <memcmp>
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
80102bf4:	e8 c7 22 00 00       	call   80104ec0 <memmove>
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
80102c9e:	68 40 83 10 80       	push   $0x80108340
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 e3 1e 00 00       	call   80104b90 <initlock>
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
80102d3f:	e8 cc 1f 00 00       	call   80104d10 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 fe 18 00 00       	call   80104660 <sleep>
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
80102d94:	e8 37 20 00 00       	call   80104dd0 <release>
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
80102db2:	e8 59 1f 00 00       	call   80104d10 <acquire>
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
80102df0:	e8 db 1f 00 00       	call   80104dd0 <release>
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
80102e0a:	e8 01 1f 00 00       	call   80104d10 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 fb 19 00 00       	call   80104820 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 9f 1f 00 00       	call   80104dd0 <release>
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
80102e84:	e8 37 20 00 00       	call   80104ec0 <memmove>
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
80102ed8:	e8 43 19 00 00       	call   80104820 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 e7 1e 00 00       	call   80104dd0 <release>
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
80102ef7:	68 44 83 10 80       	push   $0x80108344
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
80102f52:	e8 b9 1d 00 00       	call   80104d10 <acquire>
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
80102f95:	e9 36 1e 00 00       	jmp    80104dd0 <release>
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
80102fc1:	68 53 83 10 80       	push   $0x80108353
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 69 83 10 80       	push   $0x80108369
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
80102fe7:	e8 94 09 00 00       	call   80103980 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 8d 09 00 00       	call   80103980 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 84 83 10 80       	push   $0x80108384
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 b9 36 00 00       	call   801066c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 04 09 00 00       	call   80103910 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 a1 12 00 00       	call   801042c0 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 71 47 00 00       	call   801077a0 <switchkvm>
  seginit();
8010302f:	e8 dc 46 00 00       	call   80107710 <seginit>
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
80103065:	e8 16 4c 00 00       	call   80107c80 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 97 46 00 00       	call   80107710 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 43 39 00 00       	call   801069d0 <uartinit>
  pinit();         // process table
8010308d:	e8 5e 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
80103092:	e8 a9 35 00 00       	call   80106640 <tvinit>
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
801030b8:	e8 03 1e 00 00       	call   80104ec0 <memmove>

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
801030f9:	e8 12 08 00 00       	call   80103910 <mycpu>
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
80103162:	e8 79 09 00 00       	call   80103ae0 <userinit>
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
8010319e:	68 98 83 10 80       	push   $0x80108398
801031a3:	56                   	push   %esi
801031a4:	e8 c7 1c 00 00       	call   80104e70 <memcmp>
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
8010325a:	68 9d 83 10 80       	push   $0x8010839d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 08 1c 00 00       	call   80104e70 <memcmp>
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
801033b3:	68 a2 83 10 80       	push   $0x801083a2
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 bc 83 10 80       	push   $0x801083bc
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
80103467:	68 db 83 10 80       	push   $0x801083db
8010346c:	50                   	push   %eax
8010346d:	e8 1e 17 00 00       	call   80104b90 <initlock>
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
80103513:	e8 f8 17 00 00       	call   80104d10 <acquire>
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
80103533:	e8 e8 12 00 00       	call   80104820 <wakeup>
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
80103558:	e9 73 18 00 00       	jmp    80104dd0 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 a7 12 00 00       	call   80104820 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 47 18 00 00       	call   80104dd0 <release>
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
801035b1:	e8 5a 17 00 00       	call   80104d10 <acquire>
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
801035f8:	e8 b3 04 00 00       	call   80103ab0 <myproc>
801035fd:	8b 48 30             	mov    0x30(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 13 12 00 00       	call   80104820 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 4a 10 00 00       	call   80104660 <sleep>
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
8010363c:	e8 8f 17 00 00       	call   80104dd0 <release>
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
8010368a:	e8 91 11 00 00       	call   80104820 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 39 17 00 00       	call   80104dd0 <release>
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
801036ba:	e8 51 16 00 00       	call   80104d10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 d3 03 00 00       	call   80103ab0 <myproc>
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
801036ed:	e8 6e 0f 00 00       	call   80104660 <sleep>
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
80103756:	e8 c5 10 00 00       	call   80104820 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 6d 16 00 00       	call   80104dd0 <release>
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
80103779:	e8 52 16 00 00       	call   80104dd0 <release>
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
801037a1:	e8 6a 15 00 00       	call   80104d10 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801037b6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801037bc:	0f 84 ae 00 00 00    	je     80103870 <allocproc+0xe0>
    if (p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->que_id = LCFS;
  p->priority = PRIORITY_DEF;
  p->priority_ratio = 1.0f;
801037c9:	d9 e8                	fld1   
  p->pid = nextpid++;
801037cb:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->creation_time_ratio = 1.0f;
  p->executed_cycle = 0.1f;
  p->executed_cycle_ratio = 1.0f;
  p->process_size_ratio = 1.0f;
  release(&ptable.lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d3:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority_ratio = 1.0f;
801037da:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->creation_time_ratio = 1.0f;
801037e0:	d9 93 90 00 00 00    	fsts   0x90(%ebx)
  p->pid = nextpid++;
801037e6:	8d 50 01             	lea    0x1(%eax),%edx
  p->executed_cycle_ratio = 1.0f;
801037e9:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
  p->pid = nextpid++;
801037ef:	89 43 10             	mov    %eax,0x10(%ebx)
  p->process_size_ratio = 1.0f;
801037f2:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  p->que_id = LCFS;
801037f8:	c7 43 28 02 00 00 00 	movl   $0x2,0x28(%ebx)
  p->priority = PRIORITY_DEF;
801037ff:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103806:	00 00 00 
  p->executed_cycle = 0.1f;
80103809:	c7 83 94 00 00 00 cd 	movl   $0x3dcccccd,0x94(%ebx)
80103810:	cc cc 3d 
  release(&ptable.lock);
80103813:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103818:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010381e:	e8 ad 15 00 00       	call   80104dd0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103823:	e8 08 ee ff ff       	call   80102630 <kalloc>
80103828:	83 c4 10             	add    $0x10,%esp
8010382b:	89 43 08             	mov    %eax,0x8(%ebx)
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 57                	je     80103889 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103832:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103838:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103840:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103843:	c7 40 14 2b 66 10 80 	movl   $0x8010662b,0x14(%eax)
  p->context = (struct context *)sp;
8010384a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384d:	6a 14                	push   $0x14
8010384f:	6a 00                	push   $0x0
80103851:	50                   	push   %eax
80103852:	e8 c9 15 00 00       	call   80104e20 <memset>
  p->context->eip = (uint)forkret;
80103857:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010385a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010385d:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103864:	89 d8                	mov    %ebx,%eax
80103866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103869:	c9                   	leave  
8010386a:	c3                   	ret    
8010386b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop
  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103873:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103875:	68 20 3d 11 80       	push   $0x80113d20
8010387a:	e8 51 15 00 00       	call   80104dd0 <release>
}
8010387f:	89 d8                	mov    %ebx,%eax
  return 0;
80103881:	83 c4 10             	add    $0x10,%esp
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
    p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103890:	31 db                	xor    %ebx,%ebx
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038aa:	68 20 3d 11 80       	push   $0x80113d20
801038af:	e8 1c 15 00 00       	call   80104dd0 <release>

  if (first)
801038b4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	85 c0                	test   %eax,%eax
801038be:	75 08                	jne    801038c8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038c0:	c9                   	leave  
801038c1:	c3                   	ret    
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038c8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038cf:	00 00 00 
    iinit(ROOTDEV);
801038d2:	83 ec 0c             	sub    $0xc,%esp
801038d5:	6a 01                	push   $0x1
801038d7:	e8 64 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038e3:	e8 a8 f3 ff ff       	call   80102c90 <initlog>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	c9                   	leave  
801038ec:	c3                   	ret    
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <pinit>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038fa:	68 e0 83 10 80       	push   $0x801083e0
801038ff:	68 20 3d 11 80       	push   $0x80113d20
80103904:	e8 87 12 00 00       	call   80104b90 <initlock>
}
80103909:	83 c4 10             	add    $0x10,%esp
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax

80103910 <mycpu>:
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	56                   	push   %esi
80103918:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103919:	9c                   	pushf  
8010391a:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010391b:	f6 c4 02             	test   $0x2,%ah
8010391e:	75 4a                	jne    8010396a <mycpu+0x5a>
  apicid = lapicid();
80103920:	e8 7b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103925:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010392b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
8010392d:	85 f6                	test   %esi,%esi
8010392f:	7e 2c                	jle    8010395d <mycpu+0x4d>
80103931:	31 d2                	xor    %edx,%edx
80103933:	eb 0a                	jmp    8010393f <mycpu+0x2f>
80103935:	8d 76 00             	lea    0x0(%esi),%esi
80103938:	83 c2 01             	add    $0x1,%edx
8010393b:	39 f2                	cmp    %esi,%edx
8010393d:	74 1e                	je     8010395d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010393f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103945:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
8010394c:	39 d8                	cmp    %ebx,%eax
8010394e:	75 e8                	jne    80103938 <mycpu+0x28>
}
80103950:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103953:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5d                   	pop    %ebp
8010395c:	c3                   	ret    
  panic("unknown apicid\n");
8010395d:	83 ec 0c             	sub    $0xc,%esp
80103960:	68 e7 83 10 80       	push   $0x801083e7
80103965:	e8 26 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	68 24 85 10 80       	push   $0x80108524
80103972:	e8 19 ca ff ff       	call   80100390 <panic>
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax

80103980 <cpuid>:
{
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
8010398a:	e8 81 ff ff ff       	call   80103910 <mycpu>
}
8010398f:	c9                   	leave  
  return mycpu() - cpus;
80103990:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103995:	c1 f8 04             	sar    $0x4,%eax
80103998:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399e:	c3                   	ret    
8010399f:	90                   	nop

801039a0 <aging>:
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	56                   	push   %esi
  time = ticks;
801039a8:	8b 35 a0 6d 11 80    	mov    0x80116da0,%esi
{
801039ae:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039af:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801039b4:	eb 18                	jmp    801039ce <aging+0x2e>
801039b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
801039c0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801039c6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801039cc:	74 49                	je     80103a17 <aging+0x77>
    if (p->state == RUNNABLE && p->que_id != RR)
801039ce:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039d2:	75 ec                	jne    801039c0 <aging+0x20>
801039d4:	83 7b 28 01          	cmpl   $0x1,0x28(%ebx)
801039d8:	74 e6                	je     801039c0 <aging+0x20>
      if (time - p->preemption_time > AGING_THRS)
801039da:	89 f0                	mov    %esi,%eax
801039dc:	2b 43 24             	sub    0x24(%ebx),%eax
801039df:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
801039e4:	7e da                	jle    801039c0 <aging+0x20>
        release(&ptable.lock);
801039e6:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039e9:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
        release(&ptable.lock);
801039ef:	68 20 3d 11 80       	push   $0x80113d20
801039f4:	e8 d7 13 00 00       	call   80104dd0 <release>
        acquire(&ptable.lock);
801039f9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->que_id = RR;
80103a00:	c7 43 88 01 00 00 00 	movl   $0x1,-0x78(%ebx)
        acquire(&ptable.lock);
80103a07:	e8 04 13 00 00       	call   80104d10 <acquire>
80103a0c:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a0f:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103a15:	75 b7                	jne    801039ce <aging+0x2e>
}
80103a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a1a:	5b                   	pop    %ebx
80103a1b:	5e                   	pop    %esi
80103a1c:	5d                   	pop    %ebp
80103a1d:	c3                   	ret    
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <reset_bjf_attributes>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 24             	sub    $0x24,%esp
80103a2a:	d9 45 0c             	flds   0xc(%ebp)
  acquire(&ptable.lock);
80103a2d:	68 20 3d 11 80       	push   $0x80113d20
{
80103a32:	d9 5d ec             	fstps  -0x14(%ebp)
80103a35:	d9 45 10             	flds   0x10(%ebp)
80103a38:	d9 5d f0             	fstps  -0x10(%ebp)
80103a3b:	d9 45 14             	flds   0x14(%ebp)
80103a3e:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103a41:	e8 ca 12 00 00       	call   80104d10 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a46:	d9 45 ec             	flds   -0x14(%ebp)
80103a49:	d9 45 f0             	flds   -0x10(%ebp)
  acquire(&ptable.lock);
80103a4c:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a4f:	d9 45 f4             	flds   -0xc(%ebp)
80103a52:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5e:	66 90                	xchg   %ax,%ax
    if (p->state != UNUSED)
80103a60:	8b 50 0c             	mov    0xc(%eax),%edx
80103a63:	85 d2                	test   %edx,%edx
80103a65:	74 1e                	je     80103a85 <reset_bjf_attributes+0x65>
80103a67:	d9 ca                	fxch   %st(2)
      p->creation_time_ratio = creation_time_ratio;
80103a69:	d9 90 90 00 00 00    	fsts   0x90(%eax)
80103a6f:	d9 c9                	fxch   %st(1)
      p->executed_cycle_ratio = exec_cycle_ratio;
80103a71:	d9 90 98 00 00 00    	fsts   0x98(%eax)
80103a77:	d9 ca                	fxch   %st(2)
      p->priority_ratio = size_ratio;
80103a79:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80103a7f:	d9 c9                	fxch   %st(1)
80103a81:	d9 ca                	fxch   %st(2)
80103a83:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a85:	05 a0 00 00 00       	add    $0xa0,%eax
80103a8a:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103a8f:	75 cf                	jne    80103a60 <reset_bjf_attributes+0x40>
80103a91:	dd d8                	fstp   %st(0)
80103a93:	dd d8                	fstp   %st(0)
80103a95:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103a97:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103a9e:	c9                   	leave  
  release(&ptable.lock);
80103a9f:	e9 2c 13 00 00       	jmp    80104dd0 <release>
80103aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <myproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	53                   	push   %ebx
80103ab8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103abb:	e8 50 11 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103ac0:	e8 4b fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acb:	e8 90 11 00 00       	call   80104c60 <popcli>
}
80103ad0:	83 c4 04             	add    $0x4,%esp
80103ad3:	89 d8                	mov    %ebx,%eax
80103ad5:	5b                   	pop    %ebx
80103ad6:	5d                   	pop    %ebp
80103ad7:	c3                   	ret    
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <userinit>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	53                   	push   %ebx
80103ae8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103aeb:	e8 a0 fc ff ff       	call   80103790 <allocproc>
80103af0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103af2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80103af7:	e8 04 41 00 00       	call   80107c00 <setupkvm>
80103afc:	89 43 04             	mov    %eax,0x4(%ebx)
80103aff:	85 c0                	test   %eax,%eax
80103b01:	0f 84 c4 00 00 00    	je     80103bcb <userinit+0xeb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b07:	83 ec 04             	sub    $0x4,%esp
80103b0a:	68 2c 00 00 00       	push   $0x2c
80103b0f:	68 60 b4 10 80       	push   $0x8010b460
80103b14:	50                   	push   %eax
80103b15:	e8 b6 3d 00 00       	call   801078d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b23:	6a 4c                	push   $0x4c
80103b25:	6a 00                	push   $0x0
80103b27:	ff 73 18             	pushl  0x18(%ebx)
80103b2a:	e8 f1 12 00 00       	call   80104e20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b43:	8b 43 18             	mov    0x18(%ebx),%eax
80103b46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b55:	8b 43 18             	mov    0x18(%ebx),%eax
80103b58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b60:	8b 43 18             	mov    0x18(%ebx),%eax
80103b63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103b74:	8b 43 18             	mov    0x18(%ebx),%eax
80103b77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7e:	8d 43 78             	lea    0x78(%ebx),%eax
80103b81:	6a 10                	push   $0x10
80103b83:	68 10 84 10 80       	push   $0x80108410
80103b88:	50                   	push   %eax
80103b89:	e8 52 14 00 00       	call   80104fe0 <safestrcpy>
  p->cwd = namei("/");
80103b8e:	c7 04 24 19 84 10 80 	movl   $0x80108419,(%esp)
80103b95:	e8 96 e4 ff ff       	call   80102030 <namei>
80103b9a:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103b9d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ba4:	e8 67 11 00 00       	call   80104d10 <acquire>
  p->state = RUNNABLE;
80103ba9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103bb0:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103bb7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bbe:	e8 0d 12 00 00       	call   80104dd0 <release>
}
80103bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc6:	83 c4 10             	add    $0x10,%esp
80103bc9:	c9                   	leave  
80103bca:	c3                   	ret    
    panic("userinit: out of memory?");
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	68 f7 83 10 80       	push   $0x801083f7
80103bd3:	e8 b8 c7 ff ff       	call   80100390 <panic>
80103bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdf:	90                   	nop

80103be0 <print_name>:
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	57                   	push   %edi
80103be8:	56                   	push   %esi
  memset(buf, ' ', 14);
80103be9:	8d 7d d9             	lea    -0x27(%ebp),%edi
{
80103bec:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103bed:	31 db                	xor    %ebx,%ebx
{
80103bef:	83 ec 20             	sub    $0x20,%esp
80103bf2:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 14);
80103bf5:	6a 0e                	push   $0xe
80103bf7:	6a 20                	push   $0x20
80103bf9:	57                   	push   %edi
80103bfa:	e8 21 12 00 00       	call   80104e20 <memset>
  buf[14] = 0;
80103bff:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103c03:	83 c4 10             	add    $0x10,%esp
80103c06:	eb 12                	jmp    80103c1a <print_name+0x3a>
80103c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0f:	90                   	nop
    buf[i] = name[i];
80103c10:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103c14:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103c17:	83 c3 01             	add    $0x1,%ebx
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	56                   	push   %esi
80103c1e:	e8 fd 13 00 00       	call   80105020 <strlen>
80103c23:	83 c4 10             	add    $0x10,%esp
80103c26:	39 d8                	cmp    %ebx,%eax
80103c28:	7f e6                	jg     80103c10 <print_name+0x30>
  cprintf("%s", buf);
80103c2a:	83 ec 08             	sub    $0x8,%esp
80103c2d:	57                   	push   %edi
80103c2e:	68 f5 84 10 80       	push   $0x801084f5
80103c33:	e8 78 ca ff ff       	call   801006b0 <cprintf>
}
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3e:	5b                   	pop    %ebx
80103c3f:	5e                   	pop    %esi
80103c40:	5f                   	pop    %edi
80103c41:	5d                   	pop    %ebp
80103c42:	c3                   	ret    
80103c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <find_proc>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	56                   	push   %esi
80103c58:	53                   	push   %ebx
80103c59:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c5c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
80103c64:	68 20 3d 11 80       	push   $0x80113d20
80103c69:	e8 a2 10 00 00       	call   80104d10 <acquire>
80103c6e:	83 c4 10             	add    $0x10,%esp
80103c71:	eb 13                	jmp    80103c86 <find_proc+0x36>
80103c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c77:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c78:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103c7e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103c84:	74 05                	je     80103c8b <find_proc+0x3b>
    if (p->pid == pid)
80103c86:	39 73 10             	cmp    %esi,0x10(%ebx)
80103c89:	75 ed                	jne    80103c78 <find_proc+0x28>
  release(&ptable.lock);
80103c8b:	83 ec 0c             	sub    $0xc,%esp
80103c8e:	68 20 3d 11 80       	push   $0x80113d20
80103c93:	e8 38 11 00 00       	call   80104dd0 <release>
}
80103c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c9b:	89 d8                	mov    %ebx,%eax
80103c9d:	5b                   	pop    %ebx
80103c9e:	5e                   	pop    %esi
80103c9f:	5d                   	pop    %ebp
80103ca0:	c3                   	ret    
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <print_state>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cba:	83 f8 05             	cmp    $0x5,%eax
80103cbd:	77 6e                	ja     80103d2d <print_state+0x7d>
80103cbf:	3e ff 24 85 a0 85 10 	notrack jmp *-0x7fef7a60(,%eax,4)
80103cc6:	80 
80103cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cce:	66 90                	xchg   %ax,%ax
    cprintf("RUNNING   ");
80103cd0:	c7 45 08 47 84 10 80 	movl   $0x80108447,0x8(%ebp)
}
80103cd7:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103cd8:	e9 d3 c9 ff ff       	jmp    801006b0 <cprintf>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103ce0:	c7 45 08 52 84 10 80 	movl   $0x80108452,0x8(%ebp)
}
80103ce7:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103ce8:	e9 c3 c9 ff ff       	jmp    801006b0 <cprintf>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103cf0:	c7 45 08 1b 84 10 80 	movl   $0x8010841b,0x8(%ebp)
}
80103cf7:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103cf8:	e9 b3 c9 ff ff       	jmp    801006b0 <cprintf>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103d00:	c7 45 08 26 84 10 80 	movl   $0x80108426,0x8(%ebp)
}
80103d07:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103d08:	e9 a3 c9 ff ff       	jmp    801006b0 <cprintf>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103d10:	c7 45 08 31 84 10 80 	movl   $0x80108431,0x8(%ebp)
}
80103d17:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103d18:	e9 93 c9 ff ff       	jmp    801006b0 <cprintf>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103d20:	c7 45 08 3c 84 10 80 	movl   $0x8010843c,0x8(%ebp)
}
80103d27:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103d28:	e9 83 c9 ff ff       	jmp    801006b0 <cprintf>
    cprintf("damn ways to die");
80103d2d:	c7 45 08 5d 84 10 80 	movl   $0x8010845d,0x8(%ebp)
}
80103d34:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103d35:	e9 76 c9 ff ff       	jmp    801006b0 <cprintf>
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d40 <print_bitches>:
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	53                   	push   %ebx
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103d48:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103d4d:	83 ec 20             	sub    $0x20,%esp
  acquire(&ptable.lock);
80103d50:	68 20 3d 11 80       	push   $0x80113d20
80103d55:	e8 b6 0f 00 00       	call   80104d10 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103d5a:	c7 04 24 4c 85 10 80 	movl   $0x8010854c,(%esp)
80103d61:	e8 4a c9 ff ff       	call   801006b0 <cprintf>
80103d66:	83 c4 10             	add    $0x10,%esp
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("-");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 6e 84 10 80       	push   $0x8010846e
80103d78:	e8 33 c9 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < 80; i++)
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	83 eb 01             	sub    $0x1,%ebx
80103d83:	75 eb                	jne    80103d70 <print_bitches+0x30>
  cprintf("\n");
80103d85:	83 ec 0c             	sub    $0xc,%esp
80103d88:	bb cc 3d 11 80       	mov    $0x80113dcc,%ebx
80103d8d:	68 2f 89 10 80       	push   $0x8010892f
80103d92:	e8 19 c9 ff ff       	call   801006b0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d97:	83 c4 10             	add    $0x10,%esp
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state == UNUSED)
80103da0:	8b 4b 94             	mov    -0x6c(%ebx),%ecx
80103da3:	85 c9                	test   %ecx,%ecx
80103da5:	0f 84 f9 00 00 00    	je     80103ea4 <print_bitches+0x164>
    print_name(p->name);
80103dab:	83 ec 0c             	sub    $0xc,%esp
80103dae:	53                   	push   %ebx
80103daf:	e8 2c fe ff ff       	call   80103be0 <print_name>
    cprintf("%d  ", p->pid);
80103db4:	58                   	pop    %eax
80103db5:	5a                   	pop    %edx
80103db6:	ff 73 98             	pushl  -0x68(%ebx)
80103db9:	68 70 84 10 80       	push   $0x80108470
80103dbe:	e8 ed c8 ff ff       	call   801006b0 <cprintf>
    print_state((*p).state);
80103dc3:	59                   	pop    %ecx
80103dc4:	ff 73 94             	pushl  -0x6c(%ebx)
80103dc7:	e8 e4 fe ff ff       	call   80103cb0 <print_state>
    cprintf("%d   ", p->que_id);
80103dcc:	58                   	pop    %eax
80103dcd:	5a                   	pop    %edx
80103dce:	ff 73 b0             	pushl  -0x50(%ebx)
80103dd1:	68 75 84 10 80       	push   $0x80108475
80103dd6:	e8 d5 c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", (int)p->executed_cycle);
80103ddb:	d9 43 1c             	flds   0x1c(%ebx)
80103dde:	59                   	pop    %ecx
80103ddf:	d9 7d f6             	fnstcw -0xa(%ebp)
80103de2:	58                   	pop    %eax
80103de3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103de7:	80 cc 0c             	or     $0xc,%ah
80103dea:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103dee:	d9 6d f4             	fldcw  -0xc(%ebp)
80103df1:	db 5d f0             	fistpl -0x10(%ebp)
80103df4:	d9 6d f6             	fldcw  -0xa(%ebp)
80103df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dfa:	50                   	push   %eax
80103dfb:	68 75 84 10 80       	push   $0x80108475
80103e00:	e8 ab c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", p->creation_time);
80103e05:	58                   	pop    %eax
80103e06:	5a                   	pop    %edx
80103e07:	ff 73 a8             	pushl  -0x58(%ebx)
80103e0a:	68 75 84 10 80       	push   $0x80108475
80103e0f:	e8 9c c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", p->priority);
80103e14:	59                   	pop    %ecx
80103e15:	58                   	pop    %eax
80103e16:	ff 73 10             	pushl  0x10(%ebx)
80103e19:	68 75 84 10 80       	push   $0x80108475
80103e1e:	e8 8d c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", (int)p->priority_ratio);
80103e23:	d9 43 14             	flds   0x14(%ebx)
80103e26:	58                   	pop    %eax
80103e27:	d9 7d f6             	fnstcw -0xa(%ebp)
80103e2a:	5a                   	pop    %edx
80103e2b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103e2f:	80 cc 0c             	or     $0xc,%ah
80103e32:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103e36:	d9 6d f4             	fldcw  -0xc(%ebp)
80103e39:	db 5d f0             	fistpl -0x10(%ebp)
80103e3c:	d9 6d f6             	fldcw  -0xa(%ebp)
80103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e42:	50                   	push   %eax
80103e43:	68 75 84 10 80       	push   $0x80108475
80103e48:	e8 63 c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", (int)p->creation_time_ratio);
80103e4d:	d9 43 18             	flds   0x18(%ebx)
80103e50:	59                   	pop    %ecx
80103e51:	d9 7d f6             	fnstcw -0xa(%ebp)
80103e54:	58                   	pop    %eax
80103e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103e59:	80 cc 0c             	or     $0xc,%ah
80103e5c:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103e60:	d9 6d f4             	fldcw  -0xc(%ebp)
80103e63:	db 5d f0             	fistpl -0x10(%ebp)
80103e66:	d9 6d f6             	fldcw  -0xa(%ebp)
80103e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e6c:	50                   	push   %eax
80103e6d:	68 75 84 10 80       	push   $0x80108475
80103e72:	e8 39 c8 ff ff       	call   801006b0 <cprintf>
    cprintf("%d\n", (int)p->executed_cycle_ratio);
80103e77:	d9 43 20             	flds   0x20(%ebx)
80103e7a:	58                   	pop    %eax
80103e7b:	d9 7d f6             	fnstcw -0xa(%ebp)
80103e7e:	5a                   	pop    %edx
80103e7f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103e83:	80 cc 0c             	or     $0xc,%ah
80103e86:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103e8a:	d9 6d f4             	fldcw  -0xc(%ebp)
80103e8d:	db 5d f0             	fistpl -0x10(%ebp)
80103e90:	d9 6d f6             	fldcw  -0xa(%ebp)
80103e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e96:	50                   	push   %eax
80103e97:	68 94 83 10 80       	push   $0x80108394
80103e9c:	e8 0f c8 ff ff       	call   801006b0 <cprintf>
80103ea1:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea4:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103eaa:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
80103eb0:	0f 85 ea fe ff ff    	jne    80103da0 <print_bitches+0x60>
  release(&ptable.lock);
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	68 20 3d 11 80       	push   $0x80113d20
80103ebe:	e8 0d 0f 00 00       	call   80104dd0 <release>
}
80103ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ec6:	83 c4 10             	add    $0x10,%esp
80103ec9:	c9                   	leave  
80103eca:	c3                   	ret    
80103ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop

80103ed0 <count_child>:
{
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	53                   	push   %ebx
  int count = 0;
80103ed8:	31 db                	xor    %ebx,%ebx
{
80103eda:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103edd:	68 20 3d 11 80       	push   $0x80113d20
80103ee2:	e8 29 0e 00 00       	call   80104d10 <acquire>
    if (p->parent->pid == father->pid)
80103ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eea:	83 c4 10             	add    $0x10,%esp
80103eed:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ef0:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ef5:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->parent->pid == father->pid)
80103ef8:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
80103efb:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103efe:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f01:	05 a0 00 00 00       	add    $0xa0,%eax
      count++;
80103f06:	0f b6 d2             	movzbl %dl,%edx
80103f09:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f0b:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103f10:	75 e6                	jne    80103ef8 <count_child+0x28>
  release(&ptable.lock);
80103f12:	83 ec 0c             	sub    $0xc,%esp
80103f15:	68 20 3d 11 80       	push   $0x80113d20
80103f1a:	e8 b1 0e 00 00       	call   80104dd0 <release>
}
80103f1f:	89 d8                	mov    %ebx,%eax
80103f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f24:	c9                   	leave  
80103f25:	c3                   	ret    
80103f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi

80103f30 <growproc>:
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	56                   	push   %esi
80103f38:	53                   	push   %ebx
80103f39:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f3c:	e8 cf 0c 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103f41:	e8 ca f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f46:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f4c:	e8 0f 0d 00 00       	call   80104c60 <popcli>
  sz = curproc->sz;
80103f51:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103f53:	85 f6                	test   %esi,%esi
80103f55:	7f 19                	jg     80103f70 <growproc+0x40>
  else if (n < 0)
80103f57:	75 37                	jne    80103f90 <growproc+0x60>
  switchuvm(curproc);
80103f59:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f5c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f5e:	53                   	push   %ebx
80103f5f:	e8 5c 38 00 00       	call   801077c0 <switchuvm>
  return 0;
80103f64:	83 c4 10             	add    $0x10,%esp
80103f67:	31 c0                	xor    %eax,%eax
}
80103f69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f6c:	5b                   	pop    %ebx
80103f6d:	5e                   	pop    %esi
80103f6e:	5d                   	pop    %ebp
80103f6f:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f70:	83 ec 04             	sub    $0x4,%esp
80103f73:	01 c6                	add    %eax,%esi
80103f75:	56                   	push   %esi
80103f76:	50                   	push   %eax
80103f77:	ff 73 04             	pushl  0x4(%ebx)
80103f7a:	e8 a1 3a 00 00       	call   80107a20 <allocuvm>
80103f7f:	83 c4 10             	add    $0x10,%esp
80103f82:	85 c0                	test   %eax,%eax
80103f84:	75 d3                	jne    80103f59 <growproc+0x29>
      return -1;
80103f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f8b:	eb dc                	jmp    80103f69 <growproc+0x39>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f90:	83 ec 04             	sub    $0x4,%esp
80103f93:	01 c6                	add    %eax,%esi
80103f95:	56                   	push   %esi
80103f96:	50                   	push   %eax
80103f97:	ff 73 04             	pushl  0x4(%ebx)
80103f9a:	e8 b1 3b 00 00       	call   80107b50 <deallocuvm>
80103f9f:	83 c4 10             	add    $0x10,%esp
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	75 b3                	jne    80103f59 <growproc+0x29>
80103fa6:	eb de                	jmp    80103f86 <growproc+0x56>
80103fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop

80103fb0 <fork>:
{
80103fb0:	f3 0f 1e fb          	endbr32 
80103fb4:	55                   	push   %ebp
80103fb5:	89 e5                	mov    %esp,%ebp
80103fb7:	57                   	push   %edi
80103fb8:	56                   	push   %esi
80103fb9:	53                   	push   %ebx
80103fba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fbd:	e8 4e 0c 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103fc2:	e8 49 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103fc7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fcd:	e8 8e 0c 00 00       	call   80104c60 <popcli>
  if ((np = allocproc()) == 0)
80103fd2:	e8 b9 f7 ff ff       	call   80103790 <allocproc>
80103fd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	0f 84 de 00 00 00    	je     801040c0 <fork+0x110>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103fe2:	83 ec 08             	sub    $0x8,%esp
80103fe5:	ff 33                	pushl  (%ebx)
80103fe7:	89 c7                	mov    %eax,%edi
80103fe9:	ff 73 04             	pushl  0x4(%ebx)
80103fec:	e8 df 3c 00 00       	call   80107cd0 <copyuvm>
80103ff1:	83 c4 10             	add    $0x10,%esp
80103ff4:	89 47 04             	mov    %eax,0x4(%edi)
80103ff7:	85 c0                	test   %eax,%eax
80103ff9:	0f 84 c8 00 00 00    	je     801040c7 <fork+0x117>
  np->sz = curproc->sz;
80103fff:	8b 03                	mov    (%ebx),%eax
80104001:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104004:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104006:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104009:	89 c8                	mov    %ecx,%eax
8010400b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010400e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104013:	8b 73 18             	mov    0x18(%ebx),%esi
80104016:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104018:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010401a:	8b 40 18             	mov    0x18(%eax),%eax
8010401d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80104028:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
8010402c:	85 c0                	test   %eax,%eax
8010402e:	74 13                	je     80104043 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	50                   	push   %eax
80104034:	e8 37 ce ff ff       	call   80100e70 <filedup>
80104039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010403c:	83 c4 10             	add    $0x10,%esp
8010403f:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80104043:	83 c6 01             	add    $0x1,%esi
80104046:	83 fe 10             	cmp    $0x10,%esi
80104049:	75 dd                	jne    80104028 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010404b:	83 ec 0c             	sub    $0xc,%esp
8010404e:	ff 73 74             	pushl  0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104051:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
80104054:	e8 d7 d6 ff ff       	call   80101730 <idup>
80104059:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010405c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010405f:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104062:	8d 47 78             	lea    0x78(%edi),%eax
80104065:	6a 10                	push   $0x10
80104067:	53                   	push   %ebx
80104068:	50                   	push   %eax
80104069:	e8 72 0f 00 00       	call   80104fe0 <safestrcpy>
  pid = np->pid;
8010406e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104071:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104078:	e8 93 0c 00 00       	call   80104d10 <acquire>
  np->state = RUNNABLE;
8010407d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80104084:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010408b:	e8 80 0c 00 00       	call   80104d10 <acquire>
  np->creation_time = ticks;
80104090:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80104095:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80104098:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
8010409b:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801040a2:	e8 29 0d 00 00       	call   80104dd0 <release>
  release(&ptable.lock);
801040a7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040ae:	e8 1d 0d 00 00       	call   80104dd0 <release>
  return pid;
801040b3:	83 c4 10             	add    $0x10,%esp
}
801040b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b9:	89 d8                	mov    %ebx,%eax
801040bb:	5b                   	pop    %ebx
801040bc:	5e                   	pop    %esi
801040bd:	5f                   	pop    %edi
801040be:	5d                   	pop    %ebp
801040bf:	c3                   	ret    
    return -1;
801040c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040c5:	eb ef                	jmp    801040b6 <fork+0x106>
    kfree(np->kstack);
801040c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	ff 73 08             	pushl  0x8(%ebx)
801040d0:	e8 9b e3 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
801040d5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040dc:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040df:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040eb:	eb c9                	jmp    801040b6 <fork+0x106>
801040ed:	8d 76 00             	lea    0x0(%esi),%esi

801040f0 <round_robin>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
  int max_diff = MIN_INT;
801040f5:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040fa:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
801040ff:	89 e5                	mov    %esp,%ebp
80104101:	56                   	push   %esi
  struct proc *res = 0;
80104102:	31 f6                	xor    %esi,%esi
{
80104104:	53                   	push   %ebx
  int now = ticks;
80104105:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010410f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104110:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104114:	75 1a                	jne    80104130 <round_robin+0x40>
80104116:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
8010411a:	75 14                	jne    80104130 <round_robin+0x40>
    if ((now - p->preemption_time > max_diff))
8010411c:	89 da                	mov    %ebx,%edx
8010411e:	2b 50 24             	sub    0x24(%eax),%edx
80104121:	39 ca                	cmp    %ecx,%edx
80104123:	7e 0b                	jle    80104130 <round_robin+0x40>
80104125:	89 d1                	mov    %edx,%ecx
80104127:	89 c6                	mov    %eax,%esi
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104130:	05 a0 00 00 00       	add    $0xa0,%eax
80104135:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010413a:	75 d4                	jne    80104110 <round_robin+0x20>
}
8010413c:	89 f0                	mov    %esi,%eax
8010413e:	5b                   	pop    %ebx
8010413f:	5e                   	pop    %esi
80104140:	5d                   	pop    %ebp
80104141:	c3                   	ret    
80104142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <last_come_first_serve>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
  int latest_time = MIN_INT;
80104155:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415a:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010415f:	89 e5                	mov    %esp,%ebp
80104161:	53                   	push   %ebx
  struct proc *res = 0;
80104162:	31 db                	xor    %ebx,%ebx
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
80104168:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010416c:	75 12                	jne    80104180 <last_come_first_serve+0x30>
8010416e:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80104172:	75 0c                	jne    80104180 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
80104174:	8b 50 20             	mov    0x20(%eax),%edx
80104177:	39 ca                	cmp    %ecx,%edx
80104179:	7e 05                	jle    80104180 <last_come_first_serve+0x30>
8010417b:	89 d1                	mov    %edx,%ecx
8010417d:	89 c3                	mov    %eax,%ebx
8010417f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104180:	05 a0 00 00 00       	add    $0xa0,%eax
80104185:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010418a:	75 dc                	jne    80104168 <last_come_first_serve+0x18>
}
8010418c:	89 d8                	mov    %ebx,%eax
8010418e:	5b                   	pop    %ebx
8010418f:	5d                   	pop    %ebp
80104190:	c3                   	ret    
80104191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop

801041a0 <calculate_rank>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801041a5:	31 c9                	xor    %ecx,%ecx
{
801041a7:	89 e5                	mov    %esp,%ebp
801041a9:	83 ec 08             	sub    $0x8,%esp
801041ac:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801041af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801041b2:	db 80 88 00 00 00    	fildl  0x88(%eax)
801041b8:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
801041be:	db 40 20             	fildl  0x20(%eax)
801041c1:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
801041c7:	8b 10                	mov    (%eax),%edx
801041c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
801041cc:	de c1                	faddp  %st,%st(1)
801041ce:	d9 80 94 00 00 00    	flds   0x94(%eax)
801041d4:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
801041da:	de c1                	faddp  %st,%st(1)
801041dc:	df 6d f8             	fildll -0x8(%ebp)
801041df:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
801041e5:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801041e6:	de c1                	faddp  %st,%st(1)
}
801041e8:	c3                   	ret    
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <best_job_first>:
{
801041f0:	f3 0f 1e fb          	endbr32 
  float min_rank = (float)MAX_INT;
801041f4:	d9 05 d4 85 10 80    	flds   0x801085d4
  struct proc *res = 0;
801041fa:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104208:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010420c:	0f 85 96 00 00 00    	jne    801042a8 <best_job_first+0xb8>
80104212:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104216:	0f 85 8c 00 00 00    	jne    801042a8 <best_job_first+0xb8>
{
8010421c:	55                   	push   %ebp
8010421d:	89 e5                	mov    %esp,%ebp
8010421f:	53                   	push   %ebx
80104220:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104223:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104229:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
8010422f:	31 db                	xor    %ebx,%ebx
80104231:	db 40 20             	fildl  0x20(%eax)
80104234:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
8010423a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010423d:	8b 08                	mov    (%eax),%ecx
8010423f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80104242:	de c1                	faddp  %st,%st(1)
80104244:	d9 80 94 00 00 00    	flds   0x94(%eax)
8010424a:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104250:	de c1                	faddp  %st,%st(1)
80104252:	df 6d f0             	fildll -0x10(%ebp)
80104255:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
8010425b:	de c1                	faddp  %st,%st(1)
8010425d:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
8010425f:	db f1                	fcomi  %st(1),%st
80104261:	76 0d                	jbe    80104270 <best_job_first+0x80>
80104263:	dd d8                	fstp   %st(0)
80104265:	89 c2                	mov    %eax,%edx
80104267:	eb 09                	jmp    80104272 <best_job_first+0x82>
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104270:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104272:	05 a0 00 00 00       	add    $0xa0,%eax
80104277:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010427c:	74 1c                	je     8010429a <best_job_first+0xaa>
    if (p->state != RUNNABLE || p->que_id != BJF)
8010427e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104282:	75 ee                	jne    80104272 <best_job_first+0x82>
80104284:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104288:	74 99                	je     80104223 <best_job_first+0x33>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010428a:	05 a0 00 00 00       	add    $0xa0,%eax
8010428f:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104294:	75 e8                	jne    8010427e <best_job_first+0x8e>
80104296:	dd d8                	fstp   %st(0)
80104298:	eb 02                	jmp    8010429c <best_job_first+0xac>
8010429a:	dd d8                	fstp   %st(0)
}
8010429c:	83 c4 0c             	add    $0xc,%esp
8010429f:	89 d0                	mov    %edx,%eax
801042a1:	5b                   	pop    %ebx
801042a2:	5d                   	pop    %ebp
801042a3:	c3                   	ret    
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a8:	05 a0 00 00 00       	add    $0xa0,%eax
801042ad:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801042b2:	0f 85 50 ff ff ff    	jne    80104208 <best_job_first+0x18>
801042b8:	dd d8                	fstp   %st(0)
}
801042ba:	89 d0                	mov    %edx,%eax
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <scheduler>:
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	57                   	push   %edi
801042c8:	56                   	push   %esi
801042c9:	53                   	push   %ebx
801042ca:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801042cd:	e8 3e f6 ff ff       	call   80103910 <mycpu>
  c->proc = 0;
801042d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042d9:	00 00 00 
  struct cpu *c = mycpu();
801042dc:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801042de:	8d 40 04             	lea    0x4(%eax),%eax
801042e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801042e8:	fb                   	sti    
    acquire(&ptable.lock);
801042e9:	83 ec 0c             	sub    $0xc,%esp
  struct proc *res = 0;
801042ec:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
801042ee:	68 20 3d 11 80       	push   $0x80113d20
801042f3:	e8 18 0a 00 00       	call   80104d10 <acquire>
  int now = ticks;
801042f8:	8b 3d a0 6d 11 80    	mov    0x80116da0,%edi
801042fe:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104301:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104306:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010430b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104310:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104314:	75 1a                	jne    80104330 <scheduler+0x70>
80104316:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
8010431a:	75 14                	jne    80104330 <scheduler+0x70>
    if ((now - p->preemption_time > max_diff))
8010431c:	89 fa                	mov    %edi,%edx
8010431e:	2b 50 24             	sub    0x24(%eax),%edx
80104321:	39 ca                	cmp    %ecx,%edx
80104323:	7e 0b                	jle    80104330 <scheduler+0x70>
80104325:	89 d1                	mov    %edx,%ecx
80104327:	89 c6                	mov    %eax,%esi
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104330:	05 a0 00 00 00       	add    $0xa0,%eax
80104335:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010433a:	75 d4                	jne    80104310 <scheduler+0x50>
    if (p == 0)
8010433c:	85 f6                	test   %esi,%esi
8010433e:	74 60                	je     801043a0 <scheduler+0xe0>
    switchuvm(p);
80104340:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80104343:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(p);
80104349:	56                   	push   %esi
8010434a:	e8 71 34 00 00       	call   801077c0 <switchuvm>
    p->executed_cycle += 0.1f;
8010434f:	d9 05 d0 85 10 80    	flds   0x801085d0
80104355:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
8010435b:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
80104362:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80104367:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
8010436a:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
80104370:	58                   	pop    %eax
80104371:	5a                   	pop    %edx
80104372:	ff 76 1c             	pushl  0x1c(%esi)
80104375:	ff 75 e4             	pushl  -0x1c(%ebp)
80104378:	e8 c6 0c 00 00       	call   80105043 <swtch>
    switchkvm();
8010437d:	e8 1e 34 00 00       	call   801077a0 <switchkvm>
    c->proc = 0;
80104382:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104389:	00 00 00 
    release(&ptable.lock);
8010438c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104393:	e8 38 0a 00 00       	call   80104dd0 <release>
80104398:	83 c4 10             	add    $0x10,%esp
8010439b:	e9 48 ff ff ff       	jmp    801042e8 <scheduler+0x28>
  int latest_time = MIN_INT;
801043a0:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801043b0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043b4:	75 1a                	jne    801043d0 <scheduler+0x110>
801043b6:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801043ba:	75 14                	jne    801043d0 <scheduler+0x110>
    if (p->creation_time > latest_time)
801043bc:	8b 50 20             	mov    0x20(%eax),%edx
801043bf:	39 ca                	cmp    %ecx,%edx
801043c1:	7e 0d                	jle    801043d0 <scheduler+0x110>
801043c3:	89 d1                	mov    %edx,%ecx
801043c5:	89 c6                	mov    %eax,%esi
801043c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ce:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d0:	05 a0 00 00 00       	add    $0xa0,%eax
801043d5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801043da:	75 d4                	jne    801043b0 <scheduler+0xf0>
    if (p == 0)
801043dc:	85 f6                	test   %esi,%esi
801043de:	0f 85 5c ff ff ff    	jne    80104340 <scheduler+0x80>
      p = best_job_first();
801043e4:	e8 07 fe ff ff       	call   801041f0 <best_job_first>
801043e9:	89 c6                	mov    %eax,%esi
    if (p == 0)
801043eb:	85 c0                	test   %eax,%eax
801043ed:	0f 85 4d ff ff ff    	jne    80104340 <scheduler+0x80>
      release(&ptable.lock);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 20 3d 11 80       	push   $0x80113d20
801043fb:	e8 d0 09 00 00       	call   80104dd0 <release>
      continue;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	e9 e0 fe ff ff       	jmp    801042e8 <scheduler+0x28>
80104408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop

80104410 <sched>:
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	56                   	push   %esi
80104418:	53                   	push   %ebx
  pushcli();
80104419:	e8 f2 07 00 00       	call   80104c10 <pushcli>
  c = mycpu();
8010441e:	e8 ed f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104423:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104429:	e8 32 08 00 00       	call   80104c60 <popcli>
  if (!holding(&ptable.lock))
8010442e:	83 ec 0c             	sub    $0xc,%esp
80104431:	68 20 3d 11 80       	push   $0x80113d20
80104436:	e8 85 08 00 00       	call   80104cc0 <holding>
8010443b:	83 c4 10             	add    $0x10,%esp
8010443e:	85 c0                	test   %eax,%eax
80104440:	74 4f                	je     80104491 <sched+0x81>
  if (mycpu()->ncli != 1)
80104442:	e8 c9 f4 ff ff       	call   80103910 <mycpu>
80104447:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010444e:	75 68                	jne    801044b8 <sched+0xa8>
  if (p->state == RUNNING)
80104450:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104454:	74 55                	je     801044ab <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104456:	9c                   	pushf  
80104457:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104458:	f6 c4 02             	test   $0x2,%ah
8010445b:	75 41                	jne    8010449e <sched+0x8e>
  intena = mycpu()->intena;
8010445d:	e8 ae f4 ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104462:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104465:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010446b:	e8 a0 f4 ff ff       	call   80103910 <mycpu>
80104470:	83 ec 08             	sub    $0x8,%esp
80104473:	ff 70 04             	pushl  0x4(%eax)
80104476:	53                   	push   %ebx
80104477:	e8 c7 0b 00 00       	call   80105043 <swtch>
  mycpu()->intena = intena;
8010447c:	e8 8f f4 ff ff       	call   80103910 <mycpu>
}
80104481:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104484:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010448a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448d:	5b                   	pop    %ebx
8010448e:	5e                   	pop    %esi
8010448f:	5d                   	pop    %ebp
80104490:	c3                   	ret    
    panic("sched ptable.lock");
80104491:	83 ec 0c             	sub    $0xc,%esp
80104494:	68 7b 84 10 80       	push   $0x8010847b
80104499:	e8 f2 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 a7 84 10 80       	push   $0x801084a7
801044a6:	e8 e5 be ff ff       	call   80100390 <panic>
    panic("sched running");
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	68 99 84 10 80       	push   $0x80108499
801044b3:	e8 d8 be ff ff       	call   80100390 <panic>
    panic("sched locks");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 8d 84 10 80       	push   $0x8010848d
801044c0:	e8 cb be ff ff       	call   80100390 <panic>
801044c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <exit>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	56                   	push   %esi
801044d9:	53                   	push   %ebx
801044da:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801044dd:	e8 2e 07 00 00       	call   80104c10 <pushcli>
  c = mycpu();
801044e2:	e8 29 f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801044e7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044ed:	e8 6e 07 00 00       	call   80104c60 <popcli>
  if (curproc == initproc)
801044f2:	8d 5e 34             	lea    0x34(%esi),%ebx
801044f5:	8d 7e 74             	lea    0x74(%esi),%edi
801044f8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801044fe:	0f 84 fd 00 00 00    	je     80104601 <exit+0x131>
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104508:	8b 03                	mov    (%ebx),%eax
8010450a:	85 c0                	test   %eax,%eax
8010450c:	74 12                	je     80104520 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010450e:	83 ec 0c             	sub    $0xc,%esp
80104511:	50                   	push   %eax
80104512:	e8 a9 c9 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104517:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010451d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104520:	83 c3 04             	add    $0x4,%ebx
80104523:	39 df                	cmp    %ebx,%edi
80104525:	75 e1                	jne    80104508 <exit+0x38>
  begin_op();
80104527:	e8 04 e8 ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
8010452c:	83 ec 0c             	sub    $0xc,%esp
8010452f:	ff 76 74             	pushl  0x74(%esi)
80104532:	e8 59 d3 ff ff       	call   80101890 <iput>
  end_op();
80104537:	e8 64 e8 ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
8010453c:	c7 46 74 00 00 00 00 	movl   $0x0,0x74(%esi)
  acquire(&ptable.lock);
80104543:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010454a:	e8 c1 07 00 00       	call   80104d10 <acquire>
  wakeup1(curproc->parent);
8010454f:	8b 56 14             	mov    0x14(%esi),%edx
80104552:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104555:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010455a:	eb 10                	jmp    8010456c <exit+0x9c>
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104560:	05 a0 00 00 00       	add    $0xa0,%eax
80104565:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010456a:	74 1e                	je     8010458a <exit+0xba>
    if (p->state == SLEEPING && p->chan == chan)
8010456c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104570:	75 ee                	jne    80104560 <exit+0x90>
80104572:	3b 50 2c             	cmp    0x2c(%eax),%edx
80104575:	75 e9                	jne    80104560 <exit+0x90>
      p->state = RUNNABLE;
80104577:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010457e:	05 a0 00 00 00       	add    $0xa0,%eax
80104583:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104588:	75 e2                	jne    8010456c <exit+0x9c>
      p->parent = initproc;
8010458a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104590:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104595:	eb 17                	jmp    801045ae <exit+0xde>
80104597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459e:	66 90                	xchg   %ax,%ax
801045a0:	81 c2 a0 00 00 00    	add    $0xa0,%edx
801045a6:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
801045ac:	74 3a                	je     801045e8 <exit+0x118>
    if (p->parent == curproc)
801045ae:	39 72 14             	cmp    %esi,0x14(%edx)
801045b1:	75 ed                	jne    801045a0 <exit+0xd0>
      if (p->state == ZOMBIE)
801045b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801045b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801045ba:	75 e4                	jne    801045a0 <exit+0xd0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045bc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801045c1:	eb 11                	jmp    801045d4 <exit+0x104>
801045c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c7:	90                   	nop
801045c8:	05 a0 00 00 00       	add    $0xa0,%eax
801045cd:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801045d2:	74 cc                	je     801045a0 <exit+0xd0>
    if (p->state == SLEEPING && p->chan == chan)
801045d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045d8:	75 ee                	jne    801045c8 <exit+0xf8>
801045da:	3b 48 2c             	cmp    0x2c(%eax),%ecx
801045dd:	75 e9                	jne    801045c8 <exit+0xf8>
      p->state = RUNNABLE;
801045df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045e6:	eb e0                	jmp    801045c8 <exit+0xf8>
  curproc->state = ZOMBIE;
801045e8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801045ef:	e8 1c fe ff ff       	call   80104410 <sched>
  panic("zombie exit");
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	68 c8 84 10 80       	push   $0x801084c8
801045fc:	e8 8f bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104601:	83 ec 0c             	sub    $0xc,%esp
80104604:	68 bb 84 10 80       	push   $0x801084bb
80104609:	e8 82 bd ff ff       	call   80100390 <panic>
8010460e:	66 90                	xchg   %ax,%ax

80104610 <yield>:
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	53                   	push   %ebx
80104618:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
8010461b:	68 20 3d 11 80       	push   $0x80113d20
80104620:	e8 eb 06 00 00       	call   80104d10 <acquire>
  pushcli();
80104625:	e8 e6 05 00 00       	call   80104c10 <pushcli>
  c = mycpu();
8010462a:	e8 e1 f2 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010462f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104635:	e8 26 06 00 00       	call   80104c60 <popcli>
  myproc()->state = RUNNABLE;
8010463a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104641:	e8 ca fd ff ff       	call   80104410 <sched>
  release(&ptable.lock);
80104646:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010464d:	e8 7e 07 00 00       	call   80104dd0 <release>
}
80104652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	c9                   	leave  
80104659:	c3                   	ret    
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <sleep>:
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	57                   	push   %edi
80104668:	56                   	push   %esi
80104669:	53                   	push   %ebx
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104670:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104673:	e8 98 05 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80104678:	e8 93 f2 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010467d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104683:	e8 d8 05 00 00       	call   80104c60 <popcli>
  if (p == 0)
80104688:	85 db                	test   %ebx,%ebx
8010468a:	0f 84 83 00 00 00    	je     80104713 <sleep+0xb3>
  if (lk == 0)
80104690:	85 f6                	test   %esi,%esi
80104692:	74 72                	je     80104706 <sleep+0xa6>
  if (lk != &ptable.lock)
80104694:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010469a:	74 4c                	je     801046e8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
8010469c:	83 ec 0c             	sub    $0xc,%esp
8010469f:	68 20 3d 11 80       	push   $0x80113d20
801046a4:	e8 67 06 00 00       	call   80104d10 <acquire>
    release(lk);
801046a9:	89 34 24             	mov    %esi,(%esp)
801046ac:	e8 1f 07 00 00       	call   80104dd0 <release>
  p->chan = chan;
801046b1:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801046b4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046bb:	e8 50 fd ff ff       	call   80104410 <sched>
  p->chan = 0;
801046c0:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
801046c7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801046ce:	e8 fd 06 00 00       	call   80104dd0 <release>
    acquire(lk);
801046d3:	89 75 08             	mov    %esi,0x8(%ebp)
801046d6:	83 c4 10             	add    $0x10,%esp
}
801046d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046dc:	5b                   	pop    %ebx
801046dd:	5e                   	pop    %esi
801046de:	5f                   	pop    %edi
801046df:	5d                   	pop    %ebp
    acquire(lk);
801046e0:	e9 2b 06 00 00       	jmp    80104d10 <acquire>
801046e5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801046e8:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801046eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046f2:	e8 19 fd ff ff       	call   80104410 <sched>
  p->chan = 0;
801046f7:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
801046fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104701:	5b                   	pop    %ebx
80104702:	5e                   	pop    %esi
80104703:	5f                   	pop    %edi
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    
    panic("sleep without lk");
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	68 da 84 10 80       	push   $0x801084da
8010470e:	e8 7d bc ff ff       	call   80100390 <panic>
    panic("sleep");
80104713:	83 ec 0c             	sub    $0xc,%esp
80104716:	68 d4 84 10 80       	push   $0x801084d4
8010471b:	e8 70 bc ff ff       	call   80100390 <panic>

80104720 <wait>:
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	56                   	push   %esi
80104728:	53                   	push   %ebx
  pushcli();
80104729:	e8 e2 04 00 00       	call   80104c10 <pushcli>
  c = mycpu();
8010472e:	e8 dd f1 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104733:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104739:	e8 22 05 00 00       	call   80104c60 <popcli>
  acquire(&ptable.lock);
8010473e:	83 ec 0c             	sub    $0xc,%esp
80104741:	68 20 3d 11 80       	push   $0x80113d20
80104746:	e8 c5 05 00 00       	call   80104d10 <acquire>
8010474b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010474e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104750:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104755:	eb 17                	jmp    8010476e <wait+0x4e>
80104757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475e:	66 90                	xchg   %ax,%ax
80104760:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104766:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010476c:	74 1e                	je     8010478c <wait+0x6c>
      if (p->parent != curproc)
8010476e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104771:	75 ed                	jne    80104760 <wait+0x40>
      if (p->state == ZOMBIE)
80104773:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104777:	74 37                	je     801047b0 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104779:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
8010477f:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104784:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010478a:	75 e2                	jne    8010476e <wait+0x4e>
    if (!havekids || curproc->killed)
8010478c:	85 c0                	test   %eax,%eax
8010478e:	74 76                	je     80104806 <wait+0xe6>
80104790:	8b 46 30             	mov    0x30(%esi),%eax
80104793:	85 c0                	test   %eax,%eax
80104795:	75 6f                	jne    80104806 <wait+0xe6>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104797:	83 ec 08             	sub    $0x8,%esp
8010479a:	68 20 3d 11 80       	push   $0x80113d20
8010479f:	56                   	push   %esi
801047a0:	e8 bb fe ff ff       	call   80104660 <sleep>
    havekids = 0;
801047a5:	83 c4 10             	add    $0x10,%esp
801047a8:	eb a4                	jmp    8010474e <wait+0x2e>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801047b0:	83 ec 0c             	sub    $0xc,%esp
801047b3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801047b6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801047b9:	e8 b2 dc ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801047be:	5a                   	pop    %edx
801047bf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801047c2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801047c9:	e8 b2 33 00 00       	call   80107b80 <freevm>
        release(&ptable.lock);
801047ce:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801047d5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047dc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047e3:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
801047e7:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
801047ee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801047f5:	e8 d6 05 00 00       	call   80104dd0 <release>
        return pid;
801047fa:	83 c4 10             	add    $0x10,%esp
}
801047fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104800:	89 f0                	mov    %esi,%eax
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
      release(&ptable.lock);
80104806:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104809:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010480e:	68 20 3d 11 80       	push   $0x80113d20
80104813:	e8 b8 05 00 00       	call   80104dd0 <release>
      return -1;
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	eb e0                	jmp    801047fd <wait+0xdd>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	53                   	push   %ebx
80104828:	83 ec 10             	sub    $0x10,%esp
8010482b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010482e:	68 20 3d 11 80       	push   $0x80113d20
80104833:	e8 d8 04 00 00       	call   80104d10 <acquire>
80104838:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010483b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104840:	eb 12                	jmp    80104854 <wakeup+0x34>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104848:	05 a0 00 00 00       	add    $0xa0,%eax
8010484d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104852:	74 1e                	je     80104872 <wakeup+0x52>
    if (p->state == SLEEPING && p->chan == chan)
80104854:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104858:	75 ee                	jne    80104848 <wakeup+0x28>
8010485a:	3b 58 2c             	cmp    0x2c(%eax),%ebx
8010485d:	75 e9                	jne    80104848 <wakeup+0x28>
      p->state = RUNNABLE;
8010485f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104866:	05 a0 00 00 00       	add    $0xa0,%eax
8010486b:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104870:	75 e2                	jne    80104854 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104872:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010487c:	c9                   	leave  
  release(&ptable.lock);
8010487d:	e9 4e 05 00 00       	jmp    80104dd0 <release>
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	53                   	push   %ebx
80104898:	83 ec 10             	sub    $0x10,%esp
8010489b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010489e:	68 20 3d 11 80       	push   $0x80113d20
801048a3:	e8 68 04 00 00       	call   80104d10 <acquire>
801048a8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ab:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801048b0:	eb 12                	jmp    801048c4 <kill+0x34>
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b8:	05 a0 00 00 00       	add    $0xa0,%eax
801048bd:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801048c2:	74 34                	je     801048f8 <kill+0x68>
  {
    if (p->pid == pid)
801048c4:	39 58 10             	cmp    %ebx,0x10(%eax)
801048c7:	75 ef                	jne    801048b8 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
801048c9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801048cd:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
801048d4:	75 07                	jne    801048dd <kill+0x4d>
        p->state = RUNNABLE;
801048d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	68 20 3d 11 80       	push   $0x80113d20
801048e5:	e8 e6 04 00 00       	call   80104dd0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801048ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	31 c0                	xor    %eax,%eax
}
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	68 20 3d 11 80       	push   $0x80113d20
80104900:	e8 cb 04 00 00       	call   80104dd0 <release>
}
80104905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104908:	83 c4 10             	add    $0x10,%esp
8010490b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104910:	c9                   	leave  
80104911:	c3                   	ret    
80104912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104920 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	57                   	push   %edi
80104928:	56                   	push   %esi
80104929:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010492c:	53                   	push   %ebx
8010492d:	bb cc 3d 11 80       	mov    $0x80113dcc,%ebx
80104932:	83 ec 3c             	sub    $0x3c,%esp
80104935:	eb 2b                	jmp    80104962 <procdump+0x42>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104940:	83 ec 0c             	sub    $0xc,%esp
80104943:	68 2f 89 10 80       	push   $0x8010892f
80104948:	e8 63 bd ff ff       	call   801006b0 <cprintf>
8010494d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104950:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104956:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
8010495c:	0f 84 8e 00 00 00    	je     801049f0 <procdump+0xd0>
    if (p->state == UNUSED)
80104962:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	74 e7                	je     80104950 <procdump+0x30>
      state = "???";
80104969:	ba eb 84 10 80       	mov    $0x801084eb,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010496e:	83 f8 05             	cmp    $0x5,%eax
80104971:	77 11                	ja     80104984 <procdump+0x64>
80104973:	8b 14 85 b8 85 10 80 	mov    -0x7fef7a48(,%eax,4),%edx
      state = "???";
8010497a:	b8 eb 84 10 80       	mov    $0x801084eb,%eax
8010497f:	85 d2                	test   %edx,%edx
80104981:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104984:	53                   	push   %ebx
80104985:	52                   	push   %edx
80104986:	ff 73 98             	pushl  -0x68(%ebx)
80104989:	68 ef 84 10 80       	push   $0x801084ef
8010498e:	e8 1d bd ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
8010499a:	75 a4                	jne    80104940 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
8010499c:	83 ec 08             	sub    $0x8,%esp
8010499f:	8d 45 c0             	lea    -0x40(%ebp),%eax
801049a2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801049a5:	50                   	push   %eax
801049a6:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801049a9:	8b 40 0c             	mov    0xc(%eax),%eax
801049ac:	83 c0 08             	add    $0x8,%eax
801049af:	50                   	push   %eax
801049b0:	e8 fb 01 00 00       	call   80104bb0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801049b5:	83 c4 10             	add    $0x10,%esp
801049b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bf:	90                   	nop
801049c0:	8b 17                	mov    (%edi),%edx
801049c2:	85 d2                	test   %edx,%edx
801049c4:	0f 84 76 ff ff ff    	je     80104940 <procdump+0x20>
        cprintf(" %p", pc[i]);
801049ca:	83 ec 08             	sub    $0x8,%esp
801049cd:	83 c7 04             	add    $0x4,%edi
801049d0:	52                   	push   %edx
801049d1:	68 e1 7e 10 80       	push   $0x80107ee1
801049d6:	e8 d5 bc ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801049db:	83 c4 10             	add    $0x10,%esp
801049de:	39 fe                	cmp    %edi,%esi
801049e0:	75 de                	jne    801049c0 <procdump+0xa0>
801049e2:	e9 59 ff ff ff       	jmp    80104940 <procdump+0x20>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax
  }
}
801049f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049f3:	5b                   	pop    %ebx
801049f4:	5e                   	pop    %esi
801049f5:	5f                   	pop    %edi
801049f6:	5d                   	pop    %ebp
801049f7:	c3                   	ret    
801049f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop

80104a00 <find_digital_root>:

int find_digital_root(int num)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
80104a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104a0c:	83 fb 09             	cmp    $0x9,%ebx
80104a0f:	7e 32                	jle    80104a43 <find_digital_root+0x43>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
80104a11:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
{
80104a20:	89 d9                	mov    %ebx,%ecx
    int res = 0;
80104a22:	31 db                	xor    %ebx,%ebx
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104a28:	89 c8                	mov    %ecx,%eax
80104a2a:	f7 e6                	mul    %esi
80104a2c:	c1 ea 03             	shr    $0x3,%edx
80104a2f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104a32:	01 c0                	add    %eax,%eax
80104a34:	29 c1                	sub    %eax,%ecx
      res += current_dig;
80104a36:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104a38:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104a3a:	85 d2                	test   %edx,%edx
80104a3c:	75 ea                	jne    80104a28 <find_digital_root+0x28>
  while (num >= 10)
80104a3e:	83 fb 09             	cmp    $0x9,%ebx
80104a41:	7f dd                	jg     80104a20 <find_digital_root+0x20>
    }
    num = res;
  }
  return num;
80104a43:	89 d8                	mov    %ebx,%eax
80104a45:	5b                   	pop    %ebx
80104a46:	5e                   	pop    %esi
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	66 90                	xchg   %ax,%ax
80104a4b:	66 90                	xchg   %ax,%ax
80104a4d:	66 90                	xchg   %ax,%ax
80104a4f:	90                   	nop

80104a50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	53                   	push   %ebx
80104a58:	83 ec 0c             	sub    $0xc,%esp
80104a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a5e:	68 d8 85 10 80       	push   $0x801085d8
80104a63:	8d 43 04             	lea    0x4(%ebx),%eax
80104a66:	50                   	push   %eax
80104a67:	e8 24 01 00 00       	call   80104b90 <initlock>
  lk->name = name;
80104a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a75:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a78:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a7f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a85:	c9                   	leave  
80104a86:	c3                   	ret    
80104a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	56                   	push   %esi
80104a98:	53                   	push   %ebx
80104a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a9c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a9f:	83 ec 0c             	sub    $0xc,%esp
80104aa2:	56                   	push   %esi
80104aa3:	e8 68 02 00 00       	call   80104d10 <acquire>
  while (lk->locked) {
80104aa8:	8b 13                	mov    (%ebx),%edx
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	85 d2                	test   %edx,%edx
80104aaf:	74 1a                	je     80104acb <acquiresleep+0x3b>
80104ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104ab8:	83 ec 08             	sub    $0x8,%esp
80104abb:	56                   	push   %esi
80104abc:	53                   	push   %ebx
80104abd:	e8 9e fb ff ff       	call   80104660 <sleep>
  while (lk->locked) {
80104ac2:	8b 03                	mov    (%ebx),%eax
80104ac4:	83 c4 10             	add    $0x10,%esp
80104ac7:	85 c0                	test   %eax,%eax
80104ac9:	75 ed                	jne    80104ab8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104acb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ad1:	e8 da ef ff ff       	call   80103ab0 <myproc>
80104ad6:	8b 40 10             	mov    0x10(%eax),%eax
80104ad9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104adc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae2:	5b                   	pop    %ebx
80104ae3:	5e                   	pop    %esi
80104ae4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ae5:	e9 e6 02 00 00       	jmp    80104dd0 <release>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	56                   	push   %esi
80104af8:	53                   	push   %ebx
80104af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104afc:	8d 73 04             	lea    0x4(%ebx),%esi
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	56                   	push   %esi
80104b03:	e8 08 02 00 00       	call   80104d10 <acquire>
  lk->locked = 0;
80104b08:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b0e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b15:	89 1c 24             	mov    %ebx,(%esp)
80104b18:	e8 03 fd ff ff       	call   80104820 <wakeup>
  release(&lk->lk);
80104b1d:	89 75 08             	mov    %esi,0x8(%ebp)
80104b20:	83 c4 10             	add    $0x10,%esp
}
80104b23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b26:	5b                   	pop    %ebx
80104b27:	5e                   	pop    %esi
80104b28:	5d                   	pop    %ebp
  release(&lk->lk);
80104b29:	e9 a2 02 00 00       	jmp    80104dd0 <release>
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	57                   	push   %edi
80104b38:	31 ff                	xor    %edi,%edi
80104b3a:	56                   	push   %esi
80104b3b:	53                   	push   %ebx
80104b3c:	83 ec 18             	sub    $0x18,%esp
80104b3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b42:	8d 73 04             	lea    0x4(%ebx),%esi
80104b45:	56                   	push   %esi
80104b46:	e8 c5 01 00 00       	call   80104d10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b4b:	8b 03                	mov    (%ebx),%eax
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	85 c0                	test   %eax,%eax
80104b52:	75 1c                	jne    80104b70 <holdingsleep+0x40>
  release(&lk->lk);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	56                   	push   %esi
80104b58:	e8 73 02 00 00       	call   80104dd0 <release>
  return r;
}
80104b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b60:	89 f8                	mov    %edi,%eax
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5f                   	pop    %edi
80104b65:	5d                   	pop    %ebp
80104b66:	c3                   	ret    
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104b70:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b73:	e8 38 ef ff ff       	call   80103ab0 <myproc>
80104b78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b7b:	0f 94 c0             	sete   %al
80104b7e:	0f b6 c0             	movzbl %al,%eax
80104b81:	89 c7                	mov    %eax,%edi
80104b83:	eb cf                	jmp    80104b54 <holdingsleep+0x24>
80104b85:	66 90                	xchg   %ax,%ax
80104b87:	66 90                	xchg   %ax,%ax
80104b89:	66 90                	xchg   %ax,%ax
80104b8b:	66 90                	xchg   %ax,%ax
80104b8d:	66 90                	xchg   %ax,%ax
80104b8f:	90                   	nop

80104b90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ba3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ba6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bad:	5d                   	pop    %ebp
80104bae:	c3                   	ret    
80104baf:	90                   	nop

80104bb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bb5:	31 d2                	xor    %edx,%edx
{
80104bb7:	89 e5                	mov    %esp,%ebp
80104bb9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104bba:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bc0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bd4:	77 1a                	ja     80104bf0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bd6:	8b 58 04             	mov    0x4(%eax),%ebx
80104bd9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bdc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bdf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104be1:	83 fa 0a             	cmp    $0xa,%edx
80104be4:	75 e2                	jne    80104bc8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104be6:	5b                   	pop    %ebx
80104be7:	5d                   	pop    %ebp
80104be8:	c3                   	ret    
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104bf0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104bf3:	8d 51 28             	lea    0x28(%ecx),%edx
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c06:	83 c0 04             	add    $0x4,%eax
80104c09:	39 d0                	cmp    %edx,%eax
80104c0b:	75 f3                	jne    80104c00 <getcallerpcs+0x50>
}
80104c0d:	5b                   	pop    %ebx
80104c0e:	5d                   	pop    %ebp
80104c0f:	c3                   	ret    

80104c10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	53                   	push   %ebx
80104c18:	83 ec 04             	sub    $0x4,%esp
80104c1b:	9c                   	pushf  
80104c1c:	5b                   	pop    %ebx
  asm volatile("cli");
80104c1d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c1e:	e8 ed ec ff ff       	call   80103910 <mycpu>
80104c23:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	74 13                	je     80104c40 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c2d:	e8 de ec ff ff       	call   80103910 <mycpu>
80104c32:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c39:	83 c4 04             	add    $0x4,%esp
80104c3c:	5b                   	pop    %ebx
80104c3d:	5d                   	pop    %ebp
80104c3e:	c3                   	ret    
80104c3f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104c40:	e8 cb ec ff ff       	call   80103910 <mycpu>
80104c45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c51:	eb da                	jmp    80104c2d <pushcli+0x1d>
80104c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <popcli>:

void
popcli(void)
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
80104c65:	89 e5                	mov    %esp,%ebp
80104c67:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c6a:	9c                   	pushf  
80104c6b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c6c:	f6 c4 02             	test   $0x2,%ah
80104c6f:	75 31                	jne    80104ca2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c71:	e8 9a ec ff ff       	call   80103910 <mycpu>
80104c76:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c7d:	78 30                	js     80104caf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c7f:	e8 8c ec ff ff       	call   80103910 <mycpu>
80104c84:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c8a:	85 d2                	test   %edx,%edx
80104c8c:	74 02                	je     80104c90 <popcli+0x30>
    sti();
}
80104c8e:	c9                   	leave  
80104c8f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c90:	e8 7b ec ff ff       	call   80103910 <mycpu>
80104c95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c9b:	85 c0                	test   %eax,%eax
80104c9d:	74 ef                	je     80104c8e <popcli+0x2e>
  asm volatile("sti");
80104c9f:	fb                   	sti    
}
80104ca0:	c9                   	leave  
80104ca1:	c3                   	ret    
    panic("popcli - interruptible");
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	68 e3 85 10 80       	push   $0x801085e3
80104caa:	e8 e1 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104caf:	83 ec 0c             	sub    $0xc,%esp
80104cb2:	68 fa 85 10 80       	push   $0x801085fa
80104cb7:	e8 d4 b6 ff ff       	call   80100390 <panic>
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <holding>:
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	56                   	push   %esi
80104cc8:	53                   	push   %ebx
80104cc9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ccc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cce:	e8 3d ff ff ff       	call   80104c10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cd3:	8b 06                	mov    (%esi),%eax
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	75 0f                	jne    80104ce8 <holding+0x28>
  popcli();
80104cd9:	e8 82 ff ff ff       	call   80104c60 <popcli>
}
80104cde:	89 d8                	mov    %ebx,%eax
80104ce0:	5b                   	pop    %ebx
80104ce1:	5e                   	pop    %esi
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ce8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ceb:	e8 20 ec ff ff       	call   80103910 <mycpu>
80104cf0:	39 c3                	cmp    %eax,%ebx
80104cf2:	0f 94 c3             	sete   %bl
  popcli();
80104cf5:	e8 66 ff ff ff       	call   80104c60 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104cfa:	0f b6 db             	movzbl %bl,%ebx
}
80104cfd:	89 d8                	mov    %ebx,%eax
80104cff:	5b                   	pop    %ebx
80104d00:	5e                   	pop    %esi
80104d01:	5d                   	pop    %ebp
80104d02:	c3                   	ret    
80104d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <acquire>:
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d19:	e8 f2 fe ff ff       	call   80104c10 <pushcli>
  if(holding(lk))
80104d1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d21:	83 ec 0c             	sub    $0xc,%esp
80104d24:	53                   	push   %ebx
80104d25:	e8 96 ff ff ff       	call   80104cc0 <holding>
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	0f 85 7f 00 00 00    	jne    80104db4 <acquire+0xa4>
80104d35:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104d37:	ba 01 00 00 00       	mov    $0x1,%edx
80104d3c:	eb 05                	jmp    80104d43 <acquire+0x33>
80104d3e:	66 90                	xchg   %ax,%ax
80104d40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d43:	89 d0                	mov    %edx,%eax
80104d45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104d48:	85 c0                	test   %eax,%eax
80104d4a:	75 f4                	jne    80104d40 <acquire+0x30>
  __sync_synchronize();
80104d4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d54:	e8 b7 eb ff ff       	call   80103910 <mycpu>
80104d59:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104d5c:	89 e8                	mov    %ebp,%eax
80104d5e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d60:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104d66:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104d6c:	77 22                	ja     80104d90 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104d6e:	8b 50 04             	mov    0x4(%eax),%edx
80104d71:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104d75:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d78:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d7a:	83 fe 0a             	cmp    $0xa,%esi
80104d7d:	75 e1                	jne    80104d60 <acquire+0x50>
}
80104d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d90:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d94:	83 c3 34             	add    $0x34,%ebx
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104da6:	83 c0 04             	add    $0x4,%eax
80104da9:	39 d8                	cmp    %ebx,%eax
80104dab:	75 f3                	jne    80104da0 <acquire+0x90>
}
80104dad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db0:	5b                   	pop    %ebx
80104db1:	5e                   	pop    %esi
80104db2:	5d                   	pop    %ebp
80104db3:	c3                   	ret    
    panic("acquire");
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	68 01 86 10 80       	push   $0x80108601
80104dbc:	e8 cf b5 ff ff       	call   80100390 <panic>
80104dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop

80104dd0 <release>:
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	53                   	push   %ebx
80104dd8:	83 ec 10             	sub    $0x10,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104dde:	53                   	push   %ebx
80104ddf:	e8 dc fe ff ff       	call   80104cc0 <holding>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	85 c0                	test   %eax,%eax
80104de9:	74 22                	je     80104e0d <release+0x3d>
  lk->pcs[0] = 0;
80104deb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104df2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104df9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dfe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e07:	c9                   	leave  
  popcli();
80104e08:	e9 53 fe ff ff       	jmp    80104c60 <popcli>
    panic("release");
80104e0d:	83 ec 0c             	sub    $0xc,%esp
80104e10:	68 09 86 10 80       	push   $0x80108609
80104e15:	e8 76 b5 ff ff       	call   80100390 <panic>
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	57                   	push   %edi
80104e28:	8b 55 08             	mov    0x8(%ebp),%edx
80104e2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e2e:	53                   	push   %ebx
80104e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e32:	89 d7                	mov    %edx,%edi
80104e34:	09 cf                	or     %ecx,%edi
80104e36:	83 e7 03             	and    $0x3,%edi
80104e39:	75 25                	jne    80104e60 <memset+0x40>
    c &= 0xFF;
80104e3b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e3e:	c1 e0 18             	shl    $0x18,%eax
80104e41:	89 fb                	mov    %edi,%ebx
80104e43:	c1 e9 02             	shr    $0x2,%ecx
80104e46:	c1 e3 10             	shl    $0x10,%ebx
80104e49:	09 d8                	or     %ebx,%eax
80104e4b:	09 f8                	or     %edi,%eax
80104e4d:	c1 e7 08             	shl    $0x8,%edi
80104e50:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e52:	89 d7                	mov    %edx,%edi
80104e54:	fc                   	cld    
80104e55:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e57:	5b                   	pop    %ebx
80104e58:	89 d0                	mov    %edx,%eax
80104e5a:	5f                   	pop    %edi
80104e5b:	5d                   	pop    %ebp
80104e5c:	c3                   	ret    
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
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
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	56                   	push   %esi
80104e78:	8b 75 10             	mov    0x10(%ebp),%esi
80104e7b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e7e:	53                   	push   %ebx
80104e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e82:	85 f6                	test   %esi,%esi
80104e84:	74 2a                	je     80104eb0 <memcmp+0x40>
80104e86:	01 c6                	add    %eax,%esi
80104e88:	eb 10                	jmp    80104e9a <memcmp+0x2a>
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
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
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
80104ec5:	89 e5                	mov    %esp,%ebp
80104ec7:	57                   	push   %edi
80104ec8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ecb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ece:	56                   	push   %esi
80104ecf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ed2:	39 d6                	cmp    %edx,%esi
80104ed4:	73 2a                	jae    80104f00 <memmove+0x40>
80104ed6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ed9:	39 fa                	cmp    %edi,%edx
80104edb:	73 23                	jae    80104f00 <memmove+0x40>
80104edd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104ee0:	85 c9                	test   %ecx,%ecx
80104ee2:	74 13                	je     80104ef7 <memmove+0x37>
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104ee8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104eec:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104eef:	83 e8 01             	sub    $0x1,%eax
80104ef2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ef5:	75 f1                	jne    80104ee8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ef7:	5e                   	pop    %esi
80104ef8:	89 d0                	mov    %edx,%eax
80104efa:	5f                   	pop    %edi
80104efb:	5d                   	pop    %ebp
80104efc:	c3                   	ret    
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f00:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f03:	89 d7                	mov    %edx,%edi
80104f05:	85 c9                	test   %ecx,%ecx
80104f07:	74 ee                	je     80104ef7 <memmove+0x37>
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f10:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f11:	39 f0                	cmp    %esi,%eax
80104f13:	75 fb                	jne    80104f10 <memmove+0x50>
}
80104f15:	5e                   	pop    %esi
80104f16:	89 d0                	mov    %edx,%eax
80104f18:	5f                   	pop    %edi
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop

80104f20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f20:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104f24:	eb 9a                	jmp    80104ec0 <memmove>
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi

80104f30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	56                   	push   %esi
80104f38:	8b 75 10             	mov    0x10(%ebp),%esi
80104f3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f3e:	53                   	push   %ebx
80104f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104f42:	85 f6                	test   %esi,%esi
80104f44:	74 32                	je     80104f78 <strncmp+0x48>
80104f46:	01 c6                	add    %eax,%esi
80104f48:	eb 14                	jmp    80104f5e <strncmp+0x2e>
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f50:	38 da                	cmp    %bl,%dl
80104f52:	75 14                	jne    80104f68 <strncmp+0x38>
    n--, p++, q++;
80104f54:	83 c0 01             	add    $0x1,%eax
80104f57:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f5a:	39 f0                	cmp    %esi,%eax
80104f5c:	74 1a                	je     80104f78 <strncmp+0x48>
80104f5e:	0f b6 11             	movzbl (%ecx),%edx
80104f61:	0f b6 18             	movzbl (%eax),%ebx
80104f64:	84 d2                	test   %dl,%dl
80104f66:	75 e8                	jne    80104f50 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f68:	0f b6 c2             	movzbl %dl,%eax
80104f6b:	29 d8                	sub    %ebx,%eax
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5d                   	pop    %ebp
80104f70:	c3                   	ret    
80104f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f78:	5b                   	pop    %ebx
    return 0;
80104f79:	31 c0                	xor    %eax,%eax
}
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	57                   	push   %edi
80104f88:	56                   	push   %esi
80104f89:	8b 75 08             	mov    0x8(%ebp),%esi
80104f8c:	53                   	push   %ebx
80104f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f90:	89 f2                	mov    %esi,%edx
80104f92:	eb 1b                	jmp    80104faf <strncpy+0x2f>
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f98:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f9f:	83 c2 01             	add    $0x1,%edx
80104fa2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104fa6:	89 f9                	mov    %edi,%ecx
80104fa8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104fab:	84 c9                	test   %cl,%cl
80104fad:	74 09                	je     80104fb8 <strncpy+0x38>
80104faf:	89 c3                	mov    %eax,%ebx
80104fb1:	83 e8 01             	sub    $0x1,%eax
80104fb4:	85 db                	test   %ebx,%ebx
80104fb6:	7f e0                	jg     80104f98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104fb8:	89 d1                	mov    %edx,%ecx
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	7e 15                	jle    80104fd3 <strncpy+0x53>
80104fbe:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104fc0:	83 c1 01             	add    $0x1,%ecx
80104fc3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104fc7:	89 c8                	mov    %ecx,%eax
80104fc9:	f7 d0                	not    %eax
80104fcb:	01 d0                	add    %edx,%eax
80104fcd:	01 d8                	add    %ebx,%eax
80104fcf:	85 c0                	test   %eax,%eax
80104fd1:	7f ed                	jg     80104fc0 <strncpy+0x40>
  return os;
}
80104fd3:	5b                   	pop    %ebx
80104fd4:	89 f0                	mov    %esi,%eax
80104fd6:	5e                   	pop    %esi
80104fd7:	5f                   	pop    %edi
80104fd8:	5d                   	pop    %ebp
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fe0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	56                   	push   %esi
80104fe8:	8b 55 10             	mov    0x10(%ebp),%edx
80104feb:	8b 75 08             	mov    0x8(%ebp),%esi
80104fee:	53                   	push   %ebx
80104fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ff2:	85 d2                	test   %edx,%edx
80104ff4:	7e 21                	jle    80105017 <safestrcpy+0x37>
80104ff6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ffa:	89 f2                	mov    %esi,%edx
80104ffc:	eb 12                	jmp    80105010 <safestrcpy+0x30>
80104ffe:	66 90                	xchg   %ax,%ax
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
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105025:	31 c0                	xor    %eax,%eax
{
80105027:	89 e5                	mov    %esp,%ebp
80105029:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010502c:	80 3a 00             	cmpb   $0x0,(%edx)
8010502f:	74 10                	je     80105041 <strlen+0x21>
80105031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105038:	83 c0 01             	add    $0x1,%eax
8010503b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010503f:	75 f7                	jne    80105038 <strlen+0x18>
    ;
  return n;
}
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret    

80105043 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105043:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105047:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010504b:	55                   	push   %ebp
  pushl %ebx
8010504c:	53                   	push   %ebx
  pushl %esi
8010504d:	56                   	push   %esi
  pushl %edi
8010504e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010504f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105051:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105053:	5f                   	pop    %edi
  popl %esi
80105054:	5e                   	pop    %esi
  popl %ebx
80105055:	5b                   	pop    %ebx
  popl %ebp
80105056:	5d                   	pop    %ebp
  ret
80105057:	c3                   	ret    
80105058:	66 90                	xchg   %ax,%ax
8010505a:	66 90                	xchg   %ax,%ax
8010505c:	66 90                	xchg   %ax,%ax
8010505e:	66 90                	xchg   %ax,%ax

80105060 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	53                   	push   %ebx
80105068:	83 ec 04             	sub    $0x4,%esp
8010506b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010506e:	e8 3d ea ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105073:	8b 00                	mov    (%eax),%eax
80105075:	39 d8                	cmp    %ebx,%eax
80105077:	76 17                	jbe    80105090 <fetchint+0x30>
80105079:	8d 53 04             	lea    0x4(%ebx),%edx
8010507c:	39 d0                	cmp    %edx,%eax
8010507e:	72 10                	jb     80105090 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105080:	8b 45 0c             	mov    0xc(%ebp),%eax
80105083:	8b 13                	mov    (%ebx),%edx
80105085:	89 10                	mov    %edx,(%eax)
  return 0;
80105087:	31 c0                	xor    %eax,%eax
}
80105089:	83 c4 04             	add    $0x4,%esp
8010508c:	5b                   	pop    %ebx
8010508d:	5d                   	pop    %ebp
8010508e:	c3                   	ret    
8010508f:	90                   	nop
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105095:	eb f2                	jmp    80105089 <fetchint+0x29>
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax

801050a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	53                   	push   %ebx
801050a8:	83 ec 04             	sub    $0x4,%esp
801050ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801050ae:	e8 fd e9 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
801050b3:	39 18                	cmp    %ebx,(%eax)
801050b5:	76 31                	jbe    801050e8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801050b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050be:	39 d3                	cmp    %edx,%ebx
801050c0:	73 26                	jae    801050e8 <fetchstr+0x48>
801050c2:	89 d8                	mov    %ebx,%eax
801050c4:	eb 11                	jmp    801050d7 <fetchstr+0x37>
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
801050d0:	83 c0 01             	add    $0x1,%eax
801050d3:	39 c2                	cmp    %eax,%edx
801050d5:	76 11                	jbe    801050e8 <fetchstr+0x48>
    if(*s == 0)
801050d7:	80 38 00             	cmpb   $0x0,(%eax)
801050da:	75 f4                	jne    801050d0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801050dc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801050df:	29 d8                	sub    %ebx,%eax
}
801050e1:	5b                   	pop    %ebx
801050e2:	5d                   	pop    %ebp
801050e3:	c3                   	ret    
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e8:	83 c4 04             	add    $0x4,%esp
    return -1;
801050eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f0:	5b                   	pop    %ebx
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret    
801050f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105100 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	53                   	push   %ebx
80105108:	83 ec 04             	sub    $0x4,%esp
8010510b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010510e:	e8 9d e9 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105113:	8b 00                	mov    (%eax),%eax
80105115:	39 d8                	cmp    %ebx,%eax
80105117:	76 17                	jbe    80105130 <fetchfloat+0x30>
80105119:	8d 53 04             	lea    0x4(%ebx),%edx
8010511c:	39 d0                	cmp    %edx,%eax
8010511e:	72 10                	jb     80105130 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80105120:	d9 03                	flds   (%ebx)
80105122:	8b 45 0c             	mov    0xc(%ebp),%eax
80105125:	d9 18                	fstps  (%eax)
  return 0;
80105127:	31 c0                	xor    %eax,%eax
}
80105129:	83 c4 04             	add    $0x4,%esp
8010512c:	5b                   	pop    %ebx
8010512d:	5d                   	pop    %ebp
8010512e:	c3                   	ret    
8010512f:	90                   	nop
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb f2                	jmp    80105129 <fetchfloat+0x29>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	56                   	push   %esi
80105148:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105149:	e8 62 e9 ff ff       	call   80103ab0 <myproc>
8010514e:	8b 55 08             	mov    0x8(%ebp),%edx
80105151:	8b 40 18             	mov    0x18(%eax),%eax
80105154:	8b 40 44             	mov    0x44(%eax),%eax
80105157:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010515a:	e8 51 e9 ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010515f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105162:	8b 00                	mov    (%eax),%eax
80105164:	39 c6                	cmp    %eax,%esi
80105166:	73 18                	jae    80105180 <argint+0x40>
80105168:	8d 53 08             	lea    0x8(%ebx),%edx
8010516b:	39 d0                	cmp    %edx,%eax
8010516d:	72 11                	jb     80105180 <argint+0x40>
  *ip = *(int*)(addr);
8010516f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105172:	8b 53 04             	mov    0x4(%ebx),%edx
80105175:	89 10                	mov    %edx,(%eax)
  return 0;
80105177:	31 c0                	xor    %eax,%eax
}
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105185:	eb f2                	jmp    80105179 <argint+0x39>
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <argf>:
int
argf(int n, float *fp)
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	56                   	push   %esi
80105198:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105199:	e8 12 e9 ff ff       	call   80103ab0 <myproc>
8010519e:	8b 55 08             	mov    0x8(%ebp),%edx
801051a1:	8b 40 18             	mov    0x18(%eax),%eax
801051a4:	8b 40 44             	mov    0x44(%eax),%eax
801051a7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051aa:	e8 01 e9 ff ff       	call   80103ab0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801051af:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051b2:	8b 00                	mov    (%eax),%eax
801051b4:	39 c6                	cmp    %eax,%esi
801051b6:	73 18                	jae    801051d0 <argf+0x40>
801051b8:	8d 53 08             	lea    0x8(%ebx),%edx
801051bb:	39 d0                	cmp    %edx,%eax
801051bd:	72 11                	jb     801051d0 <argf+0x40>
  *fp = *(float*)(addr);
801051bf:	d9 43 04             	flds   0x4(%ebx)
801051c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c5:	d9 18                	fstps  (%eax)
  return 0;
801051c7:	31 c0                	xor    %eax,%eax
}
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801051d5:	eb f2                	jmp    801051c9 <argf+0x39>
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	56                   	push   %esi
801051e8:	53                   	push   %ebx
801051e9:	83 ec 10             	sub    $0x10,%esp
801051ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051ef:	e8 bc e8 ff ff       	call   80103ab0 <myproc>
 
  if(argint(n, &i) < 0)
801051f4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051f7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	50                   	push   %eax
801051fd:	ff 75 08             	pushl  0x8(%ebp)
80105200:	e8 3b ff ff ff       	call   80105140 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	85 c0                	test   %eax,%eax
8010520a:	78 24                	js     80105230 <argptr+0x50>
8010520c:	85 db                	test   %ebx,%ebx
8010520e:	78 20                	js     80105230 <argptr+0x50>
80105210:	8b 16                	mov    (%esi),%edx
80105212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105215:	39 c2                	cmp    %eax,%edx
80105217:	76 17                	jbe    80105230 <argptr+0x50>
80105219:	01 c3                	add    %eax,%ebx
8010521b:	39 da                	cmp    %ebx,%edx
8010521d:	72 11                	jb     80105230 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010521f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105222:	89 02                	mov    %eax,(%edx)
  return 0;
80105224:	31 c0                	xor    %eax,%eax
}
80105226:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105229:	5b                   	pop    %ebx
8010522a:	5e                   	pop    %esi
8010522b:	5d                   	pop    %ebp
8010522c:	c3                   	ret    
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105235:	eb ef                	jmp    80105226 <argptr+0x46>
80105237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523e:	66 90                	xchg   %ax,%ax

80105240 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010524a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524d:	50                   	push   %eax
8010524e:	ff 75 08             	pushl  0x8(%ebp)
80105251:	e8 ea fe ff ff       	call   80105140 <argint>
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	85 c0                	test   %eax,%eax
8010525b:	78 13                	js     80105270 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010525d:	83 ec 08             	sub    $0x8,%esp
80105260:	ff 75 0c             	pushl  0xc(%ebp)
80105263:	ff 75 f4             	pushl  -0xc(%ebp)
80105266:	e8 35 fe ff ff       	call   801050a0 <fetchstr>
8010526b:	83 c4 10             	add    $0x10,%esp
}
8010526e:	c9                   	leave  
8010526f:	c3                   	ret    
80105270:	c9                   	leave  
    return -1;
80105271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105276:	c3                   	ret    
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <syscall>:
[SYS_print_info] sys_print_info
};

void
syscall(void)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010528b:	e8 20 e8 ff ff       	call   80103ab0 <myproc>
80105290:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105292:	8b 40 18             	mov    0x18(%eax),%eax
80105295:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105298:	8d 50 ff             	lea    -0x1(%eax),%edx
8010529b:	83 fa 1f             	cmp    $0x1f,%edx
8010529e:	77 20                	ja     801052c0 <syscall+0x40>
801052a0:	8b 14 85 40 86 10 80 	mov    -0x7fef79c0(,%eax,4),%edx
801052a7:	85 d2                	test   %edx,%edx
801052a9:	74 15                	je     801052c0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052ab:	ff d2                	call   *%edx
801052ad:	89 c2                	mov    %eax,%edx
801052af:	8b 43 18             	mov    0x18(%ebx),%eax
801052b2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b8:	c9                   	leave  
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052c1:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052c4:	50                   	push   %eax
801052c5:	ff 73 10             	pushl  0x10(%ebx)
801052c8:	68 11 86 10 80       	push   $0x80108611
801052cd:	e8 de b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801052d2:	8b 43 18             	mov    0x18(%ebx),%eax
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e2:	c9                   	leave  
801052e3:	c3                   	ret    
801052e4:	66 90                	xchg   %ax,%ax
801052e6:	66 90                	xchg   %ax,%ax
801052e8:	66 90                	xchg   %ax,%ax
801052ea:	66 90                	xchg   %ax,%ax
801052ec:	66 90                	xchg   %ax,%ax
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801052f5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052f8:	53                   	push   %ebx
801052f9:	83 ec 34             	sub    $0x34,%esp
801052fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105302:	57                   	push   %edi
80105303:	50                   	push   %eax
{
80105304:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105307:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010530a:	e8 41 cd ff ff       	call   80102050 <nameiparent>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	0f 84 46 01 00 00    	je     80105460 <create+0x170>
    return 0;
  ilock(dp);
8010531a:	83 ec 0c             	sub    $0xc,%esp
8010531d:	89 c3                	mov    %eax,%ebx
8010531f:	50                   	push   %eax
80105320:	e8 3b c4 ff ff       	call   80101760 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105325:	83 c4 0c             	add    $0xc,%esp
80105328:	6a 00                	push   $0x0
8010532a:	57                   	push   %edi
8010532b:	53                   	push   %ebx
8010532c:	e8 7f c9 ff ff       	call   80101cb0 <dirlookup>
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	89 c6                	mov    %eax,%esi
80105336:	85 c0                	test   %eax,%eax
80105338:	74 56                	je     80105390 <create+0xa0>
  {
    iunlockput(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	53                   	push   %ebx
8010533e:	e8 bd c6 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105343:	89 34 24             	mov    %esi,(%esp)
80105346:	e8 15 c4 ff ff       	call   80101760 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010534b:	83 c4 10             	add    $0x10,%esp
8010534e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105353:	75 1b                	jne    80105370 <create+0x80>
80105355:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010535a:	75 14                	jne    80105370 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010535c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010535f:	89 f0                	mov    %esi,%eax
80105361:	5b                   	pop    %ebx
80105362:	5e                   	pop    %esi
80105363:	5f                   	pop    %edi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	56                   	push   %esi
    return 0;
80105374:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105376:	e8 85 c6 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010537b:	83 c4 10             	add    $0x10,%esp
}
8010537e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105381:	89 f0                	mov    %esi,%eax
80105383:	5b                   	pop    %ebx
80105384:	5e                   	pop    %esi
80105385:	5f                   	pop    %edi
80105386:	5d                   	pop    %ebp
80105387:	c3                   	ret    
80105388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105390:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105394:	83 ec 08             	sub    $0x8,%esp
80105397:	50                   	push   %eax
80105398:	ff 33                	pushl  (%ebx)
8010539a:	e8 41 c2 ff ff       	call   801015e0 <ialloc>
8010539f:	83 c4 10             	add    $0x10,%esp
801053a2:	89 c6                	mov    %eax,%esi
801053a4:	85 c0                	test   %eax,%eax
801053a6:	0f 84 cd 00 00 00    	je     80105479 <create+0x189>
  ilock(ip);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	50                   	push   %eax
801053b0:	e8 ab c3 ff ff       	call   80101760 <ilock>
  ip->major = major;
801053b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053c5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ce:	89 34 24             	mov    %esi,(%esp)
801053d1:	e8 ca c2 ff ff       	call   801016a0 <iupdate>
  if (type == T_DIR)
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053de:	74 30                	je     80105410 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
801053e0:	83 ec 04             	sub    $0x4,%esp
801053e3:	ff 76 04             	pushl  0x4(%esi)
801053e6:	57                   	push   %edi
801053e7:	53                   	push   %ebx
801053e8:	e8 83 cb ff ff       	call   80101f70 <dirlink>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 78                	js     8010546c <create+0x17c>
  iunlockput(dp);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	53                   	push   %ebx
801053f8:	e8 03 c6 ff ff       	call   80101a00 <iunlockput>
  return ip;
801053fd:	83 c4 10             	add    $0x10,%esp
}
80105400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105403:	89 f0                	mov    %esi,%eax
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5f                   	pop    %edi
80105408:	5d                   	pop    %ebp
80105409:	c3                   	ret    
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105410:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105413:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105418:	53                   	push   %ebx
80105419:	e8 82 c2 ff ff       	call   801016a0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010541e:	83 c4 0c             	add    $0xc,%esp
80105421:	ff 76 04             	pushl  0x4(%esi)
80105424:	68 e0 86 10 80       	push   $0x801086e0
80105429:	56                   	push   %esi
8010542a:	e8 41 cb ff ff       	call   80101f70 <dirlink>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	78 18                	js     8010544e <create+0x15e>
80105436:	83 ec 04             	sub    $0x4,%esp
80105439:	ff 73 04             	pushl  0x4(%ebx)
8010543c:	68 df 86 10 80       	push   $0x801086df
80105441:	56                   	push   %esi
80105442:	e8 29 cb ff ff       	call   80101f70 <dirlink>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	85 c0                	test   %eax,%eax
8010544c:	79 92                	jns    801053e0 <create+0xf0>
      panic("create dots");
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	68 d3 86 10 80       	push   $0x801086d3
80105456:	e8 35 af ff ff       	call   80100390 <panic>
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
}
80105460:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105463:	31 f6                	xor    %esi,%esi
}
80105465:	5b                   	pop    %ebx
80105466:	89 f0                	mov    %esi,%eax
80105468:	5e                   	pop    %esi
80105469:	5f                   	pop    %edi
8010546a:	5d                   	pop    %ebp
8010546b:	c3                   	ret    
    panic("create: dirlink");
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	68 e2 86 10 80       	push   $0x801086e2
80105474:	e8 17 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	68 c4 86 10 80       	push   $0x801086c4
80105481:	e8 0a af ff ff       	call   80100390 <panic>
80105486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548d:	8d 76 00             	lea    0x0(%esi),%esi

80105490 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	89 d6                	mov    %edx,%esi
80105496:	53                   	push   %ebx
80105497:	89 c3                	mov    %eax,%ebx
  if (argint(n, &fd) < 0)
80105499:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010549c:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010549f:	50                   	push   %eax
801054a0:	6a 00                	push   $0x0
801054a2:	e8 99 fc ff ff       	call   80105140 <argint>
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 2a                	js     801054d8 <argfd.constprop.0+0x48>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801054ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054b2:	77 24                	ja     801054d8 <argfd.constprop.0+0x48>
801054b4:	e8 f7 e5 ff ff       	call   80103ab0 <myproc>
801054b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054bc:	8b 44 90 34          	mov    0x34(%eax,%edx,4),%eax
801054c0:	85 c0                	test   %eax,%eax
801054c2:	74 14                	je     801054d8 <argfd.constprop.0+0x48>
  if (pfd)
801054c4:	85 db                	test   %ebx,%ebx
801054c6:	74 02                	je     801054ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801054c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801054ca:	89 06                	mov    %eax,(%esi)
  return 0;
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d1:	5b                   	pop    %ebx
801054d2:	5e                   	pop    %esi
801054d3:	5d                   	pop    %ebp
801054d4:	c3                   	ret    
801054d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ef                	jmp    801054ce <argfd.constprop.0+0x3e>
801054df:	90                   	nop

801054e0 <sys_dup>:
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0)
801054e5:	31 c0                	xor    %eax,%eax
{
801054e7:	89 e5                	mov    %esp,%ebp
801054e9:	56                   	push   %esi
801054ea:	53                   	push   %ebx
  if (argfd(0, 0, &f) < 0)
801054eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054ee:	83 ec 10             	sub    $0x10,%esp
  if (argfd(0, 0, &f) < 0)
801054f1:	e8 9a ff ff ff       	call   80105490 <argfd.constprop.0>
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 1e                	js     80105518 <sys_dup+0x38>
  if ((fd = fdalloc(f)) < 0)
801054fa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for (fd = 0; fd < NOFILE; fd++)
801054fd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ff:	e8 ac e5 ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105508:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
8010550c:	85 d2                	test   %edx,%edx
8010550e:	74 20                	je     80105530 <sys_dup+0x50>
  for (fd = 0; fd < NOFILE; fd++)
80105510:	83 c3 01             	add    $0x1,%ebx
80105513:	83 fb 10             	cmp    $0x10,%ebx
80105516:	75 f0                	jne    80105508 <sys_dup+0x28>
}
80105518:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010551b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105520:	89 d8                	mov    %ebx,%eax
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105530:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	ff 75 f4             	pushl  -0xc(%ebp)
8010553a:	e8 31 b9 ff ff       	call   80100e70 <filedup>
  return fd;
8010553f:	83 c4 10             	add    $0x10,%esp
}
80105542:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105545:	89 d8                	mov    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5e                   	pop    %esi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <sys_read>:
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105555:	31 c0                	xor    %eax,%eax
{
80105557:	89 e5                	mov    %esp,%ebp
80105559:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010555c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010555f:	e8 2c ff ff ff       	call   80105490 <argfd.constprop.0>
80105564:	85 c0                	test   %eax,%eax
80105566:	78 48                	js     801055b0 <sys_read+0x60>
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 02                	push   $0x2
80105571:	e8 ca fb ff ff       	call   80105140 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 33                	js     801055b0 <sys_read+0x60>
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105583:	ff 75 f0             	pushl  -0x10(%ebp)
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 52 fc ff ff       	call   801051e0 <argptr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 1b                	js     801055b0 <sys_read+0x60>
  return fileread(f, p, n);
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	pushl  -0x10(%ebp)
8010559b:	ff 75 f4             	pushl  -0xc(%ebp)
8010559e:	ff 75 ec             	pushl  -0x14(%ebp)
801055a1:	e8 4a ba ff ff       	call   80100ff0 <fileread>
801055a6:	83 c4 10             	add    $0x10,%esp
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
801055b0:	c9                   	leave  
    return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c3                   	ret    
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <sys_write>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c5:	31 c0                	xor    %eax,%eax
{
801055c7:	89 e5                	mov    %esp,%ebp
801055c9:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055cf:	e8 bc fe ff ff       	call   80105490 <argfd.constprop.0>
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 48                	js     80105620 <sys_write+0x60>
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 02                	push   $0x2
801055e1:	e8 5a fb ff ff       	call   80105140 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 33                	js     80105620 <sys_write+0x60>
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f3:	ff 75 f0             	pushl  -0x10(%ebp)
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 e2 fb ff ff       	call   801051e0 <argptr>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 1b                	js     80105620 <sys_write+0x60>
  return filewrite(f, p, n);
80105605:	83 ec 04             	sub    $0x4,%esp
80105608:	ff 75 f0             	pushl  -0x10(%ebp)
8010560b:	ff 75 f4             	pushl  -0xc(%ebp)
8010560e:	ff 75 ec             	pushl  -0x14(%ebp)
80105611:	e8 7a ba ff ff       	call   80101090 <filewrite>
80105616:	83 c4 10             	add    $0x10,%esp
}
80105619:	c9                   	leave  
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
80105620:	c9                   	leave  
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105626:	c3                   	ret    
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_close>:
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
8010563a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010563d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105640:	e8 4b fe ff ff       	call   80105490 <argfd.constprop.0>
80105645:	85 c0                	test   %eax,%eax
80105647:	78 27                	js     80105670 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105649:	e8 62 e4 ff ff       	call   80103ab0 <myproc>
8010564e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105651:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105654:	c7 44 90 34 00 00 00 	movl   $0x0,0x34(%eax,%edx,4)
8010565b:	00 
  fileclose(f);
8010565c:	ff 75 f4             	pushl  -0xc(%ebp)
8010565f:	e8 5c b8 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	31 c0                	xor    %eax,%eax
}
80105669:	c9                   	leave  
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
80105670:	c9                   	leave  
    return -1;
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105676:	c3                   	ret    
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_fstat>:
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105685:	31 c0                	xor    %eax,%eax
{
80105687:	89 e5                	mov    %esp,%ebp
80105689:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
8010568c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010568f:	e8 fc fd ff ff       	call   80105490 <argfd.constprop.0>
80105694:	85 c0                	test   %eax,%eax
80105696:	78 30                	js     801056c8 <sys_fstat+0x48>
80105698:	83 ec 04             	sub    $0x4,%esp
8010569b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569e:	6a 14                	push   $0x14
801056a0:	50                   	push   %eax
801056a1:	6a 01                	push   $0x1
801056a3:	e8 38 fb ff ff       	call   801051e0 <argptr>
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	85 c0                	test   %eax,%eax
801056ad:	78 19                	js     801056c8 <sys_fstat+0x48>
  return filestat(f, st);
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	ff 75 f4             	pushl  -0xc(%ebp)
801056b5:	ff 75 f0             	pushl  -0x10(%ebp)
801056b8:	e8 e3 b8 ff ff       	call   80100fa0 <filestat>
801056bd:	83 c4 10             	add    $0x10,%esp
}
801056c0:	c9                   	leave  
801056c1:	c3                   	ret    
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c8:	c9                   	leave  
    return -1;
801056c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_link>:
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
801056d8:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056dc:	53                   	push   %ebx
801056dd:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056e0:	50                   	push   %eax
801056e1:	6a 00                	push   $0x0
801056e3:	e8 58 fb ff ff       	call   80105240 <argstr>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	0f 88 ff 00 00 00    	js     801057f2 <sys_link+0x122>
801056f3:	83 ec 08             	sub    $0x8,%esp
801056f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 01                	push   $0x1
801056fc:	e8 3f fb ff ff       	call   80105240 <argstr>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	0f 88 e6 00 00 00    	js     801057f2 <sys_link+0x122>
  begin_op();
8010570c:	e8 1f d6 ff ff       	call   80102d30 <begin_op>
  if ((ip = namei(old)) == 0)
80105711:	83 ec 0c             	sub    $0xc,%esp
80105714:	ff 75 d4             	pushl  -0x2c(%ebp)
80105717:	e8 14 c9 ff ff       	call   80102030 <namei>
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	89 c3                	mov    %eax,%ebx
80105721:	85 c0                	test   %eax,%eax
80105723:	0f 84 e8 00 00 00    	je     80105811 <sys_link+0x141>
  ilock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	50                   	push   %eax
8010572d:	e8 2e c0 ff ff       	call   80101760 <ilock>
  if (ip->type == T_DIR)
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010573a:	0f 84 b9 00 00 00    	je     801057f9 <sys_link+0x129>
  iupdate(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105743:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105748:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010574b:	53                   	push   %ebx
8010574c:	e8 4f bf ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105751:	89 1c 24             	mov    %ebx,(%esp)
80105754:	e8 e7 c0 ff ff       	call   80101840 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105759:	58                   	pop    %eax
8010575a:	5a                   	pop    %edx
8010575b:	57                   	push   %edi
8010575c:	ff 75 d0             	pushl  -0x30(%ebp)
8010575f:	e8 ec c8 ff ff       	call   80102050 <nameiparent>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	89 c6                	mov    %eax,%esi
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 5f                	je     801057cc <sys_link+0xfc>
  ilock(dp);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 ea bf ff ff       	call   80101760 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105776:	8b 03                	mov    (%ebx),%eax
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	39 06                	cmp    %eax,(%esi)
8010577d:	75 41                	jne    801057c0 <sys_link+0xf0>
8010577f:	83 ec 04             	sub    $0x4,%esp
80105782:	ff 73 04             	pushl  0x4(%ebx)
80105785:	57                   	push   %edi
80105786:	56                   	push   %esi
80105787:	e8 e4 c7 ff ff       	call   80101f70 <dirlink>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	85 c0                	test   %eax,%eax
80105791:	78 2d                	js     801057c0 <sys_link+0xf0>
  iunlockput(dp);
80105793:	83 ec 0c             	sub    $0xc,%esp
80105796:	56                   	push   %esi
80105797:	e8 64 c2 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010579c:	89 1c 24             	mov    %ebx,(%esp)
8010579f:	e8 ec c0 ff ff       	call   80101890 <iput>
  end_op();
801057a4:	e8 f7 d5 ff ff       	call   80102da0 <end_op>
  return 0;
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	31 c0                	xor    %eax,%eax
}
801057ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b1:	5b                   	pop    %ebx
801057b2:	5e                   	pop    %esi
801057b3:	5f                   	pop    %edi
801057b4:	5d                   	pop    %ebp
801057b5:	c3                   	ret    
801057b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	56                   	push   %esi
801057c4:	e8 37 c2 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801057c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	53                   	push   %ebx
801057d0:	e8 8b bf ff ff       	call   80101760 <ilock>
  ip->nlink--;
801057d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057da:	89 1c 24             	mov    %ebx,(%esp)
801057dd:	e8 be be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801057e2:	89 1c 24             	mov    %ebx,(%esp)
801057e5:	e8 16 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
801057ea:	e8 b1 d5 ff ff       	call   80102da0 <end_op>
  return -1;
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f7:	eb b5                	jmp    801057ae <sys_link+0xde>
    iunlockput(ip);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	53                   	push   %ebx
801057fd:	e8 fe c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105802:	e8 99 d5 ff ff       	call   80102da0 <end_op>
    return -1;
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580f:	eb 9d                	jmp    801057ae <sys_link+0xde>
    end_op();
80105811:	e8 8a d5 ff ff       	call   80102da0 <end_op>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	eb 91                	jmp    801057ae <sys_link+0xde>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi

80105820 <sys_unlink>:
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	57                   	push   %edi
80105828:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105829:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010582c:	53                   	push   %ebx
8010582d:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105830:	50                   	push   %eax
80105831:	6a 00                	push   $0x0
80105833:	e8 08 fa ff ff       	call   80105240 <argstr>
80105838:	83 c4 10             	add    $0x10,%esp
8010583b:	85 c0                	test   %eax,%eax
8010583d:	0f 88 7d 01 00 00    	js     801059c0 <sys_unlink+0x1a0>
  begin_op();
80105843:	e8 e8 d4 ff ff       	call   80102d30 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105848:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	53                   	push   %ebx
8010584f:	ff 75 c0             	pushl  -0x40(%ebp)
80105852:	e8 f9 c7 ff ff       	call   80102050 <nameiparent>
80105857:	83 c4 10             	add    $0x10,%esp
8010585a:	89 c6                	mov    %eax,%esi
8010585c:	85 c0                	test   %eax,%eax
8010585e:	0f 84 66 01 00 00    	je     801059ca <sys_unlink+0x1aa>
  ilock(dp);
80105864:	83 ec 0c             	sub    $0xc,%esp
80105867:	50                   	push   %eax
80105868:	e8 f3 be ff ff       	call   80101760 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010586d:	58                   	pop    %eax
8010586e:	5a                   	pop    %edx
8010586f:	68 e0 86 10 80       	push   $0x801086e0
80105874:	53                   	push   %ebx
80105875:	e8 16 c4 ff ff       	call   80101c90 <namecmp>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	0f 84 03 01 00 00    	je     80105988 <sys_unlink+0x168>
80105885:	83 ec 08             	sub    $0x8,%esp
80105888:	68 df 86 10 80       	push   $0x801086df
8010588d:	53                   	push   %ebx
8010588e:	e8 fd c3 ff ff       	call   80101c90 <namecmp>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	0f 84 ea 00 00 00    	je     80105988 <sys_unlink+0x168>
  if ((ip = dirlookup(dp, name, &off)) == 0)
8010589e:	83 ec 04             	sub    $0x4,%esp
801058a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058a4:	50                   	push   %eax
801058a5:	53                   	push   %ebx
801058a6:	56                   	push   %esi
801058a7:	e8 04 c4 ff ff       	call   80101cb0 <dirlookup>
801058ac:	83 c4 10             	add    $0x10,%esp
801058af:	89 c3                	mov    %eax,%ebx
801058b1:	85 c0                	test   %eax,%eax
801058b3:	0f 84 cf 00 00 00    	je     80105988 <sys_unlink+0x168>
  ilock(ip);
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	50                   	push   %eax
801058bd:	e8 9e be ff ff       	call   80101760 <ilock>
  if (ip->nlink < 1)
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058ca:	0f 8e 23 01 00 00    	jle    801059f3 <sys_unlink+0x1d3>
  if (ip->type == T_DIR && !isdirempty(ip))
801058d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058d8:	74 66                	je     80105940 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058da:	83 ec 04             	sub    $0x4,%esp
801058dd:	6a 10                	push   $0x10
801058df:	6a 00                	push   $0x0
801058e1:	57                   	push   %edi
801058e2:	e8 39 f5 ff ff       	call   80104e20 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801058e7:	6a 10                	push   $0x10
801058e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058ec:	57                   	push   %edi
801058ed:	56                   	push   %esi
801058ee:	e8 6d c2 ff ff       	call   80101b60 <writei>
801058f3:	83 c4 20             	add    $0x20,%esp
801058f6:	83 f8 10             	cmp    $0x10,%eax
801058f9:	0f 85 e7 00 00 00    	jne    801059e6 <sys_unlink+0x1c6>
  if (ip->type == T_DIR)
801058ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105904:	0f 84 96 00 00 00    	je     801059a0 <sys_unlink+0x180>
  iunlockput(dp);
8010590a:	83 ec 0c             	sub    $0xc,%esp
8010590d:	56                   	push   %esi
8010590e:	e8 ed c0 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105913:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105918:	89 1c 24             	mov    %ebx,(%esp)
8010591b:	e8 80 bd ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105920:	89 1c 24             	mov    %ebx,(%esp)
80105923:	e8 d8 c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105928:	e8 73 d4 ff ff       	call   80102da0 <end_op>
  return 0;
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	31 c0                	xor    %eax,%eax
}
80105932:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105935:	5b                   	pop    %ebx
80105936:	5e                   	pop    %esi
80105937:	5f                   	pop    %edi
80105938:	5d                   	pop    %ebp
80105939:	c3                   	ret    
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105940:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105944:	76 94                	jbe    801058da <sys_unlink+0xba>
80105946:	ba 20 00 00 00       	mov    $0x20,%edx
8010594b:	eb 0b                	jmp    80105958 <sys_unlink+0x138>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
80105950:	83 c2 10             	add    $0x10,%edx
80105953:	39 53 58             	cmp    %edx,0x58(%ebx)
80105956:	76 82                	jbe    801058da <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105958:	6a 10                	push   $0x10
8010595a:	52                   	push   %edx
8010595b:	57                   	push   %edi
8010595c:	53                   	push   %ebx
8010595d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105960:	e8 fb c0 ff ff       	call   80101a60 <readi>
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010596b:	83 f8 10             	cmp    $0x10,%eax
8010596e:	75 69                	jne    801059d9 <sys_unlink+0x1b9>
    if (de.inum != 0)
80105970:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105975:	74 d9                	je     80105950 <sys_unlink+0x130>
    iunlockput(ip);
80105977:	83 ec 0c             	sub    $0xc,%esp
8010597a:	53                   	push   %ebx
8010597b:	e8 80 c0 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105987:	90                   	nop
  iunlockput(dp);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	56                   	push   %esi
8010598c:	e8 6f c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105991:	e8 0a d4 ff ff       	call   80102da0 <end_op>
  return -1;
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599e:	eb 92                	jmp    80105932 <sys_unlink+0x112>
    iupdate(dp);
801059a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059a8:	56                   	push   %esi
801059a9:	e8 f2 bc ff ff       	call   801016a0 <iupdate>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	e9 54 ff ff ff       	jmp    8010590a <sys_unlink+0xea>
801059b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c5:	e9 68 ff ff ff       	jmp    80105932 <sys_unlink+0x112>
    end_op();
801059ca:	e8 d1 d3 ff ff       	call   80102da0 <end_op>
    return -1;
801059cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d4:	e9 59 ff ff ff       	jmp    80105932 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	68 04 87 10 80       	push   $0x80108704
801059e1:	e8 aa a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059e6:	83 ec 0c             	sub    $0xc,%esp
801059e9:	68 16 87 10 80       	push   $0x80108716
801059ee:	e8 9d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059f3:	83 ec 0c             	sub    $0xc,%esp
801059f6:	68 f2 86 10 80       	push   $0x801086f2
801059fb:	e8 90 a9 ff ff       	call   80100390 <panic>

80105a00 <sys_open>:

int sys_open(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	57                   	push   %edi
80105a08:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a09:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a0c:	53                   	push   %ebx
80105a0d:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a10:	50                   	push   %eax
80105a11:	6a 00                	push   $0x0
80105a13:	e8 28 f8 ff ff       	call   80105240 <argstr>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	0f 88 8a 00 00 00    	js     80105aad <sys_open+0xad>
80105a23:	83 ec 08             	sub    $0x8,%esp
80105a26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 01                	push   $0x1
80105a2c:	e8 0f f7 ff ff       	call   80105140 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 75                	js     80105aad <sys_open+0xad>
    return -1;

  begin_op();
80105a38:	e8 f3 d2 ff ff       	call   80102d30 <begin_op>

  if (omode & O_CREATE)
80105a3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a41:	75 75                	jne    80105ab8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105a43:	83 ec 0c             	sub    $0xc,%esp
80105a46:	ff 75 e0             	pushl  -0x20(%ebp)
80105a49:	e8 e2 c5 ff ff       	call   80102030 <namei>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	89 c6                	mov    %eax,%esi
80105a53:	85 c0                	test   %eax,%eax
80105a55:	74 7e                	je     80105ad5 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105a57:	83 ec 0c             	sub    $0xc,%esp
80105a5a:	50                   	push   %eax
80105a5b:	e8 00 bd ff ff       	call   80101760 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105a60:	83 c4 10             	add    $0x10,%esp
80105a63:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a68:	0f 84 c2 00 00 00    	je     80105b30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105a6e:	e8 8d b3 ff ff       	call   80100e00 <filealloc>
80105a73:	89 c7                	mov    %eax,%edi
80105a75:	85 c0                	test   %eax,%eax
80105a77:	74 23                	je     80105a9c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a79:	e8 32 e0 ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105a7e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105a80:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105a84:	85 d2                	test   %edx,%edx
80105a86:	74 60                	je     80105ae8 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105a88:	83 c3 01             	add    $0x1,%ebx
80105a8b:	83 fb 10             	cmp    $0x10,%ebx
80105a8e:	75 f0                	jne    80105a80 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	57                   	push   %edi
80105a94:	e8 27 b4 ff ff       	call   80100ec0 <fileclose>
80105a99:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a9c:	83 ec 0c             	sub    $0xc,%esp
80105a9f:	56                   	push   %esi
80105aa0:	e8 5b bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105aa5:	e8 f6 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ab2:	eb 6d                	jmp    80105b21 <sys_open+0x121>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105abe:	31 c9                	xor    %ecx,%ecx
80105ac0:	ba 02 00 00 00       	mov    $0x2,%edx
80105ac5:	6a 00                	push   $0x0
80105ac7:	e8 24 f8 ff ff       	call   801052f0 <create>
    if (ip == 0)
80105acc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105acf:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105ad1:	85 c0                	test   %eax,%eax
80105ad3:	75 99                	jne    80105a6e <sys_open+0x6e>
      end_op();
80105ad5:	e8 c6 d2 ff ff       	call   80102da0 <end_op>
      return -1;
80105ada:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105adf:	eb 40                	jmp    80105b21 <sys_open+0x121>
80105ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105aeb:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
80105aef:	56                   	push   %esi
80105af0:	e8 4b bd ff ff       	call   80101840 <iunlock>
  end_op();
80105af5:	e8 a6 d2 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
80105afa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b03:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b06:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b09:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b12:	f7 d0                	not    %eax
80105b14:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b17:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b1a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b1d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	89 d8                	mov    %ebx,%eax
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105b30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b33:	85 c9                	test   %ecx,%ecx
80105b35:	0f 84 33 ff ff ff    	je     80105a6e <sys_open+0x6e>
80105b3b:	e9 5c ff ff ff       	jmp    80105a9c <sys_open+0x9c>

80105b40 <sys_mkdir>:

int sys_mkdir(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b4a:	e8 e1 d1 ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105b4f:	83 ec 08             	sub    $0x8,%esp
80105b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b55:	50                   	push   %eax
80105b56:	6a 00                	push   $0x0
80105b58:	e8 e3 f6 ff ff       	call   80105240 <argstr>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 34                	js     80105b98 <sys_mkdir+0x58>
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6a:	31 c9                	xor    %ecx,%ecx
80105b6c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b71:	6a 00                	push   $0x0
80105b73:	e8 78 f7 ff ff       	call   801052f0 <create>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	74 19                	je     80105b98 <sys_mkdir+0x58>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b7f:	83 ec 0c             	sub    $0xc,%esp
80105b82:	50                   	push   %eax
80105b83:	e8 78 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b88:	e8 13 d2 ff ff       	call   80102da0 <end_op>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b98:	e8 03 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba2:	c9                   	leave  
80105ba3:	c3                   	ret    
80105ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop

80105bb0 <sys_mknod>:

int sys_mknod(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bba:	e8 71 d1 ff ff       	call   80102d30 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105bbf:	83 ec 08             	sub    $0x8,%esp
80105bc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bc5:	50                   	push   %eax
80105bc6:	6a 00                	push   $0x0
80105bc8:	e8 73 f6 ff ff       	call   80105240 <argstr>
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	85 c0                	test   %eax,%eax
80105bd2:	78 64                	js     80105c38 <sys_mknod+0x88>
      argint(1, &major) < 0 ||
80105bd4:	83 ec 08             	sub    $0x8,%esp
80105bd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bda:	50                   	push   %eax
80105bdb:	6a 01                	push   $0x1
80105bdd:	e8 5e f5 ff ff       	call   80105140 <argint>
  if ((argstr(0, &path)) < 0 ||
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	78 4f                	js     80105c38 <sys_mknod+0x88>
      argint(2, &minor) < 0 ||
80105be9:	83 ec 08             	sub    $0x8,%esp
80105bec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bef:	50                   	push   %eax
80105bf0:	6a 02                	push   $0x2
80105bf2:	e8 49 f5 ff ff       	call   80105140 <argint>
      argint(1, &major) < 0 ||
80105bf7:	83 c4 10             	add    $0x10,%esp
80105bfa:	85 c0                	test   %eax,%eax
80105bfc:	78 3a                	js     80105c38 <sys_mknod+0x88>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105bfe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c02:	83 ec 0c             	sub    $0xc,%esp
80105c05:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c09:	ba 03 00 00 00       	mov    $0x3,%edx
80105c0e:	50                   	push   %eax
80105c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c12:	e8 d9 f6 ff ff       	call   801052f0 <create>
      argint(2, &minor) < 0 ||
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	74 1a                	je     80105c38 <sys_mknod+0x88>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	50                   	push   %eax
80105c22:	e8 d9 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c27:	e8 74 d1 ff ff       	call   80102da0 <end_op>
  return 0;
80105c2c:	83 c4 10             	add    $0x10,%esp
80105c2f:	31 c0                	xor    %eax,%eax
}
80105c31:	c9                   	leave  
80105c32:	c3                   	ret    
80105c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c37:	90                   	nop
    end_op();
80105c38:	e8 63 d1 ff ff       	call   80102da0 <end_op>
    return -1;
80105c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop

80105c50 <sys_chdir>:

int sys_chdir(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	56                   	push   %esi
80105c58:	53                   	push   %ebx
80105c59:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c5c:	e8 4f de ff ff       	call   80103ab0 <myproc>
80105c61:	89 c6                	mov    %eax,%esi

  begin_op();
80105c63:	e8 c8 d0 ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 ca f5 ff ff       	call   80105240 <argstr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 73                	js     80105cf0 <sys_chdir+0xa0>
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	ff 75 f4             	pushl  -0xc(%ebp)
80105c83:	e8 a8 c3 ff ff       	call   80102030 <namei>
80105c88:	83 c4 10             	add    $0x10,%esp
80105c8b:	89 c3                	mov    %eax,%ebx
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	74 5f                	je     80105cf0 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105c91:	83 ec 0c             	sub    $0xc,%esp
80105c94:	50                   	push   %eax
80105c95:	e8 c6 ba ff ff       	call   80101760 <ilock>
  if (ip->type != T_DIR)
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ca2:	75 2c                	jne    80105cd0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ca4:	83 ec 0c             	sub    $0xc,%esp
80105ca7:	53                   	push   %ebx
80105ca8:	e8 93 bb ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105cad:	58                   	pop    %eax
80105cae:	ff 76 74             	pushl  0x74(%esi)
80105cb1:	e8 da bb ff ff       	call   80101890 <iput>
  end_op();
80105cb6:	e8 e5 d0 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105cbb:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	31 c0                	xor    %eax,%eax
}
80105cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cc6:	5b                   	pop    %ebx
80105cc7:	5e                   	pop    %esi
80105cc8:	5d                   	pop    %ebp
80105cc9:	c3                   	ret    
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	53                   	push   %ebx
80105cd4:	e8 27 bd ff ff       	call   80101a00 <iunlockput>
    end_op();
80105cd9:	e8 c2 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce6:	eb db                	jmp    80105cc3 <sys_chdir+0x73>
80105ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
    end_op();
80105cf0:	e8 ab d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfa:	eb c7                	jmp    80105cc3 <sys_chdir+0x73>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exec>:

int sys_exec(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	57                   	push   %edi
80105d08:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105d09:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d0f:	53                   	push   %ebx
80105d10:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105d16:	50                   	push   %eax
80105d17:	6a 00                	push   $0x0
80105d19:	e8 22 f5 ff ff       	call   80105240 <argstr>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	0f 88 8b 00 00 00    	js     80105db4 <sys_exec+0xb4>
80105d29:	83 ec 08             	sub    $0x8,%esp
80105d2c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d32:	50                   	push   %eax
80105d33:	6a 01                	push   $0x1
80105d35:	e8 06 f4 ff ff       	call   80105140 <argint>
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	78 73                	js     80105db4 <sys_exec+0xb4>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d41:	83 ec 04             	sub    $0x4,%esp
80105d44:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for (i = 0;; i++)
80105d4a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d4c:	68 80 00 00 00       	push   $0x80
80105d51:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d57:	6a 00                	push   $0x0
80105d59:	50                   	push   %eax
80105d5a:	e8 c1 f0 ff ff       	call   80104e20 <memset>
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105d68:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d6e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d75:	83 ec 08             	sub    $0x8,%esp
80105d78:	57                   	push   %edi
80105d79:	01 f0                	add    %esi,%eax
80105d7b:	50                   	push   %eax
80105d7c:	e8 df f2 ff ff       	call   80105060 <fetchint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 2c                	js     80105db4 <sys_exec+0xb4>
      return -1;
    if (uarg == 0)
80105d88:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	74 36                	je     80105dc8 <sys_exec+0xc8>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105d92:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d9e:	52                   	push   %edx
80105d9f:	50                   	push   %eax
80105da0:	e8 fb f2 ff ff       	call   801050a0 <fetchstr>
80105da5:	83 c4 10             	add    $0x10,%esp
80105da8:	85 c0                	test   %eax,%eax
80105daa:	78 08                	js     80105db4 <sys_exec+0xb4>
  for (i = 0;; i++)
80105dac:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105daf:	83 fb 20             	cmp    $0x20,%ebx
80105db2:	75 b4                	jne    80105d68 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dbc:	5b                   	pop    %ebx
80105dbd:	5e                   	pop    %esi
80105dbe:	5f                   	pop    %edi
80105dbf:	5d                   	pop    %ebp
80105dc0:	c3                   	ret    
80105dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105dc8:	83 ec 08             	sub    $0x8,%esp
80105dcb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105dd1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dd8:	00 00 00 00 
  return exec(path, argv);
80105ddc:	50                   	push   %eax
80105ddd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105de3:	e8 98 ac ff ff       	call   80100a80 <exec>
80105de8:	83 c4 10             	add    $0x10,%esp
}
80105deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dee:	5b                   	pop    %ebx
80105def:	5e                   	pop    %esi
80105df0:	5f                   	pop    %edi
80105df1:	5d                   	pop    %ebp
80105df2:	c3                   	ret    
80105df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <sys_pipe>:

int sys_pipe(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	57                   	push   %edi
80105e08:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105e09:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e0c:	53                   	push   %ebx
80105e0d:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105e10:	6a 08                	push   $0x8
80105e12:	50                   	push   %eax
80105e13:	6a 00                	push   $0x0
80105e15:	e8 c6 f3 ff ff       	call   801051e0 <argptr>
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	78 4e                	js     80105e6f <sys_pipe+0x6f>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105e21:	83 ec 08             	sub    $0x8,%esp
80105e24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e27:	50                   	push   %eax
80105e28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e2b:	50                   	push   %eax
80105e2c:	e8 bf d5 ff ff       	call   801033f0 <pipealloc>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 37                	js     80105e6f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105e38:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80105e3b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e3d:	e8 6e dc ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105e48:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
80105e4c:	85 f6                	test   %esi,%esi
80105e4e:	74 30                	je     80105e80 <sys_pipe+0x80>
  for (fd = 0; fd < NOFILE; fd++)
80105e50:	83 c3 01             	add    $0x1,%ebx
80105e53:	83 fb 10             	cmp    $0x10,%ebx
80105e56:	75 f0                	jne    80105e48 <sys_pipe+0x48>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e5e:	e8 5d b0 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105e63:	58                   	pop    %eax
80105e64:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e67:	e8 54 b0 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105e6c:	83 c4 10             	add    $0x10,%esp
80105e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e74:	eb 5b                	jmp    80105ed1 <sys_pipe+0xd1>
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e80:	8d 73 0c             	lea    0xc(%ebx),%esi
80105e83:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105e87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e8a:	e8 21 dc ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105e8f:	31 d2                	xor    %edx,%edx
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105e98:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105e9c:	85 c9                	test   %ecx,%ecx
80105e9e:	74 20                	je     80105ec0 <sys_pipe+0xc0>
  for (fd = 0; fd < NOFILE; fd++)
80105ea0:	83 c2 01             	add    $0x1,%edx
80105ea3:	83 fa 10             	cmp    $0x10,%edx
80105ea6:	75 f0                	jne    80105e98 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ea8:	e8 03 dc ff ff       	call   80103ab0 <myproc>
80105ead:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80105eb4:	00 
80105eb5:	eb a1                	jmp    80105e58 <sys_pipe+0x58>
80105eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ec0:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ec7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ecc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ecf:	31 c0                	xor    %eax,%eax
}
80105ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_copy_file>:
}



int sys_copy_file(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	57                   	push   %edi
80105ee8:	56                   	push   %esi
80105ee9:	53                   	push   %ebx
80105eea:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80105ef0:	83 0c 24 00          	orl    $0x0,(%esp)
80105ef4:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80105ef7:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
80105efd:	50                   	push   %eax
80105efe:	6a 00                	push   $0x0
80105f00:	e8 3b f3 ff ff       	call   80105240 <argstr>
80105f05:	83 c4 10             	add    $0x10,%esp
80105f08:	85 c0                	test   %eax,%eax
80105f0a:	0f 88 7d 01 00 00    	js     8010608d <sys_copy_file+0x1ad>
80105f10:	83 ec 08             	sub    $0x8,%esp
80105f13:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
80105f19:	50                   	push   %eax
80105f1a:	6a 01                	push   $0x1
80105f1c:	e8 1f f3 ff ff       	call   80105240 <argstr>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 88 61 01 00 00    	js     8010608d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
80105f2c:	e8 ff cd ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
80105f31:	83 ec 0c             	sub    $0xc,%esp
80105f34:	ff b5 e0 ef ff ff    	pushl  -0x1020(%ebp)
80105f3a:	e8 f1 c0 ff ff       	call   80102030 <namei>
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	89 c6                	mov    %eax,%esi
80105f44:	85 c0                	test   %eax,%eax
80105f46:	0f 84 bc 01 00 00    	je     80106108 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105f4c:	83 ec 0c             	sub    $0xc,%esp
80105f4f:	50                   	push   %eax
80105f50:	e8 0b b8 ff ff       	call   80101760 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105f55:	e8 a6 ae ff ff       	call   80100e00 <filealloc>
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	89 c7                	mov    %eax,%edi
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	74 29                	je     80105f8c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
80105f63:	e8 48 db ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105f68:	31 d2                	xor    %edx,%edx
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105f70:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105f74:	85 c9                	test   %ecx,%ecx
80105f76:	74 38                	je     80105fb0 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80105f78:	83 c2 01             	add    $0x1,%edx
80105f7b:	83 fa 10             	cmp    $0x10,%edx
80105f7e:	75 f0                	jne    80105f70 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	57                   	push   %edi
80105f84:	e8 37 af ff ff       	call   80100ec0 <fileclose>
80105f89:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	56                   	push   %esi
80105f90:	e8 6b ba ff ff       	call   80101a00 <iunlockput>
    end_op();
80105f95:	e8 06 ce ff ff       	call   80102da0 <end_op>
    return -1;
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa2:	e9 59 01 00 00       	jmp    80106100 <sys_copy_file+0x220>
80105fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105fb0:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80105fb3:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105fb6:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
80105fba:	56                   	push   %esi
80105fbb:	e8 80 b8 ff ff       	call   80101840 <iunlock>
  end_op();
80105fc0:	e8 db cd ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80105fc5:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
80105fca:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
80105fcd:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80105fd3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
80105fda:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
80105fde:	e8 cd da ff ff       	call   80103ab0 <myproc>
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
80105fea:	85 c0                	test   %eax,%eax
80105fec:	0f 84 9b 00 00 00    	je     8010608d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80105ff2:	83 ec 04             	sub    $0x4,%esp
80105ff5:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
80105ffb:	68 00 10 00 00       	push   $0x1000
80106000:	57                   	push   %edi
80106001:	50                   	push   %eax
80106002:	e8 e9 af ff ff       	call   80100ff0 <fileread>
80106007:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
8010600d:	e8 1e cd ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
80106012:	58                   	pop    %eax
80106013:	ff b5 e4 ef ff ff    	pushl  -0x101c(%ebp)
80106019:	e8 12 c0 ff ff       	call   80102030 <namei>
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	89 c3                	mov    %eax,%ebx
80106023:	85 c0                	test   %eax,%eax
80106025:	0f 84 dd 00 00 00    	je     80106108 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
8010602b:	83 ec 0c             	sub    $0xc,%esp
8010602e:	50                   	push   %eax
8010602f:	e8 2c b7 ff ff       	call   80101760 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80106034:	83 c4 10             	add    $0x10,%esp
80106037:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010603c:	75 0a                	jne    80106048 <sys_copy_file+0x168>
8010603e:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80106044:	85 f6                	test   %esi,%esi
80106046:	75 34                	jne    8010607c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80106048:	e8 b3 ad ff ff       	call   80100e00 <filealloc>
8010604d:	89 c6                	mov    %eax,%esi
8010604f:	85 c0                	test   %eax,%eax
80106051:	74 29                	je     8010607c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80106053:	e8 58 da ff ff       	call   80103ab0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106058:	31 d2                	xor    %edx,%edx
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106060:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106064:	85 c9                	test   %ecx,%ecx
80106066:	74 30                	je     80106098 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80106068:	83 c2 01             	add    $0x1,%edx
8010606b:	83 fa 10             	cmp    $0x10,%edx
8010606e:	75 f0                	jne    80106060 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	56                   	push   %esi
80106074:	e8 47 ae ff ff       	call   80100ec0 <fileclose>
80106079:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
8010607c:	83 ec 0c             	sub    $0xc,%esp
8010607f:	53                   	push   %ebx
80106080:	e8 7b b9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106085:	e8 16 cd ff ff       	call   80102da0 <end_op>
    return -1;
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106092:	eb 6c                	jmp    80106100 <sys_copy_file+0x220>
80106094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106098:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
8010609b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010609e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
801060a2:	53                   	push   %ebx
      curproc->ofile[fd] = f;
801060a3:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
801060a9:	e8 92 b7 ff ff       	call   80101840 <iunlock>
  end_op();
801060ae:	e8 ed cc ff ff       	call   80102da0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
801060b3:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
801060b8:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
801060bb:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
801060c1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
801060c8:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
801060cc:	e8 df d9 ff ff       	call   80103ab0 <myproc>
801060d1:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
801060d7:	83 c4 10             	add    $0x10,%esp
801060da:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801060de:	85 c0                	test   %eax,%eax
801060e0:	74 ab                	je     8010608d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
801060e2:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
801060e8:	83 ec 04             	sub    $0x4,%esp
801060eb:	53                   	push   %ebx
801060ec:	57                   	push   %edi
801060ed:	50                   	push   %eax
801060ee:	e8 9d af ff ff       	call   80101090 <filewrite>
  if(written_chars != read_chars){
801060f3:	83 c4 10             	add    $0x10,%esp
801060f6:	39 c3                	cmp    %eax,%ebx
801060f8:	0f 95 c0             	setne  %al
801060fb:	0f b6 c0             	movzbl %al,%eax
801060fe:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80106100:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106103:	5b                   	pop    %ebx
80106104:	5e                   	pop    %esi
80106105:	5f                   	pop    %edi
80106106:	5d                   	pop    %ebp
80106107:	c3                   	ret    
      end_op();
80106108:	e8 93 cc ff ff       	call   80102da0 <end_op>
      return -1;
8010610d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106112:	eb ec                	jmp    80106100 <sys_copy_file+0x220>
80106114:	66 90                	xchg   %ax,%ax
80106116:	66 90                	xchg   %ax,%ax
80106118:	66 90                	xchg   %ax,%ax
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80106120:	f3 0f 1e fb          	endbr32 
  return fork();
80106124:	e9 87 de ff ff       	jmp    80103fb0 <fork>
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106130 <sys_exit>:
}

int sys_exit(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	83 ec 08             	sub    $0x8,%esp
  exit();
8010613a:	e8 91 e3 ff ff       	call   801044d0 <exit>
  return 0; // not reached
}
8010613f:	31 c0                	xor    %eax,%eax
80106141:	c9                   	leave  
80106142:	c3                   	ret    
80106143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106150 <sys_wait>:

int sys_wait(void)
{
80106150:	f3 0f 1e fb          	endbr32 
  return wait();
80106154:	e9 c7 e5 ff ff       	jmp    80104720 <wait>
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106160 <sys_kill>:
}

int sys_kill(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
8010616a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010616d:	50                   	push   %eax
8010616e:	6a 00                	push   $0x0
80106170:	e8 cb ef ff ff       	call   80105140 <argint>
80106175:	83 c4 10             	add    $0x10,%esp
80106178:	85 c0                	test   %eax,%eax
8010617a:	78 14                	js     80106190 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010617c:	83 ec 0c             	sub    $0xc,%esp
8010617f:	ff 75 f4             	pushl  -0xc(%ebp)
80106182:	e8 09 e7 ff ff       	call   80104890 <kill>
80106187:	83 c4 10             	add    $0x10,%esp
}
8010618a:	c9                   	leave  
8010618b:	c3                   	ret    
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106190:	c9                   	leave  
    return -1;
80106191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106196:	c3                   	ret    
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <sys_getpid>:

int sys_getpid(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801061aa:	e8 01 d9 ff ff       	call   80103ab0 <myproc>
801061af:	8b 40 10             	mov    0x10(%eax),%eax
}
801061b2:	c9                   	leave  
801061b3:	c3                   	ret    
801061b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop

801061c0 <sys_sbrk>:

int sys_sbrk(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
801061c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061cb:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801061ce:	50                   	push   %eax
801061cf:	6a 00                	push   $0x0
801061d1:	e8 6a ef ff ff       	call   80105140 <argint>
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	85 c0                	test   %eax,%eax
801061db:	78 23                	js     80106200 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801061dd:	e8 ce d8 ff ff       	call   80103ab0 <myproc>
  if (growproc(n) < 0)
801061e2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801061e5:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
801061e7:	ff 75 f4             	pushl  -0xc(%ebp)
801061ea:	e8 41 dd ff ff       	call   80103f30 <growproc>
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	85 c0                	test   %eax,%eax
801061f4:	78 0a                	js     80106200 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801061f6:	89 d8                	mov    %ebx,%eax
801061f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061fb:	c9                   	leave  
801061fc:	c3                   	ret    
801061fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106200:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106205:	eb ef                	jmp    801061f6 <sys_sbrk+0x36>
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax

80106210 <sys_sleep>:

int sys_sleep(void)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106218:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010621b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010621e:	50                   	push   %eax
8010621f:	6a 00                	push   $0x0
80106221:	e8 1a ef ff ff       	call   80105140 <argint>
80106226:	83 c4 10             	add    $0x10,%esp
80106229:	85 c0                	test   %eax,%eax
8010622b:	0f 88 86 00 00 00    	js     801062b7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106231:	83 ec 0c             	sub    $0xc,%esp
80106234:	68 60 65 11 80       	push   $0x80116560
80106239:	e8 d2 ea ff ff       	call   80104d10 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010623e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106241:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while (ticks - ticks0 < n)
80106247:	83 c4 10             	add    $0x10,%esp
8010624a:	85 d2                	test   %edx,%edx
8010624c:	75 23                	jne    80106271 <sys_sleep+0x61>
8010624e:	eb 50                	jmp    801062a0 <sys_sleep+0x90>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106250:	83 ec 08             	sub    $0x8,%esp
80106253:	68 60 65 11 80       	push   $0x80116560
80106258:	68 a0 6d 11 80       	push   $0x80116da0
8010625d:	e8 fe e3 ff ff       	call   80104660 <sleep>
  while (ticks - ticks0 < n)
80106262:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80106267:	83 c4 10             	add    $0x10,%esp
8010626a:	29 d8                	sub    %ebx,%eax
8010626c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010626f:	73 2f                	jae    801062a0 <sys_sleep+0x90>
    if (myproc()->killed)
80106271:	e8 3a d8 ff ff       	call   80103ab0 <myproc>
80106276:	8b 40 30             	mov    0x30(%eax),%eax
80106279:	85 c0                	test   %eax,%eax
8010627b:	74 d3                	je     80106250 <sys_sleep+0x40>
      release(&tickslock);
8010627d:	83 ec 0c             	sub    $0xc,%esp
80106280:	68 60 65 11 80       	push   $0x80116560
80106285:	e8 46 eb ff ff       	call   80104dd0 <release>
  }
  release(&tickslock);
  return 0;
}
8010628a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106295:	c9                   	leave  
80106296:	c3                   	ret    
80106297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010629e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	68 60 65 11 80       	push   $0x80116560
801062a8:	e8 23 eb ff ff       	call   80104dd0 <release>
  return 0;
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	31 c0                	xor    %eax,%eax
}
801062b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
    return -1;
801062b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bc:	eb f4                	jmp    801062b2 <sys_sleep+0xa2>
801062be:	66 90                	xchg   %ax,%ax

801062c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801062c0:	f3 0f 1e fb          	endbr32 
801062c4:	55                   	push   %ebp
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	53                   	push   %ebx
801062c8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062cb:	68 60 65 11 80       	push   $0x80116560
801062d0:	e8 3b ea ff ff       	call   80104d10 <acquire>
  xticks = ticks;
801062d5:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
801062db:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
801062e2:	e8 e9 ea ff ff       	call   80104dd0 <release>
  return xticks;
}
801062e7:	89 d8                	mov    %ebx,%eax
801062e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062ec:	c9                   	leave  
801062ed:	c3                   	ret    
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
801062f0:	f3 0f 1e fb          	endbr32 
801062f4:	55                   	push   %ebp
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
801062fa:	e8 b1 d7 ff ff       	call   80103ab0 <myproc>
  return find_digital_root(number);
801062ff:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
80106302:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
80106305:	ff 70 10             	pushl  0x10(%eax)
80106308:	e8 f3 e6 ff ff       	call   80104a00 <find_digital_root>
}
8010630d:	c9                   	leave  
8010630e:	c3                   	ret    
8010630f:	90                   	nop

80106310 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
80106310:	f3 0f 1e fb          	endbr32 
80106314:	55                   	push   %ebp
80106315:	89 e5                	mov    %esp,%ebp
80106317:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
8010631a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010631d:	50                   	push   %eax
8010631e:	6a 00                	push   $0x0
80106320:	e8 1b ee ff ff       	call   80105140 <argint>
80106325:	83 c4 10             	add    $0x10,%esp
80106328:	85 c0                	test   %eax,%eax
8010632a:	78 24                	js     80106350 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
8010632c:	83 ec 0c             	sub    $0xc,%esp
8010632f:	ff 75 f4             	pushl  -0xc(%ebp)
80106332:	e8 19 d9 ff ff       	call   80103c50 <find_proc>
  return count_child(grandFather) - 1;
80106337:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106338:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
8010633b:	ff 70 14             	pushl  0x14(%eax)
8010633e:	e8 8d db ff ff       	call   80103ed0 <count_child>
80106343:	83 c4 10             	add    $0x10,%esp
}
80106346:	c9                   	leave  
  return count_child(grandFather) - 1;
80106347:	83 e8 01             	sub    $0x1,%eax
}
8010634a:	c3                   	ret    
8010634b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010634f:	90                   	nop
80106350:	c9                   	leave  
    return -1;
80106351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106356:	c3                   	ret    
80106357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635e:	66 90                	xchg   %ax,%ax

80106360 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106360:	f3 0f 1e fb          	endbr32 
80106364:	55                   	push   %ebp
80106365:	89 e5                	mov    %esp,%ebp
80106367:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106368:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010636b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010636e:	50                   	push   %eax
8010636f:	6a 00                	push   $0x0
80106371:	e8 ca ed ff ff       	call   80105140 <argint>
80106376:	83 c4 10             	add    $0x10,%esp
80106379:	85 c0                	test   %eax,%eax
8010637b:	78 23                	js     801063a0 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	ff 75 f4             	pushl  -0xc(%ebp)
80106383:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
80106389:	e8 c2 d8 ff ff       	call   80103c50 <find_proc>
8010638e:	83 c4 10             	add    $0x10,%esp
80106391:	2b 58 20             	sub    0x20(%eax),%ebx
80106394:	89 d8                	mov    %ebx,%eax
}
80106396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106399:	c9                   	leave  
8010639a:	c3                   	ret    
8010639b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010639f:	90                   	nop
    return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a5:	eb ef                	jmp    80106396 <sys_get_process_lifetime+0x36>
801063a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <sys_set_date>:
void sys_set_date(void)
{
801063b0:	f3 0f 1e fb          	endbr32 
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
801063ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063bd:	6a 18                	push   $0x18
801063bf:	50                   	push   %eax
801063c0:	6a 00                	push   $0x0
801063c2:	e8 19 ee ff ff       	call   801051e0 <argptr>
801063c7:	83 c4 10             	add    $0x10,%esp
801063ca:	85 c0                	test   %eax,%eax
801063cc:	78 12                	js     801063e0 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
801063ce:	83 ec 0c             	sub    $0xc,%esp
801063d1:	ff 75 f4             	pushl  -0xc(%ebp)
801063d4:	e8 b7 c5 ff ff       	call   80102990 <cmostime>
}
801063d9:	83 c4 10             	add    $0x10,%esp
801063dc:	c9                   	leave  
801063dd:	c3                   	ret    
801063de:	66 90                	xchg   %ax,%ax
    cprintf("Kernel: sys_set_date() has a problem.\n");
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	68 28 87 10 80       	push   $0x80108728
801063e8:	e8 c3 a2 ff ff       	call   801006b0 <cprintf>
801063ed:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	ff 75 f4             	pushl  -0xc(%ebp)
801063f6:	e8 95 c5 ff ff       	call   80102990 <cmostime>
}
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	c9                   	leave  
801063ff:	c3                   	ret    

80106400 <sys_get_pid>:
80106400:	f3 0f 1e fb          	endbr32 
80106404:	e9 97 fd ff ff       	jmp    801061a0 <sys_getpid>
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106410 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
80106410:	f3 0f 1e fb          	endbr32 
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
8010641a:	e8 91 d6 ff ff       	call   80103ab0 <myproc>
8010641f:	8b 40 14             	mov    0x14(%eax),%eax
80106422:	8b 40 10             	mov    0x10(%eax),%eax
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <sys_change_queue>:
int sys_change_queue(void)
{
80106430:	f3 0f 1e fb          	endbr32 
80106434:	55                   	push   %ebp
80106435:	89 e5                	mov    %esp,%ebp
80106437:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
80106438:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
8010643b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
8010643e:	50                   	push   %eax
8010643f:	6a 00                	push   $0x0
80106441:	e8 fa ec ff ff       	call   80105140 <argint>
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	85 c0                	test   %eax,%eax
8010644b:	78 43                	js     80106490 <sys_change_queue+0x60>
8010644d:	83 ec 08             	sub    $0x8,%esp
80106450:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106453:	50                   	push   %eax
80106454:	6a 01                	push   $0x1
80106456:	e8 e5 ec ff ff       	call   80105140 <argint>
8010645b:	83 c4 10             	add    $0x10,%esp
8010645e:	89 c3                	mov    %eax,%ebx
80106460:	85 c0                	test   %eax,%eax
80106462:	75 2c                	jne    80106490 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", pid);
80106464:	83 ec 08             	sub    $0x8,%esp
80106467:	ff 75 f0             	pushl  -0x10(%ebp)
8010646a:	68 94 83 10 80       	push   $0x80108394
8010646f:	e8 3c a2 ff ff       	call   801006b0 <cprintf>
  struct proc *p = find_proc(pid);
80106474:	58                   	pop    %eax
80106475:	ff 75 f0             	pushl  -0x10(%ebp)
80106478:	e8 d3 d7 ff ff       	call   80103c50 <find_proc>
  p->que_id = que_id;
8010647d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
80106480:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
80106483:	89 50 28             	mov    %edx,0x28(%eax)
}
80106486:	89 d8                	mov    %ebx,%eax
80106488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010648b:	c9                   	leave  
8010648c:	c3                   	ret    
8010648d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106490:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106495:	eb ef                	jmp    80106486 <sys_change_queue+0x56>
80106497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
801064a5:	89 e5                	mov    %esp,%ebp
801064a7:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argf(1, &priority_ratio) < 0 || argf(2, &creation_time_ratio) < 0 || argf(3, &exec_cycle_ratio) < 0 || argf(4, &size_ratio) < 0)
801064aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064ad:	50                   	push   %eax
801064ae:	6a 00                	push   $0x0
801064b0:	e8 8b ec ff ff       	call   80105140 <argint>
801064b5:	83 c4 10             	add    $0x10,%esp
801064b8:	85 c0                	test   %eax,%eax
801064ba:	0f 88 90 00 00 00    	js     80106550 <sys_bjf_validation_process+0xb0>
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064c6:	50                   	push   %eax
801064c7:	6a 01                	push   $0x1
801064c9:	e8 c2 ec ff ff       	call   80105190 <argf>
801064ce:	83 c4 10             	add    $0x10,%esp
801064d1:	85 c0                	test   %eax,%eax
801064d3:	78 7b                	js     80106550 <sys_bjf_validation_process+0xb0>
801064d5:	83 ec 08             	sub    $0x8,%esp
801064d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064db:	50                   	push   %eax
801064dc:	6a 02                	push   $0x2
801064de:	e8 ad ec ff ff       	call   80105190 <argf>
801064e3:	83 c4 10             	add    $0x10,%esp
801064e6:	85 c0                	test   %eax,%eax
801064e8:	78 66                	js     80106550 <sys_bjf_validation_process+0xb0>
801064ea:	83 ec 08             	sub    $0x8,%esp
801064ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064f0:	50                   	push   %eax
801064f1:	6a 03                	push   $0x3
801064f3:	e8 98 ec ff ff       	call   80105190 <argf>
801064f8:	83 c4 10             	add    $0x10,%esp
801064fb:	85 c0                	test   %eax,%eax
801064fd:	78 51                	js     80106550 <sys_bjf_validation_process+0xb0>
801064ff:	83 ec 08             	sub    $0x8,%esp
80106502:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106505:	50                   	push   %eax
80106506:	6a 04                	push   $0x4
80106508:	e8 83 ec ff ff       	call   80105190 <argf>
8010650d:	83 c4 10             	add    $0x10,%esp
80106510:	85 c0                	test   %eax,%eax
80106512:	78 3c                	js     80106550 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	ff 75 e4             	pushl  -0x1c(%ebp)
8010651a:	e8 31 d7 ff ff       	call   80103c50 <find_proc>
  p->priority_ratio = priority_ratio;
8010651f:	d9 45 e8             	flds   -0x18(%ebp)
  p->creation_time_ratio = creation_time_ratio;
  p->executed_cycle_ratio = exec_cycle_ratio;
  p->process_size_ratio = size_ratio;

  return 0;
80106522:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = priority_ratio;
80106525:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = creation_time_ratio;
8010652b:	d9 45 ec             	flds   -0x14(%ebp)
8010652e:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = exec_cycle_ratio;
80106534:	d9 45 f0             	flds   -0x10(%ebp)
80106537:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = size_ratio;
8010653d:	d9 45 f4             	flds   -0xc(%ebp)
80106540:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
80106546:	31 c0                	xor    %eax,%eax
}
80106548:	c9                   	leave  
80106549:	c3                   	ret    
8010654a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106550:	c9                   	leave  
    return -1;
80106551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106556:	c3                   	ret    
80106557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655e:	66 90                	xchg   %ax,%ax

80106560 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106560:	f3 0f 1e fb          	endbr32 
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argf(0, &priority_ratio) < 0 || argf(1, &creation_time_ratio) < 0 || argf(2, &exec_cycle_ratio) < 0 || argf(3, &size_ratio) < 0)
8010656a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010656d:	50                   	push   %eax
8010656e:	6a 00                	push   $0x0
80106570:	e8 1b ec ff ff       	call   80105190 <argf>
80106575:	83 c4 10             	add    $0x10,%esp
80106578:	85 c0                	test   %eax,%eax
8010657a:	78 74                	js     801065f0 <sys_bjf_validation_system+0x90>
8010657c:	83 ec 08             	sub    $0x8,%esp
8010657f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106582:	50                   	push   %eax
80106583:	6a 01                	push   $0x1
80106585:	e8 06 ec ff ff       	call   80105190 <argf>
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	85 c0                	test   %eax,%eax
8010658f:	78 5f                	js     801065f0 <sys_bjf_validation_system+0x90>
80106591:	83 ec 08             	sub    $0x8,%esp
80106594:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106597:	50                   	push   %eax
80106598:	6a 02                	push   $0x2
8010659a:	e8 f1 eb ff ff       	call   80105190 <argf>
8010659f:	83 c4 10             	add    $0x10,%esp
801065a2:	85 c0                	test   %eax,%eax
801065a4:	78 4a                	js     801065f0 <sys_bjf_validation_system+0x90>
801065a6:	83 ec 08             	sub    $0x8,%esp
801065a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ac:	50                   	push   %eax
801065ad:	6a 03                	push   $0x3
801065af:	e8 dc eb ff ff       	call   80105190 <argf>
801065b4:	83 c4 10             	add    $0x10,%esp
801065b7:	85 c0                	test   %eax,%eax
801065b9:	78 35                	js     801065f0 <sys_bjf_validation_system+0x90>
  {
    return -1;
  }
  cprintf("%d\n", priority_ratio);
801065bb:	d9 45 e8             	flds   -0x18(%ebp)
801065be:	83 ec 0c             	sub    $0xc,%esp
801065c1:	dd 1c 24             	fstpl  (%esp)
801065c4:	68 94 83 10 80       	push   $0x80108394
801065c9:	e8 e2 a0 ff ff       	call   801006b0 <cprintf>
  reset_bjf_attributes(priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio);
801065ce:	ff 75 f4             	pushl  -0xc(%ebp)
801065d1:	ff 75 f0             	pushl  -0x10(%ebp)
801065d4:	ff 75 ec             	pushl  -0x14(%ebp)
801065d7:	ff 75 e8             	pushl  -0x18(%ebp)
801065da:	e8 41 d4 ff ff       	call   80103a20 <reset_bjf_attributes>
  return 0;
801065df:	83 c4 20             	add    $0x20,%esp
801065e2:	31 c0                	xor    %eax,%eax
}
801065e4:	c9                   	leave  
801065e5:	c3                   	ret    
801065e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ed:	8d 76 00             	lea    0x0(%esi),%esi
801065f0:	c9                   	leave  
    return -1;
801065f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065f6:	c3                   	ret    
801065f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fe:	66 90                	xchg   %ax,%ax

80106600 <sys_print_info>:
int sys_print_info(void)
{
80106600:	f3 0f 1e fb          	endbr32 
80106604:	55                   	push   %ebp
80106605:	89 e5                	mov    %esp,%ebp
80106607:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
8010660a:	e8 31 d7 ff ff       	call   80103d40 <print_bitches>
  return 0;
8010660f:	31 c0                	xor    %eax,%eax
80106611:	c9                   	leave  
80106612:	c3                   	ret    

80106613 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106613:	1e                   	push   %ds
  pushl %es
80106614:	06                   	push   %es
  pushl %fs
80106615:	0f a0                	push   %fs
  pushl %gs
80106617:	0f a8                	push   %gs
  pushal
80106619:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010661a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010661e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106620:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106622:	54                   	push   %esp
  call trap
80106623:	e8 c8 00 00 00       	call   801066f0 <trap>
  addl $4, %esp
80106628:	83 c4 04             	add    $0x4,%esp

8010662b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010662b:	61                   	popa   
  popl %gs
8010662c:	0f a9                	pop    %gs
  popl %fs
8010662e:	0f a1                	pop    %fs
  popl %es
80106630:	07                   	pop    %es
  popl %ds
80106631:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106632:	83 c4 08             	add    $0x8,%esp
  iret
80106635:	cf                   	iret   
80106636:	66 90                	xchg   %ax,%ax
80106638:	66 90                	xchg   %ax,%ax
8010663a:	66 90                	xchg   %ax,%ax
8010663c:	66 90                	xchg   %ax,%ax
8010663e:	66 90                	xchg   %ax,%ax

80106640 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106645:	31 c0                	xor    %eax,%eax
{
80106647:	89 e5                	mov    %esp,%ebp
80106649:	83 ec 08             	sub    $0x8,%esp
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106650:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106657:	c7 04 c5 a2 65 11 80 	movl   $0x8e000008,-0x7fee9a5e(,%eax,8)
8010665e:	08 00 00 8e 
80106662:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
80106669:	80 
8010666a:	c1 ea 10             	shr    $0x10,%edx
8010666d:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
80106674:	80 
  for(i = 0; i < 256; i++)
80106675:	83 c0 01             	add    $0x1,%eax
80106678:	3d 00 01 00 00       	cmp    $0x100,%eax
8010667d:	75 d1                	jne    80106650 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010667f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106682:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106687:	c7 05 a2 67 11 80 08 	movl   $0xef000008,0x801167a2
8010668e:	00 00 ef 
  initlock(&tickslock, "time");
80106691:	68 4f 87 10 80       	push   $0x8010874f
80106696:	68 60 65 11 80       	push   $0x80116560
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010669b:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
801066a1:	c1 e8 10             	shr    $0x10,%eax
801066a4:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6
  initlock(&tickslock, "time");
801066aa:	e8 e1 e4 ff ff       	call   80104b90 <initlock>
}
801066af:	83 c4 10             	add    $0x10,%esp
801066b2:	c9                   	leave  
801066b3:	c3                   	ret    
801066b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066bf:	90                   	nop

801066c0 <idtinit>:

void
idtinit(void)
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
  pd[0] = size-1;
801066c5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801066ca:	89 e5                	mov    %esp,%ebp
801066cc:	83 ec 10             	sub    $0x10,%esp
801066cf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066d3:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
801066d8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066dc:	c1 e8 10             	shr    $0x10,%eax
801066df:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801066e3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066e6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801066e9:	c9                   	leave  
801066ea:	c3                   	ret    
801066eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066ef:	90                   	nop

801066f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801066f0:	f3 0f 1e fb          	endbr32 
801066f4:	55                   	push   %ebp
801066f5:	89 e5                	mov    %esp,%ebp
801066f7:	57                   	push   %edi
801066f8:	56                   	push   %esi
801066f9:	53                   	push   %ebx
801066fa:	83 ec 1c             	sub    $0x1c,%esp
801066fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106700:	8b 43 30             	mov    0x30(%ebx),%eax
80106703:	83 f8 40             	cmp    $0x40,%eax
80106706:	0f 84 c4 01 00 00    	je     801068d0 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010670c:	83 e8 20             	sub    $0x20,%eax
8010670f:	83 f8 1f             	cmp    $0x1f,%eax
80106712:	77 08                	ja     8010671c <trap+0x2c>
80106714:	3e ff 24 85 f8 87 10 	notrack jmp *-0x7fef7808(,%eax,4)
8010671b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010671c:	e8 8f d3 ff ff       	call   80103ab0 <myproc>
80106721:	8b 7b 38             	mov    0x38(%ebx),%edi
80106724:	85 c0                	test   %eax,%eax
80106726:	0f 84 f3 01 00 00    	je     8010691f <trap+0x22f>
8010672c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106730:	0f 84 e9 01 00 00    	je     8010691f <trap+0x22f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106736:	0f 20 d1             	mov    %cr2,%ecx
80106739:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010673c:	e8 3f d2 ff ff       	call   80103980 <cpuid>
80106741:	8b 73 30             	mov    0x30(%ebx),%esi
80106744:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106747:	8b 43 34             	mov    0x34(%ebx),%eax
8010674a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010674d:	e8 5e d3 ff ff       	call   80103ab0 <myproc>
80106752:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106755:	e8 56 d3 ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010675a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010675d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106760:	51                   	push   %ecx
80106761:	57                   	push   %edi
80106762:	52                   	push   %edx
80106763:	ff 75 e4             	pushl  -0x1c(%ebp)
80106766:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106767:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010676a:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010676d:	56                   	push   %esi
8010676e:	ff 70 10             	pushl  0x10(%eax)
80106771:	68 b4 87 10 80       	push   $0x801087b4
80106776:	e8 35 9f ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010677b:	83 c4 20             	add    $0x20,%esp
8010677e:	e8 2d d3 ff ff       	call   80103ab0 <myproc>
80106783:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010678a:	e8 21 d3 ff ff       	call   80103ab0 <myproc>
8010678f:	85 c0                	test   %eax,%eax
80106791:	74 1d                	je     801067b0 <trap+0xc0>
80106793:	e8 18 d3 ff ff       	call   80103ab0 <myproc>
80106798:	8b 50 30             	mov    0x30(%eax),%edx
8010679b:	85 d2                	test   %edx,%edx
8010679d:	74 11                	je     801067b0 <trap+0xc0>
8010679f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067a3:	83 e0 03             	and    $0x3,%eax
801067a6:	66 83 f8 03          	cmp    $0x3,%ax
801067aa:	0f 84 58 01 00 00    	je     80106908 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801067b0:	e8 fb d2 ff ff       	call   80103ab0 <myproc>
801067b5:	85 c0                	test   %eax,%eax
801067b7:	74 0f                	je     801067c8 <trap+0xd8>
801067b9:	e8 f2 d2 ff ff       	call   80103ab0 <myproc>
801067be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801067c2:	0f 84 f0 00 00 00    	je     801068b8 <trap+0x1c8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067c8:	e8 e3 d2 ff ff       	call   80103ab0 <myproc>
801067cd:	85 c0                	test   %eax,%eax
801067cf:	74 1d                	je     801067ee <trap+0xfe>
801067d1:	e8 da d2 ff ff       	call   80103ab0 <myproc>
801067d6:	8b 40 30             	mov    0x30(%eax),%eax
801067d9:	85 c0                	test   %eax,%eax
801067db:	74 11                	je     801067ee <trap+0xfe>
801067dd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067e1:	83 e0 03             	and    $0x3,%eax
801067e4:	66 83 f8 03          	cmp    $0x3,%ax
801067e8:	0f 84 0b 01 00 00    	je     801068f9 <trap+0x209>
    exit();
}
801067ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067f1:	5b                   	pop    %ebx
801067f2:	5e                   	pop    %esi
801067f3:	5f                   	pop    %edi
801067f4:	5d                   	pop    %ebp
801067f5:	c3                   	ret    
    ideintr();
801067f6:	e8 e5 b9 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
801067fb:	e8 c0 c0 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106800:	e8 ab d2 ff ff       	call   80103ab0 <myproc>
80106805:	85 c0                	test   %eax,%eax
80106807:	75 8a                	jne    80106793 <trap+0xa3>
80106809:	eb a5                	jmp    801067b0 <trap+0xc0>
    if(cpuid() == 0){
8010680b:	e8 70 d1 ff ff       	call   80103980 <cpuid>
80106810:	85 c0                	test   %eax,%eax
80106812:	75 e7                	jne    801067fb <trap+0x10b>
      acquire(&tickslock);
80106814:	83 ec 0c             	sub    $0xc,%esp
80106817:	68 60 65 11 80       	push   $0x80116560
8010681c:	e8 ef e4 ff ff       	call   80104d10 <acquire>
      wakeup(&ticks);
80106821:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
      ticks++;
80106828:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
8010682f:	e8 ec df ff ff       	call   80104820 <wakeup>
      release(&tickslock);
80106834:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010683b:	e8 90 e5 ff ff       	call   80104dd0 <release>
      aging();
80106840:	e8 5b d1 ff ff       	call   801039a0 <aging>
80106845:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106848:	eb b1                	jmp    801067fb <trap+0x10b>
    kbdintr();
8010684a:	e8 31 bf ff ff       	call   80102780 <kbdintr>
    lapiceoi();
8010684f:	e8 6c c0 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106854:	e8 57 d2 ff ff       	call   80103ab0 <myproc>
80106859:	85 c0                	test   %eax,%eax
8010685b:	0f 85 32 ff ff ff    	jne    80106793 <trap+0xa3>
80106861:	e9 4a ff ff ff       	jmp    801067b0 <trap+0xc0>
    uartintr();
80106866:	e8 55 02 00 00       	call   80106ac0 <uartintr>
    lapiceoi();
8010686b:	e8 50 c0 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106870:	e8 3b d2 ff ff       	call   80103ab0 <myproc>
80106875:	85 c0                	test   %eax,%eax
80106877:	0f 85 16 ff ff ff    	jne    80106793 <trap+0xa3>
8010687d:	e9 2e ff ff ff       	jmp    801067b0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106882:	8b 7b 38             	mov    0x38(%ebx),%edi
80106885:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106889:	e8 f2 d0 ff ff       	call   80103980 <cpuid>
8010688e:	57                   	push   %edi
8010688f:	56                   	push   %esi
80106890:	50                   	push   %eax
80106891:	68 5c 87 10 80       	push   $0x8010875c
80106896:	e8 15 9e ff ff       	call   801006b0 <cprintf>
    lapiceoi();
8010689b:	e8 20 c0 ff ff       	call   801028c0 <lapiceoi>
    break;
801068a0:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068a3:	e8 08 d2 ff ff       	call   80103ab0 <myproc>
801068a8:	85 c0                	test   %eax,%eax
801068aa:	0f 85 e3 fe ff ff    	jne    80106793 <trap+0xa3>
801068b0:	e9 fb fe ff ff       	jmp    801067b0 <trap+0xc0>
801068b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801068b8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801068bc:	0f 85 06 ff ff ff    	jne    801067c8 <trap+0xd8>
    yield();
801068c2:	e8 49 dd ff ff       	call   80104610 <yield>
801068c7:	e9 fc fe ff ff       	jmp    801067c8 <trap+0xd8>
801068cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801068d0:	e8 db d1 ff ff       	call   80103ab0 <myproc>
801068d5:	8b 70 30             	mov    0x30(%eax),%esi
801068d8:	85 f6                	test   %esi,%esi
801068da:	75 3c                	jne    80106918 <trap+0x228>
    myproc()->tf = tf;
801068dc:	e8 cf d1 ff ff       	call   80103ab0 <myproc>
801068e1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801068e4:	e8 97 e9 ff ff       	call   80105280 <syscall>
    if(myproc()->killed)
801068e9:	e8 c2 d1 ff ff       	call   80103ab0 <myproc>
801068ee:	8b 48 30             	mov    0x30(%eax),%ecx
801068f1:	85 c9                	test   %ecx,%ecx
801068f3:	0f 84 f5 fe ff ff    	je     801067ee <trap+0xfe>
}
801068f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068fc:	5b                   	pop    %ebx
801068fd:	5e                   	pop    %esi
801068fe:	5f                   	pop    %edi
801068ff:	5d                   	pop    %ebp
      exit();
80106900:	e9 cb db ff ff       	jmp    801044d0 <exit>
80106905:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106908:	e8 c3 db ff ff       	call   801044d0 <exit>
8010690d:	e9 9e fe ff ff       	jmp    801067b0 <trap+0xc0>
80106912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106918:	e8 b3 db ff ff       	call   801044d0 <exit>
8010691d:	eb bd                	jmp    801068dc <trap+0x1ec>
8010691f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106922:	e8 59 d0 ff ff       	call   80103980 <cpuid>
80106927:	83 ec 0c             	sub    $0xc,%esp
8010692a:	56                   	push   %esi
8010692b:	57                   	push   %edi
8010692c:	50                   	push   %eax
8010692d:	ff 73 30             	pushl  0x30(%ebx)
80106930:	68 80 87 10 80       	push   $0x80108780
80106935:	e8 76 9d ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010693a:	83 c4 14             	add    $0x14,%esp
8010693d:	68 54 87 10 80       	push   $0x80108754
80106942:	e8 49 9a ff ff       	call   80100390 <panic>
80106947:	66 90                	xchg   %ax,%ax
80106949:	66 90                	xchg   %ax,%ax
8010694b:	66 90                	xchg   %ax,%ax
8010694d:	66 90                	xchg   %ax,%ax
8010694f:	90                   	nop

80106950 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106950:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106954:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106959:	85 c0                	test   %eax,%eax
8010695b:	74 1b                	je     80106978 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010695d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106962:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106963:	a8 01                	test   $0x1,%al
80106965:	74 11                	je     80106978 <uartgetc+0x28>
80106967:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010696c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010696d:	0f b6 c0             	movzbl %al,%eax
80106970:	c3                   	ret    
80106971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010697d:	c3                   	ret    
8010697e:	66 90                	xchg   %ax,%ax

80106980 <uartputc.part.0>:
uartputc(int c)
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	89 c7                	mov    %eax,%edi
80106986:	56                   	push   %esi
80106987:	be fd 03 00 00       	mov    $0x3fd,%esi
8010698c:	53                   	push   %ebx
8010698d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106992:	83 ec 0c             	sub    $0xc,%esp
80106995:	eb 1b                	jmp    801069b2 <uartputc.part.0+0x32>
80106997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699e:	66 90                	xchg   %ax,%ax
    microdelay(10);
801069a0:	83 ec 0c             	sub    $0xc,%esp
801069a3:	6a 0a                	push   $0xa
801069a5:	e8 36 bf ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801069aa:	83 c4 10             	add    $0x10,%esp
801069ad:	83 eb 01             	sub    $0x1,%ebx
801069b0:	74 07                	je     801069b9 <uartputc.part.0+0x39>
801069b2:	89 f2                	mov    %esi,%edx
801069b4:	ec                   	in     (%dx),%al
801069b5:	a8 20                	test   $0x20,%al
801069b7:	74 e7                	je     801069a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069be:	89 f8                	mov    %edi,%eax
801069c0:	ee                   	out    %al,(%dx)
}
801069c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069c4:	5b                   	pop    %ebx
801069c5:	5e                   	pop    %esi
801069c6:	5f                   	pop    %edi
801069c7:	5d                   	pop    %ebp
801069c8:	c3                   	ret    
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069d0 <uartinit>:
{
801069d0:	f3 0f 1e fb          	endbr32 
801069d4:	55                   	push   %ebp
801069d5:	31 c9                	xor    %ecx,%ecx
801069d7:	89 c8                	mov    %ecx,%eax
801069d9:	89 e5                	mov    %esp,%ebp
801069db:	57                   	push   %edi
801069dc:	56                   	push   %esi
801069dd:	53                   	push   %ebx
801069de:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801069e3:	89 da                	mov    %ebx,%edx
801069e5:	83 ec 0c             	sub    $0xc,%esp
801069e8:	ee                   	out    %al,(%dx)
801069e9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801069ee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801069f3:	89 fa                	mov    %edi,%edx
801069f5:	ee                   	out    %al,(%dx)
801069f6:	b8 0c 00 00 00       	mov    $0xc,%eax
801069fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a00:	ee                   	out    %al,(%dx)
80106a01:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a06:	89 c8                	mov    %ecx,%eax
80106a08:	89 f2                	mov    %esi,%edx
80106a0a:	ee                   	out    %al,(%dx)
80106a0b:	b8 03 00 00 00       	mov    $0x3,%eax
80106a10:	89 fa                	mov    %edi,%edx
80106a12:	ee                   	out    %al,(%dx)
80106a13:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a18:	89 c8                	mov    %ecx,%eax
80106a1a:	ee                   	out    %al,(%dx)
80106a1b:	b8 01 00 00 00       	mov    $0x1,%eax
80106a20:	89 f2                	mov    %esi,%edx
80106a22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a23:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a28:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a29:	3c ff                	cmp    $0xff,%al
80106a2b:	74 52                	je     80106a7f <uartinit+0xaf>
  uart = 1;
80106a2d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106a34:	00 00 00 
80106a37:	89 da                	mov    %ebx,%edx
80106a39:	ec                   	in     (%dx),%al
80106a3a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a3f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106a40:	83 ec 08             	sub    $0x8,%esp
80106a43:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106a48:	bb 78 88 10 80       	mov    $0x80108878,%ebx
  ioapicenable(IRQ_COM1, 0);
80106a4d:	6a 00                	push   $0x0
80106a4f:	6a 04                	push   $0x4
80106a51:	e8 da b9 ff ff       	call   80102430 <ioapicenable>
80106a56:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a59:	b8 78 00 00 00       	mov    $0x78,%eax
80106a5e:	eb 04                	jmp    80106a64 <uartinit+0x94>
80106a60:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106a64:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106a6a:	85 d2                	test   %edx,%edx
80106a6c:	74 08                	je     80106a76 <uartinit+0xa6>
    uartputc(*p);
80106a6e:	0f be c0             	movsbl %al,%eax
80106a71:	e8 0a ff ff ff       	call   80106980 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106a76:	89 f0                	mov    %esi,%eax
80106a78:	83 c3 01             	add    $0x1,%ebx
80106a7b:	84 c0                	test   %al,%al
80106a7d:	75 e1                	jne    80106a60 <uartinit+0x90>
}
80106a7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a82:	5b                   	pop    %ebx
80106a83:	5e                   	pop    %esi
80106a84:	5f                   	pop    %edi
80106a85:	5d                   	pop    %ebp
80106a86:	c3                   	ret    
80106a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <uartputc>:
{
80106a90:	f3 0f 1e fb          	endbr32 
80106a94:	55                   	push   %ebp
  if(!uart)
80106a95:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106a9b:	89 e5                	mov    %esp,%ebp
80106a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106aa0:	85 d2                	test   %edx,%edx
80106aa2:	74 0c                	je     80106ab0 <uartputc+0x20>
}
80106aa4:	5d                   	pop    %ebp
80106aa5:	e9 d6 fe ff ff       	jmp    80106980 <uartputc.part.0>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ab0:	5d                   	pop    %ebp
80106ab1:	c3                   	ret    
80106ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <uartintr>:

void
uartintr(void)
{
80106ac0:	f3 0f 1e fb          	endbr32 
80106ac4:	55                   	push   %ebp
80106ac5:	89 e5                	mov    %esp,%ebp
80106ac7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106aca:	68 50 69 10 80       	push   $0x80106950
80106acf:	e8 8c 9d ff ff       	call   80100860 <consoleintr>
}
80106ad4:	83 c4 10             	add    $0x10,%esp
80106ad7:	c9                   	leave  
80106ad8:	c3                   	ret    

80106ad9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $0
80106adb:	6a 00                	push   $0x0
  jmp alltraps
80106add:	e9 31 fb ff ff       	jmp    80106613 <alltraps>

80106ae2 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $1
80106ae4:	6a 01                	push   $0x1
  jmp alltraps
80106ae6:	e9 28 fb ff ff       	jmp    80106613 <alltraps>

80106aeb <vector2>:
.globl vector2
vector2:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $2
80106aed:	6a 02                	push   $0x2
  jmp alltraps
80106aef:	e9 1f fb ff ff       	jmp    80106613 <alltraps>

80106af4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $3
80106af6:	6a 03                	push   $0x3
  jmp alltraps
80106af8:	e9 16 fb ff ff       	jmp    80106613 <alltraps>

80106afd <vector4>:
.globl vector4
vector4:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $4
80106aff:	6a 04                	push   $0x4
  jmp alltraps
80106b01:	e9 0d fb ff ff       	jmp    80106613 <alltraps>

80106b06 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $5
80106b08:	6a 05                	push   $0x5
  jmp alltraps
80106b0a:	e9 04 fb ff ff       	jmp    80106613 <alltraps>

80106b0f <vector6>:
.globl vector6
vector6:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $6
80106b11:	6a 06                	push   $0x6
  jmp alltraps
80106b13:	e9 fb fa ff ff       	jmp    80106613 <alltraps>

80106b18 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $7
80106b1a:	6a 07                	push   $0x7
  jmp alltraps
80106b1c:	e9 f2 fa ff ff       	jmp    80106613 <alltraps>

80106b21 <vector8>:
.globl vector8
vector8:
  pushl $8
80106b21:	6a 08                	push   $0x8
  jmp alltraps
80106b23:	e9 eb fa ff ff       	jmp    80106613 <alltraps>

80106b28 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $9
80106b2a:	6a 09                	push   $0x9
  jmp alltraps
80106b2c:	e9 e2 fa ff ff       	jmp    80106613 <alltraps>

80106b31 <vector10>:
.globl vector10
vector10:
  pushl $10
80106b31:	6a 0a                	push   $0xa
  jmp alltraps
80106b33:	e9 db fa ff ff       	jmp    80106613 <alltraps>

80106b38 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b38:	6a 0b                	push   $0xb
  jmp alltraps
80106b3a:	e9 d4 fa ff ff       	jmp    80106613 <alltraps>

80106b3f <vector12>:
.globl vector12
vector12:
  pushl $12
80106b3f:	6a 0c                	push   $0xc
  jmp alltraps
80106b41:	e9 cd fa ff ff       	jmp    80106613 <alltraps>

80106b46 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b46:	6a 0d                	push   $0xd
  jmp alltraps
80106b48:	e9 c6 fa ff ff       	jmp    80106613 <alltraps>

80106b4d <vector14>:
.globl vector14
vector14:
  pushl $14
80106b4d:	6a 0e                	push   $0xe
  jmp alltraps
80106b4f:	e9 bf fa ff ff       	jmp    80106613 <alltraps>

80106b54 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $15
80106b56:	6a 0f                	push   $0xf
  jmp alltraps
80106b58:	e9 b6 fa ff ff       	jmp    80106613 <alltraps>

80106b5d <vector16>:
.globl vector16
vector16:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $16
80106b5f:	6a 10                	push   $0x10
  jmp alltraps
80106b61:	e9 ad fa ff ff       	jmp    80106613 <alltraps>

80106b66 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b66:	6a 11                	push   $0x11
  jmp alltraps
80106b68:	e9 a6 fa ff ff       	jmp    80106613 <alltraps>

80106b6d <vector18>:
.globl vector18
vector18:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $18
80106b6f:	6a 12                	push   $0x12
  jmp alltraps
80106b71:	e9 9d fa ff ff       	jmp    80106613 <alltraps>

80106b76 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $19
80106b78:	6a 13                	push   $0x13
  jmp alltraps
80106b7a:	e9 94 fa ff ff       	jmp    80106613 <alltraps>

80106b7f <vector20>:
.globl vector20
vector20:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $20
80106b81:	6a 14                	push   $0x14
  jmp alltraps
80106b83:	e9 8b fa ff ff       	jmp    80106613 <alltraps>

80106b88 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $21
80106b8a:	6a 15                	push   $0x15
  jmp alltraps
80106b8c:	e9 82 fa ff ff       	jmp    80106613 <alltraps>

80106b91 <vector22>:
.globl vector22
vector22:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $22
80106b93:	6a 16                	push   $0x16
  jmp alltraps
80106b95:	e9 79 fa ff ff       	jmp    80106613 <alltraps>

80106b9a <vector23>:
.globl vector23
vector23:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $23
80106b9c:	6a 17                	push   $0x17
  jmp alltraps
80106b9e:	e9 70 fa ff ff       	jmp    80106613 <alltraps>

80106ba3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $24
80106ba5:	6a 18                	push   $0x18
  jmp alltraps
80106ba7:	e9 67 fa ff ff       	jmp    80106613 <alltraps>

80106bac <vector25>:
.globl vector25
vector25:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $25
80106bae:	6a 19                	push   $0x19
  jmp alltraps
80106bb0:	e9 5e fa ff ff       	jmp    80106613 <alltraps>

80106bb5 <vector26>:
.globl vector26
vector26:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $26
80106bb7:	6a 1a                	push   $0x1a
  jmp alltraps
80106bb9:	e9 55 fa ff ff       	jmp    80106613 <alltraps>

80106bbe <vector27>:
.globl vector27
vector27:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $27
80106bc0:	6a 1b                	push   $0x1b
  jmp alltraps
80106bc2:	e9 4c fa ff ff       	jmp    80106613 <alltraps>

80106bc7 <vector28>:
.globl vector28
vector28:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $28
80106bc9:	6a 1c                	push   $0x1c
  jmp alltraps
80106bcb:	e9 43 fa ff ff       	jmp    80106613 <alltraps>

80106bd0 <vector29>:
.globl vector29
vector29:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $29
80106bd2:	6a 1d                	push   $0x1d
  jmp alltraps
80106bd4:	e9 3a fa ff ff       	jmp    80106613 <alltraps>

80106bd9 <vector30>:
.globl vector30
vector30:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $30
80106bdb:	6a 1e                	push   $0x1e
  jmp alltraps
80106bdd:	e9 31 fa ff ff       	jmp    80106613 <alltraps>

80106be2 <vector31>:
.globl vector31
vector31:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $31
80106be4:	6a 1f                	push   $0x1f
  jmp alltraps
80106be6:	e9 28 fa ff ff       	jmp    80106613 <alltraps>

80106beb <vector32>:
.globl vector32
vector32:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $32
80106bed:	6a 20                	push   $0x20
  jmp alltraps
80106bef:	e9 1f fa ff ff       	jmp    80106613 <alltraps>

80106bf4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $33
80106bf6:	6a 21                	push   $0x21
  jmp alltraps
80106bf8:	e9 16 fa ff ff       	jmp    80106613 <alltraps>

80106bfd <vector34>:
.globl vector34
vector34:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $34
80106bff:	6a 22                	push   $0x22
  jmp alltraps
80106c01:	e9 0d fa ff ff       	jmp    80106613 <alltraps>

80106c06 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $35
80106c08:	6a 23                	push   $0x23
  jmp alltraps
80106c0a:	e9 04 fa ff ff       	jmp    80106613 <alltraps>

80106c0f <vector36>:
.globl vector36
vector36:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $36
80106c11:	6a 24                	push   $0x24
  jmp alltraps
80106c13:	e9 fb f9 ff ff       	jmp    80106613 <alltraps>

80106c18 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $37
80106c1a:	6a 25                	push   $0x25
  jmp alltraps
80106c1c:	e9 f2 f9 ff ff       	jmp    80106613 <alltraps>

80106c21 <vector38>:
.globl vector38
vector38:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $38
80106c23:	6a 26                	push   $0x26
  jmp alltraps
80106c25:	e9 e9 f9 ff ff       	jmp    80106613 <alltraps>

80106c2a <vector39>:
.globl vector39
vector39:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $39
80106c2c:	6a 27                	push   $0x27
  jmp alltraps
80106c2e:	e9 e0 f9 ff ff       	jmp    80106613 <alltraps>

80106c33 <vector40>:
.globl vector40
vector40:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $40
80106c35:	6a 28                	push   $0x28
  jmp alltraps
80106c37:	e9 d7 f9 ff ff       	jmp    80106613 <alltraps>

80106c3c <vector41>:
.globl vector41
vector41:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $41
80106c3e:	6a 29                	push   $0x29
  jmp alltraps
80106c40:	e9 ce f9 ff ff       	jmp    80106613 <alltraps>

80106c45 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $42
80106c47:	6a 2a                	push   $0x2a
  jmp alltraps
80106c49:	e9 c5 f9 ff ff       	jmp    80106613 <alltraps>

80106c4e <vector43>:
.globl vector43
vector43:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $43
80106c50:	6a 2b                	push   $0x2b
  jmp alltraps
80106c52:	e9 bc f9 ff ff       	jmp    80106613 <alltraps>

80106c57 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $44
80106c59:	6a 2c                	push   $0x2c
  jmp alltraps
80106c5b:	e9 b3 f9 ff ff       	jmp    80106613 <alltraps>

80106c60 <vector45>:
.globl vector45
vector45:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $45
80106c62:	6a 2d                	push   $0x2d
  jmp alltraps
80106c64:	e9 aa f9 ff ff       	jmp    80106613 <alltraps>

80106c69 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $46
80106c6b:	6a 2e                	push   $0x2e
  jmp alltraps
80106c6d:	e9 a1 f9 ff ff       	jmp    80106613 <alltraps>

80106c72 <vector47>:
.globl vector47
vector47:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $47
80106c74:	6a 2f                	push   $0x2f
  jmp alltraps
80106c76:	e9 98 f9 ff ff       	jmp    80106613 <alltraps>

80106c7b <vector48>:
.globl vector48
vector48:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $48
80106c7d:	6a 30                	push   $0x30
  jmp alltraps
80106c7f:	e9 8f f9 ff ff       	jmp    80106613 <alltraps>

80106c84 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $49
80106c86:	6a 31                	push   $0x31
  jmp alltraps
80106c88:	e9 86 f9 ff ff       	jmp    80106613 <alltraps>

80106c8d <vector50>:
.globl vector50
vector50:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $50
80106c8f:	6a 32                	push   $0x32
  jmp alltraps
80106c91:	e9 7d f9 ff ff       	jmp    80106613 <alltraps>

80106c96 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $51
80106c98:	6a 33                	push   $0x33
  jmp alltraps
80106c9a:	e9 74 f9 ff ff       	jmp    80106613 <alltraps>

80106c9f <vector52>:
.globl vector52
vector52:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $52
80106ca1:	6a 34                	push   $0x34
  jmp alltraps
80106ca3:	e9 6b f9 ff ff       	jmp    80106613 <alltraps>

80106ca8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $53
80106caa:	6a 35                	push   $0x35
  jmp alltraps
80106cac:	e9 62 f9 ff ff       	jmp    80106613 <alltraps>

80106cb1 <vector54>:
.globl vector54
vector54:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $54
80106cb3:	6a 36                	push   $0x36
  jmp alltraps
80106cb5:	e9 59 f9 ff ff       	jmp    80106613 <alltraps>

80106cba <vector55>:
.globl vector55
vector55:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $55
80106cbc:	6a 37                	push   $0x37
  jmp alltraps
80106cbe:	e9 50 f9 ff ff       	jmp    80106613 <alltraps>

80106cc3 <vector56>:
.globl vector56
vector56:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $56
80106cc5:	6a 38                	push   $0x38
  jmp alltraps
80106cc7:	e9 47 f9 ff ff       	jmp    80106613 <alltraps>

80106ccc <vector57>:
.globl vector57
vector57:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $57
80106cce:	6a 39                	push   $0x39
  jmp alltraps
80106cd0:	e9 3e f9 ff ff       	jmp    80106613 <alltraps>

80106cd5 <vector58>:
.globl vector58
vector58:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $58
80106cd7:	6a 3a                	push   $0x3a
  jmp alltraps
80106cd9:	e9 35 f9 ff ff       	jmp    80106613 <alltraps>

80106cde <vector59>:
.globl vector59
vector59:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $59
80106ce0:	6a 3b                	push   $0x3b
  jmp alltraps
80106ce2:	e9 2c f9 ff ff       	jmp    80106613 <alltraps>

80106ce7 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $60
80106ce9:	6a 3c                	push   $0x3c
  jmp alltraps
80106ceb:	e9 23 f9 ff ff       	jmp    80106613 <alltraps>

80106cf0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106cf0:	6a 00                	push   $0x0
  pushl $61
80106cf2:	6a 3d                	push   $0x3d
  jmp alltraps
80106cf4:	e9 1a f9 ff ff       	jmp    80106613 <alltraps>

80106cf9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $62
80106cfb:	6a 3e                	push   $0x3e
  jmp alltraps
80106cfd:	e9 11 f9 ff ff       	jmp    80106613 <alltraps>

80106d02 <vector63>:
.globl vector63
vector63:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $63
80106d04:	6a 3f                	push   $0x3f
  jmp alltraps
80106d06:	e9 08 f9 ff ff       	jmp    80106613 <alltraps>

80106d0b <vector64>:
.globl vector64
vector64:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $64
80106d0d:	6a 40                	push   $0x40
  jmp alltraps
80106d0f:	e9 ff f8 ff ff       	jmp    80106613 <alltraps>

80106d14 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $65
80106d16:	6a 41                	push   $0x41
  jmp alltraps
80106d18:	e9 f6 f8 ff ff       	jmp    80106613 <alltraps>

80106d1d <vector66>:
.globl vector66
vector66:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $66
80106d1f:	6a 42                	push   $0x42
  jmp alltraps
80106d21:	e9 ed f8 ff ff       	jmp    80106613 <alltraps>

80106d26 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $67
80106d28:	6a 43                	push   $0x43
  jmp alltraps
80106d2a:	e9 e4 f8 ff ff       	jmp    80106613 <alltraps>

80106d2f <vector68>:
.globl vector68
vector68:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $68
80106d31:	6a 44                	push   $0x44
  jmp alltraps
80106d33:	e9 db f8 ff ff       	jmp    80106613 <alltraps>

80106d38 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $69
80106d3a:	6a 45                	push   $0x45
  jmp alltraps
80106d3c:	e9 d2 f8 ff ff       	jmp    80106613 <alltraps>

80106d41 <vector70>:
.globl vector70
vector70:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $70
80106d43:	6a 46                	push   $0x46
  jmp alltraps
80106d45:	e9 c9 f8 ff ff       	jmp    80106613 <alltraps>

80106d4a <vector71>:
.globl vector71
vector71:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $71
80106d4c:	6a 47                	push   $0x47
  jmp alltraps
80106d4e:	e9 c0 f8 ff ff       	jmp    80106613 <alltraps>

80106d53 <vector72>:
.globl vector72
vector72:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $72
80106d55:	6a 48                	push   $0x48
  jmp alltraps
80106d57:	e9 b7 f8 ff ff       	jmp    80106613 <alltraps>

80106d5c <vector73>:
.globl vector73
vector73:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $73
80106d5e:	6a 49                	push   $0x49
  jmp alltraps
80106d60:	e9 ae f8 ff ff       	jmp    80106613 <alltraps>

80106d65 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $74
80106d67:	6a 4a                	push   $0x4a
  jmp alltraps
80106d69:	e9 a5 f8 ff ff       	jmp    80106613 <alltraps>

80106d6e <vector75>:
.globl vector75
vector75:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $75
80106d70:	6a 4b                	push   $0x4b
  jmp alltraps
80106d72:	e9 9c f8 ff ff       	jmp    80106613 <alltraps>

80106d77 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $76
80106d79:	6a 4c                	push   $0x4c
  jmp alltraps
80106d7b:	e9 93 f8 ff ff       	jmp    80106613 <alltraps>

80106d80 <vector77>:
.globl vector77
vector77:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $77
80106d82:	6a 4d                	push   $0x4d
  jmp alltraps
80106d84:	e9 8a f8 ff ff       	jmp    80106613 <alltraps>

80106d89 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $78
80106d8b:	6a 4e                	push   $0x4e
  jmp alltraps
80106d8d:	e9 81 f8 ff ff       	jmp    80106613 <alltraps>

80106d92 <vector79>:
.globl vector79
vector79:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $79
80106d94:	6a 4f                	push   $0x4f
  jmp alltraps
80106d96:	e9 78 f8 ff ff       	jmp    80106613 <alltraps>

80106d9b <vector80>:
.globl vector80
vector80:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $80
80106d9d:	6a 50                	push   $0x50
  jmp alltraps
80106d9f:	e9 6f f8 ff ff       	jmp    80106613 <alltraps>

80106da4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $81
80106da6:	6a 51                	push   $0x51
  jmp alltraps
80106da8:	e9 66 f8 ff ff       	jmp    80106613 <alltraps>

80106dad <vector82>:
.globl vector82
vector82:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $82
80106daf:	6a 52                	push   $0x52
  jmp alltraps
80106db1:	e9 5d f8 ff ff       	jmp    80106613 <alltraps>

80106db6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $83
80106db8:	6a 53                	push   $0x53
  jmp alltraps
80106dba:	e9 54 f8 ff ff       	jmp    80106613 <alltraps>

80106dbf <vector84>:
.globl vector84
vector84:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $84
80106dc1:	6a 54                	push   $0x54
  jmp alltraps
80106dc3:	e9 4b f8 ff ff       	jmp    80106613 <alltraps>

80106dc8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $85
80106dca:	6a 55                	push   $0x55
  jmp alltraps
80106dcc:	e9 42 f8 ff ff       	jmp    80106613 <alltraps>

80106dd1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $86
80106dd3:	6a 56                	push   $0x56
  jmp alltraps
80106dd5:	e9 39 f8 ff ff       	jmp    80106613 <alltraps>

80106dda <vector87>:
.globl vector87
vector87:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $87
80106ddc:	6a 57                	push   $0x57
  jmp alltraps
80106dde:	e9 30 f8 ff ff       	jmp    80106613 <alltraps>

80106de3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $88
80106de5:	6a 58                	push   $0x58
  jmp alltraps
80106de7:	e9 27 f8 ff ff       	jmp    80106613 <alltraps>

80106dec <vector89>:
.globl vector89
vector89:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $89
80106dee:	6a 59                	push   $0x59
  jmp alltraps
80106df0:	e9 1e f8 ff ff       	jmp    80106613 <alltraps>

80106df5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $90
80106df7:	6a 5a                	push   $0x5a
  jmp alltraps
80106df9:	e9 15 f8 ff ff       	jmp    80106613 <alltraps>

80106dfe <vector91>:
.globl vector91
vector91:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $91
80106e00:	6a 5b                	push   $0x5b
  jmp alltraps
80106e02:	e9 0c f8 ff ff       	jmp    80106613 <alltraps>

80106e07 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $92
80106e09:	6a 5c                	push   $0x5c
  jmp alltraps
80106e0b:	e9 03 f8 ff ff       	jmp    80106613 <alltraps>

80106e10 <vector93>:
.globl vector93
vector93:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $93
80106e12:	6a 5d                	push   $0x5d
  jmp alltraps
80106e14:	e9 fa f7 ff ff       	jmp    80106613 <alltraps>

80106e19 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $94
80106e1b:	6a 5e                	push   $0x5e
  jmp alltraps
80106e1d:	e9 f1 f7 ff ff       	jmp    80106613 <alltraps>

80106e22 <vector95>:
.globl vector95
vector95:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $95
80106e24:	6a 5f                	push   $0x5f
  jmp alltraps
80106e26:	e9 e8 f7 ff ff       	jmp    80106613 <alltraps>

80106e2b <vector96>:
.globl vector96
vector96:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $96
80106e2d:	6a 60                	push   $0x60
  jmp alltraps
80106e2f:	e9 df f7 ff ff       	jmp    80106613 <alltraps>

80106e34 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $97
80106e36:	6a 61                	push   $0x61
  jmp alltraps
80106e38:	e9 d6 f7 ff ff       	jmp    80106613 <alltraps>

80106e3d <vector98>:
.globl vector98
vector98:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $98
80106e3f:	6a 62                	push   $0x62
  jmp alltraps
80106e41:	e9 cd f7 ff ff       	jmp    80106613 <alltraps>

80106e46 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $99
80106e48:	6a 63                	push   $0x63
  jmp alltraps
80106e4a:	e9 c4 f7 ff ff       	jmp    80106613 <alltraps>

80106e4f <vector100>:
.globl vector100
vector100:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $100
80106e51:	6a 64                	push   $0x64
  jmp alltraps
80106e53:	e9 bb f7 ff ff       	jmp    80106613 <alltraps>

80106e58 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $101
80106e5a:	6a 65                	push   $0x65
  jmp alltraps
80106e5c:	e9 b2 f7 ff ff       	jmp    80106613 <alltraps>

80106e61 <vector102>:
.globl vector102
vector102:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $102
80106e63:	6a 66                	push   $0x66
  jmp alltraps
80106e65:	e9 a9 f7 ff ff       	jmp    80106613 <alltraps>

80106e6a <vector103>:
.globl vector103
vector103:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $103
80106e6c:	6a 67                	push   $0x67
  jmp alltraps
80106e6e:	e9 a0 f7 ff ff       	jmp    80106613 <alltraps>

80106e73 <vector104>:
.globl vector104
vector104:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $104
80106e75:	6a 68                	push   $0x68
  jmp alltraps
80106e77:	e9 97 f7 ff ff       	jmp    80106613 <alltraps>

80106e7c <vector105>:
.globl vector105
vector105:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $105
80106e7e:	6a 69                	push   $0x69
  jmp alltraps
80106e80:	e9 8e f7 ff ff       	jmp    80106613 <alltraps>

80106e85 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $106
80106e87:	6a 6a                	push   $0x6a
  jmp alltraps
80106e89:	e9 85 f7 ff ff       	jmp    80106613 <alltraps>

80106e8e <vector107>:
.globl vector107
vector107:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $107
80106e90:	6a 6b                	push   $0x6b
  jmp alltraps
80106e92:	e9 7c f7 ff ff       	jmp    80106613 <alltraps>

80106e97 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $108
80106e99:	6a 6c                	push   $0x6c
  jmp alltraps
80106e9b:	e9 73 f7 ff ff       	jmp    80106613 <alltraps>

80106ea0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $109
80106ea2:	6a 6d                	push   $0x6d
  jmp alltraps
80106ea4:	e9 6a f7 ff ff       	jmp    80106613 <alltraps>

80106ea9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $110
80106eab:	6a 6e                	push   $0x6e
  jmp alltraps
80106ead:	e9 61 f7 ff ff       	jmp    80106613 <alltraps>

80106eb2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $111
80106eb4:	6a 6f                	push   $0x6f
  jmp alltraps
80106eb6:	e9 58 f7 ff ff       	jmp    80106613 <alltraps>

80106ebb <vector112>:
.globl vector112
vector112:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $112
80106ebd:	6a 70                	push   $0x70
  jmp alltraps
80106ebf:	e9 4f f7 ff ff       	jmp    80106613 <alltraps>

80106ec4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $113
80106ec6:	6a 71                	push   $0x71
  jmp alltraps
80106ec8:	e9 46 f7 ff ff       	jmp    80106613 <alltraps>

80106ecd <vector114>:
.globl vector114
vector114:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $114
80106ecf:	6a 72                	push   $0x72
  jmp alltraps
80106ed1:	e9 3d f7 ff ff       	jmp    80106613 <alltraps>

80106ed6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $115
80106ed8:	6a 73                	push   $0x73
  jmp alltraps
80106eda:	e9 34 f7 ff ff       	jmp    80106613 <alltraps>

80106edf <vector116>:
.globl vector116
vector116:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $116
80106ee1:	6a 74                	push   $0x74
  jmp alltraps
80106ee3:	e9 2b f7 ff ff       	jmp    80106613 <alltraps>

80106ee8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $117
80106eea:	6a 75                	push   $0x75
  jmp alltraps
80106eec:	e9 22 f7 ff ff       	jmp    80106613 <alltraps>

80106ef1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $118
80106ef3:	6a 76                	push   $0x76
  jmp alltraps
80106ef5:	e9 19 f7 ff ff       	jmp    80106613 <alltraps>

80106efa <vector119>:
.globl vector119
vector119:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $119
80106efc:	6a 77                	push   $0x77
  jmp alltraps
80106efe:	e9 10 f7 ff ff       	jmp    80106613 <alltraps>

80106f03 <vector120>:
.globl vector120
vector120:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $120
80106f05:	6a 78                	push   $0x78
  jmp alltraps
80106f07:	e9 07 f7 ff ff       	jmp    80106613 <alltraps>

80106f0c <vector121>:
.globl vector121
vector121:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $121
80106f0e:	6a 79                	push   $0x79
  jmp alltraps
80106f10:	e9 fe f6 ff ff       	jmp    80106613 <alltraps>

80106f15 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $122
80106f17:	6a 7a                	push   $0x7a
  jmp alltraps
80106f19:	e9 f5 f6 ff ff       	jmp    80106613 <alltraps>

80106f1e <vector123>:
.globl vector123
vector123:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $123
80106f20:	6a 7b                	push   $0x7b
  jmp alltraps
80106f22:	e9 ec f6 ff ff       	jmp    80106613 <alltraps>

80106f27 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $124
80106f29:	6a 7c                	push   $0x7c
  jmp alltraps
80106f2b:	e9 e3 f6 ff ff       	jmp    80106613 <alltraps>

80106f30 <vector125>:
.globl vector125
vector125:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $125
80106f32:	6a 7d                	push   $0x7d
  jmp alltraps
80106f34:	e9 da f6 ff ff       	jmp    80106613 <alltraps>

80106f39 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $126
80106f3b:	6a 7e                	push   $0x7e
  jmp alltraps
80106f3d:	e9 d1 f6 ff ff       	jmp    80106613 <alltraps>

80106f42 <vector127>:
.globl vector127
vector127:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $127
80106f44:	6a 7f                	push   $0x7f
  jmp alltraps
80106f46:	e9 c8 f6 ff ff       	jmp    80106613 <alltraps>

80106f4b <vector128>:
.globl vector128
vector128:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $128
80106f4d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f52:	e9 bc f6 ff ff       	jmp    80106613 <alltraps>

80106f57 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $129
80106f59:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f5e:	e9 b0 f6 ff ff       	jmp    80106613 <alltraps>

80106f63 <vector130>:
.globl vector130
vector130:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $130
80106f65:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f6a:	e9 a4 f6 ff ff       	jmp    80106613 <alltraps>

80106f6f <vector131>:
.globl vector131
vector131:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $131
80106f71:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f76:	e9 98 f6 ff ff       	jmp    80106613 <alltraps>

80106f7b <vector132>:
.globl vector132
vector132:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $132
80106f7d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f82:	e9 8c f6 ff ff       	jmp    80106613 <alltraps>

80106f87 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $133
80106f89:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f8e:	e9 80 f6 ff ff       	jmp    80106613 <alltraps>

80106f93 <vector134>:
.globl vector134
vector134:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $134
80106f95:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f9a:	e9 74 f6 ff ff       	jmp    80106613 <alltraps>

80106f9f <vector135>:
.globl vector135
vector135:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $135
80106fa1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106fa6:	e9 68 f6 ff ff       	jmp    80106613 <alltraps>

80106fab <vector136>:
.globl vector136
vector136:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $136
80106fad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106fb2:	e9 5c f6 ff ff       	jmp    80106613 <alltraps>

80106fb7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $137
80106fb9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106fbe:	e9 50 f6 ff ff       	jmp    80106613 <alltraps>

80106fc3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $138
80106fc5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106fca:	e9 44 f6 ff ff       	jmp    80106613 <alltraps>

80106fcf <vector139>:
.globl vector139
vector139:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $139
80106fd1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106fd6:	e9 38 f6 ff ff       	jmp    80106613 <alltraps>

80106fdb <vector140>:
.globl vector140
vector140:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $140
80106fdd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106fe2:	e9 2c f6 ff ff       	jmp    80106613 <alltraps>

80106fe7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $141
80106fe9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106fee:	e9 20 f6 ff ff       	jmp    80106613 <alltraps>

80106ff3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $142
80106ff5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ffa:	e9 14 f6 ff ff       	jmp    80106613 <alltraps>

80106fff <vector143>:
.globl vector143
vector143:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $143
80107001:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107006:	e9 08 f6 ff ff       	jmp    80106613 <alltraps>

8010700b <vector144>:
.globl vector144
vector144:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $144
8010700d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107012:	e9 fc f5 ff ff       	jmp    80106613 <alltraps>

80107017 <vector145>:
.globl vector145
vector145:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $145
80107019:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010701e:	e9 f0 f5 ff ff       	jmp    80106613 <alltraps>

80107023 <vector146>:
.globl vector146
vector146:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $146
80107025:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010702a:	e9 e4 f5 ff ff       	jmp    80106613 <alltraps>

8010702f <vector147>:
.globl vector147
vector147:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $147
80107031:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107036:	e9 d8 f5 ff ff       	jmp    80106613 <alltraps>

8010703b <vector148>:
.globl vector148
vector148:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $148
8010703d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107042:	e9 cc f5 ff ff       	jmp    80106613 <alltraps>

80107047 <vector149>:
.globl vector149
vector149:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $149
80107049:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010704e:	e9 c0 f5 ff ff       	jmp    80106613 <alltraps>

80107053 <vector150>:
.globl vector150
vector150:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $150
80107055:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010705a:	e9 b4 f5 ff ff       	jmp    80106613 <alltraps>

8010705f <vector151>:
.globl vector151
vector151:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $151
80107061:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107066:	e9 a8 f5 ff ff       	jmp    80106613 <alltraps>

8010706b <vector152>:
.globl vector152
vector152:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $152
8010706d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107072:	e9 9c f5 ff ff       	jmp    80106613 <alltraps>

80107077 <vector153>:
.globl vector153
vector153:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $153
80107079:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010707e:	e9 90 f5 ff ff       	jmp    80106613 <alltraps>

80107083 <vector154>:
.globl vector154
vector154:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $154
80107085:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010708a:	e9 84 f5 ff ff       	jmp    80106613 <alltraps>

8010708f <vector155>:
.globl vector155
vector155:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $155
80107091:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107096:	e9 78 f5 ff ff       	jmp    80106613 <alltraps>

8010709b <vector156>:
.globl vector156
vector156:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $156
8010709d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070a2:	e9 6c f5 ff ff       	jmp    80106613 <alltraps>

801070a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $157
801070a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070ae:	e9 60 f5 ff ff       	jmp    80106613 <alltraps>

801070b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $158
801070b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801070ba:	e9 54 f5 ff ff       	jmp    80106613 <alltraps>

801070bf <vector159>:
.globl vector159
vector159:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $159
801070c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801070c6:	e9 48 f5 ff ff       	jmp    80106613 <alltraps>

801070cb <vector160>:
.globl vector160
vector160:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $160
801070cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801070d2:	e9 3c f5 ff ff       	jmp    80106613 <alltraps>

801070d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $161
801070d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801070de:	e9 30 f5 ff ff       	jmp    80106613 <alltraps>

801070e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $162
801070e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801070ea:	e9 24 f5 ff ff       	jmp    80106613 <alltraps>

801070ef <vector163>:
.globl vector163
vector163:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $163
801070f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801070f6:	e9 18 f5 ff ff       	jmp    80106613 <alltraps>

801070fb <vector164>:
.globl vector164
vector164:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $164
801070fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107102:	e9 0c f5 ff ff       	jmp    80106613 <alltraps>

80107107 <vector165>:
.globl vector165
vector165:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $165
80107109:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010710e:	e9 00 f5 ff ff       	jmp    80106613 <alltraps>

80107113 <vector166>:
.globl vector166
vector166:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $166
80107115:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010711a:	e9 f4 f4 ff ff       	jmp    80106613 <alltraps>

8010711f <vector167>:
.globl vector167
vector167:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $167
80107121:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107126:	e9 e8 f4 ff ff       	jmp    80106613 <alltraps>

8010712b <vector168>:
.globl vector168
vector168:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $168
8010712d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107132:	e9 dc f4 ff ff       	jmp    80106613 <alltraps>

80107137 <vector169>:
.globl vector169
vector169:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $169
80107139:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010713e:	e9 d0 f4 ff ff       	jmp    80106613 <alltraps>

80107143 <vector170>:
.globl vector170
vector170:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $170
80107145:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010714a:	e9 c4 f4 ff ff       	jmp    80106613 <alltraps>

8010714f <vector171>:
.globl vector171
vector171:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $171
80107151:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107156:	e9 b8 f4 ff ff       	jmp    80106613 <alltraps>

8010715b <vector172>:
.globl vector172
vector172:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $172
8010715d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107162:	e9 ac f4 ff ff       	jmp    80106613 <alltraps>

80107167 <vector173>:
.globl vector173
vector173:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $173
80107169:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010716e:	e9 a0 f4 ff ff       	jmp    80106613 <alltraps>

80107173 <vector174>:
.globl vector174
vector174:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $174
80107175:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010717a:	e9 94 f4 ff ff       	jmp    80106613 <alltraps>

8010717f <vector175>:
.globl vector175
vector175:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $175
80107181:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107186:	e9 88 f4 ff ff       	jmp    80106613 <alltraps>

8010718b <vector176>:
.globl vector176
vector176:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $176
8010718d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107192:	e9 7c f4 ff ff       	jmp    80106613 <alltraps>

80107197 <vector177>:
.globl vector177
vector177:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $177
80107199:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010719e:	e9 70 f4 ff ff       	jmp    80106613 <alltraps>

801071a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $178
801071a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071aa:	e9 64 f4 ff ff       	jmp    80106613 <alltraps>

801071af <vector179>:
.globl vector179
vector179:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $179
801071b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801071b6:	e9 58 f4 ff ff       	jmp    80106613 <alltraps>

801071bb <vector180>:
.globl vector180
vector180:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $180
801071bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801071c2:	e9 4c f4 ff ff       	jmp    80106613 <alltraps>

801071c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $181
801071c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801071ce:	e9 40 f4 ff ff       	jmp    80106613 <alltraps>

801071d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $182
801071d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801071da:	e9 34 f4 ff ff       	jmp    80106613 <alltraps>

801071df <vector183>:
.globl vector183
vector183:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $183
801071e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801071e6:	e9 28 f4 ff ff       	jmp    80106613 <alltraps>

801071eb <vector184>:
.globl vector184
vector184:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $184
801071ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801071f2:	e9 1c f4 ff ff       	jmp    80106613 <alltraps>

801071f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $185
801071f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801071fe:	e9 10 f4 ff ff       	jmp    80106613 <alltraps>

80107203 <vector186>:
.globl vector186
vector186:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $186
80107205:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010720a:	e9 04 f4 ff ff       	jmp    80106613 <alltraps>

8010720f <vector187>:
.globl vector187
vector187:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $187
80107211:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107216:	e9 f8 f3 ff ff       	jmp    80106613 <alltraps>

8010721b <vector188>:
.globl vector188
vector188:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $188
8010721d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107222:	e9 ec f3 ff ff       	jmp    80106613 <alltraps>

80107227 <vector189>:
.globl vector189
vector189:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $189
80107229:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010722e:	e9 e0 f3 ff ff       	jmp    80106613 <alltraps>

80107233 <vector190>:
.globl vector190
vector190:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $190
80107235:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010723a:	e9 d4 f3 ff ff       	jmp    80106613 <alltraps>

8010723f <vector191>:
.globl vector191
vector191:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $191
80107241:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107246:	e9 c8 f3 ff ff       	jmp    80106613 <alltraps>

8010724b <vector192>:
.globl vector192
vector192:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $192
8010724d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107252:	e9 bc f3 ff ff       	jmp    80106613 <alltraps>

80107257 <vector193>:
.globl vector193
vector193:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $193
80107259:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010725e:	e9 b0 f3 ff ff       	jmp    80106613 <alltraps>

80107263 <vector194>:
.globl vector194
vector194:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $194
80107265:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010726a:	e9 a4 f3 ff ff       	jmp    80106613 <alltraps>

8010726f <vector195>:
.globl vector195
vector195:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $195
80107271:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107276:	e9 98 f3 ff ff       	jmp    80106613 <alltraps>

8010727b <vector196>:
.globl vector196
vector196:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $196
8010727d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107282:	e9 8c f3 ff ff       	jmp    80106613 <alltraps>

80107287 <vector197>:
.globl vector197
vector197:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $197
80107289:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010728e:	e9 80 f3 ff ff       	jmp    80106613 <alltraps>

80107293 <vector198>:
.globl vector198
vector198:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $198
80107295:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010729a:	e9 74 f3 ff ff       	jmp    80106613 <alltraps>

8010729f <vector199>:
.globl vector199
vector199:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $199
801072a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072a6:	e9 68 f3 ff ff       	jmp    80106613 <alltraps>

801072ab <vector200>:
.globl vector200
vector200:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $200
801072ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072b2:	e9 5c f3 ff ff       	jmp    80106613 <alltraps>

801072b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $201
801072b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801072be:	e9 50 f3 ff ff       	jmp    80106613 <alltraps>

801072c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $202
801072c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801072ca:	e9 44 f3 ff ff       	jmp    80106613 <alltraps>

801072cf <vector203>:
.globl vector203
vector203:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $203
801072d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801072d6:	e9 38 f3 ff ff       	jmp    80106613 <alltraps>

801072db <vector204>:
.globl vector204
vector204:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $204
801072dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801072e2:	e9 2c f3 ff ff       	jmp    80106613 <alltraps>

801072e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $205
801072e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801072ee:	e9 20 f3 ff ff       	jmp    80106613 <alltraps>

801072f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $206
801072f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801072fa:	e9 14 f3 ff ff       	jmp    80106613 <alltraps>

801072ff <vector207>:
.globl vector207
vector207:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $207
80107301:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107306:	e9 08 f3 ff ff       	jmp    80106613 <alltraps>

8010730b <vector208>:
.globl vector208
vector208:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $208
8010730d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107312:	e9 fc f2 ff ff       	jmp    80106613 <alltraps>

80107317 <vector209>:
.globl vector209
vector209:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $209
80107319:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010731e:	e9 f0 f2 ff ff       	jmp    80106613 <alltraps>

80107323 <vector210>:
.globl vector210
vector210:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $210
80107325:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010732a:	e9 e4 f2 ff ff       	jmp    80106613 <alltraps>

8010732f <vector211>:
.globl vector211
vector211:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $211
80107331:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107336:	e9 d8 f2 ff ff       	jmp    80106613 <alltraps>

8010733b <vector212>:
.globl vector212
vector212:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $212
8010733d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107342:	e9 cc f2 ff ff       	jmp    80106613 <alltraps>

80107347 <vector213>:
.globl vector213
vector213:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $213
80107349:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010734e:	e9 c0 f2 ff ff       	jmp    80106613 <alltraps>

80107353 <vector214>:
.globl vector214
vector214:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $214
80107355:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010735a:	e9 b4 f2 ff ff       	jmp    80106613 <alltraps>

8010735f <vector215>:
.globl vector215
vector215:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $215
80107361:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107366:	e9 a8 f2 ff ff       	jmp    80106613 <alltraps>

8010736b <vector216>:
.globl vector216
vector216:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $216
8010736d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107372:	e9 9c f2 ff ff       	jmp    80106613 <alltraps>

80107377 <vector217>:
.globl vector217
vector217:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $217
80107379:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010737e:	e9 90 f2 ff ff       	jmp    80106613 <alltraps>

80107383 <vector218>:
.globl vector218
vector218:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $218
80107385:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010738a:	e9 84 f2 ff ff       	jmp    80106613 <alltraps>

8010738f <vector219>:
.globl vector219
vector219:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $219
80107391:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107396:	e9 78 f2 ff ff       	jmp    80106613 <alltraps>

8010739b <vector220>:
.globl vector220
vector220:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $220
8010739d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073a2:	e9 6c f2 ff ff       	jmp    80106613 <alltraps>

801073a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $221
801073a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073ae:	e9 60 f2 ff ff       	jmp    80106613 <alltraps>

801073b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $222
801073b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801073ba:	e9 54 f2 ff ff       	jmp    80106613 <alltraps>

801073bf <vector223>:
.globl vector223
vector223:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $223
801073c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801073c6:	e9 48 f2 ff ff       	jmp    80106613 <alltraps>

801073cb <vector224>:
.globl vector224
vector224:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $224
801073cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801073d2:	e9 3c f2 ff ff       	jmp    80106613 <alltraps>

801073d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $225
801073d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801073de:	e9 30 f2 ff ff       	jmp    80106613 <alltraps>

801073e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $226
801073e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801073ea:	e9 24 f2 ff ff       	jmp    80106613 <alltraps>

801073ef <vector227>:
.globl vector227
vector227:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $227
801073f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801073f6:	e9 18 f2 ff ff       	jmp    80106613 <alltraps>

801073fb <vector228>:
.globl vector228
vector228:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $228
801073fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107402:	e9 0c f2 ff ff       	jmp    80106613 <alltraps>

80107407 <vector229>:
.globl vector229
vector229:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $229
80107409:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010740e:	e9 00 f2 ff ff       	jmp    80106613 <alltraps>

80107413 <vector230>:
.globl vector230
vector230:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $230
80107415:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010741a:	e9 f4 f1 ff ff       	jmp    80106613 <alltraps>

8010741f <vector231>:
.globl vector231
vector231:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $231
80107421:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107426:	e9 e8 f1 ff ff       	jmp    80106613 <alltraps>

8010742b <vector232>:
.globl vector232
vector232:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $232
8010742d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107432:	e9 dc f1 ff ff       	jmp    80106613 <alltraps>

80107437 <vector233>:
.globl vector233
vector233:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $233
80107439:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010743e:	e9 d0 f1 ff ff       	jmp    80106613 <alltraps>

80107443 <vector234>:
.globl vector234
vector234:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $234
80107445:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010744a:	e9 c4 f1 ff ff       	jmp    80106613 <alltraps>

8010744f <vector235>:
.globl vector235
vector235:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $235
80107451:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107456:	e9 b8 f1 ff ff       	jmp    80106613 <alltraps>

8010745b <vector236>:
.globl vector236
vector236:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $236
8010745d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107462:	e9 ac f1 ff ff       	jmp    80106613 <alltraps>

80107467 <vector237>:
.globl vector237
vector237:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $237
80107469:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010746e:	e9 a0 f1 ff ff       	jmp    80106613 <alltraps>

80107473 <vector238>:
.globl vector238
vector238:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $238
80107475:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010747a:	e9 94 f1 ff ff       	jmp    80106613 <alltraps>

8010747f <vector239>:
.globl vector239
vector239:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $239
80107481:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107486:	e9 88 f1 ff ff       	jmp    80106613 <alltraps>

8010748b <vector240>:
.globl vector240
vector240:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $240
8010748d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107492:	e9 7c f1 ff ff       	jmp    80106613 <alltraps>

80107497 <vector241>:
.globl vector241
vector241:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $241
80107499:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010749e:	e9 70 f1 ff ff       	jmp    80106613 <alltraps>

801074a3 <vector242>:
.globl vector242
vector242:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $242
801074a5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074aa:	e9 64 f1 ff ff       	jmp    80106613 <alltraps>

801074af <vector243>:
.globl vector243
vector243:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $243
801074b1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801074b6:	e9 58 f1 ff ff       	jmp    80106613 <alltraps>

801074bb <vector244>:
.globl vector244
vector244:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $244
801074bd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801074c2:	e9 4c f1 ff ff       	jmp    80106613 <alltraps>

801074c7 <vector245>:
.globl vector245
vector245:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $245
801074c9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801074ce:	e9 40 f1 ff ff       	jmp    80106613 <alltraps>

801074d3 <vector246>:
.globl vector246
vector246:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $246
801074d5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801074da:	e9 34 f1 ff ff       	jmp    80106613 <alltraps>

801074df <vector247>:
.globl vector247
vector247:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $247
801074e1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801074e6:	e9 28 f1 ff ff       	jmp    80106613 <alltraps>

801074eb <vector248>:
.globl vector248
vector248:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $248
801074ed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801074f2:	e9 1c f1 ff ff       	jmp    80106613 <alltraps>

801074f7 <vector249>:
.globl vector249
vector249:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $249
801074f9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801074fe:	e9 10 f1 ff ff       	jmp    80106613 <alltraps>

80107503 <vector250>:
.globl vector250
vector250:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $250
80107505:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010750a:	e9 04 f1 ff ff       	jmp    80106613 <alltraps>

8010750f <vector251>:
.globl vector251
vector251:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $251
80107511:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107516:	e9 f8 f0 ff ff       	jmp    80106613 <alltraps>

8010751b <vector252>:
.globl vector252
vector252:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $252
8010751d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107522:	e9 ec f0 ff ff       	jmp    80106613 <alltraps>

80107527 <vector253>:
.globl vector253
vector253:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $253
80107529:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010752e:	e9 e0 f0 ff ff       	jmp    80106613 <alltraps>

80107533 <vector254>:
.globl vector254
vector254:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $254
80107535:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010753a:	e9 d4 f0 ff ff       	jmp    80106613 <alltraps>

8010753f <vector255>:
.globl vector255
vector255:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $255
80107541:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107546:	e9 c8 f0 ff ff       	jmp    80106613 <alltraps>
8010754b:	66 90                	xchg   %ax,%ax
8010754d:	66 90                	xchg   %ax,%ax
8010754f:	90                   	nop

80107550 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107557:	c1 ea 16             	shr    $0x16,%edx
{
8010755a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010755b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010755e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107561:	8b 1f                	mov    (%edi),%ebx
80107563:	f6 c3 01             	test   $0x1,%bl
80107566:	74 28                	je     80107590 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107568:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010756e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107574:	89 f0                	mov    %esi,%eax
}
80107576:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107579:	c1 e8 0a             	shr    $0xa,%eax
8010757c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107581:	01 d8                	add    %ebx,%eax
}
80107583:	5b                   	pop    %ebx
80107584:	5e                   	pop    %esi
80107585:	5f                   	pop    %edi
80107586:	5d                   	pop    %ebp
80107587:	c3                   	ret    
80107588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107590:	85 c9                	test   %ecx,%ecx
80107592:	74 2c                	je     801075c0 <walkpgdir+0x70>
80107594:	e8 97 b0 ff ff       	call   80102630 <kalloc>
80107599:	89 c3                	mov    %eax,%ebx
8010759b:	85 c0                	test   %eax,%eax
8010759d:	74 21                	je     801075c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010759f:	83 ec 04             	sub    $0x4,%esp
801075a2:	68 00 10 00 00       	push   $0x1000
801075a7:	6a 00                	push   $0x0
801075a9:	50                   	push   %eax
801075aa:	e8 71 d8 ff ff       	call   80104e20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075b5:	83 c4 10             	add    $0x10,%esp
801075b8:	83 c8 07             	or     $0x7,%eax
801075bb:	89 07                	mov    %eax,(%edi)
801075bd:	eb b5                	jmp    80107574 <walkpgdir+0x24>
801075bf:	90                   	nop
}
801075c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801075c3:	31 c0                	xor    %eax,%eax
}
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801075d6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801075da:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801075db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801075e0:	89 d6                	mov    %edx,%esi
{
801075e2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801075e3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801075e9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801075ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075ef:	8b 45 08             	mov    0x8(%ebp),%eax
801075f2:	29 f0                	sub    %esi,%eax
801075f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075f7:	eb 1f                	jmp    80107618 <mappages+0x48>
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107600:	f6 00 01             	testb  $0x1,(%eax)
80107603:	75 45                	jne    8010764a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107605:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107608:	83 cb 01             	or     $0x1,%ebx
8010760b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010760d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107610:	74 2e                	je     80107640 <mappages+0x70>
      break;
    a += PGSIZE;
80107612:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010761b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107620:	89 f2                	mov    %esi,%edx
80107622:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107625:	89 f8                	mov    %edi,%eax
80107627:	e8 24 ff ff ff       	call   80107550 <walkpgdir>
8010762c:	85 c0                	test   %eax,%eax
8010762e:	75 d0                	jne    80107600 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107630:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107633:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107638:	5b                   	pop    %ebx
80107639:	5e                   	pop    %esi
8010763a:	5f                   	pop    %edi
8010763b:	5d                   	pop    %ebp
8010763c:	c3                   	ret    
8010763d:	8d 76 00             	lea    0x0(%esi),%esi
80107640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107643:	31 c0                	xor    %eax,%eax
}
80107645:	5b                   	pop    %ebx
80107646:	5e                   	pop    %esi
80107647:	5f                   	pop    %edi
80107648:	5d                   	pop    %ebp
80107649:	c3                   	ret    
      panic("remap");
8010764a:	83 ec 0c             	sub    $0xc,%esp
8010764d:	68 80 88 10 80       	push   $0x80108880
80107652:	e8 39 8d ff ff       	call   80100390 <panic>
80107657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765e:	66 90                	xchg   %ax,%ax

80107660 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	89 c6                	mov    %eax,%esi
80107667:	53                   	push   %ebx
80107668:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010766a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107670:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107676:	83 ec 1c             	sub    $0x1c,%esp
80107679:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010767c:	39 da                	cmp    %ebx,%edx
8010767e:	73 5b                	jae    801076db <deallocuvm.part.0+0x7b>
80107680:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107683:	89 d7                	mov    %edx,%edi
80107685:	eb 14                	jmp    8010769b <deallocuvm.part.0+0x3b>
80107687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768e:	66 90                	xchg   %ax,%ax
80107690:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107696:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107699:	76 40                	jbe    801076db <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010769b:	31 c9                	xor    %ecx,%ecx
8010769d:	89 fa                	mov    %edi,%edx
8010769f:	89 f0                	mov    %esi,%eax
801076a1:	e8 aa fe ff ff       	call   80107550 <walkpgdir>
801076a6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801076a8:	85 c0                	test   %eax,%eax
801076aa:	74 44                	je     801076f0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801076ac:	8b 00                	mov    (%eax),%eax
801076ae:	a8 01                	test   $0x1,%al
801076b0:	74 de                	je     80107690 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801076b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076b7:	74 47                	je     80107700 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801076b9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076bc:	05 00 00 00 80       	add    $0x80000000,%eax
801076c1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801076c7:	50                   	push   %eax
801076c8:	e8 a3 ad ff ff       	call   80102470 <kfree>
      *pte = 0;
801076cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801076d3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801076d6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801076d9:	77 c0                	ja     8010769b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801076db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e1:	5b                   	pop    %ebx
801076e2:	5e                   	pop    %esi
801076e3:	5f                   	pop    %edi
801076e4:	5d                   	pop    %ebp
801076e5:	c3                   	ret    
801076e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801076f0:	89 fa                	mov    %edi,%edx
801076f2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801076f8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801076fe:	eb 96                	jmp    80107696 <deallocuvm.part.0+0x36>
        panic("kfree");
80107700:	83 ec 0c             	sub    $0xc,%esp
80107703:	68 06 81 10 80       	push   $0x80108106
80107708:	e8 83 8c ff ff       	call   80100390 <panic>
8010770d:	8d 76 00             	lea    0x0(%esi),%esi

80107710 <seginit>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010771a:	e8 61 c2 ff ff       	call   80103980 <cpuid>
  pd[0] = size-1;
8010771f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107724:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010772a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010772e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107735:	ff 00 00 
80107738:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010773f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107742:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107749:	ff 00 00 
8010774c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107753:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107756:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010775d:	ff 00 00 
80107760:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107767:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010776a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107771:	ff 00 00 
80107774:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
8010777b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010777e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107783:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107787:	c1 e8 10             	shr    $0x10,%eax
8010778a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010778e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107791:	0f 01 10             	lgdtl  (%eax)
}
80107794:	c9                   	leave  
80107795:	c3                   	ret    
80107796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779d:	8d 76 00             	lea    0x0(%esi),%esi

801077a0 <switchkvm>:
{
801077a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077a4:	a1 a4 6d 11 80       	mov    0x80116da4,%eax
801077a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077ae:	0f 22 d8             	mov    %eax,%cr3
}
801077b1:	c3                   	ret    
801077b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077c0 <switchuvm>:
{
801077c0:	f3 0f 1e fb          	endbr32 
801077c4:	55                   	push   %ebp
801077c5:	89 e5                	mov    %esp,%ebp
801077c7:	57                   	push   %edi
801077c8:	56                   	push   %esi
801077c9:	53                   	push   %ebx
801077ca:	83 ec 1c             	sub    $0x1c,%esp
801077cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801077d0:	85 f6                	test   %esi,%esi
801077d2:	0f 84 cb 00 00 00    	je     801078a3 <switchuvm+0xe3>
  if(p->kstack == 0)
801077d8:	8b 46 08             	mov    0x8(%esi),%eax
801077db:	85 c0                	test   %eax,%eax
801077dd:	0f 84 da 00 00 00    	je     801078bd <switchuvm+0xfd>
  if(p->pgdir == 0)
801077e3:	8b 46 04             	mov    0x4(%esi),%eax
801077e6:	85 c0                	test   %eax,%eax
801077e8:	0f 84 c2 00 00 00    	je     801078b0 <switchuvm+0xf0>
  pushcli();
801077ee:	e8 1d d4 ff ff       	call   80104c10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077f3:	e8 18 c1 ff ff       	call   80103910 <mycpu>
801077f8:	89 c3                	mov    %eax,%ebx
801077fa:	e8 11 c1 ff ff       	call   80103910 <mycpu>
801077ff:	89 c7                	mov    %eax,%edi
80107801:	e8 0a c1 ff ff       	call   80103910 <mycpu>
80107806:	83 c7 08             	add    $0x8,%edi
80107809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010780c:	e8 ff c0 ff ff       	call   80103910 <mycpu>
80107811:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107814:	ba 67 00 00 00       	mov    $0x67,%edx
80107819:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107820:	83 c0 08             	add    $0x8,%eax
80107823:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010782a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010782f:	83 c1 08             	add    $0x8,%ecx
80107832:	c1 e8 18             	shr    $0x18,%eax
80107835:	c1 e9 10             	shr    $0x10,%ecx
80107838:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010783e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107844:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107849:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107850:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107855:	e8 b6 c0 ff ff       	call   80103910 <mycpu>
8010785a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107861:	e8 aa c0 ff ff       	call   80103910 <mycpu>
80107866:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010786a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010786d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107873:	e8 98 c0 ff ff       	call   80103910 <mycpu>
80107878:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010787b:	e8 90 c0 ff ff       	call   80103910 <mycpu>
80107880:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107884:	b8 28 00 00 00       	mov    $0x28,%eax
80107889:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010788c:	8b 46 04             	mov    0x4(%esi),%eax
8010788f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107894:	0f 22 d8             	mov    %eax,%cr3
}
80107897:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010789a:	5b                   	pop    %ebx
8010789b:	5e                   	pop    %esi
8010789c:	5f                   	pop    %edi
8010789d:	5d                   	pop    %ebp
  popcli();
8010789e:	e9 bd d3 ff ff       	jmp    80104c60 <popcli>
    panic("switchuvm: no process");
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	68 86 88 10 80       	push   $0x80108886
801078ab:	e8 e0 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078b0:	83 ec 0c             	sub    $0xc,%esp
801078b3:	68 b1 88 10 80       	push   $0x801088b1
801078b8:	e8 d3 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078bd:	83 ec 0c             	sub    $0xc,%esp
801078c0:	68 9c 88 10 80       	push   $0x8010889c
801078c5:	e8 c6 8a ff ff       	call   80100390 <panic>
801078ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078d0 <inituvm>:
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
801078d5:	89 e5                	mov    %esp,%ebp
801078d7:	57                   	push   %edi
801078d8:	56                   	push   %esi
801078d9:	53                   	push   %ebx
801078da:	83 ec 1c             	sub    $0x1c,%esp
801078dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801078e0:	8b 75 10             	mov    0x10(%ebp),%esi
801078e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801078e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801078e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801078ef:	77 4b                	ja     8010793c <inituvm+0x6c>
  mem = kalloc();
801078f1:	e8 3a ad ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
801078f6:	83 ec 04             	sub    $0x4,%esp
801078f9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801078fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107900:	6a 00                	push   $0x0
80107902:	50                   	push   %eax
80107903:	e8 18 d5 ff ff       	call   80104e20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107908:	58                   	pop    %eax
80107909:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010790f:	5a                   	pop    %edx
80107910:	6a 06                	push   $0x6
80107912:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107917:	31 d2                	xor    %edx,%edx
80107919:	50                   	push   %eax
8010791a:	89 f8                	mov    %edi,%eax
8010791c:	e8 af fc ff ff       	call   801075d0 <mappages>
  memmove(mem, init, sz);
80107921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107924:	89 75 10             	mov    %esi,0x10(%ebp)
80107927:	83 c4 10             	add    $0x10,%esp
8010792a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010792d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107930:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107933:	5b                   	pop    %ebx
80107934:	5e                   	pop    %esi
80107935:	5f                   	pop    %edi
80107936:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107937:	e9 84 d5 ff ff       	jmp    80104ec0 <memmove>
    panic("inituvm: more than a page");
8010793c:	83 ec 0c             	sub    $0xc,%esp
8010793f:	68 c5 88 10 80       	push   $0x801088c5
80107944:	e8 47 8a ff ff       	call   80100390 <panic>
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107950 <loaduvm>:
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	57                   	push   %edi
80107958:	56                   	push   %esi
80107959:	53                   	push   %ebx
8010795a:	83 ec 1c             	sub    $0x1c,%esp
8010795d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107960:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107963:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107968:	0f 85 99 00 00 00    	jne    80107a07 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010796e:	01 f0                	add    %esi,%eax
80107970:	89 f3                	mov    %esi,%ebx
80107972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107975:	8b 45 14             	mov    0x14(%ebp),%eax
80107978:	01 f0                	add    %esi,%eax
8010797a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010797d:	85 f6                	test   %esi,%esi
8010797f:	75 15                	jne    80107996 <loaduvm+0x46>
80107981:	eb 6d                	jmp    801079f0 <loaduvm+0xa0>
80107983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107987:	90                   	nop
80107988:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010798e:	89 f0                	mov    %esi,%eax
80107990:	29 d8                	sub    %ebx,%eax
80107992:	39 c6                	cmp    %eax,%esi
80107994:	76 5a                	jbe    801079f0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107996:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107999:	8b 45 08             	mov    0x8(%ebp),%eax
8010799c:	31 c9                	xor    %ecx,%ecx
8010799e:	29 da                	sub    %ebx,%edx
801079a0:	e8 ab fb ff ff       	call   80107550 <walkpgdir>
801079a5:	85 c0                	test   %eax,%eax
801079a7:	74 51                	je     801079fa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801079a9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801079ae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801079be:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079c1:	29 d9                	sub    %ebx,%ecx
801079c3:	05 00 00 00 80       	add    $0x80000000,%eax
801079c8:	57                   	push   %edi
801079c9:	51                   	push   %ecx
801079ca:	50                   	push   %eax
801079cb:	ff 75 10             	pushl  0x10(%ebp)
801079ce:	e8 8d a0 ff ff       	call   80101a60 <readi>
801079d3:	83 c4 10             	add    $0x10,%esp
801079d6:	39 f8                	cmp    %edi,%eax
801079d8:	74 ae                	je     80107988 <loaduvm+0x38>
}
801079da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079e2:	5b                   	pop    %ebx
801079e3:	5e                   	pop    %esi
801079e4:	5f                   	pop    %edi
801079e5:	5d                   	pop    %ebp
801079e6:	c3                   	ret    
801079e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ee:	66 90                	xchg   %ax,%ax
801079f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079f3:	31 c0                	xor    %eax,%eax
}
801079f5:	5b                   	pop    %ebx
801079f6:	5e                   	pop    %esi
801079f7:	5f                   	pop    %edi
801079f8:	5d                   	pop    %ebp
801079f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801079fa:	83 ec 0c             	sub    $0xc,%esp
801079fd:	68 df 88 10 80       	push   $0x801088df
80107a02:	e8 89 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a07:	83 ec 0c             	sub    $0xc,%esp
80107a0a:	68 80 89 10 80       	push   $0x80108980
80107a0f:	e8 7c 89 ff ff       	call   80100390 <panic>
80107a14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop

80107a20 <allocuvm>:
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	57                   	push   %edi
80107a28:	56                   	push   %esi
80107a29:	53                   	push   %ebx
80107a2a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107a2d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107a30:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a36:	85 c0                	test   %eax,%eax
80107a38:	0f 88 b2 00 00 00    	js     80107af0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107a3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107a44:	0f 82 96 00 00 00    	jb     80107ae0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107a4a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107a50:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107a56:	39 75 10             	cmp    %esi,0x10(%ebp)
80107a59:	77 40                	ja     80107a9b <allocuvm+0x7b>
80107a5b:	e9 83 00 00 00       	jmp    80107ae3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107a60:	83 ec 04             	sub    $0x4,%esp
80107a63:	68 00 10 00 00       	push   $0x1000
80107a68:	6a 00                	push   $0x0
80107a6a:	50                   	push   %eax
80107a6b:	e8 b0 d3 ff ff       	call   80104e20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a70:	58                   	pop    %eax
80107a71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a77:	5a                   	pop    %edx
80107a78:	6a 06                	push   $0x6
80107a7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a7f:	89 f2                	mov    %esi,%edx
80107a81:	50                   	push   %eax
80107a82:	89 f8                	mov    %edi,%eax
80107a84:	e8 47 fb ff ff       	call   801075d0 <mappages>
80107a89:	83 c4 10             	add    $0x10,%esp
80107a8c:	85 c0                	test   %eax,%eax
80107a8e:	78 78                	js     80107b08 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107a90:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a96:	39 75 10             	cmp    %esi,0x10(%ebp)
80107a99:	76 48                	jbe    80107ae3 <allocuvm+0xc3>
    mem = kalloc();
80107a9b:	e8 90 ab ff ff       	call   80102630 <kalloc>
80107aa0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107aa2:	85 c0                	test   %eax,%eax
80107aa4:	75 ba                	jne    80107a60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	68 fd 88 10 80       	push   $0x801088fd
80107aae:	e8 fd 8b ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ab6:	83 c4 10             	add    $0x10,%esp
80107ab9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107abc:	74 32                	je     80107af0 <allocuvm+0xd0>
80107abe:	8b 55 10             	mov    0x10(%ebp),%edx
80107ac1:	89 c1                	mov    %eax,%ecx
80107ac3:	89 f8                	mov    %edi,%eax
80107ac5:	e8 96 fb ff ff       	call   80107660 <deallocuvm.part.0>
      return 0;
80107aca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad7:	5b                   	pop    %ebx
80107ad8:	5e                   	pop    %esi
80107ad9:	5f                   	pop    %edi
80107ada:	5d                   	pop    %ebp
80107adb:	c3                   	ret    
80107adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ae9:	5b                   	pop    %ebx
80107aea:	5e                   	pop    %esi
80107aeb:	5f                   	pop    %edi
80107aec:	5d                   	pop    %ebp
80107aed:	c3                   	ret    
80107aee:	66 90                	xchg   %ax,%ax
    return 0;
80107af0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107afd:	5b                   	pop    %ebx
80107afe:	5e                   	pop    %esi
80107aff:	5f                   	pop    %edi
80107b00:	5d                   	pop    %ebp
80107b01:	c3                   	ret    
80107b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b08:	83 ec 0c             	sub    $0xc,%esp
80107b0b:	68 15 89 10 80       	push   $0x80108915
80107b10:	e8 9b 8b ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107b15:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b18:	83 c4 10             	add    $0x10,%esp
80107b1b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b1e:	74 0c                	je     80107b2c <allocuvm+0x10c>
80107b20:	8b 55 10             	mov    0x10(%ebp),%edx
80107b23:	89 c1                	mov    %eax,%ecx
80107b25:	89 f8                	mov    %edi,%eax
80107b27:	e8 34 fb ff ff       	call   80107660 <deallocuvm.part.0>
      kfree(mem);
80107b2c:	83 ec 0c             	sub    $0xc,%esp
80107b2f:	53                   	push   %ebx
80107b30:	e8 3b a9 ff ff       	call   80102470 <kfree>
      return 0;
80107b35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107b3c:	83 c4 10             	add    $0x10,%esp
}
80107b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b45:	5b                   	pop    %ebx
80107b46:	5e                   	pop    %esi
80107b47:	5f                   	pop    %edi
80107b48:	5d                   	pop    %ebp
80107b49:	c3                   	ret    
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <deallocuvm>:
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107b60:	39 d1                	cmp    %edx,%ecx
80107b62:	73 0c                	jae    80107b70 <deallocuvm+0x20>
}
80107b64:	5d                   	pop    %ebp
80107b65:	e9 f6 fa ff ff       	jmp    80107660 <deallocuvm.part.0>
80107b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b70:	89 d0                	mov    %edx,%eax
80107b72:	5d                   	pop    %ebp
80107b73:	c3                   	ret    
80107b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b7f:	90                   	nop

80107b80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b80:	f3 0f 1e fb          	endbr32 
80107b84:	55                   	push   %ebp
80107b85:	89 e5                	mov    %esp,%ebp
80107b87:	57                   	push   %edi
80107b88:	56                   	push   %esi
80107b89:	53                   	push   %ebx
80107b8a:	83 ec 0c             	sub    $0xc,%esp
80107b8d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107b90:	85 f6                	test   %esi,%esi
80107b92:	74 55                	je     80107be9 <freevm+0x69>
  if(newsz >= oldsz)
80107b94:	31 c9                	xor    %ecx,%ecx
80107b96:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107b9b:	89 f0                	mov    %esi,%eax
80107b9d:	89 f3                	mov    %esi,%ebx
80107b9f:	e8 bc fa ff ff       	call   80107660 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ba4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107baa:	eb 0b                	jmp    80107bb7 <freevm+0x37>
80107bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bb0:	83 c3 04             	add    $0x4,%ebx
80107bb3:	39 df                	cmp    %ebx,%edi
80107bb5:	74 23                	je     80107bda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107bb7:	8b 03                	mov    (%ebx),%eax
80107bb9:	a8 01                	test   $0x1,%al
80107bbb:	74 f3                	je     80107bb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107bc2:	83 ec 0c             	sub    $0xc,%esp
80107bc5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bc8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107bcd:	50                   	push   %eax
80107bce:	e8 9d a8 ff ff       	call   80102470 <kfree>
80107bd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107bd6:	39 df                	cmp    %ebx,%edi
80107bd8:	75 dd                	jne    80107bb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107bda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107be0:	5b                   	pop    %ebx
80107be1:	5e                   	pop    %esi
80107be2:	5f                   	pop    %edi
80107be3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107be4:	e9 87 a8 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107be9:	83 ec 0c             	sub    $0xc,%esp
80107bec:	68 31 89 10 80       	push   $0x80108931
80107bf1:	e8 9a 87 ff ff       	call   80100390 <panic>
80107bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi

80107c00 <setupkvm>:
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	56                   	push   %esi
80107c08:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107c09:	e8 22 aa ff ff       	call   80102630 <kalloc>
80107c0e:	89 c6                	mov    %eax,%esi
80107c10:	85 c0                	test   %eax,%eax
80107c12:	74 42                	je     80107c56 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107c14:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c17:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107c1c:	68 00 10 00 00       	push   $0x1000
80107c21:	6a 00                	push   $0x0
80107c23:	50                   	push   %eax
80107c24:	e8 f7 d1 ff ff       	call   80104e20 <memset>
80107c29:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107c2c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c2f:	83 ec 08             	sub    $0x8,%esp
80107c32:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c35:	ff 73 0c             	pushl  0xc(%ebx)
80107c38:	8b 13                	mov    (%ebx),%edx
80107c3a:	50                   	push   %eax
80107c3b:	29 c1                	sub    %eax,%ecx
80107c3d:	89 f0                	mov    %esi,%eax
80107c3f:	e8 8c f9 ff ff       	call   801075d0 <mappages>
80107c44:	83 c4 10             	add    $0x10,%esp
80107c47:	85 c0                	test   %eax,%eax
80107c49:	78 15                	js     80107c60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c4b:	83 c3 10             	add    $0x10,%ebx
80107c4e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107c54:	75 d6                	jne    80107c2c <setupkvm+0x2c>
}
80107c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c59:	89 f0                	mov    %esi,%eax
80107c5b:	5b                   	pop    %ebx
80107c5c:	5e                   	pop    %esi
80107c5d:	5d                   	pop    %ebp
80107c5e:	c3                   	ret    
80107c5f:	90                   	nop
      freevm(pgdir);
80107c60:	83 ec 0c             	sub    $0xc,%esp
80107c63:	56                   	push   %esi
      return 0;
80107c64:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107c66:	e8 15 ff ff ff       	call   80107b80 <freevm>
      return 0;
80107c6b:	83 c4 10             	add    $0x10,%esp
}
80107c6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c71:	89 f0                	mov    %esi,%eax
80107c73:	5b                   	pop    %ebx
80107c74:	5e                   	pop    %esi
80107c75:	5d                   	pop    %ebp
80107c76:	c3                   	ret    
80107c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c7e:	66 90                	xchg   %ax,%ax

80107c80 <kvmalloc>:
{
80107c80:	f3 0f 1e fb          	endbr32 
80107c84:	55                   	push   %ebp
80107c85:	89 e5                	mov    %esp,%ebp
80107c87:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c8a:	e8 71 ff ff ff       	call   80107c00 <setupkvm>
80107c8f:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c94:	05 00 00 00 80       	add    $0x80000000,%eax
80107c99:	0f 22 d8             	mov    %eax,%cr3
}
80107c9c:	c9                   	leave  
80107c9d:	c3                   	ret    
80107c9e:	66 90                	xchg   %ax,%ax

80107ca0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107ca0:	f3 0f 1e fb          	endbr32 
80107ca4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ca5:	31 c9                	xor    %ecx,%ecx
{
80107ca7:	89 e5                	mov    %esp,%ebp
80107ca9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80107caf:	8b 45 08             	mov    0x8(%ebp),%eax
80107cb2:	e8 99 f8 ff ff       	call   80107550 <walkpgdir>
  if(pte == 0)
80107cb7:	85 c0                	test   %eax,%eax
80107cb9:	74 05                	je     80107cc0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107cbb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107cbe:	c9                   	leave  
80107cbf:	c3                   	ret    
    panic("clearpteu");
80107cc0:	83 ec 0c             	sub    $0xc,%esp
80107cc3:	68 42 89 10 80       	push   $0x80108942
80107cc8:	e8 c3 86 ff ff       	call   80100390 <panic>
80107ccd:	8d 76 00             	lea    0x0(%esi),%esi

80107cd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107cd0:	f3 0f 1e fb          	endbr32 
80107cd4:	55                   	push   %ebp
80107cd5:	89 e5                	mov    %esp,%ebp
80107cd7:	57                   	push   %edi
80107cd8:	56                   	push   %esi
80107cd9:	53                   	push   %ebx
80107cda:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107cdd:	e8 1e ff ff ff       	call   80107c00 <setupkvm>
80107ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ce5:	85 c0                	test   %eax,%eax
80107ce7:	0f 84 9b 00 00 00    	je     80107d88 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107cf0:	85 c9                	test   %ecx,%ecx
80107cf2:	0f 84 90 00 00 00    	je     80107d88 <copyuvm+0xb8>
80107cf8:	31 f6                	xor    %esi,%esi
80107cfa:	eb 46                	jmp    80107d42 <copyuvm+0x72>
80107cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d00:	83 ec 04             	sub    $0x4,%esp
80107d03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107d09:	68 00 10 00 00       	push   $0x1000
80107d0e:	57                   	push   %edi
80107d0f:	50                   	push   %eax
80107d10:	e8 ab d1 ff ff       	call   80104ec0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d15:	58                   	pop    %eax
80107d16:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d1c:	5a                   	pop    %edx
80107d1d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d20:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d25:	89 f2                	mov    %esi,%edx
80107d27:	50                   	push   %eax
80107d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d2b:	e8 a0 f8 ff ff       	call   801075d0 <mappages>
80107d30:	83 c4 10             	add    $0x10,%esp
80107d33:	85 c0                	test   %eax,%eax
80107d35:	78 61                	js     80107d98 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107d37:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d3d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107d40:	76 46                	jbe    80107d88 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d42:	8b 45 08             	mov    0x8(%ebp),%eax
80107d45:	31 c9                	xor    %ecx,%ecx
80107d47:	89 f2                	mov    %esi,%edx
80107d49:	e8 02 f8 ff ff       	call   80107550 <walkpgdir>
80107d4e:	85 c0                	test   %eax,%eax
80107d50:	74 61                	je     80107db3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107d52:	8b 00                	mov    (%eax),%eax
80107d54:	a8 01                	test   $0x1,%al
80107d56:	74 4e                	je     80107da6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107d58:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107d5a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107d62:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107d68:	e8 c3 a8 ff ff       	call   80102630 <kalloc>
80107d6d:	89 c3                	mov    %eax,%ebx
80107d6f:	85 c0                	test   %eax,%eax
80107d71:	75 8d                	jne    80107d00 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107d73:	83 ec 0c             	sub    $0xc,%esp
80107d76:	ff 75 e0             	pushl  -0x20(%ebp)
80107d79:	e8 02 fe ff ff       	call   80107b80 <freevm>
  return 0;
80107d7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107d85:	83 c4 10             	add    $0x10,%esp
}
80107d88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d8e:	5b                   	pop    %ebx
80107d8f:	5e                   	pop    %esi
80107d90:	5f                   	pop    %edi
80107d91:	5d                   	pop    %ebp
80107d92:	c3                   	ret    
80107d93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d97:	90                   	nop
      kfree(mem);
80107d98:	83 ec 0c             	sub    $0xc,%esp
80107d9b:	53                   	push   %ebx
80107d9c:	e8 cf a6 ff ff       	call   80102470 <kfree>
      goto bad;
80107da1:	83 c4 10             	add    $0x10,%esp
80107da4:	eb cd                	jmp    80107d73 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107da6:	83 ec 0c             	sub    $0xc,%esp
80107da9:	68 66 89 10 80       	push   $0x80108966
80107dae:	e8 dd 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107db3:	83 ec 0c             	sub    $0xc,%esp
80107db6:	68 4c 89 10 80       	push   $0x8010894c
80107dbb:	e8 d0 85 ff ff       	call   80100390 <panic>

80107dc0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107dc0:	f3 0f 1e fb          	endbr32 
80107dc4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107dc5:	31 c9                	xor    %ecx,%ecx
{
80107dc7:	89 e5                	mov    %esp,%ebp
80107dc9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd2:	e8 79 f7 ff ff       	call   80107550 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107dd7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107dd9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107dda:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ddc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107de1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107de4:	05 00 00 00 80       	add    $0x80000000,%eax
80107de9:	83 fa 05             	cmp    $0x5,%edx
80107dec:	ba 00 00 00 00       	mov    $0x0,%edx
80107df1:	0f 45 c2             	cmovne %edx,%eax
}
80107df4:	c3                   	ret    
80107df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107e00:	f3 0f 1e fb          	endbr32 
80107e04:	55                   	push   %ebp
80107e05:	89 e5                	mov    %esp,%ebp
80107e07:	57                   	push   %edi
80107e08:	56                   	push   %esi
80107e09:	53                   	push   %ebx
80107e0a:	83 ec 0c             	sub    $0xc,%esp
80107e0d:	8b 75 14             	mov    0x14(%ebp),%esi
80107e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107e13:	85 f6                	test   %esi,%esi
80107e15:	75 3c                	jne    80107e53 <copyout+0x53>
80107e17:	eb 67                	jmp    80107e80 <copyout+0x80>
80107e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107e20:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e23:	89 fb                	mov    %edi,%ebx
80107e25:	29 d3                	sub    %edx,%ebx
80107e27:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107e2d:	39 f3                	cmp    %esi,%ebx
80107e2f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107e32:	29 fa                	sub    %edi,%edx
80107e34:	83 ec 04             	sub    $0x4,%esp
80107e37:	01 c2                	add    %eax,%edx
80107e39:	53                   	push   %ebx
80107e3a:	ff 75 10             	pushl  0x10(%ebp)
80107e3d:	52                   	push   %edx
80107e3e:	e8 7d d0 ff ff       	call   80104ec0 <memmove>
    len -= n;
    buf += n;
80107e43:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107e46:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107e4c:	83 c4 10             	add    $0x10,%esp
80107e4f:	29 de                	sub    %ebx,%esi
80107e51:	74 2d                	je     80107e80 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107e53:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e55:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107e58:	89 55 0c             	mov    %edx,0xc(%ebp)
80107e5b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e61:	57                   	push   %edi
80107e62:	ff 75 08             	pushl  0x8(%ebp)
80107e65:	e8 56 ff ff ff       	call   80107dc0 <uva2ka>
    if(pa0 == 0)
80107e6a:	83 c4 10             	add    $0x10,%esp
80107e6d:	85 c0                	test   %eax,%eax
80107e6f:	75 af                	jne    80107e20 <copyout+0x20>
  }
  return 0;
}
80107e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e79:	5b                   	pop    %ebx
80107e7a:	5e                   	pop    %esi
80107e7b:	5f                   	pop    %edi
80107e7c:	5d                   	pop    %ebp
80107e7d:	c3                   	ret    
80107e7e:	66 90                	xchg   %ax,%ax
80107e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e83:	31 c0                	xor    %eax,%eax
}
80107e85:	5b                   	pop    %ebx
80107e86:	5e                   	pop    %esi
80107e87:	5f                   	pop    %edi
80107e88:	5d                   	pop    %ebp
80107e89:	c3                   	ret    
