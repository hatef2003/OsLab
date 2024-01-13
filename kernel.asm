
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
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

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
80100048:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 86 10 80       	push   $0x80108680
80100055:	68 e0 d5 10 80       	push   $0x8010d5e0
8010005a:	e8 51 50 00 00       	call   801050b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 1c 11 80       	mov    $0x80111cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
8010006e:	1c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
80100078:	1c 11 80 
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
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 86 10 80       	push   $0x80108687
80100097:	50                   	push   %eax
80100098:	e8 d3 4e 00 00       	call   80104f70 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 1a 11 80    	cmp    $0x80111a80,%ebx
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
801000e3:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e8:	e8 43 51 00 00       	call   80105230 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 89 51 00 00       	call   801052f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 4e 00 00       	call   80104fb0 <acquiresleep>
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
801001a3:	68 8e 86 10 80       	push   $0x8010868e
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
801001c2:	e8 89 4e 00 00       	call   80105050 <holdingsleep>
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
801001e0:	68 9f 86 10 80       	push   $0x8010869f
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
80100203:	e8 48 4e 00 00       	call   80105050 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 4d 00 00       	call   80105010 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010021f:	e8 0c 50 00 00       	call   80105230 <acquire>
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
80100246:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 1d 11 80       	mov    0x80111d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 50 00 00       	jmp    801052f0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 86 10 80       	push   $0x801086a6
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
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 7a 4f 00 00       	call   80105230 <acquire>
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
801002c6:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002cb:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 c0 1f 11 80       	push   $0x80111fc0
801002e5:	e8 56 47 00 00       	call   80104a40 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 39 00 00       	call   80103c30 <myproc>
801002ff:	8b 48 30             	mov    0x30(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 dd 4f 00 00       	call   801052f0 <release>
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
80100333:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 1f 11 80 	movsbl -0x7feee0c0(%edx),%ecx
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
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 86 4f 00 00       	call   801052f0 <release>
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
80100386:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
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
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 86 10 80       	push   $0x801086ad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 5b 91 10 80 	movl   $0x8010915b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 4c 00 00       	call   801050d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 86 10 80       	push   $0x801086c1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
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
8010042a:	e8 e1 6b 00 00       	call   80107010 <uartputc>
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
80100515:	e8 f6 6a 00 00       	call   80107010 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ea 6a 00 00       	call   80107010 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 de 6a 00 00       	call   80107010 <uartputc>
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
80100561:	e8 7a 4e 00 00       	call   801053e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 4d 00 00       	call   80105340 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 86 10 80       	push   $0x801086c5
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
801005c9:	0f b6 92 f0 86 10 80 	movzbl -0x7fef7910(%edx),%edx
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
80100603:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 cc 4b 00 00       	call   80105230 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100692:	68 20 c5 10 80       	push   $0x8010c520
80100697:	e8 54 4c 00 00       	call   801052f0 <release>
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
801006bd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
801006ec:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010077d:	bb d8 86 10 80       	mov    $0x801086d8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
801007b8:	68 20 c5 10 80       	push   $0x8010c520
801007bd:	e8 6e 4a 00 00       	call   80105230 <acquire>
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
801007e0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 c5 10 80       	push   $0x8010c520
80100828:	e8 c3 4a 00 00       	call   801052f0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 86 10 80       	push   $0x801086df
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
80100872:	68 20 c5 10 80       	push   $0x8010c520
80100877:	e8 b4 49 00 00       	call   80105230 <acquire>
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
801008b4:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 1f 11 80    	mov    %ecx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 1f 11 80    	mov    %bl,-0x7feee0c0(%eax)
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
80100908:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100925:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
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
8010096a:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010096f:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100985:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
  if(panicked){
80100999:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
801009ca:	68 20 c5 10 80       	push   $0x8010c520
801009cf:	e8 1c 49 00 00       	call   801052f0 <release>
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
801009e3:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
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
801009ff:	e9 fc 43 00 00       	jmp    80104e00 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100a1b:	68 c0 1f 11 80       	push   $0x80111fc0
80100a20:	e8 db 41 00 00       	call   80104c00 <wakeup>
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
80100a3a:	68 e8 86 10 80       	push   $0x801086e8
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 67 46 00 00       	call   801050b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 29 11 80 40 	movl   $0x80100640,0x8011298c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 29 11 80 90 	movl   $0x80100290,0x80112988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
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
80100a90:	e8 9b 31 00 00       	call   80103c30 <myproc>
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
80100b0c:	e8 6f 76 00 00       	call   80108180 <setupkvm>
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
80100b73:	e8 28 74 00 00       	call   80107fa0 <allocuvm>
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
80100ba9:	e8 22 73 00 00       	call   80107ed0 <loaduvm>
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
80100beb:	e8 10 75 00 00       	call   80108100 <freevm>
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
80100c32:	e8 69 73 00 00       	call   80107fa0 <allocuvm>
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
80100c53:	e8 c8 75 00 00       	call   80108220 <clearpteu>
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
80100ca3:	e8 98 48 00 00       	call   80105540 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 85 48 00 00       	call   80105540 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 b4 76 00 00       	call   80108380 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 1a 74 00 00       	call   80108100 <freevm>
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
80100d33:	e8 48 76 00 00       	call   80108380 <copyout>
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
80100d71:	e8 8a 47 00 00       	call   80105500 <safestrcpy>
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
80100d9d:	e8 9e 6f 00 00       	call   80107d40 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 56 73 00 00       	call   80108100 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 01 87 10 80       	push   $0x80108701
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
80100dea:	68 0d 87 10 80       	push   $0x8010870d
80100def:	68 e0 1f 11 80       	push   $0x80111fe0
80100df4:	e8 b7 42 00 00       	call   801050b0 <initlock>
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
80100e08:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 e0 1f 11 80       	push   $0x80111fe0
80100e15:	e8 16 44 00 00       	call   80105230 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
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
80100e3c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e41:	e8 aa 44 00 00       	call   801052f0 <release>
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
80100e55:	68 e0 1f 11 80       	push   $0x80111fe0
80100e5a:	e8 91 44 00 00       	call   801052f0 <release>
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
80100e7e:	68 e0 1f 11 80       	push   $0x80111fe0
80100e83:	e8 a8 43 00 00       	call   80105230 <acquire>
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
80100e9b:	68 e0 1f 11 80       	push   $0x80111fe0
80100ea0:	e8 4b 44 00 00       	call   801052f0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 14 87 10 80       	push   $0x80108714
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
80100ed0:	68 e0 1f 11 80       	push   $0x80111fe0
80100ed5:	e8 56 43 00 00       	call   80105230 <acquire>
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
80100f08:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 db 43 00 00       	call   801052f0 <release>

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
80100f30:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 ad 43 00 00       	jmp    801052f0 <release>
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
80100f79:	e8 c2 26 00 00       	call   80103640 <pipeclose>
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
80100f8c:	68 1c 87 10 80       	push   $0x8010871c
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
80101065:	e9 76 27 00 00       	jmp    801037e0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 26 87 10 80       	push   $0x80108726
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
80101163:	68 2f 87 10 80       	push   $0x8010872f
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
80101191:	e9 4a 25 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 35 87 10 80       	push   $0x80108735
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
801011b8:	03 05 f8 29 11 80    	add    0x801129f8,%eax
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
80101217:	68 3f 87 10 80       	push   $0x8010873f
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
80101239:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
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
8010125c:	03 05 f8 29 11 80    	add    0x801129f8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 e0 29 11 80       	mov    0x801129e0,%eax
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
801012c9:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 52 87 10 80       	push   $0x80108752
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
80101315:	e8 26 40 00 00       	call   80105340 <memset>
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
8010134a:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 00 2a 11 80       	push   $0x80112a00
8010135a:	e8 d1 3e 00 00       	call   80105230 <acquire>
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
8010137a:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
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
8010139b:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
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
801013c2:	68 00 2a 11 80       	push   $0x80112a00
801013c7:	e8 24 3f 00 00       	call   801052f0 <release>

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
801013ed:	68 00 2a 11 80       	push   $0x80112a00
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 f6 3e 00 00       	call   801052f0 <release>
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
80101407:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 68 87 10 80       	push   $0x80108768
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
801014eb:	68 78 87 10 80       	push   $0x80108778
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
80101525:	e8 b6 3e 00 00       	call   801053e0 <memmove>
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
80101548:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 8b 87 10 80       	push   $0x8010878b
80101555:	68 00 2a 11 80       	push   $0x80112a00
8010155a:	e8 51 3b 00 00       	call   801050b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 92 87 10 80       	push   $0x80108792
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 f4 39 00 00       	call   80104f70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 e0 29 11 80       	push   $0x801129e0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 f8 29 11 80    	pushl  0x801129f8
8010159d:	ff 35 f4 29 11 80    	pushl  0x801129f4
801015a3:	ff 35 f0 29 11 80    	pushl  0x801129f0
801015a9:	ff 35 ec 29 11 80    	pushl  0x801129ec
801015af:	ff 35 e8 29 11 80    	pushl  0x801129e8
801015b5:	ff 35 e4 29 11 80    	pushl  0x801129e4
801015bb:	ff 35 e0 29 11 80    	pushl  0x801129e0
801015c1:	68 f8 87 10 80       	push   $0x801087f8
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
801015f0:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
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
8010161f:	3b 3d e8 29 11 80    	cmp    0x801129e8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 f4 29 11 80    	add    0x801129f4,%eax
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
8010165e:	e8 dd 3c 00 00       	call   80105340 <memset>
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
80101693:	68 98 87 10 80       	push   $0x80108798
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
801016b8:	03 05 f4 29 11 80    	add    0x801129f4,%eax
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
80101705:	e8 d6 3c 00 00       	call   801053e0 <memmove>
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
8010173e:	68 00 2a 11 80       	push   $0x80112a00
80101743:	e8 e8 3a 00 00       	call   80105230 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101753:	e8 98 3b 00 00       	call   801052f0 <release>
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
80101786:	e8 25 38 00 00       	call   80104fb0 <acquiresleep>
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
801017a9:	03 05 f4 29 11 80    	add    0x801129f4,%eax
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
801017f8:	e8 e3 3b 00 00       	call   801053e0 <memmove>
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
8010181d:	68 b0 87 10 80       	push   $0x801087b0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 aa 87 10 80       	push   $0x801087aa
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
80101857:	e8 f4 37 00 00       	call   80105050 <holdingsleep>
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
80101873:	e9 98 37 00 00       	jmp    80105010 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 bf 87 10 80       	push   $0x801087bf
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
801018a4:	e8 07 37 00 00       	call   80104fb0 <acquiresleep>
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
801018be:	e8 4d 37 00 00       	call   80105010 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801018ca:	e8 61 39 00 00       	call   80105230 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 07 3a 00 00       	jmp    801052f0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 2a 11 80       	push   $0x80112a00
801018f8:	e8 33 39 00 00       	call   80105230 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101907:	e8 e4 39 00 00       	call   801052f0 <release>
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
80101b07:	e8 d4 38 00 00       	call   801053e0 <memmove>
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
80101b3a:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
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
80101c03:	e8 d8 37 00 00       	call   801053e0 <memmove>
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
80101c4a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
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
80101ca2:	e8 a9 37 00 00       	call   80105450 <strncmp>
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
80101d05:	e8 46 37 00 00       	call   80105450 <strncmp>
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
80101d4a:	68 d9 87 10 80       	push   $0x801087d9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 c7 87 10 80       	push   $0x801087c7
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
80101d8a:	e8 a1 1e 00 00       	call   80103c30 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 2a 11 80       	push   $0x80112a00
80101d9c:	e8 8f 34 00 00       	call   80105230 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101dac:	e8 3f 35 00 00       	call   801052f0 <release>
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
80101e17:	e8 c4 35 00 00       	call   801053e0 <memmove>
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
80101ea3:	e8 38 35 00 00       	call   801053e0 <memmove>
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
80101fd5:	e8 c6 34 00 00       	call   801054a0 <strncpy>
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
80102013:	68 e8 87 10 80       	push   $0x801087e8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 16 8f 10 80       	push   $0x80108f16
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
8010212b:	68 54 88 10 80       	push   $0x80108854
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 4b 88 10 80       	push   $0x8010884b
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
8010215a:	68 66 88 10 80       	push   $0x80108866
8010215f:	68 80 c5 10 80       	push   $0x8010c580
80102164:	e8 47 2f 00 00       	call   801050b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 20 4d 11 80       	mov    0x80114d20,%eax
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
801021ba:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
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
801021ed:	68 80 c5 10 80       	push   $0x8010c580
801021f2:	e8 39 30 00 00       	call   80105230 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 c5 10 80       	mov    %eax,0x8010c564

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
8010224d:	e8 ae 29 00 00       	call   80104c00 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 c5 10 80       	push   $0x8010c580
8010226b:	e8 80 30 00 00       	call   801052f0 <release>

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
80102292:	e8 b9 2d 00 00       	call   80105050 <holdingsleep>
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
801022b7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 c5 10 80       	push   $0x8010c580
801022cc:	e8 5f 2f 00 00       	call   80105230 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 c5 10 80       	mov    0x8010c564,%eax
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
801022f6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
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
80102313:	68 80 c5 10 80       	push   $0x8010c580
80102318:	53                   	push   %ebx
80102319:	e8 22 27 00 00       	call   80104a40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 b5 2f 00 00       	jmp    801052f0 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 95 88 10 80       	push   $0x80108895
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 80 88 10 80       	push   $0x80108880
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 6a 88 10 80       	push   $0x8010886a
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
80102385:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 54 46 11 80    	mov    0x80114654,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
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
801023ce:	68 b4 88 10 80       	push   $0x801088b4
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
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
801023f4:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
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
8010240e:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
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
80102435:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
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
80102449:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 54 46 11 80       	mov    0x80114654,%eax
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
80102486:	81 fb 58 82 11 80    	cmp    $0x80118258,%ebx
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
801024a6:	e8 95 2e 00 00       	call   80105340 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 94 46 11 80    	mov    0x80114694,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 98 46 11 80       	mov    0x80114698,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 94 46 11 80       	mov    0x80114694,%eax
  kmem.freelist = r;
801024c4:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
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
801024db:	68 60 46 11 80       	push   $0x80114660
801024e0:	e8 4b 2d 00 00       	call   80105230 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 f0 2d 00 00       	jmp    801052f0 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 e6 88 10 80       	push   $0x801088e6
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
8010256f:	68 ec 88 10 80       	push   $0x801088ec
80102574:	68 60 46 11 80       	push   $0x80114660
80102579:	e8 32 2b 00 00       	call   801050b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
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
80102614:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
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
80102634:	a1 94 46 11 80       	mov    0x80114694,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 98 46 11 80    	mov    %edx,0x80114698
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
8010265e:	68 60 46 11 80       	push   $0x80114660
80102663:	e8 c8 2b 00 00       	call   80105230 <acquire>
  r = kmem.freelist;
80102668:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
8010266d:	8b 15 94 46 11 80    	mov    0x80114694,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 98 46 11 80    	mov    %ecx,0x80114698
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 60 46 11 80       	push   $0x80114660
80102691:	e8 5a 2c 00 00       	call   801052f0 <release>
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
801026bc:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
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
801026df:	0f b6 8a 20 8a 10 80 	movzbl -0x7fef75e0(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 20 89 10 80 	movzbl -0x7fef76e0(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 00 89 10 80 	mov    -0x7fef7700(,%eax,4),%eax
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
80102725:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
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
8010273a:	0f b6 8a 20 8a 10 80 	movzbl -0x7fef75e0(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
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
801027a4:	a1 9c 46 11 80       	mov    0x8011469c,%eax
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
801028a4:	a1 9c 46 11 80       	mov    0x8011469c,%eax
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
801028c4:	a1 9c 46 11 80       	mov    0x8011469c,%eax
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
80102932:	a1 9c 46 11 80       	mov    0x8011469c,%eax
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
80102abf:	e8 cc 28 00 00       	call   80105390 <memcmp>
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
80102b90:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
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
80102bb0:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd ec 46 11 80 	pushl  -0x7feeb914(,%edi,4)
80102bd4:	ff 35 e4 46 11 80    	pushl  0x801146e4
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
80102bf4:	e8 e7 27 00 00       	call   801053e0 <memmove>
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
80102c14:	39 3d e8 46 11 80    	cmp    %edi,0x801146e8
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
80102c37:	ff 35 d4 46 11 80    	pushl  0x801146d4
80102c3d:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 e8 46 11 80       	mov    0x801146e8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 ec 46 11 80 	mov    -0x7feeb914(,%edx,4),%ecx
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
80102c9e:	68 20 8b 10 80       	push   $0x80108b20
80102ca3:	68 a0 46 11 80       	push   $0x801146a0
80102ca8:	e8 03 24 00 00       	call   801050b0 <initlock>
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
80102cbd:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 d4 46 11 80       	mov    %eax,0x801146d4
  log.size = sb.nlog;
80102ccb:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d e8 46 11 80    	mov    %ecx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 ec 46 11 80 	mov    %ebx,-0x7feeb914(,%edx,4)
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
80102d10:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
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
80102d3a:	68 a0 46 11 80       	push   $0x801146a0
80102d3f:	e8 ec 24 00 00       	call   80105230 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 a0 46 11 80       	push   $0x801146a0
80102d58:	68 a0 46 11 80       	push   $0x801146a0
80102d5d:	e8 de 1c 00 00       	call   80104a40 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 e0 46 11 80       	mov    0x801146e0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102d73:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
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
80102d8a:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
80102d8f:	68 a0 46 11 80       	push   $0x801146a0
80102d94:	e8 57 25 00 00       	call   801052f0 <release>
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
80102dad:	68 a0 46 11 80       	push   $0x801146a0
80102db2:	e8 79 24 00 00       	call   80105230 <acquire>
  log.outstanding -= 1;
80102db7:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
80102dbc:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d dc 46 11 80    	mov    %ebx,0x801146dc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 a0 46 11 80       	push   $0x801146a0
80102df0:	e8 fb 24 00 00       	call   801052f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 a0 46 11 80       	push   $0x801146a0
80102e0a:	e8 21 24 00 00       	call   80105230 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
    log.committing = 0;
80102e16:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 db 1d 00 00       	call   80104c00 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102e2c:	e8 bf 24 00 00       	call   801052f0 <release>
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
80102e40:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102e64:	ff 35 e4 46 11 80    	pushl  0x801146e4
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
80102e84:	e8 57 25 00 00       	call   801053e0 <memmove>
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
80102ea4:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 a0 46 11 80       	push   $0x801146a0
80102ed8:	e8 23 1d 00 00       	call   80104c00 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102ee4:	e8 07 24 00 00       	call   801052f0 <release>
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
80102ef7:	68 24 8b 10 80       	push   $0x80108b24
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
80102f1b:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 d8 46 11 80       	mov    0x801146d8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 46 11 80       	push   $0x801146a0
80102f52:	e8 d9 22 00 00       	call   80105230 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
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
80102f77:	39 0c 85 ec 46 11 80 	cmp    %ecx,-0x7feeb914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 56 23 00 00       	jmp    801052f0 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 46 11 80 	mov    %ecx,-0x7feeb914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 46 11 80    	mov    %edx,0x801146e8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 33 8b 10 80       	push   $0x80108b33
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 49 8b 10 80       	push   $0x80108b49
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
80102fe7:	e8 34 0b 00 00       	call   80103b20 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 2d 0b 00 00       	call   80103b20 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 64 8b 10 80       	push   $0x80108b64
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 39 3c 00 00       	call   80106c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 a4 0a 00 00       	call   80103ab0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 31 16 00 00       	call   80104650 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 f1 4c 00 00       	call   80107d20 <switchkvm>
  seginit();
8010302f:	e8 5c 4c 00 00       	call   80107c90 <seginit>
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
8010305b:	68 58 82 11 80       	push   $0x80118258
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 96 51 00 00       	call   80108200 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 17 4c 00 00       	call   80107c90 <seginit>
  picinit();       // disable pic
80103079:	e8 92 04 00 00       	call   80103510 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 c3 3e 00 00       	call   80106f50 <uartinit>
  pinit();         // process table
8010308d:	e8 ae 09 00 00       	call   80103a40 <pinit>
  tvinit();        // trap vectors
80103092:	e8 29 3b 00 00       	call   80106bc0 <tvinit>
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
801030ae:	68 8c c4 10 80       	push   $0x8010c48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 23 23 00 00       	call   801053e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
801030c7:	00 00 00 
801030ca:	05 a0 47 11 80       	add    $0x801147a0,%eax
801030cf:	3d a0 47 11 80       	cmp    $0x801147a0,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 a0 47 11 80       	add    $0x801147a0,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 b2 09 00 00       	call   80103ab0 <mycpu>
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
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010311b:	b0 10 00 
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
80103162:	e8 39 0b 00 00       	call   80103ca0 <userinit>
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
8010319e:	68 78 8b 10 80       	push   $0x80108b78
801031a3:	56                   	push   %esi
801031a4:	e8 e7 21 00 00       	call   80105390 <memcmp>
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
8010325a:	68 7d 8b 10 80       	push   $0x80108b7d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 28 21 00 00       	call   80105390 <memcmp>
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
801032be:	a3 9c 46 11 80       	mov    %eax,0x8011469c
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
8010334f:	88 0d 80 47 11 80    	mov    %cl,0x80114780
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 47 11 80    	mov    %bl,-0x7feeb860(%edi)
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
801033b3:	68 82 8b 10 80       	push   $0x80108b82
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 9c 8b 10 80       	push   $0x80108b9c
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <init_priority>:
#include "proc.h"
#include "spinlock.h"
#include "priority_lock.h"
void
init_priority(struct priority_lock *lk, char *name)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	53                   	push   %ebx
801033d8:	83 ec 0c             	sub    $0xc,%esp
801033db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "priority lock");
801033de:	68 bb 8b 10 80       	push   $0x80108bbb
801033e3:	8d 43 04             	lea    0x4(%ebx),%eax
801033e6:	50                   	push   %eax
801033e7:	e8 c4 1c 00 00       	call   801050b0 <initlock>
  lk->name = name;
801033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801033ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801033f5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801033f8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801033ff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103405:	c9                   	leave  
80103406:	c3                   	ret    
80103407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340e:	66 90                	xchg   %ax,%ax

80103410 <acquir_priority>:

void
acquir_priority(struct priority_lock *lk)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	56                   	push   %esi
80103418:	53                   	push   %ebx
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010341c:	8d 73 04             	lea    0x4(%ebx),%esi
8010341f:	83 ec 0c             	sub    $0xc,%esp
80103422:	56                   	push   %esi
80103423:	e8 08 1e 00 00       	call   80105230 <acquire>
  while (lk->locked) {
80103428:	8b 13                	mov    (%ebx),%edx
8010342a:	83 c4 10             	add    $0x10,%esp
8010342d:	85 d2                	test   %edx,%edx
8010342f:	74 1a                	je     8010344b <acquir_priority+0x3b>
80103431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103438:	83 ec 08             	sub    $0x8,%esp
8010343b:	56                   	push   %esi
8010343c:	53                   	push   %ebx
8010343d:	e8 fe 15 00 00       	call   80104a40 <sleep>
  while (lk->locked) {
80103442:	8b 03                	mov    (%ebx),%eax
80103444:	83 c4 10             	add    $0x10,%esp
80103447:	85 c0                	test   %eax,%eax
80103449:	75 ed                	jne    80103438 <acquir_priority+0x28>
  }
  lk->locked = 1;
8010344b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103451:	e8 da 07 00 00       	call   80103c30 <myproc>
80103456:	8b 40 10             	mov    0x10(%eax),%eax
80103459:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010345c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010345f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103462:	5b                   	pop    %ebx
80103463:	5e                   	pop    %esi
80103464:	5d                   	pop    %ebp
  release(&lk->lk);
80103465:	e9 86 1e 00 00       	jmp    801052f0 <release>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103470 <release_priority>:

void
release_priority(struct priority_lock *lk)
{
80103470:	f3 0f 1e fb          	endbr32 
80103474:	55                   	push   %ebp
80103475:	89 e5                	mov    %esp,%ebp
80103477:	56                   	push   %esi
80103478:	53                   	push   %ebx
80103479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010347c:	8d 73 04             	lea    0x4(%ebx),%esi
8010347f:	83 ec 0c             	sub    $0xc,%esp
80103482:	56                   	push   %esi
80103483:	e8 a8 1d 00 00       	call   80105230 <acquire>
  lk->locked = 0;
80103488:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010348e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup_pl(lk);
80103495:	89 1c 24             	mov    %ebx,(%esp)
80103498:	e8 d3 17 00 00       	call   80104c70 <wakeup_pl>
  release(&lk->lk);
8010349d:	89 75 08             	mov    %esi,0x8(%ebp)
801034a0:	83 c4 10             	add    $0x10,%esp
}
801034a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a6:	5b                   	pop    %ebx
801034a7:	5e                   	pop    %esi
801034a8:	5d                   	pop    %ebp
  release(&lk->lk);
801034a9:	e9 42 1e 00 00       	jmp    801052f0 <release>
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <print_que>:
void print_que(struct priority_lock * lk)
{
801034b0:	f3 0f 1e fb          	endbr32 
  print_lock_que(lk);
801034b4:	e9 37 18 00 00       	jmp    80104cf0 <print_lock_que>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034c0 <holding_priority>:
}

int
holding_priority(struct priority_lock *lk)
{
801034c0:	f3 0f 1e fb          	endbr32 
801034c4:	55                   	push   %ebp
801034c5:	89 e5                	mov    %esp,%ebp
801034c7:	57                   	push   %edi
801034c8:	56                   	push   %esi
801034c9:	53                   	push   %ebx
801034ca:	83 ec 18             	sub    $0x18,%esp
801034cd:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  acquire(&lk->lk);
801034d0:	8d 7e 04             	lea    0x4(%esi),%edi
801034d3:	57                   	push   %edi
801034d4:	e8 57 1d 00 00       	call   80105230 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801034d9:	8b 1e                	mov    (%esi),%ebx
801034db:	83 c4 10             	add    $0x10,%esp
801034de:	85 db                	test   %ebx,%ebx
801034e0:	75 16                	jne    801034f8 <holding_priority+0x38>
  release(&lk->lk);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	57                   	push   %edi
801034e6:	e8 05 1e 00 00       	call   801052f0 <release>
  return r;
}
801034eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ee:	89 d8                	mov    %ebx,%eax
801034f0:	5b                   	pop    %ebx
801034f1:	5e                   	pop    %esi
801034f2:	5f                   	pop    %edi
801034f3:	5d                   	pop    %ebp
801034f4:	c3                   	ret    
801034f5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801034f8:	8b 5e 3c             	mov    0x3c(%esi),%ebx
801034fb:	e8 30 07 00 00       	call   80103c30 <myproc>
80103500:	39 58 10             	cmp    %ebx,0x10(%eax)
80103503:	0f 94 c3             	sete   %bl
80103506:	0f b6 db             	movzbl %bl,%ebx
80103509:	eb d7                	jmp    801034e2 <holding_priority+0x22>
8010350b:	66 90                	xchg   %ax,%ax
8010350d:	66 90                	xchg   %ax,%ax
8010350f:	90                   	nop

80103510 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103519:	ba 21 00 00 00       	mov    $0x21,%edx
8010351e:	ee                   	out    %al,(%dx)
8010351f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103524:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103525:	c3                   	ret    
80103526:	66 90                	xchg   %ax,%ax
80103528:	66 90                	xchg   %ax,%ax
8010352a:	66 90                	xchg   %ax,%ax
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103530:	f3 0f 1e fb          	endbr32 
80103534:	55                   	push   %ebp
80103535:	89 e5                	mov    %esp,%ebp
80103537:	57                   	push   %edi
80103538:	56                   	push   %esi
80103539:	53                   	push   %ebx
8010353a:	83 ec 0c             	sub    $0xc,%esp
8010353d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103540:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103543:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103549:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010354f:	e8 ac d8 ff ff       	call   80100e00 <filealloc>
80103554:	89 03                	mov    %eax,(%ebx)
80103556:	85 c0                	test   %eax,%eax
80103558:	0f 84 ac 00 00 00    	je     8010360a <pipealloc+0xda>
8010355e:	e8 9d d8 ff ff       	call   80100e00 <filealloc>
80103563:	89 06                	mov    %eax,(%esi)
80103565:	85 c0                	test   %eax,%eax
80103567:	0f 84 8b 00 00 00    	je     801035f8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010356d:	e8 be f0 ff ff       	call   80102630 <kalloc>
80103572:	89 c7                	mov    %eax,%edi
80103574:	85 c0                	test   %eax,%eax
80103576:	0f 84 b4 00 00 00    	je     80103630 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010357c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103583:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103586:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103589:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103590:	00 00 00 
  p->nwrite = 0;
80103593:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010359a:	00 00 00 
  p->nread = 0;
8010359d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035a4:	00 00 00 
  initlock(&p->lock, "pipe");
801035a7:	68 c9 8b 10 80       	push   $0x80108bc9
801035ac:	50                   	push   %eax
801035ad:	e8 fe 1a 00 00       	call   801050b0 <initlock>
  (*f0)->type = FD_PIPE;
801035b2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035b4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035bd:	8b 03                	mov    (%ebx),%eax
801035bf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035c3:	8b 03                	mov    (%ebx),%eax
801035c5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035ce:	8b 06                	mov    (%esi),%eax
801035d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035d6:	8b 06                	mov    (%esi),%eax
801035d8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035dc:	8b 06                	mov    (%esi),%eax
801035de:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ea:	31 c0                	xor    %eax,%eax
}
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035f8:	8b 03                	mov    (%ebx),%eax
801035fa:	85 c0                	test   %eax,%eax
801035fc:	74 1e                	je     8010361c <pipealloc+0xec>
    fileclose(*f0);
801035fe:	83 ec 0c             	sub    $0xc,%esp
80103601:	50                   	push   %eax
80103602:	e8 b9 d8 ff ff       	call   80100ec0 <fileclose>
80103607:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010360a:	8b 06                	mov    (%esi),%eax
8010360c:	85 c0                	test   %eax,%eax
8010360e:	74 0c                	je     8010361c <pipealloc+0xec>
    fileclose(*f1);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	50                   	push   %eax
80103614:	e8 a7 d8 ff ff       	call   80100ec0 <fileclose>
80103619:	83 c4 10             	add    $0x10,%esp
}
8010361c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010361f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103624:	5b                   	pop    %ebx
80103625:	5e                   	pop    %esi
80103626:	5f                   	pop    %edi
80103627:	5d                   	pop    %ebp
80103628:	c3                   	ret    
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103630:	8b 03                	mov    (%ebx),%eax
80103632:	85 c0                	test   %eax,%eax
80103634:	75 c8                	jne    801035fe <pipealloc+0xce>
80103636:	eb d2                	jmp    8010360a <pipealloc+0xda>
80103638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010363f:	90                   	nop

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	f3 0f 1e fb          	endbr32 
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	56                   	push   %esi
80103648:	53                   	push   %ebx
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010364c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364f:	83 ec 0c             	sub    $0xc,%esp
80103652:	53                   	push   %ebx
80103653:	e8 d8 1b 00 00       	call   80105230 <acquire>
  if(writable){
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	85 f6                	test   %esi,%esi
8010365d:	74 41                	je     801036a0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365f:	83 ec 0c             	sub    $0xc,%esp
80103662:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103668:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010366f:	00 00 00 
    wakeup(&p->nread);
80103672:	50                   	push   %eax
80103673:	e8 88 15 00 00       	call   80104c00 <wakeup>
80103678:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010367b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103681:	85 d2                	test   %edx,%edx
80103683:	75 0a                	jne    8010368f <pipeclose+0x4f>
80103685:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010368b:	85 c0                	test   %eax,%eax
8010368d:	74 31                	je     801036c0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103692:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103695:	5b                   	pop    %ebx
80103696:	5e                   	pop    %esi
80103697:	5d                   	pop    %ebp
    release(&p->lock);
80103698:	e9 53 1c 00 00       	jmp    801052f0 <release>
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036b0:	00 00 00 
    wakeup(&p->nwrite);
801036b3:	50                   	push   %eax
801036b4:	e8 47 15 00 00       	call   80104c00 <wakeup>
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	eb bd                	jmp    8010367b <pipeclose+0x3b>
801036be:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	53                   	push   %ebx
801036c4:	e8 27 1c 00 00       	call   801052f0 <release>
    kfree((char*)p);
801036c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036cc:	83 c4 10             	add    $0x10,%esp
}
801036cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d2:	5b                   	pop    %ebx
801036d3:	5e                   	pop    %esi
801036d4:	5d                   	pop    %ebp
    kfree((char*)p);
801036d5:	e9 96 ed ff ff       	jmp    80102470 <kfree>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	f3 0f 1e fb          	endbr32 
801036e4:	55                   	push   %ebp
801036e5:	89 e5                	mov    %esp,%ebp
801036e7:	57                   	push   %edi
801036e8:	56                   	push   %esi
801036e9:	53                   	push   %ebx
801036ea:	83 ec 28             	sub    $0x28,%esp
801036ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036f0:	53                   	push   %ebx
801036f1:	e8 3a 1b 00 00       	call   80105230 <acquire>
  for(i = 0; i < n; i++){
801036f6:	8b 45 10             	mov    0x10(%ebp),%eax
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	85 c0                	test   %eax,%eax
801036fe:	0f 8e bc 00 00 00    	jle    801037c0 <pipewrite+0xe0>
80103704:	8b 45 0c             	mov    0xc(%ebp),%eax
80103707:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010370d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103713:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103716:	03 45 10             	add    0x10(%ebp),%eax
80103719:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010371c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103722:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103728:	89 ca                	mov    %ecx,%edx
8010372a:	05 00 02 00 00       	add    $0x200,%eax
8010372f:	39 c1                	cmp    %eax,%ecx
80103731:	74 3b                	je     8010376e <pipewrite+0x8e>
80103733:	eb 63                	jmp    80103798 <pipewrite+0xb8>
80103735:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 f3 04 00 00       	call   80103c30 <myproc>
8010373d:	8b 48 30             	mov    0x30(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 b3 14 00 00       	call   80104c00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 ea 12 00 00       	call   80104a40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010375c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 6f 1b 00 00       	call   801052f0 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801037b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ba:	0f 85 5c ff ff ff    	jne    8010371c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c9:	50                   	push   %eax
801037ca:	e8 31 14 00 00       	call   80104c00 <wakeup>
  release(&p->lock);
801037cf:	89 1c 24             	mov    %ebx,(%esp)
801037d2:	e8 19 1b 00 00       	call   801052f0 <release>
  return n;
801037d7:	8b 45 10             	mov    0x10(%ebp),%eax
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	eb aa                	jmp    80103789 <pipewrite+0xa9>
801037df:	90                   	nop

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	f3 0f 1e fb          	endbr32 
801037e4:	55                   	push   %ebp
801037e5:	89 e5                	mov    %esp,%ebp
801037e7:	57                   	push   %edi
801037e8:	56                   	push   %esi
801037e9:	53                   	push   %ebx
801037ea:	83 ec 18             	sub    $0x18,%esp
801037ed:	8b 75 08             	mov    0x8(%ebp),%esi
801037f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037f3:	56                   	push   %esi
801037f4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037fa:	e8 31 1a 00 00       	call   80105230 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ff:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010380e:	74 33                	je     80103843 <piperead+0x63>
80103810:	eb 3b                	jmp    8010384d <piperead+0x6d>
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103818:	e8 13 04 00 00       	call   80103c30 <myproc>
8010381d:	8b 48 30             	mov    0x30(%eax),%ecx
80103820:	85 c9                	test   %ecx,%ecx
80103822:	0f 85 88 00 00 00    	jne    801038b0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103828:	83 ec 08             	sub    $0x8,%esp
8010382b:	56                   	push   %esi
8010382c:	53                   	push   %ebx
8010382d:	e8 0e 12 00 00       	call   80104a40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103832:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103838:	83 c4 10             	add    $0x10,%esp
8010383b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103841:	75 0a                	jne    8010384d <piperead+0x6d>
80103843:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103849:	85 c0                	test   %eax,%eax
8010384b:	75 cb                	jne    80103818 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010384d:	8b 55 10             	mov    0x10(%ebp),%edx
80103850:	31 db                	xor    %ebx,%ebx
80103852:	85 d2                	test   %edx,%edx
80103854:	7f 28                	jg     8010387e <piperead+0x9e>
80103856:	eb 34                	jmp    8010388c <piperead+0xac>
80103858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103860:	8d 48 01             	lea    0x1(%eax),%ecx
80103863:	25 ff 01 00 00       	and    $0x1ff,%eax
80103868:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010386e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103873:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103876:	83 c3 01             	add    $0x1,%ebx
80103879:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010387c:	74 0e                	je     8010388c <piperead+0xac>
    if(p->nread == p->nwrite)
8010387e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103884:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010388a:	75 d4                	jne    80103860 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010388c:	83 ec 0c             	sub    $0xc,%esp
8010388f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103895:	50                   	push   %eax
80103896:	e8 65 13 00 00       	call   80104c00 <wakeup>
  release(&p->lock);
8010389b:	89 34 24             	mov    %esi,(%esp)
8010389e:	e8 4d 1a 00 00       	call   801052f0 <release>
  return i;
801038a3:	83 c4 10             	add    $0x10,%esp
}
801038a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a9:	89 d8                	mov    %ebx,%eax
801038ab:	5b                   	pop    %ebx
801038ac:	5e                   	pop    %esi
801038ad:	5f                   	pop    %edi
801038ae:	5d                   	pop    %ebp
801038af:	c3                   	ret    
      release(&p->lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038b8:	56                   	push   %esi
801038b9:	e8 32 1a 00 00       	call   801052f0 <release>
      return -1;
801038be:	83 c4 10             	add    $0x10,%esp
}
801038c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c4:	89 d8                	mov    %ebx,%eax
801038c6:	5b                   	pop    %ebx
801038c7:	5e                   	pop    %esi
801038c8:	5f                   	pop    %edi
801038c9:	5d                   	pop    %ebp
801038ca:	c3                   	ret    
801038cb:	66 90                	xchg   %ax,%ax
801038cd:	66 90                	xchg   %ax,%ax
801038cf:	90                   	nop

801038d0 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d4:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
{
801038d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038dc:	68 80 4d 11 80       	push   $0x80114d80
801038e1:	e8 4a 19 00 00       	call   80105230 <acquire>
801038e6:	83 c4 10             	add    $0x10,%esp
801038e9:	eb 17                	jmp    80103902 <allocproc+0x32>
801038eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038f0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801038f6:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
801038fc:	0f 84 b6 00 00 00    	je     801039b8 <allocproc+0xe8>
    if (p->state == UNUSED)
80103902:	8b 43 0c             	mov    0xc(%ebx),%eax
80103905:	85 c0                	test   %eax,%eax
80103907:	75 e7                	jne    801038f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103909:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->que_id = LCFS;
  if (p->pid == 2)
    p->que_id = RR;
  p->priority = PRIORITY_DEF;
  p->priority_ratio = 1.0f;
8010390e:	d9 e8                	fld1   
  p->state = EMBRYO;
80103910:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority_ratio = 1.0f;
80103917:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->que_id = LCFS;
8010391d:	83 f8 02             	cmp    $0x2,%eax
  p->pid = nextpid++;
80103920:	8d 50 01             	lea    0x1(%eax),%edx
80103923:	89 43 10             	mov    %eax,0x10(%ebx)
  p->que_id = LCFS;
80103926:	0f 95 c0             	setne  %al
  p->creation_time_ratio = 1.0f;
80103929:	d9 93 90 00 00 00    	fsts   0x90(%ebx)
  p->executed_cycle = 0.1f;
  p->executed_cycle_ratio = 1.0f;
  p->process_size_ratio = 1.0f;
  release(&ptable.lock);
8010392f:	83 ec 0c             	sub    $0xc,%esp
  p->que_id = LCFS;
80103932:	0f b6 c0             	movzbl %al,%eax
  p->executed_cycle_ratio = 1.0f;
80103935:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
  p->que_id = LCFS;
8010393b:	83 c0 01             	add    $0x1,%eax
  p->process_size_ratio = 1.0f;
8010393e:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  p->que_id = LCFS;
80103944:	89 43 28             	mov    %eax,0x28(%ebx)
  p->priority = PRIORITY_DEF;
80103947:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
8010394e:	00 00 00 
  p->executed_cycle = 0.1f;
80103951:	c7 83 94 00 00 00 cd 	movl   $0x3dcccccd,0x94(%ebx)
80103958:	cc cc 3d 
  release(&ptable.lock);
8010395b:	68 80 4d 11 80       	push   $0x80114d80
  p->pid = nextpid++;
80103960:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103966:	e8 85 19 00 00       	call   801052f0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010396b:	e8 c0 ec ff ff       	call   80102630 <kalloc>
80103970:	83 c4 10             	add    $0x10,%esp
80103973:	89 43 08             	mov    %eax,0x8(%ebx)
80103976:	85 c0                	test   %eax,%eax
80103978:	74 57                	je     801039d1 <allocproc+0x101>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010397a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103980:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103983:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103988:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010398b:	c7 40 14 af 6b 10 80 	movl   $0x80106baf,0x14(%eax)
  p->context = (struct context *)sp;
80103992:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103995:	6a 14                	push   $0x14
80103997:	6a 00                	push   $0x0
80103999:	50                   	push   %eax
8010399a:	e8 a1 19 00 00       	call   80105340 <memset>
  p->context->eip = (uint)forkret;
8010399f:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039a2:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039a5:	c7 40 10 f0 39 10 80 	movl   $0x801039f0,0x10(%eax)
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039b7:	90                   	nop
  release(&ptable.lock);
801039b8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039bb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039bd:	68 80 4d 11 80       	push   $0x80114d80
801039c2:	e8 29 19 00 00       	call   801052f0 <release>
}
801039c7:	89 d8                	mov    %ebx,%eax
  return 0;
801039c9:	83 c4 10             	add    $0x10,%esp
}
801039cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039cf:	c9                   	leave  
801039d0:	c3                   	ret    
    p->state = UNUSED;
801039d1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039d8:	31 db                	xor    %ebx,%ebx
}
801039da:	89 d8                	mov    %ebx,%eax
801039dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039df:	c9                   	leave  
801039e0:	c3                   	ret    
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop

801039f0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039fa:	68 80 4d 11 80       	push   $0x80114d80
801039ff:	e8 ec 18 00 00       	call   801052f0 <release>

  if (first)
80103a04:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103a09:	83 c4 10             	add    $0x10,%esp
80103a0c:	85 c0                	test   %eax,%eax
80103a0e:	75 08                	jne    80103a18 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a10:	c9                   	leave  
80103a11:	c3                   	ret    
80103a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103a18:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103a1f:	00 00 00 
    iinit(ROOTDEV);
80103a22:	83 ec 0c             	sub    $0xc,%esp
80103a25:	6a 01                	push   $0x1
80103a27:	e8 14 db ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a33:	e8 58 f2 ff ff       	call   80102c90 <initlog>
}
80103a38:	83 c4 10             	add    $0x10,%esp
80103a3b:	c9                   	leave  
80103a3c:	c3                   	ret    
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi

80103a40 <pinit>:
{
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a4a:	68 ce 8b 10 80       	push   $0x80108bce
80103a4f:	68 80 4d 11 80       	push   $0x80114d80
80103a54:	e8 57 16 00 00       	call   801050b0 <initlock>
}
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	c9                   	leave  
80103a5d:	c3                   	ret    
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <calculate_rank>:
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103a65:	31 c9                	xor    %ecx,%ecx
{
80103a67:	89 e5                	mov    %esp,%ebp
80103a69:	83 ec 08             	sub    $0x8,%esp
80103a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103a6f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80103a72:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103a78:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80103a7e:	db 40 20             	fildl  0x20(%eax)
80103a81:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80103a87:	8b 10                	mov    (%eax),%edx
80103a89:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103a8c:	de c1                	faddp  %st,%st(1)
80103a8e:	d9 80 94 00 00 00    	flds   0x94(%eax)
80103a94:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80103a9a:	de c1                	faddp  %st,%st(1)
80103a9c:	df 6d f8             	fildll -0x8(%ebp)
80103a9f:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
80103aa5:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103aa6:	de c1                	faddp  %st,%st(1)
}
80103aa8:	c3                   	ret    
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ab0 <mycpu>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab9:	9c                   	pushf  
80103aba:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103abb:	f6 c4 02             	test   $0x2,%ah
80103abe:	75 4a                	jne    80103b0a <mycpu+0x5a>
  apicid = lapicid();
80103ac0:	e8 db ed ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103ac5:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
  apicid = lapicid();
80103acb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
80103acd:	85 f6                	test   %esi,%esi
80103acf:	7e 2c                	jle    80103afd <mycpu+0x4d>
80103ad1:	31 d2                	xor    %edx,%edx
80103ad3:	eb 0a                	jmp    80103adf <mycpu+0x2f>
80103ad5:	8d 76 00             	lea    0x0(%esi),%esi
80103ad8:	83 c2 01             	add    $0x1,%edx
80103adb:	39 f2                	cmp    %esi,%edx
80103add:	74 1e                	je     80103afd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103adf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ae5:	0f b6 81 a0 47 11 80 	movzbl -0x7feeb860(%ecx),%eax
80103aec:	39 d8                	cmp    %ebx,%eax
80103aee:	75 e8                	jne    80103ad8 <mycpu+0x28>
}
80103af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103af3:	8d 81 a0 47 11 80    	lea    -0x7feeb860(%ecx),%eax
}
80103af9:	5b                   	pop    %ebx
80103afa:	5e                   	pop    %esi
80103afb:	5d                   	pop    %ebp
80103afc:	c3                   	ret    
  panic("unknown apicid\n");
80103afd:	83 ec 0c             	sub    $0xc,%esp
80103b00:	68 d5 8b 10 80       	push   $0x80108bd5
80103b05:	e8 86 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	68 38 8d 10 80       	push   $0x80108d38
80103b12:	e8 79 c8 ff ff       	call   80100390 <panic>
80103b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <cpuid>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103b2a:	e8 81 ff ff ff       	call   80103ab0 <mycpu>
}
80103b2f:	c9                   	leave  
  return mycpu() - cpus;
80103b30:	2d a0 47 11 80       	sub    $0x801147a0,%eax
80103b35:	c1 f8 04             	sar    $0x4,%eax
80103b38:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b3e:	c3                   	ret    
80103b3f:	90                   	nop

80103b40 <aging>:
{
80103b40:	f3 0f 1e fb          	endbr32 
  time = ticks;
80103b44:	8b 0d 00 7f 11 80    	mov    0x80117f00,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b4a:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80103b4f:	eb 13                	jmp    80103b64 <aging+0x24>
80103b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b58:	05 a4 00 00 00       	add    $0xa4,%eax
80103b5d:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80103b62:	74 2c                	je     80103b90 <aging+0x50>
    if (p->state == RUNNABLE && p->que_id != RR)
80103b64:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b68:	75 ee                	jne    80103b58 <aging+0x18>
80103b6a:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80103b6e:	74 e8                	je     80103b58 <aging+0x18>
      if (time - p->preemption_time > AGING_THRS)
80103b70:	89 ca                	mov    %ecx,%edx
80103b72:	2b 50 24             	sub    0x24(%eax),%edx
80103b75:	81 fa 40 1f 00 00    	cmp    $0x1f40,%edx
80103b7b:	7e db                	jle    80103b58 <aging+0x18>
        p->que_id = RR;
80103b7d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b84:	05 a4 00 00 00       	add    $0xa4,%eax
80103b89:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80103b8e:	75 d4                	jne    80103b64 <aging+0x24>
}
80103b90:	c3                   	ret    
80103b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <reset_bjf_attributes>:
{
80103ba0:	f3 0f 1e fb          	endbr32 
80103ba4:	55                   	push   %ebp
80103ba5:	89 e5                	mov    %esp,%ebp
80103ba7:	83 ec 24             	sub    $0x24,%esp
80103baa:	d9 45 08             	flds   0x8(%ebp)
  acquire(&ptable.lock);
80103bad:	68 80 4d 11 80       	push   $0x80114d80
{
80103bb2:	d9 5d e8             	fstps  -0x18(%ebp)
80103bb5:	d9 45 0c             	flds   0xc(%ebp)
80103bb8:	d9 5d ec             	fstps  -0x14(%ebp)
80103bbb:	d9 45 10             	flds   0x10(%ebp)
80103bbe:	d9 5d f0             	fstps  -0x10(%ebp)
80103bc1:	d9 45 14             	flds   0x14(%ebp)
80103bc4:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103bc7:	e8 64 16 00 00       	call   80105230 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bcc:	d9 45 e8             	flds   -0x18(%ebp)
80103bcf:	d9 45 ec             	flds   -0x14(%ebp)
  acquire(&ptable.lock);
80103bd2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd5:	d9 45 f0             	flds   -0x10(%ebp)
80103bd8:	d9 45 f4             	flds   -0xc(%ebp)
80103bdb:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
    if (p->state != UNUSED)
80103be0:	8b 50 0c             	mov    0xc(%eax),%edx
80103be3:	85 d2                	test   %edx,%edx
80103be5:	74 28                	je     80103c0f <reset_bjf_attributes+0x6f>
80103be7:	d9 cb                	fxch   %st(3)
      p->priority_ratio = priority_ratio;
80103be9:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80103bef:	d9 ca                	fxch   %st(2)
      p->creation_time_ratio = creation_time_ratio;
80103bf1:	d9 90 90 00 00 00    	fsts   0x90(%eax)
80103bf7:	d9 c9                	fxch   %st(1)
      p->executed_cycle_ratio = exec_cycle_ratio;
80103bf9:	d9 90 98 00 00 00    	fsts   0x98(%eax)
80103bff:	d9 cb                	fxch   %st(3)
      p->process_size_ratio = size_ratio;
80103c01:	d9 90 9c 00 00 00    	fsts   0x9c(%eax)
80103c07:	d9 c9                	fxch   %st(1)
80103c09:	d9 ca                	fxch   %st(2)
80103c0b:	d9 cb                	fxch   %st(3)
80103c0d:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c0f:	05 a4 00 00 00       	add    $0xa4,%eax
80103c14:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80103c19:	75 c5                	jne    80103be0 <reset_bjf_attributes+0x40>
80103c1b:	dd d8                	fstp   %st(0)
80103c1d:	dd d8                	fstp   %st(0)
80103c1f:	dd d8                	fstp   %st(0)
80103c21:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103c23:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80103c2a:	c9                   	leave  
  release(&ptable.lock);
80103c2b:	e9 c0 16 00 00       	jmp    801052f0 <release>

80103c30 <myproc>:
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	53                   	push   %ebx
80103c38:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c3b:	e8 f0 14 00 00       	call   80105130 <pushcli>
  c = mycpu();
80103c40:	e8 6b fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c4b:	e8 30 15 00 00       	call   80105180 <popcli>
}
80103c50:	83 c4 04             	add    $0x4,%esp
80103c53:	89 d8                	mov    %ebx,%eax
80103c55:	5b                   	pop    %ebx
80103c56:	5d                   	pop    %ebp
80103c57:	c3                   	ret    
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <how_many_digit>:
{
80103c60:	f3 0f 1e fb          	endbr32 
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	56                   	push   %esi
80103c68:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103c6b:	53                   	push   %ebx
80103c6c:	bb 01 00 00 00       	mov    $0x1,%ebx
  if (num == 0)
80103c71:	85 c9                	test   %ecx,%ecx
80103c73:	74 1e                	je     80103c93 <how_many_digit+0x33>
  int count = 0;
80103c75:	31 db                	xor    %ebx,%ebx
    num /= 10;
80103c77:	be 67 66 66 66       	mov    $0x66666667,%esi
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c80:	89 c8                	mov    %ecx,%eax
80103c82:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80103c85:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80103c88:	f7 ee                	imul   %esi
80103c8a:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103c8d:	29 ca                	sub    %ecx,%edx
80103c8f:	89 d1                	mov    %edx,%ecx
80103c91:	75 ed                	jne    80103c80 <how_many_digit+0x20>
}
80103c93:	89 d8                	mov    %ebx,%eax
80103c95:	5b                   	pop    %ebx
80103c96:	5e                   	pop    %esi
80103c97:	5d                   	pop    %ebp
80103c98:	c3                   	ret    
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <userinit>:
{
80103ca0:	f3 0f 1e fb          	endbr32 
80103ca4:	55                   	push   %ebp
80103ca5:	89 e5                	mov    %esp,%ebp
80103ca7:	53                   	push   %ebx
80103ca8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103cab:	e8 20 fc ff ff       	call   801038d0 <allocproc>
80103cb0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cb2:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
  if ((p->pgdir = setupkvm()) == 0)
80103cb7:	e8 c4 44 00 00       	call   80108180 <setupkvm>
80103cbc:	89 43 04             	mov    %eax,0x4(%ebx)
80103cbf:	85 c0                	test   %eax,%eax
80103cc1:	0f 84 d9 00 00 00    	je     80103da0 <userinit+0x100>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cc7:	83 ec 04             	sub    $0x4,%esp
80103cca:	68 2c 00 00 00       	push   $0x2c
80103ccf:	68 60 c4 10 80       	push   $0x8010c460
80103cd4:	50                   	push   %eax
80103cd5:	e8 76 41 00 00       	call   80107e50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cda:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cdd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ce3:	6a 4c                	push   $0x4c
80103ce5:	6a 00                	push   $0x0
80103ce7:	ff 73 18             	pushl  0x18(%ebx)
80103cea:	e8 51 16 00 00       	call   80105340 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cef:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cf7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cfa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cff:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d03:	8b 43 18             	mov    0x18(%ebx),%eax
80103d06:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d11:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d15:	8b 43 18             	mov    0x18(%ebx),%eax
80103d18:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d1c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d20:	8b 43 18             	mov    0x18(%ebx),%eax
80103d23:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d2a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d2d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103d34:	8b 43 18             	mov    0x18(%ebx),%eax
80103d37:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d3e:	8d 43 78             	lea    0x78(%ebx),%eax
80103d41:	6a 10                	push   $0x10
80103d43:	68 fe 8b 10 80       	push   $0x80108bfe
80103d48:	50                   	push   %eax
80103d49:	e8 b2 17 00 00       	call   80105500 <safestrcpy>
  p->cwd = namei("/");
80103d4e:	c7 04 24 07 8c 10 80 	movl   $0x80108c07,(%esp)
80103d55:	e8 d6 e2 ff ff       	call   80102030 <namei>
80103d5a:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103d5d:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103d64:	e8 c7 14 00 00       	call   80105230 <acquire>
  p->state = RUNNABLE;
80103d69:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103d70:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103d77:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103d7e:	e8 6d 15 00 00       	call   801052f0 <release>
  init_priority(&PL , "FUCK");
80103d83:	5b                   	pop    %ebx
80103d84:	58                   	pop    %eax
80103d85:	68 09 8c 10 80       	push   $0x80108c09
80103d8a:	68 40 4d 11 80       	push   $0x80114d40
80103d8f:	e8 3c f6 ff ff       	call   801033d0 <init_priority>
}
80103d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  shared_memory_init();
80103d97:	83 c4 10             	add    $0x10,%esp
}
80103d9a:	c9                   	leave  
  shared_memory_init();
80103d9b:	e9 70 46 00 00       	jmp    80108410 <shared_memory_init>
    panic("userinit: out of memory?");
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 e5 8b 10 80       	push   $0x80108be5
80103da8:	e8 e3 c5 ff ff       	call   80100390 <panic>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi

80103db0 <print_name>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	57                   	push   %edi
80103db8:	56                   	push   %esi
  memset(buf, ' ', 12);
80103db9:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80103dbc:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103dbd:	31 db                	xor    %ebx,%ebx
{
80103dbf:	83 ec 20             	sub    $0x20,%esp
80103dc2:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 12);
80103dc5:	6a 0c                	push   $0xc
80103dc7:	6a 20                	push   $0x20
80103dc9:	57                   	push   %edi
80103dca:	e8 71 15 00 00       	call   80105340 <memset>
  buf[13] = 0;
80103dcf:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	eb 12                	jmp    80103dea <print_name+0x3a>
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop
    buf[i] = name[i];
80103de0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103de4:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103de7:	83 c3 01             	add    $0x1,%ebx
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	56                   	push   %esi
80103dee:	e8 4d 17 00 00       	call   80105540 <strlen>
80103df3:	83 c4 10             	add    $0x10,%esp
80103df6:	39 d8                	cmp    %ebx,%eax
80103df8:	7f e6                	jg     80103de0 <print_name+0x30>
  cprintf("%s", buf);
80103dfa:	83 ec 08             	sub    $0x8,%esp
80103dfd:	57                   	push   %edi
80103dfe:	68 09 8d 10 80       	push   $0x80108d09
80103e03:	e8 a8 c8 ff ff       	call   801006b0 <cprintf>
}
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e0e:	5b                   	pop    %ebx
80103e0f:	5e                   	pop    %esi
80103e10:	5f                   	pop    %edi
80103e11:	5d                   	pop    %ebp
80103e12:	c3                   	ret    
80103e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e20 <find_proc>:
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	56                   	push   %esi
80103e28:	53                   	push   %ebx
80103e29:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
  acquire(&ptable.lock);
80103e31:	83 ec 0c             	sub    $0xc,%esp
80103e34:	68 80 4d 11 80       	push   $0x80114d80
80103e39:	e8 f2 13 00 00       	call   80105230 <acquire>
80103e3e:	83 c4 10             	add    $0x10,%esp
80103e41:	eb 13                	jmp    80103e56 <find_proc+0x36>
80103e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e47:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e48:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103e4e:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80103e54:	74 05                	je     80103e5b <find_proc+0x3b>
    if (p->pid == pid)
80103e56:	39 73 10             	cmp    %esi,0x10(%ebx)
80103e59:	75 ed                	jne    80103e48 <find_proc+0x28>
  release(&ptable.lock);
80103e5b:	83 ec 0c             	sub    $0xc,%esp
80103e5e:	68 80 4d 11 80       	push   $0x80114d80
80103e63:	e8 88 14 00 00       	call   801052f0 <release>
}
80103e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e6b:	89 d8                	mov    %ebx,%eax
80103e6d:	5b                   	pop    %ebx
80103e6e:	5e                   	pop    %esi
80103e6f:	5d                   	pop    %ebp
80103e70:	c3                   	ret    
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop

80103e80 <print_state>:
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8a:	83 f8 05             	cmp    $0x5,%eax
80103e8d:	77 6e                	ja     80103efd <print_state+0x7d>
80103e8f:	3e ff 24 85 b4 8d 10 	notrack jmp *-0x7fef724c(,%eax,4)
80103e96:	80 
80103e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9e:	66 90                	xchg   %ax,%ax
    cprintf("RUNNING   ");
80103ea0:	c7 45 08 3a 8c 10 80 	movl   $0x80108c3a,0x8(%ebp)
}
80103ea7:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103ea8:	e9 03 c8 ff ff       	jmp    801006b0 <cprintf>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103eb0:	c7 45 08 45 8c 10 80 	movl   $0x80108c45,0x8(%ebp)
}
80103eb7:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103eb8:	e9 f3 c7 ff ff       	jmp    801006b0 <cprintf>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103ec0:	c7 45 08 0e 8c 10 80 	movl   $0x80108c0e,0x8(%ebp)
}
80103ec7:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103ec8:	e9 e3 c7 ff ff       	jmp    801006b0 <cprintf>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103ed0:	c7 45 08 19 8c 10 80 	movl   $0x80108c19,0x8(%ebp)
}
80103ed7:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103ed8:	e9 d3 c7 ff ff       	jmp    801006b0 <cprintf>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103ee0:	c7 45 08 24 8c 10 80 	movl   $0x80108c24,0x8(%ebp)
}
80103ee7:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103ee8:	e9 c3 c7 ff ff       	jmp    801006b0 <cprintf>
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103ef0:	c7 45 08 2f 8c 10 80 	movl   $0x80108c2f,0x8(%ebp)
}
80103ef7:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103ef8:	e9 b3 c7 ff ff       	jmp    801006b0 <cprintf>
    cprintf("damn ways to die");
80103efd:	c7 45 08 50 8c 10 80 	movl   $0x80108c50,0x8(%ebp)
}
80103f04:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103f05:	e9 a6 c7 ff ff       	jmp    801006b0 <cprintf>
80103f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f10 <print_space>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	56                   	push   %esi
80103f18:	8b 75 08             	mov    0x8(%ebp),%esi
80103f1b:	53                   	push   %ebx
  for (int i = 0; i < num; i++)
80103f1c:	85 f6                	test   %esi,%esi
80103f1e:	7e 1f                	jle    80103f3f <print_space+0x2f>
80103f20:	31 db                	xor    %ebx,%ebx
80103f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80103f28:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103f2b:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80103f2e:	68 76 8c 10 80       	push   $0x80108c76
80103f33:	e8 78 c7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80103f38:	83 c4 10             	add    $0x10,%esp
80103f3b:	39 de                	cmp    %ebx,%esi
80103f3d:	75 e9                	jne    80103f28 <print_space+0x18>
}
80103f3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f42:	5b                   	pop    %ebx
80103f43:	5e                   	pop    %esi
80103f44:	5d                   	pop    %ebp
80103f45:	c3                   	ret    
80103f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <print_bitches>:
{
80103f50:	f3 0f 1e fb          	endbr32 
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	57                   	push   %edi
80103f58:	56                   	push   %esi
80103f59:	53                   	push   %ebx
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103f5a:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103f5f:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80103f62:	68 80 4d 11 80       	push   $0x80114d80
80103f67:	e8 c4 12 00 00       	call   80105230 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103f6c:	c7 04 24 60 8d 10 80 	movl   $0x80108d60,(%esp)
80103f73:	e8 38 c7 ff ff       	call   801006b0 <cprintf>
80103f78:	83 c4 10             	add    $0x10,%esp
80103f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop
    cprintf("-");
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	68 61 8c 10 80       	push   $0x80108c61
80103f88:	e8 23 c7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < 80; i++)
80103f8d:	83 c4 10             	add    $0x10,%esp
80103f90:	83 eb 01             	sub    $0x1,%ebx
80103f93:	75 eb                	jne    80103f80 <print_bitches+0x30>
  cprintf("\n");
80103f95:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f98:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
    num /= 10;
80103f9d:	be 67 66 66 66       	mov    $0x66666667,%esi
  cprintf("\n");
80103fa2:	68 5b 91 10 80       	push   $0x8010915b
80103fa7:	e8 04 c7 ff ff       	call   801006b0 <cprintf>
80103fac:	83 c4 10             	add    $0x10,%esp
80103faf:	eb 19                	jmp    80103fca <print_bitches+0x7a>
80103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb8:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80103fbe:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80103fc4:	0f 84 9e 02 00 00    	je     80104268 <print_bitches+0x318>
    if (p->state == UNUSED)
80103fca:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103fcd:	85 c9                	test   %ecx,%ecx
80103fcf:	74 e7                	je     80103fb8 <print_bitches+0x68>
    print_name(p->name);
80103fd1:	83 ec 0c             	sub    $0xc,%esp
80103fd4:	8d 43 78             	lea    0x78(%ebx),%eax
80103fd7:	50                   	push   %eax
80103fd8:	e8 d3 fd ff ff       	call   80103db0 <print_name>
    cprintf("%d", p->pid);
80103fdd:	58                   	pop    %eax
80103fde:	5a                   	pop    %edx
80103fdf:	ff 73 10             	pushl  0x10(%ebx)
80103fe2:	68 63 8c 10 80       	push   $0x80108c63
80103fe7:	e8 c4 c6 ff ff       	call   801006b0 <cprintf>
    print_space(4 - (how_many_digit(p->pid)));
80103fec:	8b 4b 10             	mov    0x10(%ebx),%ecx
  if (num == 0)
80103fef:	83 c4 10             	add    $0x10,%esp
80103ff2:	85 c9                	test   %ecx,%ecx
80103ff4:	0f 84 a6 02 00 00    	je     801042a0 <print_bitches+0x350>
  int count = 0;
80103ffa:	31 ff                	xor    %edi,%edi
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    num /= 10;
80104000:	89 c8                	mov    %ecx,%eax
80104002:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80104005:	83 c7 01             	add    $0x1,%edi
    num /= 10;
80104008:	f7 ee                	imul   %esi
8010400a:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
8010400d:	29 ca                	sub    %ecx,%edx
8010400f:	89 d1                	mov    %edx,%ecx
80104011:	75 ed                	jne    80104000 <print_bitches+0xb0>
    print_space(4 - (how_many_digit(p->pid)));
80104013:	b8 04 00 00 00       	mov    $0x4,%eax
80104018:	29 f8                	sub    %edi,%eax
8010401a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
8010401d:	85 c0                	test   %eax,%eax
8010401f:	7e 1f                	jle    80104040 <print_bitches+0xf0>
    print_space(4 - (how_many_digit(p->pid)));
80104021:	31 ff                	xor    %edi,%edi
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
    cprintf(" ");
80104028:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
8010402b:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
8010402e:	68 76 8c 10 80       	push   $0x80108c76
80104033:	e8 78 c6 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	39 7d d8             	cmp    %edi,-0x28(%ebp)
8010403e:	7f e8                	jg     80104028 <print_bitches+0xd8>
    print_state((*p).state);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	ff 73 0c             	pushl  0xc(%ebx)
80104046:	e8 35 fe ff ff       	call   80103e80 <print_state>
    cprintf("%d     ", p->que_id);
8010404b:	58                   	pop    %eax
8010404c:	5a                   	pop    %edx
8010404d:	ff 73 28             	pushl  0x28(%ebx)
80104050:	68 66 8c 10 80       	push   $0x80108c66
80104055:	e8 56 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", (int)p->executed_cycle);
8010405a:	d9 83 94 00 00 00    	flds   0x94(%ebx)
80104060:	59                   	pop    %ecx
80104061:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104064:	5f                   	pop    %edi
80104065:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104069:	80 cc 0c             	or     $0xc,%ah
8010406c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104070:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104073:	db 5d d8             	fistpl -0x28(%ebp)
80104076:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104079:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010407c:	50                   	push   %eax
8010407d:	68 63 8c 10 80       	push   $0x80108c63
80104082:	e8 29 c6 ff ff       	call   801006b0 <cprintf>
    print_space(5 - how_many_digit((int)p->executed_cycle));
80104087:	d9 83 94 00 00 00    	flds   0x94(%ebx)
  if (num == 0)
8010408d:	83 c4 10             	add    $0x10,%esp
    print_space(5 - how_many_digit((int)p->executed_cycle));
80104090:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104093:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104097:	80 cc 0c             	or     $0xc,%ah
8010409a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
8010409e:	d9 6d e4             	fldcw  -0x1c(%ebp)
801040a1:	db 5d d8             	fistpl -0x28(%ebp)
801040a4:	d9 6d e6             	fldcw  -0x1a(%ebp)
801040a7:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  if (num == 0)
801040aa:	85 c9                	test   %ecx,%ecx
801040ac:	0f 84 de 01 00 00    	je     80104290 <print_bitches+0x340>
  int count = 0;
801040b2:	31 ff                	xor    %edi,%edi
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    num /= 10;
801040b8:	89 c8                	mov    %ecx,%eax
801040ba:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
801040bd:	83 c7 01             	add    $0x1,%edi
    num /= 10;
801040c0:	f7 ee                	imul   %esi
801040c2:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
801040c5:	29 ca                	sub    %ecx,%edx
801040c7:	89 d1                	mov    %edx,%ecx
801040c9:	75 ed                	jne    801040b8 <print_bitches+0x168>
    print_space(5 - how_many_digit((int)p->executed_cycle));
801040cb:	b8 05 00 00 00       	mov    $0x5,%eax
801040d0:	29 f8                	sub    %edi,%eax
801040d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
801040d5:	85 c0                	test   %eax,%eax
801040d7:	7e 1f                	jle    801040f8 <print_bitches+0x1a8>
    print_space(5 - how_many_digit((int)p->executed_cycle));
801040d9:	31 ff                	xor    %edi,%edi
801040db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040df:	90                   	nop
    cprintf(" ");
801040e0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
801040e3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
801040e6:	68 76 8c 10 80       	push   $0x80108c76
801040eb:	e8 c0 c5 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	3b 7d d8             	cmp    -0x28(%ebp),%edi
801040f6:	7c e8                	jl     801040e0 <print_bitches+0x190>
    cprintf("%d", p->creation_time);
801040f8:	83 ec 08             	sub    $0x8,%esp
801040fb:	ff 73 20             	pushl  0x20(%ebx)
801040fe:	68 63 8c 10 80       	push   $0x80108c63
80104103:	e8 a8 c5 ff ff       	call   801006b0 <cprintf>
    print_space(10 - how_many_digit(p->creation_time));
80104108:	8b 4b 20             	mov    0x20(%ebx),%ecx
  if (num == 0)
8010410b:	83 c4 10             	add    $0x10,%esp
8010410e:	85 c9                	test   %ecx,%ecx
80104110:	0f 84 6a 01 00 00    	je     80104280 <print_bitches+0x330>
  int count = 0;
80104116:	31 ff                	xor    %edi,%edi
80104118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop
    num /= 10;
80104120:	89 c8                	mov    %ecx,%eax
80104122:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80104125:	83 c7 01             	add    $0x1,%edi
    num /= 10;
80104128:	f7 ee                	imul   %esi
8010412a:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
8010412d:	29 ca                	sub    %ecx,%edx
8010412f:	89 d1                	mov    %edx,%ecx
80104131:	75 ed                	jne    80104120 <print_bitches+0x1d0>
    print_space(10 - how_many_digit(p->creation_time));
80104133:	b8 0a 00 00 00       	mov    $0xa,%eax
80104138:	29 f8                	sub    %edi,%eax
8010413a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
8010413d:	85 c0                	test   %eax,%eax
8010413f:	7e 1f                	jle    80104160 <print_bitches+0x210>
    print_space(10 - how_many_digit(p->creation_time));
80104141:	31 ff                	xor    %edi,%edi
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
    cprintf(" ");
80104148:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
8010414b:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
8010414e:	68 76 8c 10 80       	push   $0x80108c76
80104153:	e8 58 c5 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80104158:	83 c4 10             	add    $0x10,%esp
8010415b:	3b 7d d8             	cmp    -0x28(%ebp),%edi
8010415e:	7c e8                	jl     80104148 <print_bitches+0x1f8>
    cprintf("%d       ", p->priority);
80104160:	83 ec 08             	sub    $0x8,%esp
80104163:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104169:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
    cprintf("%d       ", p->priority);
8010416f:	68 6e 8c 10 80       	push   $0x80108c6e
80104174:	e8 37 c5 ff ff       	call   801006b0 <cprintf>
    cprintf("%d     ", (int)p->priority_ratio);
80104179:	d9 43 e8             	flds   -0x18(%ebx)
8010417c:	58                   	pop    %eax
8010417d:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104180:	5a                   	pop    %edx
80104181:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104185:	80 cc 0c             	or     $0xc,%ah
80104188:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
8010418c:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010418f:	db 5d d8             	fistpl -0x28(%ebp)
80104192:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104195:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104198:	50                   	push   %eax
80104199:	68 66 8c 10 80       	push   $0x80108c66
8010419e:	e8 0d c5 ff ff       	call   801006b0 <cprintf>
    cprintf("%d      ", (int)p->creation_time_ratio);
801041a3:	d9 43 ec             	flds   -0x14(%ebx)
801041a6:	59                   	pop    %ecx
801041a7:	d9 7d e6             	fnstcw -0x1a(%ebp)
801041aa:	5f                   	pop    %edi
801041ab:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801041af:	80 cc 0c             	or     $0xc,%ah
801041b2:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801041b6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801041b9:	db 5d d8             	fistpl -0x28(%ebp)
801041bc:	d9 6d e6             	fldcw  -0x1a(%ebp)
801041bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801041c2:	50                   	push   %eax
801041c3:	68 78 8c 10 80       	push   $0x80108c78
801041c8:	e8 e3 c4 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", (int)p->executed_cycle_ratio);
801041cd:	d9 43 f4             	flds   -0xc(%ebx)
801041d0:	58                   	pop    %eax
801041d1:	d9 7d e6             	fnstcw -0x1a(%ebp)
801041d4:	5a                   	pop    %edx
801041d5:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801041d9:	80 cc 0c             	or     $0xc,%ah
801041dc:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801041e0:	d9 6d e4             	fldcw  -0x1c(%ebp)
801041e3:	db 5d d8             	fistpl -0x28(%ebp)
801041e6:	d9 6d e6             	fldcw  -0x1a(%ebp)
801041e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801041ec:	50                   	push   %eax
801041ed:	68 81 8c 10 80       	push   $0x80108c81
801041f2:	e8 b9 c4 ff ff       	call   801006b0 <cprintf>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801041f7:	db 43 e4             	fildl  -0x1c(%ebx)
801041fa:	d8 4b e8             	fmuls  -0x18(%ebx)
801041fd:	31 d2                	xor    %edx,%edx
801041ff:	db 83 7c ff ff ff    	fildl  -0x84(%ebx)
80104205:	d8 4b ec             	fmuls  -0x14(%ebx)
80104208:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010420b:	8b 83 5c ff ff ff    	mov    -0xa4(%ebx),%eax
    cprintf("%d", (int)rank);
80104211:	59                   	pop    %ecx
80104212:	5f                   	pop    %edi
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104213:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104216:	de c1                	faddp  %st,%st(1)
80104218:	d9 43 f0             	flds   -0x10(%ebx)
8010421b:	d8 4b f4             	fmuls  -0xc(%ebx)
8010421e:	de c1                	faddp  %st,%st(1)
80104220:	df 6d d8             	fildll -0x28(%ebp)
80104223:	d8 4b f8             	fmuls  -0x8(%ebx)
    cprintf("%d", (int)rank);
80104226:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104229:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010422d:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)rank);
8010422f:	80 cc 0c             	or     $0xc,%ah
80104232:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104236:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104239:	db 5d d8             	fistpl -0x28(%ebp)
8010423c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010423f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104242:	50                   	push   %eax
80104243:	68 63 8c 10 80       	push   $0x80108c63
80104248:	e8 63 c4 ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
8010424d:	c7 04 24 5b 91 10 80 	movl   $0x8010915b,(%esp)
80104254:	e8 57 c4 ff ff       	call   801006b0 <cprintf>
80104259:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425c:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80104262:	0f 85 62 fd ff ff    	jne    80103fca <print_bitches+0x7a>
  release(&ptable.lock);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 80 4d 11 80       	push   $0x80114d80
80104270:	e8 7b 10 00 00       	call   801052f0 <release>
}
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010427b:	5b                   	pop    %ebx
8010427c:	5e                   	pop    %esi
8010427d:	5f                   	pop    %edi
8010427e:	5d                   	pop    %ebp
8010427f:	c3                   	ret    
    print_space(10 - how_many_digit(p->creation_time));
80104280:	c7 45 d8 09 00 00 00 	movl   $0x9,-0x28(%ebp)
80104287:	e9 b5 fe ff ff       	jmp    80104141 <print_bitches+0x1f1>
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(5 - how_many_digit((int)p->executed_cycle));
80104290:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
80104297:	e9 3d fe ff ff       	jmp    801040d9 <print_bitches+0x189>
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(4 - (how_many_digit(p->pid)));
801042a0:	c7 45 d8 03 00 00 00 	movl   $0x3,-0x28(%ebp)
801042a7:	e9 75 fd ff ff       	jmp    80104021 <print_bitches+0xd1>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <count_child>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	53                   	push   %ebx
  int count = 0;
801042b8:	31 db                	xor    %ebx,%ebx
{
801042ba:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801042bd:	68 80 4d 11 80       	push   $0x80114d80
801042c2:	e8 69 0f 00 00       	call   80105230 <acquire>
    if (p->parent->pid == father->pid)
801042c7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ca:	83 c4 10             	add    $0x10,%esp
801042cd:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042d0:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
801042d5:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->parent->pid == father->pid)
801042d8:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
801042db:	39 4a 10             	cmp    %ecx,0x10(%edx)
801042de:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e1:	05 a4 00 00 00       	add    $0xa4,%eax
      count++;
801042e6:	0f b6 d2             	movzbl %dl,%edx
801042e9:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042eb:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
801042f0:	75 e6                	jne    801042d8 <count_child+0x28>
  release(&ptable.lock);
801042f2:	83 ec 0c             	sub    $0xc,%esp
801042f5:	68 80 4d 11 80       	push   $0x80114d80
801042fa:	e8 f1 0f 00 00       	call   801052f0 <release>
}
801042ff:	89 d8                	mov    %ebx,%eax
80104301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104304:	c9                   	leave  
80104305:	c3                   	ret    
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <growproc>:
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	56                   	push   %esi
80104318:	53                   	push   %ebx
80104319:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010431c:	e8 0f 0e 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104321:	e8 8a f7 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104326:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010432c:	e8 4f 0e 00 00       	call   80105180 <popcli>
  sz = curproc->sz;
80104331:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80104333:	85 f6                	test   %esi,%esi
80104335:	7f 19                	jg     80104350 <growproc+0x40>
  else if (n < 0)
80104337:	75 37                	jne    80104370 <growproc+0x60>
  switchuvm(curproc);
80104339:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010433c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010433e:	53                   	push   %ebx
8010433f:	e8 fc 39 00 00       	call   80107d40 <switchuvm>
  return 0;
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	31 c0                	xor    %eax,%eax
}
80104349:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434c:	5b                   	pop    %ebx
8010434d:	5e                   	pop    %esi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104350:	83 ec 04             	sub    $0x4,%esp
80104353:	01 c6                	add    %eax,%esi
80104355:	56                   	push   %esi
80104356:	50                   	push   %eax
80104357:	ff 73 04             	pushl  0x4(%ebx)
8010435a:	e8 41 3c 00 00       	call   80107fa0 <allocuvm>
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	85 c0                	test   %eax,%eax
80104364:	75 d3                	jne    80104339 <growproc+0x29>
      return -1;
80104366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010436b:	eb dc                	jmp    80104349 <growproc+0x39>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104370:	83 ec 04             	sub    $0x4,%esp
80104373:	01 c6                	add    %eax,%esi
80104375:	56                   	push   %esi
80104376:	50                   	push   %eax
80104377:	ff 73 04             	pushl  0x4(%ebx)
8010437a:	e8 51 3d 00 00       	call   801080d0 <deallocuvm>
8010437f:	83 c4 10             	add    $0x10,%esp
80104382:	85 c0                	test   %eax,%eax
80104384:	75 b3                	jne    80104339 <growproc+0x29>
80104386:	eb de                	jmp    80104366 <growproc+0x56>
80104388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438f:	90                   	nop

80104390 <fork>:
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	57                   	push   %edi
80104398:	56                   	push   %esi
80104399:	53                   	push   %ebx
8010439a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010439d:	e8 8e 0d 00 00       	call   80105130 <pushcli>
  c = mycpu();
801043a2:	e8 09 f7 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801043a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ad:	e8 ce 0d 00 00       	call   80105180 <popcli>
  if ((np = allocproc()) == 0)
801043b2:	e8 19 f5 ff ff       	call   801038d0 <allocproc>
801043b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043ba:	85 c0                	test   %eax,%eax
801043bc:	0f 84 de 00 00 00    	je     801044a0 <fork+0x110>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
801043c2:	83 ec 08             	sub    $0x8,%esp
801043c5:	ff 33                	pushl  (%ebx)
801043c7:	89 c7                	mov    %eax,%edi
801043c9:	ff 73 04             	pushl  0x4(%ebx)
801043cc:	e8 7f 3e 00 00       	call   80108250 <copyuvm>
801043d1:	83 c4 10             	add    $0x10,%esp
801043d4:	89 47 04             	mov    %eax,0x4(%edi)
801043d7:	85 c0                	test   %eax,%eax
801043d9:	0f 84 c8 00 00 00    	je     801044a7 <fork+0x117>
  np->sz = curproc->sz;
801043df:	8b 03                	mov    (%ebx),%eax
801043e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043e4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801043e6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801043e9:	89 c8                	mov    %ecx,%eax
801043eb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801043ee:	b9 13 00 00 00       	mov    $0x13,%ecx
801043f3:	8b 73 18             	mov    0x18(%ebx),%esi
801043f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801043f8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801043fa:	8b 40 18             	mov    0x18(%eax),%eax
801043fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80104408:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
8010440c:	85 c0                	test   %eax,%eax
8010440e:	74 13                	je     80104423 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	50                   	push   %eax
80104414:	e8 57 ca ff ff       	call   80100e70 <filedup>
80104419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80104423:	83 c6 01             	add    $0x1,%esi
80104426:	83 fe 10             	cmp    $0x10,%esi
80104429:	75 dd                	jne    80104408 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	ff 73 74             	pushl  0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104431:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
80104434:	e8 f7 d2 ff ff       	call   80101730 <idup>
80104439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010443c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010443f:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104442:	8d 47 78             	lea    0x78(%edi),%eax
80104445:	6a 10                	push   $0x10
80104447:	53                   	push   %ebx
80104448:	50                   	push   %eax
80104449:	e8 b2 10 00 00       	call   80105500 <safestrcpy>
  pid = np->pid;
8010444e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104451:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104458:	e8 d3 0d 00 00       	call   80105230 <acquire>
  np->state = RUNNABLE;
8010445d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80104464:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
8010446b:	e8 c0 0d 00 00       	call   80105230 <acquire>
  np->creation_time = ticks;
80104470:	a1 00 7f 11 80       	mov    0x80117f00,%eax
80104475:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80104478:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
8010447b:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
80104482:	e8 69 0e 00 00       	call   801052f0 <release>
  release(&ptable.lock);
80104487:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
8010448e:	e8 5d 0e 00 00       	call   801052f0 <release>
  return pid;
80104493:	83 c4 10             	add    $0x10,%esp
}
80104496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104499:	89 d8                	mov    %ebx,%eax
8010449b:	5b                   	pop    %ebx
8010449c:	5e                   	pop    %esi
8010449d:	5f                   	pop    %edi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    
    return -1;
801044a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044a5:	eb ef                	jmp    80104496 <fork+0x106>
    kfree(np->kstack);
801044a7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801044aa:	83 ec 0c             	sub    $0xc,%esp
801044ad:	ff 73 08             	pushl  0x8(%ebx)
801044b0:	e8 bb df ff ff       	call   80102470 <kfree>
    np->kstack = 0;
801044b5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801044bc:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801044bf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801044c6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044cb:	eb c9                	jmp    80104496 <fork+0x106>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi

801044d0 <round_robin>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
  int max_diff = MIN_INT;
801044d5:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044da:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
{
801044df:	89 e5                	mov    %esp,%ebp
801044e1:	56                   	push   %esi
  struct proc *res = 0;
801044e2:	31 f6                	xor    %esi,%esi
{
801044e4:	53                   	push   %ebx
  int now = ticks;
801044e5:	8b 1d 00 7f 11 80    	mov    0x80117f00,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044ef:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
801044f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801044f4:	75 1a                	jne    80104510 <round_robin+0x40>
801044f6:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
801044fa:	75 14                	jne    80104510 <round_robin+0x40>
    if ((now - p->preemption_time > max_diff))
801044fc:	89 da                	mov    %ebx,%edx
801044fe:	2b 50 24             	sub    0x24(%eax),%edx
80104501:	39 ca                	cmp    %ecx,%edx
80104503:	7e 0b                	jle    80104510 <round_robin+0x40>
80104505:	89 d1                	mov    %edx,%ecx
80104507:	89 c6                	mov    %eax,%esi
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104510:	05 a4 00 00 00       	add    $0xa4,%eax
80104515:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
8010451a:	75 d4                	jne    801044f0 <round_robin+0x20>
}
8010451c:	89 f0                	mov    %esi,%eax
8010451e:	5b                   	pop    %ebx
8010451f:	5e                   	pop    %esi
80104520:	5d                   	pop    %ebp
80104521:	c3                   	ret    
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <last_come_first_serve>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
  int latest_time = MIN_INT;
80104535:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010453a:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
{
8010453f:	89 e5                	mov    %esp,%ebp
80104541:	53                   	push   %ebx
  struct proc *res = 0;
80104542:	31 db                	xor    %ebx,%ebx
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
80104548:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010454c:	75 12                	jne    80104560 <last_come_first_serve+0x30>
8010454e:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80104552:	75 0c                	jne    80104560 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
80104554:	8b 50 20             	mov    0x20(%eax),%edx
80104557:	39 ca                	cmp    %ecx,%edx
80104559:	7e 05                	jle    80104560 <last_come_first_serve+0x30>
8010455b:	89 d1                	mov    %edx,%ecx
8010455d:	89 c3                	mov    %eax,%ebx
8010455f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104560:	05 a4 00 00 00       	add    $0xa4,%eax
80104565:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
8010456a:	75 dc                	jne    80104548 <last_come_first_serve+0x18>
}
8010456c:	89 d8                	mov    %ebx,%eax
8010456e:	5b                   	pop    %ebx
8010456f:	5d                   	pop    %ebp
80104570:	c3                   	ret    
80104571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457f:	90                   	nop

80104580 <best_job_first>:
{
80104580:	f3 0f 1e fb          	endbr32 
  float min_rank = (float)MAX_INT;
80104584:	d9 05 e8 8d 10 80    	flds   0x80108de8
  struct proc *res = 0;
8010458a:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010458c:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104598:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010459c:	0f 85 96 00 00 00    	jne    80104638 <best_job_first+0xb8>
801045a2:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
801045a6:	0f 85 8c 00 00 00    	jne    80104638 <best_job_first+0xb8>
{
801045ac:	55                   	push   %ebp
801045ad:	89 e5                	mov    %esp,%ebp
801045af:	53                   	push   %ebx
801045b0:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801045b3:	db 80 88 00 00 00    	fildl  0x88(%eax)
801045b9:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
801045bf:	31 db                	xor    %ebx,%ebx
801045c1:	db 40 20             	fildl  0x20(%eax)
801045c4:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
801045ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801045cd:	8b 08                	mov    (%eax),%ecx
801045cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
801045d2:	de c1                	faddp  %st,%st(1)
801045d4:	d9 80 94 00 00 00    	flds   0x94(%eax)
801045da:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
801045e0:	de c1                	faddp  %st,%st(1)
801045e2:	df 6d f0             	fildll -0x10(%ebp)
801045e5:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
801045eb:	de c1                	faddp  %st,%st(1)
801045ed:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
801045ef:	db f1                	fcomi  %st(1),%st
801045f1:	76 0d                	jbe    80104600 <best_job_first+0x80>
801045f3:	dd d8                	fstp   %st(0)
801045f5:	89 c2                	mov    %eax,%edx
801045f7:	eb 09                	jmp    80104602 <best_job_first+0x82>
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104600:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104602:	05 a4 00 00 00       	add    $0xa4,%eax
80104607:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
8010460c:	74 1c                	je     8010462a <best_job_first+0xaa>
    if (p->state != RUNNABLE || p->que_id != BJF)
8010460e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104612:	75 ee                	jne    80104602 <best_job_first+0x82>
80104614:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104618:	74 99                	je     801045b3 <best_job_first+0x33>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010461a:	05 a4 00 00 00       	add    $0xa4,%eax
8010461f:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104624:	75 e8                	jne    8010460e <best_job_first+0x8e>
80104626:	dd d8                	fstp   %st(0)
80104628:	eb 02                	jmp    8010462c <best_job_first+0xac>
8010462a:	dd d8                	fstp   %st(0)
}
8010462c:	83 c4 0c             	add    $0xc,%esp
8010462f:	89 d0                	mov    %edx,%eax
80104631:	5b                   	pop    %ebx
80104632:	5d                   	pop    %ebp
80104633:	c3                   	ret    
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104638:	05 a4 00 00 00       	add    $0xa4,%eax
8010463d:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104642:	0f 85 50 ff ff ff    	jne    80104598 <best_job_first+0x18>
80104648:	dd d8                	fstp   %st(0)
}
8010464a:	89 d0                	mov    %edx,%eax
8010464c:	c3                   	ret    
8010464d:	8d 76 00             	lea    0x0(%esi),%esi

80104650 <scheduler>:
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	57                   	push   %edi
80104658:	56                   	push   %esi
80104659:	53                   	push   %ebx
8010465a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
8010465d:	e8 4e f4 ff ff       	call   80103ab0 <mycpu>
  c->proc = 0;
80104662:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104669:	00 00 00 
  struct cpu *c = mycpu();
8010466c:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
8010466e:	8d 40 04             	lea    0x4(%eax),%eax
80104671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104678:	fb                   	sti    
    acquire(&ptable.lock);
80104679:	83 ec 0c             	sub    $0xc,%esp
  struct proc *res = 0;
8010467c:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
8010467e:	68 80 4d 11 80       	push   $0x80114d80
80104683:	e8 a8 0b 00 00       	call   80105230 <acquire>
  int now = ticks;
80104688:	8b 3d 00 7f 11 80    	mov    0x80117f00,%edi
8010468e:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104691:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104696:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
8010469b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
801046a0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801046a4:	75 1a                	jne    801046c0 <scheduler+0x70>
801046a6:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
801046aa:	75 14                	jne    801046c0 <scheduler+0x70>
    if ((now - p->preemption_time > max_diff))
801046ac:	89 fa                	mov    %edi,%edx
801046ae:	2b 50 24             	sub    0x24(%eax),%edx
801046b1:	39 ca                	cmp    %ecx,%edx
801046b3:	7e 0b                	jle    801046c0 <scheduler+0x70>
801046b5:	89 d1                	mov    %edx,%ecx
801046b7:	89 c6                	mov    %eax,%esi
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c0:	05 a4 00 00 00       	add    $0xa4,%eax
801046c5:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
801046ca:	75 d4                	jne    801046a0 <scheduler+0x50>
    if (p == 0)
801046cc:	85 f6                	test   %esi,%esi
801046ce:	74 60                	je     80104730 <scheduler+0xe0>
    switchuvm(p);
801046d0:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
801046d3:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(p);
801046d9:	56                   	push   %esi
801046da:	e8 61 36 00 00       	call   80107d40 <switchuvm>
    p->executed_cycle += 0.1f;
801046df:	d9 05 e4 8d 10 80    	flds   0x80108de4
801046e5:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
801046eb:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
801046f2:	a1 00 7f 11 80       	mov    0x80117f00,%eax
801046f7:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
801046fa:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
80104700:	58                   	pop    %eax
80104701:	5a                   	pop    %edx
80104702:	ff 76 1c             	pushl  0x1c(%esi)
80104705:	ff 75 e4             	pushl  -0x1c(%ebp)
80104708:	e8 56 0e 00 00       	call   80105563 <swtch>
    switchkvm();
8010470d:	e8 0e 36 00 00       	call   80107d20 <switchkvm>
    c->proc = 0;
80104712:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104719:	00 00 00 
    release(&ptable.lock);
8010471c:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104723:	e8 c8 0b 00 00       	call   801052f0 <release>
80104728:	83 c4 10             	add    $0x10,%esp
8010472b:	e9 48 ff ff ff       	jmp    80104678 <scheduler+0x28>
  int latest_time = MIN_INT;
80104730:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104735:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
80104740:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104744:	75 1a                	jne    80104760 <scheduler+0x110>
80104746:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
8010474a:	75 14                	jne    80104760 <scheduler+0x110>
    if (p->creation_time > latest_time)
8010474c:	8b 50 20             	mov    0x20(%eax),%edx
8010474f:	39 ca                	cmp    %ecx,%edx
80104751:	7e 0d                	jle    80104760 <scheduler+0x110>
80104753:	89 d1                	mov    %edx,%ecx
80104755:	89 c6                	mov    %eax,%esi
80104757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104760:	05 a4 00 00 00       	add    $0xa4,%eax
80104765:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
8010476a:	75 d4                	jne    80104740 <scheduler+0xf0>
    if (p == 0)
8010476c:	85 f6                	test   %esi,%esi
8010476e:	0f 85 5c ff ff ff    	jne    801046d0 <scheduler+0x80>
      p = best_job_first();
80104774:	e8 07 fe ff ff       	call   80104580 <best_job_first>
80104779:	89 c6                	mov    %eax,%esi
    if (p == 0)
8010477b:	85 c0                	test   %eax,%eax
8010477d:	0f 85 4d ff ff ff    	jne    801046d0 <scheduler+0x80>
      release(&ptable.lock);
80104783:	83 ec 0c             	sub    $0xc,%esp
80104786:	68 80 4d 11 80       	push   $0x80114d80
8010478b:	e8 60 0b 00 00       	call   801052f0 <release>
      continue;
80104790:	83 c4 10             	add    $0x10,%esp
80104793:	e9 e0 fe ff ff       	jmp    80104678 <scheduler+0x28>
80104798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <sched>:
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	56                   	push   %esi
801047a8:	53                   	push   %ebx
  pushcli();
801047a9:	e8 82 09 00 00       	call   80105130 <pushcli>
  c = mycpu();
801047ae:	e8 fd f2 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801047b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047b9:	e8 c2 09 00 00       	call   80105180 <popcli>
  if (!holding(&ptable.lock))
801047be:	83 ec 0c             	sub    $0xc,%esp
801047c1:	68 80 4d 11 80       	push   $0x80114d80
801047c6:	e8 15 0a 00 00       	call   801051e0 <holding>
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	85 c0                	test   %eax,%eax
801047d0:	74 4f                	je     80104821 <sched+0x81>
  if (mycpu()->ncli != 1)
801047d2:	e8 d9 f2 ff ff       	call   80103ab0 <mycpu>
801047d7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801047de:	75 68                	jne    80104848 <sched+0xa8>
  if (p->state == RUNNING)
801047e0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801047e4:	74 55                	je     8010483b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047e6:	9c                   	pushf  
801047e7:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801047e8:	f6 c4 02             	test   $0x2,%ah
801047eb:	75 41                	jne    8010482e <sched+0x8e>
  intena = mycpu()->intena;
801047ed:	e8 be f2 ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801047f2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801047f5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801047fb:	e8 b0 f2 ff ff       	call   80103ab0 <mycpu>
80104800:	83 ec 08             	sub    $0x8,%esp
80104803:	ff 70 04             	pushl  0x4(%eax)
80104806:	53                   	push   %ebx
80104807:	e8 57 0d 00 00       	call   80105563 <swtch>
  mycpu()->intena = intena;
8010480c:	e8 9f f2 ff ff       	call   80103ab0 <mycpu>
}
80104811:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104814:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010481a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
    panic("sched ptable.lock");
80104821:	83 ec 0c             	sub    $0xc,%esp
80104824:	68 87 8c 10 80       	push   $0x80108c87
80104829:	e8 62 bb ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010482e:	83 ec 0c             	sub    $0xc,%esp
80104831:	68 b3 8c 10 80       	push   $0x80108cb3
80104836:	e8 55 bb ff ff       	call   80100390 <panic>
    panic("sched running");
8010483b:	83 ec 0c             	sub    $0xc,%esp
8010483e:	68 a5 8c 10 80       	push   $0x80108ca5
80104843:	e8 48 bb ff ff       	call   80100390 <panic>
    panic("sched locks");
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	68 99 8c 10 80       	push   $0x80108c99
80104850:	e8 3b bb ff ff       	call   80100390 <panic>
80104855:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <exit>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	56                   	push   %esi
80104869:	53                   	push   %ebx
8010486a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010486d:	e8 be 08 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104872:	e8 39 f2 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104877:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010487d:	e8 fe 08 00 00       	call   80105180 <popcli>
  if (curproc == initproc)
80104882:	8d 5e 34             	lea    0x34(%esi),%ebx
80104885:	8d 7e 74             	lea    0x74(%esi),%edi
80104888:	39 35 bc c5 10 80    	cmp    %esi,0x8010c5bc
8010488e:	0f 84 fd 00 00 00    	je     80104991 <exit+0x131>
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104898:	8b 03                	mov    (%ebx),%eax
8010489a:	85 c0                	test   %eax,%eax
8010489c:	74 12                	je     801048b0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	50                   	push   %eax
801048a2:	e8 19 c6 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801048a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801048ad:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801048b0:	83 c3 04             	add    $0x4,%ebx
801048b3:	39 df                	cmp    %ebx,%edi
801048b5:	75 e1                	jne    80104898 <exit+0x38>
  begin_op();
801048b7:	e8 74 e4 ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
801048bc:	83 ec 0c             	sub    $0xc,%esp
801048bf:	ff 76 74             	pushl  0x74(%esi)
801048c2:	e8 c9 cf ff ff       	call   80101890 <iput>
  end_op();
801048c7:	e8 d4 e4 ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
801048cc:	c7 46 74 00 00 00 00 	movl   $0x0,0x74(%esi)
  acquire(&ptable.lock);
801048d3:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801048da:	e8 51 09 00 00       	call   80105230 <acquire>
  wakeup1(curproc->parent);
801048df:	8b 56 14             	mov    0x14(%esi),%edx
801048e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048e5:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
801048ea:	eb 10                	jmp    801048fc <exit+0x9c>
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f0:	05 a4 00 00 00       	add    $0xa4,%eax
801048f5:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
801048fa:	74 1e                	je     8010491a <exit+0xba>
    if (p->state == SLEEPING && p->chan == chan)
801048fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104900:	75 ee                	jne    801048f0 <exit+0x90>
80104902:	3b 50 2c             	cmp    0x2c(%eax),%edx
80104905:	75 e9                	jne    801048f0 <exit+0x90>
      p->state = RUNNABLE;
80104907:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010490e:	05 a4 00 00 00       	add    $0xa4,%eax
80104913:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104918:	75 e2                	jne    801048fc <exit+0x9c>
      p->parent = initproc;
8010491a:	8b 0d bc c5 10 80    	mov    0x8010c5bc,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104920:	ba b4 4d 11 80       	mov    $0x80114db4,%edx
80104925:	eb 17                	jmp    8010493e <exit+0xde>
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax
80104930:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80104936:	81 fa b4 76 11 80    	cmp    $0x801176b4,%edx
8010493c:	74 3a                	je     80104978 <exit+0x118>
    if (p->parent == curproc)
8010493e:	39 72 14             	cmp    %esi,0x14(%edx)
80104941:	75 ed                	jne    80104930 <exit+0xd0>
      if (p->state == ZOMBIE)
80104943:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104947:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010494a:	75 e4                	jne    80104930 <exit+0xd0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010494c:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104951:	eb 11                	jmp    80104964 <exit+0x104>
80104953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104957:	90                   	nop
80104958:	05 a4 00 00 00       	add    $0xa4,%eax
8010495d:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104962:	74 cc                	je     80104930 <exit+0xd0>
    if (p->state == SLEEPING && p->chan == chan)
80104964:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104968:	75 ee                	jne    80104958 <exit+0xf8>
8010496a:	3b 48 2c             	cmp    0x2c(%eax),%ecx
8010496d:	75 e9                	jne    80104958 <exit+0xf8>
      p->state = RUNNABLE;
8010496f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104976:	eb e0                	jmp    80104958 <exit+0xf8>
  curproc->state = ZOMBIE;
80104978:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010497f:	e8 1c fe ff ff       	call   801047a0 <sched>
  panic("zombie exit");
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	68 d4 8c 10 80       	push   $0x80108cd4
8010498c:	e8 ff b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104991:	83 ec 0c             	sub    $0xc,%esp
80104994:	68 c7 8c 10 80       	push   $0x80108cc7
80104999:	e8 f2 b9 ff ff       	call   80100390 <panic>
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <yield>:
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	56                   	push   %esi
801049a8:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
801049a9:	83 ec 0c             	sub    $0xc,%esp
801049ac:	68 80 4d 11 80       	push   $0x80114d80
801049b1:	e8 7a 08 00 00       	call   80105230 <acquire>
  pushcli();
801049b6:	e8 75 07 00 00       	call   80105130 <pushcli>
  c = mycpu();
801049bb:	e8 f0 f0 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801049c0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049c6:	e8 b5 07 00 00       	call   80105180 <popcli>
  myproc()->preemption_time = ticks;
801049cb:	8b 35 00 7f 11 80    	mov    0x80117f00,%esi
  myproc()->state = RUNNABLE;
801049d1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801049d8:	e8 53 07 00 00       	call   80105130 <pushcli>
  c = mycpu();
801049dd:	e8 ce f0 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801049e2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049e8:	e8 93 07 00 00       	call   80105180 <popcli>
  myproc()->preemption_time = ticks;
801049ed:	89 73 24             	mov    %esi,0x24(%ebx)
  pushcli();
801049f0:	e8 3b 07 00 00       	call   80105130 <pushcli>
  c = mycpu();
801049f5:	e8 b6 f0 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801049fa:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a00:	e8 7b 07 00 00       	call   80105180 <popcli>
  myproc()->executed_cycle += 0.1;
80104a05:	dd 05 f0 8d 10 80    	fldl   0x80108df0
80104a0b:	d8 83 94 00 00 00    	fadds  0x94(%ebx)
80104a11:	d9 9b 94 00 00 00    	fstps  0x94(%ebx)
  sched();
80104a17:	e8 84 fd ff ff       	call   801047a0 <sched>
  release(&ptable.lock);
80104a1c:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104a23:	e8 c8 08 00 00       	call   801052f0 <release>
}
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a2e:	5b                   	pop    %ebx
80104a2f:	5e                   	pop    %esi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret    
80104a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a40 <sleep>:
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	57                   	push   %edi
80104a48:	56                   	push   %esi
80104a49:	53                   	push   %ebx
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104a53:	e8 d8 06 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104a58:	e8 53 f0 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104a5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a63:	e8 18 07 00 00       	call   80105180 <popcli>
  if (p == 0)
80104a68:	85 db                	test   %ebx,%ebx
80104a6a:	0f 84 83 00 00 00    	je     80104af3 <sleep+0xb3>
  if (lk == 0)
80104a70:	85 f6                	test   %esi,%esi
80104a72:	74 72                	je     80104ae6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104a74:	81 fe 80 4d 11 80    	cmp    $0x80114d80,%esi
80104a7a:	74 4c                	je     80104ac8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104a7c:	83 ec 0c             	sub    $0xc,%esp
80104a7f:	68 80 4d 11 80       	push   $0x80114d80
80104a84:	e8 a7 07 00 00       	call   80105230 <acquire>
    release(lk);
80104a89:	89 34 24             	mov    %esi,(%esp)
80104a8c:	e8 5f 08 00 00       	call   801052f0 <release>
  p->chan = chan;
80104a91:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104a94:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a9b:	e8 00 fd ff ff       	call   801047a0 <sched>
  p->chan = 0;
80104aa0:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
80104aa7:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104aae:	e8 3d 08 00 00       	call   801052f0 <release>
    acquire(lk);
80104ab3:	89 75 08             	mov    %esi,0x8(%ebp)
80104ab6:	83 c4 10             	add    $0x10,%esp
}
80104ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104abc:	5b                   	pop    %ebx
80104abd:	5e                   	pop    %esi
80104abe:	5f                   	pop    %edi
80104abf:	5d                   	pop    %ebp
    acquire(lk);
80104ac0:	e9 6b 07 00 00       	jmp    80105230 <acquire>
80104ac5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104ac8:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104acb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ad2:	e8 c9 fc ff ff       	call   801047a0 <sched>
  p->chan = 0;
80104ad7:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
80104ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae1:	5b                   	pop    %ebx
80104ae2:	5e                   	pop    %esi
80104ae3:	5f                   	pop    %edi
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
    panic("sleep without lk");
80104ae6:	83 ec 0c             	sub    $0xc,%esp
80104ae9:	68 e6 8c 10 80       	push   $0x80108ce6
80104aee:	e8 9d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	68 e0 8c 10 80       	push   $0x80108ce0
80104afb:	e8 90 b8 ff ff       	call   80100390 <panic>

80104b00 <wait>:
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	56                   	push   %esi
80104b08:	53                   	push   %ebx
  pushcli();
80104b09:	e8 22 06 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104b0e:	e8 9d ef ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104b13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b19:	e8 62 06 00 00       	call   80105180 <popcli>
  acquire(&ptable.lock);
80104b1e:	83 ec 0c             	sub    $0xc,%esp
80104b21:	68 80 4d 11 80       	push   $0x80114d80
80104b26:	e8 05 07 00 00       	call   80105230 <acquire>
80104b2b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b2e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b30:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104b35:	eb 17                	jmp    80104b4e <wait+0x4e>
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax
80104b40:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104b46:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80104b4c:	74 1e                	je     80104b6c <wait+0x6c>
      if (p->parent != curproc)
80104b4e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104b51:	75 ed                	jne    80104b40 <wait+0x40>
      if (p->state == ZOMBIE)
80104b53:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104b57:	74 37                	je     80104b90 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b59:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      havekids = 1;
80104b5f:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b64:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80104b6a:	75 e2                	jne    80104b4e <wait+0x4e>
    if (!havekids || curproc->killed)
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	74 76                	je     80104be6 <wait+0xe6>
80104b70:	8b 46 30             	mov    0x30(%esi),%eax
80104b73:	85 c0                	test   %eax,%eax
80104b75:	75 6f                	jne    80104be6 <wait+0xe6>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104b77:	83 ec 08             	sub    $0x8,%esp
80104b7a:	68 80 4d 11 80       	push   $0x80114d80
80104b7f:	56                   	push   %esi
80104b80:	e8 bb fe ff ff       	call   80104a40 <sleep>
    havekids = 0;
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	eb a4                	jmp    80104b2e <wait+0x2e>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104b96:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104b99:	e8 d2 d8 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80104b9e:	5a                   	pop    %edx
80104b9f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104ba2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104ba9:	e8 52 35 00 00       	call   80108100 <freevm>
        release(&ptable.lock);
80104bae:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
        p->pid = 0;
80104bb5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104bbc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104bc3:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
80104bc7:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
80104bce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104bd5:	e8 16 07 00 00       	call   801052f0 <release>
        return pid;
80104bda:	83 c4 10             	add    $0x10,%esp
}
80104bdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be0:	89 f0                	mov    %esi,%eax
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
      release(&ptable.lock);
80104be6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104be9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104bee:	68 80 4d 11 80       	push   $0x80114d80
80104bf3:	e8 f8 06 00 00       	call   801052f0 <release>
      return -1;
80104bf8:	83 c4 10             	add    $0x10,%esp
80104bfb:	eb e0                	jmp    80104bdd <wait+0xdd>
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	53                   	push   %ebx
80104c08:	83 ec 10             	sub    $0x10,%esp
80104c0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c0e:	68 80 4d 11 80       	push   $0x80114d80
80104c13:	e8 18 06 00 00       	call   80105230 <acquire>
80104c18:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c1b:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104c20:	eb 12                	jmp    80104c34 <wakeup+0x34>
80104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c28:	05 a4 00 00 00       	add    $0xa4,%eax
80104c2d:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104c32:	74 1e                	je     80104c52 <wakeup+0x52>
    if (p->state == SLEEPING && p->chan == chan)
80104c34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c38:	75 ee                	jne    80104c28 <wakeup+0x28>
80104c3a:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104c3d:	75 e9                	jne    80104c28 <wakeup+0x28>
      p->state = RUNNABLE;
80104c3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c46:	05 a4 00 00 00       	add    $0xa4,%eax
80104c4b:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104c50:	75 e2                	jne    80104c34 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104c52:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80104c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5c:	c9                   	leave  
  release(&ptable.lock);
80104c5d:	e9 8e 06 00 00       	jmp    801052f0 <release>
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c70 <wakeup_pl>:
void wakeup_pl(void *chan)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	56                   	push   %esi
  acquire(&ptable.lock);
  struct proc *p;
  int max_pid = 0;
  struct proc *chosen_one = 0;
80104c78:	31 f6                	xor    %esi,%esi
{
80104c7a:	53                   	push   %ebx
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c7e:	83 ec 0c             	sub    $0xc,%esp
80104c81:	68 80 4d 11 80       	push   $0x80114d80
80104c86:	e8 a5 05 00 00       	call   80105230 <acquire>
80104c8b:	83 c4 10             	add    $0x10,%esp
  int max_pid = 0;
80104c8e:	31 c9                	xor    %ecx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c90:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104c95:	eb 15                	jmp    80104cac <wakeup_pl+0x3c>
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax
80104ca0:	05 a4 00 00 00       	add    $0xa4,%eax
80104ca5:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104caa:	74 24                	je     80104cd0 <wakeup_pl+0x60>
  {
    if (p->chan == chan && p->pid > max_pid && p->state == SLEEPING)
80104cac:	39 58 2c             	cmp    %ebx,0x2c(%eax)
80104caf:	75 ef                	jne    80104ca0 <wakeup_pl+0x30>
80104cb1:	8b 50 10             	mov    0x10(%eax),%edx
80104cb4:	39 ca                	cmp    %ecx,%edx
80104cb6:	7e e8                	jle    80104ca0 <wakeup_pl+0x30>
80104cb8:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104cbc:	0f 44 f0             	cmove  %eax,%esi
80104cbf:	0f 44 ca             	cmove  %edx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cc2:	05 a4 00 00 00       	add    $0xa4,%eax
80104cc7:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104ccc:	75 de                	jne    80104cac <wakeup_pl+0x3c>
80104cce:	66 90                	xchg   %ax,%ax
    {
      max_pid = p->pid;
      chosen_one = p;
    }
  }
  if (max_pid != 0)
80104cd0:	85 c9                	test   %ecx,%ecx
80104cd2:	74 07                	je     80104cdb <wakeup_pl+0x6b>
  {
    chosen_one->state = RUNNABLE;
80104cd4:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  }
  release(&ptable.lock);
80104cdb:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80104ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce5:	5b                   	pop    %ebx
80104ce6:	5e                   	pop    %esi
80104ce7:	5d                   	pop    %ebp
  release(&ptable.lock);
80104ce8:	e9 03 06 00 00       	jmp    801052f0 <release>
80104ced:	8d 76 00             	lea    0x0(%esi),%esi

80104cf0 <print_lock_que>:
void print_lock_que(struct priority_lock * a)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	56                   	push   %esi
80104cf8:	53                   	push   %ebx
80104cf9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cfc:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
  acquire(&ptable.lock);
80104d01:	83 ec 0c             	sub    $0xc,%esp
80104d04:	68 80 4d 11 80       	push   $0x80114d80
80104d09:	e8 22 05 00 00       	call   80105230 <acquire>
80104d0e:	83 c4 10             	add    $0x10,%esp
80104d11:	eb 13                	jmp    80104d26 <print_lock_que+0x36>
80104d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d17:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d18:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104d1e:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80104d24:	74 36                	je     80104d5c <print_lock_que+0x6c>
  {
    if (p->chan ==  a)
80104d26:	39 73 2c             	cmp    %esi,0x2c(%ebx)
80104d29:	75 ed                	jne    80104d18 <print_lock_que+0x28>
    {
      cprintf("%d\t",p->pid);
80104d2b:	83 ec 08             	sub    $0x8,%esp
80104d2e:	ff 73 10             	pushl  0x10(%ebx)
80104d31:	68 f7 8c 10 80       	push   $0x80108cf7
80104d36:	e8 75 b9 ff ff       	call   801006b0 <cprintf>
      cprintf("%s\t",p->name);
80104d3b:	58                   	pop    %eax
80104d3c:	8d 43 78             	lea    0x78(%ebx),%eax
80104d3f:	5a                   	pop    %edx
80104d40:	50                   	push   %eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d41:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      cprintf("%s\t",p->name);
80104d47:	68 fb 8c 10 80       	push   $0x80108cfb
80104d4c:	e8 5f b9 ff ff       	call   801006b0 <cprintf>
80104d51:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d54:	81 fb b4 76 11 80    	cmp    $0x801176b4,%ebx
80104d5a:	75 ca                	jne    80104d26 <print_lock_que+0x36>
    }
  }
}
80104d5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d5f:	5b                   	pop    %ebx
80104d60:	5e                   	pop    %esi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	53                   	push   %ebx
80104d78:	83 ec 10             	sub    $0x10,%esp
80104d7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d7e:	68 80 4d 11 80       	push   $0x80114d80
80104d83:	e8 a8 04 00 00       	call   80105230 <acquire>
80104d88:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d8b:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104d90:	eb 12                	jmp    80104da4 <kill+0x34>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	05 a4 00 00 00       	add    $0xa4,%eax
80104d9d:	3d b4 76 11 80       	cmp    $0x801176b4,%eax
80104da2:	74 34                	je     80104dd8 <kill+0x68>
  {
    if (p->pid == pid)
80104da4:	39 58 10             	cmp    %ebx,0x10(%eax)
80104da7:	75 ef                	jne    80104d98 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104da9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104dad:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
80104db4:	75 07                	jne    80104dbd <kill+0x4d>
        p->state = RUNNABLE;
80104db6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	68 80 4d 11 80       	push   $0x80114d80
80104dc5:	e8 26 05 00 00       	call   801052f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	31 c0                	xor    %eax,%eax
}
80104dd2:	c9                   	leave  
80104dd3:	c3                   	ret    
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	68 80 4d 11 80       	push   $0x80114d80
80104de0:	e8 0b 05 00 00       	call   801052f0 <release>
}
80104de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104de8:	83 c4 10             	add    $0x10,%esp
80104deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df0:	c9                   	leave  
80104df1:	c3                   	ret    
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e00 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	57                   	push   %edi
80104e08:	56                   	push   %esi
80104e09:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104e0c:	53                   	push   %ebx
80104e0d:	bb 2c 4e 11 80       	mov    $0x80114e2c,%ebx
80104e12:	83 ec 3c             	sub    $0x3c,%esp
80104e15:	eb 2b                	jmp    80104e42 <procdump+0x42>
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	68 5b 91 10 80       	push   $0x8010915b
80104e28:	e8 83 b8 ff ff       	call   801006b0 <cprintf>
80104e2d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e30:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104e36:	81 fb 2c 77 11 80    	cmp    $0x8011772c,%ebx
80104e3c:	0f 84 8e 00 00 00    	je     80104ed0 <procdump+0xd0>
    if (p->state == UNUSED)
80104e42:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104e45:	85 c0                	test   %eax,%eax
80104e47:	74 e7                	je     80104e30 <procdump+0x30>
      state = "???";
80104e49:	ba ff 8c 10 80       	mov    $0x80108cff,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e4e:	83 f8 05             	cmp    $0x5,%eax
80104e51:	77 11                	ja     80104e64 <procdump+0x64>
80104e53:	8b 14 85 cc 8d 10 80 	mov    -0x7fef7234(,%eax,4),%edx
      state = "???";
80104e5a:	b8 ff 8c 10 80       	mov    $0x80108cff,%eax
80104e5f:	85 d2                	test   %edx,%edx
80104e61:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104e64:	53                   	push   %ebx
80104e65:	52                   	push   %edx
80104e66:	ff 73 98             	pushl  -0x68(%ebx)
80104e69:	68 03 8d 10 80       	push   $0x80108d03
80104e6e:	e8 3d b8 ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104e7a:	75 a4                	jne    80104e20 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104e7c:	83 ec 08             	sub    $0x8,%esp
80104e7f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104e82:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104e85:	50                   	push   %eax
80104e86:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104e89:	8b 40 0c             	mov    0xc(%eax),%eax
80104e8c:	83 c0 08             	add    $0x8,%eax
80104e8f:	50                   	push   %eax
80104e90:	e8 3b 02 00 00       	call   801050d0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop
80104ea0:	8b 17                	mov    (%edi),%edx
80104ea2:	85 d2                	test   %edx,%edx
80104ea4:	0f 84 76 ff ff ff    	je     80104e20 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104eaa:	83 ec 08             	sub    $0x8,%esp
80104ead:	83 c7 04             	add    $0x4,%edi
80104eb0:	52                   	push   %edx
80104eb1:	68 c1 86 10 80       	push   $0x801086c1
80104eb6:	e8 f5 b7 ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104ebb:	83 c4 10             	add    $0x10,%esp
80104ebe:	39 fe                	cmp    %edi,%esi
80104ec0:	75 de                	jne    80104ea0 <procdump+0xa0>
80104ec2:	e9 59 ff ff ff       	jmp    80104e20 <procdump+0x20>
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax
  }
}
80104ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed3:	5b                   	pop    %ebx
80104ed4:	5e                   	pop    %esi
80104ed5:	5f                   	pop    %edi
80104ed6:	5d                   	pop    %ebp
80104ed7:	c3                   	ret    
80104ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop

80104ee0 <find_digital_root>:

int find_digital_root(int num)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	56                   	push   %esi
80104ee8:	53                   	push   %ebx
80104ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104eec:	83 fb 09             	cmp    $0x9,%ebx
80104eef:	7e 32                	jle    80104f23 <find_digital_root+0x43>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
80104ef1:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
{
80104f00:	89 d9                	mov    %ebx,%ecx
    int res = 0;
80104f02:	31 db                	xor    %ebx,%ebx
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104f08:	89 c8                	mov    %ecx,%eax
80104f0a:	f7 e6                	mul    %esi
80104f0c:	c1 ea 03             	shr    $0x3,%edx
80104f0f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104f12:	01 c0                	add    %eax,%eax
80104f14:	29 c1                	sub    %eax,%ecx
      res += current_dig;
80104f16:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104f18:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104f1a:	85 d2                	test   %edx,%edx
80104f1c:	75 ea                	jne    80104f08 <find_digital_root+0x28>
  while (num >= 10)
80104f1e:	83 fb 09             	cmp    $0x9,%ebx
80104f21:	7f dd                	jg     80104f00 <find_digital_root+0x20>
    }
    num = res;
  }
  return num;
}
80104f23:	89 d8                	mov    %ebx,%eax
80104f25:	5b                   	pop    %ebx
80104f26:	5e                   	pop    %esi
80104f27:	5d                   	pop    %ebp
80104f28:	c3                   	ret    
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f30 <siktir>:
void siktir(void)
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	83 ec 14             	sub    $0x14,%esp
  acquir_priority(&PL);
80104f3a:	68 40 4d 11 80       	push   $0x80114d40
80104f3f:	e8 cc e4 ff ff       	call   80103410 <acquir_priority>
  for (int i = 0 ; i < 10000;i++)
  {
    continue;
  }
  abbas++;
80104f44:	a1 b8 c5 10 80       	mov    0x8010c5b8,%eax
  cprintf("%d\n",abbas);
80104f49:	5a                   	pop    %edx
80104f4a:	59                   	pop    %ecx
  abbas++;
80104f4b:	83 c0 01             	add    $0x1,%eax
  cprintf("%d\n",abbas);
80104f4e:	50                   	push   %eax
80104f4f:	68 74 8b 10 80       	push   $0x80108b74
  abbas++;
80104f54:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  cprintf("%d\n",abbas);
80104f59:	e8 52 b7 ff ff       	call   801006b0 <cprintf>
  release_priority(&PL);
80104f5e:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104f65:	e8 06 e5 ff ff       	call   80103470 <release_priority>
}
80104f6a:	83 c4 10             	add    $0x10,%esp
80104f6d:	c9                   	leave  
80104f6e:	c3                   	ret    
80104f6f:	90                   	nop

80104f70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	53                   	push   %ebx
80104f78:	83 ec 0c             	sub    $0xc,%esp
80104f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f7e:	68 f8 8d 10 80       	push   $0x80108df8
80104f83:	8d 43 04             	lea    0x4(%ebx),%eax
80104f86:	50                   	push   %eax
80104f87:	e8 24 01 00 00       	call   801050b0 <initlock>
  lk->name = name;
80104f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104f8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f95:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f98:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f9f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104fa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	53                   	push   %ebx
80104fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104fbc:	8d 73 04             	lea    0x4(%ebx),%esi
80104fbf:	83 ec 0c             	sub    $0xc,%esp
80104fc2:	56                   	push   %esi
80104fc3:	e8 68 02 00 00       	call   80105230 <acquire>
  while (lk->locked) {
80104fc8:	8b 13                	mov    (%ebx),%edx
80104fca:	83 c4 10             	add    $0x10,%esp
80104fcd:	85 d2                	test   %edx,%edx
80104fcf:	74 1a                	je     80104feb <acquiresleep+0x3b>
80104fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104fd8:	83 ec 08             	sub    $0x8,%esp
80104fdb:	56                   	push   %esi
80104fdc:	53                   	push   %ebx
80104fdd:	e8 5e fa ff ff       	call   80104a40 <sleep>
  while (lk->locked) {
80104fe2:	8b 03                	mov    (%ebx),%eax
80104fe4:	83 c4 10             	add    $0x10,%esp
80104fe7:	85 c0                	test   %eax,%eax
80104fe9:	75 ed                	jne    80104fd8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104feb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ff1:	e8 3a ec ff ff       	call   80103c30 <myproc>
80104ff6:	8b 40 10             	mov    0x10(%eax),%eax
80104ff9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ffc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105002:	5b                   	pop    %ebx
80105003:	5e                   	pop    %esi
80105004:	5d                   	pop    %ebp
  release(&lk->lk);
80105005:	e9 e6 02 00 00       	jmp    801052f0 <release>
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105010 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	56                   	push   %esi
80105018:	53                   	push   %ebx
80105019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010501c:	8d 73 04             	lea    0x4(%ebx),%esi
8010501f:	83 ec 0c             	sub    $0xc,%esp
80105022:	56                   	push   %esi
80105023:	e8 08 02 00 00       	call   80105230 <acquire>
  lk->locked = 0;
80105028:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010502e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105035:	89 1c 24             	mov    %ebx,(%esp)
80105038:	e8 c3 fb ff ff       	call   80104c00 <wakeup>
  release(&lk->lk);
8010503d:	89 75 08             	mov    %esi,0x8(%ebp)
80105040:	83 c4 10             	add    $0x10,%esp
}
80105043:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105046:	5b                   	pop    %ebx
80105047:	5e                   	pop    %esi
80105048:	5d                   	pop    %ebp
  release(&lk->lk);
80105049:	e9 a2 02 00 00       	jmp    801052f0 <release>
8010504e:	66 90                	xchg   %ax,%ax

80105050 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	57                   	push   %edi
80105058:	31 ff                	xor    %edi,%edi
8010505a:	56                   	push   %esi
8010505b:	53                   	push   %ebx
8010505c:	83 ec 18             	sub    $0x18,%esp
8010505f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105062:	8d 73 04             	lea    0x4(%ebx),%esi
80105065:	56                   	push   %esi
80105066:	e8 c5 01 00 00       	call   80105230 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010506b:	8b 03                	mov    (%ebx),%eax
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	75 1c                	jne    80105090 <holdingsleep+0x40>
  release(&lk->lk);
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	56                   	push   %esi
80105078:	e8 73 02 00 00       	call   801052f0 <release>
  return r;
}
8010507d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105080:	89 f8                	mov    %edi,%eax
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5f                   	pop    %edi
80105085:	5d                   	pop    %ebp
80105086:	c3                   	ret    
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105090:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105093:	e8 98 eb ff ff       	call   80103c30 <myproc>
80105098:	39 58 10             	cmp    %ebx,0x10(%eax)
8010509b:	0f 94 c0             	sete   %al
8010509e:	0f b6 c0             	movzbl %al,%eax
801050a1:	89 c7                	mov    %eax,%edi
801050a3:	eb cf                	jmp    80105074 <holdingsleep+0x24>
801050a5:	66 90                	xchg   %ax,%ax
801050a7:	66 90                	xchg   %ax,%ax
801050a9:	66 90                	xchg   %ax,%ax
801050ab:	66 90                	xchg   %ax,%ax
801050ad:	66 90                	xchg   %ax,%ax
801050af:	90                   	nop

801050b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801050ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801050bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801050c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801050c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050cd:	5d                   	pop    %ebp
801050ce:	c3                   	ret    
801050cf:	90                   	nop

801050d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050d5:	31 d2                	xor    %edx,%edx
{
801050d7:	89 e5                	mov    %esp,%ebp
801050d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801050da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801050dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801050e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801050e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050f4:	77 1a                	ja     80105110 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050f6:	8b 58 04             	mov    0x4(%eax),%ebx
801050f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105101:	83 fa 0a             	cmp    $0xa,%edx
80105104:	75 e2                	jne    801050e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105106:	5b                   	pop    %ebx
80105107:	5d                   	pop    %ebp
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105110:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105113:	8d 51 28             	lea    0x28(%ecx),%edx
80105116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105126:	83 c0 04             	add    $0x4,%eax
80105129:	39 d0                	cmp    %edx,%eax
8010512b:	75 f3                	jne    80105120 <getcallerpcs+0x50>
}
8010512d:	5b                   	pop    %ebx
8010512e:	5d                   	pop    %ebp
8010512f:	c3                   	ret    

80105130 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	53                   	push   %ebx
80105138:	83 ec 04             	sub    $0x4,%esp
8010513b:	9c                   	pushf  
8010513c:	5b                   	pop    %ebx
  asm volatile("cli");
8010513d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010513e:	e8 6d e9 ff ff       	call   80103ab0 <mycpu>
80105143:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105149:	85 c0                	test   %eax,%eax
8010514b:	74 13                	je     80105160 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010514d:	e8 5e e9 ff ff       	call   80103ab0 <mycpu>
80105152:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105159:	83 c4 04             	add    $0x4,%esp
8010515c:	5b                   	pop    %ebx
8010515d:	5d                   	pop    %ebp
8010515e:	c3                   	ret    
8010515f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105160:	e8 4b e9 ff ff       	call   80103ab0 <mycpu>
80105165:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010516b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105171:	eb da                	jmp    8010514d <pushcli+0x1d>
80105173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105180 <popcli>:

void
popcli(void)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010518a:	9c                   	pushf  
8010518b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010518c:	f6 c4 02             	test   $0x2,%ah
8010518f:	75 31                	jne    801051c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105191:	e8 1a e9 ff ff       	call   80103ab0 <mycpu>
80105196:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010519d:	78 30                	js     801051cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010519f:	e8 0c e9 ff ff       	call   80103ab0 <mycpu>
801051a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051aa:	85 d2                	test   %edx,%edx
801051ac:	74 02                	je     801051b0 <popcli+0x30>
    sti();
}
801051ae:	c9                   	leave  
801051af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051b0:	e8 fb e8 ff ff       	call   80103ab0 <mycpu>
801051b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051bb:	85 c0                	test   %eax,%eax
801051bd:	74 ef                	je     801051ae <popcli+0x2e>
  asm volatile("sti");
801051bf:	fb                   	sti    
}
801051c0:	c9                   	leave  
801051c1:	c3                   	ret    
    panic("popcli - interruptible");
801051c2:	83 ec 0c             	sub    $0xc,%esp
801051c5:	68 03 8e 10 80       	push   $0x80108e03
801051ca:	e8 c1 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
801051cf:	83 ec 0c             	sub    $0xc,%esp
801051d2:	68 1a 8e 10 80       	push   $0x80108e1a
801051d7:	e8 b4 b1 ff ff       	call   80100390 <panic>
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <holding>:
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	56                   	push   %esi
801051e8:	53                   	push   %ebx
801051e9:	8b 75 08             	mov    0x8(%ebp),%esi
801051ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801051ee:	e8 3d ff ff ff       	call   80105130 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051f3:	8b 06                	mov    (%esi),%eax
801051f5:	85 c0                	test   %eax,%eax
801051f7:	75 0f                	jne    80105208 <holding+0x28>
  popcli();
801051f9:	e8 82 ff ff ff       	call   80105180 <popcli>
}
801051fe:	89 d8                	mov    %ebx,%eax
80105200:	5b                   	pop    %ebx
80105201:	5e                   	pop    %esi
80105202:	5d                   	pop    %ebp
80105203:	c3                   	ret    
80105204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105208:	8b 5e 08             	mov    0x8(%esi),%ebx
8010520b:	e8 a0 e8 ff ff       	call   80103ab0 <mycpu>
80105210:	39 c3                	cmp    %eax,%ebx
80105212:	0f 94 c3             	sete   %bl
  popcli();
80105215:	e8 66 ff ff ff       	call   80105180 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010521a:	0f b6 db             	movzbl %bl,%ebx
}
8010521d:	89 d8                	mov    %ebx,%eax
8010521f:	5b                   	pop    %ebx
80105220:	5e                   	pop    %esi
80105221:	5d                   	pop    %ebp
80105222:	c3                   	ret    
80105223:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105230 <acquire>:
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	56                   	push   %esi
80105238:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105239:	e8 f2 fe ff ff       	call   80105130 <pushcli>
  if(holding(lk))
8010523e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	53                   	push   %ebx
80105245:	e8 96 ff ff ff       	call   801051e0 <holding>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	0f 85 7f 00 00 00    	jne    801052d4 <acquire+0xa4>
80105255:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105257:	ba 01 00 00 00       	mov    $0x1,%edx
8010525c:	eb 05                	jmp    80105263 <acquire+0x33>
8010525e:	66 90                	xchg   %ax,%ax
80105260:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105263:	89 d0                	mov    %edx,%eax
80105265:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105268:	85 c0                	test   %eax,%eax
8010526a:	75 f4                	jne    80105260 <acquire+0x30>
  __sync_synchronize();
8010526c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105271:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105274:	e8 37 e8 ff ff       	call   80103ab0 <mycpu>
80105279:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010527c:	89 e8                	mov    %ebp,%eax
8010527e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105280:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105286:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010528c:	77 22                	ja     801052b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010528e:	8b 50 04             	mov    0x4(%eax),%edx
80105291:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105295:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105298:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010529a:	83 fe 0a             	cmp    $0xa,%esi
8010529d:	75 e1                	jne    80105280 <acquire+0x50>
}
8010529f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5d                   	pop    %ebp
801052a5:	c3                   	ret    
801052a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801052b0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801052b4:	83 c3 34             	add    $0x34,%ebx
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801052c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801052c6:	83 c0 04             	add    $0x4,%eax
801052c9:	39 d8                	cmp    %ebx,%eax
801052cb:	75 f3                	jne    801052c0 <acquire+0x90>
}
801052cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d0:	5b                   	pop    %ebx
801052d1:	5e                   	pop    %esi
801052d2:	5d                   	pop    %ebp
801052d3:	c3                   	ret    
    panic("acquire");
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	68 21 8e 10 80       	push   $0x80108e21
801052dc:	e8 af b0 ff ff       	call   80100390 <panic>
801052e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ef:	90                   	nop

801052f0 <release>:
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	53                   	push   %ebx
801052f8:	83 ec 10             	sub    $0x10,%esp
801052fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801052fe:	53                   	push   %ebx
801052ff:	e8 dc fe ff ff       	call   801051e0 <holding>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	74 22                	je     8010532d <release+0x3d>
  lk->pcs[0] = 0;
8010530b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105312:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105319:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010531e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105327:	c9                   	leave  
  popcli();
80105328:	e9 53 fe ff ff       	jmp    80105180 <popcli>
    panic("release");
8010532d:	83 ec 0c             	sub    $0xc,%esp
80105330:	68 29 8e 10 80       	push   $0x80108e29
80105335:	e8 56 b0 ff ff       	call   80100390 <panic>
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105340:	f3 0f 1e fb          	endbr32 
80105344:	55                   	push   %ebp
80105345:	89 e5                	mov    %esp,%ebp
80105347:	57                   	push   %edi
80105348:	8b 55 08             	mov    0x8(%ebp),%edx
8010534b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010534e:	53                   	push   %ebx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105352:	89 d7                	mov    %edx,%edi
80105354:	09 cf                	or     %ecx,%edi
80105356:	83 e7 03             	and    $0x3,%edi
80105359:	75 25                	jne    80105380 <memset+0x40>
    c &= 0xFF;
8010535b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010535e:	c1 e0 18             	shl    $0x18,%eax
80105361:	89 fb                	mov    %edi,%ebx
80105363:	c1 e9 02             	shr    $0x2,%ecx
80105366:	c1 e3 10             	shl    $0x10,%ebx
80105369:	09 d8                	or     %ebx,%eax
8010536b:	09 f8                	or     %edi,%eax
8010536d:	c1 e7 08             	shl    $0x8,%edi
80105370:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105372:	89 d7                	mov    %edx,%edi
80105374:	fc                   	cld    
80105375:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105377:	5b                   	pop    %ebx
80105378:	89 d0                	mov    %edx,%eax
8010537a:	5f                   	pop    %edi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105380:	89 d7                	mov    %edx,%edi
80105382:	fc                   	cld    
80105383:	f3 aa                	rep stos %al,%es:(%edi)
80105385:	5b                   	pop    %ebx
80105386:	89 d0                	mov    %edx,%eax
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop

80105390 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	56                   	push   %esi
80105398:	8b 75 10             	mov    0x10(%ebp),%esi
8010539b:	8b 55 08             	mov    0x8(%ebp),%edx
8010539e:	53                   	push   %ebx
8010539f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801053a2:	85 f6                	test   %esi,%esi
801053a4:	74 2a                	je     801053d0 <memcmp+0x40>
801053a6:	01 c6                	add    %eax,%esi
801053a8:	eb 10                	jmp    801053ba <memcmp+0x2a>
801053aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801053b0:	83 c0 01             	add    $0x1,%eax
801053b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801053b6:	39 f0                	cmp    %esi,%eax
801053b8:	74 16                	je     801053d0 <memcmp+0x40>
    if(*s1 != *s2)
801053ba:	0f b6 0a             	movzbl (%edx),%ecx
801053bd:	0f b6 18             	movzbl (%eax),%ebx
801053c0:	38 d9                	cmp    %bl,%cl
801053c2:	74 ec                	je     801053b0 <memcmp+0x20>
      return *s1 - *s2;
801053c4:	0f b6 c1             	movzbl %cl,%eax
801053c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5d                   	pop    %ebp
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
801053d0:	5b                   	pop    %ebx
  return 0;
801053d1:	31 c0                	xor    %eax,%eax
}
801053d3:	5e                   	pop    %esi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi

801053e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	57                   	push   %edi
801053e8:	8b 55 08             	mov    0x8(%ebp),%edx
801053eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801053ee:	56                   	push   %esi
801053ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053f2:	39 d6                	cmp    %edx,%esi
801053f4:	73 2a                	jae    80105420 <memmove+0x40>
801053f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801053f9:	39 fa                	cmp    %edi,%edx
801053fb:	73 23                	jae    80105420 <memmove+0x40>
801053fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105400:	85 c9                	test   %ecx,%ecx
80105402:	74 13                	je     80105417 <memmove+0x37>
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105408:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010540c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010540f:	83 e8 01             	sub    $0x1,%eax
80105412:	83 f8 ff             	cmp    $0xffffffff,%eax
80105415:	75 f1                	jne    80105408 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105417:	5e                   	pop    %esi
80105418:	89 d0                	mov    %edx,%eax
8010541a:	5f                   	pop    %edi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105420:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105423:	89 d7                	mov    %edx,%edi
80105425:	85 c9                	test   %ecx,%ecx
80105427:	74 ee                	je     80105417 <memmove+0x37>
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105430:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105431:	39 f0                	cmp    %esi,%eax
80105433:	75 fb                	jne    80105430 <memmove+0x50>
}
80105435:	5e                   	pop    %esi
80105436:	89 d0                	mov    %edx,%eax
80105438:	5f                   	pop    %edi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop

80105440 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105440:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105444:	eb 9a                	jmp    801053e0 <memmove>
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	56                   	push   %esi
80105458:	8b 75 10             	mov    0x10(%ebp),%esi
8010545b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010545e:	53                   	push   %ebx
8010545f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105462:	85 f6                	test   %esi,%esi
80105464:	74 32                	je     80105498 <strncmp+0x48>
80105466:	01 c6                	add    %eax,%esi
80105468:	eb 14                	jmp    8010547e <strncmp+0x2e>
8010546a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105470:	38 da                	cmp    %bl,%dl
80105472:	75 14                	jne    80105488 <strncmp+0x38>
    n--, p++, q++;
80105474:	83 c0 01             	add    $0x1,%eax
80105477:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010547a:	39 f0                	cmp    %esi,%eax
8010547c:	74 1a                	je     80105498 <strncmp+0x48>
8010547e:	0f b6 11             	movzbl (%ecx),%edx
80105481:	0f b6 18             	movzbl (%eax),%ebx
80105484:	84 d2                	test   %dl,%dl
80105486:	75 e8                	jne    80105470 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105488:	0f b6 c2             	movzbl %dl,%eax
8010548b:	29 d8                	sub    %ebx,%eax
}
8010548d:	5b                   	pop    %ebx
8010548e:	5e                   	pop    %esi
8010548f:	5d                   	pop    %ebp
80105490:	c3                   	ret    
80105491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105498:	5b                   	pop    %ebx
    return 0;
80105499:	31 c0                	xor    %eax,%eax
}
8010549b:	5e                   	pop    %esi
8010549c:	5d                   	pop    %ebp
8010549d:	c3                   	ret    
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	57                   	push   %edi
801054a8:	56                   	push   %esi
801054a9:	8b 75 08             	mov    0x8(%ebp),%esi
801054ac:	53                   	push   %ebx
801054ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801054b0:	89 f2                	mov    %esi,%edx
801054b2:	eb 1b                	jmp    801054cf <strncpy+0x2f>
801054b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801054bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801054bf:	83 c2 01             	add    $0x1,%edx
801054c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801054c6:	89 f9                	mov    %edi,%ecx
801054c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801054cb:	84 c9                	test   %cl,%cl
801054cd:	74 09                	je     801054d8 <strncpy+0x38>
801054cf:	89 c3                	mov    %eax,%ebx
801054d1:	83 e8 01             	sub    $0x1,%eax
801054d4:	85 db                	test   %ebx,%ebx
801054d6:	7f e0                	jg     801054b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801054d8:	89 d1                	mov    %edx,%ecx
801054da:	85 c0                	test   %eax,%eax
801054dc:	7e 15                	jle    801054f3 <strncpy+0x53>
801054de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801054e0:	83 c1 01             	add    $0x1,%ecx
801054e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801054e7:	89 c8                	mov    %ecx,%eax
801054e9:	f7 d0                	not    %eax
801054eb:	01 d0                	add    %edx,%eax
801054ed:	01 d8                	add    %ebx,%eax
801054ef:	85 c0                	test   %eax,%eax
801054f1:	7f ed                	jg     801054e0 <strncpy+0x40>
  return os;
}
801054f3:	5b                   	pop    %ebx
801054f4:	89 f0                	mov    %esi,%eax
801054f6:	5e                   	pop    %esi
801054f7:	5f                   	pop    %edi
801054f8:	5d                   	pop    %ebp
801054f9:	c3                   	ret    
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105500 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105500:	f3 0f 1e fb          	endbr32 
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
80105507:	56                   	push   %esi
80105508:	8b 55 10             	mov    0x10(%ebp),%edx
8010550b:	8b 75 08             	mov    0x8(%ebp),%esi
8010550e:	53                   	push   %ebx
8010550f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105512:	85 d2                	test   %edx,%edx
80105514:	7e 21                	jle    80105537 <safestrcpy+0x37>
80105516:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010551a:	89 f2                	mov    %esi,%edx
8010551c:	eb 12                	jmp    80105530 <safestrcpy+0x30>
8010551e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105520:	0f b6 08             	movzbl (%eax),%ecx
80105523:	83 c0 01             	add    $0x1,%eax
80105526:	83 c2 01             	add    $0x1,%edx
80105529:	88 4a ff             	mov    %cl,-0x1(%edx)
8010552c:	84 c9                	test   %cl,%cl
8010552e:	74 04                	je     80105534 <safestrcpy+0x34>
80105530:	39 d8                	cmp    %ebx,%eax
80105532:	75 ec                	jne    80105520 <safestrcpy+0x20>
    ;
  *s = 0;
80105534:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105537:	89 f0                	mov    %esi,%eax
80105539:	5b                   	pop    %ebx
8010553a:	5e                   	pop    %esi
8010553b:	5d                   	pop    %ebp
8010553c:	c3                   	ret    
8010553d:	8d 76 00             	lea    0x0(%esi),%esi

80105540 <strlen>:

int
strlen(const char *s)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105545:	31 c0                	xor    %eax,%eax
{
80105547:	89 e5                	mov    %esp,%ebp
80105549:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010554c:	80 3a 00             	cmpb   $0x0,(%edx)
8010554f:	74 10                	je     80105561 <strlen+0x21>
80105551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105558:	83 c0 01             	add    $0x1,%eax
8010555b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010555f:	75 f7                	jne    80105558 <strlen+0x18>
    ;
  return n;
}
80105561:	5d                   	pop    %ebp
80105562:	c3                   	ret    

80105563 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105563:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105567:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010556b:	55                   	push   %ebp
  pushl %ebx
8010556c:	53                   	push   %ebx
  pushl %esi
8010556d:	56                   	push   %esi
  pushl %edi
8010556e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010556f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105571:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105573:	5f                   	pop    %edi
  popl %esi
80105574:	5e                   	pop    %esi
  popl %ebx
80105575:	5b                   	pop    %ebx
  popl %ebp
80105576:	5d                   	pop    %ebp
  ret
80105577:	c3                   	ret    
80105578:	66 90                	xchg   %ax,%ax
8010557a:	66 90                	xchg   %ax,%ax
8010557c:	66 90                	xchg   %ax,%ax
8010557e:	66 90                	xchg   %ax,%ax

80105580 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	53                   	push   %ebx
80105588:	83 ec 04             	sub    $0x4,%esp
8010558b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010558e:	e8 9d e6 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105593:	8b 00                	mov    (%eax),%eax
80105595:	39 d8                	cmp    %ebx,%eax
80105597:	76 17                	jbe    801055b0 <fetchint+0x30>
80105599:	8d 53 04             	lea    0x4(%ebx),%edx
8010559c:	39 d0                	cmp    %edx,%eax
8010559e:	72 10                	jb     801055b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801055a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a3:	8b 13                	mov    (%ebx),%edx
801055a5:	89 10                	mov    %edx,(%eax)
  return 0;
801055a7:	31 c0                	xor    %eax,%eax
}
801055a9:	83 c4 04             	add    $0x4,%esp
801055ac:	5b                   	pop    %ebx
801055ad:	5d                   	pop    %ebp
801055ae:	c3                   	ret    
801055af:	90                   	nop
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb f2                	jmp    801055a9 <fetchint+0x29>
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	53                   	push   %ebx
801055c8:	83 ec 04             	sub    $0x4,%esp
801055cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801055ce:	e8 5d e6 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz)
801055d3:	39 18                	cmp    %ebx,(%eax)
801055d5:	76 31                	jbe    80105608 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801055d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801055da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801055dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801055de:	39 d3                	cmp    %edx,%ebx
801055e0:	73 26                	jae    80105608 <fetchstr+0x48>
801055e2:	89 d8                	mov    %ebx,%eax
801055e4:	eb 11                	jmp    801055f7 <fetchstr+0x37>
801055e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
801055f0:	83 c0 01             	add    $0x1,%eax
801055f3:	39 c2                	cmp    %eax,%edx
801055f5:	76 11                	jbe    80105608 <fetchstr+0x48>
    if(*s == 0)
801055f7:	80 38 00             	cmpb   $0x0,(%eax)
801055fa:	75 f4                	jne    801055f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801055fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801055ff:	29 d8                	sub    %ebx,%eax
}
80105601:	5b                   	pop    %ebx
80105602:	5d                   	pop    %ebp
80105603:	c3                   	ret    
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105608:	83 c4 04             	add    $0x4,%esp
    return -1;
8010560b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105610:	5b                   	pop    %ebx
80105611:	5d                   	pop    %ebp
80105612:	c3                   	ret    
80105613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105620 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	53                   	push   %ebx
80105628:	83 ec 04             	sub    $0x4,%esp
8010562b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010562e:	e8 fd e5 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105633:	8b 00                	mov    (%eax),%eax
80105635:	39 d8                	cmp    %ebx,%eax
80105637:	76 17                	jbe    80105650 <fetchfloat+0x30>
80105639:	8d 53 04             	lea    0x4(%ebx),%edx
8010563c:	39 d0                	cmp    %edx,%eax
8010563e:	72 10                	jb     80105650 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80105640:	d9 03                	flds   (%ebx)
80105642:	8b 45 0c             	mov    0xc(%ebp),%eax
80105645:	d9 18                	fstps  (%eax)
  return 0;
80105647:	31 c0                	xor    %eax,%eax
}
80105649:	83 c4 04             	add    $0x4,%esp
8010564c:	5b                   	pop    %ebx
8010564d:	5d                   	pop    %ebp
8010564e:	c3                   	ret    
8010564f:	90                   	nop
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105655:	eb f2                	jmp    80105649 <fetchfloat+0x29>
80105657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565e:	66 90                	xchg   %ax,%ax

80105660 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	56                   	push   %esi
80105668:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105669:	e8 c2 e5 ff ff       	call   80103c30 <myproc>
8010566e:	8b 55 08             	mov    0x8(%ebp),%edx
80105671:	8b 40 18             	mov    0x18(%eax),%eax
80105674:	8b 40 44             	mov    0x44(%eax),%eax
80105677:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010567a:	e8 b1 e5 ff ff       	call   80103c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010567f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105682:	8b 00                	mov    (%eax),%eax
80105684:	39 c6                	cmp    %eax,%esi
80105686:	73 18                	jae    801056a0 <argint+0x40>
80105688:	8d 53 08             	lea    0x8(%ebx),%edx
8010568b:	39 d0                	cmp    %edx,%eax
8010568d:	72 11                	jb     801056a0 <argint+0x40>
  *ip = *(int*)(addr);
8010568f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105692:	8b 53 04             	mov    0x4(%ebx),%edx
80105695:	89 10                	mov    %edx,(%eax)
  return 0;
80105697:	31 c0                	xor    %eax,%eax
}
80105699:	5b                   	pop    %ebx
8010569a:	5e                   	pop    %esi
8010569b:	5d                   	pop    %ebp
8010569c:	c3                   	ret    
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801056a5:	eb f2                	jmp    80105699 <argint+0x39>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <argf>:
int
argf(int n, float *fp)
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	56                   	push   %esi
801056b8:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801056b9:	e8 72 e5 ff ff       	call   80103c30 <myproc>
801056be:	8b 55 08             	mov    0x8(%ebp),%edx
801056c1:	8b 40 18             	mov    0x18(%eax),%eax
801056c4:	8b 40 44             	mov    0x44(%eax),%eax
801056c7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801056ca:	e8 61 e5 ff ff       	call   80103c30 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801056cf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056d2:	8b 00                	mov    (%eax),%eax
801056d4:	39 c6                	cmp    %eax,%esi
801056d6:	73 18                	jae    801056f0 <argf+0x40>
801056d8:	8d 53 08             	lea    0x8(%ebx),%edx
801056db:	39 d0                	cmp    %edx,%eax
801056dd:	72 11                	jb     801056f0 <argf+0x40>
  *fp = *(float*)(addr);
801056df:	d9 43 04             	flds   0x4(%ebx)
801056e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e5:	d9 18                	fstps  (%eax)
  return 0;
801056e7:	31 c0                	xor    %eax,%eax
}
801056e9:	5b                   	pop    %ebx
801056ea:	5e                   	pop    %esi
801056eb:	5d                   	pop    %ebp
801056ec:	c3                   	ret    
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801056f5:	eb f2                	jmp    801056e9 <argf+0x39>
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	56                   	push   %esi
80105708:	53                   	push   %ebx
80105709:	83 ec 10             	sub    $0x10,%esp
8010570c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010570f:	e8 1c e5 ff ff       	call   80103c30 <myproc>
 
  if(argint(n, &i) < 0)
80105714:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105717:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105719:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571c:	50                   	push   %eax
8010571d:	ff 75 08             	pushl  0x8(%ebp)
80105720:	e8 3b ff ff ff       	call   80105660 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105725:	83 c4 10             	add    $0x10,%esp
80105728:	85 c0                	test   %eax,%eax
8010572a:	78 24                	js     80105750 <argptr+0x50>
8010572c:	85 db                	test   %ebx,%ebx
8010572e:	78 20                	js     80105750 <argptr+0x50>
80105730:	8b 16                	mov    (%esi),%edx
80105732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105735:	39 c2                	cmp    %eax,%edx
80105737:	76 17                	jbe    80105750 <argptr+0x50>
80105739:	01 c3                	add    %eax,%ebx
8010573b:	39 da                	cmp    %ebx,%edx
8010573d:	72 11                	jb     80105750 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010573f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105742:	89 02                	mov    %eax,(%edx)
  return 0;
80105744:	31 c0                	xor    %eax,%eax
}
80105746:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105749:	5b                   	pop    %ebx
8010574a:	5e                   	pop    %esi
8010574b:	5d                   	pop    %ebp
8010574c:	c3                   	ret    
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105755:	eb ef                	jmp    80105746 <argptr+0x46>
80105757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575e:	66 90                	xchg   %ax,%ax

80105760 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010576a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576d:	50                   	push   %eax
8010576e:	ff 75 08             	pushl  0x8(%ebp)
80105771:	e8 ea fe ff ff       	call   80105660 <argint>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 13                	js     80105790 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010577d:	83 ec 08             	sub    $0x8,%esp
80105780:	ff 75 0c             	pushl  0xc(%ebp)
80105783:	ff 75 f4             	pushl  -0xc(%ebp)
80105786:	e8 35 fe ff ff       	call   801055c0 <fetchstr>
8010578b:	83 c4 10             	add    $0x10,%esp
}
8010578e:	c9                   	leave  
8010578f:	c3                   	ret    
80105790:	c9                   	leave  
    return -1;
80105791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105796:	c3                   	ret    
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax

801057a0 <syscall>:
[SYS_open_shm] sys_open_shm
};

void
syscall(void)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	53                   	push   %ebx
801057a8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801057ab:	e8 80 e4 ff ff       	call   80103c30 <myproc>
801057b0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801057b2:	8b 40 18             	mov    0x18(%eax),%eax
801057b5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801057b8:	8d 50 ff             	lea    -0x1(%eax),%edx
801057bb:	83 fa 22             	cmp    $0x22,%edx
801057be:	77 20                	ja     801057e0 <syscall+0x40>
801057c0:	8b 14 85 60 8e 10 80 	mov    -0x7fef71a0(,%eax,4),%edx
801057c7:	85 d2                	test   %edx,%edx
801057c9:	74 15                	je     801057e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801057cb:	ff d2                	call   *%edx
801057cd:	89 c2                	mov    %eax,%edx
801057cf:	8b 43 18             	mov    0x18(%ebx),%eax
801057d2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801057d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d8:	c9                   	leave  
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801057e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801057e1:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801057e4:	50                   	push   %eax
801057e5:	ff 73 10             	pushl  0x10(%ebx)
801057e8:	68 31 8e 10 80       	push   $0x80108e31
801057ed:	e8 be ae ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801057f2:	8b 43 18             	mov    0x18(%ebx),%eax
801057f5:	83 c4 10             	add    $0x10,%esp
801057f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801057ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105802:	c9                   	leave  
80105803:	c3                   	ret    
80105804:	66 90                	xchg   %ax,%ax
80105806:	66 90                	xchg   %ax,%ax
80105808:	66 90                	xchg   %ax,%ax
8010580a:	66 90                	xchg   %ax,%ax
8010580c:	66 90                	xchg   %ax,%ax
8010580e:	66 90                	xchg   %ax,%ax

80105810 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80105815:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105818:	53                   	push   %ebx
80105819:	83 ec 34             	sub    $0x34,%esp
8010581c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010581f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105822:	57                   	push   %edi
80105823:	50                   	push   %eax
{
80105824:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105827:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010582a:	e8 21 c8 ff ff       	call   80102050 <nameiparent>
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	85 c0                	test   %eax,%eax
80105834:	0f 84 46 01 00 00    	je     80105980 <create+0x170>
    return 0;
  ilock(dp);
8010583a:	83 ec 0c             	sub    $0xc,%esp
8010583d:	89 c3                	mov    %eax,%ebx
8010583f:	50                   	push   %eax
80105840:	e8 1b bf ff ff       	call   80101760 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105845:	83 c4 0c             	add    $0xc,%esp
80105848:	6a 00                	push   $0x0
8010584a:	57                   	push   %edi
8010584b:	53                   	push   %ebx
8010584c:	e8 5f c4 ff ff       	call   80101cb0 <dirlookup>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	89 c6                	mov    %eax,%esi
80105856:	85 c0                	test   %eax,%eax
80105858:	74 56                	je     801058b0 <create+0xa0>
  {
    iunlockput(dp);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	53                   	push   %ebx
8010585e:	e8 9d c1 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105863:	89 34 24             	mov    %esi,(%esp)
80105866:	e8 f5 be ff ff       	call   80101760 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010586b:	83 c4 10             	add    $0x10,%esp
8010586e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105873:	75 1b                	jne    80105890 <create+0x80>
80105875:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010587a:	75 14                	jne    80105890 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010587c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010587f:	89 f0                	mov    %esi,%eax
80105881:	5b                   	pop    %ebx
80105882:	5e                   	pop    %esi
80105883:	5f                   	pop    %edi
80105884:	5d                   	pop    %ebp
80105885:	c3                   	ret    
80105886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	56                   	push   %esi
    return 0;
80105894:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105896:	e8 65 c1 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010589b:	83 c4 10             	add    $0x10,%esp
}
8010589e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a1:	89 f0                	mov    %esi,%eax
801058a3:	5b                   	pop    %ebx
801058a4:	5e                   	pop    %esi
801058a5:	5f                   	pop    %edi
801058a6:	5d                   	pop    %ebp
801058a7:	c3                   	ret    
801058a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
801058b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	50                   	push   %eax
801058b8:	ff 33                	pushl  (%ebx)
801058ba:	e8 21 bd ff ff       	call   801015e0 <ialloc>
801058bf:	83 c4 10             	add    $0x10,%esp
801058c2:	89 c6                	mov    %eax,%esi
801058c4:	85 c0                	test   %eax,%eax
801058c6:	0f 84 cd 00 00 00    	je     80105999 <create+0x189>
  ilock(ip);
801058cc:	83 ec 0c             	sub    $0xc,%esp
801058cf:	50                   	push   %eax
801058d0:	e8 8b be ff ff       	call   80101760 <ilock>
  ip->major = major;
801058d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801058d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801058dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801058e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801058e5:	b8 01 00 00 00       	mov    $0x1,%eax
801058ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801058ee:	89 34 24             	mov    %esi,(%esp)
801058f1:	e8 aa bd ff ff       	call   801016a0 <iupdate>
  if (type == T_DIR)
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801058fe:	74 30                	je     80105930 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
80105900:	83 ec 04             	sub    $0x4,%esp
80105903:	ff 76 04             	pushl  0x4(%esi)
80105906:	57                   	push   %edi
80105907:	53                   	push   %ebx
80105908:	e8 63 c6 ff ff       	call   80101f70 <dirlink>
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	85 c0                	test   %eax,%eax
80105912:	78 78                	js     8010598c <create+0x17c>
  iunlockput(dp);
80105914:	83 ec 0c             	sub    $0xc,%esp
80105917:	53                   	push   %ebx
80105918:	e8 e3 c0 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010591d:	83 c4 10             	add    $0x10,%esp
}
80105920:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105923:	89 f0                	mov    %esi,%eax
80105925:	5b                   	pop    %ebx
80105926:	5e                   	pop    %esi
80105927:	5f                   	pop    %edi
80105928:	5d                   	pop    %ebp
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105930:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105933:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105938:	53                   	push   %ebx
80105939:	e8 62 bd ff ff       	call   801016a0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010593e:	83 c4 0c             	add    $0xc,%esp
80105941:	ff 76 04             	pushl  0x4(%esi)
80105944:	68 0c 8f 10 80       	push   $0x80108f0c
80105949:	56                   	push   %esi
8010594a:	e8 21 c6 ff ff       	call   80101f70 <dirlink>
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	85 c0                	test   %eax,%eax
80105954:	78 18                	js     8010596e <create+0x15e>
80105956:	83 ec 04             	sub    $0x4,%esp
80105959:	ff 73 04             	pushl  0x4(%ebx)
8010595c:	68 0b 8f 10 80       	push   $0x80108f0b
80105961:	56                   	push   %esi
80105962:	e8 09 c6 ff ff       	call   80101f70 <dirlink>
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	85 c0                	test   %eax,%eax
8010596c:	79 92                	jns    80105900 <create+0xf0>
      panic("create dots");
8010596e:	83 ec 0c             	sub    $0xc,%esp
80105971:	68 ff 8e 10 80       	push   $0x80108eff
80105976:	e8 15 aa ff ff       	call   80100390 <panic>
8010597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop
}
80105980:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105983:	31 f6                	xor    %esi,%esi
}
80105985:	5b                   	pop    %ebx
80105986:	89 f0                	mov    %esi,%eax
80105988:	5e                   	pop    %esi
80105989:	5f                   	pop    %edi
8010598a:	5d                   	pop    %ebp
8010598b:	c3                   	ret    
    panic("create: dirlink");
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	68 0e 8f 10 80       	push   $0x80108f0e
80105994:	e8 f7 a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105999:	83 ec 0c             	sub    $0xc,%esp
8010599c:	68 f0 8e 10 80       	push   $0x80108ef0
801059a1:	e8 ea a9 ff ff       	call   80100390 <panic>
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi

801059b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	56                   	push   %esi
801059b4:	89 d6                	mov    %edx,%esi
801059b6:	53                   	push   %ebx
801059b7:	89 c3                	mov    %eax,%ebx
  if (argint(n, &fd) < 0)
801059b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801059bc:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801059bf:	50                   	push   %eax
801059c0:	6a 00                	push   $0x0
801059c2:	e8 99 fc ff ff       	call   80105660 <argint>
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	85 c0                	test   %eax,%eax
801059cc:	78 2a                	js     801059f8 <argfd.constprop.0+0x48>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801059ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059d2:	77 24                	ja     801059f8 <argfd.constprop.0+0x48>
801059d4:	e8 57 e2 ff ff       	call   80103c30 <myproc>
801059d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059dc:	8b 44 90 34          	mov    0x34(%eax,%edx,4),%eax
801059e0:	85 c0                	test   %eax,%eax
801059e2:	74 14                	je     801059f8 <argfd.constprop.0+0x48>
  if (pfd)
801059e4:	85 db                	test   %ebx,%ebx
801059e6:	74 02                	je     801059ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801059e8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801059ea:	89 06                	mov    %eax,(%esi)
  return 0;
801059ec:	31 c0                	xor    %eax,%eax
}
801059ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059f1:	5b                   	pop    %ebx
801059f2:	5e                   	pop    %esi
801059f3:	5d                   	pop    %ebp
801059f4:	c3                   	ret    
801059f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	eb ef                	jmp    801059ee <argfd.constprop.0+0x3e>
801059ff:	90                   	nop

80105a00 <sys_dup>:
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0)
80105a05:	31 c0                	xor    %eax,%eax
{
80105a07:	89 e5                	mov    %esp,%ebp
80105a09:	56                   	push   %esi
80105a0a:	53                   	push   %ebx
  if (argfd(0, 0, &f) < 0)
80105a0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105a0e:	83 ec 10             	sub    $0x10,%esp
  if (argfd(0, 0, &f) < 0)
80105a11:	e8 9a ff ff ff       	call   801059b0 <argfd.constprop.0>
80105a16:	85 c0                	test   %eax,%eax
80105a18:	78 1e                	js     80105a38 <sys_dup+0x38>
  if ((fd = fdalloc(f)) < 0)
80105a1a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for (fd = 0; fd < NOFILE; fd++)
80105a1d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a1f:	e8 0c e2 ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105a28:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105a2c:	85 d2                	test   %edx,%edx
80105a2e:	74 20                	je     80105a50 <sys_dup+0x50>
  for (fd = 0; fd < NOFILE; fd++)
80105a30:	83 c3 01             	add    $0x1,%ebx
80105a33:	83 fb 10             	cmp    $0x10,%ebx
80105a36:	75 f0                	jne    80105a28 <sys_dup+0x28>
}
80105a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105a3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105a40:	89 d8                	mov    %ebx,%eax
80105a42:	5b                   	pop    %ebx
80105a43:	5e                   	pop    %esi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret    
80105a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105a50:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
80105a54:	83 ec 0c             	sub    $0xc,%esp
80105a57:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5a:	e8 11 b4 ff ff       	call   80100e70 <filedup>
  return fd;
80105a5f:	83 c4 10             	add    $0x10,%esp
}
80105a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a65:	89 d8                	mov    %ebx,%eax
80105a67:	5b                   	pop    %ebx
80105a68:	5e                   	pop    %esi
80105a69:	5d                   	pop    %ebp
80105a6a:	c3                   	ret    
80105a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop

80105a70 <sys_read>:
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a75:	31 c0                	xor    %eax,%eax
{
80105a77:	89 e5                	mov    %esp,%ebp
80105a79:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a7c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105a7f:	e8 2c ff ff ff       	call   801059b0 <argfd.constprop.0>
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 48                	js     80105ad0 <sys_read+0x60>
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8e:	50                   	push   %eax
80105a8f:	6a 02                	push   $0x2
80105a91:	e8 ca fb ff ff       	call   80105660 <argint>
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	78 33                	js     80105ad0 <sys_read+0x60>
80105a9d:	83 ec 04             	sub    $0x4,%esp
80105aa0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa3:	ff 75 f0             	pushl  -0x10(%ebp)
80105aa6:	50                   	push   %eax
80105aa7:	6a 01                	push   $0x1
80105aa9:	e8 52 fc ff ff       	call   80105700 <argptr>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	85 c0                	test   %eax,%eax
80105ab3:	78 1b                	js     80105ad0 <sys_read+0x60>
  return fileread(f, p, n);
80105ab5:	83 ec 04             	sub    $0x4,%esp
80105ab8:	ff 75 f0             	pushl  -0x10(%ebp)
80105abb:	ff 75 f4             	pushl  -0xc(%ebp)
80105abe:	ff 75 ec             	pushl  -0x14(%ebp)
80105ac1:	e8 2a b5 ff ff       	call   80100ff0 <fileread>
80105ac6:	83 c4 10             	add    $0x10,%esp
}
80105ac9:	c9                   	leave  
80105aca:	c3                   	ret    
80105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105acf:	90                   	nop
80105ad0:	c9                   	leave  
    return -1;
80105ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad6:	c3                   	ret    
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_write>:
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ae5:	31 c0                	xor    %eax,%eax
{
80105ae7:	89 e5                	mov    %esp,%ebp
80105ae9:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105aec:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105aef:	e8 bc fe ff ff       	call   801059b0 <argfd.constprop.0>
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 48                	js     80105b40 <sys_write+0x60>
80105af8:	83 ec 08             	sub    $0x8,%esp
80105afb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105afe:	50                   	push   %eax
80105aff:	6a 02                	push   $0x2
80105b01:	e8 5a fb ff ff       	call   80105660 <argint>
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	78 33                	js     80105b40 <sys_write+0x60>
80105b0d:	83 ec 04             	sub    $0x4,%esp
80105b10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b13:	ff 75 f0             	pushl  -0x10(%ebp)
80105b16:	50                   	push   %eax
80105b17:	6a 01                	push   $0x1
80105b19:	e8 e2 fb ff ff       	call   80105700 <argptr>
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
80105b23:	78 1b                	js     80105b40 <sys_write+0x60>
  return filewrite(f, p, n);
80105b25:	83 ec 04             	sub    $0x4,%esp
80105b28:	ff 75 f0             	pushl  -0x10(%ebp)
80105b2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b2e:	ff 75 ec             	pushl  -0x14(%ebp)
80105b31:	e8 5a b5 ff ff       	call   80101090 <filewrite>
80105b36:	83 c4 10             	add    $0x10,%esp
}
80105b39:	c9                   	leave  
80105b3a:	c3                   	ret    
80105b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b3f:	90                   	nop
80105b40:	c9                   	leave  
    return -1;
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b46:	c3                   	ret    
80105b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_close>:
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
80105b5a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105b5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b60:	e8 4b fe ff ff       	call   801059b0 <argfd.constprop.0>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 27                	js     80105b90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105b69:	e8 c2 e0 ff ff       	call   80103c30 <myproc>
80105b6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105b71:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105b74:	c7 44 90 34 00 00 00 	movl   $0x0,0x34(%eax,%edx,4)
80105b7b:	00 
  fileclose(f);
80105b7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b7f:	e8 3c b3 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105b84:	83 c4 10             	add    $0x10,%esp
80105b87:	31 c0                	xor    %eax,%eax
}
80105b89:	c9                   	leave  
80105b8a:	c3                   	ret    
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
80105b90:	c9                   	leave  
    return -1;
80105b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b96:	c3                   	ret    
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <sys_fstat>:
{
80105ba0:	f3 0f 1e fb          	endbr32 
80105ba4:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105ba5:	31 c0                	xor    %eax,%eax
{
80105ba7:	89 e5                	mov    %esp,%ebp
80105ba9:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105bac:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105baf:	e8 fc fd ff ff       	call   801059b0 <argfd.constprop.0>
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	78 30                	js     80105be8 <sys_fstat+0x48>
80105bb8:	83 ec 04             	sub    $0x4,%esp
80105bbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbe:	6a 14                	push   $0x14
80105bc0:	50                   	push   %eax
80105bc1:	6a 01                	push   $0x1
80105bc3:	e8 38 fb ff ff       	call   80105700 <argptr>
80105bc8:	83 c4 10             	add    $0x10,%esp
80105bcb:	85 c0                	test   %eax,%eax
80105bcd:	78 19                	js     80105be8 <sys_fstat+0x48>
  return filestat(f, st);
80105bcf:	83 ec 08             	sub    $0x8,%esp
80105bd2:	ff 75 f4             	pushl  -0xc(%ebp)
80105bd5:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd8:	e8 c3 b3 ff ff       	call   80100fa0 <filestat>
80105bdd:	83 c4 10             	add    $0x10,%esp
}
80105be0:	c9                   	leave  
80105be1:	c3                   	ret    
80105be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105be8:	c9                   	leave  
    return -1;
80105be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bee:	c3                   	ret    
80105bef:	90                   	nop

80105bf0 <sys_link>:
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	57                   	push   %edi
80105bf8:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bf9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105bfc:	53                   	push   %ebx
80105bfd:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c00:	50                   	push   %eax
80105c01:	6a 00                	push   $0x0
80105c03:	e8 58 fb ff ff       	call   80105760 <argstr>
80105c08:	83 c4 10             	add    $0x10,%esp
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	0f 88 ff 00 00 00    	js     80105d12 <sys_link+0x122>
80105c13:	83 ec 08             	sub    $0x8,%esp
80105c16:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	6a 01                	push   $0x1
80105c1c:	e8 3f fb ff ff       	call   80105760 <argstr>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	0f 88 e6 00 00 00    	js     80105d12 <sys_link+0x122>
  begin_op();
80105c2c:	e8 ff d0 ff ff       	call   80102d30 <begin_op>
  if ((ip = namei(old)) == 0)
80105c31:	83 ec 0c             	sub    $0xc,%esp
80105c34:	ff 75 d4             	pushl  -0x2c(%ebp)
80105c37:	e8 f4 c3 ff ff       	call   80102030 <namei>
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	89 c3                	mov    %eax,%ebx
80105c41:	85 c0                	test   %eax,%eax
80105c43:	0f 84 e8 00 00 00    	je     80105d31 <sys_link+0x141>
  ilock(ip);
80105c49:	83 ec 0c             	sub    $0xc,%esp
80105c4c:	50                   	push   %eax
80105c4d:	e8 0e bb ff ff       	call   80101760 <ilock>
  if (ip->type == T_DIR)
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c5a:	0f 84 b9 00 00 00    	je     80105d19 <sys_link+0x129>
  iupdate(ip);
80105c60:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105c63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105c68:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105c6b:	53                   	push   %ebx
80105c6c:	e8 2f ba ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105c71:	89 1c 24             	mov    %ebx,(%esp)
80105c74:	e8 c7 bb ff ff       	call   80101840 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105c79:	58                   	pop    %eax
80105c7a:	5a                   	pop    %edx
80105c7b:	57                   	push   %edi
80105c7c:	ff 75 d0             	pushl  -0x30(%ebp)
80105c7f:	e8 cc c3 ff ff       	call   80102050 <nameiparent>
80105c84:	83 c4 10             	add    $0x10,%esp
80105c87:	89 c6                	mov    %eax,%esi
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	74 5f                	je     80105cec <sys_link+0xfc>
  ilock(dp);
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	50                   	push   %eax
80105c91:	e8 ca ba ff ff       	call   80101760 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105c96:	8b 03                	mov    (%ebx),%eax
80105c98:	83 c4 10             	add    $0x10,%esp
80105c9b:	39 06                	cmp    %eax,(%esi)
80105c9d:	75 41                	jne    80105ce0 <sys_link+0xf0>
80105c9f:	83 ec 04             	sub    $0x4,%esp
80105ca2:	ff 73 04             	pushl  0x4(%ebx)
80105ca5:	57                   	push   %edi
80105ca6:	56                   	push   %esi
80105ca7:	e8 c4 c2 ff ff       	call   80101f70 <dirlink>
80105cac:	83 c4 10             	add    $0x10,%esp
80105caf:	85 c0                	test   %eax,%eax
80105cb1:	78 2d                	js     80105ce0 <sys_link+0xf0>
  iunlockput(dp);
80105cb3:	83 ec 0c             	sub    $0xc,%esp
80105cb6:	56                   	push   %esi
80105cb7:	e8 44 bd ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105cbc:	89 1c 24             	mov    %ebx,(%esp)
80105cbf:	e8 cc bb ff ff       	call   80101890 <iput>
  end_op();
80105cc4:	e8 d7 d0 ff ff       	call   80102da0 <end_op>
  return 0;
80105cc9:	83 c4 10             	add    $0x10,%esp
80105ccc:	31 c0                	xor    %eax,%eax
}
80105cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd1:	5b                   	pop    %ebx
80105cd2:	5e                   	pop    %esi
80105cd3:	5f                   	pop    %edi
80105cd4:	5d                   	pop    %ebp
80105cd5:	c3                   	ret    
80105cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	56                   	push   %esi
80105ce4:	e8 17 bd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105ce9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	53                   	push   %ebx
80105cf0:	e8 6b ba ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105cf5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cfa:	89 1c 24             	mov    %ebx,(%esp)
80105cfd:	e8 9e b9 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105d02:	89 1c 24             	mov    %ebx,(%esp)
80105d05:	e8 f6 bc ff ff       	call   80101a00 <iunlockput>
  end_op();
80105d0a:	e8 91 d0 ff ff       	call   80102da0 <end_op>
  return -1;
80105d0f:	83 c4 10             	add    $0x10,%esp
80105d12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d17:	eb b5                	jmp    80105cce <sys_link+0xde>
    iunlockput(ip);
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	53                   	push   %ebx
80105d1d:	e8 de bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d22:	e8 79 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2f:	eb 9d                	jmp    80105cce <sys_link+0xde>
    end_op();
80105d31:	e8 6a d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3b:	eb 91                	jmp    80105cce <sys_link+0xde>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi

80105d40 <sys_unlink>:
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105d49:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105d4c:	53                   	push   %ebx
80105d4d:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105d50:	50                   	push   %eax
80105d51:	6a 00                	push   $0x0
80105d53:	e8 08 fa ff ff       	call   80105760 <argstr>
80105d58:	83 c4 10             	add    $0x10,%esp
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	0f 88 7d 01 00 00    	js     80105ee0 <sys_unlink+0x1a0>
  begin_op();
80105d63:	e8 c8 cf ff ff       	call   80102d30 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105d68:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105d6b:	83 ec 08             	sub    $0x8,%esp
80105d6e:	53                   	push   %ebx
80105d6f:	ff 75 c0             	pushl  -0x40(%ebp)
80105d72:	e8 d9 c2 ff ff       	call   80102050 <nameiparent>
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	89 c6                	mov    %eax,%esi
80105d7c:	85 c0                	test   %eax,%eax
80105d7e:	0f 84 66 01 00 00    	je     80105eea <sys_unlink+0x1aa>
  ilock(dp);
80105d84:	83 ec 0c             	sub    $0xc,%esp
80105d87:	50                   	push   %eax
80105d88:	e8 d3 b9 ff ff       	call   80101760 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d8d:	58                   	pop    %eax
80105d8e:	5a                   	pop    %edx
80105d8f:	68 0c 8f 10 80       	push   $0x80108f0c
80105d94:	53                   	push   %ebx
80105d95:	e8 f6 be ff ff       	call   80101c90 <namecmp>
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	85 c0                	test   %eax,%eax
80105d9f:	0f 84 03 01 00 00    	je     80105ea8 <sys_unlink+0x168>
80105da5:	83 ec 08             	sub    $0x8,%esp
80105da8:	68 0b 8f 10 80       	push   $0x80108f0b
80105dad:	53                   	push   %ebx
80105dae:	e8 dd be ff ff       	call   80101c90 <namecmp>
80105db3:	83 c4 10             	add    $0x10,%esp
80105db6:	85 c0                	test   %eax,%eax
80105db8:	0f 84 ea 00 00 00    	je     80105ea8 <sys_unlink+0x168>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80105dbe:	83 ec 04             	sub    $0x4,%esp
80105dc1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105dc4:	50                   	push   %eax
80105dc5:	53                   	push   %ebx
80105dc6:	56                   	push   %esi
80105dc7:	e8 e4 be ff ff       	call   80101cb0 <dirlookup>
80105dcc:	83 c4 10             	add    $0x10,%esp
80105dcf:	89 c3                	mov    %eax,%ebx
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	0f 84 cf 00 00 00    	je     80105ea8 <sys_unlink+0x168>
  ilock(ip);
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	50                   	push   %eax
80105ddd:	e8 7e b9 ff ff       	call   80101760 <ilock>
  if (ip->nlink < 1)
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105dea:	0f 8e 23 01 00 00    	jle    80105f13 <sys_unlink+0x1d3>
  if (ip->type == T_DIR && !isdirempty(ip))
80105df0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105df5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105df8:	74 66                	je     80105e60 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105dfa:	83 ec 04             	sub    $0x4,%esp
80105dfd:	6a 10                	push   $0x10
80105dff:	6a 00                	push   $0x0
80105e01:	57                   	push   %edi
80105e02:	e8 39 f5 ff ff       	call   80105340 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105e07:	6a 10                	push   $0x10
80105e09:	ff 75 c4             	pushl  -0x3c(%ebp)
80105e0c:	57                   	push   %edi
80105e0d:	56                   	push   %esi
80105e0e:	e8 4d bd ff ff       	call   80101b60 <writei>
80105e13:	83 c4 20             	add    $0x20,%esp
80105e16:	83 f8 10             	cmp    $0x10,%eax
80105e19:	0f 85 e7 00 00 00    	jne    80105f06 <sys_unlink+0x1c6>
  if (ip->type == T_DIR)
80105e1f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e24:	0f 84 96 00 00 00    	je     80105ec0 <sys_unlink+0x180>
  iunlockput(dp);
80105e2a:	83 ec 0c             	sub    $0xc,%esp
80105e2d:	56                   	push   %esi
80105e2e:	e8 cd bb ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105e33:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e38:	89 1c 24             	mov    %ebx,(%esp)
80105e3b:	e8 60 b8 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105e40:	89 1c 24             	mov    %ebx,(%esp)
80105e43:	e8 b8 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105e48:	e8 53 cf ff ff       	call   80102da0 <end_op>
  return 0;
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	31 c0                	xor    %eax,%eax
}
80105e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e55:	5b                   	pop    %ebx
80105e56:	5e                   	pop    %esi
80105e57:	5f                   	pop    %edi
80105e58:	5d                   	pop    %ebp
80105e59:	c3                   	ret    
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105e60:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105e64:	76 94                	jbe    80105dfa <sys_unlink+0xba>
80105e66:	ba 20 00 00 00       	mov    $0x20,%edx
80105e6b:	eb 0b                	jmp    80105e78 <sys_unlink+0x138>
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi
80105e70:	83 c2 10             	add    $0x10,%edx
80105e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80105e76:	76 82                	jbe    80105dfa <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105e78:	6a 10                	push   $0x10
80105e7a:	52                   	push   %edx
80105e7b:	57                   	push   %edi
80105e7c:	53                   	push   %ebx
80105e7d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105e80:	e8 db bb ff ff       	call   80101a60 <readi>
80105e85:	83 c4 10             	add    $0x10,%esp
80105e88:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105e8b:	83 f8 10             	cmp    $0x10,%eax
80105e8e:	75 69                	jne    80105ef9 <sys_unlink+0x1b9>
    if (de.inum != 0)
80105e90:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105e95:	74 d9                	je     80105e70 <sys_unlink+0x130>
    iunlockput(ip);
80105e97:	83 ec 0c             	sub    $0xc,%esp
80105e9a:	53                   	push   %ebx
80105e9b:	e8 60 bb ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105ea0:	83 c4 10             	add    $0x10,%esp
80105ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ea7:	90                   	nop
  iunlockput(dp);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	56                   	push   %esi
80105eac:	e8 4f bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105eb1:	e8 ea ce ff ff       	call   80102da0 <end_op>
  return -1;
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebe:	eb 92                	jmp    80105e52 <sys_unlink+0x112>
    iupdate(dp);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105ec3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ec8:	56                   	push   %esi
80105ec9:	e8 d2 b7 ff ff       	call   801016a0 <iupdate>
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	e9 54 ff ff ff       	jmp    80105e2a <sys_unlink+0xea>
80105ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee5:	e9 68 ff ff ff       	jmp    80105e52 <sys_unlink+0x112>
    end_op();
80105eea:	e8 b1 ce ff ff       	call   80102da0 <end_op>
    return -1;
80105eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef4:	e9 59 ff ff ff       	jmp    80105e52 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105ef9:	83 ec 0c             	sub    $0xc,%esp
80105efc:	68 30 8f 10 80       	push   $0x80108f30
80105f01:	e8 8a a4 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105f06:	83 ec 0c             	sub    $0xc,%esp
80105f09:	68 42 8f 10 80       	push   $0x80108f42
80105f0e:	e8 7d a4 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105f13:	83 ec 0c             	sub    $0xc,%esp
80105f16:	68 1e 8f 10 80       	push   $0x80108f1e
80105f1b:	e8 70 a4 ff ff       	call   80100390 <panic>

80105f20 <sys_open>:

int sys_open(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	57                   	push   %edi
80105f28:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f29:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105f2c:	53                   	push   %ebx
80105f2d:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f30:	50                   	push   %eax
80105f31:	6a 00                	push   $0x0
80105f33:	e8 28 f8 ff ff       	call   80105760 <argstr>
80105f38:	83 c4 10             	add    $0x10,%esp
80105f3b:	85 c0                	test   %eax,%eax
80105f3d:	0f 88 8a 00 00 00    	js     80105fcd <sys_open+0xad>
80105f43:	83 ec 08             	sub    $0x8,%esp
80105f46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f49:	50                   	push   %eax
80105f4a:	6a 01                	push   $0x1
80105f4c:	e8 0f f7 ff ff       	call   80105660 <argint>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	85 c0                	test   %eax,%eax
80105f56:	78 75                	js     80105fcd <sys_open+0xad>
    return -1;

  begin_op();
80105f58:	e8 d3 cd ff ff       	call   80102d30 <begin_op>

  if (omode & O_CREATE)
80105f5d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105f61:	75 75                	jne    80105fd8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105f63:	83 ec 0c             	sub    $0xc,%esp
80105f66:	ff 75 e0             	pushl  -0x20(%ebp)
80105f69:	e8 c2 c0 ff ff       	call   80102030 <namei>
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	89 c6                	mov    %eax,%esi
80105f73:	85 c0                	test   %eax,%eax
80105f75:	74 7e                	je     80105ff5 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105f77:	83 ec 0c             	sub    $0xc,%esp
80105f7a:	50                   	push   %eax
80105f7b:	e8 e0 b7 ff ff       	call   80101760 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105f80:	83 c4 10             	add    $0x10,%esp
80105f83:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f88:	0f 84 c2 00 00 00    	je     80106050 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105f8e:	e8 6d ae ff ff       	call   80100e00 <filealloc>
80105f93:	89 c7                	mov    %eax,%edi
80105f95:	85 c0                	test   %eax,%eax
80105f97:	74 23                	je     80105fbc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105f99:	e8 92 dc ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105f9e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105fa0:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105fa4:	85 d2                	test   %edx,%edx
80105fa6:	74 60                	je     80106008 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105fa8:	83 c3 01             	add    $0x1,%ebx
80105fab:	83 fb 10             	cmp    $0x10,%ebx
80105fae:	75 f0                	jne    80105fa0 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	57                   	push   %edi
80105fb4:	e8 07 af ff ff       	call   80100ec0 <fileclose>
80105fb9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	56                   	push   %esi
80105fc0:	e8 3b ba ff ff       	call   80101a00 <iunlockput>
    end_op();
80105fc5:	e8 d6 cd ff ff       	call   80102da0 <end_op>
    return -1;
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fd2:	eb 6d                	jmp    80106041 <sys_open+0x121>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105fd8:	83 ec 0c             	sub    $0xc,%esp
80105fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105fde:	31 c9                	xor    %ecx,%ecx
80105fe0:	ba 02 00 00 00       	mov    $0x2,%edx
80105fe5:	6a 00                	push   $0x0
80105fe7:	e8 24 f8 ff ff       	call   80105810 <create>
    if (ip == 0)
80105fec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105fef:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	75 99                	jne    80105f8e <sys_open+0x6e>
      end_op();
80105ff5:	e8 a6 cd ff ff       	call   80102da0 <end_op>
      return -1;
80105ffa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fff:	eb 40                	jmp    80106041 <sys_open+0x121>
80106001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106008:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010600b:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
8010600f:	56                   	push   %esi
80106010:	e8 2b b8 ff ff       	call   80101840 <iunlock>
  end_op();
80106015:	e8 86 cd ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010601a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106020:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106023:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106026:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106029:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010602b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106032:	f7 d0                	not    %eax
80106034:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106037:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010603a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010603d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106044:	89 d8                	mov    %ebx,%eax
80106046:	5b                   	pop    %ebx
80106047:	5e                   	pop    %esi
80106048:	5f                   	pop    %edi
80106049:	5d                   	pop    %ebp
8010604a:	c3                   	ret    
8010604b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80106050:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106053:	85 c9                	test   %ecx,%ecx
80106055:	0f 84 33 ff ff ff    	je     80105f8e <sys_open+0x6e>
8010605b:	e9 5c ff ff ff       	jmp    80105fbc <sys_open+0x9c>

80106060 <sys_mkdir>:

int sys_mkdir(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010606a:	e8 c1 cc ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
8010606f:	83 ec 08             	sub    $0x8,%esp
80106072:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106075:	50                   	push   %eax
80106076:	6a 00                	push   $0x0
80106078:	e8 e3 f6 ff ff       	call   80105760 <argstr>
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	85 c0                	test   %eax,%eax
80106082:	78 34                	js     801060b8 <sys_mkdir+0x58>
80106084:	83 ec 0c             	sub    $0xc,%esp
80106087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608a:	31 c9                	xor    %ecx,%ecx
8010608c:	ba 01 00 00 00       	mov    $0x1,%edx
80106091:	6a 00                	push   $0x0
80106093:	e8 78 f7 ff ff       	call   80105810 <create>
80106098:	83 c4 10             	add    $0x10,%esp
8010609b:	85 c0                	test   %eax,%eax
8010609d:	74 19                	je     801060b8 <sys_mkdir+0x58>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
8010609f:	83 ec 0c             	sub    $0xc,%esp
801060a2:	50                   	push   %eax
801060a3:	e8 58 b9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801060a8:	e8 f3 cc ff ff       	call   80102da0 <end_op>
  return 0;
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	31 c0                	xor    %eax,%eax
}
801060b2:	c9                   	leave  
801060b3:	c3                   	ret    
801060b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801060b8:	e8 e3 cc ff ff       	call   80102da0 <end_op>
    return -1;
801060bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c2:	c9                   	leave  
801060c3:	c3                   	ret    
801060c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop

801060d0 <sys_mknod>:

int sys_mknod(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801060da:	e8 51 cc ff ff       	call   80102d30 <begin_op>
  if ((argstr(0, &path)) < 0 ||
801060df:	83 ec 08             	sub    $0x8,%esp
801060e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060e5:	50                   	push   %eax
801060e6:	6a 00                	push   $0x0
801060e8:	e8 73 f6 ff ff       	call   80105760 <argstr>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	78 64                	js     80106158 <sys_mknod+0x88>
      argint(1, &major) < 0 ||
801060f4:	83 ec 08             	sub    $0x8,%esp
801060f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060fa:	50                   	push   %eax
801060fb:	6a 01                	push   $0x1
801060fd:	e8 5e f5 ff ff       	call   80105660 <argint>
  if ((argstr(0, &path)) < 0 ||
80106102:	83 c4 10             	add    $0x10,%esp
80106105:	85 c0                	test   %eax,%eax
80106107:	78 4f                	js     80106158 <sys_mknod+0x88>
      argint(2, &minor) < 0 ||
80106109:	83 ec 08             	sub    $0x8,%esp
8010610c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010610f:	50                   	push   %eax
80106110:	6a 02                	push   $0x2
80106112:	e8 49 f5 ff ff       	call   80105660 <argint>
      argint(1, &major) < 0 ||
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	85 c0                	test   %eax,%eax
8010611c:	78 3a                	js     80106158 <sys_mknod+0x88>
      (ip = create(path, T_DEV, major, minor)) == 0)
8010611e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106122:	83 ec 0c             	sub    $0xc,%esp
80106125:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106129:	ba 03 00 00 00       	mov    $0x3,%edx
8010612e:	50                   	push   %eax
8010612f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106132:	e8 d9 f6 ff ff       	call   80105810 <create>
      argint(2, &minor) < 0 ||
80106137:	83 c4 10             	add    $0x10,%esp
8010613a:	85 c0                	test   %eax,%eax
8010613c:	74 1a                	je     80106158 <sys_mknod+0x88>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
8010613e:	83 ec 0c             	sub    $0xc,%esp
80106141:	50                   	push   %eax
80106142:	e8 b9 b8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80106147:	e8 54 cc ff ff       	call   80102da0 <end_op>
  return 0;
8010614c:	83 c4 10             	add    $0x10,%esp
8010614f:	31 c0                	xor    %eax,%eax
}
80106151:	c9                   	leave  
80106152:	c3                   	ret    
80106153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106157:	90                   	nop
    end_op();
80106158:	e8 43 cc ff ff       	call   80102da0 <end_op>
    return -1;
8010615d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106162:	c9                   	leave  
80106163:	c3                   	ret    
80106164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <sys_chdir>:

int sys_chdir(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	56                   	push   %esi
80106178:	53                   	push   %ebx
80106179:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010617c:	e8 af da ff ff       	call   80103c30 <myproc>
80106181:	89 c6                	mov    %eax,%esi

  begin_op();
80106183:	e8 a8 cb ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80106188:	83 ec 08             	sub    $0x8,%esp
8010618b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010618e:	50                   	push   %eax
8010618f:	6a 00                	push   $0x0
80106191:	e8 ca f5 ff ff       	call   80105760 <argstr>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	78 73                	js     80106210 <sys_chdir+0xa0>
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	ff 75 f4             	pushl  -0xc(%ebp)
801061a3:	e8 88 be ff ff       	call   80102030 <namei>
801061a8:	83 c4 10             	add    $0x10,%esp
801061ab:	89 c3                	mov    %eax,%ebx
801061ad:	85 c0                	test   %eax,%eax
801061af:	74 5f                	je     80106210 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	50                   	push   %eax
801061b5:	e8 a6 b5 ff ff       	call   80101760 <ilock>
  if (ip->type != T_DIR)
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801061c2:	75 2c                	jne    801061f0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801061c4:	83 ec 0c             	sub    $0xc,%esp
801061c7:	53                   	push   %ebx
801061c8:	e8 73 b6 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801061cd:	58                   	pop    %eax
801061ce:	ff 76 74             	pushl  0x74(%esi)
801061d1:	e8 ba b6 ff ff       	call   80101890 <iput>
  end_op();
801061d6:	e8 c5 cb ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
801061db:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	31 c0                	xor    %eax,%eax
}
801061e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061e6:	5b                   	pop    %ebx
801061e7:	5e                   	pop    %esi
801061e8:	5d                   	pop    %ebp
801061e9:	c3                   	ret    
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	53                   	push   %ebx
801061f4:	e8 07 b8 ff ff       	call   80101a00 <iunlockput>
    end_op();
801061f9:	e8 a2 cb ff ff       	call   80102da0 <end_op>
    return -1;
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106206:	eb db                	jmp    801061e3 <sys_chdir+0x73>
80106208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop
    end_op();
80106210:	e8 8b cb ff ff       	call   80102da0 <end_op>
    return -1;
80106215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621a:	eb c7                	jmp    801061e3 <sys_chdir+0x73>
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_exec>:

int sys_exec(void)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	57                   	push   %edi
80106228:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106229:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010622f:	53                   	push   %ebx
80106230:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106236:	50                   	push   %eax
80106237:	6a 00                	push   $0x0
80106239:	e8 22 f5 ff ff       	call   80105760 <argstr>
8010623e:	83 c4 10             	add    $0x10,%esp
80106241:	85 c0                	test   %eax,%eax
80106243:	0f 88 8b 00 00 00    	js     801062d4 <sys_exec+0xb4>
80106249:	83 ec 08             	sub    $0x8,%esp
8010624c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106252:	50                   	push   %eax
80106253:	6a 01                	push   $0x1
80106255:	e8 06 f4 ff ff       	call   80105660 <argint>
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	85 c0                	test   %eax,%eax
8010625f:	78 73                	js     801062d4 <sys_exec+0xb4>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106261:	83 ec 04             	sub    $0x4,%esp
80106264:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for (i = 0;; i++)
8010626a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010626c:	68 80 00 00 00       	push   $0x80
80106271:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106277:	6a 00                	push   $0x0
80106279:	50                   	push   %eax
8010627a:	e8 c1 f0 ff ff       	call   80105340 <memset>
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80106288:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010628e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106295:	83 ec 08             	sub    $0x8,%esp
80106298:	57                   	push   %edi
80106299:	01 f0                	add    %esi,%eax
8010629b:	50                   	push   %eax
8010629c:	e8 df f2 ff ff       	call   80105580 <fetchint>
801062a1:	83 c4 10             	add    $0x10,%esp
801062a4:	85 c0                	test   %eax,%eax
801062a6:	78 2c                	js     801062d4 <sys_exec+0xb4>
      return -1;
    if (uarg == 0)
801062a8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801062ae:	85 c0                	test   %eax,%eax
801062b0:	74 36                	je     801062e8 <sys_exec+0xc8>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
801062b2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801062b8:	83 ec 08             	sub    $0x8,%esp
801062bb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801062be:	52                   	push   %edx
801062bf:	50                   	push   %eax
801062c0:	e8 fb f2 ff ff       	call   801055c0 <fetchstr>
801062c5:	83 c4 10             	add    $0x10,%esp
801062c8:	85 c0                	test   %eax,%eax
801062ca:	78 08                	js     801062d4 <sys_exec+0xb4>
  for (i = 0;; i++)
801062cc:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
801062cf:	83 fb 20             	cmp    $0x20,%ebx
801062d2:	75 b4                	jne    80106288 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801062d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801062d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062dc:	5b                   	pop    %ebx
801062dd:	5e                   	pop    %esi
801062de:	5f                   	pop    %edi
801062df:	5d                   	pop    %ebp
801062e0:	c3                   	ret    
801062e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801062e8:	83 ec 08             	sub    $0x8,%esp
801062eb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801062f1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801062f8:	00 00 00 00 
  return exec(path, argv);
801062fc:	50                   	push   %eax
801062fd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106303:	e8 78 a7 ff ff       	call   80100a80 <exec>
80106308:	83 c4 10             	add    $0x10,%esp
}
8010630b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010630e:	5b                   	pop    %ebx
8010630f:	5e                   	pop    %esi
80106310:	5f                   	pop    %edi
80106311:	5d                   	pop    %ebp
80106312:	c3                   	ret    
80106313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106320 <sys_pipe>:

int sys_pipe(void)
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
80106325:	89 e5                	mov    %esp,%ebp
80106327:	57                   	push   %edi
80106328:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80106329:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010632c:	53                   	push   %ebx
8010632d:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80106330:	6a 08                	push   $0x8
80106332:	50                   	push   %eax
80106333:	6a 00                	push   $0x0
80106335:	e8 c6 f3 ff ff       	call   80105700 <argptr>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	85 c0                	test   %eax,%eax
8010633f:	78 4e                	js     8010638f <sys_pipe+0x6f>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80106341:	83 ec 08             	sub    $0x8,%esp
80106344:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106347:	50                   	push   %eax
80106348:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010634b:	50                   	push   %eax
8010634c:	e8 df d1 ff ff       	call   80103530 <pipealloc>
80106351:	83 c4 10             	add    $0x10,%esp
80106354:	85 c0                	test   %eax,%eax
80106356:	78 37                	js     8010638f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106358:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
8010635b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010635d:	e8 ce d8 ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106368:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
8010636c:	85 f6                	test   %esi,%esi
8010636e:	74 30                	je     801063a0 <sys_pipe+0x80>
  for (fd = 0; fd < NOFILE; fd++)
80106370:	83 c3 01             	add    $0x1,%ebx
80106373:	83 fb 10             	cmp    $0x10,%ebx
80106376:	75 f0                	jne    80106368 <sys_pipe+0x48>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106378:	83 ec 0c             	sub    $0xc,%esp
8010637b:	ff 75 e0             	pushl  -0x20(%ebp)
8010637e:	e8 3d ab ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80106383:	58                   	pop    %eax
80106384:	ff 75 e4             	pushl  -0x1c(%ebp)
80106387:	e8 34 ab ff ff       	call   80100ec0 <fileclose>
    return -1;
8010638c:	83 c4 10             	add    $0x10,%esp
8010638f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106394:	eb 5b                	jmp    801063f1 <sys_pipe+0xd1>
80106396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801063a0:	8d 73 0c             	lea    0xc(%ebx),%esi
801063a3:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
801063a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801063aa:	e8 81 d8 ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801063af:	31 d2                	xor    %edx,%edx
801063b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
801063b8:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
801063bc:	85 c9                	test   %ecx,%ecx
801063be:	74 20                	je     801063e0 <sys_pipe+0xc0>
  for (fd = 0; fd < NOFILE; fd++)
801063c0:	83 c2 01             	add    $0x1,%edx
801063c3:	83 fa 10             	cmp    $0x10,%edx
801063c6:	75 f0                	jne    801063b8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801063c8:	e8 63 d8 ff ff       	call   80103c30 <myproc>
801063cd:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
801063d4:	00 
801063d5:	eb a1                	jmp    80106378 <sys_pipe+0x58>
801063d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801063e0:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
801063e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801063e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801063ef:	31 c0                	xor    %eax,%eax
}
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <sys_copy_file>:
}



int sys_copy_file(void)
{
80106400:	f3 0f 1e fb          	endbr32 
80106404:	55                   	push   %ebp
80106405:	89 e5                	mov    %esp,%ebp
80106407:	57                   	push   %edi
80106408:	56                   	push   %esi
80106409:	53                   	push   %ebx
8010640a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80106410:	83 0c 24 00          	orl    $0x0,(%esp)
80106414:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80106417:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
8010641d:	50                   	push   %eax
8010641e:	6a 00                	push   $0x0
80106420:	e8 3b f3 ff ff       	call   80105760 <argstr>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	85 c0                	test   %eax,%eax
8010642a:	0f 88 7d 01 00 00    	js     801065ad <sys_copy_file+0x1ad>
80106430:	83 ec 08             	sub    $0x8,%esp
80106433:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 01                	push   $0x1
8010643c:	e8 1f f3 ff ff       	call   80105760 <argstr>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	0f 88 61 01 00 00    	js     801065ad <sys_copy_file+0x1ad>
    return -1;

  begin_op();
8010644c:	e8 df c8 ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
80106451:	83 ec 0c             	sub    $0xc,%esp
80106454:	ff b5 e0 ef ff ff    	pushl  -0x1020(%ebp)
8010645a:	e8 d1 bb ff ff       	call   80102030 <namei>
8010645f:	83 c4 10             	add    $0x10,%esp
80106462:	89 c6                	mov    %eax,%esi
80106464:	85 c0                	test   %eax,%eax
80106466:	0f 84 bc 01 00 00    	je     80106628 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
8010646c:	83 ec 0c             	sub    $0xc,%esp
8010646f:	50                   	push   %eax
80106470:	e8 eb b2 ff ff       	call   80101760 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80106475:	e8 86 a9 ff ff       	call   80100e00 <filealloc>
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	89 c7                	mov    %eax,%edi
8010647f:	85 c0                	test   %eax,%eax
80106481:	74 29                	je     801064ac <sys_copy_file+0xac>
  struct proc *curproc = myproc();
80106483:	e8 a8 d7 ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106488:	31 d2                	xor    %edx,%edx
8010648a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106490:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106494:	85 c9                	test   %ecx,%ecx
80106496:	74 38                	je     801064d0 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80106498:	83 c2 01             	add    $0x1,%edx
8010649b:	83 fa 10             	cmp    $0x10,%edx
8010649e:	75 f0                	jne    80106490 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	57                   	push   %edi
801064a4:	e8 17 aa ff ff       	call   80100ec0 <fileclose>
801064a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801064ac:	83 ec 0c             	sub    $0xc,%esp
801064af:	56                   	push   %esi
801064b0:	e8 4b b5 ff ff       	call   80101a00 <iunlockput>
    end_op();
801064b5:	e8 e6 c8 ff ff       	call   80102da0 <end_op>
    return -1;
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c2:	e9 59 01 00 00       	jmp    80106620 <sys_copy_file+0x220>
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801064d0:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
801064d3:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801064d6:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
801064da:	56                   	push   %esi
801064db:	e8 60 b3 ff ff       	call   80101840 <iunlock>
  end_op();
801064e0:	e8 bb c8 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
801064e5:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
801064ea:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
801064ed:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
801064f3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
801064fa:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
801064fe:	e8 2d d7 ff ff       	call   80103c30 <myproc>
80106503:	83 c4 10             	add    $0x10,%esp
80106506:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
8010650a:	85 c0                	test   %eax,%eax
8010650c:	0f 84 9b 00 00 00    	je     801065ad <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80106512:	83 ec 04             	sub    $0x4,%esp
80106515:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
8010651b:	68 00 10 00 00       	push   $0x1000
80106520:	57                   	push   %edi
80106521:	50                   	push   %eax
80106522:	e8 c9 aa ff ff       	call   80100ff0 <fileread>
80106527:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
8010652d:	e8 fe c7 ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
80106532:	58                   	pop    %eax
80106533:	ff b5 e4 ef ff ff    	pushl  -0x101c(%ebp)
80106539:	e8 f2 ba ff ff       	call   80102030 <namei>
8010653e:	83 c4 10             	add    $0x10,%esp
80106541:	89 c3                	mov    %eax,%ebx
80106543:	85 c0                	test   %eax,%eax
80106545:	0f 84 dd 00 00 00    	je     80106628 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
8010654b:	83 ec 0c             	sub    $0xc,%esp
8010654e:	50                   	push   %eax
8010654f:	e8 0c b2 ff ff       	call   80101760 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80106554:	83 c4 10             	add    $0x10,%esp
80106557:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010655c:	75 0a                	jne    80106568 <sys_copy_file+0x168>
8010655e:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80106564:	85 f6                	test   %esi,%esi
80106566:	75 34                	jne    8010659c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80106568:	e8 93 a8 ff ff       	call   80100e00 <filealloc>
8010656d:	89 c6                	mov    %eax,%esi
8010656f:	85 c0                	test   %eax,%eax
80106571:	74 29                	je     8010659c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80106573:	e8 b8 d6 ff ff       	call   80103c30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106578:	31 d2                	xor    %edx,%edx
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106580:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106584:	85 c9                	test   %ecx,%ecx
80106586:	74 30                	je     801065b8 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80106588:	83 c2 01             	add    $0x1,%edx
8010658b:	83 fa 10             	cmp    $0x10,%edx
8010658e:	75 f0                	jne    80106580 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	56                   	push   %esi
80106594:	e8 27 a9 ff ff       	call   80100ec0 <fileclose>
80106599:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
8010659c:	83 ec 0c             	sub    $0xc,%esp
8010659f:	53                   	push   %ebx
801065a0:	e8 5b b4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801065a5:	e8 f6 c7 ff ff       	call   80102da0 <end_op>
    return -1;
801065aa:	83 c4 10             	add    $0x10,%esp
801065ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b2:	eb 6c                	jmp    80106620 <sys_copy_file+0x220>
801065b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801065b8:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
801065bb:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801065be:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
801065c2:	53                   	push   %ebx
      curproc->ofile[fd] = f;
801065c3:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
801065c9:	e8 72 b2 ff ff       	call   80101840 <iunlock>
  end_op();
801065ce:	e8 cd c7 ff ff       	call   80102da0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
801065d3:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
801065d8:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
801065db:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
801065e1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
801065e8:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
801065ec:	e8 3f d6 ff ff       	call   80103c30 <myproc>
801065f1:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
801065f7:	83 c4 10             	add    $0x10,%esp
801065fa:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801065fe:	85 c0                	test   %eax,%eax
80106600:	74 ab                	je     801065ad <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
80106602:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
80106608:	83 ec 04             	sub    $0x4,%esp
8010660b:	53                   	push   %ebx
8010660c:	57                   	push   %edi
8010660d:	50                   	push   %eax
8010660e:	e8 7d aa ff ff       	call   80101090 <filewrite>
  if(written_chars != read_chars){
80106613:	83 c4 10             	add    $0x10,%esp
80106616:	39 c3                	cmp    %eax,%ebx
80106618:	0f 95 c0             	setne  %al
8010661b:	0f b6 c0             	movzbl %al,%eax
8010661e:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80106620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106623:	5b                   	pop    %ebx
80106624:	5e                   	pop    %esi
80106625:	5f                   	pop    %edi
80106626:	5d                   	pop    %ebp
80106627:	c3                   	ret    
      end_op();
80106628:	e8 73 c7 ff ff       	call   80102da0 <end_op>
      return -1;
8010662d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106632:	eb ec                	jmp    80106620 <sys_copy_file+0x220>
80106634:	66 90                	xchg   %ax,%ax
80106636:	66 90                	xchg   %ax,%ax
80106638:	66 90                	xchg   %ax,%ax
8010663a:	66 90                	xchg   %ax,%ax
8010663c:	66 90                	xchg   %ax,%ax
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80106640:	f3 0f 1e fb          	endbr32 
  return fork();
80106644:	e9 47 dd ff ff       	jmp    80104390 <fork>
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106650 <sys_exit>:
}

int sys_exit(void)
{
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	89 e5                	mov    %esp,%ebp
80106657:	83 ec 08             	sub    $0x8,%esp
  exit();
8010665a:	e8 01 e2 ff ff       	call   80104860 <exit>
  return 0; // not reached
}
8010665f:	31 c0                	xor    %eax,%eax
80106661:	c9                   	leave  
80106662:	c3                   	ret    
80106663:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106670 <sys_wait>:

int sys_wait(void)
{
80106670:	f3 0f 1e fb          	endbr32 
  return wait();
80106674:	e9 87 e4 ff ff       	jmp    80104b00 <wait>
80106679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106680 <sys_kill>:
}

int sys_kill(void)
{
80106680:	f3 0f 1e fb          	endbr32 
80106684:	55                   	push   %ebp
80106685:	89 e5                	mov    %esp,%ebp
80106687:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
8010668a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010668d:	50                   	push   %eax
8010668e:	6a 00                	push   $0x0
80106690:	e8 cb ef ff ff       	call   80105660 <argint>
80106695:	83 c4 10             	add    $0x10,%esp
80106698:	85 c0                	test   %eax,%eax
8010669a:	78 14                	js     801066b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010669c:	83 ec 0c             	sub    $0xc,%esp
8010669f:	ff 75 f4             	pushl  -0xc(%ebp)
801066a2:	e8 c9 e6 ff ff       	call   80104d70 <kill>
801066a7:	83 c4 10             	add    $0x10,%esp
}
801066aa:	c9                   	leave  
801066ab:	c3                   	ret    
801066ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066b0:	c9                   	leave  
    return -1;
801066b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066b6:	c3                   	ret    
801066b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066be:	66 90                	xchg   %ax,%ax

801066c0 <sys_getpid>:

int sys_getpid(void)
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
801066c5:	89 e5                	mov    %esp,%ebp
801066c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801066ca:	e8 61 d5 ff ff       	call   80103c30 <myproc>
801066cf:	8b 40 10             	mov    0x10(%eax),%eax
}
801066d2:	c9                   	leave  
801066d3:	c3                   	ret    
801066d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066df:	90                   	nop

801066e0 <sys_sbrk>:

int sys_sbrk(void)
{
801066e0:	f3 0f 1e fb          	endbr32 
801066e4:	55                   	push   %ebp
801066e5:	89 e5                	mov    %esp,%ebp
801066e7:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
801066e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801066eb:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801066ee:	50                   	push   %eax
801066ef:	6a 00                	push   $0x0
801066f1:	e8 6a ef ff ff       	call   80105660 <argint>
801066f6:	83 c4 10             	add    $0x10,%esp
801066f9:	85 c0                	test   %eax,%eax
801066fb:	78 23                	js     80106720 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801066fd:	e8 2e d5 ff ff       	call   80103c30 <myproc>
  if (growproc(n) < 0)
80106702:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106705:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106707:	ff 75 f4             	pushl  -0xc(%ebp)
8010670a:	e8 01 dc ff ff       	call   80104310 <growproc>
8010670f:	83 c4 10             	add    $0x10,%esp
80106712:	85 c0                	test   %eax,%eax
80106714:	78 0a                	js     80106720 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106716:	89 d8                	mov    %ebx,%eax
80106718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010671b:	c9                   	leave  
8010671c:	c3                   	ret    
8010671d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106720:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106725:	eb ef                	jmp    80106716 <sys_sbrk+0x36>
80106727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010672e:	66 90                	xchg   %ax,%ax

80106730 <sys_sleep>:

int sys_sleep(void)
{
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	89 e5                	mov    %esp,%ebp
80106737:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106738:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010673b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010673e:	50                   	push   %eax
8010673f:	6a 00                	push   $0x0
80106741:	e8 1a ef ff ff       	call   80105660 <argint>
80106746:	83 c4 10             	add    $0x10,%esp
80106749:	85 c0                	test   %eax,%eax
8010674b:	0f 88 86 00 00 00    	js     801067d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106751:	83 ec 0c             	sub    $0xc,%esp
80106754:	68 c0 76 11 80       	push   $0x801176c0
80106759:	e8 d2 ea ff ff       	call   80105230 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010675e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106761:	8b 1d 00 7f 11 80    	mov    0x80117f00,%ebx
  while (ticks - ticks0 < n)
80106767:	83 c4 10             	add    $0x10,%esp
8010676a:	85 d2                	test   %edx,%edx
8010676c:	75 23                	jne    80106791 <sys_sleep+0x61>
8010676e:	eb 50                	jmp    801067c0 <sys_sleep+0x90>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106770:	83 ec 08             	sub    $0x8,%esp
80106773:	68 c0 76 11 80       	push   $0x801176c0
80106778:	68 00 7f 11 80       	push   $0x80117f00
8010677d:	e8 be e2 ff ff       	call   80104a40 <sleep>
  while (ticks - ticks0 < n)
80106782:	a1 00 7f 11 80       	mov    0x80117f00,%eax
80106787:	83 c4 10             	add    $0x10,%esp
8010678a:	29 d8                	sub    %ebx,%eax
8010678c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010678f:	73 2f                	jae    801067c0 <sys_sleep+0x90>
    if (myproc()->killed)
80106791:	e8 9a d4 ff ff       	call   80103c30 <myproc>
80106796:	8b 40 30             	mov    0x30(%eax),%eax
80106799:	85 c0                	test   %eax,%eax
8010679b:	74 d3                	je     80106770 <sys_sleep+0x40>
      release(&tickslock);
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	68 c0 76 11 80       	push   $0x801176c0
801067a5:	e8 46 eb ff ff       	call   801052f0 <release>
  }
  release(&tickslock);
  return 0;
}
801067aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801067ad:	83 c4 10             	add    $0x10,%esp
801067b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067b5:	c9                   	leave  
801067b6:	c3                   	ret    
801067b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801067c0:	83 ec 0c             	sub    $0xc,%esp
801067c3:	68 c0 76 11 80       	push   $0x801176c0
801067c8:	e8 23 eb ff ff       	call   801052f0 <release>
  return 0;
801067cd:	83 c4 10             	add    $0x10,%esp
801067d0:	31 c0                	xor    %eax,%eax
}
801067d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067d5:	c9                   	leave  
801067d6:	c3                   	ret    
    return -1;
801067d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067dc:	eb f4                	jmp    801067d2 <sys_sleep+0xa2>
801067de:	66 90                	xchg   %ax,%ax

801067e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	53                   	push   %ebx
801067e8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801067eb:	68 c0 76 11 80       	push   $0x801176c0
801067f0:	e8 3b ea ff ff       	call   80105230 <acquire>
  xticks = ticks;
801067f5:	8b 1d 00 7f 11 80    	mov    0x80117f00,%ebx
  release(&tickslock);
801067fb:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
80106802:	e8 e9 ea ff ff       	call   801052f0 <release>
  return xticks;
}
80106807:	89 d8                	mov    %ebx,%eax
80106809:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010680c:	c9                   	leave  
8010680d:	c3                   	ret    
8010680e:	66 90                	xchg   %ax,%ax

80106810 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
80106810:	f3 0f 1e fb          	endbr32 
80106814:	55                   	push   %ebp
80106815:	89 e5                	mov    %esp,%ebp
80106817:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
8010681a:	e8 11 d4 ff ff       	call   80103c30 <myproc>
  return find_digital_root(number);
8010681f:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
80106822:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
80106825:	ff 70 10             	pushl  0x10(%eax)
80106828:	e8 b3 e6 ff ff       	call   80104ee0 <find_digital_root>
}
8010682d:	c9                   	leave  
8010682e:	c3                   	ret    
8010682f:	90                   	nop

80106830 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
80106830:	f3 0f 1e fb          	endbr32 
80106834:	55                   	push   %ebp
80106835:	89 e5                	mov    %esp,%ebp
80106837:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
8010683a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683d:	50                   	push   %eax
8010683e:	6a 00                	push   $0x0
80106840:	e8 1b ee ff ff       	call   80105660 <argint>
80106845:	83 c4 10             	add    $0x10,%esp
80106848:	85 c0                	test   %eax,%eax
8010684a:	78 24                	js     80106870 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
8010684c:	83 ec 0c             	sub    $0xc,%esp
8010684f:	ff 75 f4             	pushl  -0xc(%ebp)
80106852:	e8 c9 d5 ff ff       	call   80103e20 <find_proc>
  return count_child(grandFather) - 1;
80106857:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106858:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
8010685b:	ff 70 14             	pushl  0x14(%eax)
8010685e:	e8 4d da ff ff       	call   801042b0 <count_child>
80106863:	83 c4 10             	add    $0x10,%esp
}
80106866:	c9                   	leave  
  return count_child(grandFather) - 1;
80106867:	83 e8 01             	sub    $0x1,%eax
}
8010686a:	c3                   	ret    
8010686b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010686f:	90                   	nop
80106870:	c9                   	leave  
    return -1;
80106871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106876:	c3                   	ret    
80106877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010687e:	66 90                	xchg   %ax,%ax

80106880 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106880:	f3 0f 1e fb          	endbr32 
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106888:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010688b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010688e:	50                   	push   %eax
8010688f:	6a 00                	push   $0x0
80106891:	e8 ca ed ff ff       	call   80105660 <argint>
80106896:	83 c4 10             	add    $0x10,%esp
80106899:	85 c0                	test   %eax,%eax
8010689b:	78 23                	js     801068c0 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
8010689d:	83 ec 0c             	sub    $0xc,%esp
801068a0:	ff 75 f4             	pushl  -0xc(%ebp)
801068a3:	8b 1d 00 7f 11 80    	mov    0x80117f00,%ebx
801068a9:	e8 72 d5 ff ff       	call   80103e20 <find_proc>
801068ae:	83 c4 10             	add    $0x10,%esp
801068b1:	2b 58 20             	sub    0x20(%eax),%ebx
801068b4:	89 d8                	mov    %ebx,%eax
}
801068b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068b9:	c9                   	leave  
801068ba:	c3                   	ret    
801068bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068bf:	90                   	nop
    return -1;
801068c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c5:	eb ef                	jmp    801068b6 <sys_get_process_lifetime+0x36>
801068c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <sys_set_date>:
void sys_set_date(void)
{
801068d0:	f3 0f 1e fb          	endbr32 
801068d4:	55                   	push   %ebp
801068d5:	89 e5                	mov    %esp,%ebp
801068d7:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
801068da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068dd:	6a 18                	push   $0x18
801068df:	50                   	push   %eax
801068e0:	6a 00                	push   $0x0
801068e2:	e8 19 ee ff ff       	call   80105700 <argptr>
801068e7:	83 c4 10             	add    $0x10,%esp
801068ea:	85 c0                	test   %eax,%eax
801068ec:	78 12                	js     80106900 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	ff 75 f4             	pushl  -0xc(%ebp)
801068f4:	e8 97 c0 ff ff       	call   80102990 <cmostime>
}
801068f9:	83 c4 10             	add    $0x10,%esp
801068fc:	c9                   	leave  
801068fd:	c3                   	ret    
801068fe:	66 90                	xchg   %ax,%ax
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	68 54 8f 10 80       	push   $0x80108f54
80106908:	e8 a3 9d ff ff       	call   801006b0 <cprintf>
8010690d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
80106910:	83 ec 0c             	sub    $0xc,%esp
80106913:	ff 75 f4             	pushl  -0xc(%ebp)
80106916:	e8 75 c0 ff ff       	call   80102990 <cmostime>
}
8010691b:	83 c4 10             	add    $0x10,%esp
8010691e:	c9                   	leave  
8010691f:	c3                   	ret    

80106920 <sys_get_pid>:
80106920:	f3 0f 1e fb          	endbr32 
80106924:	e9 97 fd ff ff       	jmp    801066c0 <sys_getpid>
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
80106930:	f3 0f 1e fb          	endbr32 
80106934:	55                   	push   %ebp
80106935:	89 e5                	mov    %esp,%ebp
80106937:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
8010693a:	e8 f1 d2 ff ff       	call   80103c30 <myproc>
8010693f:	8b 40 14             	mov    0x14(%eax),%eax
80106942:	8b 40 10             	mov    0x10(%eax),%eax
}
80106945:	c9                   	leave  
80106946:	c3                   	ret    
80106947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694e:	66 90                	xchg   %ax,%ax

80106950 <sys_change_queue>:
int sys_change_queue(void)
{
80106950:	f3 0f 1e fb          	endbr32 
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
80106958:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
8010695b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
8010695e:	50                   	push   %eax
8010695f:	6a 00                	push   $0x0
80106961:	e8 fa ec ff ff       	call   80105660 <argint>
80106966:	83 c4 10             	add    $0x10,%esp
80106969:	85 c0                	test   %eax,%eax
8010696b:	78 43                	js     801069b0 <sys_change_queue+0x60>
8010696d:	83 ec 08             	sub    $0x8,%esp
80106970:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106973:	50                   	push   %eax
80106974:	6a 01                	push   $0x1
80106976:	e8 e5 ec ff ff       	call   80105660 <argint>
8010697b:	83 c4 10             	add    $0x10,%esp
8010697e:	89 c3                	mov    %eax,%ebx
80106980:	85 c0                	test   %eax,%eax
80106982:	75 2c                	jne    801069b0 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", que_id);
80106984:	83 ec 08             	sub    $0x8,%esp
80106987:	ff 75 f4             	pushl  -0xc(%ebp)
8010698a:	68 74 8b 10 80       	push   $0x80108b74
8010698f:	e8 1c 9d ff ff       	call   801006b0 <cprintf>
  struct proc *p = find_proc(pid);
80106994:	58                   	pop    %eax
80106995:	ff 75 f0             	pushl  -0x10(%ebp)
80106998:	e8 83 d4 ff ff       	call   80103e20 <find_proc>
  p->que_id = que_id;
8010699d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
801069a0:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
801069a3:	89 50 28             	mov    %edx,0x28(%eax)
}
801069a6:	89 d8                	mov    %ebx,%eax
801069a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069ab:	c9                   	leave  
801069ac:	c3                   	ret    
801069ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801069b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801069b5:	eb ef                	jmp    801069a6 <sys_change_queue+0x56>
801069b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069be:	66 90                	xchg   %ax,%ax

801069c0 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	83 ec 30             	sub    $0x30,%esp
  int pid;
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argint(1, &priority_ratio) < 0 || argint(2, &creation_time_ratio) < 0 || argint(3, &exec_cycle_ratio) < 0 || argint(4, &size_ratio) < 0)
801069ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069cd:	50                   	push   %eax
801069ce:	6a 00                	push   $0x0
801069d0:	e8 8b ec ff ff       	call   80105660 <argint>
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	85 c0                	test   %eax,%eax
801069da:	0f 88 90 00 00 00    	js     80106a70 <sys_bjf_validation_process+0xb0>
801069e0:	83 ec 08             	sub    $0x8,%esp
801069e3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069e6:	50                   	push   %eax
801069e7:	6a 01                	push   $0x1
801069e9:	e8 72 ec ff ff       	call   80105660 <argint>
801069ee:	83 c4 10             	add    $0x10,%esp
801069f1:	85 c0                	test   %eax,%eax
801069f3:	78 7b                	js     80106a70 <sys_bjf_validation_process+0xb0>
801069f5:	83 ec 08             	sub    $0x8,%esp
801069f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069fb:	50                   	push   %eax
801069fc:	6a 02                	push   $0x2
801069fe:	e8 5d ec ff ff       	call   80105660 <argint>
80106a03:	83 c4 10             	add    $0x10,%esp
80106a06:	85 c0                	test   %eax,%eax
80106a08:	78 66                	js     80106a70 <sys_bjf_validation_process+0xb0>
80106a0a:	83 ec 08             	sub    $0x8,%esp
80106a0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a10:	50                   	push   %eax
80106a11:	6a 03                	push   $0x3
80106a13:	e8 48 ec ff ff       	call   80105660 <argint>
80106a18:	83 c4 10             	add    $0x10,%esp
80106a1b:	85 c0                	test   %eax,%eax
80106a1d:	78 51                	js     80106a70 <sys_bjf_validation_process+0xb0>
80106a1f:	83 ec 08             	sub    $0x8,%esp
80106a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a25:	50                   	push   %eax
80106a26:	6a 04                	push   $0x4
80106a28:	e8 33 ec ff ff       	call   80105660 <argint>
80106a2d:	83 c4 10             	add    $0x10,%esp
80106a30:	85 c0                	test   %eax,%eax
80106a32:	78 3c                	js     80106a70 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
80106a34:	83 ec 0c             	sub    $0xc,%esp
80106a37:	ff 75 e4             	pushl  -0x1c(%ebp)
80106a3a:	e8 e1 d3 ff ff       	call   80103e20 <find_proc>
  p->priority_ratio = (float)priority_ratio;
80106a3f:	db 45 e8             	fildl  -0x18(%ebp)
  p->creation_time_ratio = (float)creation_time_ratio;
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
  p->process_size_ratio = (float)size_ratio;

  return 0;
80106a42:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = (float)priority_ratio;
80106a45:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = (float)creation_time_ratio;
80106a4b:	db 45 ec             	fildl  -0x14(%ebp)
80106a4e:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
80106a54:	db 45 f0             	fildl  -0x10(%ebp)
80106a57:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = (float)size_ratio;
80106a5d:	db 45 f4             	fildl  -0xc(%ebp)
80106a60:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
80106a66:	31 c0                	xor    %eax,%eax
}
80106a68:	c9                   	leave  
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a70:	c9                   	leave  
    return -1;
80106a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a76:	c3                   	ret    
80106a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7e:	66 90                	xchg   %ax,%ax

80106a80 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106a80:	f3 0f 1e fb          	endbr32 
80106a84:	55                   	push   %ebp
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &priority_ratio) < 0 || argint(1, &creation_time_ratio) < 0 || argint(2, &exec_cycle_ratio) < 0 || argint(3, &size_ratio) < 0)
80106a8a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106a8d:	50                   	push   %eax
80106a8e:	6a 00                	push   $0x0
80106a90:	e8 cb eb ff ff       	call   80105660 <argint>
80106a95:	83 c4 10             	add    $0x10,%esp
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	78 6c                	js     80106b08 <sys_bjf_validation_system+0x88>
80106a9c:	83 ec 08             	sub    $0x8,%esp
80106a9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106aa2:	50                   	push   %eax
80106aa3:	6a 01                	push   $0x1
80106aa5:	e8 b6 eb ff ff       	call   80105660 <argint>
80106aaa:	83 c4 10             	add    $0x10,%esp
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	78 57                	js     80106b08 <sys_bjf_validation_system+0x88>
80106ab1:	83 ec 08             	sub    $0x8,%esp
80106ab4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ab7:	50                   	push   %eax
80106ab8:	6a 02                	push   $0x2
80106aba:	e8 a1 eb ff ff       	call   80105660 <argint>
80106abf:	83 c4 10             	add    $0x10,%esp
80106ac2:	85 c0                	test   %eax,%eax
80106ac4:	78 42                	js     80106b08 <sys_bjf_validation_system+0x88>
80106ac6:	83 ec 08             	sub    $0x8,%esp
80106ac9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106acc:	50                   	push   %eax
80106acd:	6a 03                	push   $0x3
80106acf:	e8 8c eb ff ff       	call   80105660 <argint>
80106ad4:	83 c4 10             	add    $0x10,%esp
80106ad7:	85 c0                	test   %eax,%eax
80106ad9:	78 2d                	js     80106b08 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  reset_bjf_attributes((float)priority_ratio, (float)creation_time_ratio, (float)exec_cycle_ratio, (float)size_ratio);
80106adb:	db 45 f4             	fildl  -0xc(%ebp)
80106ade:	83 ec 10             	sub    $0x10,%esp
80106ae1:	d9 5c 24 0c          	fstps  0xc(%esp)
80106ae5:	db 45 f0             	fildl  -0x10(%ebp)
80106ae8:	d9 5c 24 08          	fstps  0x8(%esp)
80106aec:	db 45 ec             	fildl  -0x14(%ebp)
80106aef:	d9 5c 24 04          	fstps  0x4(%esp)
80106af3:	db 45 e8             	fildl  -0x18(%ebp)
80106af6:	d9 1c 24             	fstps  (%esp)
80106af9:	e8 a2 d0 ff ff       	call   80103ba0 <reset_bjf_attributes>
  return 0;
80106afe:	83 c4 10             	add    $0x10,%esp
80106b01:	31 c0                	xor    %eax,%eax
}
80106b03:	c9                   	leave  
80106b04:	c3                   	ret    
80106b05:	8d 76 00             	lea    0x0(%esi),%esi
80106b08:	c9                   	leave  
    return -1;
80106b09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b0e:	c3                   	ret    
80106b0f:	90                   	nop

80106b10 <sys_print_info>:
int sys_print_info(void)
{
80106b10:	f3 0f 1e fb          	endbr32 
80106b14:	55                   	push   %ebp
80106b15:	89 e5                	mov    %esp,%ebp
80106b17:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
80106b1a:	e8 31 d4 ff ff       	call   80103f50 <print_bitches>
  return 0;
}
80106b1f:	31 c0                	xor    %eax,%eax
80106b21:	c9                   	leave  
80106b22:	c3                   	ret    
80106b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <sys_print_lopck_que>:
int sys_print_lopck_que(void)
{
80106b30:	f3 0f 1e fb          	endbr32 
  return 0;
}
80106b34:	31 c0                	xor    %eax,%eax
80106b36:	c3                   	ret    
80106b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3e:	66 90                	xchg   %ax,%ax

80106b40 <sys_plock_test>:
int sys_plock_test(void)
{
80106b40:	f3 0f 1e fb          	endbr32 
80106b44:	55                   	push   %ebp
80106b45:	89 e5                	mov    %esp,%ebp
80106b47:	83 ec 08             	sub    $0x8,%esp
  siktir();
80106b4a:	e8 e1 e3 ff ff       	call   80104f30 <siktir>
  return 0 ;
}
80106b4f:	31 c0                	xor    %eax,%eax
80106b51:	c9                   	leave  
80106b52:	c3                   	ret    
80106b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b60 <sys_open_shm>:
int sys_open_shm(void)
{
80106b60:	f3 0f 1e fb          	endbr32 
80106b64:	55                   	push   %ebp
80106b65:	89 e5                	mov    %esp,%ebp
80106b67:	83 ec 20             	sub    $0x20,%esp
  int id ; 
  if(argint(0 , &id)<0)
80106b6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b6d:	50                   	push   %eax
80106b6e:	6a 00                	push   $0x0
80106b70:	e8 eb ea ff ff       	call   80105660 <argint>
80106b75:	83 c4 10             	add    $0x10,%esp
80106b78:	85 c0                	test   %eax,%eax
80106b7a:	78 14                	js     80106b90 <sys_open_shm+0x30>
  {
    return -1;
  }
  open_shared_memory(id);
80106b7c:	83 ec 0c             	sub    $0xc,%esp
80106b7f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b82:	e8 39 19 00 00       	call   801084c0 <open_shared_memory>
  return 0;
80106b87:	83 c4 10             	add    $0x10,%esp
80106b8a:	31 c0                	xor    %eax,%eax
80106b8c:	c9                   	leave  
80106b8d:	c3                   	ret    
80106b8e:	66 90                	xchg   %ax,%ax
80106b90:	c9                   	leave  
    return -1;
80106b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b96:	c3                   	ret    

80106b97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106b97:	1e                   	push   %ds
  pushl %es
80106b98:	06                   	push   %es
  pushl %fs
80106b99:	0f a0                	push   %fs
  pushl %gs
80106b9b:	0f a8                	push   %gs
  pushal
80106b9d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106b9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106ba2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106ba4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106ba6:	54                   	push   %esp
  call trap
80106ba7:	e8 c4 00 00 00       	call   80106c70 <trap>
  addl $4, %esp
80106bac:	83 c4 04             	add    $0x4,%esp

80106baf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106baf:	61                   	popa   
  popl %gs
80106bb0:	0f a9                	pop    %gs
  popl %fs
80106bb2:	0f a1                	pop    %fs
  popl %es
80106bb4:	07                   	pop    %es
  popl %ds
80106bb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106bb6:	83 c4 08             	add    $0x8,%esp
  iret
80106bb9:	cf                   	iret   
80106bba:	66 90                	xchg   %ax,%ax
80106bbc:	66 90                	xchg   %ax,%ax
80106bbe:	66 90                	xchg   %ax,%ax

80106bc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106bc0:	f3 0f 1e fb          	endbr32 
80106bc4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106bc5:	31 c0                	xor    %eax,%eax
{
80106bc7:	89 e5                	mov    %esp,%ebp
80106bc9:	83 ec 08             	sub    $0x8,%esp
80106bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106bd0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106bd7:	c7 04 c5 02 77 11 80 	movl   $0x8e000008,-0x7fee88fe(,%eax,8)
80106bde:	08 00 00 8e 
80106be2:	66 89 14 c5 00 77 11 	mov    %dx,-0x7fee8900(,%eax,8)
80106be9:	80 
80106bea:	c1 ea 10             	shr    $0x10,%edx
80106bed:	66 89 14 c5 06 77 11 	mov    %dx,-0x7fee88fa(,%eax,8)
80106bf4:	80 
  for(i = 0; i < 256; i++)
80106bf5:	83 c0 01             	add    $0x1,%eax
80106bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106bfd:	75 d1                	jne    80106bd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106bff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c02:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106c07:	c7 05 02 79 11 80 08 	movl   $0xef000008,0x80117902
80106c0e:	00 00 ef 
  initlock(&tickslock, "time");
80106c11:	68 7b 8f 10 80       	push   $0x80108f7b
80106c16:	68 c0 76 11 80       	push   $0x801176c0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c1b:	66 a3 00 79 11 80    	mov    %ax,0x80117900
80106c21:	c1 e8 10             	shr    $0x10,%eax
80106c24:	66 a3 06 79 11 80    	mov    %ax,0x80117906
  initlock(&tickslock, "time");
80106c2a:	e8 81 e4 ff ff       	call   801050b0 <initlock>
}
80106c2f:	83 c4 10             	add    $0x10,%esp
80106c32:	c9                   	leave  
80106c33:	c3                   	ret    
80106c34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c3f:	90                   	nop

80106c40 <idtinit>:

void
idtinit(void)
{
80106c40:	f3 0f 1e fb          	endbr32 
80106c44:	55                   	push   %ebp
  pd[0] = size-1;
80106c45:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106c4a:	89 e5                	mov    %esp,%ebp
80106c4c:	83 ec 10             	sub    $0x10,%esp
80106c4f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c53:	b8 00 77 11 80       	mov    $0x80117700,%eax
80106c58:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c5c:	c1 e8 10             	shr    $0x10,%eax
80106c5f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106c63:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c66:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106c69:	c9                   	leave  
80106c6a:	c3                   	ret    
80106c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c6f:	90                   	nop

80106c70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c70:	f3 0f 1e fb          	endbr32 
80106c74:	55                   	push   %ebp
80106c75:	89 e5                	mov    %esp,%ebp
80106c77:	57                   	push   %edi
80106c78:	56                   	push   %esi
80106c79:	53                   	push   %ebx
80106c7a:	83 ec 1c             	sub    $0x1c,%esp
80106c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106c80:	8b 43 30             	mov    0x30(%ebx),%eax
80106c83:	83 f8 40             	cmp    $0x40,%eax
80106c86:	0f 84 c4 01 00 00    	je     80106e50 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106c8c:	83 e8 20             	sub    $0x20,%eax
80106c8f:	83 f8 1f             	cmp    $0x1f,%eax
80106c92:	77 08                	ja     80106c9c <trap+0x2c>
80106c94:	3e ff 24 85 24 90 10 	notrack jmp *-0x7fef6fdc(,%eax,4)
80106c9b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106c9c:	e8 8f cf ff ff       	call   80103c30 <myproc>
80106ca1:	8b 7b 38             	mov    0x38(%ebx),%edi
80106ca4:	85 c0                	test   %eax,%eax
80106ca6:	0f 84 f3 01 00 00    	je     80106e9f <trap+0x22f>
80106cac:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106cb0:	0f 84 e9 01 00 00    	je     80106e9f <trap+0x22f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106cb6:	0f 20 d1             	mov    %cr2,%ecx
80106cb9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cbc:	e8 5f ce ff ff       	call   80103b20 <cpuid>
80106cc1:	8b 73 30             	mov    0x30(%ebx),%esi
80106cc4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cc7:	8b 43 34             	mov    0x34(%ebx),%eax
80106cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106ccd:	e8 5e cf ff ff       	call   80103c30 <myproc>
80106cd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cd5:	e8 56 cf ff ff       	call   80103c30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cda:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106cdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106ce0:	51                   	push   %ecx
80106ce1:	57                   	push   %edi
80106ce2:	52                   	push   %edx
80106ce3:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ce6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106ce7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106cea:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ced:	56                   	push   %esi
80106cee:	ff 70 10             	pushl  0x10(%eax)
80106cf1:	68 e0 8f 10 80       	push   $0x80108fe0
80106cf6:	e8 b5 99 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106cfb:	83 c4 20             	add    $0x20,%esp
80106cfe:	e8 2d cf ff ff       	call   80103c30 <myproc>
80106d03:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d0a:	e8 21 cf ff ff       	call   80103c30 <myproc>
80106d0f:	85 c0                	test   %eax,%eax
80106d11:	74 1d                	je     80106d30 <trap+0xc0>
80106d13:	e8 18 cf ff ff       	call   80103c30 <myproc>
80106d18:	8b 50 30             	mov    0x30(%eax),%edx
80106d1b:	85 d2                	test   %edx,%edx
80106d1d:	74 11                	je     80106d30 <trap+0xc0>
80106d1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106d23:	83 e0 03             	and    $0x3,%eax
80106d26:	66 83 f8 03          	cmp    $0x3,%ax
80106d2a:	0f 84 58 01 00 00    	je     80106e88 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106d30:	e8 fb ce ff ff       	call   80103c30 <myproc>
80106d35:	85 c0                	test   %eax,%eax
80106d37:	74 0f                	je     80106d48 <trap+0xd8>
80106d39:	e8 f2 ce ff ff       	call   80103c30 <myproc>
80106d3e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106d42:	0f 84 f0 00 00 00    	je     80106e38 <trap+0x1c8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d48:	e8 e3 ce ff ff       	call   80103c30 <myproc>
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	74 1d                	je     80106d6e <trap+0xfe>
80106d51:	e8 da ce ff ff       	call   80103c30 <myproc>
80106d56:	8b 40 30             	mov    0x30(%eax),%eax
80106d59:	85 c0                	test   %eax,%eax
80106d5b:	74 11                	je     80106d6e <trap+0xfe>
80106d5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106d61:	83 e0 03             	and    $0x3,%eax
80106d64:	66 83 f8 03          	cmp    $0x3,%ax
80106d68:	0f 84 0b 01 00 00    	je     80106e79 <trap+0x209>
    exit();
}
80106d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d71:	5b                   	pop    %ebx
80106d72:	5e                   	pop    %esi
80106d73:	5f                   	pop    %edi
80106d74:	5d                   	pop    %ebp
80106d75:	c3                   	ret    
    ideintr();
80106d76:	e8 65 b4 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80106d7b:	e8 40 bb ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d80:	e8 ab ce ff ff       	call   80103c30 <myproc>
80106d85:	85 c0                	test   %eax,%eax
80106d87:	75 8a                	jne    80106d13 <trap+0xa3>
80106d89:	eb a5                	jmp    80106d30 <trap+0xc0>
    if(cpuid() == 0){
80106d8b:	e8 90 cd ff ff       	call   80103b20 <cpuid>
80106d90:	85 c0                	test   %eax,%eax
80106d92:	75 e7                	jne    80106d7b <trap+0x10b>
      acquire(&tickslock);
80106d94:	83 ec 0c             	sub    $0xc,%esp
80106d97:	68 c0 76 11 80       	push   $0x801176c0
80106d9c:	e8 8f e4 ff ff       	call   80105230 <acquire>
      wakeup(&ticks);
80106da1:	c7 04 24 00 7f 11 80 	movl   $0x80117f00,(%esp)
      ticks++;
80106da8:	83 05 00 7f 11 80 01 	addl   $0x1,0x80117f00
      wakeup(&ticks);
80106daf:	e8 4c de ff ff       	call   80104c00 <wakeup>
      release(&tickslock);
80106db4:	c7 04 24 c0 76 11 80 	movl   $0x801176c0,(%esp)
80106dbb:	e8 30 e5 ff ff       	call   801052f0 <release>
      aging();
80106dc0:	e8 7b cd ff ff       	call   80103b40 <aging>
80106dc5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106dc8:	eb b1                	jmp    80106d7b <trap+0x10b>
    kbdintr();
80106dca:	e8 b1 b9 ff ff       	call   80102780 <kbdintr>
    lapiceoi();
80106dcf:	e8 ec ba ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dd4:	e8 57 ce ff ff       	call   80103c30 <myproc>
80106dd9:	85 c0                	test   %eax,%eax
80106ddb:	0f 85 32 ff ff ff    	jne    80106d13 <trap+0xa3>
80106de1:	e9 4a ff ff ff       	jmp    80106d30 <trap+0xc0>
    uartintr();
80106de6:	e8 55 02 00 00       	call   80107040 <uartintr>
    lapiceoi();
80106deb:	e8 d0 ba ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106df0:	e8 3b ce ff ff       	call   80103c30 <myproc>
80106df5:	85 c0                	test   %eax,%eax
80106df7:	0f 85 16 ff ff ff    	jne    80106d13 <trap+0xa3>
80106dfd:	e9 2e ff ff ff       	jmp    80106d30 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106e02:	8b 7b 38             	mov    0x38(%ebx),%edi
80106e05:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106e09:	e8 12 cd ff ff       	call   80103b20 <cpuid>
80106e0e:	57                   	push   %edi
80106e0f:	56                   	push   %esi
80106e10:	50                   	push   %eax
80106e11:	68 88 8f 10 80       	push   $0x80108f88
80106e16:	e8 95 98 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106e1b:	e8 a0 ba ff ff       	call   801028c0 <lapiceoi>
    break;
80106e20:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e23:	e8 08 ce ff ff       	call   80103c30 <myproc>
80106e28:	85 c0                	test   %eax,%eax
80106e2a:	0f 85 e3 fe ff ff    	jne    80106d13 <trap+0xa3>
80106e30:	e9 fb fe ff ff       	jmp    80106d30 <trap+0xc0>
80106e35:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106e38:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106e3c:	0f 85 06 ff ff ff    	jne    80106d48 <trap+0xd8>
    yield();
80106e42:	e8 59 db ff ff       	call   801049a0 <yield>
80106e47:	e9 fc fe ff ff       	jmp    80106d48 <trap+0xd8>
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106e50:	e8 db cd ff ff       	call   80103c30 <myproc>
80106e55:	8b 70 30             	mov    0x30(%eax),%esi
80106e58:	85 f6                	test   %esi,%esi
80106e5a:	75 3c                	jne    80106e98 <trap+0x228>
    myproc()->tf = tf;
80106e5c:	e8 cf cd ff ff       	call   80103c30 <myproc>
80106e61:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106e64:	e8 37 e9 ff ff       	call   801057a0 <syscall>
    if(myproc()->killed)
80106e69:	e8 c2 cd ff ff       	call   80103c30 <myproc>
80106e6e:	8b 48 30             	mov    0x30(%eax),%ecx
80106e71:	85 c9                	test   %ecx,%ecx
80106e73:	0f 84 f5 fe ff ff    	je     80106d6e <trap+0xfe>
}
80106e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7c:	5b                   	pop    %ebx
80106e7d:	5e                   	pop    %esi
80106e7e:	5f                   	pop    %edi
80106e7f:	5d                   	pop    %ebp
      exit();
80106e80:	e9 db d9 ff ff       	jmp    80104860 <exit>
80106e85:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106e88:	e8 d3 d9 ff ff       	call   80104860 <exit>
80106e8d:	e9 9e fe ff ff       	jmp    80106d30 <trap+0xc0>
80106e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106e98:	e8 c3 d9 ff ff       	call   80104860 <exit>
80106e9d:	eb bd                	jmp    80106e5c <trap+0x1ec>
80106e9f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ea2:	e8 79 cc ff ff       	call   80103b20 <cpuid>
80106ea7:	83 ec 0c             	sub    $0xc,%esp
80106eaa:	56                   	push   %esi
80106eab:	57                   	push   %edi
80106eac:	50                   	push   %eax
80106ead:	ff 73 30             	pushl  0x30(%ebx)
80106eb0:	68 ac 8f 10 80       	push   $0x80108fac
80106eb5:	e8 f6 97 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106eba:	83 c4 14             	add    $0x14,%esp
80106ebd:	68 80 8f 10 80       	push   $0x80108f80
80106ec2:	e8 c9 94 ff ff       	call   80100390 <panic>
80106ec7:	66 90                	xchg   %ax,%ax
80106ec9:	66 90                	xchg   %ax,%ax
80106ecb:	66 90                	xchg   %ax,%ax
80106ecd:	66 90                	xchg   %ax,%ax
80106ecf:	90                   	nop

80106ed0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106ed0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106ed4:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80106ed9:	85 c0                	test   %eax,%eax
80106edb:	74 1b                	je     80106ef8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106edd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ee2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106ee3:	a8 01                	test   $0x1,%al
80106ee5:	74 11                	je     80106ef8 <uartgetc+0x28>
80106ee7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106eec:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106eed:	0f b6 c0             	movzbl %al,%eax
80106ef0:	c3                   	ret    
80106ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106efd:	c3                   	ret    
80106efe:	66 90                	xchg   %ax,%ax

80106f00 <uartputc.part.0>:
uartputc(int c)
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	89 c7                	mov    %eax,%edi
80106f06:	56                   	push   %esi
80106f07:	be fd 03 00 00       	mov    $0x3fd,%esi
80106f0c:	53                   	push   %ebx
80106f0d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f12:	83 ec 0c             	sub    $0xc,%esp
80106f15:	eb 1b                	jmp    80106f32 <uartputc.part.0+0x32>
80106f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	6a 0a                	push   $0xa
80106f25:	e8 b6 b9 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f2a:	83 c4 10             	add    $0x10,%esp
80106f2d:	83 eb 01             	sub    $0x1,%ebx
80106f30:	74 07                	je     80106f39 <uartputc.part.0+0x39>
80106f32:	89 f2                	mov    %esi,%edx
80106f34:	ec                   	in     (%dx),%al
80106f35:	a8 20                	test   $0x20,%al
80106f37:	74 e7                	je     80106f20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f3e:	89 f8                	mov    %edi,%eax
80106f40:	ee                   	out    %al,(%dx)
}
80106f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f44:	5b                   	pop    %ebx
80106f45:	5e                   	pop    %esi
80106f46:	5f                   	pop    %edi
80106f47:	5d                   	pop    %ebp
80106f48:	c3                   	ret    
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <uartinit>:
{
80106f50:	f3 0f 1e fb          	endbr32 
80106f54:	55                   	push   %ebp
80106f55:	31 c9                	xor    %ecx,%ecx
80106f57:	89 c8                	mov    %ecx,%eax
80106f59:	89 e5                	mov    %esp,%ebp
80106f5b:	57                   	push   %edi
80106f5c:	56                   	push   %esi
80106f5d:	53                   	push   %ebx
80106f5e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106f63:	89 da                	mov    %ebx,%edx
80106f65:	83 ec 0c             	sub    $0xc,%esp
80106f68:	ee                   	out    %al,(%dx)
80106f69:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106f6e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106f73:	89 fa                	mov    %edi,%edx
80106f75:	ee                   	out    %al,(%dx)
80106f76:	b8 0c 00 00 00       	mov    $0xc,%eax
80106f7b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f80:	ee                   	out    %al,(%dx)
80106f81:	be f9 03 00 00       	mov    $0x3f9,%esi
80106f86:	89 c8                	mov    %ecx,%eax
80106f88:	89 f2                	mov    %esi,%edx
80106f8a:	ee                   	out    %al,(%dx)
80106f8b:	b8 03 00 00 00       	mov    $0x3,%eax
80106f90:	89 fa                	mov    %edi,%edx
80106f92:	ee                   	out    %al,(%dx)
80106f93:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106f98:	89 c8                	mov    %ecx,%eax
80106f9a:	ee                   	out    %al,(%dx)
80106f9b:	b8 01 00 00 00       	mov    $0x1,%eax
80106fa0:	89 f2                	mov    %esi,%edx
80106fa2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106fa3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106fa8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106fa9:	3c ff                	cmp    $0xff,%al
80106fab:	74 52                	je     80106fff <uartinit+0xaf>
  uart = 1;
80106fad:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106fb4:	00 00 00 
80106fb7:	89 da                	mov    %ebx,%edx
80106fb9:	ec                   	in     (%dx),%al
80106fba:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fbf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106fc0:	83 ec 08             	sub    $0x8,%esp
80106fc3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106fc8:	bb a4 90 10 80       	mov    $0x801090a4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106fcd:	6a 00                	push   $0x0
80106fcf:	6a 04                	push   $0x4
80106fd1:	e8 5a b4 ff ff       	call   80102430 <ioapicenable>
80106fd6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106fd9:	b8 78 00 00 00       	mov    $0x78,%eax
80106fde:	eb 04                	jmp    80106fe4 <uartinit+0x94>
80106fe0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106fe4:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
80106fea:	85 d2                	test   %edx,%edx
80106fec:	74 08                	je     80106ff6 <uartinit+0xa6>
    uartputc(*p);
80106fee:	0f be c0             	movsbl %al,%eax
80106ff1:	e8 0a ff ff ff       	call   80106f00 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106ff6:	89 f0                	mov    %esi,%eax
80106ff8:	83 c3 01             	add    $0x1,%ebx
80106ffb:	84 c0                	test   %al,%al
80106ffd:	75 e1                	jne    80106fe0 <uartinit+0x90>
}
80106fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107002:	5b                   	pop    %ebx
80107003:	5e                   	pop    %esi
80107004:	5f                   	pop    %edi
80107005:	5d                   	pop    %ebp
80107006:	c3                   	ret    
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <uartputc>:
{
80107010:	f3 0f 1e fb          	endbr32 
80107014:	55                   	push   %ebp
  if(!uart)
80107015:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
{
8010701b:	89 e5                	mov    %esp,%ebp
8010701d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80107020:	85 d2                	test   %edx,%edx
80107022:	74 0c                	je     80107030 <uartputc+0x20>
}
80107024:	5d                   	pop    %ebp
80107025:	e9 d6 fe ff ff       	jmp    80106f00 <uartputc.part.0>
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107030:	5d                   	pop    %ebp
80107031:	c3                   	ret    
80107032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107040 <uartintr>:

void
uartintr(void)
{
80107040:	f3 0f 1e fb          	endbr32 
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010704a:	68 d0 6e 10 80       	push   $0x80106ed0
8010704f:	e8 0c 98 ff ff       	call   80100860 <consoleintr>
}
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	c9                   	leave  
80107058:	c3                   	ret    

80107059 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $0
8010705b:	6a 00                	push   $0x0
  jmp alltraps
8010705d:	e9 35 fb ff ff       	jmp    80106b97 <alltraps>

80107062 <vector1>:
.globl vector1
vector1:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $1
80107064:	6a 01                	push   $0x1
  jmp alltraps
80107066:	e9 2c fb ff ff       	jmp    80106b97 <alltraps>

8010706b <vector2>:
.globl vector2
vector2:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $2
8010706d:	6a 02                	push   $0x2
  jmp alltraps
8010706f:	e9 23 fb ff ff       	jmp    80106b97 <alltraps>

80107074 <vector3>:
.globl vector3
vector3:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $3
80107076:	6a 03                	push   $0x3
  jmp alltraps
80107078:	e9 1a fb ff ff       	jmp    80106b97 <alltraps>

8010707d <vector4>:
.globl vector4
vector4:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $4
8010707f:	6a 04                	push   $0x4
  jmp alltraps
80107081:	e9 11 fb ff ff       	jmp    80106b97 <alltraps>

80107086 <vector5>:
.globl vector5
vector5:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $5
80107088:	6a 05                	push   $0x5
  jmp alltraps
8010708a:	e9 08 fb ff ff       	jmp    80106b97 <alltraps>

8010708f <vector6>:
.globl vector6
vector6:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $6
80107091:	6a 06                	push   $0x6
  jmp alltraps
80107093:	e9 ff fa ff ff       	jmp    80106b97 <alltraps>

80107098 <vector7>:
.globl vector7
vector7:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $7
8010709a:	6a 07                	push   $0x7
  jmp alltraps
8010709c:	e9 f6 fa ff ff       	jmp    80106b97 <alltraps>

801070a1 <vector8>:
.globl vector8
vector8:
  pushl $8
801070a1:	6a 08                	push   $0x8
  jmp alltraps
801070a3:	e9 ef fa ff ff       	jmp    80106b97 <alltraps>

801070a8 <vector9>:
.globl vector9
vector9:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $9
801070aa:	6a 09                	push   $0x9
  jmp alltraps
801070ac:	e9 e6 fa ff ff       	jmp    80106b97 <alltraps>

801070b1 <vector10>:
.globl vector10
vector10:
  pushl $10
801070b1:	6a 0a                	push   $0xa
  jmp alltraps
801070b3:	e9 df fa ff ff       	jmp    80106b97 <alltraps>

801070b8 <vector11>:
.globl vector11
vector11:
  pushl $11
801070b8:	6a 0b                	push   $0xb
  jmp alltraps
801070ba:	e9 d8 fa ff ff       	jmp    80106b97 <alltraps>

801070bf <vector12>:
.globl vector12
vector12:
  pushl $12
801070bf:	6a 0c                	push   $0xc
  jmp alltraps
801070c1:	e9 d1 fa ff ff       	jmp    80106b97 <alltraps>

801070c6 <vector13>:
.globl vector13
vector13:
  pushl $13
801070c6:	6a 0d                	push   $0xd
  jmp alltraps
801070c8:	e9 ca fa ff ff       	jmp    80106b97 <alltraps>

801070cd <vector14>:
.globl vector14
vector14:
  pushl $14
801070cd:	6a 0e                	push   $0xe
  jmp alltraps
801070cf:	e9 c3 fa ff ff       	jmp    80106b97 <alltraps>

801070d4 <vector15>:
.globl vector15
vector15:
  pushl $0
801070d4:	6a 00                	push   $0x0
  pushl $15
801070d6:	6a 0f                	push   $0xf
  jmp alltraps
801070d8:	e9 ba fa ff ff       	jmp    80106b97 <alltraps>

801070dd <vector16>:
.globl vector16
vector16:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $16
801070df:	6a 10                	push   $0x10
  jmp alltraps
801070e1:	e9 b1 fa ff ff       	jmp    80106b97 <alltraps>

801070e6 <vector17>:
.globl vector17
vector17:
  pushl $17
801070e6:	6a 11                	push   $0x11
  jmp alltraps
801070e8:	e9 aa fa ff ff       	jmp    80106b97 <alltraps>

801070ed <vector18>:
.globl vector18
vector18:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $18
801070ef:	6a 12                	push   $0x12
  jmp alltraps
801070f1:	e9 a1 fa ff ff       	jmp    80106b97 <alltraps>

801070f6 <vector19>:
.globl vector19
vector19:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $19
801070f8:	6a 13                	push   $0x13
  jmp alltraps
801070fa:	e9 98 fa ff ff       	jmp    80106b97 <alltraps>

801070ff <vector20>:
.globl vector20
vector20:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $20
80107101:	6a 14                	push   $0x14
  jmp alltraps
80107103:	e9 8f fa ff ff       	jmp    80106b97 <alltraps>

80107108 <vector21>:
.globl vector21
vector21:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $21
8010710a:	6a 15                	push   $0x15
  jmp alltraps
8010710c:	e9 86 fa ff ff       	jmp    80106b97 <alltraps>

80107111 <vector22>:
.globl vector22
vector22:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $22
80107113:	6a 16                	push   $0x16
  jmp alltraps
80107115:	e9 7d fa ff ff       	jmp    80106b97 <alltraps>

8010711a <vector23>:
.globl vector23
vector23:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $23
8010711c:	6a 17                	push   $0x17
  jmp alltraps
8010711e:	e9 74 fa ff ff       	jmp    80106b97 <alltraps>

80107123 <vector24>:
.globl vector24
vector24:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $24
80107125:	6a 18                	push   $0x18
  jmp alltraps
80107127:	e9 6b fa ff ff       	jmp    80106b97 <alltraps>

8010712c <vector25>:
.globl vector25
vector25:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $25
8010712e:	6a 19                	push   $0x19
  jmp alltraps
80107130:	e9 62 fa ff ff       	jmp    80106b97 <alltraps>

80107135 <vector26>:
.globl vector26
vector26:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $26
80107137:	6a 1a                	push   $0x1a
  jmp alltraps
80107139:	e9 59 fa ff ff       	jmp    80106b97 <alltraps>

8010713e <vector27>:
.globl vector27
vector27:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $27
80107140:	6a 1b                	push   $0x1b
  jmp alltraps
80107142:	e9 50 fa ff ff       	jmp    80106b97 <alltraps>

80107147 <vector28>:
.globl vector28
vector28:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $28
80107149:	6a 1c                	push   $0x1c
  jmp alltraps
8010714b:	e9 47 fa ff ff       	jmp    80106b97 <alltraps>

80107150 <vector29>:
.globl vector29
vector29:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $29
80107152:	6a 1d                	push   $0x1d
  jmp alltraps
80107154:	e9 3e fa ff ff       	jmp    80106b97 <alltraps>

80107159 <vector30>:
.globl vector30
vector30:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $30
8010715b:	6a 1e                	push   $0x1e
  jmp alltraps
8010715d:	e9 35 fa ff ff       	jmp    80106b97 <alltraps>

80107162 <vector31>:
.globl vector31
vector31:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $31
80107164:	6a 1f                	push   $0x1f
  jmp alltraps
80107166:	e9 2c fa ff ff       	jmp    80106b97 <alltraps>

8010716b <vector32>:
.globl vector32
vector32:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $32
8010716d:	6a 20                	push   $0x20
  jmp alltraps
8010716f:	e9 23 fa ff ff       	jmp    80106b97 <alltraps>

80107174 <vector33>:
.globl vector33
vector33:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $33
80107176:	6a 21                	push   $0x21
  jmp alltraps
80107178:	e9 1a fa ff ff       	jmp    80106b97 <alltraps>

8010717d <vector34>:
.globl vector34
vector34:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $34
8010717f:	6a 22                	push   $0x22
  jmp alltraps
80107181:	e9 11 fa ff ff       	jmp    80106b97 <alltraps>

80107186 <vector35>:
.globl vector35
vector35:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $35
80107188:	6a 23                	push   $0x23
  jmp alltraps
8010718a:	e9 08 fa ff ff       	jmp    80106b97 <alltraps>

8010718f <vector36>:
.globl vector36
vector36:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $36
80107191:	6a 24                	push   $0x24
  jmp alltraps
80107193:	e9 ff f9 ff ff       	jmp    80106b97 <alltraps>

80107198 <vector37>:
.globl vector37
vector37:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $37
8010719a:	6a 25                	push   $0x25
  jmp alltraps
8010719c:	e9 f6 f9 ff ff       	jmp    80106b97 <alltraps>

801071a1 <vector38>:
.globl vector38
vector38:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $38
801071a3:	6a 26                	push   $0x26
  jmp alltraps
801071a5:	e9 ed f9 ff ff       	jmp    80106b97 <alltraps>

801071aa <vector39>:
.globl vector39
vector39:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $39
801071ac:	6a 27                	push   $0x27
  jmp alltraps
801071ae:	e9 e4 f9 ff ff       	jmp    80106b97 <alltraps>

801071b3 <vector40>:
.globl vector40
vector40:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $40
801071b5:	6a 28                	push   $0x28
  jmp alltraps
801071b7:	e9 db f9 ff ff       	jmp    80106b97 <alltraps>

801071bc <vector41>:
.globl vector41
vector41:
  pushl $0
801071bc:	6a 00                	push   $0x0
  pushl $41
801071be:	6a 29                	push   $0x29
  jmp alltraps
801071c0:	e9 d2 f9 ff ff       	jmp    80106b97 <alltraps>

801071c5 <vector42>:
.globl vector42
vector42:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $42
801071c7:	6a 2a                	push   $0x2a
  jmp alltraps
801071c9:	e9 c9 f9 ff ff       	jmp    80106b97 <alltraps>

801071ce <vector43>:
.globl vector43
vector43:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $43
801071d0:	6a 2b                	push   $0x2b
  jmp alltraps
801071d2:	e9 c0 f9 ff ff       	jmp    80106b97 <alltraps>

801071d7 <vector44>:
.globl vector44
vector44:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $44
801071d9:	6a 2c                	push   $0x2c
  jmp alltraps
801071db:	e9 b7 f9 ff ff       	jmp    80106b97 <alltraps>

801071e0 <vector45>:
.globl vector45
vector45:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $45
801071e2:	6a 2d                	push   $0x2d
  jmp alltraps
801071e4:	e9 ae f9 ff ff       	jmp    80106b97 <alltraps>

801071e9 <vector46>:
.globl vector46
vector46:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $46
801071eb:	6a 2e                	push   $0x2e
  jmp alltraps
801071ed:	e9 a5 f9 ff ff       	jmp    80106b97 <alltraps>

801071f2 <vector47>:
.globl vector47
vector47:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $47
801071f4:	6a 2f                	push   $0x2f
  jmp alltraps
801071f6:	e9 9c f9 ff ff       	jmp    80106b97 <alltraps>

801071fb <vector48>:
.globl vector48
vector48:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $48
801071fd:	6a 30                	push   $0x30
  jmp alltraps
801071ff:	e9 93 f9 ff ff       	jmp    80106b97 <alltraps>

80107204 <vector49>:
.globl vector49
vector49:
  pushl $0
80107204:	6a 00                	push   $0x0
  pushl $49
80107206:	6a 31                	push   $0x31
  jmp alltraps
80107208:	e9 8a f9 ff ff       	jmp    80106b97 <alltraps>

8010720d <vector50>:
.globl vector50
vector50:
  pushl $0
8010720d:	6a 00                	push   $0x0
  pushl $50
8010720f:	6a 32                	push   $0x32
  jmp alltraps
80107211:	e9 81 f9 ff ff       	jmp    80106b97 <alltraps>

80107216 <vector51>:
.globl vector51
vector51:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $51
80107218:	6a 33                	push   $0x33
  jmp alltraps
8010721a:	e9 78 f9 ff ff       	jmp    80106b97 <alltraps>

8010721f <vector52>:
.globl vector52
vector52:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $52
80107221:	6a 34                	push   $0x34
  jmp alltraps
80107223:	e9 6f f9 ff ff       	jmp    80106b97 <alltraps>

80107228 <vector53>:
.globl vector53
vector53:
  pushl $0
80107228:	6a 00                	push   $0x0
  pushl $53
8010722a:	6a 35                	push   $0x35
  jmp alltraps
8010722c:	e9 66 f9 ff ff       	jmp    80106b97 <alltraps>

80107231 <vector54>:
.globl vector54
vector54:
  pushl $0
80107231:	6a 00                	push   $0x0
  pushl $54
80107233:	6a 36                	push   $0x36
  jmp alltraps
80107235:	e9 5d f9 ff ff       	jmp    80106b97 <alltraps>

8010723a <vector55>:
.globl vector55
vector55:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $55
8010723c:	6a 37                	push   $0x37
  jmp alltraps
8010723e:	e9 54 f9 ff ff       	jmp    80106b97 <alltraps>

80107243 <vector56>:
.globl vector56
vector56:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $56
80107245:	6a 38                	push   $0x38
  jmp alltraps
80107247:	e9 4b f9 ff ff       	jmp    80106b97 <alltraps>

8010724c <vector57>:
.globl vector57
vector57:
  pushl $0
8010724c:	6a 00                	push   $0x0
  pushl $57
8010724e:	6a 39                	push   $0x39
  jmp alltraps
80107250:	e9 42 f9 ff ff       	jmp    80106b97 <alltraps>

80107255 <vector58>:
.globl vector58
vector58:
  pushl $0
80107255:	6a 00                	push   $0x0
  pushl $58
80107257:	6a 3a                	push   $0x3a
  jmp alltraps
80107259:	e9 39 f9 ff ff       	jmp    80106b97 <alltraps>

8010725e <vector59>:
.globl vector59
vector59:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $59
80107260:	6a 3b                	push   $0x3b
  jmp alltraps
80107262:	e9 30 f9 ff ff       	jmp    80106b97 <alltraps>

80107267 <vector60>:
.globl vector60
vector60:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $60
80107269:	6a 3c                	push   $0x3c
  jmp alltraps
8010726b:	e9 27 f9 ff ff       	jmp    80106b97 <alltraps>

80107270 <vector61>:
.globl vector61
vector61:
  pushl $0
80107270:	6a 00                	push   $0x0
  pushl $61
80107272:	6a 3d                	push   $0x3d
  jmp alltraps
80107274:	e9 1e f9 ff ff       	jmp    80106b97 <alltraps>

80107279 <vector62>:
.globl vector62
vector62:
  pushl $0
80107279:	6a 00                	push   $0x0
  pushl $62
8010727b:	6a 3e                	push   $0x3e
  jmp alltraps
8010727d:	e9 15 f9 ff ff       	jmp    80106b97 <alltraps>

80107282 <vector63>:
.globl vector63
vector63:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $63
80107284:	6a 3f                	push   $0x3f
  jmp alltraps
80107286:	e9 0c f9 ff ff       	jmp    80106b97 <alltraps>

8010728b <vector64>:
.globl vector64
vector64:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $64
8010728d:	6a 40                	push   $0x40
  jmp alltraps
8010728f:	e9 03 f9 ff ff       	jmp    80106b97 <alltraps>

80107294 <vector65>:
.globl vector65
vector65:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $65
80107296:	6a 41                	push   $0x41
  jmp alltraps
80107298:	e9 fa f8 ff ff       	jmp    80106b97 <alltraps>

8010729d <vector66>:
.globl vector66
vector66:
  pushl $0
8010729d:	6a 00                	push   $0x0
  pushl $66
8010729f:	6a 42                	push   $0x42
  jmp alltraps
801072a1:	e9 f1 f8 ff ff       	jmp    80106b97 <alltraps>

801072a6 <vector67>:
.globl vector67
vector67:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $67
801072a8:	6a 43                	push   $0x43
  jmp alltraps
801072aa:	e9 e8 f8 ff ff       	jmp    80106b97 <alltraps>

801072af <vector68>:
.globl vector68
vector68:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $68
801072b1:	6a 44                	push   $0x44
  jmp alltraps
801072b3:	e9 df f8 ff ff       	jmp    80106b97 <alltraps>

801072b8 <vector69>:
.globl vector69
vector69:
  pushl $0
801072b8:	6a 00                	push   $0x0
  pushl $69
801072ba:	6a 45                	push   $0x45
  jmp alltraps
801072bc:	e9 d6 f8 ff ff       	jmp    80106b97 <alltraps>

801072c1 <vector70>:
.globl vector70
vector70:
  pushl $0
801072c1:	6a 00                	push   $0x0
  pushl $70
801072c3:	6a 46                	push   $0x46
  jmp alltraps
801072c5:	e9 cd f8 ff ff       	jmp    80106b97 <alltraps>

801072ca <vector71>:
.globl vector71
vector71:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $71
801072cc:	6a 47                	push   $0x47
  jmp alltraps
801072ce:	e9 c4 f8 ff ff       	jmp    80106b97 <alltraps>

801072d3 <vector72>:
.globl vector72
vector72:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $72
801072d5:	6a 48                	push   $0x48
  jmp alltraps
801072d7:	e9 bb f8 ff ff       	jmp    80106b97 <alltraps>

801072dc <vector73>:
.globl vector73
vector73:
  pushl $0
801072dc:	6a 00                	push   $0x0
  pushl $73
801072de:	6a 49                	push   $0x49
  jmp alltraps
801072e0:	e9 b2 f8 ff ff       	jmp    80106b97 <alltraps>

801072e5 <vector74>:
.globl vector74
vector74:
  pushl $0
801072e5:	6a 00                	push   $0x0
  pushl $74
801072e7:	6a 4a                	push   $0x4a
  jmp alltraps
801072e9:	e9 a9 f8 ff ff       	jmp    80106b97 <alltraps>

801072ee <vector75>:
.globl vector75
vector75:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $75
801072f0:	6a 4b                	push   $0x4b
  jmp alltraps
801072f2:	e9 a0 f8 ff ff       	jmp    80106b97 <alltraps>

801072f7 <vector76>:
.globl vector76
vector76:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $76
801072f9:	6a 4c                	push   $0x4c
  jmp alltraps
801072fb:	e9 97 f8 ff ff       	jmp    80106b97 <alltraps>

80107300 <vector77>:
.globl vector77
vector77:
  pushl $0
80107300:	6a 00                	push   $0x0
  pushl $77
80107302:	6a 4d                	push   $0x4d
  jmp alltraps
80107304:	e9 8e f8 ff ff       	jmp    80106b97 <alltraps>

80107309 <vector78>:
.globl vector78
vector78:
  pushl $0
80107309:	6a 00                	push   $0x0
  pushl $78
8010730b:	6a 4e                	push   $0x4e
  jmp alltraps
8010730d:	e9 85 f8 ff ff       	jmp    80106b97 <alltraps>

80107312 <vector79>:
.globl vector79
vector79:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $79
80107314:	6a 4f                	push   $0x4f
  jmp alltraps
80107316:	e9 7c f8 ff ff       	jmp    80106b97 <alltraps>

8010731b <vector80>:
.globl vector80
vector80:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $80
8010731d:	6a 50                	push   $0x50
  jmp alltraps
8010731f:	e9 73 f8 ff ff       	jmp    80106b97 <alltraps>

80107324 <vector81>:
.globl vector81
vector81:
  pushl $0
80107324:	6a 00                	push   $0x0
  pushl $81
80107326:	6a 51                	push   $0x51
  jmp alltraps
80107328:	e9 6a f8 ff ff       	jmp    80106b97 <alltraps>

8010732d <vector82>:
.globl vector82
vector82:
  pushl $0
8010732d:	6a 00                	push   $0x0
  pushl $82
8010732f:	6a 52                	push   $0x52
  jmp alltraps
80107331:	e9 61 f8 ff ff       	jmp    80106b97 <alltraps>

80107336 <vector83>:
.globl vector83
vector83:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $83
80107338:	6a 53                	push   $0x53
  jmp alltraps
8010733a:	e9 58 f8 ff ff       	jmp    80106b97 <alltraps>

8010733f <vector84>:
.globl vector84
vector84:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $84
80107341:	6a 54                	push   $0x54
  jmp alltraps
80107343:	e9 4f f8 ff ff       	jmp    80106b97 <alltraps>

80107348 <vector85>:
.globl vector85
vector85:
  pushl $0
80107348:	6a 00                	push   $0x0
  pushl $85
8010734a:	6a 55                	push   $0x55
  jmp alltraps
8010734c:	e9 46 f8 ff ff       	jmp    80106b97 <alltraps>

80107351 <vector86>:
.globl vector86
vector86:
  pushl $0
80107351:	6a 00                	push   $0x0
  pushl $86
80107353:	6a 56                	push   $0x56
  jmp alltraps
80107355:	e9 3d f8 ff ff       	jmp    80106b97 <alltraps>

8010735a <vector87>:
.globl vector87
vector87:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $87
8010735c:	6a 57                	push   $0x57
  jmp alltraps
8010735e:	e9 34 f8 ff ff       	jmp    80106b97 <alltraps>

80107363 <vector88>:
.globl vector88
vector88:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $88
80107365:	6a 58                	push   $0x58
  jmp alltraps
80107367:	e9 2b f8 ff ff       	jmp    80106b97 <alltraps>

8010736c <vector89>:
.globl vector89
vector89:
  pushl $0
8010736c:	6a 00                	push   $0x0
  pushl $89
8010736e:	6a 59                	push   $0x59
  jmp alltraps
80107370:	e9 22 f8 ff ff       	jmp    80106b97 <alltraps>

80107375 <vector90>:
.globl vector90
vector90:
  pushl $0
80107375:	6a 00                	push   $0x0
  pushl $90
80107377:	6a 5a                	push   $0x5a
  jmp alltraps
80107379:	e9 19 f8 ff ff       	jmp    80106b97 <alltraps>

8010737e <vector91>:
.globl vector91
vector91:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $91
80107380:	6a 5b                	push   $0x5b
  jmp alltraps
80107382:	e9 10 f8 ff ff       	jmp    80106b97 <alltraps>

80107387 <vector92>:
.globl vector92
vector92:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $92
80107389:	6a 5c                	push   $0x5c
  jmp alltraps
8010738b:	e9 07 f8 ff ff       	jmp    80106b97 <alltraps>

80107390 <vector93>:
.globl vector93
vector93:
  pushl $0
80107390:	6a 00                	push   $0x0
  pushl $93
80107392:	6a 5d                	push   $0x5d
  jmp alltraps
80107394:	e9 fe f7 ff ff       	jmp    80106b97 <alltraps>

80107399 <vector94>:
.globl vector94
vector94:
  pushl $0
80107399:	6a 00                	push   $0x0
  pushl $94
8010739b:	6a 5e                	push   $0x5e
  jmp alltraps
8010739d:	e9 f5 f7 ff ff       	jmp    80106b97 <alltraps>

801073a2 <vector95>:
.globl vector95
vector95:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $95
801073a4:	6a 5f                	push   $0x5f
  jmp alltraps
801073a6:	e9 ec f7 ff ff       	jmp    80106b97 <alltraps>

801073ab <vector96>:
.globl vector96
vector96:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $96
801073ad:	6a 60                	push   $0x60
  jmp alltraps
801073af:	e9 e3 f7 ff ff       	jmp    80106b97 <alltraps>

801073b4 <vector97>:
.globl vector97
vector97:
  pushl $0
801073b4:	6a 00                	push   $0x0
  pushl $97
801073b6:	6a 61                	push   $0x61
  jmp alltraps
801073b8:	e9 da f7 ff ff       	jmp    80106b97 <alltraps>

801073bd <vector98>:
.globl vector98
vector98:
  pushl $0
801073bd:	6a 00                	push   $0x0
  pushl $98
801073bf:	6a 62                	push   $0x62
  jmp alltraps
801073c1:	e9 d1 f7 ff ff       	jmp    80106b97 <alltraps>

801073c6 <vector99>:
.globl vector99
vector99:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $99
801073c8:	6a 63                	push   $0x63
  jmp alltraps
801073ca:	e9 c8 f7 ff ff       	jmp    80106b97 <alltraps>

801073cf <vector100>:
.globl vector100
vector100:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $100
801073d1:	6a 64                	push   $0x64
  jmp alltraps
801073d3:	e9 bf f7 ff ff       	jmp    80106b97 <alltraps>

801073d8 <vector101>:
.globl vector101
vector101:
  pushl $0
801073d8:	6a 00                	push   $0x0
  pushl $101
801073da:	6a 65                	push   $0x65
  jmp alltraps
801073dc:	e9 b6 f7 ff ff       	jmp    80106b97 <alltraps>

801073e1 <vector102>:
.globl vector102
vector102:
  pushl $0
801073e1:	6a 00                	push   $0x0
  pushl $102
801073e3:	6a 66                	push   $0x66
  jmp alltraps
801073e5:	e9 ad f7 ff ff       	jmp    80106b97 <alltraps>

801073ea <vector103>:
.globl vector103
vector103:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $103
801073ec:	6a 67                	push   $0x67
  jmp alltraps
801073ee:	e9 a4 f7 ff ff       	jmp    80106b97 <alltraps>

801073f3 <vector104>:
.globl vector104
vector104:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $104
801073f5:	6a 68                	push   $0x68
  jmp alltraps
801073f7:	e9 9b f7 ff ff       	jmp    80106b97 <alltraps>

801073fc <vector105>:
.globl vector105
vector105:
  pushl $0
801073fc:	6a 00                	push   $0x0
  pushl $105
801073fe:	6a 69                	push   $0x69
  jmp alltraps
80107400:	e9 92 f7 ff ff       	jmp    80106b97 <alltraps>

80107405 <vector106>:
.globl vector106
vector106:
  pushl $0
80107405:	6a 00                	push   $0x0
  pushl $106
80107407:	6a 6a                	push   $0x6a
  jmp alltraps
80107409:	e9 89 f7 ff ff       	jmp    80106b97 <alltraps>

8010740e <vector107>:
.globl vector107
vector107:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $107
80107410:	6a 6b                	push   $0x6b
  jmp alltraps
80107412:	e9 80 f7 ff ff       	jmp    80106b97 <alltraps>

80107417 <vector108>:
.globl vector108
vector108:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $108
80107419:	6a 6c                	push   $0x6c
  jmp alltraps
8010741b:	e9 77 f7 ff ff       	jmp    80106b97 <alltraps>

80107420 <vector109>:
.globl vector109
vector109:
  pushl $0
80107420:	6a 00                	push   $0x0
  pushl $109
80107422:	6a 6d                	push   $0x6d
  jmp alltraps
80107424:	e9 6e f7 ff ff       	jmp    80106b97 <alltraps>

80107429 <vector110>:
.globl vector110
vector110:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $110
8010742b:	6a 6e                	push   $0x6e
  jmp alltraps
8010742d:	e9 65 f7 ff ff       	jmp    80106b97 <alltraps>

80107432 <vector111>:
.globl vector111
vector111:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $111
80107434:	6a 6f                	push   $0x6f
  jmp alltraps
80107436:	e9 5c f7 ff ff       	jmp    80106b97 <alltraps>

8010743b <vector112>:
.globl vector112
vector112:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $112
8010743d:	6a 70                	push   $0x70
  jmp alltraps
8010743f:	e9 53 f7 ff ff       	jmp    80106b97 <alltraps>

80107444 <vector113>:
.globl vector113
vector113:
  pushl $0
80107444:	6a 00                	push   $0x0
  pushl $113
80107446:	6a 71                	push   $0x71
  jmp alltraps
80107448:	e9 4a f7 ff ff       	jmp    80106b97 <alltraps>

8010744d <vector114>:
.globl vector114
vector114:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $114
8010744f:	6a 72                	push   $0x72
  jmp alltraps
80107451:	e9 41 f7 ff ff       	jmp    80106b97 <alltraps>

80107456 <vector115>:
.globl vector115
vector115:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $115
80107458:	6a 73                	push   $0x73
  jmp alltraps
8010745a:	e9 38 f7 ff ff       	jmp    80106b97 <alltraps>

8010745f <vector116>:
.globl vector116
vector116:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $116
80107461:	6a 74                	push   $0x74
  jmp alltraps
80107463:	e9 2f f7 ff ff       	jmp    80106b97 <alltraps>

80107468 <vector117>:
.globl vector117
vector117:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $117
8010746a:	6a 75                	push   $0x75
  jmp alltraps
8010746c:	e9 26 f7 ff ff       	jmp    80106b97 <alltraps>

80107471 <vector118>:
.globl vector118
vector118:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $118
80107473:	6a 76                	push   $0x76
  jmp alltraps
80107475:	e9 1d f7 ff ff       	jmp    80106b97 <alltraps>

8010747a <vector119>:
.globl vector119
vector119:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $119
8010747c:	6a 77                	push   $0x77
  jmp alltraps
8010747e:	e9 14 f7 ff ff       	jmp    80106b97 <alltraps>

80107483 <vector120>:
.globl vector120
vector120:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $120
80107485:	6a 78                	push   $0x78
  jmp alltraps
80107487:	e9 0b f7 ff ff       	jmp    80106b97 <alltraps>

8010748c <vector121>:
.globl vector121
vector121:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $121
8010748e:	6a 79                	push   $0x79
  jmp alltraps
80107490:	e9 02 f7 ff ff       	jmp    80106b97 <alltraps>

80107495 <vector122>:
.globl vector122
vector122:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $122
80107497:	6a 7a                	push   $0x7a
  jmp alltraps
80107499:	e9 f9 f6 ff ff       	jmp    80106b97 <alltraps>

8010749e <vector123>:
.globl vector123
vector123:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $123
801074a0:	6a 7b                	push   $0x7b
  jmp alltraps
801074a2:	e9 f0 f6 ff ff       	jmp    80106b97 <alltraps>

801074a7 <vector124>:
.globl vector124
vector124:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $124
801074a9:	6a 7c                	push   $0x7c
  jmp alltraps
801074ab:	e9 e7 f6 ff ff       	jmp    80106b97 <alltraps>

801074b0 <vector125>:
.globl vector125
vector125:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $125
801074b2:	6a 7d                	push   $0x7d
  jmp alltraps
801074b4:	e9 de f6 ff ff       	jmp    80106b97 <alltraps>

801074b9 <vector126>:
.globl vector126
vector126:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $126
801074bb:	6a 7e                	push   $0x7e
  jmp alltraps
801074bd:	e9 d5 f6 ff ff       	jmp    80106b97 <alltraps>

801074c2 <vector127>:
.globl vector127
vector127:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $127
801074c4:	6a 7f                	push   $0x7f
  jmp alltraps
801074c6:	e9 cc f6 ff ff       	jmp    80106b97 <alltraps>

801074cb <vector128>:
.globl vector128
vector128:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $128
801074cd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801074d2:	e9 c0 f6 ff ff       	jmp    80106b97 <alltraps>

801074d7 <vector129>:
.globl vector129
vector129:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $129
801074d9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801074de:	e9 b4 f6 ff ff       	jmp    80106b97 <alltraps>

801074e3 <vector130>:
.globl vector130
vector130:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $130
801074e5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801074ea:	e9 a8 f6 ff ff       	jmp    80106b97 <alltraps>

801074ef <vector131>:
.globl vector131
vector131:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $131
801074f1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801074f6:	e9 9c f6 ff ff       	jmp    80106b97 <alltraps>

801074fb <vector132>:
.globl vector132
vector132:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $132
801074fd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107502:	e9 90 f6 ff ff       	jmp    80106b97 <alltraps>

80107507 <vector133>:
.globl vector133
vector133:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $133
80107509:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010750e:	e9 84 f6 ff ff       	jmp    80106b97 <alltraps>

80107513 <vector134>:
.globl vector134
vector134:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $134
80107515:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010751a:	e9 78 f6 ff ff       	jmp    80106b97 <alltraps>

8010751f <vector135>:
.globl vector135
vector135:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $135
80107521:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107526:	e9 6c f6 ff ff       	jmp    80106b97 <alltraps>

8010752b <vector136>:
.globl vector136
vector136:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $136
8010752d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107532:	e9 60 f6 ff ff       	jmp    80106b97 <alltraps>

80107537 <vector137>:
.globl vector137
vector137:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $137
80107539:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010753e:	e9 54 f6 ff ff       	jmp    80106b97 <alltraps>

80107543 <vector138>:
.globl vector138
vector138:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $138
80107545:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010754a:	e9 48 f6 ff ff       	jmp    80106b97 <alltraps>

8010754f <vector139>:
.globl vector139
vector139:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $139
80107551:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107556:	e9 3c f6 ff ff       	jmp    80106b97 <alltraps>

8010755b <vector140>:
.globl vector140
vector140:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $140
8010755d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107562:	e9 30 f6 ff ff       	jmp    80106b97 <alltraps>

80107567 <vector141>:
.globl vector141
vector141:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $141
80107569:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010756e:	e9 24 f6 ff ff       	jmp    80106b97 <alltraps>

80107573 <vector142>:
.globl vector142
vector142:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $142
80107575:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010757a:	e9 18 f6 ff ff       	jmp    80106b97 <alltraps>

8010757f <vector143>:
.globl vector143
vector143:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $143
80107581:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107586:	e9 0c f6 ff ff       	jmp    80106b97 <alltraps>

8010758b <vector144>:
.globl vector144
vector144:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $144
8010758d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107592:	e9 00 f6 ff ff       	jmp    80106b97 <alltraps>

80107597 <vector145>:
.globl vector145
vector145:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $145
80107599:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010759e:	e9 f4 f5 ff ff       	jmp    80106b97 <alltraps>

801075a3 <vector146>:
.globl vector146
vector146:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $146
801075a5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801075aa:	e9 e8 f5 ff ff       	jmp    80106b97 <alltraps>

801075af <vector147>:
.globl vector147
vector147:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $147
801075b1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801075b6:	e9 dc f5 ff ff       	jmp    80106b97 <alltraps>

801075bb <vector148>:
.globl vector148
vector148:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $148
801075bd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801075c2:	e9 d0 f5 ff ff       	jmp    80106b97 <alltraps>

801075c7 <vector149>:
.globl vector149
vector149:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $149
801075c9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801075ce:	e9 c4 f5 ff ff       	jmp    80106b97 <alltraps>

801075d3 <vector150>:
.globl vector150
vector150:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $150
801075d5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801075da:	e9 b8 f5 ff ff       	jmp    80106b97 <alltraps>

801075df <vector151>:
.globl vector151
vector151:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $151
801075e1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801075e6:	e9 ac f5 ff ff       	jmp    80106b97 <alltraps>

801075eb <vector152>:
.globl vector152
vector152:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $152
801075ed:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801075f2:	e9 a0 f5 ff ff       	jmp    80106b97 <alltraps>

801075f7 <vector153>:
.globl vector153
vector153:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $153
801075f9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801075fe:	e9 94 f5 ff ff       	jmp    80106b97 <alltraps>

80107603 <vector154>:
.globl vector154
vector154:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $154
80107605:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010760a:	e9 88 f5 ff ff       	jmp    80106b97 <alltraps>

8010760f <vector155>:
.globl vector155
vector155:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $155
80107611:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107616:	e9 7c f5 ff ff       	jmp    80106b97 <alltraps>

8010761b <vector156>:
.globl vector156
vector156:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $156
8010761d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107622:	e9 70 f5 ff ff       	jmp    80106b97 <alltraps>

80107627 <vector157>:
.globl vector157
vector157:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $157
80107629:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010762e:	e9 64 f5 ff ff       	jmp    80106b97 <alltraps>

80107633 <vector158>:
.globl vector158
vector158:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $158
80107635:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010763a:	e9 58 f5 ff ff       	jmp    80106b97 <alltraps>

8010763f <vector159>:
.globl vector159
vector159:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $159
80107641:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107646:	e9 4c f5 ff ff       	jmp    80106b97 <alltraps>

8010764b <vector160>:
.globl vector160
vector160:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $160
8010764d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107652:	e9 40 f5 ff ff       	jmp    80106b97 <alltraps>

80107657 <vector161>:
.globl vector161
vector161:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $161
80107659:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010765e:	e9 34 f5 ff ff       	jmp    80106b97 <alltraps>

80107663 <vector162>:
.globl vector162
vector162:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $162
80107665:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010766a:	e9 28 f5 ff ff       	jmp    80106b97 <alltraps>

8010766f <vector163>:
.globl vector163
vector163:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $163
80107671:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107676:	e9 1c f5 ff ff       	jmp    80106b97 <alltraps>

8010767b <vector164>:
.globl vector164
vector164:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $164
8010767d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107682:	e9 10 f5 ff ff       	jmp    80106b97 <alltraps>

80107687 <vector165>:
.globl vector165
vector165:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $165
80107689:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010768e:	e9 04 f5 ff ff       	jmp    80106b97 <alltraps>

80107693 <vector166>:
.globl vector166
vector166:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $166
80107695:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010769a:	e9 f8 f4 ff ff       	jmp    80106b97 <alltraps>

8010769f <vector167>:
.globl vector167
vector167:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $167
801076a1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801076a6:	e9 ec f4 ff ff       	jmp    80106b97 <alltraps>

801076ab <vector168>:
.globl vector168
vector168:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $168
801076ad:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801076b2:	e9 e0 f4 ff ff       	jmp    80106b97 <alltraps>

801076b7 <vector169>:
.globl vector169
vector169:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $169
801076b9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801076be:	e9 d4 f4 ff ff       	jmp    80106b97 <alltraps>

801076c3 <vector170>:
.globl vector170
vector170:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $170
801076c5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801076ca:	e9 c8 f4 ff ff       	jmp    80106b97 <alltraps>

801076cf <vector171>:
.globl vector171
vector171:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $171
801076d1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801076d6:	e9 bc f4 ff ff       	jmp    80106b97 <alltraps>

801076db <vector172>:
.globl vector172
vector172:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $172
801076dd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801076e2:	e9 b0 f4 ff ff       	jmp    80106b97 <alltraps>

801076e7 <vector173>:
.globl vector173
vector173:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $173
801076e9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801076ee:	e9 a4 f4 ff ff       	jmp    80106b97 <alltraps>

801076f3 <vector174>:
.globl vector174
vector174:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $174
801076f5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801076fa:	e9 98 f4 ff ff       	jmp    80106b97 <alltraps>

801076ff <vector175>:
.globl vector175
vector175:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $175
80107701:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107706:	e9 8c f4 ff ff       	jmp    80106b97 <alltraps>

8010770b <vector176>:
.globl vector176
vector176:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $176
8010770d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107712:	e9 80 f4 ff ff       	jmp    80106b97 <alltraps>

80107717 <vector177>:
.globl vector177
vector177:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $177
80107719:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010771e:	e9 74 f4 ff ff       	jmp    80106b97 <alltraps>

80107723 <vector178>:
.globl vector178
vector178:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $178
80107725:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010772a:	e9 68 f4 ff ff       	jmp    80106b97 <alltraps>

8010772f <vector179>:
.globl vector179
vector179:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $179
80107731:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107736:	e9 5c f4 ff ff       	jmp    80106b97 <alltraps>

8010773b <vector180>:
.globl vector180
vector180:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $180
8010773d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107742:	e9 50 f4 ff ff       	jmp    80106b97 <alltraps>

80107747 <vector181>:
.globl vector181
vector181:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $181
80107749:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010774e:	e9 44 f4 ff ff       	jmp    80106b97 <alltraps>

80107753 <vector182>:
.globl vector182
vector182:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $182
80107755:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010775a:	e9 38 f4 ff ff       	jmp    80106b97 <alltraps>

8010775f <vector183>:
.globl vector183
vector183:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $183
80107761:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107766:	e9 2c f4 ff ff       	jmp    80106b97 <alltraps>

8010776b <vector184>:
.globl vector184
vector184:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $184
8010776d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107772:	e9 20 f4 ff ff       	jmp    80106b97 <alltraps>

80107777 <vector185>:
.globl vector185
vector185:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $185
80107779:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010777e:	e9 14 f4 ff ff       	jmp    80106b97 <alltraps>

80107783 <vector186>:
.globl vector186
vector186:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $186
80107785:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010778a:	e9 08 f4 ff ff       	jmp    80106b97 <alltraps>

8010778f <vector187>:
.globl vector187
vector187:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $187
80107791:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107796:	e9 fc f3 ff ff       	jmp    80106b97 <alltraps>

8010779b <vector188>:
.globl vector188
vector188:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $188
8010779d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801077a2:	e9 f0 f3 ff ff       	jmp    80106b97 <alltraps>

801077a7 <vector189>:
.globl vector189
vector189:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $189
801077a9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801077ae:	e9 e4 f3 ff ff       	jmp    80106b97 <alltraps>

801077b3 <vector190>:
.globl vector190
vector190:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $190
801077b5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801077ba:	e9 d8 f3 ff ff       	jmp    80106b97 <alltraps>

801077bf <vector191>:
.globl vector191
vector191:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $191
801077c1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801077c6:	e9 cc f3 ff ff       	jmp    80106b97 <alltraps>

801077cb <vector192>:
.globl vector192
vector192:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $192
801077cd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801077d2:	e9 c0 f3 ff ff       	jmp    80106b97 <alltraps>

801077d7 <vector193>:
.globl vector193
vector193:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $193
801077d9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801077de:	e9 b4 f3 ff ff       	jmp    80106b97 <alltraps>

801077e3 <vector194>:
.globl vector194
vector194:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $194
801077e5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801077ea:	e9 a8 f3 ff ff       	jmp    80106b97 <alltraps>

801077ef <vector195>:
.globl vector195
vector195:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $195
801077f1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801077f6:	e9 9c f3 ff ff       	jmp    80106b97 <alltraps>

801077fb <vector196>:
.globl vector196
vector196:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $196
801077fd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107802:	e9 90 f3 ff ff       	jmp    80106b97 <alltraps>

80107807 <vector197>:
.globl vector197
vector197:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $197
80107809:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010780e:	e9 84 f3 ff ff       	jmp    80106b97 <alltraps>

80107813 <vector198>:
.globl vector198
vector198:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $198
80107815:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010781a:	e9 78 f3 ff ff       	jmp    80106b97 <alltraps>

8010781f <vector199>:
.globl vector199
vector199:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $199
80107821:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107826:	e9 6c f3 ff ff       	jmp    80106b97 <alltraps>

8010782b <vector200>:
.globl vector200
vector200:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $200
8010782d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107832:	e9 60 f3 ff ff       	jmp    80106b97 <alltraps>

80107837 <vector201>:
.globl vector201
vector201:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $201
80107839:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010783e:	e9 54 f3 ff ff       	jmp    80106b97 <alltraps>

80107843 <vector202>:
.globl vector202
vector202:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $202
80107845:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010784a:	e9 48 f3 ff ff       	jmp    80106b97 <alltraps>

8010784f <vector203>:
.globl vector203
vector203:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $203
80107851:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107856:	e9 3c f3 ff ff       	jmp    80106b97 <alltraps>

8010785b <vector204>:
.globl vector204
vector204:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $204
8010785d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107862:	e9 30 f3 ff ff       	jmp    80106b97 <alltraps>

80107867 <vector205>:
.globl vector205
vector205:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $205
80107869:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010786e:	e9 24 f3 ff ff       	jmp    80106b97 <alltraps>

80107873 <vector206>:
.globl vector206
vector206:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $206
80107875:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010787a:	e9 18 f3 ff ff       	jmp    80106b97 <alltraps>

8010787f <vector207>:
.globl vector207
vector207:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $207
80107881:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107886:	e9 0c f3 ff ff       	jmp    80106b97 <alltraps>

8010788b <vector208>:
.globl vector208
vector208:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $208
8010788d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107892:	e9 00 f3 ff ff       	jmp    80106b97 <alltraps>

80107897 <vector209>:
.globl vector209
vector209:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $209
80107899:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010789e:	e9 f4 f2 ff ff       	jmp    80106b97 <alltraps>

801078a3 <vector210>:
.globl vector210
vector210:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $210
801078a5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801078aa:	e9 e8 f2 ff ff       	jmp    80106b97 <alltraps>

801078af <vector211>:
.globl vector211
vector211:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $211
801078b1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801078b6:	e9 dc f2 ff ff       	jmp    80106b97 <alltraps>

801078bb <vector212>:
.globl vector212
vector212:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $212
801078bd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801078c2:	e9 d0 f2 ff ff       	jmp    80106b97 <alltraps>

801078c7 <vector213>:
.globl vector213
vector213:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $213
801078c9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801078ce:	e9 c4 f2 ff ff       	jmp    80106b97 <alltraps>

801078d3 <vector214>:
.globl vector214
vector214:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $214
801078d5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801078da:	e9 b8 f2 ff ff       	jmp    80106b97 <alltraps>

801078df <vector215>:
.globl vector215
vector215:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $215
801078e1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801078e6:	e9 ac f2 ff ff       	jmp    80106b97 <alltraps>

801078eb <vector216>:
.globl vector216
vector216:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $216
801078ed:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801078f2:	e9 a0 f2 ff ff       	jmp    80106b97 <alltraps>

801078f7 <vector217>:
.globl vector217
vector217:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $217
801078f9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801078fe:	e9 94 f2 ff ff       	jmp    80106b97 <alltraps>

80107903 <vector218>:
.globl vector218
vector218:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $218
80107905:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010790a:	e9 88 f2 ff ff       	jmp    80106b97 <alltraps>

8010790f <vector219>:
.globl vector219
vector219:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $219
80107911:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107916:	e9 7c f2 ff ff       	jmp    80106b97 <alltraps>

8010791b <vector220>:
.globl vector220
vector220:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $220
8010791d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107922:	e9 70 f2 ff ff       	jmp    80106b97 <alltraps>

80107927 <vector221>:
.globl vector221
vector221:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $221
80107929:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010792e:	e9 64 f2 ff ff       	jmp    80106b97 <alltraps>

80107933 <vector222>:
.globl vector222
vector222:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $222
80107935:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010793a:	e9 58 f2 ff ff       	jmp    80106b97 <alltraps>

8010793f <vector223>:
.globl vector223
vector223:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $223
80107941:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107946:	e9 4c f2 ff ff       	jmp    80106b97 <alltraps>

8010794b <vector224>:
.globl vector224
vector224:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $224
8010794d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107952:	e9 40 f2 ff ff       	jmp    80106b97 <alltraps>

80107957 <vector225>:
.globl vector225
vector225:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $225
80107959:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010795e:	e9 34 f2 ff ff       	jmp    80106b97 <alltraps>

80107963 <vector226>:
.globl vector226
vector226:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $226
80107965:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010796a:	e9 28 f2 ff ff       	jmp    80106b97 <alltraps>

8010796f <vector227>:
.globl vector227
vector227:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $227
80107971:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107976:	e9 1c f2 ff ff       	jmp    80106b97 <alltraps>

8010797b <vector228>:
.globl vector228
vector228:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $228
8010797d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107982:	e9 10 f2 ff ff       	jmp    80106b97 <alltraps>

80107987 <vector229>:
.globl vector229
vector229:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $229
80107989:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010798e:	e9 04 f2 ff ff       	jmp    80106b97 <alltraps>

80107993 <vector230>:
.globl vector230
vector230:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $230
80107995:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010799a:	e9 f8 f1 ff ff       	jmp    80106b97 <alltraps>

8010799f <vector231>:
.globl vector231
vector231:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $231
801079a1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801079a6:	e9 ec f1 ff ff       	jmp    80106b97 <alltraps>

801079ab <vector232>:
.globl vector232
vector232:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $232
801079ad:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801079b2:	e9 e0 f1 ff ff       	jmp    80106b97 <alltraps>

801079b7 <vector233>:
.globl vector233
vector233:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $233
801079b9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801079be:	e9 d4 f1 ff ff       	jmp    80106b97 <alltraps>

801079c3 <vector234>:
.globl vector234
vector234:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $234
801079c5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801079ca:	e9 c8 f1 ff ff       	jmp    80106b97 <alltraps>

801079cf <vector235>:
.globl vector235
vector235:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $235
801079d1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801079d6:	e9 bc f1 ff ff       	jmp    80106b97 <alltraps>

801079db <vector236>:
.globl vector236
vector236:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $236
801079dd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801079e2:	e9 b0 f1 ff ff       	jmp    80106b97 <alltraps>

801079e7 <vector237>:
.globl vector237
vector237:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $237
801079e9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801079ee:	e9 a4 f1 ff ff       	jmp    80106b97 <alltraps>

801079f3 <vector238>:
.globl vector238
vector238:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $238
801079f5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801079fa:	e9 98 f1 ff ff       	jmp    80106b97 <alltraps>

801079ff <vector239>:
.globl vector239
vector239:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $239
80107a01:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a06:	e9 8c f1 ff ff       	jmp    80106b97 <alltraps>

80107a0b <vector240>:
.globl vector240
vector240:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $240
80107a0d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107a12:	e9 80 f1 ff ff       	jmp    80106b97 <alltraps>

80107a17 <vector241>:
.globl vector241
vector241:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $241
80107a19:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107a1e:	e9 74 f1 ff ff       	jmp    80106b97 <alltraps>

80107a23 <vector242>:
.globl vector242
vector242:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $242
80107a25:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107a2a:	e9 68 f1 ff ff       	jmp    80106b97 <alltraps>

80107a2f <vector243>:
.globl vector243
vector243:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $243
80107a31:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107a36:	e9 5c f1 ff ff       	jmp    80106b97 <alltraps>

80107a3b <vector244>:
.globl vector244
vector244:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $244
80107a3d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107a42:	e9 50 f1 ff ff       	jmp    80106b97 <alltraps>

80107a47 <vector245>:
.globl vector245
vector245:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $245
80107a49:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107a4e:	e9 44 f1 ff ff       	jmp    80106b97 <alltraps>

80107a53 <vector246>:
.globl vector246
vector246:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $246
80107a55:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107a5a:	e9 38 f1 ff ff       	jmp    80106b97 <alltraps>

80107a5f <vector247>:
.globl vector247
vector247:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $247
80107a61:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107a66:	e9 2c f1 ff ff       	jmp    80106b97 <alltraps>

80107a6b <vector248>:
.globl vector248
vector248:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $248
80107a6d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107a72:	e9 20 f1 ff ff       	jmp    80106b97 <alltraps>

80107a77 <vector249>:
.globl vector249
vector249:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $249
80107a79:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107a7e:	e9 14 f1 ff ff       	jmp    80106b97 <alltraps>

80107a83 <vector250>:
.globl vector250
vector250:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $250
80107a85:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107a8a:	e9 08 f1 ff ff       	jmp    80106b97 <alltraps>

80107a8f <vector251>:
.globl vector251
vector251:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $251
80107a91:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107a96:	e9 fc f0 ff ff       	jmp    80106b97 <alltraps>

80107a9b <vector252>:
.globl vector252
vector252:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $252
80107a9d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107aa2:	e9 f0 f0 ff ff       	jmp    80106b97 <alltraps>

80107aa7 <vector253>:
.globl vector253
vector253:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $253
80107aa9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107aae:	e9 e4 f0 ff ff       	jmp    80106b97 <alltraps>

80107ab3 <vector254>:
.globl vector254
vector254:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $254
80107ab5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107aba:	e9 d8 f0 ff ff       	jmp    80106b97 <alltraps>

80107abf <vector255>:
.globl vector255
vector255:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $255
80107ac1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107ac6:	e9 cc f0 ff ff       	jmp    80106b97 <alltraps>
80107acb:	66 90                	xchg   %ax,%ax
80107acd:	66 90                	xchg   %ax,%ax
80107acf:	90                   	nop

80107ad0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107ad7:	c1 ea 16             	shr    $0x16,%edx
{
80107ada:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80107adb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80107ade:	83 ec 0c             	sub    $0xc,%esp
  if (*pde & PTE_P)
80107ae1:	8b 1f                	mov    (%edi),%ebx
80107ae3:	f6 c3 01             	test   $0x1,%bl
80107ae6:	74 28                	je     80107b10 <walkpgdir+0x40>
  {
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107ae8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107aee:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107af4:	89 f0                	mov    %esi,%eax
}
80107af6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107af9:	c1 e8 0a             	shr    $0xa,%eax
80107afc:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b01:	01 d8                	add    %ebx,%eax
}
80107b03:	5b                   	pop    %ebx
80107b04:	5e                   	pop    %esi
80107b05:	5f                   	pop    %edi
80107b06:	5d                   	pop    %ebp
80107b07:	c3                   	ret    
80107b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b0f:	90                   	nop
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80107b10:	85 c9                	test   %ecx,%ecx
80107b12:	74 2c                	je     80107b40 <walkpgdir+0x70>
80107b14:	e8 17 ab ff ff       	call   80102630 <kalloc>
80107b19:	89 c3                	mov    %eax,%ebx
80107b1b:	85 c0                	test   %eax,%eax
80107b1d:	74 21                	je     80107b40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107b1f:	83 ec 04             	sub    $0x4,%esp
80107b22:	68 00 10 00 00       	push   $0x1000
80107b27:	6a 00                	push   $0x0
80107b29:	50                   	push   %eax
80107b2a:	e8 11 d8 ff ff       	call   80105340 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b35:	83 c4 10             	add    $0x10,%esp
80107b38:	83 c8 07             	or     $0x7,%eax
80107b3b:	89 07                	mov    %eax,(%edi)
80107b3d:	eb b5                	jmp    80107af4 <walkpgdir+0x24>
80107b3f:	90                   	nop
}
80107b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107b43:	31 c0                	xor    %eax,%eax
}
80107b45:	5b                   	pop    %ebx
80107b46:	5e                   	pop    %esi
80107b47:	5f                   	pop    %edi
80107b48:	5d                   	pop    %ebp
80107b49:	c3                   	ret    
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107b56:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80107b5a:	56                   	push   %esi
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80107b60:	89 d6                	mov    %edx,%esi
{
80107b62:	53                   	push   %ebx
  a = (char *)PGROUNDDOWN((uint)va);
80107b63:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107b69:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b72:	29 f0                	sub    %esi,%eax
80107b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b77:	eb 1f                	jmp    80107b98 <mappages+0x48>
80107b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
80107b80:	f6 00 01             	testb  $0x1,(%eax)
80107b83:	75 45                	jne    80107bca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107b85:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107b88:	83 cb 01             	or     $0x1,%ebx
80107b8b:	89 18                	mov    %ebx,(%eax)
    if (a == last)
80107b8d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107b90:	74 2e                	je     80107bc0 <mappages+0x70>
      break;
    a += PGSIZE;
80107b92:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for (;;)
80107b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b9b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107ba0:	89 f2                	mov    %esi,%edx
80107ba2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107ba5:	89 f8                	mov    %edi,%eax
80107ba7:	e8 24 ff ff ff       	call   80107ad0 <walkpgdir>
80107bac:	85 c0                	test   %eax,%eax
80107bae:	75 d0                	jne    80107b80 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bb8:	5b                   	pop    %ebx
80107bb9:	5e                   	pop    %esi
80107bba:	5f                   	pop    %edi
80107bbb:	5d                   	pop    %ebp
80107bbc:	c3                   	ret    
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
80107bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bc3:	31 c0                	xor    %eax,%eax
}
80107bc5:	5b                   	pop    %ebx
80107bc6:	5e                   	pop    %esi
80107bc7:	5f                   	pop    %edi
80107bc8:	5d                   	pop    %ebp
80107bc9:	c3                   	ret    
      panic("remap");
80107bca:	83 ec 0c             	sub    $0xc,%esp
80107bcd:	68 ac 90 10 80       	push   $0x801090ac
80107bd2:	e8 b9 87 ff ff       	call   80100390 <panic>
80107bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bde:	66 90                	xchg   %ax,%ax

80107be0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	89 c6                	mov    %eax,%esi
80107be7:	53                   	push   %ebx
80107be8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if (newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107bea:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107bf0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107bf6:	83 ec 1c             	sub    $0x1c,%esp
80107bf9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for (; a < oldsz; a += PGSIZE)
80107bfc:	39 da                	cmp    %ebx,%edx
80107bfe:	73 5b                	jae    80107c5b <deallocuvm.part.0+0x7b>
80107c00:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107c03:	89 d7                	mov    %edx,%edi
80107c05:	eb 14                	jmp    80107c1b <deallocuvm.part.0+0x3b>
80107c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c0e:	66 90                	xchg   %ax,%ax
80107c10:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107c16:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107c19:	76 40                	jbe    80107c5b <deallocuvm.part.0+0x7b>
  {
    pte = walkpgdir(pgdir, (char *)a, 0);
80107c1b:	31 c9                	xor    %ecx,%ecx
80107c1d:	89 fa                	mov    %edi,%edx
80107c1f:	89 f0                	mov    %esi,%eax
80107c21:	e8 aa fe ff ff       	call   80107ad0 <walkpgdir>
80107c26:	89 c3                	mov    %eax,%ebx
    if (!pte)
80107c28:	85 c0                	test   %eax,%eax
80107c2a:	74 44                	je     80107c70 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0)
80107c2c:	8b 00                	mov    (%eax),%eax
80107c2e:	a8 01                	test   $0x1,%al
80107c30:	74 de                	je     80107c10 <deallocuvm.part.0+0x30>
    {
      pa = PTE_ADDR(*pte);
      if (pa == 0)
80107c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c37:	74 47                	je     80107c80 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107c39:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107c3c:	05 00 00 00 80       	add    $0x80000000,%eax
80107c41:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107c47:	50                   	push   %eax
80107c48:	e8 23 a8 ff ff       	call   80102470 <kfree>
      *pte = 0;
80107c4d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107c53:	83 c4 10             	add    $0x10,%esp
  for (; a < oldsz; a += PGSIZE)
80107c56:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107c59:	77 c0                	ja     80107c1b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107c5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c61:	5b                   	pop    %ebx
80107c62:	5e                   	pop    %esi
80107c63:	5f                   	pop    %edi
80107c64:	5d                   	pop    %ebp
80107c65:	c3                   	ret    
80107c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c6d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c70:	89 fa                	mov    %edi,%edx
80107c72:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107c78:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107c7e:	eb 96                	jmp    80107c16 <deallocuvm.part.0+0x36>
        panic("kfree");
80107c80:	83 ec 0c             	sub    $0xc,%esp
80107c83:	68 e6 88 10 80       	push   $0x801088e6
80107c88:	e8 03 87 ff ff       	call   80100390 <panic>
80107c8d:	8d 76 00             	lea    0x0(%esi),%esi

80107c90 <seginit>:
{
80107c90:	f3 0f 1e fb          	endbr32 
80107c94:	55                   	push   %ebp
80107c95:	89 e5                	mov    %esp,%ebp
80107c97:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107c9a:	e8 81 be ff ff       	call   80103b20 <cpuid>
  pd[0] = size-1;
80107c9f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107ca4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107caa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80107cae:	c7 80 18 48 11 80 ff 	movl   $0xffff,-0x7feeb7e8(%eax)
80107cb5:	ff 00 00 
80107cb8:	c7 80 1c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7e4(%eax)
80107cbf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cc2:	c7 80 20 48 11 80 ff 	movl   $0xffff,-0x7feeb7e0(%eax)
80107cc9:	ff 00 00 
80107ccc:	c7 80 24 48 11 80 00 	movl   $0xcf9200,-0x7feeb7dc(%eax)
80107cd3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107cd6:	c7 80 28 48 11 80 ff 	movl   $0xffff,-0x7feeb7d8(%eax)
80107cdd:	ff 00 00 
80107ce0:	c7 80 2c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7d4(%eax)
80107ce7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107cea:	c7 80 30 48 11 80 ff 	movl   $0xffff,-0x7feeb7d0(%eax)
80107cf1:	ff 00 00 
80107cf4:	c7 80 34 48 11 80 00 	movl   $0xcff200,-0x7feeb7cc(%eax)
80107cfb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107cfe:	05 10 48 11 80       	add    $0x80114810,%eax
  pd[1] = (uint)p;
80107d03:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107d07:	c1 e8 10             	shr    $0x10,%eax
80107d0a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107d0e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107d11:	0f 01 10             	lgdtl  (%eax)
}
80107d14:	c9                   	leave  
80107d15:	c3                   	ret    
80107d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d1d:	8d 76 00             	lea    0x0(%esi),%esi

80107d20 <switchkvm>:
{
80107d20:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80107d24:	a1 54 82 11 80       	mov    0x80118254,%eax
80107d29:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d2e:	0f 22 d8             	mov    %eax,%cr3
}
80107d31:	c3                   	ret    
80107d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d40 <switchuvm>:
{
80107d40:	f3 0f 1e fb          	endbr32 
80107d44:	55                   	push   %ebp
80107d45:	89 e5                	mov    %esp,%ebp
80107d47:	57                   	push   %edi
80107d48:	56                   	push   %esi
80107d49:	53                   	push   %ebx
80107d4a:	83 ec 1c             	sub    $0x1c,%esp
80107d4d:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
80107d50:	85 f6                	test   %esi,%esi
80107d52:	0f 84 cb 00 00 00    	je     80107e23 <switchuvm+0xe3>
  if (p->kstack == 0)
80107d58:	8b 46 08             	mov    0x8(%esi),%eax
80107d5b:	85 c0                	test   %eax,%eax
80107d5d:	0f 84 da 00 00 00    	je     80107e3d <switchuvm+0xfd>
  if (p->pgdir == 0)
80107d63:	8b 46 04             	mov    0x4(%esi),%eax
80107d66:	85 c0                	test   %eax,%eax
80107d68:	0f 84 c2 00 00 00    	je     80107e30 <switchuvm+0xf0>
  pushcli();
80107d6e:	e8 bd d3 ff ff       	call   80105130 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d73:	e8 38 bd ff ff       	call   80103ab0 <mycpu>
80107d78:	89 c3                	mov    %eax,%ebx
80107d7a:	e8 31 bd ff ff       	call   80103ab0 <mycpu>
80107d7f:	89 c7                	mov    %eax,%edi
80107d81:	e8 2a bd ff ff       	call   80103ab0 <mycpu>
80107d86:	83 c7 08             	add    $0x8,%edi
80107d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d8c:	e8 1f bd ff ff       	call   80103ab0 <mycpu>
80107d91:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107d94:	ba 67 00 00 00       	mov    $0x67,%edx
80107d99:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107da0:	83 c0 08             	add    $0x8,%eax
80107da3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107daa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107daf:	83 c1 08             	add    $0x8,%ecx
80107db2:	c1 e8 18             	shr    $0x18,%eax
80107db5:	c1 e9 10             	shr    $0x10,%ecx
80107db8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107dbe:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107dc4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107dc9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107dd0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107dd5:	e8 d6 bc ff ff       	call   80103ab0 <mycpu>
80107dda:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107de1:	e8 ca bc ff ff       	call   80103ab0 <mycpu>
80107de6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107dea:	8b 5e 08             	mov    0x8(%esi),%ebx
80107ded:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107df3:	e8 b8 bc ff ff       	call   80103ab0 <mycpu>
80107df8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort)0xFFFF;
80107dfb:	e8 b0 bc ff ff       	call   80103ab0 <mycpu>
80107e00:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107e04:	b8 28 00 00 00       	mov    $0x28,%eax
80107e09:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir)); // switch to process's address space
80107e0c:	8b 46 04             	mov    0x4(%esi),%eax
80107e0f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e14:	0f 22 d8             	mov    %eax,%cr3
}
80107e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e1a:	5b                   	pop    %ebx
80107e1b:	5e                   	pop    %esi
80107e1c:	5f                   	pop    %edi
80107e1d:	5d                   	pop    %ebp
  popcli();
80107e1e:	e9 5d d3 ff ff       	jmp    80105180 <popcli>
    panic("switchuvm: no process");
80107e23:	83 ec 0c             	sub    $0xc,%esp
80107e26:	68 b2 90 10 80       	push   $0x801090b2
80107e2b:	e8 60 85 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107e30:	83 ec 0c             	sub    $0xc,%esp
80107e33:	68 dd 90 10 80       	push   $0x801090dd
80107e38:	e8 53 85 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107e3d:	83 ec 0c             	sub    $0xc,%esp
80107e40:	68 c8 90 10 80       	push   $0x801090c8
80107e45:	e8 46 85 ff ff       	call   80100390 <panic>
80107e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e50 <inituvm>:
{
80107e50:	f3 0f 1e fb          	endbr32 
80107e54:	55                   	push   %ebp
80107e55:	89 e5                	mov    %esp,%ebp
80107e57:	57                   	push   %edi
80107e58:	56                   	push   %esi
80107e59:	53                   	push   %ebx
80107e5a:	83 ec 1c             	sub    $0x1c,%esp
80107e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e60:	8b 75 10             	mov    0x10(%ebp),%esi
80107e63:	8b 7d 08             	mov    0x8(%ebp),%edi
80107e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz >= PGSIZE)
80107e69:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107e6f:	77 4b                	ja     80107ebc <inituvm+0x6c>
  mem = kalloc();
80107e71:	e8 ba a7 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107e76:	83 ec 04             	sub    $0x4,%esp
80107e79:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107e7e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107e80:	6a 00                	push   $0x0
80107e82:	50                   	push   %eax
80107e83:	e8 b8 d4 ff ff       	call   80105340 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107e88:	58                   	pop    %eax
80107e89:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e8f:	5a                   	pop    %edx
80107e90:	6a 06                	push   $0x6
80107e92:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e97:	31 d2                	xor    %edx,%edx
80107e99:	50                   	push   %eax
80107e9a:	89 f8                	mov    %edi,%eax
80107e9c:	e8 af fc ff ff       	call   80107b50 <mappages>
  memmove(mem, init, sz);
80107ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ea4:	89 75 10             	mov    %esi,0x10(%ebp)
80107ea7:	83 c4 10             	add    $0x10,%esp
80107eaa:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107ead:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eb3:	5b                   	pop    %ebx
80107eb4:	5e                   	pop    %esi
80107eb5:	5f                   	pop    %edi
80107eb6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107eb7:	e9 24 d5 ff ff       	jmp    801053e0 <memmove>
    panic("inituvm: more than a page");
80107ebc:	83 ec 0c             	sub    $0xc,%esp
80107ebf:	68 f1 90 10 80       	push   $0x801090f1
80107ec4:	e8 c7 84 ff ff       	call   80100390 <panic>
80107ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ed0 <loaduvm>:
{
80107ed0:	f3 0f 1e fb          	endbr32 
80107ed4:	55                   	push   %ebp
80107ed5:	89 e5                	mov    %esp,%ebp
80107ed7:	57                   	push   %edi
80107ed8:	56                   	push   %esi
80107ed9:	53                   	push   %ebx
80107eda:	83 ec 1c             	sub    $0x1c,%esp
80107edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ee0:	8b 75 18             	mov    0x18(%ebp),%esi
  if ((uint)addr % PGSIZE != 0)
80107ee3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107ee8:	0f 85 99 00 00 00    	jne    80107f87 <loaduvm+0xb7>
  for (i = 0; i < sz; i += PGSIZE)
80107eee:	01 f0                	add    %esi,%eax
80107ef0:	89 f3                	mov    %esi,%ebx
80107ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107ef5:	8b 45 14             	mov    0x14(%ebp),%eax
80107ef8:	01 f0                	add    %esi,%eax
80107efa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < sz; i += PGSIZE)
80107efd:	85 f6                	test   %esi,%esi
80107eff:	75 15                	jne    80107f16 <loaduvm+0x46>
80107f01:	eb 6d                	jmp    80107f70 <loaduvm+0xa0>
80107f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f07:	90                   	nop
80107f08:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107f0e:	89 f0                	mov    %esi,%eax
80107f10:	29 d8                	sub    %ebx,%eax
80107f12:	39 c6                	cmp    %eax,%esi
80107f14:	76 5a                	jbe    80107f70 <loaduvm+0xa0>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107f16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f19:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1c:	31 c9                	xor    %ecx,%ecx
80107f1e:	29 da                	sub    %ebx,%edx
80107f20:	e8 ab fb ff ff       	call   80107ad0 <walkpgdir>
80107f25:	85 c0                	test   %eax,%eax
80107f27:	74 51                	je     80107f7a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107f29:	8b 00                	mov    (%eax),%eax
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107f2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if (sz - i < PGSIZE)
80107f2e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107f33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (sz - i < PGSIZE)
80107f38:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107f3e:	0f 46 fb             	cmovbe %ebx,%edi
    if (readi(ip, P2V(pa), offset + i, n) != n)
80107f41:	29 d9                	sub    %ebx,%ecx
80107f43:	05 00 00 00 80       	add    $0x80000000,%eax
80107f48:	57                   	push   %edi
80107f49:	51                   	push   %ecx
80107f4a:	50                   	push   %eax
80107f4b:	ff 75 10             	pushl  0x10(%ebp)
80107f4e:	e8 0d 9b ff ff       	call   80101a60 <readi>
80107f53:	83 c4 10             	add    $0x10,%esp
80107f56:	39 f8                	cmp    %edi,%eax
80107f58:	74 ae                	je     80107f08 <loaduvm+0x38>
}
80107f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f62:	5b                   	pop    %ebx
80107f63:	5e                   	pop    %esi
80107f64:	5f                   	pop    %edi
80107f65:	5d                   	pop    %ebp
80107f66:	c3                   	ret    
80107f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6e:	66 90                	xchg   %ax,%ax
80107f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f73:	31 c0                	xor    %eax,%eax
}
80107f75:	5b                   	pop    %ebx
80107f76:	5e                   	pop    %esi
80107f77:	5f                   	pop    %edi
80107f78:	5d                   	pop    %ebp
80107f79:	c3                   	ret    
      panic("loaduvm: address should exist");
80107f7a:	83 ec 0c             	sub    $0xc,%esp
80107f7d:	68 0b 91 10 80       	push   $0x8010910b
80107f82:	e8 09 84 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107f87:	83 ec 0c             	sub    $0xc,%esp
80107f8a:	68 ac 91 10 80       	push   $0x801091ac
80107f8f:	e8 fc 83 ff ff       	call   80100390 <panic>
80107f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f9f:	90                   	nop

80107fa0 <allocuvm>:
{
80107fa0:	f3 0f 1e fb          	endbr32 
80107fa4:	55                   	push   %ebp
80107fa5:	89 e5                	mov    %esp,%ebp
80107fa7:	57                   	push   %edi
80107fa8:	56                   	push   %esi
80107fa9:	53                   	push   %ebx
80107faa:	83 ec 1c             	sub    $0x1c,%esp
  if (newsz >= KERNBASE)
80107fad:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107fb0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (newsz >= KERNBASE)
80107fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107fb6:	85 c0                	test   %eax,%eax
80107fb8:	0f 88 b2 00 00 00    	js     80108070 <allocuvm+0xd0>
  if (newsz < oldsz)
80107fbe:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (newsz < oldsz)
80107fc4:	0f 82 96 00 00 00    	jb     80108060 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107fca:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107fd0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a < newsz; a += PGSIZE)
80107fd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107fd9:	77 40                	ja     8010801b <allocuvm+0x7b>
80107fdb:	e9 83 00 00 00       	jmp    80108063 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107fe0:	83 ec 04             	sub    $0x4,%esp
80107fe3:	68 00 10 00 00       	push   $0x1000
80107fe8:	6a 00                	push   $0x0
80107fea:	50                   	push   %eax
80107feb:	e8 50 d3 ff ff       	call   80105340 <memset>
    if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80107ff0:	58                   	pop    %eax
80107ff1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ff7:	5a                   	pop    %edx
80107ff8:	6a 06                	push   $0x6
80107ffa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107fff:	89 f2                	mov    %esi,%edx
80108001:	50                   	push   %eax
80108002:	89 f8                	mov    %edi,%eax
80108004:	e8 47 fb ff ff       	call   80107b50 <mappages>
80108009:	83 c4 10             	add    $0x10,%esp
8010800c:	85 c0                	test   %eax,%eax
8010800e:	78 78                	js     80108088 <allocuvm+0xe8>
  for (; a < newsz; a += PGSIZE)
80108010:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108016:	39 75 10             	cmp    %esi,0x10(%ebp)
80108019:	76 48                	jbe    80108063 <allocuvm+0xc3>
    mem = kalloc();
8010801b:	e8 10 a6 ff ff       	call   80102630 <kalloc>
80108020:	89 c3                	mov    %eax,%ebx
    if (mem == 0)
80108022:	85 c0                	test   %eax,%eax
80108024:	75 ba                	jne    80107fe0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	68 29 91 10 80       	push   $0x80109129
8010802e:	e8 7d 86 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80108033:	8b 45 0c             	mov    0xc(%ebp),%eax
80108036:	83 c4 10             	add    $0x10,%esp
80108039:	39 45 10             	cmp    %eax,0x10(%ebp)
8010803c:	74 32                	je     80108070 <allocuvm+0xd0>
8010803e:	8b 55 10             	mov    0x10(%ebp),%edx
80108041:	89 c1                	mov    %eax,%ecx
80108043:	89 f8                	mov    %edi,%eax
80108045:	e8 96 fb ff ff       	call   80107be0 <deallocuvm.part.0>
      return 0;
8010804a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108054:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108057:	5b                   	pop    %ebx
80108058:	5e                   	pop    %esi
80108059:	5f                   	pop    %edi
8010805a:	5d                   	pop    %ebp
8010805b:	c3                   	ret    
8010805c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108060:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108069:	5b                   	pop    %ebx
8010806a:	5e                   	pop    %esi
8010806b:	5f                   	pop    %edi
8010806c:	5d                   	pop    %ebp
8010806d:	c3                   	ret    
8010806e:	66 90                	xchg   %ax,%ax
    return 0;
80108070:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010807a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010807d:	5b                   	pop    %ebx
8010807e:	5e                   	pop    %esi
8010807f:	5f                   	pop    %edi
80108080:	5d                   	pop    %ebp
80108081:	c3                   	ret    
80108082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108088:	83 ec 0c             	sub    $0xc,%esp
8010808b:	68 41 91 10 80       	push   $0x80109141
80108090:	e8 1b 86 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz)
80108095:	8b 45 0c             	mov    0xc(%ebp),%eax
80108098:	83 c4 10             	add    $0x10,%esp
8010809b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010809e:	74 0c                	je     801080ac <allocuvm+0x10c>
801080a0:	8b 55 10             	mov    0x10(%ebp),%edx
801080a3:	89 c1                	mov    %eax,%ecx
801080a5:	89 f8                	mov    %edi,%eax
801080a7:	e8 34 fb ff ff       	call   80107be0 <deallocuvm.part.0>
      kfree(mem);
801080ac:	83 ec 0c             	sub    $0xc,%esp
801080af:	53                   	push   %ebx
801080b0:	e8 bb a3 ff ff       	call   80102470 <kfree>
      return 0;
801080b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801080bc:	83 c4 10             	add    $0x10,%esp
}
801080bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080c5:	5b                   	pop    %ebx
801080c6:	5e                   	pop    %esi
801080c7:	5f                   	pop    %edi
801080c8:	5d                   	pop    %ebp
801080c9:	c3                   	ret    
801080ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801080d0 <deallocuvm>:
{
801080d0:	f3 0f 1e fb          	endbr32 
801080d4:	55                   	push   %ebp
801080d5:	89 e5                	mov    %esp,%ebp
801080d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801080da:	8b 4d 10             	mov    0x10(%ebp),%ecx
801080dd:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz)
801080e0:	39 d1                	cmp    %edx,%ecx
801080e2:	73 0c                	jae    801080f0 <deallocuvm+0x20>
}
801080e4:	5d                   	pop    %ebp
801080e5:	e9 f6 fa ff ff       	jmp    80107be0 <deallocuvm.part.0>
801080ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080f0:	89 d0                	mov    %edx,%eax
801080f2:	5d                   	pop    %ebp
801080f3:	c3                   	ret    
801080f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080ff:	90                   	nop

80108100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir)
{
80108100:	f3 0f 1e fb          	endbr32 
80108104:	55                   	push   %ebp
80108105:	89 e5                	mov    %esp,%ebp
80108107:	57                   	push   %edi
80108108:	56                   	push   %esi
80108109:	53                   	push   %ebx
8010810a:	83 ec 0c             	sub    $0xc,%esp
8010810d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if (pgdir == 0)
80108110:	85 f6                	test   %esi,%esi
80108112:	74 55                	je     80108169 <freevm+0x69>
  if (newsz >= oldsz)
80108114:	31 c9                	xor    %ecx,%ecx
80108116:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010811b:	89 f0                	mov    %esi,%eax
8010811d:	89 f3                	mov    %esi,%ebx
8010811f:	e8 bc fa ff ff       	call   80107be0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for (i = 0; i < NPDENTRIES; i++)
80108124:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010812a:	eb 0b                	jmp    80108137 <freevm+0x37>
8010812c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108130:	83 c3 04             	add    $0x4,%ebx
80108133:	39 df                	cmp    %ebx,%edi
80108135:	74 23                	je     8010815a <freevm+0x5a>
  {
    if (pgdir[i] & PTE_P)
80108137:	8b 03                	mov    (%ebx),%eax
80108139:	a8 01                	test   $0x1,%al
8010813b:	74 f3                	je     80108130 <freevm+0x30>
    {
      char *v = P2V(PTE_ADDR(pgdir[i]));
8010813d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108142:	83 ec 0c             	sub    $0xc,%esp
80108145:	83 c3 04             	add    $0x4,%ebx
      char *v = P2V(PTE_ADDR(pgdir[i]));
80108148:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010814d:	50                   	push   %eax
8010814e:	e8 1d a3 ff ff       	call   80102470 <kfree>
80108153:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++)
80108156:	39 df                	cmp    %ebx,%edi
80108158:	75 dd                	jne    80108137 <freevm+0x37>
    }
  }
  kfree((char *)pgdir);
8010815a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010815d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108160:	5b                   	pop    %ebx
80108161:	5e                   	pop    %esi
80108162:	5f                   	pop    %edi
80108163:	5d                   	pop    %ebp
  kfree((char *)pgdir);
80108164:	e9 07 a3 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80108169:	83 ec 0c             	sub    $0xc,%esp
8010816c:	68 5d 91 10 80       	push   $0x8010915d
80108171:	e8 1a 82 ff ff       	call   80100390 <panic>
80108176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010817d:	8d 76 00             	lea    0x0(%esi),%esi

80108180 <setupkvm>:
{
80108180:	f3 0f 1e fb          	endbr32 
80108184:	55                   	push   %ebp
80108185:	89 e5                	mov    %esp,%ebp
80108187:	56                   	push   %esi
80108188:	53                   	push   %ebx
  if ((pgdir = (pde_t *)kalloc()) == 0)
80108189:	e8 a2 a4 ff ff       	call   80102630 <kalloc>
8010818e:	89 c6                	mov    %eax,%esi
80108190:	85 c0                	test   %eax,%eax
80108192:	74 42                	je     801081d6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108194:	83 ec 04             	sub    $0x4,%esp
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108197:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
8010819c:	68 00 10 00 00       	push   $0x1000
801081a1:	6a 00                	push   $0x0
801081a3:	50                   	push   %eax
801081a4:	e8 97 d1 ff ff       	call   80105340 <memset>
801081a9:	83 c4 10             	add    $0x10,%esp
                 (uint)k->phys_start, k->perm) < 0)
801081ac:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081af:	83 ec 08             	sub    $0x8,%esp
801081b2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801081b5:	ff 73 0c             	pushl  0xc(%ebx)
801081b8:	8b 13                	mov    (%ebx),%edx
801081ba:	50                   	push   %eax
801081bb:	29 c1                	sub    %eax,%ecx
801081bd:	89 f0                	mov    %esi,%eax
801081bf:	e8 8c f9 ff ff       	call   80107b50 <mappages>
801081c4:	83 c4 10             	add    $0x10,%esp
801081c7:	85 c0                	test   %eax,%eax
801081c9:	78 15                	js     801081e0 <setupkvm+0x60>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081cb:	83 c3 10             	add    $0x10,%ebx
801081ce:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801081d4:	75 d6                	jne    801081ac <setupkvm+0x2c>
}
801081d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801081d9:	89 f0                	mov    %esi,%eax
801081db:	5b                   	pop    %ebx
801081dc:	5e                   	pop    %esi
801081dd:	5d                   	pop    %ebp
801081de:	c3                   	ret    
801081df:	90                   	nop
      freevm(pgdir);
801081e0:	83 ec 0c             	sub    $0xc,%esp
801081e3:	56                   	push   %esi
      return 0;
801081e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801081e6:	e8 15 ff ff ff       	call   80108100 <freevm>
      return 0;
801081eb:	83 c4 10             	add    $0x10,%esp
}
801081ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801081f1:	89 f0                	mov    %esi,%eax
801081f3:	5b                   	pop    %ebx
801081f4:	5e                   	pop    %esi
801081f5:	5d                   	pop    %ebp
801081f6:	c3                   	ret    
801081f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081fe:	66 90                	xchg   %ax,%ax

80108200 <kvmalloc>:
{
80108200:	f3 0f 1e fb          	endbr32 
80108204:	55                   	push   %ebp
80108205:	89 e5                	mov    %esp,%ebp
80108207:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010820a:	e8 71 ff ff ff       	call   80108180 <setupkvm>
8010820f:	a3 54 82 11 80       	mov    %eax,0x80118254
  lcr3(V2P(kpgdir)); // switch to the kernel page table
80108214:	05 00 00 00 80       	add    $0x80000000,%eax
80108219:	0f 22 d8             	mov    %eax,%cr3
}
8010821c:	c9                   	leave  
8010821d:	c3                   	ret    
8010821e:	66 90                	xchg   %ax,%ax

80108220 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva)
{
80108220:	f3 0f 1e fb          	endbr32 
80108224:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108225:	31 c9                	xor    %ecx,%ecx
{
80108227:	89 e5                	mov    %esp,%ebp
80108229:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010822c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010822f:	8b 45 08             	mov    0x8(%ebp),%eax
80108232:	e8 99 f8 ff ff       	call   80107ad0 <walkpgdir>
  if (pte == 0)
80108237:	85 c0                	test   %eax,%eax
80108239:	74 05                	je     80108240 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010823b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010823e:	c9                   	leave  
8010823f:	c3                   	ret    
    panic("clearpteu");
80108240:	83 ec 0c             	sub    $0xc,%esp
80108243:	68 6e 91 10 80       	push   $0x8010916e
80108248:	e8 43 81 ff ff       	call   80100390 <panic>
8010824d:	8d 76 00             	lea    0x0(%esi),%esi

80108250 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
80108250:	f3 0f 1e fb          	endbr32 
80108254:	55                   	push   %ebp
80108255:	89 e5                	mov    %esp,%ebp
80108257:	57                   	push   %edi
80108258:	56                   	push   %esi
80108259:	53                   	push   %ebx
8010825a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
8010825d:	e8 1e ff ff ff       	call   80108180 <setupkvm>
80108262:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108265:	85 c0                	test   %eax,%eax
80108267:	0f 84 9b 00 00 00    	je     80108308 <copyuvm+0xb8>
    return 0;
  for (i = 0; i < sz; i += PGSIZE)
8010826d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108270:	85 c9                	test   %ecx,%ecx
80108272:	0f 84 90 00 00 00    	je     80108308 <copyuvm+0xb8>
80108278:	31 f6                	xor    %esi,%esi
8010827a:	eb 46                	jmp    801082c2 <copyuvm+0x72>
8010827c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char *)P2V(pa), PGSIZE);
80108280:	83 ec 04             	sub    $0x4,%esp
80108283:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108289:	68 00 10 00 00       	push   $0x1000
8010828e:	57                   	push   %edi
8010828f:	50                   	push   %eax
80108290:	e8 4b d1 ff ff       	call   801053e0 <memmove>
    if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0)
80108295:	58                   	pop    %eax
80108296:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010829c:	5a                   	pop    %edx
8010829d:	ff 75 e4             	pushl  -0x1c(%ebp)
801082a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801082a5:	89 f2                	mov    %esi,%edx
801082a7:	50                   	push   %eax
801082a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082ab:	e8 a0 f8 ff ff       	call   80107b50 <mappages>
801082b0:	83 c4 10             	add    $0x10,%esp
801082b3:	85 c0                	test   %eax,%eax
801082b5:	78 61                	js     80108318 <copyuvm+0xc8>
  for (i = 0; i < sz; i += PGSIZE)
801082b7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801082bd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801082c0:	76 46                	jbe    80108308 <copyuvm+0xb8>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
801082c2:	8b 45 08             	mov    0x8(%ebp),%eax
801082c5:	31 c9                	xor    %ecx,%ecx
801082c7:	89 f2                	mov    %esi,%edx
801082c9:	e8 02 f8 ff ff       	call   80107ad0 <walkpgdir>
801082ce:	85 c0                	test   %eax,%eax
801082d0:	74 61                	je     80108333 <copyuvm+0xe3>
    if (!(*pte & PTE_P))
801082d2:	8b 00                	mov    (%eax),%eax
801082d4:	a8 01                	test   $0x1,%al
801082d6:	74 4e                	je     80108326 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801082d8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801082da:	25 ff 0f 00 00       	and    $0xfff,%eax
801082df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801082e2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if ((mem = kalloc()) == 0)
801082e8:	e8 43 a3 ff ff       	call   80102630 <kalloc>
801082ed:	89 c3                	mov    %eax,%ebx
801082ef:	85 c0                	test   %eax,%eax
801082f1:	75 8d                	jne    80108280 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801082f3:	83 ec 0c             	sub    $0xc,%esp
801082f6:	ff 75 e0             	pushl  -0x20(%ebp)
801082f9:	e8 02 fe ff ff       	call   80108100 <freevm>
  return 0;
801082fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108305:	83 c4 10             	add    $0x10,%esp
}
80108308:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010830b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010830e:	5b                   	pop    %ebx
8010830f:	5e                   	pop    %esi
80108310:	5f                   	pop    %edi
80108311:	5d                   	pop    %ebp
80108312:	c3                   	ret    
80108313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108317:	90                   	nop
      kfree(mem);
80108318:	83 ec 0c             	sub    $0xc,%esp
8010831b:	53                   	push   %ebx
8010831c:	e8 4f a1 ff ff       	call   80102470 <kfree>
      goto bad;
80108321:	83 c4 10             	add    $0x10,%esp
80108324:	eb cd                	jmp    801082f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108326:	83 ec 0c             	sub    $0xc,%esp
80108329:	68 92 91 10 80       	push   $0x80109192
8010832e:	e8 5d 80 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108333:	83 ec 0c             	sub    $0xc,%esp
80108336:	68 78 91 10 80       	push   $0x80109178
8010833b:	e8 50 80 ff ff       	call   80100390 <panic>

80108340 <uva2ka>:

// PAGEBREAK!
//  Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80108340:	f3 0f 1e fb          	endbr32 
80108344:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108345:	31 c9                	xor    %ecx,%ecx
{
80108347:	89 e5                	mov    %esp,%ebp
80108349:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010834c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010834f:	8b 45 08             	mov    0x8(%ebp),%eax
80108352:	e8 79 f7 ff ff       	call   80107ad0 <walkpgdir>
  if ((*pte & PTE_P) == 0)
80108357:	8b 00                	mov    (%eax),%eax
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  return (char *)P2V(PTE_ADDR(*pte));
}
80108359:	c9                   	leave  
  if ((*pte & PTE_U) == 0)
8010835a:	89 c2                	mov    %eax,%edx
  return (char *)P2V(PTE_ADDR(*pte));
8010835c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if ((*pte & PTE_U) == 0)
80108361:	83 e2 05             	and    $0x5,%edx
  return (char *)P2V(PTE_ADDR(*pte));
80108364:	05 00 00 00 80       	add    $0x80000000,%eax
80108369:	83 fa 05             	cmp    $0x5,%edx
8010836c:	ba 00 00 00 00       	mov    $0x0,%edx
80108371:	0f 45 c2             	cmovne %edx,%eax
}
80108374:	c3                   	ret    
80108375:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010837c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108380 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108380:	f3 0f 1e fb          	endbr32 
80108384:	55                   	push   %ebp
80108385:	89 e5                	mov    %esp,%ebp
80108387:	57                   	push   %edi
80108388:	56                   	push   %esi
80108389:	53                   	push   %ebx
8010838a:	83 ec 0c             	sub    $0xc,%esp
8010838d:	8b 75 14             	mov    0x14(%ebp),%esi
80108390:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
  while (len > 0)
80108393:	85 f6                	test   %esi,%esi
80108395:	75 3c                	jne    801083d3 <copyout+0x53>
80108397:	eb 67                	jmp    80108400 <copyout+0x80>
80108399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char *)va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801083a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801083a3:	89 fb                	mov    %edi,%ebx
801083a5:	29 d3                	sub    %edx,%ebx
801083a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if (n > len)
801083ad:	39 f3                	cmp    %esi,%ebx
801083af:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801083b2:	29 fa                	sub    %edi,%edx
801083b4:	83 ec 04             	sub    $0x4,%esp
801083b7:	01 c2                	add    %eax,%edx
801083b9:	53                   	push   %ebx
801083ba:	ff 75 10             	pushl  0x10(%ebp)
801083bd:	52                   	push   %edx
801083be:	e8 1d d0 ff ff       	call   801053e0 <memmove>
    len -= n;
    buf += n;
801083c3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801083c6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while (len > 0)
801083cc:	83 c4 10             	add    $0x10,%esp
801083cf:	29 de                	sub    %ebx,%esi
801083d1:	74 2d                	je     80108400 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801083d3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
801083d5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801083d8:	89 55 0c             	mov    %edx,0xc(%ebp)
801083db:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char *)va0);
801083e1:	57                   	push   %edi
801083e2:	ff 75 08             	pushl  0x8(%ebp)
801083e5:	e8 56 ff ff ff       	call   80108340 <uva2ka>
    if (pa0 == 0)
801083ea:	83 c4 10             	add    $0x10,%esp
801083ed:	85 c0                	test   %eax,%eax
801083ef:	75 af                	jne    801083a0 <copyout+0x20>
  }
  return 0;
}
801083f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801083f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801083f9:	5b                   	pop    %ebx
801083fa:	5e                   	pop    %esi
801083fb:	5f                   	pop    %edi
801083fc:	5d                   	pop    %ebp
801083fd:	c3                   	ret    
801083fe:	66 90                	xchg   %ax,%ax
80108400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108403:	31 c0                	xor    %eax,%eax
}
80108405:	5b                   	pop    %ebx
80108406:	5e                   	pop    %esi
80108407:	5f                   	pop    %edi
80108408:	5d                   	pop    %ebp
80108409:	c3                   	ret    
8010840a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108410 <shared_memory_init>:
//  Blank page.
// PAGEBREAK!
//  Blank page.

void shared_memory_init()
{
80108410:	f3 0f 1e fb          	endbr32 
80108414:	55                   	push   %ebp
80108415:	89 e5                	mov    %esp,%ebp
80108417:	56                   	push   %esi
80108418:	be 4c 82 11 80       	mov    $0x8011824c,%esi
8010841d:	53                   	push   %ebx
8010841e:	bb 4c 7f 11 80       	mov    $0x80117f4c,%ebx
  int i = 0;
  acquire(&shmlock);
80108423:	83 ec 0c             	sub    $0xc,%esp
80108426:	68 20 82 11 80       	push   $0x80118220
8010842b:	e8 00 ce ff ff       	call   80105230 <acquire>
  for (i = 0; i < SHARED_MEMORY_COUNT; i++)
80108430:	83 c4 10             	add    $0x10,%esp
80108433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108437:	90                   	nop
  {
    acquire(&shm_table[i].lock);
80108438:	83 ec 0c             	sub    $0xc,%esp
8010843b:	53                   	push   %ebx
8010843c:	e8 ef cd ff ff       	call   80105230 <acquire>
    int j = 0;
    for (j = 0; j < MAX_ATTACHED_PROCS; j++)
    {
      shm_table[i].attached_processes[j] = -1;
    }
    release(&shm_table[i].lock);
80108441:	89 1c 24             	mov    %ebx,(%esp)
80108444:	83 c3 60             	add    $0x60,%ebx
    shm_table[i].ref_count = 0;
80108447:	c7 83 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebx)
8010844e:	00 00 00 
    shm_table[i].marked = 0;
80108451:	c7 43 9c 00 00 00 00 	movl   $0x0,-0x64(%ebx)
      shm_table[i].attached_processes[j] = -1;
80108458:	c7 83 78 ff ff ff ff 	movl   $0xffffffff,-0x88(%ebx)
8010845f:	ff ff ff 
80108462:	c7 83 7c ff ff ff ff 	movl   $0xffffffff,-0x84(%ebx)
80108469:	ff ff ff 
8010846c:	c7 43 80 ff ff ff ff 	movl   $0xffffffff,-0x80(%ebx)
80108473:	c7 43 84 ff ff ff ff 	movl   $0xffffffff,-0x7c(%ebx)
8010847a:	c7 43 88 ff ff ff ff 	movl   $0xffffffff,-0x78(%ebx)
80108481:	c7 43 8c ff ff ff ff 	movl   $0xffffffff,-0x74(%ebx)
80108488:	c7 43 90 ff ff ff ff 	movl   $0xffffffff,-0x70(%ebx)
8010848f:	c7 43 94 ff ff ff ff 	movl   $0xffffffff,-0x6c(%ebx)
    release(&shm_table[i].lock);
80108496:	e8 55 ce ff ff       	call   801052f0 <release>
  for (i = 0; i < SHARED_MEMORY_COUNT; i++)
8010849b:	83 c4 10             	add    $0x10,%esp
8010849e:	39 de                	cmp    %ebx,%esi
801084a0:	75 96                	jne    80108438 <shared_memory_init+0x28>
  }
  release(&shmlock);
801084a2:	83 ec 0c             	sub    $0xc,%esp
801084a5:	68 20 82 11 80       	push   $0x80118220
801084aa:	e8 41 ce ff ff       	call   801052f0 <release>
}
801084af:	83 c4 10             	add    $0x10,%esp
801084b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801084b5:	5b                   	pop    %ebx
801084b6:	5e                   	pop    %esi
801084b7:	5d                   	pop    %ebp
801084b8:	c3                   	ret    
801084b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801084c0 <open_shared_memory>:
void open_shared_memory(int id)
{
801084c0:	f3 0f 1e fb          	endbr32 
801084c4:	55                   	push   %ebp
801084c5:	89 e5                	mov    %esp,%ebp
801084c7:	57                   	push   %edi
801084c8:	56                   	push   %esi
801084c9:	53                   	push   %ebx
801084ca:	83 ec 1c             	sub    $0x1c,%esp
801084cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *proc = myproc();
801084d0:	e8 5b b7 ff ff       	call   80103c30 <myproc>
  pde_t *pgdir = proc->pgdir;
  uint shm = proc->shm;
  acquire(&shm_table[id].lock);
801084d5:	83 ec 0c             	sub    $0xc,%esp
801084d8:	8d 1c 5b             	lea    (%ebx,%ebx,2),%ebx
  struct proc *proc = myproc();
801084db:	89 c6                	mov    %eax,%esi
  pde_t *pgdir = proc->pgdir;
801084dd:	8b 40 04             	mov    0x4(%eax),%eax
801084e0:	c1 e3 05             	shl    $0x5,%ebx
  uint shm = proc->shm;
801084e3:	8b be a0 00 00 00    	mov    0xa0(%esi),%edi
  acquire(&shm_table[id].lock);
801084e9:	8d 8b 4c 7f 11 80    	lea    -0x7fee80b4(%ebx),%ecx
  pde_t *pgdir = proc->pgdir;
801084ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&shm_table[id].lock);
801084f2:	51                   	push   %ecx
  uint shm = proc->shm;
801084f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  acquire(&shm_table[id].lock);
801084f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801084f9:	e8 32 cd ff ff       	call   80105230 <acquire>
  if (shm_table[id].marked == 1)
801084fe:	83 c4 10             	add    $0x10,%esp
80108501:	83 bb 48 7f 11 80 01 	cmpl   $0x1,-0x7fee80b8(%ebx)
80108508:	0f 84 da 00 00 00    	je     801085e8 <open_shared_memory+0x128>
    return;
  if (shm_table[id].ref_count == 0)
8010850e:	8b 83 20 7f 11 80    	mov    -0x7fee80e0(%ebx),%eax
80108514:	8d bb 20 7f 11 80    	lea    -0x7fee80e0(%ebx),%edi
8010851a:	85 c0                	test   %eax,%eax
8010851c:	74 6a                	je     80108588 <open_shared_memory+0xc8>
    shm_table[id].frame = mem;
    shm_table[id].ref_count++;
  }
  else
  {
    mappages(pgdir, (char *)shm, PGSIZE, V2P(shm_table[id].frame), PTE_W | PTE_U);
8010851e:	83 ec 08             	sub    $0x8,%esp
80108521:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108524:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108529:	6a 06                	push   $0x6
8010852b:	8b 47 24             	mov    0x24(%edi),%eax
8010852e:	05 00 00 00 80       	add    $0x80000000,%eax
80108533:	50                   	push   %eax
80108534:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108537:	e8 14 f6 ff ff       	call   80107b50 <mappages>

    shm_table[id].ref_count++;
    proc->shm = shm;
8010853c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    shm_table[id].ref_count++;
8010853f:	83 83 20 7f 11 80 01 	addl   $0x1,-0x7fee80e0(%ebx)
    proc->shm = shm;
80108546:	83 c4 10             	add    $0x10,%esp
80108549:	89 86 a0 00 00 00    	mov    %eax,0xa0(%esi)
8010854f:	89 f8                	mov    %edi,%eax
80108551:	81 c3 40 7f 11 80    	add    $0x80117f40,%ebx
80108557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010855e:	66 90                	xchg   %ax,%ax
  }
  int i = 0;
  for (i = 0; i < MAX_ATTACHED_PROCS; i++)
  {
    if (shm_table[id].attached_processes[i] == -1)
80108560:	83 78 04 ff          	cmpl   $0xffffffff,0x4(%eax)
80108564:	75 06                	jne    8010856c <open_shared_memory+0xac>
    {
      shm_table[id].attached_processes[i] = proc->pid;
80108566:	8b 56 10             	mov    0x10(%esi),%edx
80108569:	89 50 04             	mov    %edx,0x4(%eax)
  for (i = 0; i < MAX_ATTACHED_PROCS; i++)
8010856c:	83 c0 04             	add    $0x4,%eax
8010856f:	39 d8                	cmp    %ebx,%eax
80108571:	75 ed                	jne    80108560 <open_shared_memory+0xa0>
    }
  }
  release(&shm_table[id].lock);
80108573:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108576:	89 45 08             	mov    %eax,0x8(%ebp)
}
80108579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010857c:	5b                   	pop    %ebx
8010857d:	5e                   	pop    %esi
8010857e:	5f                   	pop    %edi
8010857f:	5d                   	pop    %ebp
  release(&shm_table[id].lock);
80108580:	e9 6b cd ff ff       	jmp    801052f0 <release>
80108585:	8d 76 00             	lea    0x0(%esi),%esi
    mem = kalloc();
80108588:	e8 a3 a0 ff ff       	call   80102630 <kalloc>
    memset(mem, 0, PGSIZE);
8010858d:	83 ec 04             	sub    $0x4,%esp
80108590:	68 00 10 00 00       	push   $0x1000
80108595:	6a 00                	push   $0x0
80108597:	50                   	push   %eax
80108598:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010859b:	e8 a0 cd ff ff       	call   80105340 <memset>
    mappages(pgdir, (char *)shm, PGSIZE, V2P(mem), PTE_W | PTE_U);
801085a0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801085a3:	58                   	pop    %eax
801085a4:	5a                   	pop    %edx
801085a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801085a8:	6a 06                	push   $0x6
801085aa:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
801085b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801085b5:	50                   	push   %eax
801085b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801085b9:	e8 92 f5 ff ff       	call   80107b50 <mappages>
    cprintf("%d\n", shm_table[id].ref_count);
801085be:	59                   	pop    %ecx
801085bf:	58                   	pop    %eax
801085c0:	ff b3 20 7f 11 80    	pushl  -0x7fee80e0(%ebx)
801085c6:	68 74 8b 10 80       	push   $0x80108b74
801085cb:	e8 e0 80 ff ff       	call   801006b0 <cprintf>
    shm_table[id].frame = mem;
801085d0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
    shm_table[id].ref_count++;
801085d3:	83 83 20 7f 11 80 01 	addl   $0x1,-0x7fee80e0(%ebx)
801085da:	83 c4 10             	add    $0x10,%esp
    shm_table[id].frame = mem;
801085dd:	89 4f 24             	mov    %ecx,0x24(%edi)
    shm_table[id].ref_count++;
801085e0:	e9 6a ff ff ff       	jmp    8010854f <open_shared_memory+0x8f>
801085e5:	8d 76 00             	lea    0x0(%esi),%esi
}
801085e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085eb:	5b                   	pop    %ebx
801085ec:	5e                   	pop    %esi
801085ed:	5f                   	pop    %edi
801085ee:	5d                   	pop    %ebp
801085ef:	c3                   	ret    

801085f0 <close_shm>:
void close_shm(int id)
{
801085f0:	f3 0f 1e fb          	endbr32 
801085f4:	55                   	push   %ebp
801085f5:	89 e5                	mov    %esp,%ebp
801085f7:	57                   	push   %edi
801085f8:	56                   	push   %esi
801085f9:	53                   	push   %ebx
801085fa:	83 ec 0c             	sub    $0xc,%esp
801085fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *proc = myproc();
80108600:	e8 2b b6 ff ff       	call   80103c30 <myproc>
  if (shm_table[id].ref_count != 0)
80108605:	8d 0c 5b             	lea    (%ebx,%ebx,2),%ecx
80108608:	c1 e1 05             	shl    $0x5,%ecx
8010860b:	8b b1 20 7f 11 80    	mov    -0x7fee80e0(%ecx),%esi
80108611:	85 f6                	test   %esi,%esi
80108613:	74 45                	je     8010865a <close_shm+0x6a>
  {
    shm_table[id].ref_count--;
80108615:	83 ee 01             	sub    $0x1,%esi
80108618:	8d 91 20 7f 11 80    	lea    -0x7fee80e0(%ecx),%edx
8010861e:	89 b1 20 7f 11 80    	mov    %esi,-0x7fee80e0(%ecx)
    int i = 0;
    for (i = 0; i < MAX_ATTACHED_PROCS; i++)
80108624:	81 c1 40 7f 11 80    	add    $0x80117f40,%ecx
8010862a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    {
      if (shm_table[id].attached_processes[i] == proc->pid)
80108630:	8b 78 10             	mov    0x10(%eax),%edi
80108633:	39 7a 04             	cmp    %edi,0x4(%edx)
80108636:	75 07                	jne    8010863f <close_shm+0x4f>
        shm_table[id].attached_processes[i] = -1;
80108638:	c7 42 04 ff ff ff ff 	movl   $0xffffffff,0x4(%edx)
    for (i = 0; i < MAX_ATTACHED_PROCS; i++)
8010863f:	83 c2 04             	add    $0x4,%edx
80108642:	39 ca                	cmp    %ecx,%edx
80108644:	75 ea                	jne    80108630 <close_shm+0x40>
    }
    if (shm_table[id].ref_count == 0)
80108646:	85 f6                	test   %esi,%esi
80108648:	75 10                	jne    8010865a <close_shm+0x6a>
    {
      shm_table[id].marked = 1;
8010864a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
8010864d:	c1 e0 05             	shl    $0x5,%eax
80108650:	c7 80 48 7f 11 80 01 	movl   $0x1,-0x7fee80b8(%eax)
80108657:	00 00 00 
    }
  }
8010865a:	83 c4 0c             	add    $0xc,%esp
8010865d:	5b                   	pop    %ebx
8010865e:	5e                   	pop    %esi
8010865f:	5f                   	pop    %edi
80108660:	5d                   	pop    %ebp
80108661:	c3                   	ret    
