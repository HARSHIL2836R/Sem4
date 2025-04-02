
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
80100028:	bc e0 e4 14 80       	mov    $0x8014e4e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 9b 39 10 80       	mov    $0x8010399b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 5c 86 10 80       	push   $0x8010865c
80100042:	68 80 b5 10 80       	push   $0x8010b580
80100047:	e8 51 50 00 00       	call   8010509d <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 cc fc 10 80 7c 	movl   $0x8010fc7c,0x8010fccc
80100056:	fc 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d0 fc 10 80 7c 	movl   $0x8010fc7c,0x8010fcd0
80100060:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 b5 10 80 	movl   $0x8010b5b4,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 d0 fc 10 80    	mov    0x8010fcd0,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 7c fc 10 80 	movl   $0x8010fc7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 63 86 10 80       	push   $0x80108663
80100090:	50                   	push   %eax
80100091:	e8 84 4e 00 00       	call   80104f1a <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 d0 fc 10 80       	mov    0x8010fcd0,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 d0 fc 10 80       	mov    %eax,0x8010fcd0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 7c fc 10 80       	mov    $0x8010fc7c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
  }
}
801000bd:	90                   	nop
801000be:	90                   	nop
801000bf:	c9                   	leave
801000c0:	c3                   	ret

801000c1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c1:	55                   	push   %ebp
801000c2:	89 e5                	mov    %esp,%ebp
801000c4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c7:	83 ec 0c             	sub    $0xc,%esp
801000ca:	68 80 b5 10 80       	push   $0x8010b580
801000cf:	e8 eb 4f 00 00       	call   801050bf <acquire>
801000d4:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d7:	a1 d0 fc 10 80       	mov    0x8010fcd0,%eax
801000dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000df:	eb 58                	jmp    80100139 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e4:	8b 40 04             	mov    0x4(%eax),%eax
801000e7:	39 45 08             	cmp    %eax,0x8(%ebp)
801000ea:	75 44                	jne    80100130 <bget+0x6f>
801000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ef:	8b 40 08             	mov    0x8(%eax),%eax
801000f2:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000f5:	75 39                	jne    80100130 <bget+0x6f>
      b->refcnt++;
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fd:	8d 50 01             	lea    0x1(%eax),%edx
80100100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100103:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100106:	83 ec 0c             	sub    $0xc,%esp
80100109:	68 80 b5 10 80       	push   $0x8010b580
8010010e:	e8 1a 50 00 00       	call   8010512d <release>
80100113:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100119:	83 c0 0c             	add    $0xc,%eax
8010011c:	83 ec 0c             	sub    $0xc,%esp
8010011f:	50                   	push   %eax
80100120:	e8 31 4e 00 00       	call   80104f56 <acquiresleep>
80100125:	83 c4 10             	add    $0x10,%esp
      return b;
80100128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012b:	e9 9d 00 00 00       	jmp    801001cd <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	8b 40 54             	mov    0x54(%eax),%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	81 7d f4 7c fc 10 80 	cmpl   $0x8010fc7c,-0xc(%ebp)
80100140:	75 9f                	jne    801000e1 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100142:	a1 cc fc 10 80       	mov    0x8010fccc,%eax
80100147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014a:	eb 6b                	jmp    801001b7 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014f:	8b 40 4c             	mov    0x4c(%eax),%eax
80100152:	85 c0                	test   %eax,%eax
80100154:	75 58                	jne    801001ae <bget+0xed>
80100156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100159:	8b 00                	mov    (%eax),%eax
8010015b:	83 e0 04             	and    $0x4,%eax
8010015e:	85 c0                	test   %eax,%eax
80100160:	75 4c                	jne    801001ae <bget+0xed>
      b->dev = dev;
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 55 08             	mov    0x8(%ebp),%edx
80100168:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016e:	8b 55 0c             	mov    0xc(%ebp),%edx
80100171:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100180:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100187:	83 ec 0c             	sub    $0xc,%esp
8010018a:	68 80 b5 10 80       	push   $0x8010b580
8010018f:	e8 99 4f 00 00       	call   8010512d <release>
80100194:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010019a:	83 c0 0c             	add    $0xc,%eax
8010019d:	83 ec 0c             	sub    $0xc,%esp
801001a0:	50                   	push   %eax
801001a1:	e8 b0 4d 00 00       	call   80104f56 <acquiresleep>
801001a6:	83 c4 10             	add    $0x10,%esp
      return b;
801001a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ac:	eb 1f                	jmp    801001cd <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b1:	8b 40 50             	mov    0x50(%eax),%eax
801001b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b7:	81 7d f4 7c fc 10 80 	cmpl   $0x8010fc7c,-0xc(%ebp)
801001be:	75 8c                	jne    8010014c <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001c0:	83 ec 0c             	sub    $0xc,%esp
801001c3:	68 6a 86 10 80       	push   $0x8010866a
801001c8:	e8 e6 03 00 00       	call   801005b3 <panic>
}
801001cd:	c9                   	leave
801001ce:	c3                   	ret

801001cf <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001cf:	55                   	push   %ebp
801001d0:	89 e5                	mov    %esp,%ebp
801001d2:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d5:	83 ec 08             	sub    $0x8,%esp
801001d8:	ff 75 0c             	push   0xc(%ebp)
801001db:	ff 75 08             	push   0x8(%ebp)
801001de:	e8 de fe ff ff       	call   801000c1 <bget>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ec:	8b 00                	mov    (%eax),%eax
801001ee:	83 e0 02             	and    $0x2,%eax
801001f1:	85 c0                	test   %eax,%eax
801001f3:	75 0e                	jne    80100203 <bread+0x34>
    iderw(b);
801001f5:	83 ec 0c             	sub    $0xc,%esp
801001f8:	ff 75 f4             	push   -0xc(%ebp)
801001fb:	e8 5b 27 00 00       	call   8010295b <iderw>
80100200:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100203:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100206:	c9                   	leave
80100207:	c3                   	ret

80100208 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100208:	55                   	push   %ebp
80100209:	89 e5                	mov    %esp,%ebp
8010020b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	83 c0 0c             	add    $0xc,%eax
80100214:	83 ec 0c             	sub    $0xc,%esp
80100217:	50                   	push   %eax
80100218:	e8 eb 4d 00 00       	call   80105008 <holdingsleep>
8010021d:	83 c4 10             	add    $0x10,%esp
80100220:	85 c0                	test   %eax,%eax
80100222:	75 0d                	jne    80100231 <bwrite+0x29>
    panic("bwrite");
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	68 7b 86 10 80       	push   $0x8010867b
8010022c:	e8 82 03 00 00       	call   801005b3 <panic>
  b->flags |= B_DIRTY;
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 c8 04             	or     $0x4,%eax
80100239:	89 c2                	mov    %eax,%edx
8010023b:	8b 45 08             	mov    0x8(%ebp),%eax
8010023e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	ff 75 08             	push   0x8(%ebp)
80100246:	e8 10 27 00 00       	call   8010295b <iderw>
8010024b:	83 c4 10             	add    $0x10,%esp
}
8010024e:	90                   	nop
8010024f:	c9                   	leave
80100250:	c3                   	ret

80100251 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100251:	55                   	push   %ebp
80100252:	89 e5                	mov    %esp,%ebp
80100254:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100257:	8b 45 08             	mov    0x8(%ebp),%eax
8010025a:	83 c0 0c             	add    $0xc,%eax
8010025d:	83 ec 0c             	sub    $0xc,%esp
80100260:	50                   	push   %eax
80100261:	e8 a2 4d 00 00       	call   80105008 <holdingsleep>
80100266:	83 c4 10             	add    $0x10,%esp
80100269:	85 c0                	test   %eax,%eax
8010026b:	75 0d                	jne    8010027a <brelse+0x29>
    panic("brelse");
8010026d:	83 ec 0c             	sub    $0xc,%esp
80100270:	68 82 86 10 80       	push   $0x80108682
80100275:	e8 39 03 00 00       	call   801005b3 <panic>

  releasesleep(&b->lock);
8010027a:	8b 45 08             	mov    0x8(%ebp),%eax
8010027d:	83 c0 0c             	add    $0xc,%eax
80100280:	83 ec 0c             	sub    $0xc,%esp
80100283:	50                   	push   %eax
80100284:	e8 31 4d 00 00       	call   80104fba <releasesleep>
80100289:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028c:	83 ec 0c             	sub    $0xc,%esp
8010028f:	68 80 b5 10 80       	push   $0x8010b580
80100294:	e8 26 4e 00 00       	call   801050bf <acquire>
80100299:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a5:	8b 45 08             	mov    0x8(%ebp),%eax
801002a8:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 47                	jne    801002fc <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b5:	8b 45 08             	mov    0x8(%ebp),%eax
801002b8:	8b 40 54             	mov    0x54(%eax),%eax
801002bb:	8b 55 08             	mov    0x8(%ebp),%edx
801002be:	8b 52 50             	mov    0x50(%edx),%edx
801002c1:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c4:	8b 45 08             	mov    0x8(%ebp),%eax
801002c7:	8b 40 50             	mov    0x50(%eax),%eax
801002ca:	8b 55 08             	mov    0x8(%ebp),%edx
801002cd:	8b 52 54             	mov    0x54(%edx),%edx
801002d0:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d3:	8b 15 d0 fc 10 80    	mov    0x8010fcd0,%edx
801002d9:	8b 45 08             	mov    0x8(%ebp),%eax
801002dc:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002df:	8b 45 08             	mov    0x8(%ebp),%eax
801002e2:	c7 40 50 7c fc 10 80 	movl   $0x8010fc7c,0x50(%eax)
    bcache.head.next->prev = b;
801002e9:	a1 d0 fc 10 80       	mov    0x8010fcd0,%eax
801002ee:	8b 55 08             	mov    0x8(%ebp),%edx
801002f1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f4:	8b 45 08             	mov    0x8(%ebp),%eax
801002f7:	a3 d0 fc 10 80       	mov    %eax,0x8010fcd0
  }
  
  release(&bcache.lock);
801002fc:	83 ec 0c             	sub    $0xc,%esp
801002ff:	68 80 b5 10 80       	push   $0x8010b580
80100304:	e8 24 4e 00 00       	call   8010512d <release>
80100309:	83 c4 10             	add    $0x10,%esp
}
8010030c:	90                   	nop
8010030d:	c9                   	leave
8010030e:	c3                   	ret

8010030f <inb>:
// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
8010030f:	55                   	push   %ebp
80100310:	89 e5                	mov    %esp,%ebp
80100312:	83 ec 14             	sub    $0x14,%esp
80100315:	8b 45 08             	mov    0x8(%ebp),%eax
80100318:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
#include "defs.h"
#include "param.h"
#include "traps.h"
8010031c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100320:	89 c2                	mov    %eax,%edx
80100322:	ec                   	in     (%dx),%al
80100323:	88 45 ff             	mov    %al,-0x1(%ebp)
#include "spinlock.h"
80100326:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
#include "sleeplock.h"
8010032a:	c9                   	leave
8010032b:	c3                   	ret

8010032c <outb>:
static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
8010032c:	55                   	push   %ebp
8010032d:	89 e5                	mov    %esp,%ebp
8010032f:	83 ec 08             	sub    $0x8,%esp
80100332:	8b 55 08             	mov    0x8(%ebp),%edx
80100335:	8b 45 0c             	mov    0xc(%ebp),%eax
80100338:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033c:	88 45 f8             	mov    %al,-0x8(%ebp)
  int locking;
8010033f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100343:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100347:	ee                   	out    %al,(%dx)
} cons;
80100348:	90                   	nop
80100349:	c9                   	leave
8010034a:	c3                   	ret

8010034b <cli>:

void
panic(char *s)
{
  int i;
  uint pcs[10];
8010034b:	55                   	push   %ebp
8010034c:	89 e5                	mov    %esp,%ebp

8010034e:	fa                   	cli
  cli();
8010034f:	90                   	nop
80100350:	5d                   	pop    %ebp
80100351:	c3                   	ret

80100352 <printint>:
{
80100352:	55                   	push   %ebp
80100353:	89 e5                	mov    %esp,%ebp
80100355:	83 ec 28             	sub    $0x28,%esp
  if(sign && (sign = xx < 0))
80100358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035c:	74 1c                	je     8010037a <printint+0x28>
8010035e:	8b 45 08             	mov    0x8(%ebp),%eax
80100361:	c1 e8 1f             	shr    $0x1f,%eax
80100364:	0f b6 c0             	movzbl %al,%eax
80100367:	89 45 10             	mov    %eax,0x10(%ebp)
8010036a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036e:	74 0a                	je     8010037a <printint+0x28>
    x = -xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	f7 d8                	neg    %eax
80100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100378:	eb 06                	jmp    80100380 <printint+0x2e>
    x = xx;
8010037a:	8b 45 08             	mov    0x8(%ebp),%eax
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  i = 0;
80100380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    buf[i++] = digits[x % base];
80100387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010038a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010038d:	ba 00 00 00 00       	mov    $0x0,%edx
80100392:	f7 f1                	div    %ecx
80100394:	89 d1                	mov    %edx,%ecx
80100396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100399:	8d 50 01             	lea    0x1(%eax),%edx
8010039c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010039f:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
801003a6:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b0:	ba 00 00 00 00       	mov    $0x0,%edx
801003b5:	f7 f1                	div    %ecx
801003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003be:	75 c7                	jne    80100387 <printint+0x35>
  if(sign)
801003c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c4:	74 2a                	je     801003f0 <printint+0x9e>
    buf[i++] = '-';
801003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c9:	8d 50 01             	lea    0x1(%eax),%edx
801003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003cf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
  while(--i >= 0)
801003d4:	eb 1a                	jmp    801003f0 <printint+0x9e>
    consputc(buf[i]);
801003d6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003dc:	01 d0                	add    %edx,%eax
801003de:	0f b6 00             	movzbl (%eax),%eax
801003e1:	0f be c0             	movsbl %al,%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 f4 03 00 00       	call   801007e1 <consputc>
801003ed:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f8:	79 dc                	jns    801003d6 <printint+0x84>
}
801003fa:	90                   	nop
801003fb:	90                   	nop
801003fc:	c9                   	leave
801003fd:	c3                   	ret

801003fe <cprintf>:
{
801003fe:	55                   	push   %ebp
801003ff:	89 e5                	mov    %esp,%ebp
80100401:	83 ec 28             	sub    $0x28,%esp
  locking = cons.locking;
80100404:	a1 b4 ff 10 80       	mov    0x8010ffb4,%eax
80100409:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100410:	74 10                	je     80100422 <cprintf+0x24>
    acquire(&cons.lock);
80100412:	83 ec 0c             	sub    $0xc,%esp
80100415:	68 80 ff 10 80       	push   $0x8010ff80
8010041a:	e8 a0 4c 00 00       	call   801050bf <acquire>
8010041f:	83 c4 10             	add    $0x10,%esp
  if (fmt == 0)
80100422:	8b 45 08             	mov    0x8(%ebp),%eax
80100425:	85 c0                	test   %eax,%eax
80100427:	75 0d                	jne    80100436 <cprintf+0x38>
    panic("null fmt");
80100429:	83 ec 0c             	sub    $0xc,%esp
8010042c:	68 89 86 10 80       	push   $0x80108689
80100431:	e8 7d 01 00 00       	call   801005b3 <panic>
  argp = (uint*)(void*)(&fmt + 1);
80100436:	8d 45 0c             	lea    0xc(%ebp),%eax
80100439:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100443:	e9 2f 01 00 00       	jmp    80100577 <cprintf+0x179>
    if(c != '%'){
80100448:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044c:	74 13                	je     80100461 <cprintf+0x63>
      consputc(c);
8010044e:	83 ec 0c             	sub    $0xc,%esp
80100451:	ff 75 e4             	push   -0x1c(%ebp)
80100454:	e8 88 03 00 00       	call   801007e1 <consputc>
80100459:	83 c4 10             	add    $0x10,%esp
      continue;
8010045c:	e9 12 01 00 00       	jmp    80100573 <cprintf+0x175>
    c = fmt[++i] & 0xff;
80100461:	8b 55 08             	mov    0x8(%ebp),%edx
80100464:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010046b:	01 d0                	add    %edx,%eax
8010046d:	0f b6 00             	movzbl (%eax),%eax
80100470:	0f be c0             	movsbl %al,%eax
80100473:	25 ff 00 00 00       	and    $0xff,%eax
80100478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010047b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010047f:	0f 84 14 01 00 00    	je     80100599 <cprintf+0x19b>
    switch(c){
80100485:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100489:	74 5e                	je     801004e9 <cprintf+0xeb>
8010048b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010048f:	0f 8f c2 00 00 00    	jg     80100557 <cprintf+0x159>
80100495:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100499:	74 6b                	je     80100506 <cprintf+0x108>
8010049b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010049f:	0f 8f b2 00 00 00    	jg     80100557 <cprintf+0x159>
801004a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a9:	74 3e                	je     801004e9 <cprintf+0xeb>
801004ab:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004af:	0f 8f a2 00 00 00    	jg     80100557 <cprintf+0x159>
801004b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004b9:	0f 84 89 00 00 00    	je     80100548 <cprintf+0x14a>
801004bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004c3:	0f 85 8e 00 00 00    	jne    80100557 <cprintf+0x159>
      printint(*argp++, 10, 1);
801004c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004cc:	8d 50 04             	lea    0x4(%eax),%edx
801004cf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d2:	8b 00                	mov    (%eax),%eax
801004d4:	83 ec 04             	sub    $0x4,%esp
801004d7:	6a 01                	push   $0x1
801004d9:	6a 0a                	push   $0xa
801004db:	50                   	push   %eax
801004dc:	e8 71 fe ff ff       	call   80100352 <printint>
801004e1:	83 c4 10             	add    $0x10,%esp
      break;
801004e4:	e9 8a 00 00 00       	jmp    80100573 <cprintf+0x175>
      printint(*argp++, 16, 0);
801004e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ec:	8d 50 04             	lea    0x4(%eax),%edx
801004ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f2:	8b 00                	mov    (%eax),%eax
801004f4:	83 ec 04             	sub    $0x4,%esp
801004f7:	6a 00                	push   $0x0
801004f9:	6a 10                	push   $0x10
801004fb:	50                   	push   %eax
801004fc:	e8 51 fe ff ff       	call   80100352 <printint>
80100501:	83 c4 10             	add    $0x10,%esp
      break;
80100504:	eb 6d                	jmp    80100573 <cprintf+0x175>
      if((s = (char*)*argp++) == 0)
80100506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100509:	8d 50 04             	lea    0x4(%eax),%edx
8010050c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010050f:	8b 00                	mov    (%eax),%eax
80100511:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100518:	75 22                	jne    8010053c <cprintf+0x13e>
        s = "(null)";
8010051a:	c7 45 ec 92 86 10 80 	movl   $0x80108692,-0x14(%ebp)
      for(; *s; s++)
80100521:	eb 19                	jmp    8010053c <cprintf+0x13e>
        consputc(*s);
80100523:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100526:	0f b6 00             	movzbl (%eax),%eax
80100529:	0f be c0             	movsbl %al,%eax
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	50                   	push   %eax
80100530:	e8 ac 02 00 00       	call   801007e1 <consputc>
80100535:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100538:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010053f:	0f b6 00             	movzbl (%eax),%eax
80100542:	84 c0                	test   %al,%al
80100544:	75 dd                	jne    80100523 <cprintf+0x125>
      break;
80100546:	eb 2b                	jmp    80100573 <cprintf+0x175>
      consputc('%');
80100548:	83 ec 0c             	sub    $0xc,%esp
8010054b:	6a 25                	push   $0x25
8010054d:	e8 8f 02 00 00       	call   801007e1 <consputc>
80100552:	83 c4 10             	add    $0x10,%esp
      break;
80100555:	eb 1c                	jmp    80100573 <cprintf+0x175>
      consputc('%');
80100557:	83 ec 0c             	sub    $0xc,%esp
8010055a:	6a 25                	push   $0x25
8010055c:	e8 80 02 00 00       	call   801007e1 <consputc>
80100561:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100564:	83 ec 0c             	sub    $0xc,%esp
80100567:	ff 75 e4             	push   -0x1c(%ebp)
8010056a:	e8 72 02 00 00       	call   801007e1 <consputc>
8010056f:	83 c4 10             	add    $0x10,%esp
      break;
80100572:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100573:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100577:	8b 55 08             	mov    0x8(%ebp),%edx
8010057a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010057d:	01 d0                	add    %edx,%eax
8010057f:	0f b6 00             	movzbl (%eax),%eax
80100582:	0f be c0             	movsbl %al,%eax
80100585:	25 ff 00 00 00       	and    $0xff,%eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100591:	0f 85 b1 fe ff ff    	jne    80100448 <cprintf+0x4a>
80100597:	eb 01                	jmp    8010059a <cprintf+0x19c>
      break;
80100599:	90                   	nop
  if(locking)
8010059a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010059e:	74 10                	je     801005b0 <cprintf+0x1b2>
    release(&cons.lock);
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 80 ff 10 80       	push   $0x8010ff80
801005a8:	e8 80 4b 00 00       	call   8010512d <release>
801005ad:	83 c4 10             	add    $0x10,%esp
}
801005b0:	90                   	nop
801005b1:	c9                   	leave
801005b2:	c3                   	ret

801005b3 <panic>:
{
801005b3:	55                   	push   %ebp
801005b4:	89 e5                	mov    %esp,%ebp
801005b6:	83 ec 38             	sub    $0x38,%esp
  cli();
801005b9:	e8 8d fd ff ff       	call   8010034b <cli>
  cons.locking = 0;
801005be:	c7 05 b4 ff 10 80 00 	movl   $0x0,0x8010ffb4
801005c5:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005c8:	e8 63 2b 00 00       	call   80103130 <lapicid>
801005cd:	83 ec 08             	sub    $0x8,%esp
801005d0:	50                   	push   %eax
801005d1:	68 99 86 10 80       	push   $0x80108699
801005d6:	e8 23 fe ff ff       	call   801003fe <cprintf>
801005db:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005de:	8b 45 08             	mov    0x8(%ebp),%eax
801005e1:	83 ec 0c             	sub    $0xc,%esp
801005e4:	50                   	push   %eax
801005e5:	e8 14 fe ff ff       	call   801003fe <cprintf>
801005ea:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005ed:	83 ec 0c             	sub    $0xc,%esp
801005f0:	68 ad 86 10 80       	push   $0x801086ad
801005f5:	e8 04 fe ff ff       	call   801003fe <cprintf>
801005fa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005fd:	83 ec 08             	sub    $0x8,%esp
80100600:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100603:	50                   	push   %eax
80100604:	8d 45 08             	lea    0x8(%ebp),%eax
80100607:	50                   	push   %eax
80100608:	e8 72 4b 00 00       	call   8010517f <getcallerpcs>
8010060d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100610:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100617:	eb 1c                	jmp    80100635 <panic+0x82>
    cprintf(" %p", pcs[i]);
80100619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010061c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100620:	83 ec 08             	sub    $0x8,%esp
80100623:	50                   	push   %eax
80100624:	68 af 86 10 80       	push   $0x801086af
80100629:	e8 d0 fd ff ff       	call   801003fe <cprintf>
8010062e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100631:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100635:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100639:	7e de                	jle    80100619 <panic+0x66>
  panicked = 1; // freeze other CPU
8010063b:	c7 05 6c ff 10 80 01 	movl   $0x1,0x8010ff6c
80100642:	00 00 00 
  for(;;)
80100645:	90                   	nop
80100646:	eb fd                	jmp    80100645 <panic+0x92>

80100648 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100648:	55                   	push   %ebp
80100649:	89 e5                	mov    %esp,%ebp
8010064b:	53                   	push   %ebx
8010064c:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010064f:	6a 0e                	push   $0xe
80100651:	68 d4 03 00 00       	push   $0x3d4
80100656:	e8 d1 fc ff ff       	call   8010032c <outb>
8010065b:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010065e:	68 d5 03 00 00       	push   $0x3d5
80100663:	e8 a7 fc ff ff       	call   8010030f <inb>
80100668:	83 c4 04             	add    $0x4,%esp
8010066b:	0f b6 c0             	movzbl %al,%eax
8010066e:	c1 e0 08             	shl    $0x8,%eax
80100671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100674:	6a 0f                	push   $0xf
80100676:	68 d4 03 00 00       	push   $0x3d4
8010067b:	e8 ac fc ff ff       	call   8010032c <outb>
80100680:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100683:	68 d5 03 00 00       	push   $0x3d5
80100688:	e8 82 fc ff ff       	call   8010030f <inb>
8010068d:	83 c4 04             	add    $0x4,%esp
80100690:	0f b6 c0             	movzbl %al,%eax
80100693:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100696:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010069a:	75 30                	jne    801006cc <cgaputc+0x84>
    pos += 80 - pos%80;
8010069c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010069f:	ba 67 66 66 66       	mov    $0x66666667,%edx
801006a4:	89 c8                	mov    %ecx,%eax
801006a6:	f7 ea                	imul   %edx
801006a8:	c1 fa 05             	sar    $0x5,%edx
801006ab:	89 c8                	mov    %ecx,%eax
801006ad:	c1 f8 1f             	sar    $0x1f,%eax
801006b0:	29 c2                	sub    %eax,%edx
801006b2:	89 d0                	mov    %edx,%eax
801006b4:	c1 e0 02             	shl    $0x2,%eax
801006b7:	01 d0                	add    %edx,%eax
801006b9:	c1 e0 04             	shl    $0x4,%eax
801006bc:	29 c1                	sub    %eax,%ecx
801006be:	89 ca                	mov    %ecx,%edx
801006c0:	b8 50 00 00 00       	mov    $0x50,%eax
801006c5:	29 d0                	sub    %edx,%eax
801006c7:	01 45 f4             	add    %eax,-0xc(%ebp)
801006ca:	eb 38                	jmp    80100704 <cgaputc+0xbc>
  else if(c == BACKSPACE){
801006cc:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006d3:	75 0c                	jne    801006e1 <cgaputc+0x99>
    if(pos > 0) --pos;
801006d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006d9:	7e 29                	jle    80100704 <cgaputc+0xbc>
801006db:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006df:	eb 23                	jmp    80100704 <cgaputc+0xbc>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006e1:	8b 45 08             	mov    0x8(%ebp),%eax
801006e4:	0f b6 c0             	movzbl %al,%eax
801006e7:	80 cc 07             	or     $0x7,%ah
801006ea:	89 c3                	mov    %eax,%ebx
801006ec:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006f5:	8d 50 01             	lea    0x1(%eax),%edx
801006f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006fb:	01 c0                	add    %eax,%eax
801006fd:	01 c8                	add    %ecx,%eax
801006ff:	89 da                	mov    %ebx,%edx
80100701:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100708:	78 09                	js     80100713 <cgaputc+0xcb>
8010070a:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100711:	7e 0d                	jle    80100720 <cgaputc+0xd8>
    panic("pos under/overflow");
80100713:	83 ec 0c             	sub    $0xc,%esp
80100716:	68 b3 86 10 80       	push   $0x801086b3
8010071b:	e8 93 fe ff ff       	call   801005b3 <panic>

  if((pos/80) >= 24){  // Scroll up.
80100720:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100727:	7e 4c                	jle    80100775 <cgaputc+0x12d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100729:	a1 00 90 10 80       	mov    0x80109000,%eax
8010072e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100734:	a1 00 90 10 80       	mov    0x80109000,%eax
80100739:	83 ec 04             	sub    $0x4,%esp
8010073c:	68 60 0e 00 00       	push   $0xe60
80100741:	52                   	push   %edx
80100742:	50                   	push   %eax
80100743:	e8 bc 4c 00 00       	call   80105404 <memmove>
80100748:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010074b:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010074f:	b8 80 07 00 00       	mov    $0x780,%eax
80100754:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100757:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010075a:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100762:	01 c9                	add    %ecx,%ecx
80100764:	01 c8                	add    %ecx,%eax
80100766:	83 ec 04             	sub    $0x4,%esp
80100769:	52                   	push   %edx
8010076a:	6a 00                	push   $0x0
8010076c:	50                   	push   %eax
8010076d:	e8 d3 4b 00 00       	call   80105345 <memset>
80100772:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
80100775:	83 ec 08             	sub    $0x8,%esp
80100778:	6a 0e                	push   $0xe
8010077a:	68 d4 03 00 00       	push   $0x3d4
8010077f:	e8 a8 fb ff ff       	call   8010032c <outb>
80100784:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078a:	c1 f8 08             	sar    $0x8,%eax
8010078d:	0f b6 c0             	movzbl %al,%eax
80100790:	83 ec 08             	sub    $0x8,%esp
80100793:	50                   	push   %eax
80100794:	68 d5 03 00 00       	push   $0x3d5
80100799:	e8 8e fb ff ff       	call   8010032c <outb>
8010079e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007a1:	83 ec 08             	sub    $0x8,%esp
801007a4:	6a 0f                	push   $0xf
801007a6:	68 d4 03 00 00       	push   $0x3d4
801007ab:	e8 7c fb ff ff       	call   8010032c <outb>
801007b0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007b6:	0f b6 c0             	movzbl %al,%eax
801007b9:	83 ec 08             	sub    $0x8,%esp
801007bc:	50                   	push   %eax
801007bd:	68 d5 03 00 00       	push   $0x3d5
801007c2:	e8 65 fb ff ff       	call   8010032c <outb>
801007c7:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007ca:	a1 00 90 10 80       	mov    0x80109000,%eax
801007cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007d2:	01 d2                	add    %edx,%edx
801007d4:	01 d0                	add    %edx,%eax
801007d6:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007db:	90                   	nop
801007dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007df:	c9                   	leave
801007e0:	c3                   	ret

801007e1 <consputc>:

void
consputc(int c)
{
801007e1:	55                   	push   %ebp
801007e2:	89 e5                	mov    %esp,%ebp
801007e4:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007e7:	a1 6c ff 10 80       	mov    0x8010ff6c,%eax
801007ec:	85 c0                	test   %eax,%eax
801007ee:	74 08                	je     801007f8 <consputc+0x17>
    cli();
801007f0:	e8 56 fb ff ff       	call   8010034b <cli>
    for(;;)
801007f5:	90                   	nop
801007f6:	eb fd                	jmp    801007f5 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007f8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007ff:	75 29                	jne    8010082a <consputc+0x49>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100801:	83 ec 0c             	sub    $0xc,%esp
80100804:	6a 08                	push   $0x8
80100806:	e8 44 64 00 00       	call   80106c4f <uartputc>
8010080b:	83 c4 10             	add    $0x10,%esp
8010080e:	83 ec 0c             	sub    $0xc,%esp
80100811:	6a 20                	push   $0x20
80100813:	e8 37 64 00 00       	call   80106c4f <uartputc>
80100818:	83 c4 10             	add    $0x10,%esp
8010081b:	83 ec 0c             	sub    $0xc,%esp
8010081e:	6a 08                	push   $0x8
80100820:	e8 2a 64 00 00       	call   80106c4f <uartputc>
80100825:	83 c4 10             	add    $0x10,%esp
80100828:	eb 0e                	jmp    80100838 <consputc+0x57>
  } else
    uartputc(c);
8010082a:	83 ec 0c             	sub    $0xc,%esp
8010082d:	ff 75 08             	push   0x8(%ebp)
80100830:	e8 1a 64 00 00       	call   80106c4f <uartputc>
80100835:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100838:	83 ec 0c             	sub    $0xc,%esp
8010083b:	ff 75 08             	push   0x8(%ebp)
8010083e:	e8 05 fe ff ff       	call   80100648 <cgaputc>
80100843:	83 c4 10             	add    $0x10,%esp
}
80100846:	90                   	nop
80100847:	c9                   	leave
80100848:	c3                   	ret

80100849 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100849:	55                   	push   %ebp
8010084a:	89 e5                	mov    %esp,%ebp
8010084c:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010084f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100856:	83 ec 0c             	sub    $0xc,%esp
80100859:	68 80 ff 10 80       	push   $0x8010ff80
8010085e:	e8 5c 48 00 00       	call   801050bf <acquire>
80100863:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100866:	e9 58 01 00 00       	jmp    801009c3 <consoleintr+0x17a>
    switch(c){
8010086b:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010086f:	0f 84 81 00 00 00    	je     801008f6 <consoleintr+0xad>
80100875:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100879:	0f 8f ac 00 00 00    	jg     8010092b <consoleintr+0xe2>
8010087f:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100883:	74 43                	je     801008c8 <consoleintr+0x7f>
80100885:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100889:	0f 8f 9c 00 00 00    	jg     8010092b <consoleintr+0xe2>
8010088f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100893:	74 61                	je     801008f6 <consoleintr+0xad>
80100895:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100899:	0f 85 8c 00 00 00    	jne    8010092b <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010089f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801008a6:	e9 18 01 00 00       	jmp    801009c3 <consoleintr+0x17a>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008ab:	a1 68 ff 10 80       	mov    0x8010ff68,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 68 ff 10 80       	mov    %eax,0x8010ff68
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 1c ff ff ff       	call   801007e1 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008c8:	8b 15 68 ff 10 80    	mov    0x8010ff68,%edx
801008ce:	a1 64 ff 10 80       	mov    0x8010ff64,%eax
801008d3:	39 c2                	cmp    %eax,%edx
801008d5:	0f 84 e1 00 00 00    	je     801009bc <consoleintr+0x173>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008db:	a1 68 ff 10 80       	mov    0x8010ff68,%eax
801008e0:	83 e8 01             	sub    $0x1,%eax
801008e3:	83 e0 7f             	and    $0x7f,%eax
801008e6:	0f b6 80 e0 fe 10 80 	movzbl -0x7fef0120(%eax),%eax
      while(input.e != input.w &&
801008ed:	3c 0a                	cmp    $0xa,%al
801008ef:	75 ba                	jne    801008ab <consoleintr+0x62>
      }
      break;
801008f1:	e9 c6 00 00 00       	jmp    801009bc <consoleintr+0x173>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008f6:	8b 15 68 ff 10 80    	mov    0x8010ff68,%edx
801008fc:	a1 64 ff 10 80       	mov    0x8010ff64,%eax
80100901:	39 c2                	cmp    %eax,%edx
80100903:	0f 84 b6 00 00 00    	je     801009bf <consoleintr+0x176>
        input.e--;
80100909:	a1 68 ff 10 80       	mov    0x8010ff68,%eax
8010090e:	83 e8 01             	sub    $0x1,%eax
80100911:	a3 68 ff 10 80       	mov    %eax,0x8010ff68
        consputc(BACKSPACE);
80100916:	83 ec 0c             	sub    $0xc,%esp
80100919:	68 00 01 00 00       	push   $0x100
8010091e:	e8 be fe ff ff       	call   801007e1 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100926:	e9 94 00 00 00       	jmp    801009bf <consoleintr+0x176>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010092b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010092f:	0f 84 8d 00 00 00    	je     801009c2 <consoleintr+0x179>
80100935:	8b 15 68 ff 10 80    	mov    0x8010ff68,%edx
8010093b:	a1 60 ff 10 80       	mov    0x8010ff60,%eax
80100940:	29 c2                	sub    %eax,%edx
80100942:	83 fa 7f             	cmp    $0x7f,%edx
80100945:	77 7b                	ja     801009c2 <consoleintr+0x179>
        c = (c == '\r') ? '\n' : c;
80100947:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010094b:	74 05                	je     80100952 <consoleintr+0x109>
8010094d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100950:	eb 05                	jmp    80100957 <consoleintr+0x10e>
80100952:	b8 0a 00 00 00       	mov    $0xa,%eax
80100957:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010095a:	a1 68 ff 10 80       	mov    0x8010ff68,%eax
8010095f:	8d 50 01             	lea    0x1(%eax),%edx
80100962:	89 15 68 ff 10 80    	mov    %edx,0x8010ff68
80100968:	83 e0 7f             	and    $0x7f,%eax
8010096b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010096e:	88 90 e0 fe 10 80    	mov    %dl,-0x7fef0120(%eax)
        consputc(c);
80100974:	83 ec 0c             	sub    $0xc,%esp
80100977:	ff 75 f0             	push   -0x10(%ebp)
8010097a:	e8 62 fe ff ff       	call   801007e1 <consputc>
8010097f:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100982:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100986:	74 18                	je     801009a0 <consoleintr+0x157>
80100988:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010098c:	74 12                	je     801009a0 <consoleintr+0x157>
8010098e:	8b 15 68 ff 10 80    	mov    0x8010ff68,%edx
80100994:	a1 60 ff 10 80       	mov    0x8010ff60,%eax
80100999:	83 e8 80             	sub    $0xffffff80,%eax
8010099c:	39 c2                	cmp    %eax,%edx
8010099e:	75 22                	jne    801009c2 <consoleintr+0x179>
          input.w = input.e;
801009a0:	a1 68 ff 10 80       	mov    0x8010ff68,%eax
801009a5:	a3 64 ff 10 80       	mov    %eax,0x8010ff64
          wakeup(&input.r);
801009aa:	83 ec 0c             	sub    $0xc,%esp
801009ad:	68 60 ff 10 80       	push   $0x8010ff60
801009b2:	e8 ae 43 00 00       	call   80104d65 <wakeup>
801009b7:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009ba:	eb 06                	jmp    801009c2 <consoleintr+0x179>
      break;
801009bc:	90                   	nop
801009bd:	eb 04                	jmp    801009c3 <consoleintr+0x17a>
      break;
801009bf:	90                   	nop
801009c0:	eb 01                	jmp    801009c3 <consoleintr+0x17a>
      break;
801009c2:	90                   	nop
  while((c = getc()) >= 0){
801009c3:	8b 45 08             	mov    0x8(%ebp),%eax
801009c6:	ff d0                	call   *%eax
801009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009cf:	0f 89 96 fe ff ff    	jns    8010086b <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009d5:	83 ec 0c             	sub    $0xc,%esp
801009d8:	68 80 ff 10 80       	push   $0x8010ff80
801009dd:	e8 4b 47 00 00       	call   8010512d <release>
801009e2:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009e9:	74 05                	je     801009f0 <consoleintr+0x1a7>
    procdump();  // now call procdump() wo. cons.lock held
801009eb:	e8 30 44 00 00       	call   80104e20 <procdump>
  }
}
801009f0:	90                   	nop
801009f1:	c9                   	leave
801009f2:	c3                   	ret

801009f3 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009f3:	55                   	push   %ebp
801009f4:	89 e5                	mov    %esp,%ebp
801009f6:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009f9:	83 ec 0c             	sub    $0xc,%esp
801009fc:	ff 75 08             	push   0x8(%ebp)
801009ff:	e8 2b 11 00 00       	call   80101b2f <iunlock>
80100a04:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a07:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a0d:	83 ec 0c             	sub    $0xc,%esp
80100a10:	68 80 ff 10 80       	push   $0x8010ff80
80100a15:	e8 a5 46 00 00       	call   801050bf <acquire>
80100a1a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a1d:	e9 ab 00 00 00       	jmp    80100acd <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
80100a22:	e8 ae 39 00 00       	call   801043d5 <myproc>
80100a27:	8b 40 24             	mov    0x24(%eax),%eax
80100a2a:	85 c0                	test   %eax,%eax
80100a2c:	74 28                	je     80100a56 <consoleread+0x63>
        release(&cons.lock);
80100a2e:	83 ec 0c             	sub    $0xc,%esp
80100a31:	68 80 ff 10 80       	push   $0x8010ff80
80100a36:	e8 f2 46 00 00       	call   8010512d <release>
80100a3b:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	ff 75 08             	push   0x8(%ebp)
80100a44:	e8 d3 0f 00 00       	call   80101a1c <ilock>
80100a49:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a51:	e9 ab 00 00 00       	jmp    80100b01 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a56:	83 ec 08             	sub    $0x8,%esp
80100a59:	68 80 ff 10 80       	push   $0x8010ff80
80100a5e:	68 60 ff 10 80       	push   $0x8010ff60
80100a63:	e8 16 42 00 00       	call   80104c7e <sleep>
80100a68:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a6b:	8b 15 60 ff 10 80    	mov    0x8010ff60,%edx
80100a71:	a1 64 ff 10 80       	mov    0x8010ff64,%eax
80100a76:	39 c2                	cmp    %eax,%edx
80100a78:	74 a8                	je     80100a22 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a7a:	a1 60 ff 10 80       	mov    0x8010ff60,%eax
80100a7f:	8d 50 01             	lea    0x1(%eax),%edx
80100a82:	89 15 60 ff 10 80    	mov    %edx,0x8010ff60
80100a88:	83 e0 7f             	and    $0x7f,%eax
80100a8b:	0f b6 80 e0 fe 10 80 	movzbl -0x7fef0120(%eax),%eax
80100a92:	0f be c0             	movsbl %al,%eax
80100a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a98:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a9c:	75 17                	jne    80100ab5 <consoleread+0xc2>
      if(n < target){
80100a9e:	8b 45 10             	mov    0x10(%ebp),%eax
80100aa1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aa4:	73 2f                	jae    80100ad5 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aa6:	a1 60 ff 10 80       	mov    0x8010ff60,%eax
80100aab:	83 e8 01             	sub    $0x1,%eax
80100aae:	a3 60 ff 10 80       	mov    %eax,0x8010ff60
      }
      break;
80100ab3:	eb 20                	jmp    80100ad5 <consoleread+0xe2>
    }
    *dst++ = c;
80100ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab8:	8d 50 01             	lea    0x1(%eax),%edx
80100abb:	89 55 0c             	mov    %edx,0xc(%ebp)
80100abe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100ac1:	88 10                	mov    %dl,(%eax)
    --n;
80100ac3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100ac7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100acb:	74 0b                	je     80100ad8 <consoleread+0xe5>
  while(n > 0){
80100acd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ad1:	7f 98                	jg     80100a6b <consoleread+0x78>
80100ad3:	eb 04                	jmp    80100ad9 <consoleread+0xe6>
      break;
80100ad5:	90                   	nop
80100ad6:	eb 01                	jmp    80100ad9 <consoleread+0xe6>
      break;
80100ad8:	90                   	nop
  }
  release(&cons.lock);
80100ad9:	83 ec 0c             	sub    $0xc,%esp
80100adc:	68 80 ff 10 80       	push   $0x8010ff80
80100ae1:	e8 47 46 00 00       	call   8010512d <release>
80100ae6:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ae9:	83 ec 0c             	sub    $0xc,%esp
80100aec:	ff 75 08             	push   0x8(%ebp)
80100aef:	e8 28 0f 00 00       	call   80101a1c <ilock>
80100af4:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100af7:	8b 45 10             	mov    0x10(%ebp),%eax
80100afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100afd:	29 c2                	sub    %eax,%edx
80100aff:	89 d0                	mov    %edx,%eax
}
80100b01:	c9                   	leave
80100b02:	c3                   	ret

80100b03 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b03:	55                   	push   %ebp
80100b04:	89 e5                	mov    %esp,%ebp
80100b06:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b09:	83 ec 0c             	sub    $0xc,%esp
80100b0c:	ff 75 08             	push   0x8(%ebp)
80100b0f:	e8 1b 10 00 00       	call   80101b2f <iunlock>
80100b14:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b17:	83 ec 0c             	sub    $0xc,%esp
80100b1a:	68 80 ff 10 80       	push   $0x8010ff80
80100b1f:	e8 9b 45 00 00       	call   801050bf <acquire>
80100b24:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b2e:	eb 21                	jmp    80100b51 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b33:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b36:	01 d0                	add    %edx,%eax
80100b38:	0f b6 00             	movzbl (%eax),%eax
80100b3b:	0f be c0             	movsbl %al,%eax
80100b3e:	0f b6 c0             	movzbl %al,%eax
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	50                   	push   %eax
80100b45:	e8 97 fc ff ff       	call   801007e1 <consputc>
80100b4a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b54:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b57:	7c d7                	jl     80100b30 <consolewrite+0x2d>
  release(&cons.lock);
80100b59:	83 ec 0c             	sub    $0xc,%esp
80100b5c:	68 80 ff 10 80       	push   $0x8010ff80
80100b61:	e8 c7 45 00 00       	call   8010512d <release>
80100b66:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff 75 08             	push   0x8(%ebp)
80100b6f:	e8 a8 0e 00 00       	call   80101a1c <ilock>
80100b74:	83 c4 10             	add    $0x10,%esp

  return n;
80100b77:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b7a:	c9                   	leave
80100b7b:	c3                   	ret

80100b7c <consoleinit>:

void
consoleinit(void)
{
80100b7c:	55                   	push   %ebp
80100b7d:	89 e5                	mov    %esp,%ebp
80100b7f:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b82:	83 ec 08             	sub    $0x8,%esp
80100b85:	68 c6 86 10 80       	push   $0x801086c6
80100b8a:	68 80 ff 10 80       	push   $0x8010ff80
80100b8f:	e8 09 45 00 00       	call   8010509d <initlock>
80100b94:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b97:	c7 05 cc ff 10 80 03 	movl   $0x80100b03,0x8010ffcc
80100b9e:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba1:	c7 05 c8 ff 10 80 f3 	movl   $0x801009f3,0x8010ffc8
80100ba8:	09 10 80 
  cons.locking = 1;
80100bab:	c7 05 b4 ff 10 80 01 	movl   $0x1,0x8010ffb4
80100bb2:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100bb5:	83 ec 08             	sub    $0x8,%esp
80100bb8:	6a 00                	push   $0x0
80100bba:	6a 01                	push   $0x1
80100bbc:	e8 63 1f 00 00       	call   80102b24 <ioapicenable>
80100bc1:	83 c4 10             	add    $0x10,%esp
}
80100bc4:	90                   	nop
80100bc5:	c9                   	leave
80100bc6:	c3                   	ret

80100bc7 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bc7:	55                   	push   %ebp
80100bc8:	89 e5                	mov    %esp,%ebp
80100bca:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bd0:	e8 00 38 00 00       	call   801043d5 <myproc>
80100bd5:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bd8:	e8 95 2a 00 00       	call   80103672 <begin_op>

  if((ip = namei(path)) == 0){
80100bdd:	83 ec 0c             	sub    $0xc,%esp
80100be0:	ff 75 08             	push   0x8(%ebp)
80100be3:	e8 67 19 00 00       	call   8010254f <namei>
80100be8:	83 c4 10             	add    $0x10,%esp
80100beb:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bf2:	75 1f                	jne    80100c13 <exec+0x4c>
    end_op();
80100bf4:	e8 05 2b 00 00       	call   801036fe <end_op>
    cprintf("exec: fail\n");
80100bf9:	83 ec 0c             	sub    $0xc,%esp
80100bfc:	68 ce 86 10 80       	push   $0x801086ce
80100c01:	e8 f8 f7 ff ff       	call   801003fe <cprintf>
80100c06:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0e:	e9 f1 03 00 00       	jmp    80101004 <exec+0x43d>
  }
  ilock(ip);
80100c13:	83 ec 0c             	sub    $0xc,%esp
80100c16:	ff 75 d8             	push   -0x28(%ebp)
80100c19:	e8 fe 0d 00 00       	call   80101a1c <ilock>
80100c1e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c28:	6a 34                	push   $0x34
80100c2a:	6a 00                	push   $0x0
80100c2c:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c32:	50                   	push   %eax
80100c33:	ff 75 d8             	push   -0x28(%ebp)
80100c36:	e8 cd 12 00 00       	call   80101f08 <readi>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	83 f8 34             	cmp    $0x34,%eax
80100c41:	0f 85 66 03 00 00    	jne    80100fad <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c47:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c4d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c52:	0f 85 58 03 00 00    	jne    80100fb0 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c58:	e8 ee 6f 00 00       	call   80107c4b <setupkvm>
80100c5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c60:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c64:	0f 84 49 03 00 00    	je     80100fb3 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c78:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c81:	e9 de 00 00 00       	jmp    80100d64 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c89:	6a 20                	push   $0x20
80100c8b:	50                   	push   %eax
80100c8c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c92:	50                   	push   %eax
80100c93:	ff 75 d8             	push   -0x28(%ebp)
80100c96:	e8 6d 12 00 00       	call   80101f08 <readi>
80100c9b:	83 c4 10             	add    $0x10,%esp
80100c9e:	83 f8 20             	cmp    $0x20,%eax
80100ca1:	0f 85 0f 03 00 00    	jne    80100fb6 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ca7:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100cad:	83 f8 01             	cmp    $0x1,%eax
80100cb0:	0f 85 a0 00 00 00    	jne    80100d56 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100cb6:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cbc:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cc2:	39 c2                	cmp    %eax,%edx
80100cc4:	0f 82 ef 02 00 00    	jb     80100fb9 <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cd0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cd6:	01 c2                	add    %eax,%edx
80100cd8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cde:	39 c2                	cmp    %eax,%edx
80100ce0:	0f 82 d6 02 00 00    	jb     80100fbc <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ce6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cf2:	01 d0                	add    %edx,%eax
80100cf4:	83 ec 04             	sub    $0x4,%esp
80100cf7:	50                   	push   %eax
80100cf8:	ff 75 e0             	push   -0x20(%ebp)
80100cfb:	ff 75 d4             	push   -0x2c(%ebp)
80100cfe:	e8 ee 72 00 00       	call   80107ff1 <allocuvm>
80100d03:	83 c4 10             	add    $0x10,%esp
80100d06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d0d:	0f 84 ac 02 00 00    	je     80100fbf <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d13:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d19:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d1e:	85 c0                	test   %eax,%eax
80100d20:	0f 85 9c 02 00 00    	jne    80100fc2 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d26:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d2c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d32:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d38:	83 ec 0c             	sub    $0xc,%esp
80100d3b:	52                   	push   %edx
80100d3c:	50                   	push   %eax
80100d3d:	ff 75 d8             	push   -0x28(%ebp)
80100d40:	51                   	push   %ecx
80100d41:	ff 75 d4             	push   -0x2c(%ebp)
80100d44:	e8 db 71 00 00       	call   80107f24 <loaduvm>
80100d49:	83 c4 20             	add    $0x20,%esp
80100d4c:	85 c0                	test   %eax,%eax
80100d4e:	0f 88 71 02 00 00    	js     80100fc5 <exec+0x3fe>
80100d54:	eb 01                	jmp    80100d57 <exec+0x190>
      continue;
80100d56:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d57:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d5e:	83 c0 20             	add    $0x20,%eax
80100d61:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d64:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d6b:	0f b7 c0             	movzwl %ax,%eax
80100d6e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d71:	0f 8c 0f ff ff ff    	jl     80100c86 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	ff 75 d8             	push   -0x28(%ebp)
80100d7d:	e8 cb 0e 00 00       	call   80101c4d <iunlockput>
80100d82:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d85:	e8 74 29 00 00       	call   801036fe <end_op>
  ip = 0;
80100d8a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d94:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da4:	05 00 20 00 00       	add    $0x2000,%eax
80100da9:	83 ec 04             	sub    $0x4,%esp
80100dac:	50                   	push   %eax
80100dad:	ff 75 e0             	push   -0x20(%ebp)
80100db0:	ff 75 d4             	push   -0x2c(%ebp)
80100db3:	e8 39 72 00 00       	call   80107ff1 <allocuvm>
80100db8:	83 c4 10             	add    $0x10,%esp
80100dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dc2:	0f 84 00 02 00 00    	je     80100fc8 <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dcb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dd0:	83 ec 08             	sub    $0x8,%esp
80100dd3:	50                   	push   %eax
80100dd4:	ff 75 d4             	push   -0x2c(%ebp)
80100dd7:	e8 77 74 00 00       	call   80108253 <clearpteu>
80100ddc:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100de2:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dec:	e9 96 00 00 00       	jmp    80100e87 <exec+0x2c0>
    if(argc >= MAXARG)
80100df1:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df5:	0f 87 d0 01 00 00    	ja     80100fcb <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e08:	01 d0                	add    %edx,%eax
80100e0a:	8b 00                	mov    (%eax),%eax
80100e0c:	83 ec 0c             	sub    $0xc,%esp
80100e0f:	50                   	push   %eax
80100e10:	e8 7e 47 00 00       	call   80105593 <strlen>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	89 c2                	mov    %eax,%edx
80100e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1d:	29 d0                	sub    %edx,%eax
80100e1f:	83 e8 01             	sub    $0x1,%eax
80100e22:	83 e0 fc             	and    $0xfffffffc,%eax
80100e25:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e32:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e35:	01 d0                	add    %edx,%eax
80100e37:	8b 00                	mov    (%eax),%eax
80100e39:	83 ec 0c             	sub    $0xc,%esp
80100e3c:	50                   	push   %eax
80100e3d:	e8 51 47 00 00       	call   80105593 <strlen>
80100e42:	83 c4 10             	add    $0x10,%esp
80100e45:	83 c0 01             	add    $0x1,%eax
80100e48:	89 c1                	mov    %eax,%ecx
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e57:	01 d0                	add    %edx,%eax
80100e59:	8b 00                	mov    (%eax),%eax
80100e5b:	51                   	push   %ecx
80100e5c:	50                   	push   %eax
80100e5d:	ff 75 dc             	push   -0x24(%ebp)
80100e60:	ff 75 d4             	push   -0x2c(%ebp)
80100e63:	e8 96 75 00 00       	call   801083fe <copyout>
80100e68:	83 c4 10             	add    $0x10,%esp
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	0f 88 5b 01 00 00    	js     80100fce <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e76:	8d 50 03             	lea    0x3(%eax),%edx
80100e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e7c:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e83:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e94:	01 d0                	add    %edx,%eax
80100e96:	8b 00                	mov    (%eax),%eax
80100e98:	85 c0                	test   %eax,%eax
80100e9a:	0f 85 51 ff ff ff    	jne    80100df1 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea3:	83 c0 03             	add    $0x3,%eax
80100ea6:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100ead:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eb1:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100eb8:	ff ff ff 
  ustack[1] = argc;
80100ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebe:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec7:	83 c0 01             	add    $0x1,%eax
80100eca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed4:	29 d0                	sub    %edx,%eax
80100ed6:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edf:	83 c0 04             	add    $0x4,%eax
80100ee2:	c1 e0 02             	shl    $0x2,%eax
80100ee5:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eeb:	83 c0 04             	add    $0x4,%eax
80100eee:	c1 e0 02             	shl    $0x2,%eax
80100ef1:	50                   	push   %eax
80100ef2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ef8:	50                   	push   %eax
80100ef9:	ff 75 dc             	push   -0x24(%ebp)
80100efc:	ff 75 d4             	push   -0x2c(%ebp)
80100eff:	e8 fa 74 00 00       	call   801083fe <copyout>
80100f04:	83 c4 10             	add    $0x10,%esp
80100f07:	85 c0                	test   %eax,%eax
80100f09:	0f 88 c2 00 00 00    	js     80100fd1 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f1b:	eb 17                	jmp    80100f34 <exec+0x36d>
    if(*s == '/')
80100f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f20:	0f b6 00             	movzbl (%eax),%eax
80100f23:	3c 2f                	cmp    $0x2f,%al
80100f25:	75 09                	jne    80100f30 <exec+0x369>
      last = s+1;
80100f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f2a:	83 c0 01             	add    $0x1,%eax
80100f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f37:	0f b6 00             	movzbl (%eax),%eax
80100f3a:	84 c0                	test   %al,%al
80100f3c:	75 df                	jne    80100f1d <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f41:	83 c0 6c             	add    $0x6c,%eax
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	6a 10                	push   $0x10
80100f49:	ff 75 f0             	push   -0x10(%ebp)
80100f4c:	50                   	push   %eax
80100f4d:	e8 f6 45 00 00       	call   80105548 <safestrcpy>
80100f52:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f55:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f58:	8b 40 04             	mov    0x4(%eax),%eax
80100f5b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f64:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f67:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f6d:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f72:	8b 40 18             	mov    0x18(%eax),%eax
80100f75:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f7b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f81:	8b 40 18             	mov    0x18(%eax),%eax
80100f84:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f87:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	ff 75 d0             	push   -0x30(%ebp)
80100f90:	e8 80 6d 00 00       	call   80107d15 <switchuvm>
80100f95:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 75 cc             	push   -0x34(%ebp)
80100f9e:	e8 17 72 00 00       	call   801081ba <freevm>
80100fa3:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80100fab:	eb 57                	jmp    80101004 <exec+0x43d>
    goto bad;
80100fad:	90                   	nop
80100fae:	eb 22                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fb0:	90                   	nop
80100fb1:	eb 1f                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fb3:	90                   	nop
80100fb4:	eb 1c                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fb6:	90                   	nop
80100fb7:	eb 19                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fb9:	90                   	nop
80100fba:	eb 16                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fbc:	90                   	nop
80100fbd:	eb 13                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fbf:	90                   	nop
80100fc0:	eb 10                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fc2:	90                   	nop
80100fc3:	eb 0d                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fc5:	90                   	nop
80100fc6:	eb 0a                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fc8:	90                   	nop
80100fc9:	eb 07                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fcb:	90                   	nop
80100fcc:	eb 04                	jmp    80100fd2 <exec+0x40b>
      goto bad;
80100fce:	90                   	nop
80100fcf:	eb 01                	jmp    80100fd2 <exec+0x40b>
    goto bad;
80100fd1:	90                   	nop

 bad:
  if(pgdir)
80100fd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fd6:	74 0e                	je     80100fe6 <exec+0x41f>
    freevm(pgdir);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 75 d4             	push   -0x2c(%ebp)
80100fde:	e8 d7 71 00 00       	call   801081ba <freevm>
80100fe3:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fe6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fea:	74 13                	je     80100fff <exec+0x438>
    iunlockput(ip);
80100fec:	83 ec 0c             	sub    $0xc,%esp
80100fef:	ff 75 d8             	push   -0x28(%ebp)
80100ff2:	e8 56 0c 00 00       	call   80101c4d <iunlockput>
80100ff7:	83 c4 10             	add    $0x10,%esp
    end_op();
80100ffa:	e8 ff 26 00 00       	call   801036fe <end_op>
  }
  return -1;
80100fff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101004:	c9                   	leave
80101005:	c3                   	ret

80101006 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101006:	55                   	push   %ebp
80101007:	89 e5                	mov    %esp,%ebp
80101009:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010100c:	83 ec 08             	sub    $0x8,%esp
8010100f:	68 da 86 10 80       	push   $0x801086da
80101014:	68 20 00 11 80       	push   $0x80110020
80101019:	e8 7f 40 00 00       	call   8010509d <initlock>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	90                   	nop
80101022:	c9                   	leave
80101023:	c3                   	ret

80101024 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	68 20 00 11 80       	push   $0x80110020
80101032:	e8 88 40 00 00       	call   801050bf <acquire>
80101037:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103a:	c7 45 f4 54 00 11 80 	movl   $0x80110054,-0xc(%ebp)
80101041:	eb 2d                	jmp    80101070 <filealloc+0x4c>
    if(f->ref == 0){
80101043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101046:	8b 40 04             	mov    0x4(%eax),%eax
80101049:	85 c0                	test   %eax,%eax
8010104b:	75 1f                	jne    8010106c <filealloc+0x48>
      f->ref = 1;
8010104d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101050:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	68 20 00 11 80       	push   $0x80110020
8010105f:	e8 c9 40 00 00       	call   8010512d <release>
80101064:	83 c4 10             	add    $0x10,%esp
      return f;
80101067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010106a:	eb 23                	jmp    8010108f <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010106c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101070:	b8 b4 09 11 80       	mov    $0x801109b4,%eax
80101075:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101078:	72 c9                	jb     80101043 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010107a:	83 ec 0c             	sub    $0xc,%esp
8010107d:	68 20 00 11 80       	push   $0x80110020
80101082:	e8 a6 40 00 00       	call   8010512d <release>
80101087:	83 c4 10             	add    $0x10,%esp
  return 0;
8010108a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010108f:	c9                   	leave
80101090:	c3                   	ret

80101091 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101091:	55                   	push   %ebp
80101092:	89 e5                	mov    %esp,%ebp
80101094:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 20 00 11 80       	push   $0x80110020
8010109f:	e8 1b 40 00 00       	call   801050bf <acquire>
801010a4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	8b 40 04             	mov    0x4(%eax),%eax
801010ad:	85 c0                	test   %eax,%eax
801010af:	7f 0d                	jg     801010be <filedup+0x2d>
    panic("filedup");
801010b1:	83 ec 0c             	sub    $0xc,%esp
801010b4:	68 e1 86 10 80       	push   $0x801086e1
801010b9:	e8 f5 f4 ff ff       	call   801005b3 <panic>
  f->ref++;
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
801010c1:	8b 40 04             	mov    0x4(%eax),%eax
801010c4:	8d 50 01             	lea    0x1(%eax),%edx
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	68 20 00 11 80       	push   $0x80110020
801010d5:	e8 53 40 00 00       	call   8010512d <release>
801010da:	83 c4 10             	add    $0x10,%esp
  return f;
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010e0:	c9                   	leave
801010e1:	c3                   	ret

801010e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e2:	55                   	push   %ebp
801010e3:	89 e5                	mov    %esp,%ebp
801010e5:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	68 20 00 11 80       	push   $0x80110020
801010f0:	e8 ca 3f 00 00       	call   801050bf <acquire>
801010f5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	8b 40 04             	mov    0x4(%eax),%eax
801010fe:	85 c0                	test   %eax,%eax
80101100:	7f 0d                	jg     8010110f <fileclose+0x2d>
    panic("fileclose");
80101102:	83 ec 0c             	sub    $0xc,%esp
80101105:	68 e9 86 10 80       	push   $0x801086e9
8010110a:	e8 a4 f4 ff ff       	call   801005b3 <panic>
  if(--f->ref > 0){
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	8b 40 04             	mov    0x4(%eax),%eax
80101115:	8d 50 ff             	lea    -0x1(%eax),%edx
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	89 50 04             	mov    %edx,0x4(%eax)
8010111e:	8b 45 08             	mov    0x8(%ebp),%eax
80101121:	8b 40 04             	mov    0x4(%eax),%eax
80101124:	85 c0                	test   %eax,%eax
80101126:	7e 15                	jle    8010113d <fileclose+0x5b>
    release(&ftable.lock);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	68 20 00 11 80       	push   $0x80110020
80101130:	e8 f8 3f 00 00       	call   8010512d <release>
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	e9 8b 00 00 00       	jmp    801011c8 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010113d:	8b 45 08             	mov    0x8(%ebp),%eax
80101140:	8b 10                	mov    (%eax),%edx
80101142:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101145:	8b 50 04             	mov    0x4(%eax),%edx
80101148:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010114b:	8b 50 08             	mov    0x8(%eax),%edx
8010114e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101151:	8b 50 0c             	mov    0xc(%eax),%edx
80101154:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101157:	8b 50 10             	mov    0x10(%eax),%edx
8010115a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010115d:	8b 40 14             	mov    0x14(%eax),%eax
80101160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	68 20 00 11 80       	push   $0x80110020
8010117e:	e8 aa 3f 00 00       	call   8010512d <release>
80101183:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101186:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101189:	83 f8 01             	cmp    $0x1,%eax
8010118c:	75 19                	jne    801011a7 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010118e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101192:	0f be d0             	movsbl %al,%edx
80101195:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101198:	83 ec 08             	sub    $0x8,%esp
8010119b:	52                   	push   %edx
8010119c:	50                   	push   %eax
8010119d:	e8 c2 2e 00 00       	call   80104064 <pipeclose>
801011a2:	83 c4 10             	add    $0x10,%esp
801011a5:	eb 21                	jmp    801011c8 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011aa:	83 f8 02             	cmp    $0x2,%eax
801011ad:	75 19                	jne    801011c8 <fileclose+0xe6>
    begin_op();
801011af:	e8 be 24 00 00       	call   80103672 <begin_op>
    iput(ff.ip);
801011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011b7:	83 ec 0c             	sub    $0xc,%esp
801011ba:	50                   	push   %eax
801011bb:	e8 bd 09 00 00       	call   80101b7d <iput>
801011c0:	83 c4 10             	add    $0x10,%esp
    end_op();
801011c3:	e8 36 25 00 00       	call   801036fe <end_op>
  }
}
801011c8:	c9                   	leave
801011c9:	c3                   	ret

801011ca <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011ca:	55                   	push   %ebp
801011cb:	89 e5                	mov    %esp,%ebp
801011cd:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011d0:	8b 45 08             	mov    0x8(%ebp),%eax
801011d3:	8b 00                	mov    (%eax),%eax
801011d5:	83 f8 02             	cmp    $0x2,%eax
801011d8:	75 40                	jne    8010121a <filestat+0x50>
    ilock(f->ip);
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 40 10             	mov    0x10(%eax),%eax
801011e0:	83 ec 0c             	sub    $0xc,%esp
801011e3:	50                   	push   %eax
801011e4:	e8 33 08 00 00       	call   80101a1c <ilock>
801011e9:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 40 10             	mov    0x10(%eax),%eax
801011f2:	83 ec 08             	sub    $0x8,%esp
801011f5:	ff 75 0c             	push   0xc(%ebp)
801011f8:	50                   	push   %eax
801011f9:	e8 c4 0c 00 00       	call   80101ec2 <stati>
801011fe:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	8b 40 10             	mov    0x10(%eax),%eax
80101207:	83 ec 0c             	sub    $0xc,%esp
8010120a:	50                   	push   %eax
8010120b:	e8 1f 09 00 00       	call   80101b2f <iunlock>
80101210:	83 c4 10             	add    $0x10,%esp
    return 0;
80101213:	b8 00 00 00 00       	mov    $0x0,%eax
80101218:	eb 05                	jmp    8010121f <filestat+0x55>
  }
  return -1;
8010121a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010121f:	c9                   	leave
80101220:	c3                   	ret

80101221 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101221:	55                   	push   %ebp
80101222:	89 e5                	mov    %esp,%ebp
80101224:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010122e:	84 c0                	test   %al,%al
80101230:	75 0a                	jne    8010123c <fileread+0x1b>
    return -1;
80101232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101237:	e9 9b 00 00 00       	jmp    801012d7 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010123c:	8b 45 08             	mov    0x8(%ebp),%eax
8010123f:	8b 00                	mov    (%eax),%eax
80101241:	83 f8 01             	cmp    $0x1,%eax
80101244:	75 1a                	jne    80101260 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101246:	8b 45 08             	mov    0x8(%ebp),%eax
80101249:	8b 40 0c             	mov    0xc(%eax),%eax
8010124c:	83 ec 04             	sub    $0x4,%esp
8010124f:	ff 75 10             	push   0x10(%ebp)
80101252:	ff 75 0c             	push   0xc(%ebp)
80101255:	50                   	push   %eax
80101256:	e8 b6 2f 00 00       	call   80104211 <piperead>
8010125b:	83 c4 10             	add    $0x10,%esp
8010125e:	eb 77                	jmp    801012d7 <fileread+0xb6>
  if(f->type == FD_INODE){
80101260:	8b 45 08             	mov    0x8(%ebp),%eax
80101263:	8b 00                	mov    (%eax),%eax
80101265:	83 f8 02             	cmp    $0x2,%eax
80101268:	75 60                	jne    801012ca <fileread+0xa9>
    ilock(f->ip);
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 40 10             	mov    0x10(%eax),%eax
80101270:	83 ec 0c             	sub    $0xc,%esp
80101273:	50                   	push   %eax
80101274:	e8 a3 07 00 00       	call   80101a1c <ilock>
80101279:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010127c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 50 14             	mov    0x14(%eax),%edx
80101285:	8b 45 08             	mov    0x8(%ebp),%eax
80101288:	8b 40 10             	mov    0x10(%eax),%eax
8010128b:	51                   	push   %ecx
8010128c:	52                   	push   %edx
8010128d:	ff 75 0c             	push   0xc(%ebp)
80101290:	50                   	push   %eax
80101291:	e8 72 0c 00 00       	call   80101f08 <readi>
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010129c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012a0:	7e 11                	jle    801012b3 <fileread+0x92>
      f->off += r;
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 50 14             	mov    0x14(%eax),%edx
801012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ab:	01 c2                	add    %eax,%edx
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 40 10             	mov    0x10(%eax),%eax
801012b9:	83 ec 0c             	sub    $0xc,%esp
801012bc:	50                   	push   %eax
801012bd:	e8 6d 08 00 00       	call   80101b2f <iunlock>
801012c2:	83 c4 10             	add    $0x10,%esp
    return r;
801012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c8:	eb 0d                	jmp    801012d7 <fileread+0xb6>
  }
  panic("fileread");
801012ca:	83 ec 0c             	sub    $0xc,%esp
801012cd:	68 f3 86 10 80       	push   $0x801086f3
801012d2:	e8 dc f2 ff ff       	call   801005b3 <panic>
}
801012d7:	c9                   	leave
801012d8:	c3                   	ret

801012d9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012d9:	55                   	push   %ebp
801012da:	89 e5                	mov    %esp,%ebp
801012dc:	53                   	push   %ebx
801012dd:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012e0:	8b 45 08             	mov    0x8(%ebp),%eax
801012e3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012e7:	84 c0                	test   %al,%al
801012e9:	75 0a                	jne    801012f5 <filewrite+0x1c>
    return -1;
801012eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f0:	e9 1b 01 00 00       	jmp    80101410 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012f5:	8b 45 08             	mov    0x8(%ebp),%eax
801012f8:	8b 00                	mov    (%eax),%eax
801012fa:	83 f8 01             	cmp    $0x1,%eax
801012fd:	75 1d                	jne    8010131c <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101302:	8b 40 0c             	mov    0xc(%eax),%eax
80101305:	83 ec 04             	sub    $0x4,%esp
80101308:	ff 75 10             	push   0x10(%ebp)
8010130b:	ff 75 0c             	push   0xc(%ebp)
8010130e:	50                   	push   %eax
8010130f:	e8 fb 2d 00 00       	call   8010410f <pipewrite>
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	e9 f4 00 00 00       	jmp    80101410 <filewrite+0x137>
  if(f->type == FD_INODE){
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 00                	mov    (%eax),%eax
80101321:	83 f8 02             	cmp    $0x2,%eax
80101324:	0f 85 d9 00 00 00    	jne    80101403 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
8010132a:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101338:	e9 a3 00 00 00       	jmp    801013e0 <filewrite+0x107>
      int n1 = n - i;
8010133d:	8b 45 10             	mov    0x10(%ebp),%eax
80101340:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101343:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101349:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010134c:	7e 06                	jle    80101354 <filewrite+0x7b>
        n1 = max;
8010134e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101351:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101354:	e8 19 23 00 00       	call   80103672 <begin_op>
      ilock(f->ip);
80101359:	8b 45 08             	mov    0x8(%ebp),%eax
8010135c:	8b 40 10             	mov    0x10(%eax),%eax
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	50                   	push   %eax
80101363:	e8 b4 06 00 00       	call   80101a1c <ilock>
80101368:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010136b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 50 14             	mov    0x14(%eax),%edx
80101374:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101377:	8b 45 0c             	mov    0xc(%ebp),%eax
8010137a:	01 c3                	add    %eax,%ebx
8010137c:	8b 45 08             	mov    0x8(%ebp),%eax
8010137f:	8b 40 10             	mov    0x10(%eax),%eax
80101382:	51                   	push   %ecx
80101383:	52                   	push   %edx
80101384:	53                   	push   %ebx
80101385:	50                   	push   %eax
80101386:	e8 d2 0c 00 00       	call   8010205d <writei>
8010138b:	83 c4 10             	add    $0x10,%esp
8010138e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101391:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101395:	7e 11                	jle    801013a8 <filewrite+0xcf>
        f->off += r;
80101397:	8b 45 08             	mov    0x8(%ebp),%eax
8010139a:	8b 50 14             	mov    0x14(%eax),%edx
8010139d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013a0:	01 c2                	add    %eax,%edx
801013a2:	8b 45 08             	mov    0x8(%ebp),%eax
801013a5:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	8b 40 10             	mov    0x10(%eax),%eax
801013ae:	83 ec 0c             	sub    $0xc,%esp
801013b1:	50                   	push   %eax
801013b2:	e8 78 07 00 00       	call   80101b2f <iunlock>
801013b7:	83 c4 10             	add    $0x10,%esp
      end_op();
801013ba:	e8 3f 23 00 00       	call   801036fe <end_op>

      if(r < 0)
801013bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013c3:	78 29                	js     801013ee <filewrite+0x115>
        break;
      if(r != n1)
801013c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013cb:	74 0d                	je     801013da <filewrite+0x101>
        panic("short filewrite");
801013cd:	83 ec 0c             	sub    $0xc,%esp
801013d0:	68 fc 86 10 80       	push   $0x801086fc
801013d5:	e8 d9 f1 ff ff       	call   801005b3 <panic>
      i += r;
801013da:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013dd:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e3:	3b 45 10             	cmp    0x10(%ebp),%eax
801013e6:	0f 8c 51 ff ff ff    	jl     8010133d <filewrite+0x64>
801013ec:	eb 01                	jmp    801013ef <filewrite+0x116>
        break;
801013ee:	90                   	nop
    }
    return i == n ? n : -1;
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f5:	75 05                	jne    801013fc <filewrite+0x123>
801013f7:	8b 45 10             	mov    0x10(%ebp),%eax
801013fa:	eb 14                	jmp    80101410 <filewrite+0x137>
801013fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101401:	eb 0d                	jmp    80101410 <filewrite+0x137>
  }
  panic("filewrite");
80101403:	83 ec 0c             	sub    $0xc,%esp
80101406:	68 0c 87 10 80       	push   $0x8010870c
8010140b:	e8 a3 f1 ff ff       	call   801005b3 <panic>
}
80101410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101413:	c9                   	leave
80101414:	c3                   	ret

80101415 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101415:	55                   	push   %ebp
80101416:	89 e5                	mov    %esp,%ebp
80101418:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010141b:	8b 45 08             	mov    0x8(%ebp),%eax
8010141e:	83 ec 08             	sub    $0x8,%esp
80101421:	6a 01                	push   $0x1
80101423:	50                   	push   %eax
80101424:	e8 a6 ed ff ff       	call   801001cf <bread>
80101429:	83 c4 10             	add    $0x10,%esp
8010142c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101432:	83 c0 5c             	add    $0x5c,%eax
80101435:	83 ec 04             	sub    $0x4,%esp
80101438:	6a 1c                	push   $0x1c
8010143a:	50                   	push   %eax
8010143b:	ff 75 0c             	push   0xc(%ebp)
8010143e:	e8 c1 3f 00 00       	call   80105404 <memmove>
80101443:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101446:	83 ec 0c             	sub    $0xc,%esp
80101449:	ff 75 f4             	push   -0xc(%ebp)
8010144c:	e8 00 ee ff ff       	call   80100251 <brelse>
80101451:	83 c4 10             	add    $0x10,%esp
}
80101454:	90                   	nop
80101455:	c9                   	leave
80101456:	c3                   	ret

80101457 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101457:	55                   	push   %ebp
80101458:	89 e5                	mov    %esp,%ebp
8010145a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010145d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101460:	8b 45 08             	mov    0x8(%ebp),%eax
80101463:	83 ec 08             	sub    $0x8,%esp
80101466:	52                   	push   %edx
80101467:	50                   	push   %eax
80101468:	e8 62 ed ff ff       	call   801001cf <bread>
8010146d:	83 c4 10             	add    $0x10,%esp
80101470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101476:	83 c0 5c             	add    $0x5c,%eax
80101479:	83 ec 04             	sub    $0x4,%esp
8010147c:	68 00 02 00 00       	push   $0x200
80101481:	6a 00                	push   $0x0
80101483:	50                   	push   %eax
80101484:	e8 bc 3e 00 00       	call   80105345 <memset>
80101489:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	ff 75 f4             	push   -0xc(%ebp)
80101492:	e8 14 24 00 00       	call   801038ab <log_write>
80101497:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010149a:	83 ec 0c             	sub    $0xc,%esp
8010149d:	ff 75 f4             	push   -0xc(%ebp)
801014a0:	e8 ac ed ff ff       	call   80100251 <brelse>
801014a5:	83 c4 10             	add    $0x10,%esp
}
801014a8:	90                   	nop
801014a9:	c9                   	leave
801014aa:	c3                   	ret

801014ab <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014ab:	55                   	push   %ebp
801014ac:	89 e5                	mov    %esp,%ebp
801014ae:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014bf:	e9 0b 01 00 00       	jmp    801015cf <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
801014c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014c7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014cd:	85 c0                	test   %eax,%eax
801014cf:	0f 48 c2             	cmovs  %edx,%eax
801014d2:	c1 f8 0c             	sar    $0xc,%eax
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014dc:	01 d0                	add    %edx,%eax
801014de:	83 ec 08             	sub    $0x8,%esp
801014e1:	50                   	push   %eax
801014e2:	ff 75 08             	push   0x8(%ebp)
801014e5:	e8 e5 ec ff ff       	call   801001cf <bread>
801014ea:	83 c4 10             	add    $0x10,%esp
801014ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014f7:	e9 9e 00 00 00       	jmp    8010159a <balloc+0xef>
      m = 1 << (bi % 8);
801014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ff:	83 e0 07             	and    $0x7,%eax
80101502:	ba 01 00 00 00       	mov    $0x1,%edx
80101507:	89 c1                	mov    %eax,%ecx
80101509:	d3 e2                	shl    %cl,%edx
8010150b:	89 d0                	mov    %edx,%eax
8010150d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101513:	8d 50 07             	lea    0x7(%eax),%edx
80101516:	85 c0                	test   %eax,%eax
80101518:	0f 48 c2             	cmovs  %edx,%eax
8010151b:	c1 f8 03             	sar    $0x3,%eax
8010151e:	89 c2                	mov    %eax,%edx
80101520:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101523:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101528:	0f b6 c0             	movzbl %al,%eax
8010152b:	23 45 e8             	and    -0x18(%ebp),%eax
8010152e:	85 c0                	test   %eax,%eax
80101530:	75 64                	jne    80101596 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
80101532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101535:	8d 50 07             	lea    0x7(%eax),%edx
80101538:	85 c0                	test   %eax,%eax
8010153a:	0f 48 c2             	cmovs  %edx,%eax
8010153d:	c1 f8 03             	sar    $0x3,%eax
80101540:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101543:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101548:	89 d1                	mov    %edx,%ecx
8010154a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010154d:	09 ca                	or     %ecx,%edx
8010154f:	89 d1                	mov    %edx,%ecx
80101551:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101554:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	ff 75 ec             	push   -0x14(%ebp)
8010155e:	e8 48 23 00 00       	call   801038ab <log_write>
80101563:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101566:	83 ec 0c             	sub    $0xc,%esp
80101569:	ff 75 ec             	push   -0x14(%ebp)
8010156c:	e8 e0 ec ff ff       	call   80100251 <brelse>
80101571:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101574:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157a:	01 c2                	add    %eax,%edx
8010157c:	8b 45 08             	mov    0x8(%ebp),%eax
8010157f:	83 ec 08             	sub    $0x8,%esp
80101582:	52                   	push   %edx
80101583:	50                   	push   %eax
80101584:	e8 ce fe ff ff       	call   80101457 <bzero>
80101589:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101592:	01 d0                	add    %edx,%eax
80101594:	eb 56                	jmp    801015ec <balloc+0x141>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101596:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010159a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015a1:	7f 17                	jg     801015ba <balloc+0x10f>
801015a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	01 d0                	add    %edx,%eax
801015ab:	89 c2                	mov    %eax,%edx
801015ad:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801015b2:	39 c2                	cmp    %eax,%edx
801015b4:	0f 82 42 ff ff ff    	jb     801014fc <balloc+0x51>
      }
    }
    brelse(bp);
801015ba:	83 ec 0c             	sub    $0xc,%esp
801015bd:	ff 75 ec             	push   -0x14(%ebp)
801015c0:	e8 8c ec ff ff       	call   80100251 <brelse>
801015c5:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015c8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015cf:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d7:	39 c2                	cmp    %eax,%edx
801015d9:	0f 82 e5 fe ff ff    	jb     801014c4 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	68 18 87 10 80       	push   $0x80108718
801015e7:	e8 c7 ef ff ff       	call   801005b3 <panic>
}
801015ec:	c9                   	leave
801015ed:	c3                   	ret

801015ee <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015ee:	55                   	push   %ebp
801015ef:	89 e5                	mov    %esp,%ebp
801015f1:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f7:	c1 e8 0c             	shr    $0xc,%eax
801015fa:	89 c2                	mov    %eax,%edx
801015fc:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101601:	01 c2                	add    %eax,%edx
80101603:	8b 45 08             	mov    0x8(%ebp),%eax
80101606:	83 ec 08             	sub    $0x8,%esp
80101609:	52                   	push   %edx
8010160a:	50                   	push   %eax
8010160b:	e8 bf eb ff ff       	call   801001cf <bread>
80101610:	83 c4 10             	add    $0x10,%esp
80101613:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101616:	8b 45 0c             	mov    0xc(%ebp),%eax
80101619:	25 ff 0f 00 00       	and    $0xfff,%eax
8010161e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101624:	83 e0 07             	and    $0x7,%eax
80101627:	ba 01 00 00 00       	mov    $0x1,%edx
8010162c:	89 c1                	mov    %eax,%ecx
8010162e:	d3 e2                	shl    %cl,%edx
80101630:	89 d0                	mov    %edx,%eax
80101632:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101635:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101638:	8d 50 07             	lea    0x7(%eax),%edx
8010163b:	85 c0                	test   %eax,%eax
8010163d:	0f 48 c2             	cmovs  %edx,%eax
80101640:	c1 f8 03             	sar    $0x3,%eax
80101643:	89 c2                	mov    %eax,%edx
80101645:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101648:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010164d:	0f b6 c0             	movzbl %al,%eax
80101650:	23 45 ec             	and    -0x14(%ebp),%eax
80101653:	85 c0                	test   %eax,%eax
80101655:	75 0d                	jne    80101664 <bfree+0x76>
    panic("freeing free block");
80101657:	83 ec 0c             	sub    $0xc,%esp
8010165a:	68 2e 87 10 80       	push   $0x8010872e
8010165f:	e8 4f ef ff ff       	call   801005b3 <panic>
  bp->data[bi/8] &= ~m;
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	8d 50 07             	lea    0x7(%eax),%edx
8010166a:	85 c0                	test   %eax,%eax
8010166c:	0f 48 c2             	cmovs  %edx,%eax
8010166f:	c1 f8 03             	sar    $0x3,%eax
80101672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101675:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010167a:	89 d1                	mov    %edx,%ecx
8010167c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010167f:	f7 d2                	not    %edx
80101681:	21 ca                	and    %ecx,%edx
80101683:	89 d1                	mov    %edx,%ecx
80101685:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101688:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010168c:	83 ec 0c             	sub    $0xc,%esp
8010168f:	ff 75 f4             	push   -0xc(%ebp)
80101692:	e8 14 22 00 00       	call   801038ab <log_write>
80101697:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010169a:	83 ec 0c             	sub    $0xc,%esp
8010169d:	ff 75 f4             	push   -0xc(%ebp)
801016a0:	e8 ac eb ff ff       	call   80100251 <brelse>
801016a5:	83 c4 10             	add    $0x10,%esp
}
801016a8:	90                   	nop
801016a9:	c9                   	leave
801016aa:	c3                   	ret

801016ab <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016ab:	55                   	push   %ebp
801016ac:	89 e5                	mov    %esp,%ebp
801016ae:	57                   	push   %edi
801016af:	56                   	push   %esi
801016b0:	53                   	push   %ebx
801016b1:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016bb:	83 ec 08             	sub    $0x8,%esp
801016be:	68 41 87 10 80       	push   $0x80108741
801016c3:	68 e0 09 11 80       	push   $0x801109e0
801016c8:	e8 d0 39 00 00       	call   8010509d <initlock>
801016cd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016d7:	eb 2d                	jmp    80101706 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016dc:	89 d0                	mov    %edx,%eax
801016de:	c1 e0 03             	shl    $0x3,%eax
801016e1:	01 d0                	add    %edx,%eax
801016e3:	c1 e0 04             	shl    $0x4,%eax
801016e6:	83 c0 30             	add    $0x30,%eax
801016e9:	05 e0 09 11 80       	add    $0x801109e0,%eax
801016ee:	83 c0 10             	add    $0x10,%eax
801016f1:	83 ec 08             	sub    $0x8,%esp
801016f4:	68 48 87 10 80       	push   $0x80108748
801016f9:	50                   	push   %eax
801016fa:	e8 1b 38 00 00       	call   80104f1a <initsleeplock>
801016ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101702:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101706:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010170a:	7e cd                	jle    801016d9 <iinit+0x2e>
  }

  readsb(dev, &sb);
8010170c:	83 ec 08             	sub    $0x8,%esp
8010170f:	68 c0 09 11 80       	push   $0x801109c0
80101714:	ff 75 08             	push   0x8(%ebp)
80101717:	e8 f9 fc ff ff       	call   80101415 <readsb>
8010171c:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010171f:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101724:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101727:	8b 3d d4 09 11 80    	mov    0x801109d4,%edi
8010172d:	8b 35 d0 09 11 80    	mov    0x801109d0,%esi
80101733:	8b 1d cc 09 11 80    	mov    0x801109cc,%ebx
80101739:	8b 0d c8 09 11 80    	mov    0x801109c8,%ecx
8010173f:	8b 15 c4 09 11 80    	mov    0x801109c4,%edx
80101745:	a1 c0 09 11 80       	mov    0x801109c0,%eax
8010174a:	ff 75 d4             	push   -0x2c(%ebp)
8010174d:	57                   	push   %edi
8010174e:	56                   	push   %esi
8010174f:	53                   	push   %ebx
80101750:	51                   	push   %ecx
80101751:	52                   	push   %edx
80101752:	50                   	push   %eax
80101753:	68 50 87 10 80       	push   $0x80108750
80101758:	e8 a1 ec ff ff       	call   801003fe <cprintf>
8010175d:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101760:	90                   	nop
80101761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5f                   	pop    %edi
80101767:	5d                   	pop    %ebp
80101768:	c3                   	ret

80101769 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101769:	55                   	push   %ebp
8010176a:	89 e5                	mov    %esp,%ebp
8010176c:	83 ec 28             	sub    $0x28,%esp
8010176f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101772:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101776:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010177d:	e9 9e 00 00 00       	jmp    80101820 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101785:	c1 e8 03             	shr    $0x3,%eax
80101788:	89 c2                	mov    %eax,%edx
8010178a:	a1 d4 09 11 80       	mov    0x801109d4,%eax
8010178f:	01 d0                	add    %edx,%eax
80101791:	83 ec 08             	sub    $0x8,%esp
80101794:	50                   	push   %eax
80101795:	ff 75 08             	push   0x8(%ebp)
80101798:	e8 32 ea ff ff       	call   801001cf <bread>
8010179d:	83 c4 10             	add    $0x10,%esp
801017a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a6:	8d 50 5c             	lea    0x5c(%eax),%edx
801017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ac:	83 e0 07             	and    $0x7,%eax
801017af:	c1 e0 06             	shl    $0x6,%eax
801017b2:	01 d0                	add    %edx,%eax
801017b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ba:	0f b7 00             	movzwl (%eax),%eax
801017bd:	66 85 c0             	test   %ax,%ax
801017c0:	75 4c                	jne    8010180e <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017c2:	83 ec 04             	sub    $0x4,%esp
801017c5:	6a 40                	push   $0x40
801017c7:	6a 00                	push   $0x0
801017c9:	ff 75 ec             	push   -0x14(%ebp)
801017cc:	e8 74 3b 00 00       	call   80105345 <memset>
801017d1:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017d7:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017db:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017de:	83 ec 0c             	sub    $0xc,%esp
801017e1:	ff 75 f0             	push   -0x10(%ebp)
801017e4:	e8 c2 20 00 00       	call   801038ab <log_write>
801017e9:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017ec:	83 ec 0c             	sub    $0xc,%esp
801017ef:	ff 75 f0             	push   -0x10(%ebp)
801017f2:	e8 5a ea ff ff       	call   80100251 <brelse>
801017f7:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fd:	83 ec 08             	sub    $0x8,%esp
80101800:	50                   	push   %eax
80101801:	ff 75 08             	push   0x8(%ebp)
80101804:	e8 f7 00 00 00       	call   80101900 <iget>
80101809:	83 c4 10             	add    $0x10,%esp
8010180c:	eb 2f                	jmp    8010183d <ialloc+0xd4>
    }
    brelse(bp);
8010180e:	83 ec 0c             	sub    $0xc,%esp
80101811:	ff 75 f0             	push   -0x10(%ebp)
80101814:	e8 38 ea ff ff       	call   80100251 <brelse>
80101819:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
8010181c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101820:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101825:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101828:	39 c2                	cmp    %eax,%edx
8010182a:	0f 82 52 ff ff ff    	jb     80101782 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101830:	83 ec 0c             	sub    $0xc,%esp
80101833:	68 a3 87 10 80       	push   $0x801087a3
80101838:	e8 76 ed ff ff       	call   801005b3 <panic>
}
8010183d:	c9                   	leave
8010183e:	c3                   	ret

8010183f <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010183f:	55                   	push   %ebp
80101840:	89 e5                	mov    %esp,%ebp
80101842:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101845:	8b 45 08             	mov    0x8(%ebp),%eax
80101848:	8b 40 04             	mov    0x4(%eax),%eax
8010184b:	c1 e8 03             	shr    $0x3,%eax
8010184e:	89 c2                	mov    %eax,%edx
80101850:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101855:	01 c2                	add    %eax,%edx
80101857:	8b 45 08             	mov    0x8(%ebp),%eax
8010185a:	8b 00                	mov    (%eax),%eax
8010185c:	83 ec 08             	sub    $0x8,%esp
8010185f:	52                   	push   %edx
80101860:	50                   	push   %eax
80101861:	e8 69 e9 ff ff       	call   801001cf <bread>
80101866:	83 c4 10             	add    $0x10,%esp
80101869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101872:	8b 45 08             	mov    0x8(%ebp),%eax
80101875:	8b 40 04             	mov    0x4(%eax),%eax
80101878:	83 e0 07             	and    $0x7,%eax
8010187b:	c1 e0 06             	shl    $0x6,%eax
8010187e:	01 d0                	add    %edx,%eax
80101880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101883:	8b 45 08             	mov    0x8(%ebp),%eax
80101886:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189a:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010189e:	8b 45 08             	mov    0x8(%ebp),%eax
801018a1:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a8:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018ac:	8b 45 08             	mov    0x8(%ebp),%eax
801018af:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b6:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018ba:	8b 45 08             	mov    0x8(%ebp),%eax
801018bd:	8b 50 58             	mov    0x58(%eax),%edx
801018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018c6:	8b 45 08             	mov    0x8(%ebp),%eax
801018c9:	8d 50 5c             	lea    0x5c(%eax),%edx
801018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018cf:	83 c0 0c             	add    $0xc,%eax
801018d2:	83 ec 04             	sub    $0x4,%esp
801018d5:	6a 34                	push   $0x34
801018d7:	52                   	push   %edx
801018d8:	50                   	push   %eax
801018d9:	e8 26 3b 00 00       	call   80105404 <memmove>
801018de:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018e1:	83 ec 0c             	sub    $0xc,%esp
801018e4:	ff 75 f4             	push   -0xc(%ebp)
801018e7:	e8 bf 1f 00 00       	call   801038ab <log_write>
801018ec:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018ef:	83 ec 0c             	sub    $0xc,%esp
801018f2:	ff 75 f4             	push   -0xc(%ebp)
801018f5:	e8 57 e9 ff ff       	call   80100251 <brelse>
801018fa:	83 c4 10             	add    $0x10,%esp
}
801018fd:	90                   	nop
801018fe:	c9                   	leave
801018ff:	c3                   	ret

80101900 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101906:	83 ec 0c             	sub    $0xc,%esp
80101909:	68 e0 09 11 80       	push   $0x801109e0
8010190e:	e8 ac 37 00 00       	call   801050bf <acquire>
80101913:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101916:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010191d:	c7 45 f4 14 0a 11 80 	movl   $0x80110a14,-0xc(%ebp)
80101924:	eb 60                	jmp    80101986 <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101929:	8b 40 08             	mov    0x8(%eax),%eax
8010192c:	85 c0                	test   %eax,%eax
8010192e:	7e 39                	jle    80101969 <iget+0x69>
80101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101933:	8b 00                	mov    (%eax),%eax
80101935:	39 45 08             	cmp    %eax,0x8(%ebp)
80101938:	75 2f                	jne    80101969 <iget+0x69>
8010193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193d:	8b 40 04             	mov    0x4(%eax),%eax
80101940:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101943:	75 24                	jne    80101969 <iget+0x69>
      ip->ref++;
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	8b 40 08             	mov    0x8(%eax),%eax
8010194b:	8d 50 01             	lea    0x1(%eax),%edx
8010194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101951:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101954:	83 ec 0c             	sub    $0xc,%esp
80101957:	68 e0 09 11 80       	push   $0x801109e0
8010195c:	e8 cc 37 00 00       	call   8010512d <release>
80101961:	83 c4 10             	add    $0x10,%esp
      return ip;
80101964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101967:	eb 77                	jmp    801019e0 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010196d:	75 10                	jne    8010197f <iget+0x7f>
8010196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101972:	8b 40 08             	mov    0x8(%eax),%eax
80101975:	85 c0                	test   %eax,%eax
80101977:	75 06                	jne    8010197f <iget+0x7f>
      empty = ip;
80101979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010197f:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101986:	81 7d f4 34 26 11 80 	cmpl   $0x80112634,-0xc(%ebp)
8010198d:	72 97                	jb     80101926 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010198f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101993:	75 0d                	jne    801019a2 <iget+0xa2>
    panic("iget: no inodes");
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	68 b5 87 10 80       	push   $0x801087b5
8010199d:	e8 11 ec ff ff       	call   801005b3 <panic>

  ip = empty;
801019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	8b 55 08             	mov    0x8(%ebp),%edx
801019ae:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801019b6:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019bc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019cd:	83 ec 0c             	sub    $0xc,%esp
801019d0:	68 e0 09 11 80       	push   $0x801109e0
801019d5:	e8 53 37 00 00       	call   8010512d <release>
801019da:	83 c4 10             	add    $0x10,%esp

  return ip;
801019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019e0:	c9                   	leave
801019e1:	c3                   	ret

801019e2 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019e2:	55                   	push   %ebp
801019e3:	89 e5                	mov    %esp,%ebp
801019e5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019e8:	83 ec 0c             	sub    $0xc,%esp
801019eb:	68 e0 09 11 80       	push   $0x801109e0
801019f0:	e8 ca 36 00 00       	call   801050bf <acquire>
801019f5:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f8:	8b 45 08             	mov    0x8(%ebp),%eax
801019fb:	8b 40 08             	mov    0x8(%eax),%eax
801019fe:	8d 50 01             	lea    0x1(%eax),%edx
80101a01:	8b 45 08             	mov    0x8(%ebp),%eax
80101a04:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 e0 09 11 80       	push   $0x801109e0
80101a0f:	e8 19 37 00 00       	call   8010512d <release>
80101a14:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a17:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a1a:	c9                   	leave
80101a1b:	c3                   	ret

80101a1c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a1c:	55                   	push   %ebp
80101a1d:	89 e5                	mov    %esp,%ebp
80101a1f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a26:	74 0a                	je     80101a32 <ilock+0x16>
80101a28:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2b:	8b 40 08             	mov    0x8(%eax),%eax
80101a2e:	85 c0                	test   %eax,%eax
80101a30:	7f 0d                	jg     80101a3f <ilock+0x23>
    panic("ilock");
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	68 c5 87 10 80       	push   $0x801087c5
80101a3a:	e8 74 eb ff ff       	call   801005b3 <panic>

  acquiresleep(&ip->lock);
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	83 c0 0c             	add    $0xc,%eax
80101a45:	83 ec 0c             	sub    $0xc,%esp
80101a48:	50                   	push   %eax
80101a49:	e8 08 35 00 00       	call   80104f56 <acquiresleep>
80101a4e:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a57:	85 c0                	test   %eax,%eax
80101a59:	0f 85 cd 00 00 00    	jne    80101b2c <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	8b 40 04             	mov    0x4(%eax),%eax
80101a65:	c1 e8 03             	shr    $0x3,%eax
80101a68:	89 c2                	mov    %eax,%edx
80101a6a:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101a6f:	01 c2                	add    %eax,%edx
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 00                	mov    (%eax),%eax
80101a76:	83 ec 08             	sub    $0x8,%esp
80101a79:	52                   	push   %edx
80101a7a:	50                   	push   %eax
80101a7b:	e8 4f e7 ff ff       	call   801001cf <bread>
80101a80:	83 c4 10             	add    $0x10,%esp
80101a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a89:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8f:	8b 40 04             	mov    0x4(%eax),%eax
80101a92:	83 e0 07             	and    $0x7,%eax
80101a95:	c1 e0 06             	shl    $0x6,%eax
80101a98:	01 d0                	add    %edx,%eax
80101a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa0:	0f b7 10             	movzwl (%eax),%edx
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aad:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abb:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad7:	8b 50 08             	mov    0x8(%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae3:	8d 50 0c             	lea    0xc(%eax),%edx
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	83 c0 5c             	add    $0x5c,%eax
80101aec:	83 ec 04             	sub    $0x4,%esp
80101aef:	6a 34                	push   $0x34
80101af1:	52                   	push   %edx
80101af2:	50                   	push   %eax
80101af3:	e8 0c 39 00 00       	call   80105404 <memmove>
80101af8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101afb:	83 ec 0c             	sub    $0xc,%esp
80101afe:	ff 75 f4             	push   -0xc(%ebp)
80101b01:	e8 4b e7 ff ff       	call   80100251 <brelse>
80101b06:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b1a:	66 85 c0             	test   %ax,%ax
80101b1d:	75 0d                	jne    80101b2c <ilock+0x110>
      panic("ilock: no type");
80101b1f:	83 ec 0c             	sub    $0xc,%esp
80101b22:	68 cb 87 10 80       	push   $0x801087cb
80101b27:	e8 87 ea ff ff       	call   801005b3 <panic>
  }
}
80101b2c:	90                   	nop
80101b2d:	c9                   	leave
80101b2e:	c3                   	ret

80101b2f <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b2f:	55                   	push   %ebp
80101b30:	89 e5                	mov    %esp,%ebp
80101b32:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b39:	74 20                	je     80101b5b <iunlock+0x2c>
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	83 c0 0c             	add    $0xc,%eax
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	50                   	push   %eax
80101b45:	e8 be 34 00 00       	call   80105008 <holdingsleep>
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	74 0a                	je     80101b5b <iunlock+0x2c>
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8b 40 08             	mov    0x8(%eax),%eax
80101b57:	85 c0                	test   %eax,%eax
80101b59:	7f 0d                	jg     80101b68 <iunlock+0x39>
    panic("iunlock");
80101b5b:	83 ec 0c             	sub    $0xc,%esp
80101b5e:	68 da 87 10 80       	push   $0x801087da
80101b63:	e8 4b ea ff ff       	call   801005b3 <panic>

  releasesleep(&ip->lock);
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	83 c0 0c             	add    $0xc,%eax
80101b6e:	83 ec 0c             	sub    $0xc,%esp
80101b71:	50                   	push   %eax
80101b72:	e8 43 34 00 00       	call   80104fba <releasesleep>
80101b77:	83 c4 10             	add    $0x10,%esp
}
80101b7a:	90                   	nop
80101b7b:	c9                   	leave
80101b7c:	c3                   	ret

80101b7d <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b7d:	55                   	push   %ebp
80101b7e:	89 e5                	mov    %esp,%ebp
80101b80:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	83 c0 0c             	add    $0xc,%eax
80101b89:	83 ec 0c             	sub    $0xc,%esp
80101b8c:	50                   	push   %eax
80101b8d:	e8 c4 33 00 00       	call   80104f56 <acquiresleep>
80101b92:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b9b:	85 c0                	test   %eax,%eax
80101b9d:	74 6a                	je     80101c09 <iput+0x8c>
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ba6:	66 85 c0             	test   %ax,%ax
80101ba9:	75 5e                	jne    80101c09 <iput+0x8c>
    acquire(&icache.lock);
80101bab:	83 ec 0c             	sub    $0xc,%esp
80101bae:	68 e0 09 11 80       	push   $0x801109e0
80101bb3:	e8 07 35 00 00       	call   801050bf <acquire>
80101bb8:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	8b 40 08             	mov    0x8(%eax),%eax
80101bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	68 e0 09 11 80       	push   $0x801109e0
80101bcc:	e8 5c 35 00 00       	call   8010512d <release>
80101bd1:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101bd4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bd8:	75 2f                	jne    80101c09 <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bda:	83 ec 0c             	sub    $0xc,%esp
80101bdd:	ff 75 08             	push   0x8(%ebp)
80101be0:	e8 ad 01 00 00       	call   80101d92 <itrunc>
80101be5:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	ff 75 08             	push   0x8(%ebp)
80101bf7:	e8 43 fc ff ff       	call   8010183f <iupdate>
80101bfc:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bff:	8b 45 08             	mov    0x8(%ebp),%eax
80101c02:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	83 c0 0c             	add    $0xc,%eax
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	50                   	push   %eax
80101c13:	e8 a2 33 00 00       	call   80104fba <releasesleep>
80101c18:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
80101c1e:	68 e0 09 11 80       	push   $0x801109e0
80101c23:	e8 97 34 00 00       	call   801050bf <acquire>
80101c28:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2e:	8b 40 08             	mov    0x8(%eax),%eax
80101c31:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	68 e0 09 11 80       	push   $0x801109e0
80101c42:	e8 e6 34 00 00       	call   8010512d <release>
80101c47:	83 c4 10             	add    $0x10,%esp
}
80101c4a:	90                   	nop
80101c4b:	c9                   	leave
80101c4c:	c3                   	ret

80101c4d <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c4d:	55                   	push   %ebp
80101c4e:	89 e5                	mov    %esp,%ebp
80101c50:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c53:	83 ec 0c             	sub    $0xc,%esp
80101c56:	ff 75 08             	push   0x8(%ebp)
80101c59:	e8 d1 fe ff ff       	call   80101b2f <iunlock>
80101c5e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c61:	83 ec 0c             	sub    $0xc,%esp
80101c64:	ff 75 08             	push   0x8(%ebp)
80101c67:	e8 11 ff ff ff       	call   80101b7d <iput>
80101c6c:	83 c4 10             	add    $0x10,%esp
}
80101c6f:	90                   	nop
80101c70:	c9                   	leave
80101c71:	c3                   	ret

80101c72 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c72:	55                   	push   %ebp
80101c73:	89 e5                	mov    %esp,%ebp
80101c75:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c78:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c7c:	77 42                	ja     80101cc0 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c84:	83 c2 14             	add    $0x14,%edx
80101c87:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c92:	75 24                	jne    80101cb8 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 00                	mov    (%eax),%eax
80101c99:	83 ec 0c             	sub    $0xc,%esp
80101c9c:	50                   	push   %eax
80101c9d:	e8 09 f8 ff ff       	call   801014ab <balloc>
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cab:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cae:	8d 4a 14             	lea    0x14(%edx),%ecx
80101cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb4:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cbb:	e9 d0 00 00 00       	jmp    80101d90 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101cc0:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cc4:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cc8:	0f 87 b5 00 00 00    	ja     80101d83 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cde:	75 20                	jne    80101d00 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce3:	8b 00                	mov    (%eax),%eax
80101ce5:	83 ec 0c             	sub    $0xc,%esp
80101ce8:	50                   	push   %eax
80101ce9:	e8 bd f7 ff ff       	call   801014ab <balloc>
80101cee:	83 c4 10             	add    $0x10,%esp
80101cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfa:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 00                	mov    (%eax),%eax
80101d05:	83 ec 08             	sub    $0x8,%esp
80101d08:	ff 75 f4             	push   -0xc(%ebp)
80101d0b:	50                   	push   %eax
80101d0c:	e8 be e4 ff ff       	call   801001cf <bread>
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1a:	83 c0 5c             	add    $0x5c,%eax
80101d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d2d:	01 d0                	add    %edx,%eax
80101d2f:	8b 00                	mov    (%eax),%eax
80101d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d38:	75 36                	jne    80101d70 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3d:	8b 00                	mov    (%eax),%eax
80101d3f:	83 ec 0c             	sub    $0xc,%esp
80101d42:	50                   	push   %eax
80101d43:	e8 63 f7 ff ff       	call   801014ab <balloc>
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d5b:	01 c2                	add    %eax,%edx
80101d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d60:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	ff 75 f0             	push   -0x10(%ebp)
80101d68:	e8 3e 1b 00 00       	call   801038ab <log_write>
80101d6d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d70:	83 ec 0c             	sub    $0xc,%esp
80101d73:	ff 75 f0             	push   -0x10(%ebp)
80101d76:	e8 d6 e4 ff ff       	call   80100251 <brelse>
80101d7b:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d81:	eb 0d                	jmp    80101d90 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d83:	83 ec 0c             	sub    $0xc,%esp
80101d86:	68 e2 87 10 80       	push   $0x801087e2
80101d8b:	e8 23 e8 ff ff       	call   801005b3 <panic>
}
80101d90:	c9                   	leave
80101d91:	c3                   	ret

80101d92 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d92:	55                   	push   %ebp
80101d93:	89 e5                	mov    %esp,%ebp
80101d95:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d9f:	eb 45                	jmp    80101de6 <itrunc+0x54>
    if(ip->addrs[i]){
80101da1:	8b 45 08             	mov    0x8(%ebp),%eax
80101da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da7:	83 c2 14             	add    $0x14,%edx
80101daa:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dae:	85 c0                	test   %eax,%eax
80101db0:	74 30                	je     80101de2 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db8:	83 c2 14             	add    $0x14,%edx
80101dbb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc2:	8b 12                	mov    (%edx),%edx
80101dc4:	83 ec 08             	sub    $0x8,%esp
80101dc7:	50                   	push   %eax
80101dc8:	52                   	push   %edx
80101dc9:	e8 20 f8 ff ff       	call   801015ee <bfree>
80101dce:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dd7:	83 c2 14             	add    $0x14,%edx
80101dda:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101de1:	00 
  for(i = 0; i < NDIRECT; i++){
80101de2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101de6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dea:	7e b5                	jle    80101da1 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101df5:	85 c0                	test   %eax,%eax
80101df7:	0f 84 aa 00 00 00    	je     80101ea7 <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 00                	mov    (%eax),%eax
80101e0b:	83 ec 08             	sub    $0x8,%esp
80101e0e:	52                   	push   %edx
80101e0f:	50                   	push   %eax
80101e10:	e8 ba e3 ff ff       	call   801001cf <bread>
80101e15:	83 c4 10             	add    $0x10,%esp
80101e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e1e:	83 c0 5c             	add    $0x5c,%eax
80101e21:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e2b:	eb 3c                	jmp    80101e69 <itrunc+0xd7>
      if(a[j])
80101e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e3a:	01 d0                	add    %edx,%eax
80101e3c:	8b 00                	mov    (%eax),%eax
80101e3e:	85 c0                	test   %eax,%eax
80101e40:	74 23                	je     80101e65 <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e4f:	01 d0                	add    %edx,%eax
80101e51:	8b 00                	mov    (%eax),%eax
80101e53:	8b 55 08             	mov    0x8(%ebp),%edx
80101e56:	8b 12                	mov    (%edx),%edx
80101e58:	83 ec 08             	sub    $0x8,%esp
80101e5b:	50                   	push   %eax
80101e5c:	52                   	push   %edx
80101e5d:	e8 8c f7 ff ff       	call   801015ee <bfree>
80101e62:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e65:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6c:	83 f8 7f             	cmp    $0x7f,%eax
80101e6f:	76 bc                	jbe    80101e2d <itrunc+0x9b>
    }
    brelse(bp);
80101e71:	83 ec 0c             	sub    $0xc,%esp
80101e74:	ff 75 ec             	push   -0x14(%ebp)
80101e77:	e8 d5 e3 ff ff       	call   80100251 <brelse>
80101e7c:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e88:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8b:	8b 12                	mov    (%edx),%edx
80101e8d:	83 ec 08             	sub    $0x8,%esp
80101e90:	50                   	push   %eax
80101e91:	52                   	push   %edx
80101e92:	e8 57 f7 ff ff       	call   801015ee <bfree>
80101e97:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101ea4:	00 00 00 
  }

  ip->size = 0;
80101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaa:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101eb1:	83 ec 0c             	sub    $0xc,%esp
80101eb4:	ff 75 08             	push   0x8(%ebp)
80101eb7:	e8 83 f9 ff ff       	call   8010183f <iupdate>
80101ebc:	83 c4 10             	add    $0x10,%esp
}
80101ebf:	90                   	nop
80101ec0:	c9                   	leave
80101ec1:	c3                   	ret

80101ec2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ec2:	55                   	push   %ebp
80101ec3:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	8b 00                	mov    (%eax),%eax
80101eca:	89 c2                	mov    %eax,%edx
80101ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecf:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed5:	8b 50 04             	mov    0x4(%eax),%edx
80101ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edb:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee8:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef5:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	8b 50 58             	mov    0x58(%eax),%edx
80101eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f02:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f05:	90                   	nop
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret

80101f08 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f08:	55                   	push   %ebp
80101f09:	89 e5                	mov    %esp,%ebp
80101f0b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f11:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f15:	66 83 f8 03          	cmp    $0x3,%ax
80101f19:	75 5c                	jne    80101f77 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f22:	66 85 c0             	test   %ax,%ax
80101f25:	78 20                	js     80101f47 <readi+0x3f>
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f2e:	66 83 f8 09          	cmp    $0x9,%ax
80101f32:	7f 13                	jg     80101f47 <readi+0x3f>
80101f34:	8b 45 08             	mov    0x8(%ebp),%eax
80101f37:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f3b:	98                   	cwtl
80101f3c:	8b 04 c5 c0 ff 10 80 	mov    -0x7fef0040(,%eax,8),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	75 0a                	jne    80101f51 <readi+0x49>
      return -1;
80101f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4c:	e9 0a 01 00 00       	jmp    8010205b <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f51:	8b 45 08             	mov    0x8(%ebp),%eax
80101f54:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f58:	98                   	cwtl
80101f59:	8b 04 c5 c0 ff 10 80 	mov    -0x7fef0040(,%eax,8),%eax
80101f60:	8b 55 14             	mov    0x14(%ebp),%edx
80101f63:	83 ec 04             	sub    $0x4,%esp
80101f66:	52                   	push   %edx
80101f67:	ff 75 0c             	push   0xc(%ebp)
80101f6a:	ff 75 08             	push   0x8(%ebp)
80101f6d:	ff d0                	call   *%eax
80101f6f:	83 c4 10             	add    $0x10,%esp
80101f72:	e9 e4 00 00 00       	jmp    8010205b <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	8b 40 58             	mov    0x58(%eax),%eax
80101f7d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f80:	72 0d                	jb     80101f8f <readi+0x87>
80101f82:	8b 55 10             	mov    0x10(%ebp),%edx
80101f85:	8b 45 14             	mov    0x14(%ebp),%eax
80101f88:	01 d0                	add    %edx,%eax
80101f8a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f8d:	73 0a                	jae    80101f99 <readi+0x91>
    return -1;
80101f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f94:	e9 c2 00 00 00       	jmp    8010205b <readi+0x153>
  if(off + n > ip->size)
80101f99:	8b 55 10             	mov    0x10(%ebp),%edx
80101f9c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f9f:	01 c2                	add    %eax,%edx
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	8b 40 58             	mov    0x58(%eax),%eax
80101fa7:	39 d0                	cmp    %edx,%eax
80101fa9:	73 0c                	jae    80101fb7 <readi+0xaf>
    n = ip->size - off;
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
80101fae:	8b 40 58             	mov    0x58(%eax),%eax
80101fb1:	2b 45 10             	sub    0x10(%ebp),%eax
80101fb4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fbe:	e9 89 00 00 00       	jmp    8010204c <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc6:	c1 e8 09             	shr    $0x9,%eax
80101fc9:	83 ec 08             	sub    $0x8,%esp
80101fcc:	50                   	push   %eax
80101fcd:	ff 75 08             	push   0x8(%ebp)
80101fd0:	e8 9d fc ff ff       	call   80101c72 <bmap>
80101fd5:	83 c4 10             	add    $0x10,%esp
80101fd8:	8b 55 08             	mov    0x8(%ebp),%edx
80101fdb:	8b 12                	mov    (%edx),%edx
80101fdd:	83 ec 08             	sub    $0x8,%esp
80101fe0:	50                   	push   %eax
80101fe1:	52                   	push   %edx
80101fe2:	e8 e8 e1 ff ff       	call   801001cf <bread>
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fed:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff5:	ba 00 02 00 00       	mov    $0x200,%edx
80101ffa:	29 c2                	sub    %eax,%edx
80101ffc:	8b 45 14             	mov    0x14(%ebp),%eax
80101fff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102002:	39 c2                	cmp    %eax,%edx
80102004:	0f 46 c2             	cmovbe %edx,%eax
80102007:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102010:	8b 45 10             	mov    0x10(%ebp),%eax
80102013:	25 ff 01 00 00       	and    $0x1ff,%eax
80102018:	01 d0                	add    %edx,%eax
8010201a:	83 ec 04             	sub    $0x4,%esp
8010201d:	ff 75 ec             	push   -0x14(%ebp)
80102020:	50                   	push   %eax
80102021:	ff 75 0c             	push   0xc(%ebp)
80102024:	e8 db 33 00 00       	call   80105404 <memmove>
80102029:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	ff 75 f0             	push   -0x10(%ebp)
80102032:	e8 1a e2 ff ff       	call   80100251 <brelse>
80102037:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102040:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102043:	01 45 10             	add    %eax,0x10(%ebp)
80102046:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102049:	01 45 0c             	add    %eax,0xc(%ebp)
8010204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102052:	0f 82 6b ff ff ff    	jb     80101fc3 <readi+0xbb>
  }
  return n;
80102058:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010205b:	c9                   	leave
8010205c:	c3                   	ret

8010205d <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010205d:	55                   	push   %ebp
8010205e:	89 e5                	mov    %esp,%ebp
80102060:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102063:	8b 45 08             	mov    0x8(%ebp),%eax
80102066:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010206a:	66 83 f8 03          	cmp    $0x3,%ax
8010206e:	75 5c                	jne    801020cc <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102070:	8b 45 08             	mov    0x8(%ebp),%eax
80102073:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102077:	66 85 c0             	test   %ax,%ax
8010207a:	78 20                	js     8010209c <writei+0x3f>
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102083:	66 83 f8 09          	cmp    $0x9,%ax
80102087:	7f 13                	jg     8010209c <writei+0x3f>
80102089:	8b 45 08             	mov    0x8(%ebp),%eax
8010208c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102090:	98                   	cwtl
80102091:	8b 04 c5 c4 ff 10 80 	mov    -0x7fef003c(,%eax,8),%eax
80102098:	85 c0                	test   %eax,%eax
8010209a:	75 0a                	jne    801020a6 <writei+0x49>
      return -1;
8010209c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a1:	e9 3b 01 00 00       	jmp    801021e1 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
801020a6:	8b 45 08             	mov    0x8(%ebp),%eax
801020a9:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020ad:	98                   	cwtl
801020ae:	8b 04 c5 c4 ff 10 80 	mov    -0x7fef003c(,%eax,8),%eax
801020b5:	8b 55 14             	mov    0x14(%ebp),%edx
801020b8:	83 ec 04             	sub    $0x4,%esp
801020bb:	52                   	push   %edx
801020bc:	ff 75 0c             	push   0xc(%ebp)
801020bf:	ff 75 08             	push   0x8(%ebp)
801020c2:	ff d0                	call   *%eax
801020c4:	83 c4 10             	add    $0x10,%esp
801020c7:	e9 15 01 00 00       	jmp    801021e1 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	8b 40 58             	mov    0x58(%eax),%eax
801020d2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d5:	72 0d                	jb     801020e4 <writei+0x87>
801020d7:	8b 55 10             	mov    0x10(%ebp),%edx
801020da:	8b 45 14             	mov    0x14(%ebp),%eax
801020dd:	01 d0                	add    %edx,%eax
801020df:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e2:	73 0a                	jae    801020ee <writei+0x91>
    return -1;
801020e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e9:	e9 f3 00 00 00       	jmp    801021e1 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020ee:	8b 55 10             	mov    0x10(%ebp),%edx
801020f1:	8b 45 14             	mov    0x14(%ebp),%eax
801020f4:	01 d0                	add    %edx,%eax
801020f6:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020fb:	76 0a                	jbe    80102107 <writei+0xaa>
    return -1;
801020fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102102:	e9 da 00 00 00       	jmp    801021e1 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010210e:	e9 97 00 00 00       	jmp    801021aa <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	c1 e8 09             	shr    $0x9,%eax
80102119:	83 ec 08             	sub    $0x8,%esp
8010211c:	50                   	push   %eax
8010211d:	ff 75 08             	push   0x8(%ebp)
80102120:	e8 4d fb ff ff       	call   80101c72 <bmap>
80102125:	83 c4 10             	add    $0x10,%esp
80102128:	8b 55 08             	mov    0x8(%ebp),%edx
8010212b:	8b 12                	mov    (%edx),%edx
8010212d:	83 ec 08             	sub    $0x8,%esp
80102130:	50                   	push   %eax
80102131:	52                   	push   %edx
80102132:	e8 98 e0 ff ff       	call   801001cf <bread>
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010213d:	8b 45 10             	mov    0x10(%ebp),%eax
80102140:	25 ff 01 00 00       	and    $0x1ff,%eax
80102145:	ba 00 02 00 00       	mov    $0x200,%edx
8010214a:	29 c2                	sub    %eax,%edx
8010214c:	8b 45 14             	mov    0x14(%ebp),%eax
8010214f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102152:	39 c2                	cmp    %eax,%edx
80102154:	0f 46 c2             	cmovbe %edx,%eax
80102157:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010215d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102160:	8b 45 10             	mov    0x10(%ebp),%eax
80102163:	25 ff 01 00 00       	and    $0x1ff,%eax
80102168:	01 d0                	add    %edx,%eax
8010216a:	83 ec 04             	sub    $0x4,%esp
8010216d:	ff 75 ec             	push   -0x14(%ebp)
80102170:	ff 75 0c             	push   0xc(%ebp)
80102173:	50                   	push   %eax
80102174:	e8 8b 32 00 00       	call   80105404 <memmove>
80102179:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010217c:	83 ec 0c             	sub    $0xc,%esp
8010217f:	ff 75 f0             	push   -0x10(%ebp)
80102182:	e8 24 17 00 00       	call   801038ab <log_write>
80102187:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010218a:	83 ec 0c             	sub    $0xc,%esp
8010218d:	ff 75 f0             	push   -0x10(%ebp)
80102190:	e8 bc e0 ff ff       	call   80100251 <brelse>
80102195:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102198:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010219e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a1:	01 45 10             	add    %eax,0x10(%ebp)
801021a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a7:	01 45 0c             	add    %eax,0xc(%ebp)
801021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ad:	3b 45 14             	cmp    0x14(%ebp),%eax
801021b0:	0f 82 5d ff ff ff    	jb     80102113 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
801021b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021ba:	74 22                	je     801021de <writei+0x181>
801021bc:	8b 45 08             	mov    0x8(%ebp),%eax
801021bf:	8b 40 58             	mov    0x58(%eax),%eax
801021c2:	3b 45 10             	cmp    0x10(%ebp),%eax
801021c5:	73 17                	jae    801021de <writei+0x181>
    ip->size = off;
801021c7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ca:	8b 55 10             	mov    0x10(%ebp),%edx
801021cd:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	ff 75 08             	push   0x8(%ebp)
801021d6:	e8 64 f6 ff ff       	call   8010183f <iupdate>
801021db:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021de:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021e1:	c9                   	leave
801021e2:	c3                   	ret

801021e3 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021e3:	55                   	push   %ebp
801021e4:	89 e5                	mov    %esp,%ebp
801021e6:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021e9:	83 ec 04             	sub    $0x4,%esp
801021ec:	6a 0e                	push   $0xe
801021ee:	ff 75 0c             	push   0xc(%ebp)
801021f1:	ff 75 08             	push   0x8(%ebp)
801021f4:	e8 a1 32 00 00       	call   8010549a <strncmp>
801021f9:	83 c4 10             	add    $0x10,%esp
}
801021fc:	c9                   	leave
801021fd:	c3                   	ret

801021fe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021fe:	55                   	push   %ebp
801021ff:	89 e5                	mov    %esp,%ebp
80102201:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102204:	8b 45 08             	mov    0x8(%ebp),%eax
80102207:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010220b:	66 83 f8 01          	cmp    $0x1,%ax
8010220f:	74 0d                	je     8010221e <dirlookup+0x20>
    panic("dirlookup not DIR");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 f5 87 10 80       	push   $0x801087f5
80102219:	e8 95 e3 ff ff       	call   801005b3 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102225:	eb 7b                	jmp    801022a2 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102227:	6a 10                	push   $0x10
80102229:	ff 75 f4             	push   -0xc(%ebp)
8010222c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222f:	50                   	push   %eax
80102230:	ff 75 08             	push   0x8(%ebp)
80102233:	e8 d0 fc ff ff       	call   80101f08 <readi>
80102238:	83 c4 10             	add    $0x10,%esp
8010223b:	83 f8 10             	cmp    $0x10,%eax
8010223e:	74 0d                	je     8010224d <dirlookup+0x4f>
      panic("dirlookup read");
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 07 88 10 80       	push   $0x80108807
80102248:	e8 66 e3 ff ff       	call   801005b3 <panic>
    if(de.inum == 0)
8010224d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102251:	66 85 c0             	test   %ax,%ax
80102254:	74 47                	je     8010229d <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102256:	83 ec 08             	sub    $0x8,%esp
80102259:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010225c:	83 c0 02             	add    $0x2,%eax
8010225f:	50                   	push   %eax
80102260:	ff 75 0c             	push   0xc(%ebp)
80102263:	e8 7b ff ff ff       	call   801021e3 <namecmp>
80102268:	83 c4 10             	add    $0x10,%esp
8010226b:	85 c0                	test   %eax,%eax
8010226d:	75 2f                	jne    8010229e <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010226f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102273:	74 08                	je     8010227d <dirlookup+0x7f>
        *poff = off;
80102275:	8b 45 10             	mov    0x10(%ebp),%eax
80102278:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010227b:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010227d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102281:	0f b7 c0             	movzwl %ax,%eax
80102284:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102287:	8b 45 08             	mov    0x8(%ebp),%eax
8010228a:	8b 00                	mov    (%eax),%eax
8010228c:	83 ec 08             	sub    $0x8,%esp
8010228f:	ff 75 f0             	push   -0x10(%ebp)
80102292:	50                   	push   %eax
80102293:	e8 68 f6 ff ff       	call   80101900 <iget>
80102298:	83 c4 10             	add    $0x10,%esp
8010229b:	eb 19                	jmp    801022b6 <dirlookup+0xb8>
      continue;
8010229d:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010229e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022a2:	8b 45 08             	mov    0x8(%ebp),%eax
801022a5:	8b 40 58             	mov    0x58(%eax),%eax
801022a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801022ab:	0f 82 76 ff ff ff    	jb     80102227 <dirlookup+0x29>
    }
  }

  return 0;
801022b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b6:	c9                   	leave
801022b7:	c3                   	ret

801022b8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022b8:	55                   	push   %ebp
801022b9:	89 e5                	mov    %esp,%ebp
801022bb:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022be:	83 ec 04             	sub    $0x4,%esp
801022c1:	6a 00                	push   $0x0
801022c3:	ff 75 0c             	push   0xc(%ebp)
801022c6:	ff 75 08             	push   0x8(%ebp)
801022c9:	e8 30 ff ff ff       	call   801021fe <dirlookup>
801022ce:	83 c4 10             	add    $0x10,%esp
801022d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022d8:	74 18                	je     801022f2 <dirlink+0x3a>
    iput(ip);
801022da:	83 ec 0c             	sub    $0xc,%esp
801022dd:	ff 75 f0             	push   -0x10(%ebp)
801022e0:	e8 98 f8 ff ff       	call   80101b7d <iput>
801022e5:	83 c4 10             	add    $0x10,%esp
    return -1;
801022e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022ed:	e9 9c 00 00 00       	jmp    8010238e <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022f9:	eb 39                	jmp    80102334 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fe:	6a 10                	push   $0x10
80102300:	50                   	push   %eax
80102301:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102304:	50                   	push   %eax
80102305:	ff 75 08             	push   0x8(%ebp)
80102308:	e8 fb fb ff ff       	call   80101f08 <readi>
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	83 f8 10             	cmp    $0x10,%eax
80102313:	74 0d                	je     80102322 <dirlink+0x6a>
      panic("dirlink read");
80102315:	83 ec 0c             	sub    $0xc,%esp
80102318:	68 16 88 10 80       	push   $0x80108816
8010231d:	e8 91 e2 ff ff       	call   801005b3 <panic>
    if(de.inum == 0)
80102322:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102326:	66 85 c0             	test   %ax,%ax
80102329:	74 18                	je     80102343 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232e:	83 c0 10             	add    $0x10,%eax
80102331:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102334:	8b 45 08             	mov    0x8(%ebp),%eax
80102337:	8b 40 58             	mov    0x58(%eax),%eax
8010233a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010233d:	39 c2                	cmp    %eax,%edx
8010233f:	72 ba                	jb     801022fb <dirlink+0x43>
80102341:	eb 01                	jmp    80102344 <dirlink+0x8c>
      break;
80102343:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	6a 0e                	push   $0xe
80102349:	ff 75 0c             	push   0xc(%ebp)
8010234c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234f:	83 c0 02             	add    $0x2,%eax
80102352:	50                   	push   %eax
80102353:	e8 98 31 00 00       	call   801054f0 <strncpy>
80102358:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010235b:	8b 45 10             	mov    0x10(%ebp),%eax
8010235e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102365:	6a 10                	push   $0x10
80102367:	50                   	push   %eax
80102368:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010236b:	50                   	push   %eax
8010236c:	ff 75 08             	push   0x8(%ebp)
8010236f:	e8 e9 fc ff ff       	call   8010205d <writei>
80102374:	83 c4 10             	add    $0x10,%esp
80102377:	83 f8 10             	cmp    $0x10,%eax
8010237a:	74 0d                	je     80102389 <dirlink+0xd1>
    panic("dirlink");
8010237c:	83 ec 0c             	sub    $0xc,%esp
8010237f:	68 23 88 10 80       	push   $0x80108823
80102384:	e8 2a e2 ff ff       	call   801005b3 <panic>

  return 0;
80102389:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010238e:	c9                   	leave
8010238f:	c3                   	ret

80102390 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102396:	eb 04                	jmp    8010239c <skipelem+0xc>
    path++;
80102398:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010239c:	8b 45 08             	mov    0x8(%ebp),%eax
8010239f:	0f b6 00             	movzbl (%eax),%eax
801023a2:	3c 2f                	cmp    $0x2f,%al
801023a4:	74 f2                	je     80102398 <skipelem+0x8>
  if(*path == 0)
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
801023a9:	0f b6 00             	movzbl (%eax),%eax
801023ac:	84 c0                	test   %al,%al
801023ae:	75 07                	jne    801023b7 <skipelem+0x27>
    return 0;
801023b0:	b8 00 00 00 00       	mov    $0x0,%eax
801023b5:	eb 77                	jmp    8010242e <skipelem+0x9e>
  s = path;
801023b7:	8b 45 08             	mov    0x8(%ebp),%eax
801023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023bd:	eb 04                	jmp    801023c3 <skipelem+0x33>
    path++;
801023bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801023c3:	8b 45 08             	mov    0x8(%ebp),%eax
801023c6:	0f b6 00             	movzbl (%eax),%eax
801023c9:	3c 2f                	cmp    $0x2f,%al
801023cb:	74 0a                	je     801023d7 <skipelem+0x47>
801023cd:	8b 45 08             	mov    0x8(%ebp),%eax
801023d0:	0f b6 00             	movzbl (%eax),%eax
801023d3:	84 c0                	test   %al,%al
801023d5:	75 e8                	jne    801023bf <skipelem+0x2f>
  len = path - s;
801023d7:	8b 45 08             	mov    0x8(%ebp),%eax
801023da:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023e0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e4:	7e 15                	jle    801023fb <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023e6:	83 ec 04             	sub    $0x4,%esp
801023e9:	6a 0e                	push   $0xe
801023eb:	ff 75 f4             	push   -0xc(%ebp)
801023ee:	ff 75 0c             	push   0xc(%ebp)
801023f1:	e8 0e 30 00 00       	call   80105404 <memmove>
801023f6:	83 c4 10             	add    $0x10,%esp
801023f9:	eb 26                	jmp    80102421 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023fe:	83 ec 04             	sub    $0x4,%esp
80102401:	50                   	push   %eax
80102402:	ff 75 f4             	push   -0xc(%ebp)
80102405:	ff 75 0c             	push   0xc(%ebp)
80102408:	e8 f7 2f 00 00       	call   80105404 <memmove>
8010240d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102410:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102413:	8b 45 0c             	mov    0xc(%ebp),%eax
80102416:	01 d0                	add    %edx,%eax
80102418:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010241b:	eb 04                	jmp    80102421 <skipelem+0x91>
    path++;
8010241d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	0f b6 00             	movzbl (%eax),%eax
80102427:	3c 2f                	cmp    $0x2f,%al
80102429:	74 f2                	je     8010241d <skipelem+0x8d>
  return path;
8010242b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010242e:	c9                   	leave
8010242f:	c3                   	ret

80102430 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102436:	8b 45 08             	mov    0x8(%ebp),%eax
80102439:	0f b6 00             	movzbl (%eax),%eax
8010243c:	3c 2f                	cmp    $0x2f,%al
8010243e:	75 17                	jne    80102457 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	6a 01                	push   $0x1
80102445:	6a 01                	push   $0x1
80102447:	e8 b4 f4 ff ff       	call   80101900 <iget>
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102452:	e9 ba 00 00 00       	jmp    80102511 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102457:	e8 79 1f 00 00       	call   801043d5 <myproc>
8010245c:	8b 40 68             	mov    0x68(%eax),%eax
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	50                   	push   %eax
80102463:	e8 7a f5 ff ff       	call   801019e2 <idup>
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010246e:	e9 9e 00 00 00       	jmp    80102511 <namex+0xe1>
    ilock(ip);
80102473:	83 ec 0c             	sub    $0xc,%esp
80102476:	ff 75 f4             	push   -0xc(%ebp)
80102479:	e8 9e f5 ff ff       	call   80101a1c <ilock>
8010247e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102484:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102488:	66 83 f8 01          	cmp    $0x1,%ax
8010248c:	74 18                	je     801024a6 <namex+0x76>
      iunlockput(ip);
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	ff 75 f4             	push   -0xc(%ebp)
80102494:	e8 b4 f7 ff ff       	call   80101c4d <iunlockput>
80102499:	83 c4 10             	add    $0x10,%esp
      return 0;
8010249c:	b8 00 00 00 00       	mov    $0x0,%eax
801024a1:	e9 a7 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
801024a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024aa:	74 20                	je     801024cc <namex+0x9c>
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	84 c0                	test   %al,%al
801024b4:	75 16                	jne    801024cc <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	push   -0xc(%ebp)
801024bc:	e8 6e f6 ff ff       	call   80101b2f <iunlock>
801024c1:	83 c4 10             	add    $0x10,%esp
      return ip;
801024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c7:	e9 81 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cc:	83 ec 04             	sub    $0x4,%esp
801024cf:	6a 00                	push   $0x0
801024d1:	ff 75 10             	push   0x10(%ebp)
801024d4:	ff 75 f4             	push   -0xc(%ebp)
801024d7:	e8 22 fd ff ff       	call   801021fe <dirlookup>
801024dc:	83 c4 10             	add    $0x10,%esp
801024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e6:	75 15                	jne    801024fd <namex+0xcd>
      iunlockput(ip);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f4             	push   -0xc(%ebp)
801024ee:	e8 5a f7 ff ff       	call   80101c4d <iunlockput>
801024f3:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 50                	jmp    8010254d <namex+0x11d>
    }
    iunlockput(ip);
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	ff 75 f4             	push   -0xc(%ebp)
80102503:	e8 45 f7 ff ff       	call   80101c4d <iunlockput>
80102508:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102511:	83 ec 08             	sub    $0x8,%esp
80102514:	ff 75 10             	push   0x10(%ebp)
80102517:	ff 75 08             	push   0x8(%ebp)
8010251a:	e8 71 fe ff ff       	call   80102390 <skipelem>
8010251f:	83 c4 10             	add    $0x10,%esp
80102522:	89 45 08             	mov    %eax,0x8(%ebp)
80102525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102529:	0f 85 44 ff ff ff    	jne    80102473 <namex+0x43>
  }
  if(nameiparent){
8010252f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102533:	74 15                	je     8010254a <namex+0x11a>
    iput(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	ff 75 f4             	push   -0xc(%ebp)
8010253b:	e8 3d f6 ff ff       	call   80101b7d <iput>
80102540:	83 c4 10             	add    $0x10,%esp
    return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
80102548:	eb 03                	jmp    8010254d <namex+0x11d>
  }
  return ip;
8010254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254d:	c9                   	leave
8010254e:	c3                   	ret

8010254f <namei>:

struct inode*
namei(char *path)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	83 ec 04             	sub    $0x4,%esp
80102558:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010255b:	50                   	push   %eax
8010255c:	6a 00                	push   $0x0
8010255e:	ff 75 08             	push   0x8(%ebp)
80102561:	e8 ca fe ff ff       	call   80102430 <namex>
80102566:	83 c4 10             	add    $0x10,%esp
}
80102569:	c9                   	leave
8010256a:	c3                   	ret

8010256b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102571:	83 ec 04             	sub    $0x4,%esp
80102574:	ff 75 0c             	push   0xc(%ebp)
80102577:	6a 01                	push   $0x1
80102579:	ff 75 08             	push   0x8(%ebp)
8010257c:	e8 af fe ff ff       	call   80102430 <namex>
80102581:	83 c4 10             	add    $0x10,%esp
}
80102584:	c9                   	leave
80102585:	c3                   	ret

80102586 <inb>:
// Simple PIO-based (non-DMA) IDE driver code.

#include "types.h"
#include "defs.h"
#include "param.h"
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 14             	sub    $0x14,%esp
8010258c:	8b 45 08             	mov    0x8(%ebp),%eax
8010258f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
80102593:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102597:	89 c2                	mov    %eax,%edx
80102599:	ec                   	in     (%dx),%al
8010259a:	88 45 ff             	mov    %al,-0x1(%ebp)
#include "x86.h"
8010259d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
#include "traps.h"
801025a1:	c9                   	leave
801025a2:	c3                   	ret

801025a3 <insl>:
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
801025a3:	55                   	push   %ebp
801025a4:	89 e5                	mov    %esp,%ebp
801025a6:	57                   	push   %edi
801025a7:	53                   	push   %ebx

801025a8:	8b 55 08             	mov    0x8(%ebp),%edx
801025ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025ae:	8b 45 10             	mov    0x10(%ebp),%eax
801025b1:	89 cb                	mov    %ecx,%ebx
801025b3:	89 df                	mov    %ebx,%edi
801025b5:	89 c1                	mov    %eax,%ecx
801025b7:	fc                   	cld
801025b8:	f3 6d                	rep insl (%dx),%es:(%edi)
801025ba:	89 c8                	mov    %ecx,%eax
801025bc:	89 fb                	mov    %edi,%ebx
801025be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c1:	89 45 10             	mov    %eax,0x10(%ebp)
#define SECTOR_SIZE   512
#define IDE_BSY       0x80
#define IDE_DRDY      0x40
#define IDE_DF        0x20
801025c4:	90                   	nop
801025c5:	5b                   	pop    %ebx
801025c6:	5f                   	pop    %edi
801025c7:	5d                   	pop    %ebp
801025c8:	c3                   	ret

801025c9 <outb>:
#define IDE_ERR       0x01

#define IDE_CMD_READ  0x20
#define IDE_CMD_WRITE 0x30
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	83 ec 08             	sub    $0x8,%esp
801025cf:	8b 55 08             	mov    0x8(%ebp),%edx
801025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025d9:	88 45 f8             	mov    %al,-0x8(%ebp)
#define IDE_CMD_RDMUL 0xc4
801025dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025e4:	ee                   	out    %al,(%dx)
#define IDE_CMD_WRMUL 0xc5
801025e5:	90                   	nop
801025e6:	c9                   	leave
801025e7:	c3                   	ret

801025e8 <outsl>:

static struct spinlock idelock;
static struct buf *idequeue;

static int havedisk1;
static void idestart(struct buf*);
801025e8:	55                   	push   %ebp
801025e9:	89 e5                	mov    %esp,%ebp
801025eb:	56                   	push   %esi
801025ec:	53                   	push   %ebx

801025ed:	8b 55 08             	mov    0x8(%ebp),%edx
801025f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f3:	8b 45 10             	mov    0x10(%ebp),%eax
801025f6:	89 cb                	mov    %ecx,%ebx
801025f8:	89 de                	mov    %ebx,%esi
801025fa:	89 c1                	mov    %eax,%ecx
801025fc:	fc                   	cld
801025fd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ff:	89 c8                	mov    %ecx,%eax
80102601:	89 f3                	mov    %esi,%ebx
80102603:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102606:	89 45 10             	mov    %eax,0x10(%ebp)
// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102609:	90                   	nop
8010260a:	5b                   	pop    %ebx
8010260b:	5e                   	pop    %esi
8010260c:	5d                   	pop    %ebp
8010260d:	c3                   	ret

8010260e <idewait>:
8010260e:	55                   	push   %ebp
8010260f:	89 e5                	mov    %esp,%ebp
80102611:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102614:	90                   	nop
80102615:	68 f7 01 00 00       	push   $0x1f7
8010261a:	e8 67 ff ff ff       	call   80102586 <inb>
8010261f:	83 c4 04             	add    $0x4,%esp
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262b:	25 c0 00 00 00       	and    $0xc0,%eax
80102630:	83 f8 40             	cmp    $0x40,%eax
80102633:	75 e0                	jne    80102615 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102635:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102639:	74 11                	je     8010264c <idewait+0x3e>
8010263b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010263e:	83 e0 21             	and    $0x21,%eax
80102641:	85 c0                	test   %eax,%eax
80102643:	74 07                	je     8010264c <idewait+0x3e>
    return -1;
80102645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264a:	eb 05                	jmp    80102651 <idewait+0x43>
  return 0;
8010264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102651:	c9                   	leave
80102652:	c3                   	ret

80102653 <ideinit>:

void
ideinit(void)
{
80102653:	55                   	push   %ebp
80102654:	89 e5                	mov    %esp,%ebp
80102656:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102659:	83 ec 08             	sub    $0x8,%esp
8010265c:	68 2b 88 10 80       	push   $0x8010882b
80102661:	68 40 26 11 80       	push   $0x80112640
80102666:	e8 32 2a 00 00       	call   8010509d <initlock>
8010266b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010266e:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
80102673:	83 e8 01             	sub    $0x1,%eax
80102676:	83 ec 08             	sub    $0x8,%esp
80102679:	50                   	push   %eax
8010267a:	6a 0e                	push   $0xe
8010267c:	e8 a3 04 00 00       	call   80102b24 <ioapicenable>
80102681:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	6a 00                	push   $0x0
80102689:	e8 80 ff ff ff       	call   8010260e <idewait>
8010268e:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102691:	83 ec 08             	sub    $0x8,%esp
80102694:	68 f0 00 00 00       	push   $0xf0
80102699:	68 f6 01 00 00       	push   $0x1f6
8010269e:	e8 26 ff ff ff       	call   801025c9 <outb>
801026a3:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ad:	eb 24                	jmp    801026d3 <ideinit+0x80>
    if(inb(0x1f7) != 0){
801026af:	83 ec 0c             	sub    $0xc,%esp
801026b2:	68 f7 01 00 00       	push   $0x1f7
801026b7:	e8 ca fe ff ff       	call   80102586 <inb>
801026bc:	83 c4 10             	add    $0x10,%esp
801026bf:	84 c0                	test   %al,%al
801026c1:	74 0c                	je     801026cf <ideinit+0x7c>
      havedisk1 = 1;
801026c3:	c7 05 78 26 11 80 01 	movl   $0x1,0x80112678
801026ca:	00 00 00 
      break;
801026cd:	eb 0d                	jmp    801026dc <ideinit+0x89>
  for(i=0; i<1000; i++){
801026cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026d3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026da:	7e d3                	jle    801026af <ideinit+0x5c>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026dc:	83 ec 08             	sub    $0x8,%esp
801026df:	68 e0 00 00 00       	push   $0xe0
801026e4:	68 f6 01 00 00       	push   $0x1f6
801026e9:	e8 db fe ff ff       	call   801025c9 <outb>
801026ee:	83 c4 10             	add    $0x10,%esp
}
801026f1:	90                   	nop
801026f2:	c9                   	leave
801026f3:	c3                   	ret

801026f4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f4:	55                   	push   %ebp
801026f5:	89 e5                	mov    %esp,%ebp
801026f7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026fe:	75 0d                	jne    8010270d <idestart+0x19>
    panic("idestart");
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 2f 88 10 80       	push   $0x8010882f
80102708:	e8 a6 de ff ff       	call   801005b3 <panic>
  if(b->blockno >= FSSIZE)
8010270d:	8b 45 08             	mov    0x8(%ebp),%eax
80102710:	8b 40 08             	mov    0x8(%eax),%eax
80102713:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102718:	76 0d                	jbe    80102727 <idestart+0x33>
    panic("incorrect blockno");
8010271a:	83 ec 0c             	sub    $0xc,%esp
8010271d:	68 38 88 10 80       	push   $0x80108838
80102722:	e8 8c de ff ff       	call   801005b3 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102727:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010272e:	8b 45 08             	mov    0x8(%ebp),%eax
80102731:	8b 50 08             	mov    0x8(%eax),%edx
80102734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102737:	0f af c2             	imul   %edx,%eax
8010273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010273d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102741:	75 07                	jne    8010274a <idestart+0x56>
80102743:	b8 20 00 00 00       	mov    $0x20,%eax
80102748:	eb 05                	jmp    8010274f <idestart+0x5b>
8010274a:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010274f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102752:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102756:	75 07                	jne    8010275f <idestart+0x6b>
80102758:	b8 30 00 00 00       	mov    $0x30,%eax
8010275d:	eb 05                	jmp    80102764 <idestart+0x70>
8010275f:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102764:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102767:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010276b:	7e 0d                	jle    8010277a <idestart+0x86>
8010276d:	83 ec 0c             	sub    $0xc,%esp
80102770:	68 2f 88 10 80       	push   $0x8010882f
80102775:	e8 39 de ff ff       	call   801005b3 <panic>

  idewait(0);
8010277a:	83 ec 0c             	sub    $0xc,%esp
8010277d:	6a 00                	push   $0x0
8010277f:	e8 8a fe ff ff       	call   8010260e <idewait>
80102784:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102787:	83 ec 08             	sub    $0x8,%esp
8010278a:	6a 00                	push   $0x0
8010278c:	68 f6 03 00 00       	push   $0x3f6
80102791:	e8 33 fe ff ff       	call   801025c9 <outb>
80102796:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279c:	0f b6 c0             	movzbl %al,%eax
8010279f:	83 ec 08             	sub    $0x8,%esp
801027a2:	50                   	push   %eax
801027a3:	68 f2 01 00 00       	push   $0x1f2
801027a8:	e8 1c fe ff ff       	call   801025c9 <outb>
801027ad:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b3:	0f b6 c0             	movzbl %al,%eax
801027b6:	83 ec 08             	sub    $0x8,%esp
801027b9:	50                   	push   %eax
801027ba:	68 f3 01 00 00       	push   $0x1f3
801027bf:	e8 05 fe ff ff       	call   801025c9 <outb>
801027c4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ca:	c1 f8 08             	sar    $0x8,%eax
801027cd:	0f b6 c0             	movzbl %al,%eax
801027d0:	83 ec 08             	sub    $0x8,%esp
801027d3:	50                   	push   %eax
801027d4:	68 f4 01 00 00       	push   $0x1f4
801027d9:	e8 eb fd ff ff       	call   801025c9 <outb>
801027de:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027e4:	c1 f8 10             	sar    $0x10,%eax
801027e7:	0f b6 c0             	movzbl %al,%eax
801027ea:	83 ec 08             	sub    $0x8,%esp
801027ed:	50                   	push   %eax
801027ee:	68 f5 01 00 00       	push   $0x1f5
801027f3:	e8 d1 fd ff ff       	call   801025c9 <outb>
801027f8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	8b 40 04             	mov    0x4(%eax),%eax
80102801:	c1 e0 04             	shl    $0x4,%eax
80102804:	83 e0 10             	and    $0x10,%eax
80102807:	89 c2                	mov    %eax,%edx
80102809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280c:	c1 f8 18             	sar    $0x18,%eax
8010280f:	83 e0 0f             	and    $0xf,%eax
80102812:	09 d0                	or     %edx,%eax
80102814:	83 c8 e0             	or     $0xffffffe0,%eax
80102817:	0f b6 c0             	movzbl %al,%eax
8010281a:	83 ec 08             	sub    $0x8,%esp
8010281d:	50                   	push   %eax
8010281e:	68 f6 01 00 00       	push   $0x1f6
80102823:	e8 a1 fd ff ff       	call   801025c9 <outb>
80102828:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010282b:	8b 45 08             	mov    0x8(%ebp),%eax
8010282e:	8b 00                	mov    (%eax),%eax
80102830:	83 e0 04             	and    $0x4,%eax
80102833:	85 c0                	test   %eax,%eax
80102835:	74 35                	je     8010286c <idestart+0x178>
    outb(0x1f7, write_cmd);
80102837:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010283a:	0f b6 c0             	movzbl %al,%eax
8010283d:	83 ec 08             	sub    $0x8,%esp
80102840:	50                   	push   %eax
80102841:	68 f7 01 00 00       	push   $0x1f7
80102846:	e8 7e fd ff ff       	call   801025c9 <outb>
8010284b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	83 c0 5c             	add    $0x5c,%eax
80102854:	83 ec 04             	sub    $0x4,%esp
80102857:	68 80 00 00 00       	push   $0x80
8010285c:	50                   	push   %eax
8010285d:	68 f0 01 00 00       	push   $0x1f0
80102862:	e8 81 fd ff ff       	call   801025e8 <outsl>
80102867:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010286a:	eb 17                	jmp    80102883 <idestart+0x18f>
    outb(0x1f7, read_cmd);
8010286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010286f:	0f b6 c0             	movzbl %al,%eax
80102872:	83 ec 08             	sub    $0x8,%esp
80102875:	50                   	push   %eax
80102876:	68 f7 01 00 00       	push   $0x1f7
8010287b:	e8 49 fd ff ff       	call   801025c9 <outb>
80102880:	83 c4 10             	add    $0x10,%esp
}
80102883:	90                   	nop
80102884:	c9                   	leave
80102885:	c3                   	ret

80102886 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102886:	55                   	push   %ebp
80102887:	89 e5                	mov    %esp,%ebp
80102889:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288c:	83 ec 0c             	sub    $0xc,%esp
8010288f:	68 40 26 11 80       	push   $0x80112640
80102894:	e8 26 28 00 00       	call   801050bf <acquire>
80102899:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010289c:	a1 74 26 11 80       	mov    0x80112674,%eax
801028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028a8:	75 15                	jne    801028bf <ideintr+0x39>
    release(&idelock);
801028aa:	83 ec 0c             	sub    $0xc,%esp
801028ad:	68 40 26 11 80       	push   $0x80112640
801028b2:	e8 76 28 00 00       	call   8010512d <release>
801028b7:	83 c4 10             	add    $0x10,%esp
    return;
801028ba:	e9 9a 00 00 00       	jmp    80102959 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c2:	8b 40 58             	mov    0x58(%eax),%eax
801028c5:	a3 74 26 11 80       	mov    %eax,0x80112674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 04             	and    $0x4,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 2d                	jne    80102903 <ideintr+0x7d>
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	6a 01                	push   $0x1
801028db:	e8 2e fd ff ff       	call   8010260e <idewait>
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	85 c0                	test   %eax,%eax
801028e5:	78 1c                	js     80102903 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ea:	83 c0 5c             	add    $0x5c,%eax
801028ed:	83 ec 04             	sub    $0x4,%esp
801028f0:	68 80 00 00 00       	push   $0x80
801028f5:	50                   	push   %eax
801028f6:	68 f0 01 00 00       	push   $0x1f0
801028fb:	e8 a3 fc ff ff       	call   801025a3 <insl>
80102900:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102906:	8b 00                	mov    (%eax),%eax
80102908:	83 c8 02             	or     $0x2,%eax
8010290b:	89 c2                	mov    %eax,%edx
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102915:	8b 00                	mov    (%eax),%eax
80102917:	83 e0 fb             	and    $0xfffffffb,%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	ff 75 f4             	push   -0xc(%ebp)
80102927:	e8 39 24 00 00       	call   80104d65 <wakeup>
8010292c:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010292f:	a1 74 26 11 80       	mov    0x80112674,%eax
80102934:	85 c0                	test   %eax,%eax
80102936:	74 11                	je     80102949 <ideintr+0xc3>
    idestart(idequeue);
80102938:	a1 74 26 11 80       	mov    0x80112674,%eax
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	50                   	push   %eax
80102941:	e8 ae fd ff ff       	call   801026f4 <idestart>
80102946:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102949:	83 ec 0c             	sub    $0xc,%esp
8010294c:	68 40 26 11 80       	push   $0x80112640
80102951:	e8 d7 27 00 00       	call   8010512d <release>
80102956:	83 c4 10             	add    $0x10,%esp
}
80102959:	c9                   	leave
8010295a:	c3                   	ret

8010295b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295b:	55                   	push   %ebp
8010295c:	89 e5                	mov    %esp,%ebp
8010295e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	83 c0 0c             	add    $0xc,%eax
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	50                   	push   %eax
8010296b:	e8 98 26 00 00       	call   80105008 <holdingsleep>
80102970:	83 c4 10             	add    $0x10,%esp
80102973:	85 c0                	test   %eax,%eax
80102975:	75 0d                	jne    80102984 <iderw+0x29>
    panic("iderw: buf not locked");
80102977:	83 ec 0c             	sub    $0xc,%esp
8010297a:	68 4a 88 10 80       	push   $0x8010884a
8010297f:	e8 2f dc ff ff       	call   801005b3 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102984:	8b 45 08             	mov    0x8(%ebp),%eax
80102987:	8b 00                	mov    (%eax),%eax
80102989:	83 e0 06             	and    $0x6,%eax
8010298c:	83 f8 02             	cmp    $0x2,%eax
8010298f:	75 0d                	jne    8010299e <iderw+0x43>
    panic("iderw: nothing to do");
80102991:	83 ec 0c             	sub    $0xc,%esp
80102994:	68 60 88 10 80       	push   $0x80108860
80102999:	e8 15 dc ff ff       	call   801005b3 <panic>
  if(b->dev != 0 && !havedisk1)
8010299e:	8b 45 08             	mov    0x8(%ebp),%eax
801029a1:	8b 40 04             	mov    0x4(%eax),%eax
801029a4:	85 c0                	test   %eax,%eax
801029a6:	74 16                	je     801029be <iderw+0x63>
801029a8:	a1 78 26 11 80       	mov    0x80112678,%eax
801029ad:	85 c0                	test   %eax,%eax
801029af:	75 0d                	jne    801029be <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029b1:	83 ec 0c             	sub    $0xc,%esp
801029b4:	68 75 88 10 80       	push   $0x80108875
801029b9:	e8 f5 db ff ff       	call   801005b3 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029be:	83 ec 0c             	sub    $0xc,%esp
801029c1:	68 40 26 11 80       	push   $0x80112640
801029c6:	e8 f4 26 00 00       	call   801050bf <acquire>
801029cb:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029ce:	8b 45 08             	mov    0x8(%ebp),%eax
801029d1:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d8:	c7 45 f4 74 26 11 80 	movl   $0x80112674,-0xc(%ebp)
801029df:	eb 0b                	jmp    801029ec <iderw+0x91>
801029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e4:	8b 00                	mov    (%eax),%eax
801029e6:	83 c0 58             	add    $0x58,%eax
801029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ef:	8b 00                	mov    (%eax),%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	75 ec                	jne    801029e1 <iderw+0x86>
    ;
  *pp = b;
801029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f8:	8b 55 08             	mov    0x8(%ebp),%edx
801029fb:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029fd:	a1 74 26 11 80       	mov    0x80112674,%eax
80102a02:	39 45 08             	cmp    %eax,0x8(%ebp)
80102a05:	75 23                	jne    80102a2a <iderw+0xcf>
    idestart(b);
80102a07:	83 ec 0c             	sub    $0xc,%esp
80102a0a:	ff 75 08             	push   0x8(%ebp)
80102a0d:	e8 e2 fc ff ff       	call   801026f4 <idestart>
80102a12:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a15:	eb 13                	jmp    80102a2a <iderw+0xcf>
    sleep(b, &idelock);
80102a17:	83 ec 08             	sub    $0x8,%esp
80102a1a:	68 40 26 11 80       	push   $0x80112640
80102a1f:	ff 75 08             	push   0x8(%ebp)
80102a22:	e8 57 22 00 00       	call   80104c7e <sleep>
80102a27:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2d:	8b 00                	mov    (%eax),%eax
80102a2f:	83 e0 06             	and    $0x6,%eax
80102a32:	83 f8 02             	cmp    $0x2,%eax
80102a35:	75 e0                	jne    80102a17 <iderw+0xbc>
  }


  release(&idelock);
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 40 26 11 80       	push   $0x80112640
80102a3f:	e8 e9 26 00 00       	call   8010512d <release>
80102a44:	83 c4 10             	add    $0x10,%esp
}
80102a47:	90                   	nop
80102a48:	c9                   	leave
80102a49:	c3                   	ret

80102a4a <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a4a:	55                   	push   %ebp
80102a4b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a4d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a52:	8b 55 08             	mov    0x8(%ebp),%edx
80102a55:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a57:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a5c:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a5f:	5d                   	pop    %ebp
80102a60:	c3                   	ret

80102a61 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a61:	55                   	push   %ebp
80102a62:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a64:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a69:	8b 55 08             	mov    0x8(%ebp),%edx
80102a6c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a6e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a73:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a76:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a79:	90                   	nop
80102a7a:	5d                   	pop    %ebp
80102a7b:	c3                   	ret

80102a7c <ioapicinit>:

void
ioapicinit(void)
{
80102a7c:	55                   	push   %ebp
80102a7d:	89 e5                	mov    %esp,%ebp
80102a7f:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a82:	c7 05 7c 26 11 80 00 	movl   $0xfec00000,0x8011267c
80102a89:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a8c:	6a 01                	push   $0x1
80102a8e:	e8 b7 ff ff ff       	call   80102a4a <ioapicread>
80102a93:	83 c4 04             	add    $0x4,%esp
80102a96:	c1 e8 10             	shr    $0x10,%eax
80102a99:	25 ff 00 00 00       	and    $0xff,%eax
80102a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa1:	6a 00                	push   $0x0
80102aa3:	e8 a2 ff ff ff       	call   80102a4a <ioapicread>
80102aa8:	83 c4 04             	add    $0x4,%esp
80102aab:	c1 e8 18             	shr    $0x18,%eax
80102aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab1:	0f b6 05 44 ad 14 80 	movzbl 0x8014ad44,%eax
80102ab8:	0f b6 c0             	movzbl %al,%eax
80102abb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102abe:	74 10                	je     80102ad0 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	68 94 88 10 80       	push   $0x80108894
80102ac8:	e8 31 d9 ff ff       	call   801003fe <cprintf>
80102acd:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ad7:	eb 3f                	jmp    80102b18 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102adc:	83 c0 20             	add    $0x20,%eax
80102adf:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae9:	83 c0 08             	add    $0x8,%eax
80102aec:	01 c0                	add    %eax,%eax
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	52                   	push   %edx
80102af2:	50                   	push   %eax
80102af3:	e8 69 ff ff ff       	call   80102a61 <ioapicwrite>
80102af8:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afe:	83 c0 08             	add    $0x8,%eax
80102b01:	01 c0                	add    %eax,%eax
80102b03:	83 c0 01             	add    $0x1,%eax
80102b06:	83 ec 08             	sub    $0x8,%esp
80102b09:	6a 00                	push   $0x0
80102b0b:	50                   	push   %eax
80102b0c:	e8 50 ff ff ff       	call   80102a61 <ioapicwrite>
80102b11:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b1e:	7e b9                	jle    80102ad9 <ioapicinit+0x5d>
  }
}
80102b20:	90                   	nop
80102b21:	90                   	nop
80102b22:	c9                   	leave
80102b23:	c3                   	ret

80102b24 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2a:	83 c0 20             	add    $0x20,%eax
80102b2d:	89 c2                	mov    %eax,%edx
80102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b32:	83 c0 08             	add    $0x8,%eax
80102b35:	01 c0                	add    %eax,%eax
80102b37:	52                   	push   %edx
80102b38:	50                   	push   %eax
80102b39:	e8 23 ff ff ff       	call   80102a61 <ioapicwrite>
80102b3e:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b44:	c1 e0 18             	shl    $0x18,%eax
80102b47:	89 c2                	mov    %eax,%edx
80102b49:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4c:	83 c0 08             	add    $0x8,%eax
80102b4f:	01 c0                	add    %eax,%eax
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	52                   	push   %edx
80102b55:	50                   	push   %eax
80102b56:	e8 06 ff ff ff       	call   80102a61 <ioapicwrite>
80102b5b:	83 c4 08             	add    $0x8,%esp
}
80102b5e:	90                   	nop
80102b5f:	c9                   	leave
80102b60:	c3                   	ret

80102b61 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b61:	55                   	push   %ebp
80102b62:	89 e5                	mov    %esp,%ebp
80102b64:	83 ec 18             	sub    $0x18,%esp
  for (int i=0; i<PHYSTOP/PGSIZE; i++) {
80102b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b6e:	eb 12                	jmp    80102b82 <kinit1+0x21>
    count.refs[i] = 0; // simple initialisation
80102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b73:	c7 04 85 c0 26 11 80 	movl   $0x0,-0x7feed940(,%eax,4)
80102b7a:	00 00 00 00 
  for (int i=0; i<PHYSTOP/PGSIZE; i++) {
80102b7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b82:	81 7d f4 ff df 00 00 	cmpl   $0xdfff,-0xc(%ebp)
80102b89:	7e e5                	jle    80102b70 <kinit1+0xf>
  }
  initlock(&kmem.lock, "kmem");
80102b8b:	83 ec 08             	sub    $0x8,%esp
80102b8e:	68 c8 88 10 80       	push   $0x801088c8
80102b93:	68 80 26 11 80       	push   $0x80112680
80102b98:	e8 00 25 00 00       	call   8010509d <initlock>
80102b9d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ba0:	c7 05 b4 26 11 80 00 	movl   $0x0,0x801126b4
80102ba7:	00 00 00 
  freerange(vstart, vend);
80102baa:	83 ec 08             	sub    $0x8,%esp
80102bad:	ff 75 0c             	push   0xc(%ebp)
80102bb0:	ff 75 08             	push   0x8(%ebp)
80102bb3:	e8 2a 00 00 00       	call   80102be2 <freerange>
80102bb8:	83 c4 10             	add    $0x10,%esp
}
80102bbb:	90                   	nop
80102bbc:	c9                   	leave
80102bbd:	c3                   	ret

80102bbe <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bc4:	83 ec 08             	sub    $0x8,%esp
80102bc7:	ff 75 0c             	push   0xc(%ebp)
80102bca:	ff 75 08             	push   0x8(%ebp)
80102bcd:	e8 10 00 00 00       	call   80102be2 <freerange>
80102bd2:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bd5:	c7 05 b4 26 11 80 01 	movl   $0x1,0x801126b4
80102bdc:	00 00 00 
}
80102bdf:	90                   	nop
80102be0:	c9                   	leave
80102be1:	c3                   	ret

80102be2 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102be2:	55                   	push   %ebp
80102be3:	89 e5                	mov    %esp,%ebp
80102be5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102be8:	8b 45 08             	mov    0x8(%ebp),%eax
80102beb:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf8:	eb 15                	jmp    80102c0f <freerange+0x2d>
    kfree(p);
80102bfa:	83 ec 0c             	sub    $0xc,%esp
80102bfd:	ff 75 f4             	push   -0xc(%ebp)
80102c00:	e8 1b 00 00 00       	call   80102c20 <kfree>
80102c05:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c08:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c12:	05 00 10 00 00       	add    $0x1000,%eax
80102c17:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102c1a:	73 de                	jae    80102bfa <freerange+0x18>
}
80102c1c:	90                   	nop
80102c1d:	90                   	nop
80102c1e:	c9                   	leave
80102c1f:	c3                   	ret

80102c20 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c26:	8b 45 08             	mov    0x8(%ebp),%eax
80102c29:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c2e:	85 c0                	test   %eax,%eax
80102c30:	75 18                	jne    80102c4a <kfree+0x2a>
80102c32:	81 7d 08 e0 e4 14 80 	cmpl   $0x8014e4e0,0x8(%ebp)
80102c39:	72 0f                	jb     80102c4a <kfree+0x2a>
80102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c3e:	05 00 00 00 80       	add    $0x80000000,%eax
80102c43:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c48:	76 0d                	jbe    80102c57 <kfree+0x37>
    panic("kfree");
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	68 cd 88 10 80       	push   $0x801088cd
80102c52:	e8 5c d9 ff ff       	call   801005b3 <panic>
  r = (struct run*)v;
80102c57:	8b 45 08             	mov    0x8(%ebp),%eax
80102c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (kmem.use_lock) {
80102c5d:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c62:	85 c0                	test   %eax,%eax
80102c64:	74 58                	je     80102cbe <kfree+0x9e>
    if (count.refs[V2P((char*)r)/PGSIZE] > 1) {
80102c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c69:	05 00 00 00 80       	add    $0x80000000,%eax
80102c6e:	c1 e8 0c             	shr    $0xc,%eax
80102c71:	8b 04 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%eax
80102c78:	83 f8 01             	cmp    $0x1,%eax
80102c7b:	7e 1e                	jle    80102c9b <kfree+0x7b>
      count.refs[V2P((char*)r)/PGSIZE]--;
80102c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c80:	05 00 00 00 80       	add    $0x80000000,%eax
80102c85:	c1 e8 0c             	shr    $0xc,%eax
80102c88:	8b 14 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%edx
80102c8f:	83 ea 01             	sub    $0x1,%edx
80102c92:	89 14 85 c0 26 11 80 	mov    %edx,-0x7feed940(,%eax,4)
      return;
80102c99:	eb 7d                	jmp    80102d18 <kfree+0xf8>
    }
    else if (count.refs[V2P((char*)r)/PGSIZE] < 1) {
80102c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9e:	05 00 00 00 80       	add    $0x80000000,%eax
80102ca3:	c1 e8 0c             	shr    $0xc,%eax
80102ca6:	8b 04 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%eax
80102cad:	85 c0                	test   %eax,%eax
80102caf:	7f 0d                	jg     80102cbe <kfree+0x9e>
      panic("Shouldn't be possible to free a page having no reference!\n");
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	68 d4 88 10 80       	push   $0x801088d4
80102cb9:	e8 f5 d8 ff ff       	call   801005b3 <panic>
    } 
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cbe:	83 ec 04             	sub    $0x4,%esp
80102cc1:	68 00 10 00 00       	push   $0x1000
80102cc6:	6a 01                	push   $0x1
80102cc8:	ff 75 08             	push   0x8(%ebp)
80102ccb:	e8 75 26 00 00       	call   80105345 <memset>
80102cd0:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cd3:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cd8:	85 c0                	test   %eax,%eax
80102cda:	74 10                	je     80102cec <kfree+0xcc>
    acquire(&kmem.lock);
80102cdc:	83 ec 0c             	sub    $0xc,%esp
80102cdf:	68 80 26 11 80       	push   $0x80112680
80102ce4:	e8 d6 23 00 00       	call   801050bf <acquire>
80102ce9:	83 c4 10             	add    $0x10,%esp
  
  r->next = kmem.freelist;
80102cec:	8b 15 b8 26 11 80    	mov    0x801126b8,%edx
80102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf5:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cfa:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  if(kmem.use_lock)
80102cff:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d04:	85 c0                	test   %eax,%eax
80102d06:	74 10                	je     80102d18 <kfree+0xf8>
    release(&kmem.lock);
80102d08:	83 ec 0c             	sub    $0xc,%esp
80102d0b:	68 80 26 11 80       	push   $0x80112680
80102d10:	e8 18 24 00 00       	call   8010512d <release>
80102d15:	83 c4 10             	add    $0x10,%esp
}
80102d18:	c9                   	leave
80102d19:	c3                   	ret

80102d1a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d1a:	55                   	push   %ebp
80102d1b:	89 e5                	mov    %esp,%ebp
80102d1d:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d25:	85 c0                	test   %eax,%eax
80102d27:	74 10                	je     80102d39 <kalloc+0x1f>
    acquire(&kmem.lock);
80102d29:	83 ec 0c             	sub    $0xc,%esp
80102d2c:	68 80 26 11 80       	push   $0x80112680
80102d31:	e8 89 23 00 00       	call   801050bf <acquire>
80102d36:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d39:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r) {
80102d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d45:	74 20                	je     80102d67 <kalloc+0x4d>
    kmem.freelist = r->next;
80102d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d4a:	8b 00                	mov    (%eax),%eax
80102d4c:	a3 b8 26 11 80       	mov    %eax,0x801126b8
    count.refs[V2P(r)/PGSIZE] = 1;
80102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d54:	05 00 00 00 80       	add    $0x80000000,%eax
80102d59:	c1 e8 0c             	shr    $0xc,%eax
80102d5c:	c7 04 85 c0 26 11 80 	movl   $0x1,-0x7feed940(,%eax,4)
80102d63:	01 00 00 00 
  }
    
  if(kmem.use_lock)
80102d67:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d6c:	85 c0                	test   %eax,%eax
80102d6e:	74 10                	je     80102d80 <kalloc+0x66>
    release(&kmem.lock);
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	68 80 26 11 80       	push   $0x80112680
80102d78:	e8 b0 23 00 00       	call   8010512d <release>
80102d7d:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d83:	c9                   	leave
80102d84:	c3                   	ret

80102d85 <freePage>:

int freePage() {
80102d85:	55                   	push   %ebp
80102d86:	89 e5                	mov    %esp,%ebp
80102d88:	83 ec 18             	sub    $0x18,%esp

  // function to return number of free pages, which is just the size of our freelist
  struct run *r;
  int freeCount = 0;
80102d8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if(kmem.use_lock)
80102d92:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d97:	85 c0                	test   %eax,%eax
80102d99:	74 10                	je     80102dab <freePage+0x26>
    acquire(&kmem.lock);
80102d9b:	83 ec 0c             	sub    $0xc,%esp
80102d9e:	68 80 26 11 80       	push   $0x80112680
80102da3:	e8 17 23 00 00       	call   801050bf <acquire>
80102da8:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102dab:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  while (r) {
80102db3:	eb 0c                	jmp    80102dc1 <freePage+0x3c>
    freeCount++;
80102db5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    r = r->next;
80102db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dbc:	8b 00                	mov    (%eax),%eax
80102dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (r) {
80102dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102dc5:	75 ee                	jne    80102db5 <freePage+0x30>
  }

  if(kmem.use_lock)
80102dc7:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102dcc:	85 c0                	test   %eax,%eax
80102dce:	74 10                	je     80102de0 <freePage+0x5b>
    release(&kmem.lock);
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 80 26 11 80       	push   $0x80112680
80102dd8:	e8 50 23 00 00       	call   8010512d <release>
80102ddd:	83 c4 10             	add    $0x10,%esp

  return freeCount;  
80102de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80102de3:	c9                   	leave
80102de4:	c3                   	ret

80102de5 <getRefCount>:

int getRefCount(uint pa) {
80102de5:	55                   	push   %ebp
80102de6:	89 e5                	mov    %esp,%ebp
  return count.refs[pa/PGSIZE];
80102de8:	8b 45 08             	mov    0x8(%ebp),%eax
80102deb:	c1 e8 0c             	shr    $0xc,%eax
80102dee:	8b 04 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%eax
}
80102df5:	5d                   	pop    %ebp
80102df6:	c3                   	ret

80102df7 <increaseRefCount>:

void increaseRefCount (uint pa) {
80102df7:	55                   	push   %ebp
80102df8:	89 e5                	mov    %esp,%ebp
  count.refs[pa/PGSIZE]++;
80102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80102dfd:	c1 e8 0c             	shr    $0xc,%eax
80102e00:	8b 14 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%edx
80102e07:	83 c2 01             	add    $0x1,%edx
80102e0a:	89 14 85 c0 26 11 80 	mov    %edx,-0x7feed940(,%eax,4)
}
80102e11:	90                   	nop
80102e12:	5d                   	pop    %ebp
80102e13:	c3                   	ret

80102e14 <decreaseRefCount>:
void decreaseRefCount (uint pa) {
80102e14:	55                   	push   %ebp
80102e15:	89 e5                	mov    %esp,%ebp
  count.refs[pa/PGSIZE]--;
80102e17:	8b 45 08             	mov    0x8(%ebp),%eax
80102e1a:	c1 e8 0c             	shr    $0xc,%eax
80102e1d:	8b 14 85 c0 26 11 80 	mov    -0x7feed940(,%eax,4),%edx
80102e24:	83 ea 01             	sub    $0x1,%edx
80102e27:	89 14 85 c0 26 11 80 	mov    %edx,-0x7feed940(,%eax,4)
80102e2e:	90                   	nop
80102e2f:	5d                   	pop    %ebp
80102e30:	c3                   	ret

80102e31 <inb>:
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"

80102e31:	55                   	push   %ebp
80102e32:	89 e5                	mov    %esp,%ebp
80102e34:	83 ec 14             	sub    $0x14,%esp
80102e37:	8b 45 08             	mov    0x8(%ebp),%eax
80102e3a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
int
kbdgetc(void)
{
80102e3e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e42:	89 c2                	mov    %eax,%edx
80102e44:	ec                   	in     (%dx),%al
80102e45:	88 45 ff             	mov    %al,-0x1(%ebp)
  static uint shift;
80102e48:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
  static uchar *charcode[4] = {
80102e4c:	c9                   	leave
80102e4d:	c3                   	ret

80102e4e <kbdgetc>:
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
80102e51:	83 ec 10             	sub    $0x10,%esp
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e54:	6a 64                	push   $0x64
80102e56:	e8 d6 ff ff ff       	call   80102e31 <inb>
80102e5b:	83 c4 04             	add    $0x4,%esp
80102e5e:	0f b6 c0             	movzbl %al,%eax
80102e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e67:	83 e0 01             	and    $0x1,%eax
80102e6a:	85 c0                	test   %eax,%eax
80102e6c:	75 0a                	jne    80102e78 <kbdgetc+0x2a>
    return -1;
80102e6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e73:	e9 23 01 00 00       	jmp    80102f9b <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102e78:	6a 60                	push   $0x60
80102e7a:	e8 b2 ff ff ff       	call   80102e31 <inb>
80102e7f:	83 c4 04             	add    $0x4,%esp
80102e82:	0f b6 c0             	movzbl %al,%eax
80102e85:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102e88:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102e8f:	75 17                	jne    80102ea8 <kbdgetc+0x5a>
    shift |= E0ESC;
80102e91:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102e96:	83 c8 40             	or     $0x40,%eax
80102e99:	a3 c0 a6 14 80       	mov    %eax,0x8014a6c0
    return 0;
80102e9e:	b8 00 00 00 00       	mov    $0x0,%eax
80102ea3:	e9 f3 00 00 00       	jmp    80102f9b <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eab:	25 80 00 00 00       	and    $0x80,%eax
80102eb0:	85 c0                	test   %eax,%eax
80102eb2:	74 45                	je     80102ef9 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102eb4:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102eb9:	83 e0 40             	and    $0x40,%eax
80102ebc:	85 c0                	test   %eax,%eax
80102ebe:	75 08                	jne    80102ec8 <kbdgetc+0x7a>
80102ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ec3:	83 e0 7f             	and    $0x7f,%eax
80102ec6:	eb 03                	jmp    80102ecb <kbdgetc+0x7d>
80102ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ed1:	05 20 90 10 80       	add    $0x80109020,%eax
80102ed6:	0f b6 00             	movzbl (%eax),%eax
80102ed9:	83 c8 40             	or     $0x40,%eax
80102edc:	0f b6 c0             	movzbl %al,%eax
80102edf:	f7 d0                	not    %eax
80102ee1:	89 c2                	mov    %eax,%edx
80102ee3:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102ee8:	21 d0                	and    %edx,%eax
80102eea:	a3 c0 a6 14 80       	mov    %eax,0x8014a6c0
    return 0;
80102eef:	b8 00 00 00 00       	mov    $0x0,%eax
80102ef4:	e9 a2 00 00 00       	jmp    80102f9b <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102ef9:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102efe:	83 e0 40             	and    $0x40,%eax
80102f01:	85 c0                	test   %eax,%eax
80102f03:	74 14                	je     80102f19 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f05:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f0c:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102f11:	83 e0 bf             	and    $0xffffffbf,%eax
80102f14:	a3 c0 a6 14 80       	mov    %eax,0x8014a6c0
  }

  shift |= shiftcode[data];
80102f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f1c:	05 20 90 10 80       	add    $0x80109020,%eax
80102f21:	0f b6 00             	movzbl (%eax),%eax
80102f24:	0f b6 d0             	movzbl %al,%edx
80102f27:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102f2c:	09 d0                	or     %edx,%eax
80102f2e:	a3 c0 a6 14 80       	mov    %eax,0x8014a6c0
  shift ^= togglecode[data];
80102f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f36:	05 20 91 10 80       	add    $0x80109120,%eax
80102f3b:	0f b6 00             	movzbl (%eax),%eax
80102f3e:	0f b6 d0             	movzbl %al,%edx
80102f41:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102f46:	31 d0                	xor    %edx,%eax
80102f48:	a3 c0 a6 14 80       	mov    %eax,0x8014a6c0
  c = charcode[shift & (CTL | SHIFT)][data];
80102f4d:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102f52:	83 e0 03             	and    $0x3,%eax
80102f55:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f5f:	01 d0                	add    %edx,%eax
80102f61:	0f b6 00             	movzbl (%eax),%eax
80102f64:	0f b6 c0             	movzbl %al,%eax
80102f67:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f6a:	a1 c0 a6 14 80       	mov    0x8014a6c0,%eax
80102f6f:	83 e0 08             	and    $0x8,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	74 22                	je     80102f98 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102f76:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f7a:	76 0c                	jbe    80102f88 <kbdgetc+0x13a>
80102f7c:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f80:	77 06                	ja     80102f88 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102f82:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102f86:	eb 10                	jmp    80102f98 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102f88:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102f8c:	76 0a                	jbe    80102f98 <kbdgetc+0x14a>
80102f8e:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f92:	77 04                	ja     80102f98 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102f94:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f9b:	c9                   	leave
80102f9c:	c3                   	ret

80102f9d <kbdintr>:

void
kbdintr(void)
{
80102f9d:	55                   	push   %ebp
80102f9e:	89 e5                	mov    %esp,%ebp
80102fa0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102fa3:	83 ec 0c             	sub    $0xc,%esp
80102fa6:	68 4e 2e 10 80       	push   $0x80102e4e
80102fab:	e8 99 d8 ff ff       	call   80100849 <consoleintr>
80102fb0:	83 c4 10             	add    $0x10,%esp
}
80102fb3:	90                   	nop
80102fb4:	c9                   	leave
80102fb5:	c3                   	ret

80102fb6 <inb>:
// The local APIC manages internal (non-I/O) interrupts.
// See Chapter 8 & Appendix C of Intel processor manual volume 3.

#include "param.h"
#include "types.h"
80102fb6:	55                   	push   %ebp
80102fb7:	89 e5                	mov    %esp,%ebp
80102fb9:	83 ec 14             	sub    $0x14,%esp
80102fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80102fbf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
#include "defs.h"
#include "date.h"
#include "memlayout.h"
80102fc3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fc7:	89 c2                	mov    %eax,%edx
80102fc9:	ec                   	in     (%dx),%al
80102fca:	88 45 ff             	mov    %al,-0x1(%ebp)
#include "traps.h"
80102fcd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
#include "mmu.h"
80102fd1:	c9                   	leave
80102fd2:	c3                   	ret

80102fd3 <outb>:
#define SVR     (0x00F0/4)   // Spurious Interrupt Vector
  #define ENABLE     0x00000100   // Unit Enable
#define ESR     (0x0280/4)   // Error Status
#define ICRLO   (0x0300/4)   // Interrupt Command
  #define INIT       0x00000500   // INIT/RESET
  #define STARTUP    0x00000600   // Startup IPI
80102fd3:	55                   	push   %ebp
80102fd4:	89 e5                	mov    %esp,%ebp
80102fd6:	83 ec 08             	sub    $0x8,%esp
80102fd9:	8b 55 08             	mov    0x8(%ebp),%edx
80102fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fdf:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102fe3:	88 45 f8             	mov    %al,-0x8(%ebp)
  #define DELIVS     0x00001000   // Delivery status
80102fe6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102fea:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102fee:	ee                   	out    %al,(%dx)
  #define ASSERT     0x00004000   // Assert interrupt (vs deassert)
80102fef:	90                   	nop
80102ff0:	c9                   	leave
80102ff1:	c3                   	ret

80102ff2 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102ff2:	55                   	push   %ebp
80102ff3:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102ff5:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
80102ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80102ffd:	c1 e2 02             	shl    $0x2,%edx
80103000:	01 c2                	add    %eax,%edx
80103002:	8b 45 0c             	mov    0xc(%ebp),%eax
80103005:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80103007:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
8010300c:	83 c0 20             	add    $0x20,%eax
8010300f:	8b 00                	mov    (%eax),%eax
}
80103011:	90                   	nop
80103012:	5d                   	pop    %ebp
80103013:	c3                   	ret

80103014 <lapicinit>:

void
lapicinit(void)
{
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103017:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
8010301c:	85 c0                	test   %eax,%eax
8010301e:	0f 84 09 01 00 00    	je     8010312d <lapicinit+0x119>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103024:	68 3f 01 00 00       	push   $0x13f
80103029:	6a 3c                	push   $0x3c
8010302b:	e8 c2 ff ff ff       	call   80102ff2 <lapicw>
80103030:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103033:	6a 0b                	push   $0xb
80103035:	68 f8 00 00 00       	push   $0xf8
8010303a:	e8 b3 ff ff ff       	call   80102ff2 <lapicw>
8010303f:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103042:	68 20 00 02 00       	push   $0x20020
80103047:	68 c8 00 00 00       	push   $0xc8
8010304c:	e8 a1 ff ff ff       	call   80102ff2 <lapicw>
80103051:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80103054:	68 80 96 98 00       	push   $0x989680
80103059:	68 e0 00 00 00       	push   $0xe0
8010305e:	e8 8f ff ff ff       	call   80102ff2 <lapicw>
80103063:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103066:	68 00 00 01 00       	push   $0x10000
8010306b:	68 d4 00 00 00       	push   $0xd4
80103070:	e8 7d ff ff ff       	call   80102ff2 <lapicw>
80103075:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103078:	68 00 00 01 00       	push   $0x10000
8010307d:	68 d8 00 00 00       	push   $0xd8
80103082:	e8 6b ff ff ff       	call   80102ff2 <lapicw>
80103087:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010308a:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
8010308f:	83 c0 30             	add    $0x30,%eax
80103092:	8b 00                	mov    (%eax),%eax
80103094:	25 00 00 fc 00       	and    $0xfc0000,%eax
80103099:	85 c0                	test   %eax,%eax
8010309b:	74 12                	je     801030af <lapicinit+0x9b>
    lapicw(PCINT, MASKED);
8010309d:	68 00 00 01 00       	push   $0x10000
801030a2:	68 d0 00 00 00       	push   $0xd0
801030a7:	e8 46 ff ff ff       	call   80102ff2 <lapicw>
801030ac:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030af:	6a 33                	push   $0x33
801030b1:	68 dc 00 00 00       	push   $0xdc
801030b6:	e8 37 ff ff ff       	call   80102ff2 <lapicw>
801030bb:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801030be:	6a 00                	push   $0x0
801030c0:	68 a0 00 00 00       	push   $0xa0
801030c5:	e8 28 ff ff ff       	call   80102ff2 <lapicw>
801030ca:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801030cd:	6a 00                	push   $0x0
801030cf:	68 a0 00 00 00       	push   $0xa0
801030d4:	e8 19 ff ff ff       	call   80102ff2 <lapicw>
801030d9:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801030dc:	6a 00                	push   $0x0
801030de:	6a 2c                	push   $0x2c
801030e0:	e8 0d ff ff ff       	call   80102ff2 <lapicw>
801030e5:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801030e8:	6a 00                	push   $0x0
801030ea:	68 c4 00 00 00       	push   $0xc4
801030ef:	e8 fe fe ff ff       	call   80102ff2 <lapicw>
801030f4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801030f7:	68 00 85 08 00       	push   $0x88500
801030fc:	68 c0 00 00 00       	push   $0xc0
80103101:	e8 ec fe ff ff       	call   80102ff2 <lapicw>
80103106:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103109:	90                   	nop
8010310a:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
8010310f:	05 00 03 00 00       	add    $0x300,%eax
80103114:	8b 00                	mov    (%eax),%eax
80103116:	25 00 10 00 00       	and    $0x1000,%eax
8010311b:	85 c0                	test   %eax,%eax
8010311d:	75 eb                	jne    8010310a <lapicinit+0xf6>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010311f:	6a 00                	push   $0x0
80103121:	6a 20                	push   $0x20
80103123:	e8 ca fe ff ff       	call   80102ff2 <lapicw>
80103128:	83 c4 08             	add    $0x8,%esp
8010312b:	eb 01                	jmp    8010312e <lapicinit+0x11a>
    return;
8010312d:	90                   	nop
}
8010312e:	c9                   	leave
8010312f:	c3                   	ret

80103130 <lapicid>:

int
lapicid(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103133:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
80103138:	85 c0                	test   %eax,%eax
8010313a:	75 07                	jne    80103143 <lapicid+0x13>
    return 0;
8010313c:	b8 00 00 00 00       	mov    $0x0,%eax
80103141:	eb 0d                	jmp    80103150 <lapicid+0x20>
  return lapic[ID] >> 24;
80103143:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
80103148:	83 c0 20             	add    $0x20,%eax
8010314b:	8b 00                	mov    (%eax),%eax
8010314d:	c1 e8 18             	shr    $0x18,%eax
}
80103150:	5d                   	pop    %ebp
80103151:	c3                   	ret

80103152 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103152:	55                   	push   %ebp
80103153:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103155:	a1 c4 a6 14 80       	mov    0x8014a6c4,%eax
8010315a:	85 c0                	test   %eax,%eax
8010315c:	74 0c                	je     8010316a <lapiceoi+0x18>
    lapicw(EOI, 0);
8010315e:	6a 00                	push   $0x0
80103160:	6a 2c                	push   $0x2c
80103162:	e8 8b fe ff ff       	call   80102ff2 <lapicw>
80103167:	83 c4 08             	add    $0x8,%esp
}
8010316a:	90                   	nop
8010316b:	c9                   	leave
8010316c:	c3                   	ret

8010316d <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010316d:	55                   	push   %ebp
8010316e:	89 e5                	mov    %esp,%ebp
}
80103170:	90                   	nop
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret

80103173 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103173:	55                   	push   %ebp
80103174:	89 e5                	mov    %esp,%ebp
80103176:	83 ec 14             	sub    $0x14,%esp
80103179:	8b 45 08             	mov    0x8(%ebp),%eax
8010317c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010317f:	6a 0f                	push   $0xf
80103181:	6a 70                	push   $0x70
80103183:	e8 4b fe ff ff       	call   80102fd3 <outb>
80103188:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010318b:	6a 0a                	push   $0xa
8010318d:	6a 71                	push   $0x71
8010318f:	e8 3f fe ff ff       	call   80102fd3 <outb>
80103194:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103197:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010319e:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031a1:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801031a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801031a9:	c1 e8 04             	shr    $0x4,%eax
801031ac:	89 c2                	mov    %eax,%edx
801031ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031b1:	83 c0 02             	add    $0x2,%eax
801031b4:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031b7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031bb:	c1 e0 18             	shl    $0x18,%eax
801031be:	50                   	push   %eax
801031bf:	68 c4 00 00 00       	push   $0xc4
801031c4:	e8 29 fe ff ff       	call   80102ff2 <lapicw>
801031c9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801031cc:	68 00 c5 00 00       	push   $0xc500
801031d1:	68 c0 00 00 00       	push   $0xc0
801031d6:	e8 17 fe ff ff       	call   80102ff2 <lapicw>
801031db:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031de:	68 c8 00 00 00       	push   $0xc8
801031e3:	e8 85 ff ff ff       	call   8010316d <microdelay>
801031e8:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801031eb:	68 00 85 00 00       	push   $0x8500
801031f0:	68 c0 00 00 00       	push   $0xc0
801031f5:	e8 f8 fd ff ff       	call   80102ff2 <lapicw>
801031fa:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801031fd:	6a 64                	push   $0x64
801031ff:	e8 69 ff ff ff       	call   8010316d <microdelay>
80103204:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010320e:	eb 3d                	jmp    8010324d <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80103210:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103214:	c1 e0 18             	shl    $0x18,%eax
80103217:	50                   	push   %eax
80103218:	68 c4 00 00 00       	push   $0xc4
8010321d:	e8 d0 fd ff ff       	call   80102ff2 <lapicw>
80103222:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103225:	8b 45 0c             	mov    0xc(%ebp),%eax
80103228:	c1 e8 0c             	shr    $0xc,%eax
8010322b:	80 cc 06             	or     $0x6,%ah
8010322e:	50                   	push   %eax
8010322f:	68 c0 00 00 00       	push   $0xc0
80103234:	e8 b9 fd ff ff       	call   80102ff2 <lapicw>
80103239:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010323c:	68 c8 00 00 00       	push   $0xc8
80103241:	e8 27 ff ff ff       	call   8010316d <microdelay>
80103246:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103249:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010324d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103251:	7e bd                	jle    80103210 <lapicstartap+0x9d>
  }
}
80103253:	90                   	nop
80103254:	90                   	nop
80103255:	c9                   	leave
80103256:	c3                   	ret

80103257 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
80103257:	55                   	push   %ebp
80103258:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010325a:	8b 45 08             	mov    0x8(%ebp),%eax
8010325d:	0f b6 c0             	movzbl %al,%eax
80103260:	50                   	push   %eax
80103261:	6a 70                	push   $0x70
80103263:	e8 6b fd ff ff       	call   80102fd3 <outb>
80103268:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010326b:	68 c8 00 00 00       	push   $0xc8
80103270:	e8 f8 fe ff ff       	call   8010316d <microdelay>
80103275:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103278:	6a 71                	push   $0x71
8010327a:	e8 37 fd ff ff       	call   80102fb6 <inb>
8010327f:	83 c4 04             	add    $0x4,%esp
80103282:	0f b6 c0             	movzbl %al,%eax
}
80103285:	c9                   	leave
80103286:	c3                   	ret

80103287 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80103287:	55                   	push   %ebp
80103288:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010328a:	6a 00                	push   $0x0
8010328c:	e8 c6 ff ff ff       	call   80103257 <cmos_read>
80103291:	83 c4 04             	add    $0x4,%esp
80103294:	8b 55 08             	mov    0x8(%ebp),%edx
80103297:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103299:	6a 02                	push   $0x2
8010329b:	e8 b7 ff ff ff       	call   80103257 <cmos_read>
801032a0:	83 c4 04             	add    $0x4,%esp
801032a3:	8b 55 08             	mov    0x8(%ebp),%edx
801032a6:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801032a9:	6a 04                	push   $0x4
801032ab:	e8 a7 ff ff ff       	call   80103257 <cmos_read>
801032b0:	83 c4 04             	add    $0x4,%esp
801032b3:	8b 55 08             	mov    0x8(%ebp),%edx
801032b6:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801032b9:	6a 07                	push   $0x7
801032bb:	e8 97 ff ff ff       	call   80103257 <cmos_read>
801032c0:	83 c4 04             	add    $0x4,%esp
801032c3:	8b 55 08             	mov    0x8(%ebp),%edx
801032c6:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801032c9:	6a 08                	push   $0x8
801032cb:	e8 87 ff ff ff       	call   80103257 <cmos_read>
801032d0:	83 c4 04             	add    $0x4,%esp
801032d3:	8b 55 08             	mov    0x8(%ebp),%edx
801032d6:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801032d9:	6a 09                	push   $0x9
801032db:	e8 77 ff ff ff       	call   80103257 <cmos_read>
801032e0:	83 c4 04             	add    $0x4,%esp
801032e3:	8b 55 08             	mov    0x8(%ebp),%edx
801032e6:	89 42 14             	mov    %eax,0x14(%edx)
}
801032e9:	90                   	nop
801032ea:	c9                   	leave
801032eb:	c3                   	ret

801032ec <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801032ec:	55                   	push   %ebp
801032ed:	89 e5                	mov    %esp,%ebp
801032ef:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801032f2:	6a 0b                	push   $0xb
801032f4:	e8 5e ff ff ff       	call   80103257 <cmos_read>
801032f9:	83 c4 04             	add    $0x4,%esp
801032fc:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103302:	83 e0 04             	and    $0x4,%eax
80103305:	85 c0                	test   %eax,%eax
80103307:	0f 94 c0             	sete   %al
8010330a:	0f b6 c0             	movzbl %al,%eax
8010330d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103310:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103313:	50                   	push   %eax
80103314:	e8 6e ff ff ff       	call   80103287 <fill_rtcdate>
80103319:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010331c:	6a 0a                	push   $0xa
8010331e:	e8 34 ff ff ff       	call   80103257 <cmos_read>
80103323:	83 c4 04             	add    $0x4,%esp
80103326:	25 80 00 00 00       	and    $0x80,%eax
8010332b:	85 c0                	test   %eax,%eax
8010332d:	75 27                	jne    80103356 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010332f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103332:	50                   	push   %eax
80103333:	e8 4f ff ff ff       	call   80103287 <fill_rtcdate>
80103338:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010333b:	83 ec 04             	sub    $0x4,%esp
8010333e:	6a 18                	push   $0x18
80103340:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103343:	50                   	push   %eax
80103344:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103347:	50                   	push   %eax
80103348:	e8 5f 20 00 00       	call   801053ac <memcmp>
8010334d:	83 c4 10             	add    $0x10,%esp
80103350:	85 c0                	test   %eax,%eax
80103352:	74 05                	je     80103359 <cmostime+0x6d>
80103354:	eb ba                	jmp    80103310 <cmostime+0x24>
        continue;
80103356:	90                   	nop
    fill_rtcdate(&t1);
80103357:	eb b7                	jmp    80103310 <cmostime+0x24>
      break;
80103359:	90                   	nop
  }

  // convert
  if(bcd) {
8010335a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010335e:	0f 84 b4 00 00 00    	je     80103418 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103364:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103367:	c1 e8 04             	shr    $0x4,%eax
8010336a:	89 c2                	mov    %eax,%edx
8010336c:	89 d0                	mov    %edx,%eax
8010336e:	c1 e0 02             	shl    $0x2,%eax
80103371:	01 d0                	add    %edx,%eax
80103373:	01 c0                	add    %eax,%eax
80103375:	89 c2                	mov    %eax,%edx
80103377:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010337a:	83 e0 0f             	and    $0xf,%eax
8010337d:	01 d0                	add    %edx,%eax
8010337f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103382:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103385:	c1 e8 04             	shr    $0x4,%eax
80103388:	89 c2                	mov    %eax,%edx
8010338a:	89 d0                	mov    %edx,%eax
8010338c:	c1 e0 02             	shl    $0x2,%eax
8010338f:	01 d0                	add    %edx,%eax
80103391:	01 c0                	add    %eax,%eax
80103393:	89 c2                	mov    %eax,%edx
80103395:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103398:	83 e0 0f             	and    $0xf,%eax
8010339b:	01 d0                	add    %edx,%eax
8010339d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801033a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033a3:	c1 e8 04             	shr    $0x4,%eax
801033a6:	89 c2                	mov    %eax,%edx
801033a8:	89 d0                	mov    %edx,%eax
801033aa:	c1 e0 02             	shl    $0x2,%eax
801033ad:	01 d0                	add    %edx,%eax
801033af:	01 c0                	add    %eax,%eax
801033b1:	89 c2                	mov    %eax,%edx
801033b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033b6:	83 e0 0f             	and    $0xf,%eax
801033b9:	01 d0                	add    %edx,%eax
801033bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033c1:	c1 e8 04             	shr    $0x4,%eax
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	89 d0                	mov    %edx,%eax
801033c8:	c1 e0 02             	shl    $0x2,%eax
801033cb:	01 d0                	add    %edx,%eax
801033cd:	01 c0                	add    %eax,%eax
801033cf:	89 c2                	mov    %eax,%edx
801033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033d4:	83 e0 0f             	and    $0xf,%eax
801033d7:	01 d0                	add    %edx,%eax
801033d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033df:	c1 e8 04             	shr    $0x4,%eax
801033e2:	89 c2                	mov    %eax,%edx
801033e4:	89 d0                	mov    %edx,%eax
801033e6:	c1 e0 02             	shl    $0x2,%eax
801033e9:	01 d0                	add    %edx,%eax
801033eb:	01 c0                	add    %eax,%eax
801033ed:	89 c2                	mov    %eax,%edx
801033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033f2:	83 e0 0f             	and    $0xf,%eax
801033f5:	01 d0                	add    %edx,%eax
801033f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fd:	c1 e8 04             	shr    $0x4,%eax
80103400:	89 c2                	mov    %eax,%edx
80103402:	89 d0                	mov    %edx,%eax
80103404:	c1 e0 02             	shl    $0x2,%eax
80103407:	01 d0                	add    %edx,%eax
80103409:	01 c0                	add    %eax,%eax
8010340b:	89 c2                	mov    %eax,%edx
8010340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103410:	83 e0 0f             	and    $0xf,%eax
80103413:	01 d0                	add    %edx,%eax
80103415:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103418:	8b 45 08             	mov    0x8(%ebp),%eax
8010341b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010341e:	89 10                	mov    %edx,(%eax)
80103420:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103423:	89 50 04             	mov    %edx,0x4(%eax)
80103426:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103429:	89 50 08             	mov    %edx,0x8(%eax)
8010342c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010342f:	89 50 0c             	mov    %edx,0xc(%eax)
80103432:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103435:	89 50 10             	mov    %edx,0x10(%eax)
80103438:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010343b:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010343e:	8b 45 08             	mov    0x8(%ebp),%eax
80103441:	8b 40 14             	mov    0x14(%eax),%eax
80103444:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010344a:	8b 45 08             	mov    0x8(%ebp),%eax
8010344d:	89 50 14             	mov    %edx,0x14(%eax)
}
80103450:	90                   	nop
80103451:	c9                   	leave
80103452:	c3                   	ret

80103453 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103453:	55                   	push   %ebp
80103454:	89 e5                	mov    %esp,%ebp
80103456:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103459:	83 ec 08             	sub    $0x8,%esp
8010345c:	68 0f 89 10 80       	push   $0x8010890f
80103461:	68 e0 a6 14 80       	push   $0x8014a6e0
80103466:	e8 32 1c 00 00       	call   8010509d <initlock>
8010346b:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010346e:	83 ec 08             	sub    $0x8,%esp
80103471:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103474:	50                   	push   %eax
80103475:	ff 75 08             	push   0x8(%ebp)
80103478:	e8 98 df ff ff       	call   80101415 <readsb>
8010347d:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103480:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103483:	a3 14 a7 14 80       	mov    %eax,0x8014a714
  log.size = sb.nlog;
80103488:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010348b:	a3 18 a7 14 80       	mov    %eax,0x8014a718
  log.dev = dev;
80103490:	8b 45 08             	mov    0x8(%ebp),%eax
80103493:	a3 24 a7 14 80       	mov    %eax,0x8014a724
  recover_from_log();
80103498:	e8 b3 01 00 00       	call   80103650 <recover_from_log>
}
8010349d:	90                   	nop
8010349e:	c9                   	leave
8010349f:	c3                   	ret

801034a0 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034ad:	e9 95 00 00 00       	jmp    80103547 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034b2:	8b 15 14 a7 14 80    	mov    0x8014a714,%edx
801034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034bb:	01 d0                	add    %edx,%eax
801034bd:	83 c0 01             	add    $0x1,%eax
801034c0:	89 c2                	mov    %eax,%edx
801034c2:	a1 24 a7 14 80       	mov    0x8014a724,%eax
801034c7:	83 ec 08             	sub    $0x8,%esp
801034ca:	52                   	push   %edx
801034cb:	50                   	push   %eax
801034cc:	e8 fe cc ff ff       	call   801001cf <bread>
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034da:	83 c0 10             	add    $0x10,%eax
801034dd:	8b 04 85 ec a6 14 80 	mov    -0x7feb5914(,%eax,4),%eax
801034e4:	89 c2                	mov    %eax,%edx
801034e6:	a1 24 a7 14 80       	mov    0x8014a724,%eax
801034eb:	83 ec 08             	sub    $0x8,%esp
801034ee:	52                   	push   %edx
801034ef:	50                   	push   %eax
801034f0:	e8 da cc ff ff       	call   801001cf <bread>
801034f5:	83 c4 10             	add    $0x10,%esp
801034f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034fe:	8d 50 5c             	lea    0x5c(%eax),%edx
80103501:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103504:	83 c0 5c             	add    $0x5c,%eax
80103507:	83 ec 04             	sub    $0x4,%esp
8010350a:	68 00 02 00 00       	push   $0x200
8010350f:	52                   	push   %edx
80103510:	50                   	push   %eax
80103511:	e8 ee 1e 00 00       	call   80105404 <memmove>
80103516:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103519:	83 ec 0c             	sub    $0xc,%esp
8010351c:	ff 75 ec             	push   -0x14(%ebp)
8010351f:	e8 e4 cc ff ff       	call   80100208 <bwrite>
80103524:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103527:	83 ec 0c             	sub    $0xc,%esp
8010352a:	ff 75 f0             	push   -0x10(%ebp)
8010352d:	e8 1f cd ff ff       	call   80100251 <brelse>
80103532:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	ff 75 ec             	push   -0x14(%ebp)
8010353b:	e8 11 cd ff ff       	call   80100251 <brelse>
80103540:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103543:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103547:	a1 28 a7 14 80       	mov    0x8014a728,%eax
8010354c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010354f:	0f 8c 5d ff ff ff    	jl     801034b2 <install_trans+0x12>
  }
}
80103555:	90                   	nop
80103556:	90                   	nop
80103557:	c9                   	leave
80103558:	c3                   	ret

80103559 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103559:	55                   	push   %ebp
8010355a:	89 e5                	mov    %esp,%ebp
8010355c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010355f:	a1 14 a7 14 80       	mov    0x8014a714,%eax
80103564:	89 c2                	mov    %eax,%edx
80103566:	a1 24 a7 14 80       	mov    0x8014a724,%eax
8010356b:	83 ec 08             	sub    $0x8,%esp
8010356e:	52                   	push   %edx
8010356f:	50                   	push   %eax
80103570:	e8 5a cc ff ff       	call   801001cf <bread>
80103575:	83 c4 10             	add    $0x10,%esp
80103578:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010357e:	83 c0 5c             	add    $0x5c,%eax
80103581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103584:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103587:	8b 00                	mov    (%eax),%eax
80103589:	a3 28 a7 14 80       	mov    %eax,0x8014a728
  for (i = 0; i < log.lh.n; i++) {
8010358e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103595:	eb 1b                	jmp    801035b2 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103597:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010359a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010359d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801035a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035a4:	83 c2 10             	add    $0x10,%edx
801035a7:	89 04 95 ec a6 14 80 	mov    %eax,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035b2:	a1 28 a7 14 80       	mov    0x8014a728,%eax
801035b7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035ba:	7c db                	jl     80103597 <read_head+0x3e>
  }
  brelse(buf);
801035bc:	83 ec 0c             	sub    $0xc,%esp
801035bf:	ff 75 f0             	push   -0x10(%ebp)
801035c2:	e8 8a cc ff ff       	call   80100251 <brelse>
801035c7:	83 c4 10             	add    $0x10,%esp
}
801035ca:	90                   	nop
801035cb:	c9                   	leave
801035cc:	c3                   	ret

801035cd <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801035cd:	55                   	push   %ebp
801035ce:	89 e5                	mov    %esp,%ebp
801035d0:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035d3:	a1 14 a7 14 80       	mov    0x8014a714,%eax
801035d8:	89 c2                	mov    %eax,%edx
801035da:	a1 24 a7 14 80       	mov    0x8014a724,%eax
801035df:	83 ec 08             	sub    $0x8,%esp
801035e2:	52                   	push   %edx
801035e3:	50                   	push   %eax
801035e4:	e8 e6 cb ff ff       	call   801001cf <bread>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801035ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035f2:	83 c0 5c             	add    $0x5c,%eax
801035f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801035f8:	8b 15 28 a7 14 80    	mov    0x8014a728,%edx
801035fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103601:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010360a:	eb 1b                	jmp    80103627 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010360f:	83 c0 10             	add    $0x10,%eax
80103612:	8b 0c 85 ec a6 14 80 	mov    -0x7feb5914(,%eax,4),%ecx
80103619:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010361c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010361f:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103623:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103627:	a1 28 a7 14 80       	mov    0x8014a728,%eax
8010362c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010362f:	7c db                	jl     8010360c <write_head+0x3f>
  }
  bwrite(buf);
80103631:	83 ec 0c             	sub    $0xc,%esp
80103634:	ff 75 f0             	push   -0x10(%ebp)
80103637:	e8 cc cb ff ff       	call   80100208 <bwrite>
8010363c:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010363f:	83 ec 0c             	sub    $0xc,%esp
80103642:	ff 75 f0             	push   -0x10(%ebp)
80103645:	e8 07 cc ff ff       	call   80100251 <brelse>
8010364a:	83 c4 10             	add    $0x10,%esp
}
8010364d:	90                   	nop
8010364e:	c9                   	leave
8010364f:	c3                   	ret

80103650 <recover_from_log>:

static void
recover_from_log(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103656:	e8 fe fe ff ff       	call   80103559 <read_head>
  install_trans(); // if committed, copy from log to disk
8010365b:	e8 40 fe ff ff       	call   801034a0 <install_trans>
  log.lh.n = 0;
80103660:	c7 05 28 a7 14 80 00 	movl   $0x0,0x8014a728
80103667:	00 00 00 
  write_head(); // clear the log
8010366a:	e8 5e ff ff ff       	call   801035cd <write_head>
}
8010366f:	90                   	nop
80103670:	c9                   	leave
80103671:	c3                   	ret

80103672 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103672:	55                   	push   %ebp
80103673:	89 e5                	mov    %esp,%ebp
80103675:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	68 e0 a6 14 80       	push   $0x8014a6e0
80103680:	e8 3a 1a 00 00       	call   801050bf <acquire>
80103685:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103688:	a1 20 a7 14 80       	mov    0x8014a720,%eax
8010368d:	85 c0                	test   %eax,%eax
8010368f:	74 17                	je     801036a8 <begin_op+0x36>
      sleep(&log, &log.lock);
80103691:	83 ec 08             	sub    $0x8,%esp
80103694:	68 e0 a6 14 80       	push   $0x8014a6e0
80103699:	68 e0 a6 14 80       	push   $0x8014a6e0
8010369e:	e8 db 15 00 00       	call   80104c7e <sleep>
801036a3:	83 c4 10             	add    $0x10,%esp
801036a6:	eb e0                	jmp    80103688 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801036a8:	8b 0d 28 a7 14 80    	mov    0x8014a728,%ecx
801036ae:	a1 1c a7 14 80       	mov    0x8014a71c,%eax
801036b3:	8d 50 01             	lea    0x1(%eax),%edx
801036b6:	89 d0                	mov    %edx,%eax
801036b8:	c1 e0 02             	shl    $0x2,%eax
801036bb:	01 d0                	add    %edx,%eax
801036bd:	01 c0                	add    %eax,%eax
801036bf:	01 c8                	add    %ecx,%eax
801036c1:	83 f8 1e             	cmp    $0x1e,%eax
801036c4:	7e 17                	jle    801036dd <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801036c6:	83 ec 08             	sub    $0x8,%esp
801036c9:	68 e0 a6 14 80       	push   $0x8014a6e0
801036ce:	68 e0 a6 14 80       	push   $0x8014a6e0
801036d3:	e8 a6 15 00 00       	call   80104c7e <sleep>
801036d8:	83 c4 10             	add    $0x10,%esp
801036db:	eb ab                	jmp    80103688 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801036dd:	a1 1c a7 14 80       	mov    0x8014a71c,%eax
801036e2:	83 c0 01             	add    $0x1,%eax
801036e5:	a3 1c a7 14 80       	mov    %eax,0x8014a71c
      release(&log.lock);
801036ea:	83 ec 0c             	sub    $0xc,%esp
801036ed:	68 e0 a6 14 80       	push   $0x8014a6e0
801036f2:	e8 36 1a 00 00       	call   8010512d <release>
801036f7:	83 c4 10             	add    $0x10,%esp
      break;
801036fa:	90                   	nop
    }
  }
}
801036fb:	90                   	nop
801036fc:	c9                   	leave
801036fd:	c3                   	ret

801036fe <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801036fe:	55                   	push   %ebp
801036ff:	89 e5                	mov    %esp,%ebp
80103701:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	68 e0 a6 14 80       	push   $0x8014a6e0
80103713:	e8 a7 19 00 00       	call   801050bf <acquire>
80103718:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010371b:	a1 1c a7 14 80       	mov    0x8014a71c,%eax
80103720:	83 e8 01             	sub    $0x1,%eax
80103723:	a3 1c a7 14 80       	mov    %eax,0x8014a71c
  if(log.committing)
80103728:	a1 20 a7 14 80       	mov    0x8014a720,%eax
8010372d:	85 c0                	test   %eax,%eax
8010372f:	74 0d                	je     8010373e <end_op+0x40>
    panic("log.committing");
80103731:	83 ec 0c             	sub    $0xc,%esp
80103734:	68 13 89 10 80       	push   $0x80108913
80103739:	e8 75 ce ff ff       	call   801005b3 <panic>
  if(log.outstanding == 0){
8010373e:	a1 1c a7 14 80       	mov    0x8014a71c,%eax
80103743:	85 c0                	test   %eax,%eax
80103745:	75 13                	jne    8010375a <end_op+0x5c>
    do_commit = 1;
80103747:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010374e:	c7 05 20 a7 14 80 01 	movl   $0x1,0x8014a720
80103755:	00 00 00 
80103758:	eb 10                	jmp    8010376a <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	68 e0 a6 14 80       	push   $0x8014a6e0
80103762:	e8 fe 15 00 00       	call   80104d65 <wakeup>
80103767:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010376a:	83 ec 0c             	sub    $0xc,%esp
8010376d:	68 e0 a6 14 80       	push   $0x8014a6e0
80103772:	e8 b6 19 00 00       	call   8010512d <release>
80103777:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010377a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010377e:	74 3f                	je     801037bf <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103780:	e8 f6 00 00 00       	call   8010387b <commit>
    acquire(&log.lock);
80103785:	83 ec 0c             	sub    $0xc,%esp
80103788:	68 e0 a6 14 80       	push   $0x8014a6e0
8010378d:	e8 2d 19 00 00       	call   801050bf <acquire>
80103792:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103795:	c7 05 20 a7 14 80 00 	movl   $0x0,0x8014a720
8010379c:	00 00 00 
    wakeup(&log);
8010379f:	83 ec 0c             	sub    $0xc,%esp
801037a2:	68 e0 a6 14 80       	push   $0x8014a6e0
801037a7:	e8 b9 15 00 00       	call   80104d65 <wakeup>
801037ac:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801037af:	83 ec 0c             	sub    $0xc,%esp
801037b2:	68 e0 a6 14 80       	push   $0x8014a6e0
801037b7:	e8 71 19 00 00       	call   8010512d <release>
801037bc:	83 c4 10             	add    $0x10,%esp
  }
}
801037bf:	90                   	nop
801037c0:	c9                   	leave
801037c1:	c3                   	ret

801037c2 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801037c2:	55                   	push   %ebp
801037c3:	89 e5                	mov    %esp,%ebp
801037c5:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037cf:	e9 95 00 00 00       	jmp    80103869 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801037d4:	8b 15 14 a7 14 80    	mov    0x8014a714,%edx
801037da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037dd:	01 d0                	add    %edx,%eax
801037df:	83 c0 01             	add    $0x1,%eax
801037e2:	89 c2                	mov    %eax,%edx
801037e4:	a1 24 a7 14 80       	mov    0x8014a724,%eax
801037e9:	83 ec 08             	sub    $0x8,%esp
801037ec:	52                   	push   %edx
801037ed:	50                   	push   %eax
801037ee:	e8 dc c9 ff ff       	call   801001cf <bread>
801037f3:	83 c4 10             	add    $0x10,%esp
801037f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037fc:	83 c0 10             	add    $0x10,%eax
801037ff:	8b 04 85 ec a6 14 80 	mov    -0x7feb5914(,%eax,4),%eax
80103806:	89 c2                	mov    %eax,%edx
80103808:	a1 24 a7 14 80       	mov    0x8014a724,%eax
8010380d:	83 ec 08             	sub    $0x8,%esp
80103810:	52                   	push   %edx
80103811:	50                   	push   %eax
80103812:	e8 b8 c9 ff ff       	call   801001cf <bread>
80103817:	83 c4 10             	add    $0x10,%esp
8010381a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010381d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103820:	8d 50 5c             	lea    0x5c(%eax),%edx
80103823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103826:	83 c0 5c             	add    $0x5c,%eax
80103829:	83 ec 04             	sub    $0x4,%esp
8010382c:	68 00 02 00 00       	push   $0x200
80103831:	52                   	push   %edx
80103832:	50                   	push   %eax
80103833:	e8 cc 1b 00 00       	call   80105404 <memmove>
80103838:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010383b:	83 ec 0c             	sub    $0xc,%esp
8010383e:	ff 75 f0             	push   -0x10(%ebp)
80103841:	e8 c2 c9 ff ff       	call   80100208 <bwrite>
80103846:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	ff 75 ec             	push   -0x14(%ebp)
8010384f:	e8 fd c9 ff ff       	call   80100251 <brelse>
80103854:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103857:	83 ec 0c             	sub    $0xc,%esp
8010385a:	ff 75 f0             	push   -0x10(%ebp)
8010385d:	e8 ef c9 ff ff       	call   80100251 <brelse>
80103862:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103865:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103869:	a1 28 a7 14 80       	mov    0x8014a728,%eax
8010386e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103871:	0f 8c 5d ff ff ff    	jl     801037d4 <write_log+0x12>
  }
}
80103877:	90                   	nop
80103878:	90                   	nop
80103879:	c9                   	leave
8010387a:	c3                   	ret

8010387b <commit>:

static void
commit()
{
8010387b:	55                   	push   %ebp
8010387c:	89 e5                	mov    %esp,%ebp
8010387e:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103881:	a1 28 a7 14 80       	mov    0x8014a728,%eax
80103886:	85 c0                	test   %eax,%eax
80103888:	7e 1e                	jle    801038a8 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010388a:	e8 33 ff ff ff       	call   801037c2 <write_log>
    write_head();    // Write header to disk -- the real commit
8010388f:	e8 39 fd ff ff       	call   801035cd <write_head>
    install_trans(); // Now install writes to home locations
80103894:	e8 07 fc ff ff       	call   801034a0 <install_trans>
    log.lh.n = 0;
80103899:	c7 05 28 a7 14 80 00 	movl   $0x0,0x8014a728
801038a0:	00 00 00 
    write_head();    // Erase the transaction from the log
801038a3:	e8 25 fd ff ff       	call   801035cd <write_head>
  }
}
801038a8:	90                   	nop
801038a9:	c9                   	leave
801038aa:	c3                   	ret

801038ab <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038ab:	55                   	push   %ebp
801038ac:	89 e5                	mov    %esp,%ebp
801038ae:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038b1:	a1 28 a7 14 80       	mov    0x8014a728,%eax
801038b6:	83 f8 1d             	cmp    $0x1d,%eax
801038b9:	7f 12                	jg     801038cd <log_write+0x22>
801038bb:	8b 15 28 a7 14 80    	mov    0x8014a728,%edx
801038c1:	a1 18 a7 14 80       	mov    0x8014a718,%eax
801038c6:	83 e8 01             	sub    $0x1,%eax
801038c9:	39 c2                	cmp    %eax,%edx
801038cb:	7c 0d                	jl     801038da <log_write+0x2f>
    panic("too big a transaction");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 22 89 10 80       	push   $0x80108922
801038d5:	e8 d9 cc ff ff       	call   801005b3 <panic>
  if (log.outstanding < 1)
801038da:	a1 1c a7 14 80       	mov    0x8014a71c,%eax
801038df:	85 c0                	test   %eax,%eax
801038e1:	7f 0d                	jg     801038f0 <log_write+0x45>
    panic("log_write outside of trans");
801038e3:	83 ec 0c             	sub    $0xc,%esp
801038e6:	68 38 89 10 80       	push   $0x80108938
801038eb:	e8 c3 cc ff ff       	call   801005b3 <panic>

  acquire(&log.lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	68 e0 a6 14 80       	push   $0x8014a6e0
801038f8:	e8 c2 17 00 00       	call   801050bf <acquire>
801038fd:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103907:	eb 1d                	jmp    80103926 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010390c:	83 c0 10             	add    $0x10,%eax
8010390f:	8b 04 85 ec a6 14 80 	mov    -0x7feb5914(,%eax,4),%eax
80103916:	89 c2                	mov    %eax,%edx
80103918:	8b 45 08             	mov    0x8(%ebp),%eax
8010391b:	8b 40 08             	mov    0x8(%eax),%eax
8010391e:	39 c2                	cmp    %eax,%edx
80103920:	74 10                	je     80103932 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
80103922:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103926:	a1 28 a7 14 80       	mov    0x8014a728,%eax
8010392b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010392e:	7c d9                	jl     80103909 <log_write+0x5e>
80103930:	eb 01                	jmp    80103933 <log_write+0x88>
      break;
80103932:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103933:	8b 45 08             	mov    0x8(%ebp),%eax
80103936:	8b 40 08             	mov    0x8(%eax),%eax
80103939:	89 c2                	mov    %eax,%edx
8010393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010393e:	83 c0 10             	add    $0x10,%eax
80103941:	89 14 85 ec a6 14 80 	mov    %edx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
80103948:	a1 28 a7 14 80       	mov    0x8014a728,%eax
8010394d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103950:	75 0d                	jne    8010395f <log_write+0xb4>
    log.lh.n++;
80103952:	a1 28 a7 14 80       	mov    0x8014a728,%eax
80103957:	83 c0 01             	add    $0x1,%eax
8010395a:	a3 28 a7 14 80       	mov    %eax,0x8014a728
  b->flags |= B_DIRTY; // prevent eviction
8010395f:	8b 45 08             	mov    0x8(%ebp),%eax
80103962:	8b 00                	mov    (%eax),%eax
80103964:	83 c8 04             	or     $0x4,%eax
80103967:	89 c2                	mov    %eax,%edx
80103969:	8b 45 08             	mov    0x8(%ebp),%eax
8010396c:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010396e:	83 ec 0c             	sub    $0xc,%esp
80103971:	68 e0 a6 14 80       	push   $0x8014a6e0
80103976:	e8 b2 17 00 00       	call   8010512d <release>
8010397b:	83 c4 10             	add    $0x10,%esp
}
8010397e:	90                   	nop
8010397f:	c9                   	leave
80103980:	c3                   	ret

80103981 <xchg>:
80103981:	55                   	push   %ebp
80103982:	89 e5                	mov    %esp,%ebp
80103984:	83 ec 10             	sub    $0x10,%esp
80103987:	8b 55 08             	mov    0x8(%ebp),%edx
8010398a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010398d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103990:	f0 87 02             	lock xchg %eax,(%edx)
80103993:	89 45 fc             	mov    %eax,-0x4(%ebp)
80103996:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103999:	c9                   	leave
8010399a:	c3                   	ret

8010399b <main>:
{
8010399b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010399f:	83 e4 f0             	and    $0xfffffff0,%esp
801039a2:	ff 71 fc             	push   -0x4(%ecx)
801039a5:	55                   	push   %ebp
801039a6:	89 e5                	mov    %esp,%ebp
801039a8:	51                   	push   %ecx
801039a9:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801039ac:	83 ec 08             	sub    $0x8,%esp
801039af:	68 00 00 40 80       	push   $0x80400000
801039b4:	68 e0 e4 14 80       	push   $0x8014e4e0
801039b9:	e8 a3 f1 ff ff       	call   80102b61 <kinit1>
801039be:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801039c1:	e8 1e 43 00 00       	call   80107ce4 <kvmalloc>
  mpinit();        // detect other processors
801039c6:	e8 bb 03 00 00       	call   80103d86 <mpinit>
  lapicinit();     // interrupt controller
801039cb:	e8 44 f6 ff ff       	call   80103014 <lapicinit>
  seginit();       // segment descriptors
801039d0:	e8 fa 3d 00 00       	call   801077cf <seginit>
  picinit();       // disable pic
801039d5:	e8 11 05 00 00       	call   80103eeb <picinit>
  ioapicinit();    // another interrupt controller
801039da:	e8 9d f0 ff ff       	call   80102a7c <ioapicinit>
  consoleinit();   // console hardware
801039df:	e8 98 d1 ff ff       	call   80100b7c <consoleinit>
  uartinit();      // serial port
801039e4:	e8 7f 31 00 00       	call   80106b68 <uartinit>
  pinit();         // process table
801039e9:	e8 36 09 00 00       	call   80104324 <pinit>
  tvinit();        // trap vectors
801039ee:	e8 2c 2d 00 00       	call   8010671f <tvinit>
  binit();         // buffer cache
801039f3:	e8 3c c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039f8:	e8 09 d6 ff ff       	call   80101006 <fileinit>
  ideinit();       // disk 
801039fd:	e8 51 ec ff ff       	call   80102653 <ideinit>
  startothers();   // start other processors
80103a02:	e8 80 00 00 00       	call   80103a87 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a07:	83 ec 08             	sub    $0x8,%esp
80103a0a:	68 00 00 00 8e       	push   $0x8e000000
80103a0f:	68 00 00 40 80       	push   $0x80400000
80103a14:	e8 a5 f1 ff ff       	call   80102bbe <kinit2>
80103a19:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103a1c:	e8 e1 0a 00 00       	call   80104502 <userinit>
  mpmain();        // finish this processor's setup
80103a21:	e8 1a 00 00 00       	call   80103a40 <mpmain>

80103a26 <mpenter>:
{
80103a26:	55                   	push   %ebp
80103a27:	89 e5                	mov    %esp,%ebp
80103a29:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103a2c:	e8 cb 42 00 00       	call   80107cfc <switchkvm>
  seginit();
80103a31:	e8 99 3d 00 00       	call   801077cf <seginit>
  lapicinit();
80103a36:	e8 d9 f5 ff ff       	call   80103014 <lapicinit>
  mpmain();
80103a3b:	e8 00 00 00 00       	call   80103a40 <mpmain>

80103a40 <mpmain>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103a47:	e8 f6 08 00 00       	call   80104342 <cpuid>
80103a4c:	89 c3                	mov    %eax,%ebx
80103a4e:	e8 ef 08 00 00       	call   80104342 <cpuid>
80103a53:	83 ec 04             	sub    $0x4,%esp
80103a56:	53                   	push   %ebx
80103a57:	50                   	push   %eax
80103a58:	68 53 89 10 80       	push   $0x80108953
80103a5d:	e8 9c c9 ff ff       	call   801003fe <cprintf>
80103a62:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a65:	e8 2b 2e 00 00       	call   80106895 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103a6a:	e8 ee 08 00 00       	call   8010435d <mycpu>
80103a6f:	05 a0 00 00 00       	add    $0xa0,%eax
80103a74:	83 ec 08             	sub    $0x8,%esp
80103a77:	6a 01                	push   $0x1
80103a79:	50                   	push   %eax
80103a7a:	e8 02 ff ff ff       	call   80103981 <xchg>
80103a7f:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a82:	e8 06 10 00 00       	call   80104a8d <scheduler>

80103a87 <startothers>:
{
80103a87:	55                   	push   %ebp
80103a88:	89 e5                	mov    %esp,%ebp
80103a8a:	83 ec 18             	sub    $0x18,%esp
  code = P2V(0x7000);
80103a8d:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a94:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a99:	83 ec 04             	sub    $0x4,%esp
80103a9c:	50                   	push   %eax
80103a9d:	68 ec b4 10 80       	push   $0x8010b4ec
80103aa2:	ff 75 f0             	push   -0x10(%ebp)
80103aa5:	e8 5a 19 00 00       	call   80105404 <memmove>
80103aaa:	83 c4 10             	add    $0x10,%esp
  for(c = cpus; c < cpus+ncpu; c++){
80103aad:	c7 45 f4 c0 a7 14 80 	movl   $0x8014a7c0,-0xc(%ebp)
80103ab4:	eb 79                	jmp    80103b2f <startothers+0xa8>
    if(c == mycpu())  // We've started already.
80103ab6:	e8 a2 08 00 00       	call   8010435d <mycpu>
80103abb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103abe:	74 67                	je     80103b27 <startothers+0xa0>
    stack = kalloc();
80103ac0:	e8 55 f2 ff ff       	call   80102d1a <kalloc>
80103ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103acb:	83 e8 04             	sub    $0x4,%eax
80103ace:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103ad1:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ad7:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103adc:	83 e8 08             	sub    $0x8,%eax
80103adf:	c7 00 26 3a 10 80    	movl   $0x80103a26,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103ae5:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80103aea:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af3:	83 e8 0c             	sub    $0xc,%eax
80103af6:	89 10                	mov    %edx,(%eax)
    lapicstartap(c->apicid, V2P(code));
80103af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103afb:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b04:	0f b6 00             	movzbl (%eax),%eax
80103b07:	0f b6 c0             	movzbl %al,%eax
80103b0a:	83 ec 08             	sub    $0x8,%esp
80103b0d:	52                   	push   %edx
80103b0e:	50                   	push   %eax
80103b0f:	e8 5f f6 ff ff       	call   80103173 <lapicstartap>
80103b14:	83 c4 10             	add    $0x10,%esp
    while(c->started == 0)
80103b17:	90                   	nop
80103b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1b:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103b21:	85 c0                	test   %eax,%eax
80103b23:	74 f3                	je     80103b18 <startothers+0x91>
80103b25:	eb 01                	jmp    80103b28 <startothers+0xa1>
      continue;
80103b27:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103b28:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103b2f:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
80103b34:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103b3a:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
80103b3f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b42:	0f 82 6e ff ff ff    	jb     80103ab6 <startothers+0x2f>
}
80103b48:	90                   	nop
80103b49:	90                   	nop
80103b4a:	c9                   	leave
80103b4b:	c3                   	ret

80103b4c <inb>:
// Multiprocessor support
// Search memory for MP description structures.
// http://developer.intel.com/design/pentium/datashts/24201606.pdf

#include "types.h"
80103b4c:	55                   	push   %ebp
80103b4d:	89 e5                	mov    %esp,%ebp
80103b4f:	83 ec 14             	sub    $0x14,%esp
80103b52:	8b 45 08             	mov    0x8(%ebp),%eax
80103b55:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
#include "defs.h"
#include "param.h"
#include "memlayout.h"
80103b59:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b5d:	89 c2                	mov    %eax,%edx
80103b5f:	ec                   	in     (%dx),%al
80103b60:	88 45 ff             	mov    %al,-0x1(%ebp)
#include "mp.h"
80103b63:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
#include "x86.h"
80103b67:	c9                   	leave
80103b68:	c3                   	ret

80103b69 <outb>:
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103b69:	55                   	push   %ebp
80103b6a:	89 e5                	mov    %esp,%ebp
80103b6c:	83 ec 08             	sub    $0x8,%esp
80103b6f:	8b 55 08             	mov    0x8(%ebp),%edx
80103b72:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b75:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b79:	88 45 f8             	mov    %al,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b7c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b80:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b84:	ee                   	out    %al,(%dx)
    sum += addr[i];
80103b85:	90                   	nop
80103b86:	c9                   	leave
80103b87:	c3                   	ret

80103b88 <sum>:
{
80103b88:	55                   	push   %ebp
80103b89:	89 e5                	mov    %esp,%ebp
80103b8b:	83 ec 10             	sub    $0x10,%esp
  sum = 0;
80103b8e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b9c:	eb 15                	jmp    80103bb3 <sum+0x2b>
    sum += addr[i];
80103b9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ba1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ba4:	01 d0                	add    %edx,%eax
80103ba6:	0f b6 00             	movzbl (%eax),%eax
80103ba9:	0f b6 c0             	movzbl %al,%eax
80103bac:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103baf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bb6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bb9:	7c e3                	jl     80103b9e <sum+0x16>
  return sum;
80103bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bbe:	c9                   	leave
80103bbf:	c3                   	ret

80103bc0 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc9:	05 00 00 00 80       	add    $0x80000000,%eax
80103bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd7:	01 d0                	add    %edx,%eax
80103bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103be2:	eb 36                	jmp    80103c1a <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103be4:	83 ec 04             	sub    $0x4,%esp
80103be7:	6a 04                	push   $0x4
80103be9:	68 68 89 10 80       	push   $0x80108968
80103bee:	ff 75 f4             	push   -0xc(%ebp)
80103bf1:	e8 b6 17 00 00       	call   801053ac <memcmp>
80103bf6:	83 c4 10             	add    $0x10,%esp
80103bf9:	85 c0                	test   %eax,%eax
80103bfb:	75 19                	jne    80103c16 <mpsearch1+0x56>
80103bfd:	83 ec 08             	sub    $0x8,%esp
80103c00:	6a 10                	push   $0x10
80103c02:	ff 75 f4             	push   -0xc(%ebp)
80103c05:	e8 7e ff ff ff       	call   80103b88 <sum>
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	84 c0                	test   %al,%al
80103c0f:	75 05                	jne    80103c16 <mpsearch1+0x56>
      return (struct mp*)p;
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	eb 11                	jmp    80103c27 <mpsearch1+0x67>
  for(p = addr; p < e; p += sizeof(struct mp))
80103c16:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c20:	72 c2                	jb     80103be4 <mpsearch1+0x24>
  return 0;
80103c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c27:	c9                   	leave
80103c28:	c3                   	ret

80103c29 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c29:	55                   	push   %ebp
80103c2a:	89 e5                	mov    %esp,%ebp
80103c2c:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c2f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c39:	83 c0 0f             	add    $0xf,%eax
80103c3c:	0f b6 00             	movzbl (%eax),%eax
80103c3f:	0f b6 c0             	movzbl %al,%eax
80103c42:	c1 e0 08             	shl    $0x8,%eax
80103c45:	89 c2                	mov    %eax,%edx
80103c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c4a:	83 c0 0e             	add    $0xe,%eax
80103c4d:	0f b6 00             	movzbl (%eax),%eax
80103c50:	0f b6 c0             	movzbl %al,%eax
80103c53:	09 d0                	or     %edx,%eax
80103c55:	c1 e0 04             	shl    $0x4,%eax
80103c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c5f:	74 21                	je     80103c82 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c61:	83 ec 08             	sub    $0x8,%esp
80103c64:	68 00 04 00 00       	push   $0x400
80103c69:	ff 75 f0             	push   -0x10(%ebp)
80103c6c:	e8 4f ff ff ff       	call   80103bc0 <mpsearch1>
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c7b:	74 51                	je     80103cce <mpsearch+0xa5>
      return mp;
80103c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c80:	eb 61                	jmp    80103ce3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c85:	83 c0 14             	add    $0x14,%eax
80103c88:	0f b6 00             	movzbl (%eax),%eax
80103c8b:	0f b6 c0             	movzbl %al,%eax
80103c8e:	c1 e0 08             	shl    $0x8,%eax
80103c91:	89 c2                	mov    %eax,%edx
80103c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c96:	83 c0 13             	add    $0x13,%eax
80103c99:	0f b6 00             	movzbl (%eax),%eax
80103c9c:	0f b6 c0             	movzbl %al,%eax
80103c9f:	09 d0                	or     %edx,%eax
80103ca1:	c1 e0 0a             	shl    $0xa,%eax
80103ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	2d 00 04 00 00       	sub    $0x400,%eax
80103caf:	83 ec 08             	sub    $0x8,%esp
80103cb2:	68 00 04 00 00       	push   $0x400
80103cb7:	50                   	push   %eax
80103cb8:	e8 03 ff ff ff       	call   80103bc0 <mpsearch1>
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cc7:	74 05                	je     80103cce <mpsearch+0xa5>
      return mp;
80103cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ccc:	eb 15                	jmp    80103ce3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cce:	83 ec 08             	sub    $0x8,%esp
80103cd1:	68 00 00 01 00       	push   $0x10000
80103cd6:	68 00 00 0f 00       	push   $0xf0000
80103cdb:	e8 e0 fe ff ff       	call   80103bc0 <mpsearch1>
80103ce0:	83 c4 10             	add    $0x10,%esp
}
80103ce3:	c9                   	leave
80103ce4:	c3                   	ret

80103ce5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ce5:	55                   	push   %ebp
80103ce6:	89 e5                	mov    %esp,%ebp
80103ce8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ceb:	e8 39 ff ff ff       	call   80103c29 <mpsearch>
80103cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cf7:	74 0a                	je     80103d03 <mpconfig+0x1e>
80103cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfc:	8b 40 04             	mov    0x4(%eax),%eax
80103cff:	85 c0                	test   %eax,%eax
80103d01:	75 07                	jne    80103d0a <mpconfig+0x25>
    return 0;
80103d03:	b8 00 00 00 00       	mov    $0x0,%eax
80103d08:	eb 7a                	jmp    80103d84 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0d:	8b 40 04             	mov    0x4(%eax),%eax
80103d10:	05 00 00 00 80       	add    $0x80000000,%eax
80103d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d18:	83 ec 04             	sub    $0x4,%esp
80103d1b:	6a 04                	push   $0x4
80103d1d:	68 6d 89 10 80       	push   $0x8010896d
80103d22:	ff 75 f0             	push   -0x10(%ebp)
80103d25:	e8 82 16 00 00       	call   801053ac <memcmp>
80103d2a:	83 c4 10             	add    $0x10,%esp
80103d2d:	85 c0                	test   %eax,%eax
80103d2f:	74 07                	je     80103d38 <mpconfig+0x53>
    return 0;
80103d31:	b8 00 00 00 00       	mov    $0x0,%eax
80103d36:	eb 4c                	jmp    80103d84 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d3b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d3f:	3c 01                	cmp    $0x1,%al
80103d41:	74 12                	je     80103d55 <mpconfig+0x70>
80103d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d46:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d4a:	3c 04                	cmp    $0x4,%al
80103d4c:	74 07                	je     80103d55 <mpconfig+0x70>
    return 0;
80103d4e:	b8 00 00 00 00       	mov    $0x0,%eax
80103d53:	eb 2f                	jmp    80103d84 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d58:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d5c:	0f b7 c0             	movzwl %ax,%eax
80103d5f:	83 ec 08             	sub    $0x8,%esp
80103d62:	50                   	push   %eax
80103d63:	ff 75 f0             	push   -0x10(%ebp)
80103d66:	e8 1d fe ff ff       	call   80103b88 <sum>
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	84 c0                	test   %al,%al
80103d70:	74 07                	je     80103d79 <mpconfig+0x94>
    return 0;
80103d72:	b8 00 00 00 00       	mov    $0x0,%eax
80103d77:	eb 0b                	jmp    80103d84 <mpconfig+0x9f>
  *pmp = mp;
80103d79:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d7f:	89 10                	mov    %edx,(%eax)
  return conf;
80103d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d84:	c9                   	leave
80103d85:	c3                   	ret

80103d86 <mpinit>:

void
mpinit(void)
{
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
80103d89:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103d8c:	83 ec 0c             	sub    $0xc,%esp
80103d8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103d92:	50                   	push   %eax
80103d93:	e8 4d ff ff ff       	call   80103ce5 <mpconfig>
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103da2:	75 0d                	jne    80103db1 <mpinit+0x2b>
    panic("Expect to run on an SMP");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 72 89 10 80       	push   $0x80108972
80103dac:	e8 02 c8 ff ff       	call   801005b3 <panic>
  ismp = 1;
80103db1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dbb:	8b 40 24             	mov    0x24(%eax),%eax
80103dbe:	a3 c4 a6 14 80       	mov    %eax,0x8014a6c4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dc6:	83 c0 2c             	add    $0x2c,%eax
80103dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dcf:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103dd3:	0f b7 d0             	movzwl %ax,%edx
80103dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dd9:	01 d0                	add    %edx,%eax
80103ddb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103dde:	e9 8c 00 00 00       	jmp    80103e6f <mpinit+0xe9>
    switch(*p){
80103de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de6:	0f b6 00             	movzbl (%eax),%eax
80103de9:	0f b6 c0             	movzbl %al,%eax
80103dec:	83 f8 04             	cmp    $0x4,%eax
80103def:	7f 76                	jg     80103e67 <mpinit+0xe1>
80103df1:	83 f8 03             	cmp    $0x3,%eax
80103df4:	7d 6b                	jge    80103e61 <mpinit+0xdb>
80103df6:	83 f8 02             	cmp    $0x2,%eax
80103df9:	74 4e                	je     80103e49 <mpinit+0xc3>
80103dfb:	83 f8 02             	cmp    $0x2,%eax
80103dfe:	7f 67                	jg     80103e67 <mpinit+0xe1>
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 07                	je     80103e0b <mpinit+0x85>
80103e04:	83 f8 01             	cmp    $0x1,%eax
80103e07:	74 58                	je     80103e61 <mpinit+0xdb>
80103e09:	eb 5c                	jmp    80103e67 <mpinit+0xe1>
    case MPPROC:
      proc = (struct mpproc*)p;
80103e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103e11:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
80103e16:	83 f8 07             	cmp    $0x7,%eax
80103e19:	7f 28                	jg     80103e43 <mpinit+0xbd>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103e1b:	8b 15 40 ad 14 80    	mov    0x8014ad40,%edx
80103e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e24:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e28:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103e2e:	81 c2 c0 a7 14 80    	add    $0x8014a7c0,%edx
80103e34:	88 02                	mov    %al,(%edx)
        ncpu++;
80103e36:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
80103e3b:	83 c0 01             	add    $0x1,%eax
80103e3e:	a3 40 ad 14 80       	mov    %eax,0x8014ad40
      }
      p += sizeof(struct mpproc);
80103e43:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e47:	eb 26                	jmp    80103e6f <mpinit+0xe9>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e52:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e56:	a2 44 ad 14 80       	mov    %al,0x8014ad44
      p += sizeof(struct mpioapic);
80103e5b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e5f:	eb 0e                	jmp    80103e6f <mpinit+0xe9>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e61:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e65:	eb 08                	jmp    80103e6f <mpinit+0xe9>
    default:
      ismp = 0;
80103e67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103e6e:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e72:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103e75:	0f 82 68 ff ff ff    	jb     80103de3 <mpinit+0x5d>
    }
  }
  if(!ismp)
80103e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e7f:	75 0d                	jne    80103e8e <mpinit+0x108>
    panic("Didn't find a suitable machine");
80103e81:	83 ec 0c             	sub    $0xc,%esp
80103e84:	68 8c 89 10 80       	push   $0x8010898c
80103e89:	e8 25 c7 ff ff       	call   801005b3 <panic>

  if(mp->imcrp){
80103e8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e91:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e95:	84 c0                	test   %al,%al
80103e97:	74 30                	je     80103ec9 <mpinit+0x143>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e99:	83 ec 08             	sub    $0x8,%esp
80103e9c:	6a 70                	push   $0x70
80103e9e:	6a 22                	push   $0x22
80103ea0:	e8 c4 fc ff ff       	call   80103b69 <outb>
80103ea5:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ea8:	83 ec 0c             	sub    $0xc,%esp
80103eab:	6a 23                	push   $0x23
80103ead:	e8 9a fc ff ff       	call   80103b4c <inb>
80103eb2:	83 c4 10             	add    $0x10,%esp
80103eb5:	83 c8 01             	or     $0x1,%eax
80103eb8:	0f b6 c0             	movzbl %al,%eax
80103ebb:	83 ec 08             	sub    $0x8,%esp
80103ebe:	50                   	push   %eax
80103ebf:	6a 23                	push   $0x23
80103ec1:	e8 a3 fc ff ff       	call   80103b69 <outb>
80103ec6:	83 c4 10             	add    $0x10,%esp
  }
}
80103ec9:	90                   	nop
80103eca:	c9                   	leave
80103ecb:	c3                   	ret

80103ecc <outb>:
//PAGEBREAK!
// Blank page.
80103ecc:	55                   	push   %ebp
80103ecd:	89 e5                	mov    %esp,%ebp
80103ecf:	83 ec 08             	sub    $0x8,%esp
80103ed2:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ed8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103edc:	88 45 f8             	mov    %al,-0x8(%ebp)
80103edf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ee3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ee7:	ee                   	out    %al,(%dx)
80103ee8:	90                   	nop
80103ee9:	c9                   	leave
80103eea:	c3                   	ret

80103eeb <picinit>:
{
80103eeb:	55                   	push   %ebp
80103eec:	89 e5                	mov    %esp,%ebp
  outb(IO_PIC1+1, 0xFF);
80103eee:	68 ff 00 00 00       	push   $0xff
80103ef3:	6a 21                	push   $0x21
80103ef5:	e8 d2 ff ff ff       	call   80103ecc <outb>
80103efa:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103efd:	68 ff 00 00 00       	push   $0xff
80103f02:	68 a1 00 00 00       	push   $0xa1
80103f07:	e8 c0 ff ff ff       	call   80103ecc <outb>
80103f0c:	83 c4 08             	add    $0x8,%esp
}
80103f0f:	90                   	nop
80103f10:	c9                   	leave
80103f11:	c3                   	ret

80103f12 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f12:	55                   	push   %ebp
80103f13:	89 e5                	mov    %esp,%ebp
80103f15:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f28:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f2b:	8b 10                	mov    (%eax),%edx
80103f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f30:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f32:	e8 ed d0 ff ff       	call   80101024 <filealloc>
80103f37:	8b 55 08             	mov    0x8(%ebp),%edx
80103f3a:	89 02                	mov    %eax,(%edx)
80103f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3f:	8b 00                	mov    (%eax),%eax
80103f41:	85 c0                	test   %eax,%eax
80103f43:	0f 84 c8 00 00 00    	je     80104011 <pipealloc+0xff>
80103f49:	e8 d6 d0 ff ff       	call   80101024 <filealloc>
80103f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f51:	89 02                	mov    %eax,(%edx)
80103f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f56:	8b 00                	mov    (%eax),%eax
80103f58:	85 c0                	test   %eax,%eax
80103f5a:	0f 84 b1 00 00 00    	je     80104011 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f60:	e8 b5 ed ff ff       	call   80102d1a <kalloc>
80103f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f6c:	0f 84 a2 00 00 00    	je     80104014 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
80103f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f75:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f7c:	00 00 00 
  p->writeopen = 1;
80103f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f82:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103f89:	00 00 00 
  p->nwrite = 0;
80103f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103f96:	00 00 00 
  p->nread = 0;
80103f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f9c:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fa3:	00 00 00 
  initlock(&p->lock, "pipe");
80103fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa9:	83 ec 08             	sub    $0x8,%esp
80103fac:	68 ab 89 10 80       	push   $0x801089ab
80103fb1:	50                   	push   %eax
80103fb2:	e8 e6 10 00 00       	call   8010509d <initlock>
80103fb7:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103fba:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbd:	8b 00                	mov    (%eax),%eax
80103fbf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc8:	8b 00                	mov    (%eax),%eax
80103fca:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103fce:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd1:	8b 00                	mov    (%eax),%eax
80103fd3:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fda:	8b 00                	mov    (%eax),%eax
80103fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fdf:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe5:	8b 00                	mov    (%eax),%eax
80103fe7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103fed:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff0:	8b 00                	mov    (%eax),%eax
80103ff2:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff9:	8b 00                	mov    (%eax),%eax
80103ffb:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104002:	8b 00                	mov    (%eax),%eax
80104004:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104007:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010400a:	b8 00 00 00 00       	mov    $0x0,%eax
8010400f:	eb 51                	jmp    80104062 <pipealloc+0x150>
    goto bad;
80104011:	90                   	nop
80104012:	eb 01                	jmp    80104015 <pipealloc+0x103>
    goto bad;
80104014:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80104015:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104019:	74 0e                	je     80104029 <pipealloc+0x117>
    kfree((char*)p);
8010401b:	83 ec 0c             	sub    $0xc,%esp
8010401e:	ff 75 f4             	push   -0xc(%ebp)
80104021:	e8 fa eb ff ff       	call   80102c20 <kfree>
80104026:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104029:	8b 45 08             	mov    0x8(%ebp),%eax
8010402c:	8b 00                	mov    (%eax),%eax
8010402e:	85 c0                	test   %eax,%eax
80104030:	74 11                	je     80104043 <pipealloc+0x131>
    fileclose(*f0);
80104032:	8b 45 08             	mov    0x8(%ebp),%eax
80104035:	8b 00                	mov    (%eax),%eax
80104037:	83 ec 0c             	sub    $0xc,%esp
8010403a:	50                   	push   %eax
8010403b:	e8 a2 d0 ff ff       	call   801010e2 <fileclose>
80104040:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104043:	8b 45 0c             	mov    0xc(%ebp),%eax
80104046:	8b 00                	mov    (%eax),%eax
80104048:	85 c0                	test   %eax,%eax
8010404a:	74 11                	je     8010405d <pipealloc+0x14b>
    fileclose(*f1);
8010404c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404f:	8b 00                	mov    (%eax),%eax
80104051:	83 ec 0c             	sub    $0xc,%esp
80104054:	50                   	push   %eax
80104055:	e8 88 d0 ff ff       	call   801010e2 <fileclose>
8010405a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010405d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104062:	c9                   	leave
80104063:	c3                   	ret

80104064 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010406a:	8b 45 08             	mov    0x8(%ebp),%eax
8010406d:	83 ec 0c             	sub    $0xc,%esp
80104070:	50                   	push   %eax
80104071:	e8 49 10 00 00       	call   801050bf <acquire>
80104076:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010407d:	74 23                	je     801040a2 <pipeclose+0x3e>
    p->writeopen = 0;
8010407f:	8b 45 08             	mov    0x8(%ebp),%eax
80104082:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104089:	00 00 00 
    wakeup(&p->nread);
8010408c:	8b 45 08             	mov    0x8(%ebp),%eax
8010408f:	05 34 02 00 00       	add    $0x234,%eax
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	50                   	push   %eax
80104098:	e8 c8 0c 00 00       	call   80104d65 <wakeup>
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	eb 21                	jmp    801040c3 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801040a2:	8b 45 08             	mov    0x8(%ebp),%eax
801040a5:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040ac:	00 00 00 
    wakeup(&p->nwrite);
801040af:	8b 45 08             	mov    0x8(%ebp),%eax
801040b2:	05 38 02 00 00       	add    $0x238,%eax
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	50                   	push   %eax
801040bb:	e8 a5 0c 00 00       	call   80104d65 <wakeup>
801040c0:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040c3:	8b 45 08             	mov    0x8(%ebp),%eax
801040c6:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040cc:	85 c0                	test   %eax,%eax
801040ce:	75 2c                	jne    801040fc <pipeclose+0x98>
801040d0:	8b 45 08             	mov    0x8(%ebp),%eax
801040d3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040d9:	85 c0                	test   %eax,%eax
801040db:	75 1f                	jne    801040fc <pipeclose+0x98>
    release(&p->lock);
801040dd:	8b 45 08             	mov    0x8(%ebp),%eax
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	50                   	push   %eax
801040e4:	e8 44 10 00 00       	call   8010512d <release>
801040e9:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801040ec:	83 ec 0c             	sub    $0xc,%esp
801040ef:	ff 75 08             	push   0x8(%ebp)
801040f2:	e8 29 eb ff ff       	call   80102c20 <kfree>
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	eb 10                	jmp    8010410c <pipeclose+0xa8>
  } else
    release(&p->lock);
801040fc:	8b 45 08             	mov    0x8(%ebp),%eax
801040ff:	83 ec 0c             	sub    $0xc,%esp
80104102:	50                   	push   %eax
80104103:	e8 25 10 00 00       	call   8010512d <release>
80104108:	83 c4 10             	add    $0x10,%esp
}
8010410b:	90                   	nop
8010410c:	90                   	nop
8010410d:	c9                   	leave
8010410e:	c3                   	ret

8010410f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010410f:	55                   	push   %ebp
80104110:	89 e5                	mov    %esp,%ebp
80104112:	53                   	push   %ebx
80104113:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104116:	8b 45 08             	mov    0x8(%ebp),%eax
80104119:	83 ec 0c             	sub    $0xc,%esp
8010411c:	50                   	push   %eax
8010411d:	e8 9d 0f 00 00       	call   801050bf <acquire>
80104122:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104125:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010412c:	e9 ad 00 00 00       	jmp    801041de <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80104131:	8b 45 08             	mov    0x8(%ebp),%eax
80104134:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010413a:	85 c0                	test   %eax,%eax
8010413c:	74 0c                	je     8010414a <pipewrite+0x3b>
8010413e:	e8 92 02 00 00       	call   801043d5 <myproc>
80104143:	8b 40 24             	mov    0x24(%eax),%eax
80104146:	85 c0                	test   %eax,%eax
80104148:	74 19                	je     80104163 <pipewrite+0x54>
        release(&p->lock);
8010414a:	8b 45 08             	mov    0x8(%ebp),%eax
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	50                   	push   %eax
80104151:	e8 d7 0f 00 00       	call   8010512d <release>
80104156:	83 c4 10             	add    $0x10,%esp
        return -1;
80104159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010415e:	e9 a9 00 00 00       	jmp    8010420c <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80104163:	8b 45 08             	mov    0x8(%ebp),%eax
80104166:	05 34 02 00 00       	add    $0x234,%eax
8010416b:	83 ec 0c             	sub    $0xc,%esp
8010416e:	50                   	push   %eax
8010416f:	e8 f1 0b 00 00       	call   80104d65 <wakeup>
80104174:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104177:	8b 45 08             	mov    0x8(%ebp),%eax
8010417a:	8b 55 08             	mov    0x8(%ebp),%edx
8010417d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104183:	83 ec 08             	sub    $0x8,%esp
80104186:	50                   	push   %eax
80104187:	52                   	push   %edx
80104188:	e8 f1 0a 00 00       	call   80104c7e <sleep>
8010418d:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104190:	8b 45 08             	mov    0x8(%ebp),%eax
80104193:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104199:	8b 45 08             	mov    0x8(%ebp),%eax
8010419c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041a2:	05 00 02 00 00       	add    $0x200,%eax
801041a7:	39 c2                	cmp    %eax,%edx
801041a9:	74 86                	je     80104131 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801041b4:	8b 45 08             	mov    0x8(%ebp),%eax
801041b7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041bd:	8d 48 01             	lea    0x1(%eax),%ecx
801041c0:	8b 55 08             	mov    0x8(%ebp),%edx
801041c3:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801041ce:	89 c1                	mov    %eax,%ecx
801041d0:	0f b6 13             	movzbl (%ebx),%edx
801041d3:	8b 45 08             	mov    0x8(%ebp),%eax
801041d6:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801041da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e1:	3b 45 10             	cmp    0x10(%ebp),%eax
801041e4:	7c aa                	jl     80104190 <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041e6:	8b 45 08             	mov    0x8(%ebp),%eax
801041e9:	05 34 02 00 00       	add    $0x234,%eax
801041ee:	83 ec 0c             	sub    $0xc,%esp
801041f1:	50                   	push   %eax
801041f2:	e8 6e 0b 00 00       	call   80104d65 <wakeup>
801041f7:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801041fa:	8b 45 08             	mov    0x8(%ebp),%eax
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	50                   	push   %eax
80104201:	e8 27 0f 00 00       	call   8010512d <release>
80104206:	83 c4 10             	add    $0x10,%esp
  return n;
80104209:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010420c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010420f:	c9                   	leave
80104210:	c3                   	ret

80104211 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104211:	55                   	push   %ebp
80104212:	89 e5                	mov    %esp,%ebp
80104214:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104217:	8b 45 08             	mov    0x8(%ebp),%eax
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	50                   	push   %eax
8010421e:	e8 9c 0e 00 00       	call   801050bf <acquire>
80104223:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104226:	eb 3e                	jmp    80104266 <piperead+0x55>
    if(myproc()->killed){
80104228:	e8 a8 01 00 00       	call   801043d5 <myproc>
8010422d:	8b 40 24             	mov    0x24(%eax),%eax
80104230:	85 c0                	test   %eax,%eax
80104232:	74 19                	je     8010424d <piperead+0x3c>
      release(&p->lock);
80104234:	8b 45 08             	mov    0x8(%ebp),%eax
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	50                   	push   %eax
8010423b:	e8 ed 0e 00 00       	call   8010512d <release>
80104240:	83 c4 10             	add    $0x10,%esp
      return -1;
80104243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104248:	e9 be 00 00 00       	jmp    8010430b <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010424d:	8b 45 08             	mov    0x8(%ebp),%eax
80104250:	8b 55 08             	mov    0x8(%ebp),%edx
80104253:	81 c2 34 02 00 00    	add    $0x234,%edx
80104259:	83 ec 08             	sub    $0x8,%esp
8010425c:	50                   	push   %eax
8010425d:	52                   	push   %edx
8010425e:	e8 1b 0a 00 00       	call   80104c7e <sleep>
80104263:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104266:	8b 45 08             	mov    0x8(%ebp),%eax
80104269:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010426f:	8b 45 08             	mov    0x8(%ebp),%eax
80104272:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104278:	39 c2                	cmp    %eax,%edx
8010427a:	75 0d                	jne    80104289 <piperead+0x78>
8010427c:	8b 45 08             	mov    0x8(%ebp),%eax
8010427f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104285:	85 c0                	test   %eax,%eax
80104287:	75 9f                	jne    80104228 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104290:	eb 48                	jmp    801042da <piperead+0xc9>
    if(p->nread == p->nwrite)
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010429b:	8b 45 08             	mov    0x8(%ebp),%eax
8010429e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042a4:	39 c2                	cmp    %eax,%edx
801042a6:	74 3c                	je     801042e4 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042a8:	8b 45 08             	mov    0x8(%ebp),%eax
801042ab:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042b1:	8d 48 01             	lea    0x1(%eax),%ecx
801042b4:	8b 55 08             	mov    0x8(%ebp),%edx
801042b7:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042bd:	25 ff 01 00 00       	and    $0x1ff,%eax
801042c2:	89 c1                	mov    %eax,%ecx
801042c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ca:	01 c2                	add    %eax,%edx
801042cc:	8b 45 08             	mov    0x8(%ebp),%eax
801042cf:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801042d4:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042dd:	3b 45 10             	cmp    0x10(%ebp),%eax
801042e0:	7c b0                	jl     80104292 <piperead+0x81>
801042e2:	eb 01                	jmp    801042e5 <piperead+0xd4>
      break;
801042e4:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042e5:	8b 45 08             	mov    0x8(%ebp),%eax
801042e8:	05 38 02 00 00       	add    $0x238,%eax
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	50                   	push   %eax
801042f1:	e8 6f 0a 00 00       	call   80104d65 <wakeup>
801042f6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042f9:	8b 45 08             	mov    0x8(%ebp),%eax
801042fc:	83 ec 0c             	sub    $0xc,%esp
801042ff:	50                   	push   %eax
80104300:	e8 28 0e 00 00       	call   8010512d <release>
80104305:	83 c4 10             	add    $0x10,%esp
  return i;
80104308:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010430b:	c9                   	leave
8010430c:	c3                   	ret

8010430d <readeflags>:

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010430d:	55                   	push   %ebp
8010430e:	89 e5                	mov    %esp,%ebp
80104310:	83 ec 10             	sub    $0x10,%esp
    return 0;
  }
80104313:	9c                   	pushf
80104314:	58                   	pop    %eax
80104315:	89 45 fc             	mov    %eax,-0x4(%ebp)
  sp = p->kstack + KSTACKSIZE;
80104318:	8b 45 fc             	mov    -0x4(%ebp),%eax

8010431b:	c9                   	leave
8010431c:	c3                   	ret

8010431d <sti>:
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010431d:	55                   	push   %ebp
8010431e:	89 e5                	mov    %esp,%ebp

80104320:	fb                   	sti
//PAGEBREAK: 32
80104321:	90                   	nop
80104322:	5d                   	pop    %ebp
80104323:	c3                   	ret

80104324 <pinit>:
{
80104324:	55                   	push   %ebp
80104325:	89 e5                	mov    %esp,%ebp
80104327:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010432a:	83 ec 08             	sub    $0x8,%esp
8010432d:	68 b0 89 10 80       	push   $0x801089b0
80104332:	68 60 ad 14 80       	push   $0x8014ad60
80104337:	e8 61 0d 00 00       	call   8010509d <initlock>
8010433c:	83 c4 10             	add    $0x10,%esp
}
8010433f:	90                   	nop
80104340:	c9                   	leave
80104341:	c3                   	ret

80104342 <cpuid>:
cpuid() {
80104342:	55                   	push   %ebp
80104343:	89 e5                	mov    %esp,%ebp
80104345:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104348:	e8 10 00 00 00       	call   8010435d <mycpu>
8010434d:	2d c0 a7 14 80       	sub    $0x8014a7c0,%eax
80104352:	c1 f8 04             	sar    $0x4,%eax
80104355:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010435b:	c9                   	leave
8010435c:	c3                   	ret

8010435d <mycpu>:
{
8010435d:	55                   	push   %ebp
8010435e:	89 e5                	mov    %esp,%ebp
80104360:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104363:	e8 a5 ff ff ff       	call   8010430d <readeflags>
80104368:	25 00 02 00 00       	and    $0x200,%eax
8010436d:	85 c0                	test   %eax,%eax
8010436f:	74 0d                	je     8010437e <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80104371:	83 ec 0c             	sub    $0xc,%esp
80104374:	68 b8 89 10 80       	push   $0x801089b8
80104379:	e8 35 c2 ff ff       	call   801005b3 <panic>
  apicid = lapicid();
8010437e:	e8 ad ed ff ff       	call   80103130 <lapicid>
80104383:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < ncpu; ++i) {
80104386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010438d:	eb 2d                	jmp    801043bc <mycpu+0x5f>
    if (cpus[i].apicid == apicid)
8010438f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104392:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104398:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
8010439d:	0f b6 00             	movzbl (%eax),%eax
801043a0:	0f b6 c0             	movzbl %al,%eax
801043a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801043a6:	75 10                	jne    801043b8 <mycpu+0x5b>
      return &cpus[i];
801043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801043b1:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
801043b6:	eb 1b                	jmp    801043d3 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
801043b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043bc:	a1 40 ad 14 80       	mov    0x8014ad40,%eax
801043c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801043c4:	7c c9                	jl     8010438f <mycpu+0x32>
  panic("unknown apicid\n");
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 de 89 10 80       	push   $0x801089de
801043ce:	e8 e0 c1 ff ff       	call   801005b3 <panic>
}
801043d3:	c9                   	leave
801043d4:	c3                   	ret

801043d5 <myproc>:
myproc(void) {
801043d5:	55                   	push   %ebp
801043d6:	89 e5                	mov    %esp,%ebp
801043d8:	83 ec 18             	sub    $0x18,%esp
  pushcli();
801043db:	e8 5a 0e 00 00       	call   8010523a <pushcli>
  c = mycpu();
801043e0:	e8 78 ff ff ff       	call   8010435d <mycpu>
801043e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043eb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801043f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801043f4:	e8 8e 0e 00 00       	call   80105287 <popcli>
  return p;
801043f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801043fc:	c9                   	leave
801043fd:	c3                   	ret

801043fe <allocproc>:
{
801043fe:	55                   	push   %ebp
801043ff:	89 e5                	mov    %esp,%ebp
80104401:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 60 ad 14 80       	push   $0x8014ad60
8010440c:	e8 ae 0c 00 00       	call   801050bf <acquire>
80104411:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104414:	c7 45 f4 94 ad 14 80 	movl   $0x8014ad94,-0xc(%ebp)
8010441b:	eb 0e                	jmp    8010442b <allocproc+0x2d>
    if(p->state == UNUSED)
8010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104420:	8b 40 0c             	mov    0xc(%eax),%eax
80104423:	85 c0                	test   %eax,%eax
80104425:	74 27                	je     8010444e <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104427:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010442b:	81 7d f4 94 cc 14 80 	cmpl   $0x8014cc94,-0xc(%ebp)
80104432:	72 e9                	jb     8010441d <allocproc+0x1f>
  release(&ptable.lock);
80104434:	83 ec 0c             	sub    $0xc,%esp
80104437:	68 60 ad 14 80       	push   $0x8014ad60
8010443c:	e8 ec 0c 00 00       	call   8010512d <release>
80104441:	83 c4 10             	add    $0x10,%esp
  return 0;
80104444:	b8 00 00 00 00       	mov    $0x0,%eax
80104449:	e9 b2 00 00 00       	jmp    80104500 <allocproc+0x102>
      goto found;
8010444e:	90                   	nop
  p->state = EMBRYO;
8010444f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104452:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104459:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010445e:	8d 50 01             	lea    0x1(%eax),%edx
80104461:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
80104467:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446a:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
8010446d:	83 ec 0c             	sub    $0xc,%esp
80104470:	68 60 ad 14 80       	push   $0x8014ad60
80104475:	e8 b3 0c 00 00       	call   8010512d <release>
8010447a:	83 c4 10             	add    $0x10,%esp
  if((p->kstack = kalloc()) == 0){
8010447d:	e8 98 e8 ff ff       	call   80102d1a <kalloc>
80104482:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104485:	89 42 08             	mov    %eax,0x8(%edx)
80104488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448b:	8b 40 08             	mov    0x8(%eax),%eax
8010448e:	85 c0                	test   %eax,%eax
80104490:	75 11                	jne    801044a3 <allocproc+0xa5>
    p->state = UNUSED;
80104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104495:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010449c:	b8 00 00 00 00       	mov    $0x0,%eax
801044a1:	eb 5d                	jmp    80104500 <allocproc+0x102>
  sp = p->kstack + KSTACKSIZE;
801044a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a6:	8b 40 08             	mov    0x8(%eax),%eax
801044a9:	05 00 10 00 00       	add    $0x1000,%eax
801044ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= sizeof *p->tf;
801044b1:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044bb:	89 50 18             	mov    %edx,0x18(%eax)
  sp -= 4;
801044be:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044c2:	ba d9 66 10 80       	mov    $0x801066d9,%edx
801044c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044ca:	89 10                	mov    %edx,(%eax)
  sp -= sizeof *p->context;
801044cc:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044d6:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dc:	8b 40 1c             	mov    0x1c(%eax),%eax
801044df:	83 ec 04             	sub    $0x4,%esp
801044e2:	6a 14                	push   $0x14
801044e4:	6a 00                	push   $0x0
801044e6:	50                   	push   %eax
801044e7:	e8 59 0e 00 00       	call   80105345 <memset>
801044ec:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f2:	8b 40 1c             	mov    0x1c(%eax),%eax
801044f5:	ba 38 4c 10 80       	mov    $0x80104c38,%edx
801044fa:	89 50 10             	mov    %edx,0x10(%eax)
  return p;
801044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104500:	c9                   	leave
80104501:	c3                   	ret

80104502 <userinit>:
// Set up first user process.
void
userinit(void)
{
80104502:	55                   	push   %ebp
80104503:	89 e5                	mov    %esp,%ebp
80104505:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104508:	e8 f1 fe ff ff       	call   801043fe <allocproc>
8010450d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104513:	a3 94 cc 14 80       	mov    %eax,0x8014cc94
  if((p->pgdir = setupkvm()) == 0)
80104518:	e8 2e 37 00 00       	call   80107c4b <setupkvm>
8010451d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104520:	89 42 04             	mov    %eax,0x4(%edx)
80104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104526:	8b 40 04             	mov    0x4(%eax),%eax
80104529:	85 c0                	test   %eax,%eax
8010452b:	75 0d                	jne    8010453a <userinit+0x38>
    panic("userinit: out of memory?");
8010452d:	83 ec 0c             	sub    $0xc,%esp
80104530:	68 ee 89 10 80       	push   $0x801089ee
80104535:	e8 79 c0 ff ff       	call   801005b3 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010453a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104542:	8b 40 04             	mov    0x4(%eax),%eax
80104545:	83 ec 04             	sub    $0x4,%esp
80104548:	52                   	push   %edx
80104549:	68 c0 b4 10 80       	push   $0x8010b4c0
8010454e:	50                   	push   %eax
8010454f:	e8 60 39 00 00       	call   80107eb4 <inituvm>
80104554:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455a:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104563:	8b 40 18             	mov    0x18(%eax),%eax
80104566:	83 ec 04             	sub    $0x4,%esp
80104569:	6a 4c                	push   $0x4c
8010456b:	6a 00                	push   $0x0
8010456d:	50                   	push   %eax
8010456e:	e8 d2 0d 00 00       	call   80105345 <memset>
80104573:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104579:	8b 40 18             	mov    0x18(%eax),%eax
8010457c:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 18             	mov    0x18(%eax),%eax
80104588:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010458e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104591:	8b 50 18             	mov    0x18(%eax),%edx
80104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104597:	8b 40 18             	mov    0x18(%eax),%eax
8010459a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010459e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	8b 50 18             	mov    0x18(%eax),%edx
801045a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ab:	8b 40 18             	mov    0x18(%eax),%eax
801045ae:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045b2:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	8b 40 18             	mov    0x18(%eax),%eax
801045bc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c6:	8b 40 18             	mov    0x18(%eax),%eax
801045c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d3:	8b 40 18             	mov    0x18(%eax),%eax
801045d6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e0:	83 c0 6c             	add    $0x6c,%eax
801045e3:	83 ec 04             	sub    $0x4,%esp
801045e6:	6a 10                	push   $0x10
801045e8:	68 07 8a 10 80       	push   $0x80108a07
801045ed:	50                   	push   %eax
801045ee:	e8 55 0f 00 00       	call   80105548 <safestrcpy>
801045f3:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045f6:	83 ec 0c             	sub    $0xc,%esp
801045f9:	68 10 8a 10 80       	push   $0x80108a10
801045fe:	e8 4c df ff ff       	call   8010254f <namei>
80104603:	83 c4 10             	add    $0x10,%esp
80104606:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104609:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 60 ad 14 80       	push   $0x8014ad60
80104614:	e8 a6 0a 00 00       	call   801050bf <acquire>
80104619:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	68 60 ad 14 80       	push   $0x8014ad60
8010462e:	e8 fa 0a 00 00       	call   8010512d <release>
80104633:	83 c4 10             	add    $0x10,%esp
}
80104636:	90                   	nop
80104637:	c9                   	leave
80104638:	c3                   	ret

80104639 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104639:	55                   	push   %ebp
8010463a:	89 e5                	mov    %esp,%ebp
8010463c:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
8010463f:	e8 91 fd ff ff       	call   801043d5 <myproc>
80104644:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010464a:	8b 00                	mov    (%eax),%eax
8010464c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010464f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104653:	7e 2e                	jle    80104683 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104655:	8b 55 08             	mov    0x8(%ebp),%edx
80104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465b:	01 c2                	add    %eax,%edx
8010465d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104660:	8b 40 04             	mov    0x4(%eax),%eax
80104663:	83 ec 04             	sub    $0x4,%esp
80104666:	52                   	push   %edx
80104667:	ff 75 f4             	push   -0xc(%ebp)
8010466a:	50                   	push   %eax
8010466b:	e8 81 39 00 00       	call   80107ff1 <allocuvm>
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010467a:	75 3b                	jne    801046b7 <growproc+0x7e>
      return -1;
8010467c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104681:	eb 4f                	jmp    801046d2 <growproc+0x99>
  } else if(n < 0){
80104683:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104687:	79 2e                	jns    801046b7 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104689:	8b 55 08             	mov    0x8(%ebp),%edx
8010468c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468f:	01 c2                	add    %eax,%edx
80104691:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104694:	8b 40 04             	mov    0x4(%eax),%eax
80104697:	83 ec 04             	sub    $0x4,%esp
8010469a:	52                   	push   %edx
8010469b:	ff 75 f4             	push   -0xc(%ebp)
8010469e:	50                   	push   %eax
8010469f:	e8 52 3a 00 00       	call   801080f6 <deallocuvm>
801046a4:	83 c4 10             	add    $0x10,%esp
801046a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046ae:	75 07                	jne    801046b7 <growproc+0x7e>
      return -1;
801046b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b5:	eb 1b                	jmp    801046d2 <growproc+0x99>
  }
  curproc->sz = sz;
801046b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046bd:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801046bf:	83 ec 0c             	sub    $0xc,%esp
801046c2:	ff 75 f0             	push   -0x10(%ebp)
801046c5:	e8 4b 36 00 00       	call   80107d15 <switchuvm>
801046ca:	83 c4 10             	add    $0x10,%esp
  return 0;
801046cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046d2:	c9                   	leave
801046d3:	c3                   	ret

801046d4 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	56                   	push   %esi
801046d9:	53                   	push   %ebx
801046da:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801046dd:	e8 f3 fc ff ff       	call   801043d5 <myproc>
801046e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801046e5:	e8 14 fd ff ff       	call   801043fe <allocproc>
801046ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
801046ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801046f1:	75 0a                	jne    801046fd <fork+0x29>
    return -1;
801046f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f8:	e9 48 01 00 00       	jmp    80104845 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801046fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104700:	8b 10                	mov    (%eax),%edx
80104702:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104705:	8b 40 04             	mov    0x4(%eax),%eax
80104708:	83 ec 08             	sub    $0x8,%esp
8010470b:	52                   	push   %edx
8010470c:	50                   	push   %eax
8010470d:	e8 82 3b 00 00       	call   80108294 <copyuvm>
80104712:	83 c4 10             	add    $0x10,%esp
80104715:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104718:	89 42 04             	mov    %eax,0x4(%edx)
8010471b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010471e:	8b 40 04             	mov    0x4(%eax),%eax
80104721:	85 c0                	test   %eax,%eax
80104723:	75 30                	jne    80104755 <fork+0x81>
    kfree(np->kstack);
80104725:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104728:	8b 40 08             	mov    0x8(%eax),%eax
8010472b:	83 ec 0c             	sub    $0xc,%esp
8010472e:	50                   	push   %eax
8010472f:	e8 ec e4 ff ff       	call   80102c20 <kfree>
80104734:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104737:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010473a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104741:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104744:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010474b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104750:	e9 f0 00 00 00       	jmp    80104845 <fork+0x171>
  }
  np->sz = curproc->sz;
80104755:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104758:	8b 10                	mov    (%eax),%edx
8010475a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010475d:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010475f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104762:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104765:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104768:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476b:	8b 48 18             	mov    0x18(%eax),%ecx
8010476e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104771:	8b 40 18             	mov    0x18(%eax),%eax
80104774:	89 c2                	mov    %eax,%edx
80104776:	89 cb                	mov    %ecx,%ebx
80104778:	b8 13 00 00 00       	mov    $0x13,%eax
8010477d:	89 d7                	mov    %edx,%edi
8010477f:	89 de                	mov    %ebx,%esi
80104781:	89 c1                	mov    %eax,%ecx
80104783:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104785:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104788:	8b 40 18             	mov    0x18(%eax),%eax
8010478b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104792:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104799:	eb 3b                	jmp    801047d6 <fork+0x102>
    if(curproc->ofile[i])
8010479b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047a1:	83 c2 08             	add    $0x8,%edx
801047a4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047a8:	85 c0                	test   %eax,%eax
801047aa:	74 26                	je     801047d2 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
801047ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b2:	83 c2 08             	add    $0x8,%edx
801047b5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047b9:	83 ec 0c             	sub    $0xc,%esp
801047bc:	50                   	push   %eax
801047bd:	e8 cf c8 ff ff       	call   80101091 <filedup>
801047c2:	83 c4 10             	add    $0x10,%esp
801047c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047cb:	83 c1 08             	add    $0x8,%ecx
801047ce:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801047d2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047d6:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047da:	7e bf                	jle    8010479b <fork+0xc7>
  np->cwd = idup(curproc->cwd);
801047dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047df:	8b 40 68             	mov    0x68(%eax),%eax
801047e2:	83 ec 0c             	sub    $0xc,%esp
801047e5:	50                   	push   %eax
801047e6:	e8 f7 d1 ff ff       	call   801019e2 <idup>
801047eb:	83 c4 10             	add    $0x10,%esp
801047ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047f1:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801047f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f7:	8d 50 6c             	lea    0x6c(%eax),%edx
801047fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047fd:	83 c0 6c             	add    $0x6c,%eax
80104800:	83 ec 04             	sub    $0x4,%esp
80104803:	6a 10                	push   $0x10
80104805:	52                   	push   %edx
80104806:	50                   	push   %eax
80104807:	e8 3c 0d 00 00       	call   80105548 <safestrcpy>
8010480c:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
8010480f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104812:	8b 40 10             	mov    0x10(%eax),%eax
80104815:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 60 ad 14 80       	push   $0x8014ad60
80104820:	e8 9a 08 00 00       	call   801050bf <acquire>
80104825:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104828:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010482b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 60 ad 14 80       	push   $0x8014ad60
8010483a:	e8 ee 08 00 00       	call   8010512d <release>
8010483f:	83 c4 10             	add    $0x10,%esp

  return pid;
80104842:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104845:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104848:	5b                   	pop    %ebx
80104849:	5e                   	pop    %esi
8010484a:	5f                   	pop    %edi
8010484b:	5d                   	pop    %ebp
8010484c:	c3                   	ret

8010484d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010484d:	55                   	push   %ebp
8010484e:	89 e5                	mov    %esp,%ebp
80104850:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104853:	e8 7d fb ff ff       	call   801043d5 <myproc>
80104858:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010485b:	a1 94 cc 14 80       	mov    0x8014cc94,%eax
80104860:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104863:	75 0d                	jne    80104872 <exit+0x25>
    panic("init exiting");
80104865:	83 ec 0c             	sub    $0xc,%esp
80104868:	68 12 8a 10 80       	push   $0x80108a12
8010486d:	e8 41 bd ff ff       	call   801005b3 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104879:	eb 3f                	jmp    801048ba <exit+0x6d>
    if(curproc->ofile[fd]){
8010487b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010487e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104881:	83 c2 08             	add    $0x8,%edx
80104884:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104888:	85 c0                	test   %eax,%eax
8010488a:	74 2a                	je     801048b6 <exit+0x69>
      fileclose(curproc->ofile[fd]);
8010488c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104892:	83 c2 08             	add    $0x8,%edx
80104895:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104899:	83 ec 0c             	sub    $0xc,%esp
8010489c:	50                   	push   %eax
8010489d:	e8 40 c8 ff ff       	call   801010e2 <fileclose>
801048a2:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801048a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048ab:	83 c2 08             	add    $0x8,%edx
801048ae:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048b5:	00 
  for(fd = 0; fd < NOFILE; fd++){
801048b6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048ba:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048be:	7e bb                	jle    8010487b <exit+0x2e>
    }
  }

  begin_op();
801048c0:	e8 ad ed ff ff       	call   80103672 <begin_op>
  iput(curproc->cwd);
801048c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048c8:	8b 40 68             	mov    0x68(%eax),%eax
801048cb:	83 ec 0c             	sub    $0xc,%esp
801048ce:	50                   	push   %eax
801048cf:	e8 a9 d2 ff ff       	call   80101b7d <iput>
801048d4:	83 c4 10             	add    $0x10,%esp
  end_op();
801048d7:	e8 22 ee ff ff       	call   801036fe <end_op>
  curproc->cwd = 0;
801048dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048df:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048e6:	83 ec 0c             	sub    $0xc,%esp
801048e9:	68 60 ad 14 80       	push   $0x8014ad60
801048ee:	e8 cc 07 00 00       	call   801050bf <acquire>
801048f3:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801048f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048f9:	8b 40 14             	mov    0x14(%eax),%eax
801048fc:	83 ec 0c             	sub    $0xc,%esp
801048ff:	50                   	push   %eax
80104900:	e8 20 04 00 00       	call   80104d25 <wakeup1>
80104905:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104908:	c7 45 f4 94 ad 14 80 	movl   $0x8014ad94,-0xc(%ebp)
8010490f:	eb 37                	jmp    80104948 <exit+0xfb>
    if(p->parent == curproc){
80104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104914:	8b 40 14             	mov    0x14(%eax),%eax
80104917:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010491a:	75 28                	jne    80104944 <exit+0xf7>
      p->parent = initproc;
8010491c:	8b 15 94 cc 14 80    	mov    0x8014cc94,%edx
80104922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104925:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492b:	8b 40 0c             	mov    0xc(%eax),%eax
8010492e:	83 f8 05             	cmp    $0x5,%eax
80104931:	75 11                	jne    80104944 <exit+0xf7>
        wakeup1(initproc);
80104933:	a1 94 cc 14 80       	mov    0x8014cc94,%eax
80104938:	83 ec 0c             	sub    $0xc,%esp
8010493b:	50                   	push   %eax
8010493c:	e8 e4 03 00 00       	call   80104d25 <wakeup1>
80104941:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104944:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104948:	81 7d f4 94 cc 14 80 	cmpl   $0x8014cc94,-0xc(%ebp)
8010494f:	72 c0                	jb     80104911 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104951:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104954:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010495b:	e8 e5 01 00 00       	call   80104b45 <sched>
  panic("zombie exit");
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 1f 8a 10 80       	push   $0x80108a1f
80104968:	e8 46 bc ff ff       	call   801005b3 <panic>

8010496d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010496d:	55                   	push   %ebp
8010496e:	89 e5                	mov    %esp,%ebp
80104970:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104973:	e8 5d fa ff ff       	call   801043d5 <myproc>
80104978:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010497b:	83 ec 0c             	sub    $0xc,%esp
8010497e:	68 60 ad 14 80       	push   $0x8014ad60
80104983:	e8 37 07 00 00       	call   801050bf <acquire>
80104988:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010498b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104992:	c7 45 f4 94 ad 14 80 	movl   $0x8014ad94,-0xc(%ebp)
80104999:	e9 a1 00 00 00       	jmp    80104a3f <wait+0xd2>
      if(p->parent != curproc)
8010499e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a1:	8b 40 14             	mov    0x14(%eax),%eax
801049a4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801049a7:	0f 85 8d 00 00 00    	jne    80104a3a <wait+0xcd>
        continue;
      havekids = 1;
801049ad:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b7:	8b 40 0c             	mov    0xc(%eax),%eax
801049ba:	83 f8 05             	cmp    $0x5,%eax
801049bd:	75 7c                	jne    80104a3b <wait+0xce>
        // Found one.
        pid = p->pid;
801049bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c2:	8b 40 10             	mov    0x10(%eax),%eax
801049c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cb:	8b 40 08             	mov    0x8(%eax),%eax
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	50                   	push   %eax
801049d2:	e8 49 e2 ff ff       	call   80102c20 <kfree>
801049d7:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801049da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e7:	8b 40 04             	mov    0x4(%eax),%eax
801049ea:	83 ec 0c             	sub    $0xc,%esp
801049ed:	50                   	push   %eax
801049ee:	e8 c7 37 00 00       	call   801081ba <freevm>
801049f3:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801049f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a03:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a14:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104a25:	83 ec 0c             	sub    $0xc,%esp
80104a28:	68 60 ad 14 80       	push   $0x8014ad60
80104a2d:	e8 fb 06 00 00       	call   8010512d <release>
80104a32:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a38:	eb 51                	jmp    80104a8b <wait+0x11e>
        continue;
80104a3a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a3f:	81 7d f4 94 cc 14 80 	cmpl   $0x8014cc94,-0xc(%ebp)
80104a46:	0f 82 52 ff ff ff    	jb     8010499e <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104a4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a50:	74 0a                	je     80104a5c <wait+0xef>
80104a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a55:	8b 40 24             	mov    0x24(%eax),%eax
80104a58:	85 c0                	test   %eax,%eax
80104a5a:	74 17                	je     80104a73 <wait+0x106>
      release(&ptable.lock);
80104a5c:	83 ec 0c             	sub    $0xc,%esp
80104a5f:	68 60 ad 14 80       	push   $0x8014ad60
80104a64:	e8 c4 06 00 00       	call   8010512d <release>
80104a69:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a71:	eb 18                	jmp    80104a8b <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a73:	83 ec 08             	sub    $0x8,%esp
80104a76:	68 60 ad 14 80       	push   $0x8014ad60
80104a7b:	ff 75 ec             	push   -0x14(%ebp)
80104a7e:	e8 fb 01 00 00       	call   80104c7e <sleep>
80104a83:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104a86:	e9 00 ff ff ff       	jmp    8010498b <wait+0x1e>
  }
}
80104a8b:	c9                   	leave
80104a8c:	c3                   	ret

80104a8d <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a8d:	55                   	push   %ebp
80104a8e:	89 e5                	mov    %esp,%ebp
80104a90:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104a93:	e8 c5 f8 ff ff       	call   8010435d <mycpu>
80104a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104aa5:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104aa8:	e8 70 f8 ff ff       	call   8010431d <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104aad:	83 ec 0c             	sub    $0xc,%esp
80104ab0:	68 60 ad 14 80       	push   $0x8014ad60
80104ab5:	e8 05 06 00 00       	call   801050bf <acquire>
80104aba:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104abd:	c7 45 f4 94 ad 14 80 	movl   $0x8014ad94,-0xc(%ebp)
80104ac4:	eb 61                	jmp    80104b27 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac9:	8b 40 0c             	mov    0xc(%eax),%eax
80104acc:	83 f8 03             	cmp    $0x3,%eax
80104acf:	75 51                	jne    80104b22 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ad7:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104add:	83 ec 0c             	sub    $0xc,%esp
80104ae0:	ff 75 f4             	push   -0xc(%ebp)
80104ae3:	e8 2d 32 00 00       	call   80107d15 <switchuvm>
80104ae8:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aee:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104afb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104afe:	83 c2 04             	add    $0x4,%edx
80104b01:	83 ec 08             	sub    $0x8,%esp
80104b04:	50                   	push   %eax
80104b05:	52                   	push   %edx
80104b06:	e8 af 0a 00 00       	call   801055ba <swtch>
80104b0b:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b0e:	e8 e9 31 00 00       	call   80107cfc <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b16:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104b1d:	00 00 00 
80104b20:	eb 01                	jmp    80104b23 <scheduler+0x96>
        continue;
80104b22:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b23:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b27:	81 7d f4 94 cc 14 80 	cmpl   $0x8014cc94,-0xc(%ebp)
80104b2e:	72 96                	jb     80104ac6 <scheduler+0x39>
    }
    release(&ptable.lock);
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	68 60 ad 14 80       	push   $0x8014ad60
80104b38:	e8 f0 05 00 00       	call   8010512d <release>
80104b3d:	83 c4 10             	add    $0x10,%esp
    sti();
80104b40:	e9 63 ff ff ff       	jmp    80104aa8 <scheduler+0x1b>

80104b45 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104b45:	55                   	push   %ebp
80104b46:	89 e5                	mov    %esp,%ebp
80104b48:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104b4b:	e8 85 f8 ff ff       	call   801043d5 <myproc>
80104b50:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104b53:	83 ec 0c             	sub    $0xc,%esp
80104b56:	68 60 ad 14 80       	push   $0x8014ad60
80104b5b:	e8 9a 06 00 00       	call   801051fa <holding>
80104b60:	83 c4 10             	add    $0x10,%esp
80104b63:	85 c0                	test   %eax,%eax
80104b65:	75 0d                	jne    80104b74 <sched+0x2f>
    panic("sched ptable.lock");
80104b67:	83 ec 0c             	sub    $0xc,%esp
80104b6a:	68 2b 8a 10 80       	push   $0x80108a2b
80104b6f:	e8 3f ba ff ff       	call   801005b3 <panic>
  if(mycpu()->ncli != 1)
80104b74:	e8 e4 f7 ff ff       	call   8010435d <mycpu>
80104b79:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b7f:	83 f8 01             	cmp    $0x1,%eax
80104b82:	74 0d                	je     80104b91 <sched+0x4c>
    panic("sched locks");
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	68 3d 8a 10 80       	push   $0x80108a3d
80104b8c:	e8 22 ba ff ff       	call   801005b3 <panic>
  if(p->state == RUNNING)
80104b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b94:	8b 40 0c             	mov    0xc(%eax),%eax
80104b97:	83 f8 04             	cmp    $0x4,%eax
80104b9a:	75 0d                	jne    80104ba9 <sched+0x64>
    panic("sched running");
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	68 49 8a 10 80       	push   $0x80108a49
80104ba4:	e8 0a ba ff ff       	call   801005b3 <panic>
  if(readeflags()&FL_IF)
80104ba9:	e8 5f f7 ff ff       	call   8010430d <readeflags>
80104bae:	25 00 02 00 00       	and    $0x200,%eax
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	74 0d                	je     80104bc4 <sched+0x7f>
    panic("sched interruptible");
80104bb7:	83 ec 0c             	sub    $0xc,%esp
80104bba:	68 57 8a 10 80       	push   $0x80108a57
80104bbf:	e8 ef b9 ff ff       	call   801005b3 <panic>
  intena = mycpu()->intena;
80104bc4:	e8 94 f7 ff ff       	call   8010435d <mycpu>
80104bc9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104bd2:	e8 86 f7 ff ff       	call   8010435d <mycpu>
80104bd7:	8b 40 04             	mov    0x4(%eax),%eax
80104bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bdd:	83 c2 1c             	add    $0x1c,%edx
80104be0:	83 ec 08             	sub    $0x8,%esp
80104be3:	50                   	push   %eax
80104be4:	52                   	push   %edx
80104be5:	e8 d0 09 00 00       	call   801055ba <swtch>
80104bea:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104bed:	e8 6b f7 ff ff       	call   8010435d <mycpu>
80104bf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bf5:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104bfb:	90                   	nop
80104bfc:	c9                   	leave
80104bfd:	c3                   	ret

80104bfe <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104bfe:	55                   	push   %ebp
80104bff:	89 e5                	mov    %esp,%ebp
80104c01:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	68 60 ad 14 80       	push   $0x8014ad60
80104c0c:	e8 ae 04 00 00       	call   801050bf <acquire>
80104c11:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104c14:	e8 bc f7 ff ff       	call   801043d5 <myproc>
80104c19:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c20:	e8 20 ff ff ff       	call   80104b45 <sched>
  release(&ptable.lock);
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	68 60 ad 14 80       	push   $0x8014ad60
80104c2d:	e8 fb 04 00 00       	call   8010512d <release>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	90                   	nop
80104c36:	c9                   	leave
80104c37:	c3                   	ret

80104c38 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c38:	55                   	push   %ebp
80104c39:	89 e5                	mov    %esp,%ebp
80104c3b:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c3e:	83 ec 0c             	sub    $0xc,%esp
80104c41:	68 60 ad 14 80       	push   $0x8014ad60
80104c46:	e8 e2 04 00 00       	call   8010512d <release>
80104c4b:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c4e:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104c53:	85 c0                	test   %eax,%eax
80104c55:	74 24                	je     80104c7b <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104c57:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104c5e:	00 00 00 
    iinit(ROOTDEV);
80104c61:	83 ec 0c             	sub    $0xc,%esp
80104c64:	6a 01                	push   $0x1
80104c66:	e8 40 ca ff ff       	call   801016ab <iinit>
80104c6b:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	6a 01                	push   $0x1
80104c73:	e8 db e7 ff ff       	call   80103453 <initlog>
80104c78:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104c7b:	90                   	nop
80104c7c:	c9                   	leave
80104c7d:	c3                   	ret

80104c7e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c7e:	55                   	push   %ebp
80104c7f:	89 e5                	mov    %esp,%ebp
80104c81:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104c84:	e8 4c f7 ff ff       	call   801043d5 <myproc>
80104c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c90:	75 0d                	jne    80104c9f <sleep+0x21>
    panic("sleep");
80104c92:	83 ec 0c             	sub    $0xc,%esp
80104c95:	68 6b 8a 10 80       	push   $0x80108a6b
80104c9a:	e8 14 b9 ff ff       	call   801005b3 <panic>

  if(lk == 0)
80104c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ca3:	75 0d                	jne    80104cb2 <sleep+0x34>
    panic("sleep without lk");
80104ca5:	83 ec 0c             	sub    $0xc,%esp
80104ca8:	68 71 8a 10 80       	push   $0x80108a71
80104cad:	e8 01 b9 ff ff       	call   801005b3 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cb2:	81 7d 0c 60 ad 14 80 	cmpl   $0x8014ad60,0xc(%ebp)
80104cb9:	74 1e                	je     80104cd9 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cbb:	83 ec 0c             	sub    $0xc,%esp
80104cbe:	68 60 ad 14 80       	push   $0x8014ad60
80104cc3:	e8 f7 03 00 00       	call   801050bf <acquire>
80104cc8:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104ccb:	83 ec 0c             	sub    $0xc,%esp
80104cce:	ff 75 0c             	push   0xc(%ebp)
80104cd1:	e8 57 04 00 00       	call   8010512d <release>
80104cd6:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdc:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdf:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104cec:	e8 54 fe ff ff       	call   80104b45 <sched>

  // Tidy up.
  p->chan = 0;
80104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf4:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104cfb:	81 7d 0c 60 ad 14 80 	cmpl   $0x8014ad60,0xc(%ebp)
80104d02:	74 1e                	je     80104d22 <sleep+0xa4>
    release(&ptable.lock);
80104d04:	83 ec 0c             	sub    $0xc,%esp
80104d07:	68 60 ad 14 80       	push   $0x8014ad60
80104d0c:	e8 1c 04 00 00       	call   8010512d <release>
80104d11:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	ff 75 0c             	push   0xc(%ebp)
80104d1a:	e8 a0 03 00 00       	call   801050bf <acquire>
80104d1f:	83 c4 10             	add    $0x10,%esp
  }
}
80104d22:	90                   	nop
80104d23:	c9                   	leave
80104d24:	c3                   	ret

80104d25 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d25:	55                   	push   %ebp
80104d26:	89 e5                	mov    %esp,%ebp
80104d28:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d2b:	c7 45 fc 94 ad 14 80 	movl   $0x8014ad94,-0x4(%ebp)
80104d32:	eb 24                	jmp    80104d58 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d37:	8b 40 0c             	mov    0xc(%eax),%eax
80104d3a:	83 f8 02             	cmp    $0x2,%eax
80104d3d:	75 15                	jne    80104d54 <wakeup1+0x2f>
80104d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d42:	8b 40 20             	mov    0x20(%eax),%eax
80104d45:	39 45 08             	cmp    %eax,0x8(%ebp)
80104d48:	75 0a                	jne    80104d54 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d4d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d54:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104d58:	81 7d fc 94 cc 14 80 	cmpl   $0x8014cc94,-0x4(%ebp)
80104d5f:	72 d3                	jb     80104d34 <wakeup1+0xf>
}
80104d61:	90                   	nop
80104d62:	90                   	nop
80104d63:	c9                   	leave
80104d64:	c3                   	ret

80104d65 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d65:	55                   	push   %ebp
80104d66:	89 e5                	mov    %esp,%ebp
80104d68:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d6b:	83 ec 0c             	sub    $0xc,%esp
80104d6e:	68 60 ad 14 80       	push   $0x8014ad60
80104d73:	e8 47 03 00 00       	call   801050bf <acquire>
80104d78:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d7b:	83 ec 0c             	sub    $0xc,%esp
80104d7e:	ff 75 08             	push   0x8(%ebp)
80104d81:	e8 9f ff ff ff       	call   80104d25 <wakeup1>
80104d86:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 60 ad 14 80       	push   $0x8014ad60
80104d91:	e8 97 03 00 00       	call   8010512d <release>
80104d96:	83 c4 10             	add    $0x10,%esp
}
80104d99:	90                   	nop
80104d9a:	c9                   	leave
80104d9b:	c3                   	ret

80104d9c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d9c:	55                   	push   %ebp
80104d9d:	89 e5                	mov    %esp,%ebp
80104d9f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104da2:	83 ec 0c             	sub    $0xc,%esp
80104da5:	68 60 ad 14 80       	push   $0x8014ad60
80104daa:	e8 10 03 00 00       	call   801050bf <acquire>
80104daf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db2:	c7 45 f4 94 ad 14 80 	movl   $0x8014ad94,-0xc(%ebp)
80104db9:	eb 45                	jmp    80104e00 <kill+0x64>
    if(p->pid == pid){
80104dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbe:	8b 40 10             	mov    0x10(%eax),%eax
80104dc1:	39 45 08             	cmp    %eax,0x8(%ebp)
80104dc4:	75 36                	jne    80104dfc <kill+0x60>
      p->killed = 1;
80104dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd3:	8b 40 0c             	mov    0xc(%eax),%eax
80104dd6:	83 f8 02             	cmp    $0x2,%eax
80104dd9:	75 0a                	jne    80104de5 <kill+0x49>
        p->state = RUNNABLE;
80104ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dde:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104de5:	83 ec 0c             	sub    $0xc,%esp
80104de8:	68 60 ad 14 80       	push   $0x8014ad60
80104ded:	e8 3b 03 00 00       	call   8010512d <release>
80104df2:	83 c4 10             	add    $0x10,%esp
      return 0;
80104df5:	b8 00 00 00 00       	mov    $0x0,%eax
80104dfa:	eb 22                	jmp    80104e1e <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dfc:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e00:	81 7d f4 94 cc 14 80 	cmpl   $0x8014cc94,-0xc(%ebp)
80104e07:	72 b2                	jb     80104dbb <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104e09:	83 ec 0c             	sub    $0xc,%esp
80104e0c:	68 60 ad 14 80       	push   $0x8014ad60
80104e11:	e8 17 03 00 00       	call   8010512d <release>
80104e16:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e1e:	c9                   	leave
80104e1f:	c3                   	ret

80104e20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e26:	c7 45 f0 94 ad 14 80 	movl   $0x8014ad94,-0x10(%ebp)
80104e2d:	e9 d7 00 00 00       	jmp    80104f09 <procdump+0xe9>
    if(p->state == UNUSED)
80104e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e35:	8b 40 0c             	mov    0xc(%eax),%eax
80104e38:	85 c0                	test   %eax,%eax
80104e3a:	0f 84 c4 00 00 00    	je     80104f04 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e43:	8b 40 0c             	mov    0xc(%eax),%eax
80104e46:	83 f8 05             	cmp    $0x5,%eax
80104e49:	77 23                	ja     80104e6e <procdump+0x4e>
80104e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e51:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104e58:	85 c0                	test   %eax,%eax
80104e5a:	74 12                	je     80104e6e <procdump+0x4e>
      state = states[p->state];
80104e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e62:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e6c:	eb 07                	jmp    80104e75 <procdump+0x55>
    else
      state = "???";
80104e6e:	c7 45 ec 82 8a 10 80 	movl   $0x80108a82,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e78:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7e:	8b 40 10             	mov    0x10(%eax),%eax
80104e81:	52                   	push   %edx
80104e82:	ff 75 ec             	push   -0x14(%ebp)
80104e85:	50                   	push   %eax
80104e86:	68 86 8a 10 80       	push   $0x80108a86
80104e8b:	e8 6e b5 ff ff       	call   801003fe <cprintf>
80104e90:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e96:	8b 40 0c             	mov    0xc(%eax),%eax
80104e99:	83 f8 02             	cmp    $0x2,%eax
80104e9c:	75 54                	jne    80104ef2 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ea4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea7:	83 c0 08             	add    $0x8,%eax
80104eaa:	89 c2                	mov    %eax,%edx
80104eac:	83 ec 08             	sub    $0x8,%esp
80104eaf:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104eb2:	50                   	push   %eax
80104eb3:	52                   	push   %edx
80104eb4:	e8 c6 02 00 00       	call   8010517f <getcallerpcs>
80104eb9:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ec3:	eb 1c                	jmp    80104ee1 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ecc:	83 ec 08             	sub    $0x8,%esp
80104ecf:	50                   	push   %eax
80104ed0:	68 8f 8a 10 80       	push   $0x80108a8f
80104ed5:	e8 24 b5 ff ff       	call   801003fe <cprintf>
80104eda:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104edd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ee1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ee5:	7f 0b                	jg     80104ef2 <procdump+0xd2>
80104ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eea:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eee:	85 c0                	test   %eax,%eax
80104ef0:	75 d3                	jne    80104ec5 <procdump+0xa5>
    }
    cprintf("\n");
80104ef2:	83 ec 0c             	sub    $0xc,%esp
80104ef5:	68 93 8a 10 80       	push   $0x80108a93
80104efa:	e8 ff b4 ff ff       	call   801003fe <cprintf>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	eb 01                	jmp    80104f05 <procdump+0xe5>
      continue;
80104f04:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f05:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104f09:	81 7d f0 94 cc 14 80 	cmpl   $0x8014cc94,-0x10(%ebp)
80104f10:	0f 82 1c ff ff ff    	jb     80104e32 <procdump+0x12>
  }
}
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	c9                   	leave
80104f19:	c3                   	ret

80104f1a <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f1a:	55                   	push   %ebp
80104f1b:	89 e5                	mov    %esp,%ebp
80104f1d:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104f20:	8b 45 08             	mov    0x8(%ebp),%eax
80104f23:	83 c0 04             	add    $0x4,%eax
80104f26:	83 ec 08             	sub    $0x8,%esp
80104f29:	68 bf 8a 10 80       	push   $0x80108abf
80104f2e:	50                   	push   %eax
80104f2f:	e8 69 01 00 00       	call   8010509d <initlock>
80104f34:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104f37:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f3d:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104f40:	8b 45 08             	mov    0x8(%ebp),%eax
80104f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104f49:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104f53:	90                   	nop
80104f54:	c9                   	leave
80104f55:	c3                   	ret

80104f56 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f56:	55                   	push   %ebp
80104f57:	89 e5                	mov    %esp,%ebp
80104f59:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5f:	83 c0 04             	add    $0x4,%eax
80104f62:	83 ec 0c             	sub    $0xc,%esp
80104f65:	50                   	push   %eax
80104f66:	e8 54 01 00 00       	call   801050bf <acquire>
80104f6b:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104f6e:	eb 15                	jmp    80104f85 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104f70:	8b 45 08             	mov    0x8(%ebp),%eax
80104f73:	83 c0 04             	add    $0x4,%eax
80104f76:	83 ec 08             	sub    $0x8,%esp
80104f79:	50                   	push   %eax
80104f7a:	ff 75 08             	push   0x8(%ebp)
80104f7d:	e8 fc fc ff ff       	call   80104c7e <sleep>
80104f82:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104f85:	8b 45 08             	mov    0x8(%ebp),%eax
80104f88:	8b 00                	mov    (%eax),%eax
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	75 e2                	jne    80104f70 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f91:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104f97:	e8 39 f4 ff ff       	call   801043d5 <myproc>
80104f9c:	8b 50 10             	mov    0x10(%eax),%edx
80104f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa2:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa8:	83 c0 04             	add    $0x4,%eax
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	50                   	push   %eax
80104faf:	e8 79 01 00 00       	call   8010512d <release>
80104fb4:	83 c4 10             	add    $0x10,%esp
}
80104fb7:	90                   	nop
80104fb8:	c9                   	leave
80104fb9:	c3                   	ret

80104fba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104fba:	55                   	push   %ebp
80104fbb:	89 e5                	mov    %esp,%ebp
80104fbd:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc3:	83 c0 04             	add    $0x4,%eax
80104fc6:	83 ec 0c             	sub    $0xc,%esp
80104fc9:	50                   	push   %eax
80104fca:	e8 f0 00 00 00       	call   801050bf <acquire>
80104fcf:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fde:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	ff 75 08             	push   0x8(%ebp)
80104feb:	e8 75 fd ff ff       	call   80104d65 <wakeup>
80104ff0:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff6:	83 c0 04             	add    $0x4,%eax
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	50                   	push   %eax
80104ffd:	e8 2b 01 00 00       	call   8010512d <release>
80105002:	83 c4 10             	add    $0x10,%esp
}
80105005:	90                   	nop
80105006:	c9                   	leave
80105007:	c3                   	ret

80105008 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105008:	55                   	push   %ebp
80105009:	89 e5                	mov    %esp,%ebp
8010500b:	53                   	push   %ebx
8010500c:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
8010500f:	8b 45 08             	mov    0x8(%ebp),%eax
80105012:	83 c0 04             	add    $0x4,%eax
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 a1 00 00 00       	call   801050bf <acquire>
8010501e:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
80105021:	8b 45 08             	mov    0x8(%ebp),%eax
80105024:	8b 00                	mov    (%eax),%eax
80105026:	85 c0                	test   %eax,%eax
80105028:	74 19                	je     80105043 <holdingsleep+0x3b>
8010502a:	8b 45 08             	mov    0x8(%ebp),%eax
8010502d:	8b 58 3c             	mov    0x3c(%eax),%ebx
80105030:	e8 a0 f3 ff ff       	call   801043d5 <myproc>
80105035:	8b 40 10             	mov    0x10(%eax),%eax
80105038:	39 c3                	cmp    %eax,%ebx
8010503a:	75 07                	jne    80105043 <holdingsleep+0x3b>
8010503c:	b8 01 00 00 00       	mov    $0x1,%eax
80105041:	eb 05                	jmp    80105048 <holdingsleep+0x40>
80105043:	b8 00 00 00 00       	mov    $0x0,%eax
80105048:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010504b:	8b 45 08             	mov    0x8(%ebp),%eax
8010504e:	83 c0 04             	add    $0x4,%eax
80105051:	83 ec 0c             	sub    $0xc,%esp
80105054:	50                   	push   %eax
80105055:	e8 d3 00 00 00       	call   8010512d <release>
8010505a:	83 c4 10             	add    $0x10,%esp
  return r;
8010505d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105063:	c9                   	leave
80105064:	c3                   	ret

80105065 <readeflags>:
{
  int r;
  pushcli();
  r = lock->locked && lock->cpu == mycpu();
  popcli();
  return r;
80105065:	55                   	push   %ebp
80105066:	89 e5                	mov    %esp,%ebp
80105068:	83 ec 10             	sub    $0x10,%esp
}

8010506b:	9c                   	pushf
8010506c:	58                   	pop    %eax
8010506d:	89 45 fc             	mov    %eax,-0x4(%ebp)

80105070:	8b 45 fc             	mov    -0x4(%ebp),%eax
// Pushcli/popcli are like cli/sti except that they are matched:
80105073:	c9                   	leave
80105074:	c3                   	ret

80105075 <cli>:
pushcli(void)
{
  int eflags;

  eflags = readeflags();
  cli();
80105075:	55                   	push   %ebp
80105076:	89 e5                	mov    %esp,%ebp
  if(mycpu()->ncli == 0)
80105078:	fa                   	cli
    mycpu()->intena = eflags & FL_IF;
80105079:	90                   	nop
8010507a:	5d                   	pop    %ebp
8010507b:	c3                   	ret

8010507c <sti>:
  mycpu()->ncli += 1;
}

void
8010507c:	55                   	push   %ebp
8010507d:	89 e5                	mov    %esp,%ebp
popcli(void)
8010507f:	fb                   	sti
{
80105080:	90                   	nop
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret

80105083 <xchg>:
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80105083:	55                   	push   %ebp
80105084:	89 e5                	mov    %esp,%ebp
80105086:	83 ec 10             	sub    $0x10,%esp
  if(mycpu()->ncli == 0 && mycpu()->intena)
    sti();
}

80105089:	8b 55 08             	mov    0x8(%ebp),%edx
8010508c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105092:	f0 87 02             	lock xchg %eax,(%edx)
80105095:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105098:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010509b:	c9                   	leave
8010509c:	c3                   	ret

8010509d <initlock>:
{
8010509d:	55                   	push   %ebp
8010509e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801050a0:	8b 45 08             	mov    0x8(%ebp),%eax
801050a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050a6:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801050a9:	8b 45 08             	mov    0x8(%ebp),%eax
801050ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801050b2:	8b 45 08             	mov    0x8(%ebp),%eax
801050b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050bc:	90                   	nop
801050bd:	5d                   	pop    %ebp
801050be:	c3                   	ret

801050bf <acquire>:
{
801050bf:	55                   	push   %ebp
801050c0:	89 e5                	mov    %esp,%ebp
801050c2:	53                   	push   %ebx
801050c3:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050c6:	e8 6f 01 00 00       	call   8010523a <pushcli>
  if(holding(lk))
801050cb:	8b 45 08             	mov    0x8(%ebp),%eax
801050ce:	83 ec 0c             	sub    $0xc,%esp
801050d1:	50                   	push   %eax
801050d2:	e8 23 01 00 00       	call   801051fa <holding>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	74 0d                	je     801050eb <acquire+0x2c>
    panic("acquire");
801050de:	83 ec 0c             	sub    $0xc,%esp
801050e1:	68 ca 8a 10 80       	push   $0x80108aca
801050e6:	e8 c8 b4 ff ff       	call   801005b3 <panic>
  while(xchg(&lk->locked, 1) != 0)
801050eb:	90                   	nop
801050ec:	8b 45 08             	mov    0x8(%ebp),%eax
801050ef:	83 ec 08             	sub    $0x8,%esp
801050f2:	6a 01                	push   $0x1
801050f4:	50                   	push   %eax
801050f5:	e8 89 ff ff ff       	call   80105083 <xchg>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	75 eb                	jne    801050ec <acquire+0x2d>
  __sync_synchronize();
80105101:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105106:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105109:	e8 4f f2 ff ff       	call   8010435d <mycpu>
8010510e:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105111:	8b 45 08             	mov    0x8(%ebp),%eax
80105114:	83 c0 0c             	add    $0xc,%eax
80105117:	83 ec 08             	sub    $0x8,%esp
8010511a:	50                   	push   %eax
8010511b:	8d 45 08             	lea    0x8(%ebp),%eax
8010511e:	50                   	push   %eax
8010511f:	e8 5b 00 00 00       	call   8010517f <getcallerpcs>
80105124:	83 c4 10             	add    $0x10,%esp
}
80105127:	90                   	nop
80105128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010512b:	c9                   	leave
8010512c:	c3                   	ret

8010512d <release>:
{
8010512d:	55                   	push   %ebp
8010512e:	89 e5                	mov    %esp,%ebp
80105130:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105133:	83 ec 0c             	sub    $0xc,%esp
80105136:	ff 75 08             	push   0x8(%ebp)
80105139:	e8 bc 00 00 00       	call   801051fa <holding>
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	85 c0                	test   %eax,%eax
80105143:	75 0d                	jne    80105152 <release+0x25>
    panic("release");
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	68 d2 8a 10 80       	push   $0x80108ad2
8010514d:	e8 61 b4 ff ff       	call   801005b3 <panic>
  lk->pcs[0] = 0;
80105152:	8b 45 08             	mov    0x8(%ebp),%eax
80105155:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010515c:	8b 45 08             	mov    0x8(%ebp),%eax
8010515f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  __sync_synchronize();
80105166:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010516b:	8b 45 08             	mov    0x8(%ebp),%eax
8010516e:	8b 55 08             	mov    0x8(%ebp),%edx
80105171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  popcli();
80105177:	e8 0b 01 00 00       	call   80105287 <popcli>
}
8010517c:	90                   	nop
8010517d:	c9                   	leave
8010517e:	c3                   	ret

8010517f <getcallerpcs>:
{
8010517f:	55                   	push   %ebp
80105180:	89 e5                	mov    %esp,%ebp
80105182:	83 ec 10             	sub    $0x10,%esp
  ebp = (uint*)v - 2;
80105185:	8b 45 08             	mov    0x8(%ebp),%eax
80105188:	83 e8 08             	sub    $0x8,%eax
8010518b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010518e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105195:	eb 38                	jmp    801051cf <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105197:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010519b:	74 53                	je     801051f0 <getcallerpcs+0x71>
8010519d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801051a4:	76 4a                	jbe    801051f0 <getcallerpcs+0x71>
801051a6:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801051aa:	74 44                	je     801051f0 <getcallerpcs+0x71>
    pcs[i] = ebp[1];     // saved %eip
801051ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b9:	01 c2                	add    %eax,%edx
801051bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051be:	8b 40 04             	mov    0x4(%eax),%eax
801051c1:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801051c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051c6:	8b 00                	mov    (%eax),%eax
801051c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051cb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051cf:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051d3:	7e c2                	jle    80105197 <getcallerpcs+0x18>
  for(; i < 10; i++)
801051d5:	eb 19                	jmp    801051f0 <getcallerpcs+0x71>
    pcs[i] = 0;
801051d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e4:	01 d0                	add    %edx,%eax
801051e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801051ec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051f0:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051f4:	7e e1                	jle    801051d7 <getcallerpcs+0x58>
}
801051f6:	90                   	nop
801051f7:	90                   	nop
801051f8:	c9                   	leave
801051f9:	c3                   	ret

801051fa <holding>:
{
801051fa:	55                   	push   %ebp
801051fb:	89 e5                	mov    %esp,%ebp
801051fd:	53                   	push   %ebx
801051fe:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80105201:	e8 34 00 00 00       	call   8010523a <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105206:	8b 45 08             	mov    0x8(%ebp),%eax
80105209:	8b 00                	mov    (%eax),%eax
8010520b:	85 c0                	test   %eax,%eax
8010520d:	74 16                	je     80105225 <holding+0x2b>
8010520f:	8b 45 08             	mov    0x8(%ebp),%eax
80105212:	8b 58 08             	mov    0x8(%eax),%ebx
80105215:	e8 43 f1 ff ff       	call   8010435d <mycpu>
8010521a:	39 c3                	cmp    %eax,%ebx
8010521c:	75 07                	jne    80105225 <holding+0x2b>
8010521e:	b8 01 00 00 00       	mov    $0x1,%eax
80105223:	eb 05                	jmp    8010522a <holding+0x30>
80105225:	b8 00 00 00 00       	mov    $0x0,%eax
8010522a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010522d:	e8 55 00 00 00       	call   80105287 <popcli>
  return r;
80105232:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105238:	c9                   	leave
80105239:	c3                   	ret

8010523a <pushcli>:
{
8010523a:	55                   	push   %ebp
8010523b:	89 e5                	mov    %esp,%ebp
8010523d:	83 ec 18             	sub    $0x18,%esp
  eflags = readeflags();
80105240:	e8 20 fe ff ff       	call   80105065 <readeflags>
80105245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105248:	e8 28 fe ff ff       	call   80105075 <cli>
  if(mycpu()->ncli == 0)
8010524d:	e8 0b f1 ff ff       	call   8010435d <mycpu>
80105252:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105258:	85 c0                	test   %eax,%eax
8010525a:	75 14                	jne    80105270 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
8010525c:	e8 fc f0 ff ff       	call   8010435d <mycpu>
80105261:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105264:	81 e2 00 02 00 00    	and    $0x200,%edx
8010526a:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105270:	e8 e8 f0 ff ff       	call   8010435d <mycpu>
80105275:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010527b:	83 c2 01             	add    $0x1,%edx
8010527e:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105284:	90                   	nop
80105285:	c9                   	leave
80105286:	c3                   	ret

80105287 <popcli>:
{
80105287:	55                   	push   %ebp
80105288:	89 e5                	mov    %esp,%ebp
8010528a:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010528d:	e8 d3 fd ff ff       	call   80105065 <readeflags>
80105292:	25 00 02 00 00       	and    $0x200,%eax
80105297:	85 c0                	test   %eax,%eax
80105299:	74 0d                	je     801052a8 <popcli+0x21>
    panic("popcli - interruptible");
8010529b:	83 ec 0c             	sub    $0xc,%esp
8010529e:	68 da 8a 10 80       	push   $0x80108ada
801052a3:	e8 0b b3 ff ff       	call   801005b3 <panic>
  if(--mycpu()->ncli < 0)
801052a8:	e8 b0 f0 ff ff       	call   8010435d <mycpu>
801052ad:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801052b3:	83 ea 01             	sub    $0x1,%edx
801052b6:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801052bc:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801052c2:	85 c0                	test   %eax,%eax
801052c4:	79 0d                	jns    801052d3 <popcli+0x4c>
    panic("popcli");
801052c6:	83 ec 0c             	sub    $0xc,%esp
801052c9:	68 f1 8a 10 80       	push   $0x80108af1
801052ce:	e8 e0 b2 ff ff       	call   801005b3 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801052d3:	e8 85 f0 ff ff       	call   8010435d <mycpu>
801052d8:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801052de:	85 c0                	test   %eax,%eax
801052e0:	75 14                	jne    801052f6 <popcli+0x6f>
801052e2:	e8 76 f0 ff ff       	call   8010435d <mycpu>
801052e7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801052ed:	85 c0                	test   %eax,%eax
801052ef:	74 05                	je     801052f6 <popcli+0x6f>
    sti();
801052f1:	e8 86 fd ff ff       	call   8010507c <sti>
}
801052f6:	90                   	nop
801052f7:	c9                   	leave
801052f8:	c3                   	ret

801052f9 <stosb>:
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
801052f9:	55                   	push   %ebp
801052fa:	89 e5                	mov    %esp,%ebp
801052fc:	57                   	push   %edi
801052fd:	53                   	push   %ebx
    while(n-- > 0)
801052fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105301:	8b 55 10             	mov    0x10(%ebp),%edx
80105304:	8b 45 0c             	mov    0xc(%ebp),%eax
80105307:	89 cb                	mov    %ecx,%ebx
80105309:	89 df                	mov    %ebx,%edi
8010530b:	89 d1                	mov    %edx,%ecx
8010530d:	fc                   	cld
8010530e:	f3 aa                	rep stos %al,%es:(%edi)
80105310:	89 ca                	mov    %ecx,%edx
80105312:	89 fb                	mov    %edi,%ebx
80105314:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105317:	89 55 10             	mov    %edx,0x10(%ebp)
      *d++ = *s++;

  return dst;
}
8010531a:	90                   	nop
8010531b:	5b                   	pop    %ebx
8010531c:	5f                   	pop    %edi
8010531d:	5d                   	pop    %ebp
8010531e:	c3                   	ret

8010531f <stosl>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
8010531f:	55                   	push   %ebp
80105320:	89 e5                	mov    %esp,%ebp
80105322:	57                   	push   %edi
80105323:	53                   	push   %ebx
{
80105324:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105327:	8b 55 10             	mov    0x10(%ebp),%edx
8010532a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010532d:	89 cb                	mov    %ecx,%ebx
8010532f:	89 df                	mov    %ebx,%edi
80105331:	89 d1                	mov    %edx,%ecx
80105333:	fc                   	cld
80105334:	f3 ab                	rep stos %eax,%es:(%edi)
80105336:	89 ca                	mov    %ecx,%edx
80105338:	89 fb                	mov    %edi,%ebx
8010533a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010533d:	89 55 10             	mov    %edx,0x10(%ebp)
  return memmove(dst, src, n);
}

int
80105340:	90                   	nop
80105341:	5b                   	pop    %ebx
80105342:	5f                   	pop    %edi
80105343:	5d                   	pop    %ebp
80105344:	c3                   	ret

80105345 <memset>:
{
80105345:	55                   	push   %ebp
80105346:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105348:	8b 45 08             	mov    0x8(%ebp),%eax
8010534b:	83 e0 03             	and    $0x3,%eax
8010534e:	85 c0                	test   %eax,%eax
80105350:	75 43                	jne    80105395 <memset+0x50>
80105352:	8b 45 10             	mov    0x10(%ebp),%eax
80105355:	83 e0 03             	and    $0x3,%eax
80105358:	85 c0                	test   %eax,%eax
8010535a:	75 39                	jne    80105395 <memset+0x50>
    c &= 0xFF;
8010535c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105363:	8b 45 10             	mov    0x10(%ebp),%eax
80105366:	c1 e8 02             	shr    $0x2,%eax
80105369:	89 c1                	mov    %eax,%ecx
8010536b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536e:	c1 e0 18             	shl    $0x18,%eax
80105371:	89 c2                	mov    %eax,%edx
80105373:	8b 45 0c             	mov    0xc(%ebp),%eax
80105376:	c1 e0 10             	shl    $0x10,%eax
80105379:	09 c2                	or     %eax,%edx
8010537b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537e:	c1 e0 08             	shl    $0x8,%eax
80105381:	09 d0                	or     %edx,%eax
80105383:	0b 45 0c             	or     0xc(%ebp),%eax
80105386:	51                   	push   %ecx
80105387:	50                   	push   %eax
80105388:	ff 75 08             	push   0x8(%ebp)
8010538b:	e8 8f ff ff ff       	call   8010531f <stosl>
80105390:	83 c4 0c             	add    $0xc,%esp
80105393:	eb 12                	jmp    801053a7 <memset+0x62>
    stosb(dst, c, n);
80105395:	8b 45 10             	mov    0x10(%ebp),%eax
80105398:	50                   	push   %eax
80105399:	ff 75 0c             	push   0xc(%ebp)
8010539c:	ff 75 08             	push   0x8(%ebp)
8010539f:	e8 55 ff ff ff       	call   801052f9 <stosb>
801053a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
801053a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801053aa:	c9                   	leave
801053ab:	c3                   	ret

801053ac <memcmp>:
{
801053ac:	55                   	push   %ebp
801053ad:	89 e5                	mov    %esp,%ebp
801053af:	83 ec 10             	sub    $0x10,%esp
  s1 = v1;
801053b2:	8b 45 08             	mov    0x8(%ebp),%eax
801053b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801053b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801053be:	eb 2e                	jmp    801053ee <memcmp+0x42>
    if(*s1 != *s2)
801053c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053c3:	0f b6 10             	movzbl (%eax),%edx
801053c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053c9:	0f b6 00             	movzbl (%eax),%eax
801053cc:	38 c2                	cmp    %al,%dl
801053ce:	74 16                	je     801053e6 <memcmp+0x3a>
      return *s1 - *s2;
801053d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053d3:	0f b6 00             	movzbl (%eax),%eax
801053d6:	0f b6 d0             	movzbl %al,%edx
801053d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053dc:	0f b6 00             	movzbl (%eax),%eax
801053df:	0f b6 c0             	movzbl %al,%eax
801053e2:	29 c2                	sub    %eax,%edx
801053e4:	eb 1a                	jmp    80105400 <memcmp+0x54>
    s1++, s2++;
801053e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053ea:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801053ee:	8b 45 10             	mov    0x10(%ebp),%eax
801053f1:	8d 50 ff             	lea    -0x1(%eax),%edx
801053f4:	89 55 10             	mov    %edx,0x10(%ebp)
801053f7:	85 c0                	test   %eax,%eax
801053f9:	75 c5                	jne    801053c0 <memcmp+0x14>
  return 0;
801053fb:	ba 00 00 00 00       	mov    $0x0,%edx
}
80105400:	89 d0                	mov    %edx,%eax
80105402:	c9                   	leave
80105403:	c3                   	ret

80105404 <memmove>:
{
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 10             	sub    $0x10,%esp
  s = src;
8010540a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105410:	8b 45 08             	mov    0x8(%ebp),%eax
80105413:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105416:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105419:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010541c:	73 54                	jae    80105472 <memmove+0x6e>
8010541e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105421:	8b 45 10             	mov    0x10(%ebp),%eax
80105424:	01 d0                	add    %edx,%eax
80105426:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105429:	73 47                	jae    80105472 <memmove+0x6e>
    s += n;
8010542b:	8b 45 10             	mov    0x10(%ebp),%eax
8010542e:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105431:	8b 45 10             	mov    0x10(%ebp),%eax
80105434:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105437:	eb 13                	jmp    8010544c <memmove+0x48>
      *--d = *--s;
80105439:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010543d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105441:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105444:	0f b6 10             	movzbl (%eax),%edx
80105447:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010544a:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010544c:	8b 45 10             	mov    0x10(%ebp),%eax
8010544f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105452:	89 55 10             	mov    %edx,0x10(%ebp)
80105455:	85 c0                	test   %eax,%eax
80105457:	75 e0                	jne    80105439 <memmove+0x35>
  if(s < d && s + n > d){
80105459:	eb 24                	jmp    8010547f <memmove+0x7b>
      *d++ = *s++;
8010545b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010545e:	8d 42 01             	lea    0x1(%edx),%eax
80105461:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105464:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105467:	8d 48 01             	lea    0x1(%eax),%ecx
8010546a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010546d:	0f b6 12             	movzbl (%edx),%edx
80105470:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105472:	8b 45 10             	mov    0x10(%ebp),%eax
80105475:	8d 50 ff             	lea    -0x1(%eax),%edx
80105478:	89 55 10             	mov    %edx,0x10(%ebp)
8010547b:	85 c0                	test   %eax,%eax
8010547d:	75 dc                	jne    8010545b <memmove+0x57>
  return dst;
8010547f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105482:	c9                   	leave
80105483:	c3                   	ret

80105484 <memcpy>:
{
80105484:	55                   	push   %ebp
80105485:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105487:	ff 75 10             	push   0x10(%ebp)
8010548a:	ff 75 0c             	push   0xc(%ebp)
8010548d:	ff 75 08             	push   0x8(%ebp)
80105490:	e8 6f ff ff ff       	call   80105404 <memmove>
80105495:	83 c4 0c             	add    $0xc,%esp
}
80105498:	c9                   	leave
80105499:	c3                   	ret

8010549a <strncmp>:
strncmp(const char *p, const char *q, uint n)
{
8010549a:	55                   	push   %ebp
8010549b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010549d:	eb 0c                	jmp    801054ab <strncmp+0x11>
    n--, p++, q++;
8010549f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801054a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801054a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801054ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054af:	74 1a                	je     801054cb <strncmp+0x31>
801054b1:	8b 45 08             	mov    0x8(%ebp),%eax
801054b4:	0f b6 00             	movzbl (%eax),%eax
801054b7:	84 c0                	test   %al,%al
801054b9:	74 10                	je     801054cb <strncmp+0x31>
801054bb:	8b 45 08             	mov    0x8(%ebp),%eax
801054be:	0f b6 10             	movzbl (%eax),%edx
801054c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c4:	0f b6 00             	movzbl (%eax),%eax
801054c7:	38 c2                	cmp    %al,%dl
801054c9:	74 d4                	je     8010549f <strncmp+0x5>
  if(n == 0)
801054cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054cf:	75 07                	jne    801054d8 <strncmp+0x3e>
    return 0;
801054d1:	ba 00 00 00 00       	mov    $0x0,%edx
801054d6:	eb 14                	jmp    801054ec <strncmp+0x52>
  return (uchar)*p - (uchar)*q;
801054d8:	8b 45 08             	mov    0x8(%ebp),%eax
801054db:	0f b6 00             	movzbl (%eax),%eax
801054de:	0f b6 d0             	movzbl %al,%edx
801054e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e4:	0f b6 00             	movzbl (%eax),%eax
801054e7:	0f b6 c0             	movzbl %al,%eax
801054ea:	29 c2                	sub    %eax,%edx
}
801054ec:	89 d0                	mov    %edx,%eax
801054ee:	5d                   	pop    %ebp
801054ef:	c3                   	ret

801054f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801054f6:	8b 45 08             	mov    0x8(%ebp),%eax
801054f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054fc:	90                   	nop
801054fd:	8b 45 10             	mov    0x10(%ebp),%eax
80105500:	8d 50 ff             	lea    -0x1(%eax),%edx
80105503:	89 55 10             	mov    %edx,0x10(%ebp)
80105506:	85 c0                	test   %eax,%eax
80105508:	7e 2c                	jle    80105536 <strncpy+0x46>
8010550a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010550d:	8d 42 01             	lea    0x1(%edx),%eax
80105510:	89 45 0c             	mov    %eax,0xc(%ebp)
80105513:	8b 45 08             	mov    0x8(%ebp),%eax
80105516:	8d 48 01             	lea    0x1(%eax),%ecx
80105519:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010551c:	0f b6 12             	movzbl (%edx),%edx
8010551f:	88 10                	mov    %dl,(%eax)
80105521:	0f b6 00             	movzbl (%eax),%eax
80105524:	84 c0                	test   %al,%al
80105526:	75 d5                	jne    801054fd <strncpy+0xd>
    ;
  while(n-- > 0)
80105528:	eb 0c                	jmp    80105536 <strncpy+0x46>
    *s++ = 0;
8010552a:	8b 45 08             	mov    0x8(%ebp),%eax
8010552d:	8d 50 01             	lea    0x1(%eax),%edx
80105530:	89 55 08             	mov    %edx,0x8(%ebp)
80105533:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105536:	8b 45 10             	mov    0x10(%ebp),%eax
80105539:	8d 50 ff             	lea    -0x1(%eax),%edx
8010553c:	89 55 10             	mov    %edx,0x10(%ebp)
8010553f:	85 c0                	test   %eax,%eax
80105541:	7f e7                	jg     8010552a <strncpy+0x3a>
  return os;
80105543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105546:	c9                   	leave
80105547:	c3                   	ret

80105548 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105548:	55                   	push   %ebp
80105549:	89 e5                	mov    %esp,%ebp
8010554b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010554e:	8b 45 08             	mov    0x8(%ebp),%eax
80105551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105554:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105558:	7f 05                	jg     8010555f <safestrcpy+0x17>
    return os;
8010555a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555d:	eb 32                	jmp    80105591 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
8010555f:	90                   	nop
80105560:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105564:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105568:	7e 1e                	jle    80105588 <safestrcpy+0x40>
8010556a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010556d:	8d 42 01             	lea    0x1(%edx),%eax
80105570:	89 45 0c             	mov    %eax,0xc(%ebp)
80105573:	8b 45 08             	mov    0x8(%ebp),%eax
80105576:	8d 48 01             	lea    0x1(%eax),%ecx
80105579:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010557c:	0f b6 12             	movzbl (%edx),%edx
8010557f:	88 10                	mov    %dl,(%eax)
80105581:	0f b6 00             	movzbl (%eax),%eax
80105584:	84 c0                	test   %al,%al
80105586:	75 d8                	jne    80105560 <safestrcpy+0x18>
    ;
  *s = 0;
80105588:	8b 45 08             	mov    0x8(%ebp),%eax
8010558b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010558e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105591:	c9                   	leave
80105592:	c3                   	ret

80105593 <strlen>:

int
strlen(const char *s)
{
80105593:	55                   	push   %ebp
80105594:	89 e5                	mov    %esp,%ebp
80105596:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105599:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801055a0:	eb 04                	jmp    801055a6 <strlen+0x13>
801055a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055a9:	8b 45 08             	mov    0x8(%ebp),%eax
801055ac:	01 d0                	add    %edx,%eax
801055ae:	0f b6 00             	movzbl (%eax),%eax
801055b1:	84 c0                	test   %al,%al
801055b3:	75 ed                	jne    801055a2 <strlen+0xf>
    ;
  return n;
801055b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055b8:	c9                   	leave
801055b9:	c3                   	ret

801055ba <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801055ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801055be:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801055c2:	55                   	push   %ebp
  pushl %ebx
801055c3:	53                   	push   %ebx
  pushl %esi
801055c4:	56                   	push   %esi
  pushl %edi
801055c5:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801055c6:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801055c8:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801055ca:	5f                   	pop    %edi
  popl %esi
801055cb:	5e                   	pop    %esi
  popl %ebx
801055cc:	5b                   	pop    %ebx
  popl %ebp
801055cd:	5d                   	pop    %ebp
  ret
801055ce:	c3                   	ret

801055cf <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801055cf:	55                   	push   %ebp
801055d0:	89 e5                	mov    %esp,%ebp
801055d2:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801055d5:	e8 fb ed ff ff       	call   801043d5 <myproc>
801055da:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e0:	8b 00                	mov    (%eax),%eax
801055e2:	39 45 08             	cmp    %eax,0x8(%ebp)
801055e5:	73 0f                	jae    801055f6 <fetchint+0x27>
801055e7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ea:	8d 50 04             	lea    0x4(%eax),%edx
801055ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f0:	8b 00                	mov    (%eax),%eax
801055f2:	39 d0                	cmp    %edx,%eax
801055f4:	73 07                	jae    801055fd <fetchint+0x2e>
    return -1;
801055f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fb:	eb 0f                	jmp    8010560c <fetchint+0x3d>
  *ip = *(int*)(addr);
801055fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105600:	8b 10                	mov    (%eax),%edx
80105602:	8b 45 0c             	mov    0xc(%ebp),%eax
80105605:	89 10                	mov    %edx,(%eax)
  return 0;
80105607:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010560c:	c9                   	leave
8010560d:	c3                   	ret

8010560e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010560e:	55                   	push   %ebp
8010560f:	89 e5                	mov    %esp,%ebp
80105611:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105614:	e8 bc ed ff ff       	call   801043d5 <myproc>
80105619:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010561c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010561f:	8b 00                	mov    (%eax),%eax
80105621:	39 45 08             	cmp    %eax,0x8(%ebp)
80105624:	72 07                	jb     8010562d <fetchstr+0x1f>
    return -1;
80105626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562b:	eb 41                	jmp    8010566e <fetchstr+0x60>
  *pp = (char*)addr;
8010562d:	8b 55 08             	mov    0x8(%ebp),%edx
80105630:	8b 45 0c             	mov    0xc(%ebp),%eax
80105633:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105635:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105638:	8b 00                	mov    (%eax),%eax
8010563a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010563d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105640:	8b 00                	mov    (%eax),%eax
80105642:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105645:	eb 1a                	jmp    80105661 <fetchstr+0x53>
    if(*s == 0)
80105647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010564a:	0f b6 00             	movzbl (%eax),%eax
8010564d:	84 c0                	test   %al,%al
8010564f:	75 0c                	jne    8010565d <fetchstr+0x4f>
      return s - *pp;
80105651:	8b 45 0c             	mov    0xc(%ebp),%eax
80105654:	8b 10                	mov    (%eax),%edx
80105656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105659:	29 d0                	sub    %edx,%eax
8010565b:	eb 11                	jmp    8010566e <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
8010565d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105664:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105667:	72 de                	jb     80105647 <fetchstr+0x39>
  }
  return -1;
80105669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010566e:	c9                   	leave
8010566f:	c3                   	ret

80105670 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105676:	e8 5a ed ff ff       	call   801043d5 <myproc>
8010567b:	8b 40 18             	mov    0x18(%eax),%eax
8010567e:	8b 40 44             	mov    0x44(%eax),%eax
80105681:	8b 55 08             	mov    0x8(%ebp),%edx
80105684:	c1 e2 02             	shl    $0x2,%edx
80105687:	01 d0                	add    %edx,%eax
80105689:	83 c0 04             	add    $0x4,%eax
8010568c:	83 ec 08             	sub    $0x8,%esp
8010568f:	ff 75 0c             	push   0xc(%ebp)
80105692:	50                   	push   %eax
80105693:	e8 37 ff ff ff       	call   801055cf <fetchint>
80105698:	83 c4 10             	add    $0x10,%esp
}
8010569b:	c9                   	leave
8010569c:	c3                   	ret

8010569d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010569d:	55                   	push   %ebp
8010569e:	89 e5                	mov    %esp,%ebp
801056a0:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
801056a3:	e8 2d ed ff ff       	call   801043d5 <myproc>
801056a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801056ab:	83 ec 08             	sub    $0x8,%esp
801056ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b1:	50                   	push   %eax
801056b2:	ff 75 08             	push   0x8(%ebp)
801056b5:	e8 b6 ff ff ff       	call   80105670 <argint>
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	85 c0                	test   %eax,%eax
801056bf:	79 07                	jns    801056c8 <argptr+0x2b>
    return -1;
801056c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c6:	eb 3b                	jmp    80105703 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056cc:	78 1f                	js     801056ed <argptr+0x50>
801056ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d1:	8b 00                	mov    (%eax),%eax
801056d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056d6:	39 c2                	cmp    %eax,%edx
801056d8:	73 13                	jae    801056ed <argptr+0x50>
801056da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056dd:	89 c2                	mov    %eax,%edx
801056df:	8b 45 10             	mov    0x10(%ebp),%eax
801056e2:	01 c2                	add    %eax,%edx
801056e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e7:	8b 00                	mov    (%eax),%eax
801056e9:	39 d0                	cmp    %edx,%eax
801056eb:	73 07                	jae    801056f4 <argptr+0x57>
    return -1;
801056ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f2:	eb 0f                	jmp    80105703 <argptr+0x66>
  *pp = (char*)i;
801056f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f7:	89 c2                	mov    %eax,%edx
801056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fc:	89 10                	mov    %edx,(%eax)
  return 0;
801056fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105703:	c9                   	leave
80105704:	c3                   	ret

80105705 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105705:	55                   	push   %ebp
80105706:	89 e5                	mov    %esp,%ebp
80105708:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010570b:	83 ec 08             	sub    $0x8,%esp
8010570e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105711:	50                   	push   %eax
80105712:	ff 75 08             	push   0x8(%ebp)
80105715:	e8 56 ff ff ff       	call   80105670 <argint>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	79 07                	jns    80105728 <argstr+0x23>
    return -1;
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105726:	eb 12                	jmp    8010573a <argstr+0x35>
  return fetchstr(addr, pp);
80105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572b:	83 ec 08             	sub    $0x8,%esp
8010572e:	ff 75 0c             	push   0xc(%ebp)
80105731:	50                   	push   %eax
80105732:	e8 d7 fe ff ff       	call   8010560e <fetchstr>
80105737:	83 c4 10             	add    $0x10,%esp
}
8010573a:	c9                   	leave
8010573b:	c3                   	ret

8010573c <syscall>:
[SYS_getNumFreePages] sys_getNumFreePages,
};

void
syscall(void)
{
8010573c:	55                   	push   %ebp
8010573d:	89 e5                	mov    %esp,%ebp
8010573f:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105742:	e8 8e ec ff ff       	call   801043d5 <myproc>
80105747:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010574a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574d:	8b 40 18             	mov    0x18(%eax),%eax
80105750:	8b 40 1c             	mov    0x1c(%eax),%eax
80105753:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105756:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010575a:	7e 2f                	jle    8010578b <syscall+0x4f>
8010575c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575f:	83 f8 16             	cmp    $0x16,%eax
80105762:	77 27                	ja     8010578b <syscall+0x4f>
80105764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105767:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
8010576e:	85 c0                	test   %eax,%eax
80105770:	74 19                	je     8010578b <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105775:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
8010577c:	ff d0                	call   *%eax
8010577e:	89 c2                	mov    %eax,%edx
80105780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105783:	8b 40 18             	mov    0x18(%eax),%eax
80105786:	89 50 1c             	mov    %edx,0x1c(%eax)
80105789:	eb 2c                	jmp    801057b7 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010578b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010578e:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105794:	8b 40 10             	mov    0x10(%eax),%eax
80105797:	ff 75 f0             	push   -0x10(%ebp)
8010579a:	52                   	push   %edx
8010579b:	50                   	push   %eax
8010579c:	68 f8 8a 10 80       	push   $0x80108af8
801057a1:	e8 58 ac ff ff       	call   801003fe <cprintf>
801057a6:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
801057a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ac:	8b 40 18             	mov    0x18(%eax),%eax
801057af:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801057b6:	90                   	nop
801057b7:	90                   	nop
801057b8:	c9                   	leave
801057b9:	c3                   	ret

801057ba <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801057ba:	55                   	push   %ebp
801057bb:	89 e5                	mov    %esp,%ebp
801057bd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c6:	50                   	push   %eax
801057c7:	ff 75 08             	push   0x8(%ebp)
801057ca:	e8 a1 fe ff ff       	call   80105670 <argint>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	79 07                	jns    801057dd <argfd+0x23>
    return -1;
801057d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057db:	eb 4f                	jmp    8010582c <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 20                	js     80105804 <argfd+0x4a>
801057e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e7:	83 f8 0f             	cmp    $0xf,%eax
801057ea:	7f 18                	jg     80105804 <argfd+0x4a>
801057ec:	e8 e4 eb ff ff       	call   801043d5 <myproc>
801057f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057f4:	83 c2 08             	add    $0x8,%edx
801057f7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105802:	75 07                	jne    8010580b <argfd+0x51>
    return -1;
80105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105809:	eb 21                	jmp    8010582c <argfd+0x72>
  if(pfd)
8010580b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010580f:	74 08                	je     80105819 <argfd+0x5f>
    *pfd = fd;
80105811:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105814:	8b 45 0c             	mov    0xc(%ebp),%eax
80105817:	89 10                	mov    %edx,(%eax)
  if(pf)
80105819:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010581d:	74 08                	je     80105827 <argfd+0x6d>
    *pf = f;
8010581f:	8b 45 10             	mov    0x10(%ebp),%eax
80105822:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105825:	89 10                	mov    %edx,(%eax)
  return 0;
80105827:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010582c:	c9                   	leave
8010582d:	c3                   	ret

8010582e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010582e:	55                   	push   %ebp
8010582f:	89 e5                	mov    %esp,%ebp
80105831:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105834:	e8 9c eb ff ff       	call   801043d5 <myproc>
80105839:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010583c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105843:	eb 2a                	jmp    8010586f <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105845:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105848:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010584b:	83 c2 08             	add    $0x8,%edx
8010584e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105852:	85 c0                	test   %eax,%eax
80105854:	75 15                	jne    8010586b <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105859:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010585c:	8d 4a 08             	lea    0x8(%edx),%ecx
8010585f:	8b 55 08             	mov    0x8(%ebp),%edx
80105862:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105869:	eb 0f                	jmp    8010587a <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
8010586b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010586f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105873:	7e d0                	jle    80105845 <fdalloc+0x17>
    }
  }
  return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587a:	c9                   	leave
8010587b:	c3                   	ret

8010587c <sys_dup>:

int
sys_dup(void)
{
8010587c:	55                   	push   %ebp
8010587d:	89 e5                	mov    %esp,%ebp
8010587f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105882:	83 ec 04             	sub    $0x4,%esp
80105885:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105888:	50                   	push   %eax
80105889:	6a 00                	push   $0x0
8010588b:	6a 00                	push   $0x0
8010588d:	e8 28 ff ff ff       	call   801057ba <argfd>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	79 07                	jns    801058a0 <sys_dup+0x24>
    return -1;
80105899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589e:	eb 31                	jmp    801058d1 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801058a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a3:	83 ec 0c             	sub    $0xc,%esp
801058a6:	50                   	push   %eax
801058a7:	e8 82 ff ff ff       	call   8010582e <fdalloc>
801058ac:	83 c4 10             	add    $0x10,%esp
801058af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058b6:	79 07                	jns    801058bf <sys_dup+0x43>
    return -1;
801058b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bd:	eb 12                	jmp    801058d1 <sys_dup+0x55>
  filedup(f);
801058bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c2:	83 ec 0c             	sub    $0xc,%esp
801058c5:	50                   	push   %eax
801058c6:	e8 c6 b7 ff ff       	call   80101091 <filedup>
801058cb:	83 c4 10             	add    $0x10,%esp
  return fd;
801058ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801058d1:	c9                   	leave
801058d2:	c3                   	ret

801058d3 <sys_read>:

int
sys_read(void)
{
801058d3:	55                   	push   %ebp
801058d4:	89 e5                	mov    %esp,%ebp
801058d6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058d9:	83 ec 04             	sub    $0x4,%esp
801058dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058df:	50                   	push   %eax
801058e0:	6a 00                	push   $0x0
801058e2:	6a 00                	push   $0x0
801058e4:	e8 d1 fe ff ff       	call   801057ba <argfd>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	85 c0                	test   %eax,%eax
801058ee:	78 2e                	js     8010591e <sys_read+0x4b>
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058f6:	50                   	push   %eax
801058f7:	6a 02                	push   $0x2
801058f9:	e8 72 fd ff ff       	call   80105670 <argint>
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	85 c0                	test   %eax,%eax
80105903:	78 19                	js     8010591e <sys_read+0x4b>
80105905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105908:	83 ec 04             	sub    $0x4,%esp
8010590b:	50                   	push   %eax
8010590c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010590f:	50                   	push   %eax
80105910:	6a 01                	push   $0x1
80105912:	e8 86 fd ff ff       	call   8010569d <argptr>
80105917:	83 c4 10             	add    $0x10,%esp
8010591a:	85 c0                	test   %eax,%eax
8010591c:	79 07                	jns    80105925 <sys_read+0x52>
    return -1;
8010591e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105923:	eb 17                	jmp    8010593c <sys_read+0x69>
  return fileread(f, p, n);
80105925:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105928:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010592b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592e:	83 ec 04             	sub    $0x4,%esp
80105931:	51                   	push   %ecx
80105932:	52                   	push   %edx
80105933:	50                   	push   %eax
80105934:	e8 e8 b8 ff ff       	call   80101221 <fileread>
80105939:	83 c4 10             	add    $0x10,%esp
}
8010593c:	c9                   	leave
8010593d:	c3                   	ret

8010593e <sys_write>:

int
sys_write(void)
{
8010593e:	55                   	push   %ebp
8010593f:	89 e5                	mov    %esp,%ebp
80105941:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105944:	83 ec 04             	sub    $0x4,%esp
80105947:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	6a 00                	push   $0x0
8010594f:	e8 66 fe ff ff       	call   801057ba <argfd>
80105954:	83 c4 10             	add    $0x10,%esp
80105957:	85 c0                	test   %eax,%eax
80105959:	78 2e                	js     80105989 <sys_write+0x4b>
8010595b:	83 ec 08             	sub    $0x8,%esp
8010595e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105961:	50                   	push   %eax
80105962:	6a 02                	push   $0x2
80105964:	e8 07 fd ff ff       	call   80105670 <argint>
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	85 c0                	test   %eax,%eax
8010596e:	78 19                	js     80105989 <sys_write+0x4b>
80105970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105973:	83 ec 04             	sub    $0x4,%esp
80105976:	50                   	push   %eax
80105977:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010597a:	50                   	push   %eax
8010597b:	6a 01                	push   $0x1
8010597d:	e8 1b fd ff ff       	call   8010569d <argptr>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	79 07                	jns    80105990 <sys_write+0x52>
    return -1;
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	eb 17                	jmp    801059a7 <sys_write+0x69>
  return filewrite(f, p, n);
80105990:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105993:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105999:	83 ec 04             	sub    $0x4,%esp
8010599c:	51                   	push   %ecx
8010599d:	52                   	push   %edx
8010599e:	50                   	push   %eax
8010599f:	e8 35 b9 ff ff       	call   801012d9 <filewrite>
801059a4:	83 c4 10             	add    $0x10,%esp
}
801059a7:	c9                   	leave
801059a8:	c3                   	ret

801059a9 <sys_close>:

int
sys_close(void)
{
801059a9:	55                   	push   %ebp
801059aa:	89 e5                	mov    %esp,%ebp
801059ac:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801059af:	83 ec 04             	sub    $0x4,%esp
801059b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059b5:	50                   	push   %eax
801059b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b9:	50                   	push   %eax
801059ba:	6a 00                	push   $0x0
801059bc:	e8 f9 fd ff ff       	call   801057ba <argfd>
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	85 c0                	test   %eax,%eax
801059c6:	79 07                	jns    801059cf <sys_close+0x26>
    return -1;
801059c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cd:	eb 27                	jmp    801059f6 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801059cf:	e8 01 ea ff ff       	call   801043d5 <myproc>
801059d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d7:	83 c2 08             	add    $0x8,%edx
801059da:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059e1:	00 
  fileclose(f);
801059e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e5:	83 ec 0c             	sub    $0xc,%esp
801059e8:	50                   	push   %eax
801059e9:	e8 f4 b6 ff ff       	call   801010e2 <fileclose>
801059ee:	83 c4 10             	add    $0x10,%esp
  return 0;
801059f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059f6:	c9                   	leave
801059f7:	c3                   	ret

801059f8 <sys_fstat>:

int
sys_fstat(void)
{
801059f8:	55                   	push   %ebp
801059f9:	89 e5                	mov    %esp,%ebp
801059fb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059fe:	83 ec 04             	sub    $0x4,%esp
80105a01:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a04:	50                   	push   %eax
80105a05:	6a 00                	push   $0x0
80105a07:	6a 00                	push   $0x0
80105a09:	e8 ac fd ff ff       	call   801057ba <argfd>
80105a0e:	83 c4 10             	add    $0x10,%esp
80105a11:	85 c0                	test   %eax,%eax
80105a13:	78 17                	js     80105a2c <sys_fstat+0x34>
80105a15:	83 ec 04             	sub    $0x4,%esp
80105a18:	6a 14                	push   $0x14
80105a1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a1d:	50                   	push   %eax
80105a1e:	6a 01                	push   $0x1
80105a20:	e8 78 fc ff ff       	call   8010569d <argptr>
80105a25:	83 c4 10             	add    $0x10,%esp
80105a28:	85 c0                	test   %eax,%eax
80105a2a:	79 07                	jns    80105a33 <sys_fstat+0x3b>
    return -1;
80105a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a31:	eb 13                	jmp    80105a46 <sys_fstat+0x4e>
  return filestat(f, st);
80105a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a39:	83 ec 08             	sub    $0x8,%esp
80105a3c:	52                   	push   %edx
80105a3d:	50                   	push   %eax
80105a3e:	e8 87 b7 ff ff       	call   801011ca <filestat>
80105a43:	83 c4 10             	add    $0x10,%esp
}
80105a46:	c9                   	leave
80105a47:	c3                   	ret

80105a48 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a48:	55                   	push   %ebp
80105a49:	89 e5                	mov    %esp,%ebp
80105a4b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a4e:	83 ec 08             	sub    $0x8,%esp
80105a51:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a54:	50                   	push   %eax
80105a55:	6a 00                	push   $0x0
80105a57:	e8 a9 fc ff ff       	call   80105705 <argstr>
80105a5c:	83 c4 10             	add    $0x10,%esp
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	78 15                	js     80105a78 <sys_link+0x30>
80105a63:	83 ec 08             	sub    $0x8,%esp
80105a66:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a69:	50                   	push   %eax
80105a6a:	6a 01                	push   $0x1
80105a6c:	e8 94 fc ff ff       	call   80105705 <argstr>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	79 0a                	jns    80105a82 <sys_link+0x3a>
    return -1;
80105a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7d:	e9 68 01 00 00       	jmp    80105bea <sys_link+0x1a2>

  begin_op();
80105a82:	e8 eb db ff ff       	call   80103672 <begin_op>
  if((ip = namei(old)) == 0){
80105a87:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	50                   	push   %eax
80105a8e:	e8 bc ca ff ff       	call   8010254f <namei>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a9d:	75 0f                	jne    80105aae <sys_link+0x66>
    end_op();
80105a9f:	e8 5a dc ff ff       	call   801036fe <end_op>
    return -1;
80105aa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa9:	e9 3c 01 00 00       	jmp    80105bea <sys_link+0x1a2>
  }

  ilock(ip);
80105aae:	83 ec 0c             	sub    $0xc,%esp
80105ab1:	ff 75 f4             	push   -0xc(%ebp)
80105ab4:	e8 63 bf ff ff       	call   80101a1c <ilock>
80105ab9:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ac3:	66 83 f8 01          	cmp    $0x1,%ax
80105ac7:	75 1d                	jne    80105ae6 <sys_link+0x9e>
    iunlockput(ip);
80105ac9:	83 ec 0c             	sub    $0xc,%esp
80105acc:	ff 75 f4             	push   -0xc(%ebp)
80105acf:	e8 79 c1 ff ff       	call   80101c4d <iunlockput>
80105ad4:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ad7:	e8 22 dc ff ff       	call   801036fe <end_op>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae1:	e9 04 01 00 00       	jmp    80105bea <sys_link+0x1a2>
  }

  ip->nlink++;
80105ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae9:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105aed:	83 c0 01             	add    $0x1,%eax
80105af0:	89 c2                	mov    %eax,%edx
80105af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af5:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	ff 75 f4             	push   -0xc(%ebp)
80105aff:	e8 3b bd ff ff       	call   8010183f <iupdate>
80105b04:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105b07:	83 ec 0c             	sub    $0xc,%esp
80105b0a:	ff 75 f4             	push   -0xc(%ebp)
80105b0d:	e8 1d c0 ff ff       	call   80101b2f <iunlock>
80105b12:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105b15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b18:	83 ec 08             	sub    $0x8,%esp
80105b1b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b1e:	52                   	push   %edx
80105b1f:	50                   	push   %eax
80105b20:	e8 46 ca ff ff       	call   8010256b <nameiparent>
80105b25:	83 c4 10             	add    $0x10,%esp
80105b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b2f:	74 71                	je     80105ba2 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	ff 75 f0             	push   -0x10(%ebp)
80105b37:	e8 e0 be ff ff       	call   80101a1c <ilock>
80105b3c:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b42:	8b 10                	mov    (%eax),%edx
80105b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b47:	8b 00                	mov    (%eax),%eax
80105b49:	39 c2                	cmp    %eax,%edx
80105b4b:	75 1d                	jne    80105b6a <sys_link+0x122>
80105b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b50:	8b 40 04             	mov    0x4(%eax),%eax
80105b53:	83 ec 04             	sub    $0x4,%esp
80105b56:	50                   	push   %eax
80105b57:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b5a:	50                   	push   %eax
80105b5b:	ff 75 f0             	push   -0x10(%ebp)
80105b5e:	e8 55 c7 ff ff       	call   801022b8 <dirlink>
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	79 10                	jns    80105b7a <sys_link+0x132>
    iunlockput(dp);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	ff 75 f0             	push   -0x10(%ebp)
80105b70:	e8 d8 c0 ff ff       	call   80101c4d <iunlockput>
80105b75:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105b78:	eb 29                	jmp    80105ba3 <sys_link+0x15b>
  }
  iunlockput(dp);
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	ff 75 f0             	push   -0x10(%ebp)
80105b80:	e8 c8 c0 ff ff       	call   80101c4d <iunlockput>
80105b85:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 f4             	push   -0xc(%ebp)
80105b8e:	e8 ea bf ff ff       	call   80101b7d <iput>
80105b93:	83 c4 10             	add    $0x10,%esp

  end_op();
80105b96:	e8 63 db ff ff       	call   801036fe <end_op>

  return 0;
80105b9b:	b8 00 00 00 00       	mov    $0x0,%eax
80105ba0:	eb 48                	jmp    80105bea <sys_link+0x1a2>
    goto bad;
80105ba2:	90                   	nop

bad:
  ilock(ip);
80105ba3:	83 ec 0c             	sub    $0xc,%esp
80105ba6:	ff 75 f4             	push   -0xc(%ebp)
80105ba9:	e8 6e be ff ff       	call   80101a1c <ilock>
80105bae:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105bb8:	83 e8 01             	sub    $0x1,%eax
80105bbb:	89 c2                	mov    %eax,%edx
80105bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc0:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	ff 75 f4             	push   -0xc(%ebp)
80105bca:	e8 70 bc ff ff       	call   8010183f <iupdate>
80105bcf:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	ff 75 f4             	push   -0xc(%ebp)
80105bd8:	e8 70 c0 ff ff       	call   80101c4d <iunlockput>
80105bdd:	83 c4 10             	add    $0x10,%esp
  end_op();
80105be0:	e8 19 db ff ff       	call   801036fe <end_op>
  return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bea:	c9                   	leave
80105beb:	c3                   	ret

80105bec <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bec:	55                   	push   %ebp
80105bed:	89 e5                	mov    %esp,%ebp
80105bef:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bf2:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bf9:	eb 40                	jmp    80105c3b <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfe:	6a 10                	push   $0x10
80105c00:	50                   	push   %eax
80105c01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c04:	50                   	push   %eax
80105c05:	ff 75 08             	push   0x8(%ebp)
80105c08:	e8 fb c2 ff ff       	call   80101f08 <readi>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	83 f8 10             	cmp    $0x10,%eax
80105c13:	74 0d                	je     80105c22 <isdirempty+0x36>
      panic("isdirempty: readi");
80105c15:	83 ec 0c             	sub    $0xc,%esp
80105c18:	68 14 8b 10 80       	push   $0x80108b14
80105c1d:	e8 91 a9 ff ff       	call   801005b3 <panic>
    if(de.inum != 0)
80105c22:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c26:	66 85 c0             	test   %ax,%ax
80105c29:	74 07                	je     80105c32 <isdirempty+0x46>
      return 0;
80105c2b:	b8 00 00 00 00       	mov    $0x0,%eax
80105c30:	eb 1b                	jmp    80105c4d <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c35:	83 c0 10             	add    $0x10,%eax
80105c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c3e:	8b 40 58             	mov    0x58(%eax),%eax
80105c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c44:	39 c2                	cmp    %eax,%edx
80105c46:	72 b3                	jb     80105bfb <isdirempty+0xf>
  }
  return 1;
80105c48:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c4d:	c9                   	leave
80105c4e:	c3                   	ret

80105c4f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c4f:	55                   	push   %ebp
80105c50:	89 e5                	mov    %esp,%ebp
80105c52:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c5b:	50                   	push   %eax
80105c5c:	6a 00                	push   $0x0
80105c5e:	e8 a2 fa ff ff       	call   80105705 <argstr>
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	79 0a                	jns    80105c74 <sys_unlink+0x25>
    return -1;
80105c6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6f:	e9 bf 01 00 00       	jmp    80105e33 <sys_unlink+0x1e4>

  begin_op();
80105c74:	e8 f9 d9 ff ff       	call   80103672 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c79:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c7c:	83 ec 08             	sub    $0x8,%esp
80105c7f:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c82:	52                   	push   %edx
80105c83:	50                   	push   %eax
80105c84:	e8 e2 c8 ff ff       	call   8010256b <nameiparent>
80105c89:	83 c4 10             	add    $0x10,%esp
80105c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c93:	75 0f                	jne    80105ca4 <sys_unlink+0x55>
    end_op();
80105c95:	e8 64 da ff ff       	call   801036fe <end_op>
    return -1;
80105c9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9f:	e9 8f 01 00 00       	jmp    80105e33 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105ca4:	83 ec 0c             	sub    $0xc,%esp
80105ca7:	ff 75 f4             	push   -0xc(%ebp)
80105caa:	e8 6d bd ff ff       	call   80101a1c <ilock>
80105caf:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105cb2:	83 ec 08             	sub    $0x8,%esp
80105cb5:	68 26 8b 10 80       	push   $0x80108b26
80105cba:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cbd:	50                   	push   %eax
80105cbe:	e8 20 c5 ff ff       	call   801021e3 <namecmp>
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	0f 84 49 01 00 00    	je     80105e17 <sys_unlink+0x1c8>
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	68 28 8b 10 80       	push   $0x80108b28
80105cd6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	e8 04 c5 ff ff       	call   801021e3 <namecmp>
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	85 c0                	test   %eax,%eax
80105ce4:	0f 84 2d 01 00 00    	je     80105e17 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105cea:	83 ec 04             	sub    $0x4,%esp
80105ced:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cf0:	50                   	push   %eax
80105cf1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cf4:	50                   	push   %eax
80105cf5:	ff 75 f4             	push   -0xc(%ebp)
80105cf8:	e8 01 c5 ff ff       	call   801021fe <dirlookup>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d07:	0f 84 0d 01 00 00    	je     80105e1a <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	ff 75 f0             	push   -0x10(%ebp)
80105d13:	e8 04 bd ff ff       	call   80101a1c <ilock>
80105d18:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d22:	66 85 c0             	test   %ax,%ax
80105d25:	7f 0d                	jg     80105d34 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105d27:	83 ec 0c             	sub    $0xc,%esp
80105d2a:	68 2b 8b 10 80       	push   $0x80108b2b
80105d2f:	e8 7f a8 ff ff       	call   801005b3 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d37:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d3b:	66 83 f8 01          	cmp    $0x1,%ax
80105d3f:	75 25                	jne    80105d66 <sys_unlink+0x117>
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	ff 75 f0             	push   -0x10(%ebp)
80105d47:	e8 a0 fe ff ff       	call   80105bec <isdirempty>
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	75 13                	jne    80105d66 <sys_unlink+0x117>
    iunlockput(ip);
80105d53:	83 ec 0c             	sub    $0xc,%esp
80105d56:	ff 75 f0             	push   -0x10(%ebp)
80105d59:	e8 ef be ff ff       	call   80101c4d <iunlockput>
80105d5e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d61:	e9 b5 00 00 00       	jmp    80105e1b <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105d66:	83 ec 04             	sub    $0x4,%esp
80105d69:	6a 10                	push   $0x10
80105d6b:	6a 00                	push   $0x0
80105d6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d70:	50                   	push   %eax
80105d71:	e8 cf f5 ff ff       	call   80105345 <memset>
80105d76:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d79:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d7c:	6a 10                	push   $0x10
80105d7e:	50                   	push   %eax
80105d7f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d82:	50                   	push   %eax
80105d83:	ff 75 f4             	push   -0xc(%ebp)
80105d86:	e8 d2 c2 ff ff       	call   8010205d <writei>
80105d8b:	83 c4 10             	add    $0x10,%esp
80105d8e:	83 f8 10             	cmp    $0x10,%eax
80105d91:	74 0d                	je     80105da0 <sys_unlink+0x151>
    panic("unlink: writei");
80105d93:	83 ec 0c             	sub    $0xc,%esp
80105d96:	68 3d 8b 10 80       	push   $0x80108b3d
80105d9b:	e8 13 a8 ff ff       	call   801005b3 <panic>
  if(ip->type == T_DIR){
80105da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105da7:	66 83 f8 01          	cmp    $0x1,%ax
80105dab:	75 21                	jne    80105dce <sys_unlink+0x17f>
    dp->nlink--;
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105db4:	83 e8 01             	sub    $0x1,%eax
80105db7:	89 c2                	mov    %eax,%edx
80105db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbc:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	ff 75 f4             	push   -0xc(%ebp)
80105dc6:	e8 74 ba ff ff       	call   8010183f <iupdate>
80105dcb:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105dce:	83 ec 0c             	sub    $0xc,%esp
80105dd1:	ff 75 f4             	push   -0xc(%ebp)
80105dd4:	e8 74 be ff ff       	call   80101c4d <iunlockput>
80105dd9:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105de3:	83 e8 01             	sub    $0x1,%eax
80105de6:	89 c2                	mov    %eax,%edx
80105de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105deb:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105def:	83 ec 0c             	sub    $0xc,%esp
80105df2:	ff 75 f0             	push   -0x10(%ebp)
80105df5:	e8 45 ba ff ff       	call   8010183f <iupdate>
80105dfa:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	ff 75 f0             	push   -0x10(%ebp)
80105e03:	e8 45 be ff ff       	call   80101c4d <iunlockput>
80105e08:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e0b:	e8 ee d8 ff ff       	call   801036fe <end_op>

  return 0;
80105e10:	b8 00 00 00 00       	mov    $0x0,%eax
80105e15:	eb 1c                	jmp    80105e33 <sys_unlink+0x1e4>
    goto bad;
80105e17:	90                   	nop
80105e18:	eb 01                	jmp    80105e1b <sys_unlink+0x1cc>
    goto bad;
80105e1a:	90                   	nop

bad:
  iunlockput(dp);
80105e1b:	83 ec 0c             	sub    $0xc,%esp
80105e1e:	ff 75 f4             	push   -0xc(%ebp)
80105e21:	e8 27 be ff ff       	call   80101c4d <iunlockput>
80105e26:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e29:	e8 d0 d8 ff ff       	call   801036fe <end_op>
  return -1;
80105e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e33:	c9                   	leave
80105e34:	c3                   	ret

80105e35 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e35:	55                   	push   %ebp
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 38             	sub    $0x38,%esp
80105e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e3e:	8b 55 10             	mov    0x10(%ebp),%edx
80105e41:	8b 45 14             	mov    0x14(%ebp),%eax
80105e44:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e48:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e4c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e56:	50                   	push   %eax
80105e57:	ff 75 08             	push   0x8(%ebp)
80105e5a:	e8 0c c7 ff ff       	call   8010256b <nameiparent>
80105e5f:	83 c4 10             	add    $0x10,%esp
80105e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e69:	75 0a                	jne    80105e75 <create+0x40>
    return 0;
80105e6b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e70:	e9 8e 01 00 00       	jmp    80106003 <create+0x1ce>
  ilock(dp);
80105e75:	83 ec 0c             	sub    $0xc,%esp
80105e78:	ff 75 f4             	push   -0xc(%ebp)
80105e7b:	e8 9c bb ff ff       	call   80101a1c <ilock>
80105e80:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
80105e83:	83 ec 04             	sub    $0x4,%esp
80105e86:	6a 00                	push   $0x0
80105e88:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e8b:	50                   	push   %eax
80105e8c:	ff 75 f4             	push   -0xc(%ebp)
80105e8f:	e8 6a c3 ff ff       	call   801021fe <dirlookup>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e9e:	74 50                	je     80105ef0 <create+0xbb>
    iunlockput(dp);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	ff 75 f4             	push   -0xc(%ebp)
80105ea6:	e8 a2 bd ff ff       	call   80101c4d <iunlockput>
80105eab:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	ff 75 f0             	push   -0x10(%ebp)
80105eb4:	e8 63 bb ff ff       	call   80101a1c <ilock>
80105eb9:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105ebc:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ec1:	75 15                	jne    80105ed8 <create+0xa3>
80105ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec6:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105eca:	66 83 f8 02          	cmp    $0x2,%ax
80105ece:	75 08                	jne    80105ed8 <create+0xa3>
      return ip;
80105ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed3:	e9 2b 01 00 00       	jmp    80106003 <create+0x1ce>
    iunlockput(ip);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
80105edb:	ff 75 f0             	push   -0x10(%ebp)
80105ede:	e8 6a bd ff ff       	call   80101c4d <iunlockput>
80105ee3:	83 c4 10             	add    $0x10,%esp
    return 0;
80105ee6:	b8 00 00 00 00       	mov    $0x0,%eax
80105eeb:	e9 13 01 00 00       	jmp    80106003 <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ef0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef7:	8b 00                	mov    (%eax),%eax
80105ef9:	83 ec 08             	sub    $0x8,%esp
80105efc:	52                   	push   %edx
80105efd:	50                   	push   %eax
80105efe:	e8 66 b8 ff ff       	call   80101769 <ialloc>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f0d:	75 0d                	jne    80105f1c <create+0xe7>
    panic("create: ialloc");
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	68 4c 8b 10 80       	push   $0x80108b4c
80105f17:	e8 97 a6 ff ff       	call   801005b3 <panic>

  ilock(ip);
80105f1c:	83 ec 0c             	sub    $0xc,%esp
80105f1f:	ff 75 f0             	push   -0x10(%ebp)
80105f22:	e8 f5 ba ff ff       	call   80101a1c <ilock>
80105f27:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2d:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f31:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f38:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f3c:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f43:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105f49:	83 ec 0c             	sub    $0xc,%esp
80105f4c:	ff 75 f0             	push   -0x10(%ebp)
80105f4f:	e8 eb b8 ff ff       	call   8010183f <iupdate>
80105f54:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f57:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f5c:	75 6a                	jne    80105fc8 <create+0x193>
    dp->nlink++;  // for ".."
80105f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f61:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f65:	83 c0 01             	add    $0x1,%eax
80105f68:	89 c2                	mov    %eax,%edx
80105f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105f71:	83 ec 0c             	sub    $0xc,%esp
80105f74:	ff 75 f4             	push   -0xc(%ebp)
80105f77:	e8 c3 b8 ff ff       	call   8010183f <iupdate>
80105f7c:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f82:	8b 40 04             	mov    0x4(%eax),%eax
80105f85:	83 ec 04             	sub    $0x4,%esp
80105f88:	50                   	push   %eax
80105f89:	68 26 8b 10 80       	push   $0x80108b26
80105f8e:	ff 75 f0             	push   -0x10(%ebp)
80105f91:	e8 22 c3 ff ff       	call   801022b8 <dirlink>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	78 1e                	js     80105fbb <create+0x186>
80105f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa0:	8b 40 04             	mov    0x4(%eax),%eax
80105fa3:	83 ec 04             	sub    $0x4,%esp
80105fa6:	50                   	push   %eax
80105fa7:	68 28 8b 10 80       	push   $0x80108b28
80105fac:	ff 75 f0             	push   -0x10(%ebp)
80105faf:	e8 04 c3 ff ff       	call   801022b8 <dirlink>
80105fb4:	83 c4 10             	add    $0x10,%esp
80105fb7:	85 c0                	test   %eax,%eax
80105fb9:	79 0d                	jns    80105fc8 <create+0x193>
      panic("create dots");
80105fbb:	83 ec 0c             	sub    $0xc,%esp
80105fbe:	68 5b 8b 10 80       	push   $0x80108b5b
80105fc3:	e8 eb a5 ff ff       	call   801005b3 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fcb:	8b 40 04             	mov    0x4(%eax),%eax
80105fce:	83 ec 04             	sub    $0x4,%esp
80105fd1:	50                   	push   %eax
80105fd2:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fd5:	50                   	push   %eax
80105fd6:	ff 75 f4             	push   -0xc(%ebp)
80105fd9:	e8 da c2 ff ff       	call   801022b8 <dirlink>
80105fde:	83 c4 10             	add    $0x10,%esp
80105fe1:	85 c0                	test   %eax,%eax
80105fe3:	79 0d                	jns    80105ff2 <create+0x1bd>
    panic("create: dirlink");
80105fe5:	83 ec 0c             	sub    $0xc,%esp
80105fe8:	68 67 8b 10 80       	push   $0x80108b67
80105fed:	e8 c1 a5 ff ff       	call   801005b3 <panic>

  iunlockput(dp);
80105ff2:	83 ec 0c             	sub    $0xc,%esp
80105ff5:	ff 75 f4             	push   -0xc(%ebp)
80105ff8:	e8 50 bc ff ff       	call   80101c4d <iunlockput>
80105ffd:	83 c4 10             	add    $0x10,%esp

  return ip;
80106000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106003:	c9                   	leave
80106004:	c3                   	ret

80106005 <sys_open>:

int
sys_open(void)
{
80106005:	55                   	push   %ebp
80106006:	89 e5                	mov    %esp,%ebp
80106008:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010600b:	83 ec 08             	sub    $0x8,%esp
8010600e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106011:	50                   	push   %eax
80106012:	6a 00                	push   $0x0
80106014:	e8 ec f6 ff ff       	call   80105705 <argstr>
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	85 c0                	test   %eax,%eax
8010601e:	78 15                	js     80106035 <sys_open+0x30>
80106020:	83 ec 08             	sub    $0x8,%esp
80106023:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106026:	50                   	push   %eax
80106027:	6a 01                	push   $0x1
80106029:	e8 42 f6 ff ff       	call   80105670 <argint>
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	85 c0                	test   %eax,%eax
80106033:	79 0a                	jns    8010603f <sys_open+0x3a>
    return -1;
80106035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603a:	e9 61 01 00 00       	jmp    801061a0 <sys_open+0x19b>

  begin_op();
8010603f:	e8 2e d6 ff ff       	call   80103672 <begin_op>

  if(omode & O_CREATE){
80106044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106047:	25 00 02 00 00       	and    $0x200,%eax
8010604c:	85 c0                	test   %eax,%eax
8010604e:	74 2a                	je     8010607a <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106050:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106053:	6a 00                	push   $0x0
80106055:	6a 00                	push   $0x0
80106057:	6a 02                	push   $0x2
80106059:	50                   	push   %eax
8010605a:	e8 d6 fd ff ff       	call   80105e35 <create>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106069:	75 75                	jne    801060e0 <sys_open+0xdb>
      end_op();
8010606b:	e8 8e d6 ff ff       	call   801036fe <end_op>
      return -1;
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106075:	e9 26 01 00 00       	jmp    801061a0 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010607a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	50                   	push   %eax
80106081:	e8 c9 c4 ff ff       	call   8010254f <namei>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010608c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106090:	75 0f                	jne    801060a1 <sys_open+0x9c>
      end_op();
80106092:	e8 67 d6 ff ff       	call   801036fe <end_op>
      return -1;
80106097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609c:	e9 ff 00 00 00       	jmp    801061a0 <sys_open+0x19b>
    }
    ilock(ip);
801060a1:	83 ec 0c             	sub    $0xc,%esp
801060a4:	ff 75 f4             	push   -0xc(%ebp)
801060a7:	e8 70 b9 ff ff       	call   80101a1c <ilock>
801060ac:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801060af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b2:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801060b6:	66 83 f8 01          	cmp    $0x1,%ax
801060ba:	75 24                	jne    801060e0 <sys_open+0xdb>
801060bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060bf:	85 c0                	test   %eax,%eax
801060c1:	74 1d                	je     801060e0 <sys_open+0xdb>
      iunlockput(ip);
801060c3:	83 ec 0c             	sub    $0xc,%esp
801060c6:	ff 75 f4             	push   -0xc(%ebp)
801060c9:	e8 7f bb ff ff       	call   80101c4d <iunlockput>
801060ce:	83 c4 10             	add    $0x10,%esp
      end_op();
801060d1:	e8 28 d6 ff ff       	call   801036fe <end_op>
      return -1;
801060d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060db:	e9 c0 00 00 00       	jmp    801061a0 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060e0:	e8 3f af ff ff       	call   80101024 <filealloc>
801060e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ec:	74 17                	je     80106105 <sys_open+0x100>
801060ee:	83 ec 0c             	sub    $0xc,%esp
801060f1:	ff 75 f0             	push   -0x10(%ebp)
801060f4:	e8 35 f7 ff ff       	call   8010582e <fdalloc>
801060f9:	83 c4 10             	add    $0x10,%esp
801060fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106103:	79 2e                	jns    80106133 <sys_open+0x12e>
    if(f)
80106105:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106109:	74 0e                	je     80106119 <sys_open+0x114>
      fileclose(f);
8010610b:	83 ec 0c             	sub    $0xc,%esp
8010610e:	ff 75 f0             	push   -0x10(%ebp)
80106111:	e8 cc af ff ff       	call   801010e2 <fileclose>
80106116:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106119:	83 ec 0c             	sub    $0xc,%esp
8010611c:	ff 75 f4             	push   -0xc(%ebp)
8010611f:	e8 29 bb ff ff       	call   80101c4d <iunlockput>
80106124:	83 c4 10             	add    $0x10,%esp
    end_op();
80106127:	e8 d2 d5 ff ff       	call   801036fe <end_op>
    return -1;
8010612c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106131:	eb 6d                	jmp    801061a0 <sys_open+0x19b>
  }
  iunlock(ip);
80106133:	83 ec 0c             	sub    $0xc,%esp
80106136:	ff 75 f4             	push   -0xc(%ebp)
80106139:	e8 f1 b9 ff ff       	call   80101b2f <iunlock>
8010613e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106141:	e8 b8 d5 ff ff       	call   801036fe <end_op>

  f->type = FD_INODE;
80106146:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106149:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010614f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106155:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106158:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106165:	83 e0 01             	and    $0x1,%eax
80106168:	85 c0                	test   %eax,%eax
8010616a:	0f 94 c0             	sete   %al
8010616d:	89 c2                	mov    %eax,%edx
8010616f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106172:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106178:	83 e0 01             	and    $0x1,%eax
8010617b:	85 c0                	test   %eax,%eax
8010617d:	75 0a                	jne    80106189 <sys_open+0x184>
8010617f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106182:	83 e0 02             	and    $0x2,%eax
80106185:	85 c0                	test   %eax,%eax
80106187:	74 07                	je     80106190 <sys_open+0x18b>
80106189:	b8 01 00 00 00       	mov    $0x1,%eax
8010618e:	eb 05                	jmp    80106195 <sys_open+0x190>
80106190:	b8 00 00 00 00       	mov    $0x0,%eax
80106195:	89 c2                	mov    %eax,%edx
80106197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010619d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801061a0:	c9                   	leave
801061a1:	c3                   	ret

801061a2 <sys_mkdir>:

int
sys_mkdir(void)
{
801061a2:	55                   	push   %ebp
801061a3:	89 e5                	mov    %esp,%ebp
801061a5:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061a8:	e8 c5 d4 ff ff       	call   80103672 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061ad:	83 ec 08             	sub    $0x8,%esp
801061b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061b3:	50                   	push   %eax
801061b4:	6a 00                	push   $0x0
801061b6:	e8 4a f5 ff ff       	call   80105705 <argstr>
801061bb:	83 c4 10             	add    $0x10,%esp
801061be:	85 c0                	test   %eax,%eax
801061c0:	78 1b                	js     801061dd <sys_mkdir+0x3b>
801061c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c5:	6a 00                	push   $0x0
801061c7:	6a 00                	push   $0x0
801061c9:	6a 01                	push   $0x1
801061cb:	50                   	push   %eax
801061cc:	e8 64 fc ff ff       	call   80105e35 <create>
801061d1:	83 c4 10             	add    $0x10,%esp
801061d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061db:	75 0c                	jne    801061e9 <sys_mkdir+0x47>
    end_op();
801061dd:	e8 1c d5 ff ff       	call   801036fe <end_op>
    return -1;
801061e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e7:	eb 18                	jmp    80106201 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	ff 75 f4             	push   -0xc(%ebp)
801061ef:	e8 59 ba ff ff       	call   80101c4d <iunlockput>
801061f4:	83 c4 10             	add    $0x10,%esp
  end_op();
801061f7:	e8 02 d5 ff ff       	call   801036fe <end_op>
  return 0;
801061fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106201:	c9                   	leave
80106202:	c3                   	ret

80106203 <sys_mknod>:

int
sys_mknod(void)
{
80106203:	55                   	push   %ebp
80106204:	89 e5                	mov    %esp,%ebp
80106206:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106209:	e8 64 d4 ff ff       	call   80103672 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010620e:	83 ec 08             	sub    $0x8,%esp
80106211:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106214:	50                   	push   %eax
80106215:	6a 00                	push   $0x0
80106217:	e8 e9 f4 ff ff       	call   80105705 <argstr>
8010621c:	83 c4 10             	add    $0x10,%esp
8010621f:	85 c0                	test   %eax,%eax
80106221:	78 4f                	js     80106272 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80106223:	83 ec 08             	sub    $0x8,%esp
80106226:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106229:	50                   	push   %eax
8010622a:	6a 01                	push   $0x1
8010622c:	e8 3f f4 ff ff       	call   80105670 <argint>
80106231:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106234:	85 c0                	test   %eax,%eax
80106236:	78 3a                	js     80106272 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80106238:	83 ec 08             	sub    $0x8,%esp
8010623b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010623e:	50                   	push   %eax
8010623f:	6a 02                	push   $0x2
80106241:	e8 2a f4 ff ff       	call   80105670 <argint>
80106246:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106249:	85 c0                	test   %eax,%eax
8010624b:	78 25                	js     80106272 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010624d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106250:	0f bf c8             	movswl %ax,%ecx
80106253:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106256:	0f bf d0             	movswl %ax,%edx
80106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625c:	51                   	push   %ecx
8010625d:	52                   	push   %edx
8010625e:	6a 03                	push   $0x3
80106260:	50                   	push   %eax
80106261:	e8 cf fb ff ff       	call   80105e35 <create>
80106266:	83 c4 10             	add    $0x10,%esp
80106269:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
8010626c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106270:	75 0c                	jne    8010627e <sys_mknod+0x7b>
    end_op();
80106272:	e8 87 d4 ff ff       	call   801036fe <end_op>
    return -1;
80106277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627c:	eb 18                	jmp    80106296 <sys_mknod+0x93>
  }
  iunlockput(ip);
8010627e:	83 ec 0c             	sub    $0xc,%esp
80106281:	ff 75 f4             	push   -0xc(%ebp)
80106284:	e8 c4 b9 ff ff       	call   80101c4d <iunlockput>
80106289:	83 c4 10             	add    $0x10,%esp
  end_op();
8010628c:	e8 6d d4 ff ff       	call   801036fe <end_op>
  return 0;
80106291:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106296:	c9                   	leave
80106297:	c3                   	ret

80106298 <sys_chdir>:

int
sys_chdir(void)
{
80106298:	55                   	push   %ebp
80106299:	89 e5                	mov    %esp,%ebp
8010629b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010629e:	e8 32 e1 ff ff       	call   801043d5 <myproc>
801062a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801062a6:	e8 c7 d3 ff ff       	call   80103672 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062ab:	83 ec 08             	sub    $0x8,%esp
801062ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062b1:	50                   	push   %eax
801062b2:	6a 00                	push   $0x0
801062b4:	e8 4c f4 ff ff       	call   80105705 <argstr>
801062b9:	83 c4 10             	add    $0x10,%esp
801062bc:	85 c0                	test   %eax,%eax
801062be:	78 18                	js     801062d8 <sys_chdir+0x40>
801062c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062c3:	83 ec 0c             	sub    $0xc,%esp
801062c6:	50                   	push   %eax
801062c7:	e8 83 c2 ff ff       	call   8010254f <namei>
801062cc:	83 c4 10             	add    $0x10,%esp
801062cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d6:	75 0c                	jne    801062e4 <sys_chdir+0x4c>
    end_op();
801062d8:	e8 21 d4 ff ff       	call   801036fe <end_op>
    return -1;
801062dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e2:	eb 68                	jmp    8010634c <sys_chdir+0xb4>
  }
  ilock(ip);
801062e4:	83 ec 0c             	sub    $0xc,%esp
801062e7:	ff 75 f0             	push   -0x10(%ebp)
801062ea:	e8 2d b7 ff ff       	call   80101a1c <ilock>
801062ef:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801062f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062f9:	66 83 f8 01          	cmp    $0x1,%ax
801062fd:	74 1a                	je     80106319 <sys_chdir+0x81>
    iunlockput(ip);
801062ff:	83 ec 0c             	sub    $0xc,%esp
80106302:	ff 75 f0             	push   -0x10(%ebp)
80106305:	e8 43 b9 ff ff       	call   80101c4d <iunlockput>
8010630a:	83 c4 10             	add    $0x10,%esp
    end_op();
8010630d:	e8 ec d3 ff ff       	call   801036fe <end_op>
    return -1;
80106312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106317:	eb 33                	jmp    8010634c <sys_chdir+0xb4>
  }
  iunlock(ip);
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	ff 75 f0             	push   -0x10(%ebp)
8010631f:	e8 0b b8 ff ff       	call   80101b2f <iunlock>
80106324:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80106327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632a:	8b 40 68             	mov    0x68(%eax),%eax
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	50                   	push   %eax
80106331:	e8 47 b8 ff ff       	call   80101b7d <iput>
80106336:	83 c4 10             	add    $0x10,%esp
  end_op();
80106339:	e8 c0 d3 ff ff       	call   801036fe <end_op>
  curproc->cwd = ip;
8010633e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106341:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106344:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106347:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010634c:	c9                   	leave
8010634d:	c3                   	ret

8010634e <sys_exec>:

int
sys_exec(void)
{
8010634e:	55                   	push   %ebp
8010634f:	89 e5                	mov    %esp,%ebp
80106351:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106357:	83 ec 08             	sub    $0x8,%esp
8010635a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010635d:	50                   	push   %eax
8010635e:	6a 00                	push   $0x0
80106360:	e8 a0 f3 ff ff       	call   80105705 <argstr>
80106365:	83 c4 10             	add    $0x10,%esp
80106368:	85 c0                	test   %eax,%eax
8010636a:	78 18                	js     80106384 <sys_exec+0x36>
8010636c:	83 ec 08             	sub    $0x8,%esp
8010636f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106375:	50                   	push   %eax
80106376:	6a 01                	push   $0x1
80106378:	e8 f3 f2 ff ff       	call   80105670 <argint>
8010637d:	83 c4 10             	add    $0x10,%esp
80106380:	85 c0                	test   %eax,%eax
80106382:	79 0a                	jns    8010638e <sys_exec+0x40>
    return -1;
80106384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106389:	e9 c6 00 00 00       	jmp    80106454 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010638e:	83 ec 04             	sub    $0x4,%esp
80106391:	68 80 00 00 00       	push   $0x80
80106396:	6a 00                	push   $0x0
80106398:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010639e:	50                   	push   %eax
8010639f:	e8 a1 ef ff ff       	call   80105345 <memset>
801063a4:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801063a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801063ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b1:	83 f8 1f             	cmp    $0x1f,%eax
801063b4:	76 0a                	jbe    801063c0 <sys_exec+0x72>
      return -1;
801063b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063bb:	e9 94 00 00 00       	jmp    80106454 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c3:	c1 e0 02             	shl    $0x2,%eax
801063c6:	89 c2                	mov    %eax,%edx
801063c8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063ce:	01 c2                	add    %eax,%edx
801063d0:	83 ec 08             	sub    $0x8,%esp
801063d3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063d9:	50                   	push   %eax
801063da:	52                   	push   %edx
801063db:	e8 ef f1 ff ff       	call   801055cf <fetchint>
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	85 c0                	test   %eax,%eax
801063e5:	79 07                	jns    801063ee <sys_exec+0xa0>
      return -1;
801063e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ec:	eb 66                	jmp    80106454 <sys_exec+0x106>
    if(uarg == 0){
801063ee:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063f4:	85 c0                	test   %eax,%eax
801063f6:	75 27                	jne    8010641f <sys_exec+0xd1>
      argv[i] = 0;
801063f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063fb:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106402:	00 00 00 00 
      break;
80106406:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106407:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640a:	83 ec 08             	sub    $0x8,%esp
8010640d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106413:	52                   	push   %edx
80106414:	50                   	push   %eax
80106415:	e8 ad a7 ff ff       	call   80100bc7 <exec>
8010641a:	83 c4 10             	add    $0x10,%esp
8010641d:	eb 35                	jmp    80106454 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
8010641f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106425:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106428:	c1 e2 02             	shl    $0x2,%edx
8010642b:	01 c2                	add    %eax,%edx
8010642d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106433:	83 ec 08             	sub    $0x8,%esp
80106436:	52                   	push   %edx
80106437:	50                   	push   %eax
80106438:	e8 d1 f1 ff ff       	call   8010560e <fetchstr>
8010643d:	83 c4 10             	add    $0x10,%esp
80106440:	85 c0                	test   %eax,%eax
80106442:	79 07                	jns    8010644b <sys_exec+0xfd>
      return -1;
80106444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106449:	eb 09                	jmp    80106454 <sys_exec+0x106>
  for(i=0;; i++){
8010644b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010644f:	e9 5a ff ff ff       	jmp    801063ae <sys_exec+0x60>
}
80106454:	c9                   	leave
80106455:	c3                   	ret

80106456 <sys_pipe>:

int
sys_pipe(void)
{
80106456:	55                   	push   %ebp
80106457:	89 e5                	mov    %esp,%ebp
80106459:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010645c:	83 ec 04             	sub    $0x4,%esp
8010645f:	6a 08                	push   $0x8
80106461:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106464:	50                   	push   %eax
80106465:	6a 00                	push   $0x0
80106467:	e8 31 f2 ff ff       	call   8010569d <argptr>
8010646c:	83 c4 10             	add    $0x10,%esp
8010646f:	85 c0                	test   %eax,%eax
80106471:	79 0a                	jns    8010647d <sys_pipe+0x27>
    return -1;
80106473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106478:	e9 ae 00 00 00       	jmp    8010652b <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
8010647d:	83 ec 08             	sub    $0x8,%esp
80106480:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106483:	50                   	push   %eax
80106484:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106487:	50                   	push   %eax
80106488:	e8 85 da ff ff       	call   80103f12 <pipealloc>
8010648d:	83 c4 10             	add    $0x10,%esp
80106490:	85 c0                	test   %eax,%eax
80106492:	79 0a                	jns    8010649e <sys_pipe+0x48>
    return -1;
80106494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106499:	e9 8d 00 00 00       	jmp    8010652b <sys_pipe+0xd5>
  fd0 = -1;
8010649e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064a8:	83 ec 0c             	sub    $0xc,%esp
801064ab:	50                   	push   %eax
801064ac:	e8 7d f3 ff ff       	call   8010582e <fdalloc>
801064b1:	83 c4 10             	add    $0x10,%esp
801064b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064bb:	78 18                	js     801064d5 <sys_pipe+0x7f>
801064bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	50                   	push   %eax
801064c4:	e8 65 f3 ff ff       	call   8010582e <fdalloc>
801064c9:	83 c4 10             	add    $0x10,%esp
801064cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064d3:	79 3e                	jns    80106513 <sys_pipe+0xbd>
    if(fd0 >= 0)
801064d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064d9:	78 13                	js     801064ee <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801064db:	e8 f5 de ff ff       	call   801043d5 <myproc>
801064e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064e3:	83 c2 08             	add    $0x8,%edx
801064e6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064ed:	00 
    fileclose(rf);
801064ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064f1:	83 ec 0c             	sub    $0xc,%esp
801064f4:	50                   	push   %eax
801064f5:	e8 e8 ab ff ff       	call   801010e2 <fileclose>
801064fa:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801064fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106500:	83 ec 0c             	sub    $0xc,%esp
80106503:	50                   	push   %eax
80106504:	e8 d9 ab ff ff       	call   801010e2 <fileclose>
80106509:	83 c4 10             	add    $0x10,%esp
    return -1;
8010650c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106511:	eb 18                	jmp    8010652b <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80106513:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106519:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010651b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010651e:	8d 50 04             	lea    0x4(%eax),%edx
80106521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106524:	89 02                	mov    %eax,(%edx)
  return 0;
80106526:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010652b:	c9                   	leave
8010652c:	c3                   	ret

8010652d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010652d:	55                   	push   %ebp
8010652e:	89 e5                	mov    %esp,%ebp
80106530:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106533:	e8 9c e1 ff ff       	call   801046d4 <fork>
}
80106538:	c9                   	leave
80106539:	c3                   	ret

8010653a <sys_exit>:

int
sys_exit(void)
{
8010653a:	55                   	push   %ebp
8010653b:	89 e5                	mov    %esp,%ebp
8010653d:	83 ec 08             	sub    $0x8,%esp
  exit();
80106540:	e8 08 e3 ff ff       	call   8010484d <exit>
  return 0;  // not reached
80106545:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010654a:	c9                   	leave
8010654b:	c3                   	ret

8010654c <sys_wait>:

int
sys_wait(void)
{
8010654c:	55                   	push   %ebp
8010654d:	89 e5                	mov    %esp,%ebp
8010654f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106552:	e8 16 e4 ff ff       	call   8010496d <wait>
}
80106557:	c9                   	leave
80106558:	c3                   	ret

80106559 <sys_kill>:

int
sys_kill(void)
{
80106559:	55                   	push   %ebp
8010655a:	89 e5                	mov    %esp,%ebp
8010655c:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010655f:	83 ec 08             	sub    $0x8,%esp
80106562:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106565:	50                   	push   %eax
80106566:	6a 00                	push   $0x0
80106568:	e8 03 f1 ff ff       	call   80105670 <argint>
8010656d:	83 c4 10             	add    $0x10,%esp
80106570:	85 c0                	test   %eax,%eax
80106572:	79 07                	jns    8010657b <sys_kill+0x22>
    return -1;
80106574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106579:	eb 0f                	jmp    8010658a <sys_kill+0x31>
  return kill(pid);
8010657b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657e:	83 ec 0c             	sub    $0xc,%esp
80106581:	50                   	push   %eax
80106582:	e8 15 e8 ff ff       	call   80104d9c <kill>
80106587:	83 c4 10             	add    $0x10,%esp
}
8010658a:	c9                   	leave
8010658b:	c3                   	ret

8010658c <sys_getpid>:

int
sys_getpid(void)
{
8010658c:	55                   	push   %ebp
8010658d:	89 e5                	mov    %esp,%ebp
8010658f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106592:	e8 3e de ff ff       	call   801043d5 <myproc>
80106597:	8b 40 10             	mov    0x10(%eax),%eax
}
8010659a:	c9                   	leave
8010659b:	c3                   	ret

8010659c <sys_sbrk>:

int
sys_sbrk(void)
{
8010659c:	55                   	push   %ebp
8010659d:	89 e5                	mov    %esp,%ebp
8010659f:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801065a2:	83 ec 08             	sub    $0x8,%esp
801065a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065a8:	50                   	push   %eax
801065a9:	6a 00                	push   $0x0
801065ab:	e8 c0 f0 ff ff       	call   80105670 <argint>
801065b0:	83 c4 10             	add    $0x10,%esp
801065b3:	85 c0                	test   %eax,%eax
801065b5:	79 07                	jns    801065be <sys_sbrk+0x22>
    return -1;
801065b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065bc:	eb 27                	jmp    801065e5 <sys_sbrk+0x49>
  addr = myproc()->sz;
801065be:	e8 12 de ff ff       	call   801043d5 <myproc>
801065c3:	8b 00                	mov    (%eax),%eax
801065c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801065c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065cb:	83 ec 0c             	sub    $0xc,%esp
801065ce:	50                   	push   %eax
801065cf:	e8 65 e0 ff ff       	call   80104639 <growproc>
801065d4:	83 c4 10             	add    $0x10,%esp
801065d7:	85 c0                	test   %eax,%eax
801065d9:	79 07                	jns    801065e2 <sys_sbrk+0x46>
    return -1;
801065db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e0:	eb 03                	jmp    801065e5 <sys_sbrk+0x49>
  return addr;
801065e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065e5:	c9                   	leave
801065e6:	c3                   	ret

801065e7 <sys_sleep>:

int
sys_sleep(void)
{
801065e7:	55                   	push   %ebp
801065e8:	89 e5                	mov    %esp,%ebp
801065ea:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801065ed:	83 ec 08             	sub    $0x8,%esp
801065f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065f3:	50                   	push   %eax
801065f4:	6a 00                	push   $0x0
801065f6:	e8 75 f0 ff ff       	call   80105670 <argint>
801065fb:	83 c4 10             	add    $0x10,%esp
801065fe:	85 c0                	test   %eax,%eax
80106600:	79 07                	jns    80106609 <sys_sleep+0x22>
    return -1;
80106602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106607:	eb 76                	jmp    8010667f <sys_sleep+0x98>
  acquire(&tickslock);
80106609:	83 ec 0c             	sub    $0xc,%esp
8010660c:	68 a0 d4 14 80       	push   $0x8014d4a0
80106611:	e8 a9 ea ff ff       	call   801050bf <acquire>
80106616:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106619:	a1 d4 d4 14 80       	mov    0x8014d4d4,%eax
8010661e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106621:	eb 38                	jmp    8010665b <sys_sleep+0x74>
    if(myproc()->killed){
80106623:	e8 ad dd ff ff       	call   801043d5 <myproc>
80106628:	8b 40 24             	mov    0x24(%eax),%eax
8010662b:	85 c0                	test   %eax,%eax
8010662d:	74 17                	je     80106646 <sys_sleep+0x5f>
      release(&tickslock);
8010662f:	83 ec 0c             	sub    $0xc,%esp
80106632:	68 a0 d4 14 80       	push   $0x8014d4a0
80106637:	e8 f1 ea ff ff       	call   8010512d <release>
8010663c:	83 c4 10             	add    $0x10,%esp
      return -1;
8010663f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106644:	eb 39                	jmp    8010667f <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80106646:	83 ec 08             	sub    $0x8,%esp
80106649:	68 a0 d4 14 80       	push   $0x8014d4a0
8010664e:	68 d4 d4 14 80       	push   $0x8014d4d4
80106653:	e8 26 e6 ff ff       	call   80104c7e <sleep>
80106658:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
8010665b:	a1 d4 d4 14 80       	mov    0x8014d4d4,%eax
80106660:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106663:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106666:	39 d0                	cmp    %edx,%eax
80106668:	72 b9                	jb     80106623 <sys_sleep+0x3c>
  }
  release(&tickslock);
8010666a:	83 ec 0c             	sub    $0xc,%esp
8010666d:	68 a0 d4 14 80       	push   $0x8014d4a0
80106672:	e8 b6 ea ff ff       	call   8010512d <release>
80106677:	83 c4 10             	add    $0x10,%esp
  return 0;
8010667a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010667f:	c9                   	leave
80106680:	c3                   	ret

80106681 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106681:	55                   	push   %ebp
80106682:	89 e5                	mov    %esp,%ebp
80106684:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106687:	83 ec 0c             	sub    $0xc,%esp
8010668a:	68 a0 d4 14 80       	push   $0x8014d4a0
8010668f:	e8 2b ea ff ff       	call   801050bf <acquire>
80106694:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106697:	a1 d4 d4 14 80       	mov    0x8014d4d4,%eax
8010669c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010669f:	83 ec 0c             	sub    $0xc,%esp
801066a2:	68 a0 d4 14 80       	push   $0x8014d4a0
801066a7:	e8 81 ea ff ff       	call   8010512d <release>
801066ac:	83 c4 10             	add    $0x10,%esp
  return xticks;
801066af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066b2:	c9                   	leave
801066b3:	c3                   	ret

801066b4 <sys_getNumFreePages>:

int sys_getNumFreePages (void) {
801066b4:	55                   	push   %ebp
801066b5:	89 e5                	mov    %esp,%ebp
801066b7:	83 ec 08             	sub    $0x8,%esp
  return freePage();
801066ba:	e8 c6 c6 ff ff       	call   80102d85 <freePage>
801066bf:	c9                   	leave
801066c0:	c3                   	ret

801066c1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066c1:	1e                   	push   %ds
  pushl %es
801066c2:	06                   	push   %es
  pushl %fs
801066c3:	0f a0                	push   %fs
  pushl %gs
801066c5:	0f a8                	push   %gs
  pushal
801066c7:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801066c8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066cc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066ce:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801066d0:	54                   	push   %esp
  call trap
801066d1:	e8 d7 01 00 00       	call   801068ad <trap>
  addl $4, %esp
801066d6:	83 c4 04             	add    $0x4,%esp

801066d9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066d9:	61                   	popa
  popl %gs
801066da:	0f a9                	pop    %gs
  popl %fs
801066dc:	0f a1                	pop    %fs
  popl %es
801066de:	07                   	pop    %es
  popl %ds
801066df:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066e0:	83 c4 08             	add    $0x8,%esp
  iret
801066e3:	cf                   	iret

801066e4 <lidt>:
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
801066e4:	55                   	push   %ebp
801066e5:	89 e5                	mov    %esp,%ebp
801066e7:	83 ec 10             	sub    $0x10,%esp
    uartintr();
    lapiceoi();
    break;
801066ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801066ed:	83 e8 01             	sub    $0x1,%eax
801066f0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  case T_IRQ0 + 7:
801066f4:	8b 45 08             	mov    0x8(%ebp),%eax
801066f7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  case T_IRQ0 + IRQ_SPURIOUS:
801066fb:	8b 45 08             	mov    0x8(%ebp),%eax
801066fe:	c1 e8 10             	shr    $0x10,%eax
80106701:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
80106705:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106708:	0f 01 18             	lidtl  (%eax)
    lapiceoi();
8010670b:	90                   	nop
8010670c:	c9                   	leave
8010670d:	c3                   	ret

8010670e <rcr2>:
8010670e:	55                   	push   %ebp
8010670f:	89 e5                	mov    %esp,%ebp
80106711:	83 ec 10             	sub    $0x10,%esp
80106714:	0f 20 d0             	mov    %cr2,%eax
80106717:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010671a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010671d:	c9                   	leave
8010671e:	c3                   	ret

8010671f <tvinit>:
{
8010671f:	55                   	push   %ebp
80106720:	89 e5                	mov    %esp,%ebp
80106722:	83 ec 18             	sub    $0x18,%esp
  for(i = 0; i < 256; i++)
80106725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010672c:	e9 c3 00 00 00       	jmp    801067f4 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106734:	8b 04 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%eax
8010673b:	89 c2                	mov    %eax,%edx
8010673d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106740:	66 89 14 c5 a0 cc 14 	mov    %dx,-0x7feb3360(,%eax,8)
80106747:	80 
80106748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674b:	66 c7 04 c5 a2 cc 14 	movw   $0x8,-0x7feb335e(,%eax,8)
80106752:	80 08 00 
80106755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106758:	0f b6 14 c5 a4 cc 14 	movzbl -0x7feb335c(,%eax,8),%edx
8010675f:	80 
80106760:	83 e2 e0             	and    $0xffffffe0,%edx
80106763:	88 14 c5 a4 cc 14 80 	mov    %dl,-0x7feb335c(,%eax,8)
8010676a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010676d:	0f b6 14 c5 a4 cc 14 	movzbl -0x7feb335c(,%eax,8),%edx
80106774:	80 
80106775:	83 e2 1f             	and    $0x1f,%edx
80106778:	88 14 c5 a4 cc 14 80 	mov    %dl,-0x7feb335c(,%eax,8)
8010677f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106782:	0f b6 14 c5 a5 cc 14 	movzbl -0x7feb335b(,%eax,8),%edx
80106789:	80 
8010678a:	83 e2 f0             	and    $0xfffffff0,%edx
8010678d:	83 ca 0e             	or     $0xe,%edx
80106790:	88 14 c5 a5 cc 14 80 	mov    %dl,-0x7feb335b(,%eax,8)
80106797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679a:	0f b6 14 c5 a5 cc 14 	movzbl -0x7feb335b(,%eax,8),%edx
801067a1:	80 
801067a2:	83 e2 ef             	and    $0xffffffef,%edx
801067a5:	88 14 c5 a5 cc 14 80 	mov    %dl,-0x7feb335b(,%eax,8)
801067ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067af:	0f b6 14 c5 a5 cc 14 	movzbl -0x7feb335b(,%eax,8),%edx
801067b6:	80 
801067b7:	83 e2 9f             	and    $0xffffff9f,%edx
801067ba:	88 14 c5 a5 cc 14 80 	mov    %dl,-0x7feb335b(,%eax,8)
801067c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c4:	0f b6 14 c5 a5 cc 14 	movzbl -0x7feb335b(,%eax,8),%edx
801067cb:	80 
801067cc:	83 ca 80             	or     $0xffffff80,%edx
801067cf:	88 14 c5 a5 cc 14 80 	mov    %dl,-0x7feb335b(,%eax,8)
801067d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d9:	8b 04 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%eax
801067e0:	c1 e8 10             	shr    $0x10,%eax
801067e3:	89 c2                	mov    %eax,%edx
801067e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e8:	66 89 14 c5 a6 cc 14 	mov    %dx,-0x7feb335a(,%eax,8)
801067ef:	80 
  for(i = 0; i < 256; i++)
801067f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067f4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801067fb:	0f 8e 30 ff ff ff    	jle    80106731 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106801:	a1 7c b1 10 80       	mov    0x8010b17c,%eax
80106806:	66 a3 a0 ce 14 80    	mov    %ax,0x8014cea0
8010680c:	66 c7 05 a2 ce 14 80 	movw   $0x8,0x8014cea2
80106813:	08 00 
80106815:	0f b6 05 a4 ce 14 80 	movzbl 0x8014cea4,%eax
8010681c:	83 e0 e0             	and    $0xffffffe0,%eax
8010681f:	a2 a4 ce 14 80       	mov    %al,0x8014cea4
80106824:	0f b6 05 a4 ce 14 80 	movzbl 0x8014cea4,%eax
8010682b:	83 e0 1f             	and    $0x1f,%eax
8010682e:	a2 a4 ce 14 80       	mov    %al,0x8014cea4
80106833:	0f b6 05 a5 ce 14 80 	movzbl 0x8014cea5,%eax
8010683a:	83 c8 0f             	or     $0xf,%eax
8010683d:	a2 a5 ce 14 80       	mov    %al,0x8014cea5
80106842:	0f b6 05 a5 ce 14 80 	movzbl 0x8014cea5,%eax
80106849:	83 e0 ef             	and    $0xffffffef,%eax
8010684c:	a2 a5 ce 14 80       	mov    %al,0x8014cea5
80106851:	0f b6 05 a5 ce 14 80 	movzbl 0x8014cea5,%eax
80106858:	83 c8 60             	or     $0x60,%eax
8010685b:	a2 a5 ce 14 80       	mov    %al,0x8014cea5
80106860:	0f b6 05 a5 ce 14 80 	movzbl 0x8014cea5,%eax
80106867:	83 c8 80             	or     $0xffffff80,%eax
8010686a:	a2 a5 ce 14 80       	mov    %al,0x8014cea5
8010686f:	a1 7c b1 10 80       	mov    0x8010b17c,%eax
80106874:	c1 e8 10             	shr    $0x10,%eax
80106877:	66 a3 a6 ce 14 80    	mov    %ax,0x8014cea6
  initlock(&tickslock, "time");
8010687d:	83 ec 08             	sub    $0x8,%esp
80106880:	68 78 8b 10 80       	push   $0x80108b78
80106885:	68 a0 d4 14 80       	push   $0x8014d4a0
8010688a:	e8 0e e8 ff ff       	call   8010509d <initlock>
8010688f:	83 c4 10             	add    $0x10,%esp
}
80106892:	90                   	nop
80106893:	c9                   	leave
80106894:	c3                   	ret

80106895 <idtinit>:
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106898:	68 00 08 00 00       	push   $0x800
8010689d:	68 a0 cc 14 80       	push   $0x8014cca0
801068a2:	e8 3d fe ff ff       	call   801066e4 <lidt>
801068a7:	83 c4 08             	add    $0x8,%esp
}
801068aa:	90                   	nop
801068ab:	c9                   	leave
801068ac:	c3                   	ret

801068ad <trap>:
{
801068ad:	55                   	push   %ebp
801068ae:	89 e5                	mov    %esp,%ebp
801068b0:	57                   	push   %edi
801068b1:	56                   	push   %esi
801068b2:	53                   	push   %ebx
801068b3:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){
801068b6:	8b 45 08             	mov    0x8(%ebp),%eax
801068b9:	8b 40 30             	mov    0x30(%eax),%eax
801068bc:	83 f8 40             	cmp    $0x40,%eax
801068bf:	75 3b                	jne    801068fc <trap+0x4f>
    if(myproc()->killed)
801068c1:	e8 0f db ff ff       	call   801043d5 <myproc>
801068c6:	8b 40 24             	mov    0x24(%eax),%eax
801068c9:	85 c0                	test   %eax,%eax
801068cb:	74 05                	je     801068d2 <trap+0x25>
      exit();
801068cd:	e8 7b df ff ff       	call   8010484d <exit>
    myproc()->tf = tf;
801068d2:	e8 fe da ff ff       	call   801043d5 <myproc>
801068d7:	8b 55 08             	mov    0x8(%ebp),%edx
801068da:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801068dd:	e8 5a ee ff ff       	call   8010573c <syscall>
    if(myproc()->killed)
801068e2:	e8 ee da ff ff       	call   801043d5 <myproc>
801068e7:	8b 40 24             	mov    0x24(%eax),%eax
801068ea:	85 c0                	test   %eax,%eax
801068ec:	0f 84 31 02 00 00    	je     80106b23 <trap+0x276>
      exit();
801068f2:	e8 56 df ff ff       	call   8010484d <exit>
    return;
801068f7:	e9 27 02 00 00       	jmp    80106b23 <trap+0x276>
  switch(tf->trapno){
801068fc:	8b 45 08             	mov    0x8(%ebp),%eax
801068ff:	8b 40 30             	mov    0x30(%eax),%eax
80106902:	83 e8 0e             	sub    $0xe,%eax
80106905:	83 f8 31             	cmp    $0x31,%eax
80106908:	0f 87 e0 00 00 00    	ja     801069ee <trap+0x141>
8010690e:	8b 04 85 20 8c 10 80 	mov    -0x7fef73e0(,%eax,4),%eax
80106915:	ff e0                	jmp    *%eax
    void* va = (void*)rcr2();
80106917:	e8 f2 fd ff ff       	call   8010670e <rcr2>
8010691c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    va = (void*)PGROUNDDOWN((uint)va);
8010691f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106922:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    handlePageFault(va);
8010692a:	83 ec 0c             	sub    $0xc,%esp
8010692d:	ff 75 e4             	push   -0x1c(%ebp)
80106930:	e8 67 1b 00 00       	call   8010849c <handlePageFault>
80106935:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106938:	e8 15 c8 ff ff       	call   80103152 <lapiceoi>
    return;
8010693d:	e9 e2 01 00 00       	jmp    80106b24 <trap+0x277>
    if(cpuid() == 0){
80106942:	e8 fb d9 ff ff       	call   80104342 <cpuid>
80106947:	85 c0                	test   %eax,%eax
80106949:	75 3d                	jne    80106988 <trap+0xdb>
      acquire(&tickslock);
8010694b:	83 ec 0c             	sub    $0xc,%esp
8010694e:	68 a0 d4 14 80       	push   $0x8014d4a0
80106953:	e8 67 e7 ff ff       	call   801050bf <acquire>
80106958:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010695b:	a1 d4 d4 14 80       	mov    0x8014d4d4,%eax
80106960:	83 c0 01             	add    $0x1,%eax
80106963:	a3 d4 d4 14 80       	mov    %eax,0x8014d4d4
      wakeup(&ticks);
80106968:	83 ec 0c             	sub    $0xc,%esp
8010696b:	68 d4 d4 14 80       	push   $0x8014d4d4
80106970:	e8 f0 e3 ff ff       	call   80104d65 <wakeup>
80106975:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106978:	83 ec 0c             	sub    $0xc,%esp
8010697b:	68 a0 d4 14 80       	push   $0x8014d4a0
80106980:	e8 a8 e7 ff ff       	call   8010512d <release>
80106985:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106988:	e8 c5 c7 ff ff       	call   80103152 <lapiceoi>
    break;
8010698d:	e9 11 01 00 00       	jmp    80106aa3 <trap+0x1f6>
    ideintr();
80106992:	e8 ef be ff ff       	call   80102886 <ideintr>
    lapiceoi();
80106997:	e8 b6 c7 ff ff       	call   80103152 <lapiceoi>
    break;
8010699c:	e9 02 01 00 00       	jmp    80106aa3 <trap+0x1f6>
    kbdintr();
801069a1:	e8 f7 c5 ff ff       	call   80102f9d <kbdintr>
    lapiceoi();
801069a6:	e8 a7 c7 ff ff       	call   80103152 <lapiceoi>
    break;
801069ab:	e9 f3 00 00 00       	jmp    80106aa3 <trap+0x1f6>
    uartintr();
801069b0:	e8 42 03 00 00       	call   80106cf7 <uartintr>
    lapiceoi();
801069b5:	e8 98 c7 ff ff       	call   80103152 <lapiceoi>
    break;
801069ba:	e9 e4 00 00 00       	jmp    80106aa3 <trap+0x1f6>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069bf:	8b 45 08             	mov    0x8(%ebp),%eax
801069c2:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801069c5:	8b 45 08             	mov    0x8(%ebp),%eax
801069c8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069cc:	0f b7 d8             	movzwl %ax,%ebx
801069cf:	e8 6e d9 ff ff       	call   80104342 <cpuid>
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	50                   	push   %eax
801069d7:	68 80 8b 10 80       	push   $0x80108b80
801069dc:	e8 1d 9a ff ff       	call   801003fe <cprintf>
801069e1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801069e4:	e8 69 c7 ff ff       	call   80103152 <lapiceoi>
    break;
801069e9:	e9 b5 00 00 00       	jmp    80106aa3 <trap+0x1f6>
    if(myproc() == 0 || (tf->cs&3) == 0){
801069ee:	e8 e2 d9 ff ff       	call   801043d5 <myproc>
801069f3:	85 c0                	test   %eax,%eax
801069f5:	74 11                	je     80106a08 <trap+0x15b>
801069f7:	8b 45 08             	mov    0x8(%ebp),%eax
801069fa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069fe:	0f b7 c0             	movzwl %ax,%eax
80106a01:	83 e0 03             	and    $0x3,%eax
80106a04:	85 c0                	test   %eax,%eax
80106a06:	75 39                	jne    80106a41 <trap+0x194>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a08:	e8 01 fd ff ff       	call   8010670e <rcr2>
80106a0d:	89 c3                	mov    %eax,%ebx
80106a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a12:	8b 70 38             	mov    0x38(%eax),%esi
80106a15:	e8 28 d9 ff ff       	call   80104342 <cpuid>
80106a1a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a1d:	8b 52 30             	mov    0x30(%edx),%edx
80106a20:	83 ec 0c             	sub    $0xc,%esp
80106a23:	53                   	push   %ebx
80106a24:	56                   	push   %esi
80106a25:	50                   	push   %eax
80106a26:	52                   	push   %edx
80106a27:	68 a4 8b 10 80       	push   $0x80108ba4
80106a2c:	e8 cd 99 ff ff       	call   801003fe <cprintf>
80106a31:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80106a34:	83 ec 0c             	sub    $0xc,%esp
80106a37:	68 d6 8b 10 80       	push   $0x80108bd6
80106a3c:	e8 72 9b ff ff       	call   801005b3 <panic>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a41:	e8 c8 fc ff ff       	call   8010670e <rcr2>
80106a46:	89 c6                	mov    %eax,%esi
80106a48:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4b:	8b 40 38             	mov    0x38(%eax),%eax
80106a4e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106a51:	e8 ec d8 ff ff       	call   80104342 <cpuid>
80106a56:	89 c3                	mov    %eax,%ebx
80106a58:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5b:	8b 48 34             	mov    0x34(%eax),%ecx
80106a5e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80106a61:	8b 45 08             	mov    0x8(%ebp),%eax
80106a64:	8b 78 30             	mov    0x30(%eax),%edi
            myproc()->pid, myproc()->name, tf->trapno,
80106a67:	e8 69 d9 ff ff       	call   801043d5 <myproc>
80106a6c:	8d 50 6c             	lea    0x6c(%eax),%edx
80106a6f:	89 55 cc             	mov    %edx,-0x34(%ebp)
80106a72:	e8 5e d9 ff ff       	call   801043d5 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a77:	8b 40 10             	mov    0x10(%eax),%eax
80106a7a:	56                   	push   %esi
80106a7b:	ff 75 d4             	push   -0x2c(%ebp)
80106a7e:	53                   	push   %ebx
80106a7f:	ff 75 d0             	push   -0x30(%ebp)
80106a82:	57                   	push   %edi
80106a83:	ff 75 cc             	push   -0x34(%ebp)
80106a86:	50                   	push   %eax
80106a87:	68 dc 8b 10 80       	push   $0x80108bdc
80106a8c:	e8 6d 99 ff ff       	call   801003fe <cprintf>
80106a91:	83 c4 20             	add    $0x20,%esp
    myproc()->killed = 1;
80106a94:	e8 3c d9 ff ff       	call   801043d5 <myproc>
80106a99:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106aa0:	eb 01                	jmp    80106aa3 <trap+0x1f6>
    break;
80106aa2:	90                   	nop
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106aa3:	e8 2d d9 ff ff       	call   801043d5 <myproc>
80106aa8:	85 c0                	test   %eax,%eax
80106aaa:	74 23                	je     80106acf <trap+0x222>
80106aac:	e8 24 d9 ff ff       	call   801043d5 <myproc>
80106ab1:	8b 40 24             	mov    0x24(%eax),%eax
80106ab4:	85 c0                	test   %eax,%eax
80106ab6:	74 17                	je     80106acf <trap+0x222>
80106ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80106abb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106abf:	0f b7 c0             	movzwl %ax,%eax
80106ac2:	83 e0 03             	and    $0x3,%eax
80106ac5:	83 f8 03             	cmp    $0x3,%eax
80106ac8:	75 05                	jne    80106acf <trap+0x222>
    exit();
80106aca:	e8 7e dd ff ff       	call   8010484d <exit>
  if(myproc() && myproc()->state == RUNNING &&
80106acf:	e8 01 d9 ff ff       	call   801043d5 <myproc>
80106ad4:	85 c0                	test   %eax,%eax
80106ad6:	74 1d                	je     80106af5 <trap+0x248>
80106ad8:	e8 f8 d8 ff ff       	call   801043d5 <myproc>
80106add:	8b 40 0c             	mov    0xc(%eax),%eax
80106ae0:	83 f8 04             	cmp    $0x4,%eax
80106ae3:	75 10                	jne    80106af5 <trap+0x248>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae8:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106aeb:	83 f8 20             	cmp    $0x20,%eax
80106aee:	75 05                	jne    80106af5 <trap+0x248>
    yield();
80106af0:	e8 09 e1 ff ff       	call   80104bfe <yield>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106af5:	e8 db d8 ff ff       	call   801043d5 <myproc>
80106afa:	85 c0                	test   %eax,%eax
80106afc:	74 26                	je     80106b24 <trap+0x277>
80106afe:	e8 d2 d8 ff ff       	call   801043d5 <myproc>
80106b03:	8b 40 24             	mov    0x24(%eax),%eax
80106b06:	85 c0                	test   %eax,%eax
80106b08:	74 1a                	je     80106b24 <trap+0x277>
80106b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b11:	0f b7 c0             	movzwl %ax,%eax
80106b14:	83 e0 03             	and    $0x3,%eax
80106b17:	83 f8 03             	cmp    $0x3,%eax
80106b1a:	75 08                	jne    80106b24 <trap+0x277>
    exit();
80106b1c:	e8 2c dd ff ff       	call   8010484d <exit>
80106b21:	eb 01                	jmp    80106b24 <trap+0x277>
    return;
80106b23:	90                   	nop
}
80106b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b27:	5b                   	pop    %ebx
80106b28:	5e                   	pop    %esi
80106b29:	5f                   	pop    %edi
80106b2a:	5d                   	pop    %ebp
80106b2b:	c3                   	ret

80106b2c <inb>:
// Intel 8250 serial port (UART).

#include "types.h"
#include "defs.h"
#include "param.h"
80106b2c:	55                   	push   %ebp
80106b2d:	89 e5                	mov    %esp,%ebp
80106b2f:	83 ec 14             	sub    $0x14,%esp
80106b32:	8b 45 08             	mov    0x8(%ebp),%eax
80106b35:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
80106b39:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106b3d:	89 c2                	mov    %eax,%edx
80106b3f:	ec                   	in     (%dx),%al
80106b40:	88 45 ff             	mov    %al,-0x1(%ebp)
#include "fs.h"
80106b43:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
#include "file.h"
80106b47:	c9                   	leave
80106b48:	c3                   	ret

80106b49 <outb>:

void
uartinit(void)
{
  char *p;

80106b49:	55                   	push   %ebp
80106b4a:	89 e5                	mov    %esp,%ebp
80106b4c:	83 ec 08             	sub    $0x8,%esp
80106b4f:	8b 55 08             	mov    0x8(%ebp),%edx
80106b52:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b55:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b59:	88 45 f8             	mov    %al,-0x8(%ebp)
  // Turn off the FIFO
80106b5c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b60:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b64:	ee                   	out    %al,(%dx)
  outb(COM1+2, 0);
80106b65:	90                   	nop
80106b66:	c9                   	leave
80106b67:	c3                   	ret

80106b68 <uartinit>:
{
80106b68:	55                   	push   %ebp
80106b69:	89 e5                	mov    %esp,%ebp
80106b6b:	83 ec 18             	sub    $0x18,%esp
  outb(COM1+2, 0);
80106b6e:	6a 00                	push   $0x0
80106b70:	68 fa 03 00 00       	push   $0x3fa
80106b75:	e8 cf ff ff ff       	call   80106b49 <outb>
80106b7a:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b7d:	68 80 00 00 00       	push   $0x80
80106b82:	68 fb 03 00 00       	push   $0x3fb
80106b87:	e8 bd ff ff ff       	call   80106b49 <outb>
80106b8c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106b8f:	6a 0c                	push   $0xc
80106b91:	68 f8 03 00 00       	push   $0x3f8
80106b96:	e8 ae ff ff ff       	call   80106b49 <outb>
80106b9b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106b9e:	6a 00                	push   $0x0
80106ba0:	68 f9 03 00 00       	push   $0x3f9
80106ba5:	e8 9f ff ff ff       	call   80106b49 <outb>
80106baa:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106bad:	6a 03                	push   $0x3
80106baf:	68 fb 03 00 00       	push   $0x3fb
80106bb4:	e8 90 ff ff ff       	call   80106b49 <outb>
80106bb9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106bbc:	6a 00                	push   $0x0
80106bbe:	68 fc 03 00 00       	push   $0x3fc
80106bc3:	e8 81 ff ff ff       	call   80106b49 <outb>
80106bc8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bcb:	6a 01                	push   $0x1
80106bcd:	68 f9 03 00 00       	push   $0x3f9
80106bd2:	e8 72 ff ff ff       	call   80106b49 <outb>
80106bd7:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106bda:	68 fd 03 00 00       	push   $0x3fd
80106bdf:	e8 48 ff ff ff       	call   80106b2c <inb>
80106be4:	83 c4 04             	add    $0x4,%esp
80106be7:	3c ff                	cmp    $0xff,%al
80106be9:	74 61                	je     80106c4c <uartinit+0xe4>
    return;
  uart = 1;
80106beb:	c7 05 d8 d4 14 80 01 	movl   $0x1,0x8014d4d8
80106bf2:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106bf5:	68 fa 03 00 00       	push   $0x3fa
80106bfa:	e8 2d ff ff ff       	call   80106b2c <inb>
80106bff:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106c02:	68 f8 03 00 00       	push   $0x3f8
80106c07:	e8 20 ff ff ff       	call   80106b2c <inb>
80106c0c:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106c0f:	83 ec 08             	sub    $0x8,%esp
80106c12:	6a 00                	push   $0x0
80106c14:	6a 04                	push   $0x4
80106c16:	e8 09 bf ff ff       	call   80102b24 <ioapicenable>
80106c1b:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c1e:	c7 45 f4 e8 8c 10 80 	movl   $0x80108ce8,-0xc(%ebp)
80106c25:	eb 19                	jmp    80106c40 <uartinit+0xd8>
    uartputc(*p);
80106c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2a:	0f b6 00             	movzbl (%eax),%eax
80106c2d:	0f be c0             	movsbl %al,%eax
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	50                   	push   %eax
80106c34:	e8 16 00 00 00       	call   80106c4f <uartputc>
80106c39:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c3c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c43:	0f b6 00             	movzbl (%eax),%eax
80106c46:	84 c0                	test   %al,%al
80106c48:	75 dd                	jne    80106c27 <uartinit+0xbf>
80106c4a:	eb 01                	jmp    80106c4d <uartinit+0xe5>
    return;
80106c4c:	90                   	nop
}
80106c4d:	c9                   	leave
80106c4e:	c3                   	ret

80106c4f <uartputc>:

void
uartputc(int c)
{
80106c4f:	55                   	push   %ebp
80106c50:	89 e5                	mov    %esp,%ebp
80106c52:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106c55:	a1 d8 d4 14 80       	mov    0x8014d4d8,%eax
80106c5a:	85 c0                	test   %eax,%eax
80106c5c:	74 53                	je     80106cb1 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c65:	eb 11                	jmp    80106c78 <uartputc+0x29>
    microdelay(10);
80106c67:	83 ec 0c             	sub    $0xc,%esp
80106c6a:	6a 0a                	push   $0xa
80106c6c:	e8 fc c4 ff ff       	call   8010316d <microdelay>
80106c71:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c78:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c7c:	7f 1a                	jg     80106c98 <uartputc+0x49>
80106c7e:	83 ec 0c             	sub    $0xc,%esp
80106c81:	68 fd 03 00 00       	push   $0x3fd
80106c86:	e8 a1 fe ff ff       	call   80106b2c <inb>
80106c8b:	83 c4 10             	add    $0x10,%esp
80106c8e:	0f b6 c0             	movzbl %al,%eax
80106c91:	83 e0 20             	and    $0x20,%eax
80106c94:	85 c0                	test   %eax,%eax
80106c96:	74 cf                	je     80106c67 <uartputc+0x18>
  outb(COM1+0, c);
80106c98:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9b:	0f b6 c0             	movzbl %al,%eax
80106c9e:	83 ec 08             	sub    $0x8,%esp
80106ca1:	50                   	push   %eax
80106ca2:	68 f8 03 00 00       	push   $0x3f8
80106ca7:	e8 9d fe ff ff       	call   80106b49 <outb>
80106cac:	83 c4 10             	add    $0x10,%esp
80106caf:	eb 01                	jmp    80106cb2 <uartputc+0x63>
    return;
80106cb1:	90                   	nop
}
80106cb2:	c9                   	leave
80106cb3:	c3                   	ret

80106cb4 <uartgetc>:

static int
uartgetc(void)
{
80106cb4:	55                   	push   %ebp
80106cb5:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106cb7:	a1 d8 d4 14 80       	mov    0x8014d4d8,%eax
80106cbc:	85 c0                	test   %eax,%eax
80106cbe:	75 07                	jne    80106cc7 <uartgetc+0x13>
    return -1;
80106cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc5:	eb 2e                	jmp    80106cf5 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106cc7:	68 fd 03 00 00       	push   $0x3fd
80106ccc:	e8 5b fe ff ff       	call   80106b2c <inb>
80106cd1:	83 c4 04             	add    $0x4,%esp
80106cd4:	0f b6 c0             	movzbl %al,%eax
80106cd7:	83 e0 01             	and    $0x1,%eax
80106cda:	85 c0                	test   %eax,%eax
80106cdc:	75 07                	jne    80106ce5 <uartgetc+0x31>
    return -1;
80106cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce3:	eb 10                	jmp    80106cf5 <uartgetc+0x41>
  return inb(COM1+0);
80106ce5:	68 f8 03 00 00       	push   $0x3f8
80106cea:	e8 3d fe ff ff       	call   80106b2c <inb>
80106cef:	83 c4 04             	add    $0x4,%esp
80106cf2:	0f b6 c0             	movzbl %al,%eax
}
80106cf5:	c9                   	leave
80106cf6:	c3                   	ret

80106cf7 <uartintr>:

void
uartintr(void)
{
80106cf7:	55                   	push   %ebp
80106cf8:	89 e5                	mov    %esp,%ebp
80106cfa:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106cfd:	83 ec 0c             	sub    $0xc,%esp
80106d00:	68 b4 6c 10 80       	push   $0x80106cb4
80106d05:	e8 3f 9b ff ff       	call   80100849 <consoleintr>
80106d0a:	83 c4 10             	add    $0x10,%esp
}
80106d0d:	90                   	nop
80106d0e:	c9                   	leave
80106d0f:	c3                   	ret

80106d10 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $0
80106d12:	6a 00                	push   $0x0
  jmp alltraps
80106d14:	e9 a8 f9 ff ff       	jmp    801066c1 <alltraps>

80106d19 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $1
80106d1b:	6a 01                	push   $0x1
  jmp alltraps
80106d1d:	e9 9f f9 ff ff       	jmp    801066c1 <alltraps>

80106d22 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $2
80106d24:	6a 02                	push   $0x2
  jmp alltraps
80106d26:	e9 96 f9 ff ff       	jmp    801066c1 <alltraps>

80106d2b <vector3>:
.globl vector3
vector3:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $3
80106d2d:	6a 03                	push   $0x3
  jmp alltraps
80106d2f:	e9 8d f9 ff ff       	jmp    801066c1 <alltraps>

80106d34 <vector4>:
.globl vector4
vector4:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $4
80106d36:	6a 04                	push   $0x4
  jmp alltraps
80106d38:	e9 84 f9 ff ff       	jmp    801066c1 <alltraps>

80106d3d <vector5>:
.globl vector5
vector5:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $5
80106d3f:	6a 05                	push   $0x5
  jmp alltraps
80106d41:	e9 7b f9 ff ff       	jmp    801066c1 <alltraps>

80106d46 <vector6>:
.globl vector6
vector6:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $6
80106d48:	6a 06                	push   $0x6
  jmp alltraps
80106d4a:	e9 72 f9 ff ff       	jmp    801066c1 <alltraps>

80106d4f <vector7>:
.globl vector7
vector7:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $7
80106d51:	6a 07                	push   $0x7
  jmp alltraps
80106d53:	e9 69 f9 ff ff       	jmp    801066c1 <alltraps>

80106d58 <vector8>:
.globl vector8
vector8:
  pushl $8
80106d58:	6a 08                	push   $0x8
  jmp alltraps
80106d5a:	e9 62 f9 ff ff       	jmp    801066c1 <alltraps>

80106d5f <vector9>:
.globl vector9
vector9:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $9
80106d61:	6a 09                	push   $0x9
  jmp alltraps
80106d63:	e9 59 f9 ff ff       	jmp    801066c1 <alltraps>

80106d68 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d68:	6a 0a                	push   $0xa
  jmp alltraps
80106d6a:	e9 52 f9 ff ff       	jmp    801066c1 <alltraps>

80106d6f <vector11>:
.globl vector11
vector11:
  pushl $11
80106d6f:	6a 0b                	push   $0xb
  jmp alltraps
80106d71:	e9 4b f9 ff ff       	jmp    801066c1 <alltraps>

80106d76 <vector12>:
.globl vector12
vector12:
  pushl $12
80106d76:	6a 0c                	push   $0xc
  jmp alltraps
80106d78:	e9 44 f9 ff ff       	jmp    801066c1 <alltraps>

80106d7d <vector13>:
.globl vector13
vector13:
  pushl $13
80106d7d:	6a 0d                	push   $0xd
  jmp alltraps
80106d7f:	e9 3d f9 ff ff       	jmp    801066c1 <alltraps>

80106d84 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d84:	6a 0e                	push   $0xe
  jmp alltraps
80106d86:	e9 36 f9 ff ff       	jmp    801066c1 <alltraps>

80106d8b <vector15>:
.globl vector15
vector15:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $15
80106d8d:	6a 0f                	push   $0xf
  jmp alltraps
80106d8f:	e9 2d f9 ff ff       	jmp    801066c1 <alltraps>

80106d94 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $16
80106d96:	6a 10                	push   $0x10
  jmp alltraps
80106d98:	e9 24 f9 ff ff       	jmp    801066c1 <alltraps>

80106d9d <vector17>:
.globl vector17
vector17:
  pushl $17
80106d9d:	6a 11                	push   $0x11
  jmp alltraps
80106d9f:	e9 1d f9 ff ff       	jmp    801066c1 <alltraps>

80106da4 <vector18>:
.globl vector18
vector18:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $18
80106da6:	6a 12                	push   $0x12
  jmp alltraps
80106da8:	e9 14 f9 ff ff       	jmp    801066c1 <alltraps>

80106dad <vector19>:
.globl vector19
vector19:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $19
80106daf:	6a 13                	push   $0x13
  jmp alltraps
80106db1:	e9 0b f9 ff ff       	jmp    801066c1 <alltraps>

80106db6 <vector20>:
.globl vector20
vector20:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $20
80106db8:	6a 14                	push   $0x14
  jmp alltraps
80106dba:	e9 02 f9 ff ff       	jmp    801066c1 <alltraps>

80106dbf <vector21>:
.globl vector21
vector21:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $21
80106dc1:	6a 15                	push   $0x15
  jmp alltraps
80106dc3:	e9 f9 f8 ff ff       	jmp    801066c1 <alltraps>

80106dc8 <vector22>:
.globl vector22
vector22:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $22
80106dca:	6a 16                	push   $0x16
  jmp alltraps
80106dcc:	e9 f0 f8 ff ff       	jmp    801066c1 <alltraps>

80106dd1 <vector23>:
.globl vector23
vector23:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $23
80106dd3:	6a 17                	push   $0x17
  jmp alltraps
80106dd5:	e9 e7 f8 ff ff       	jmp    801066c1 <alltraps>

80106dda <vector24>:
.globl vector24
vector24:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $24
80106ddc:	6a 18                	push   $0x18
  jmp alltraps
80106dde:	e9 de f8 ff ff       	jmp    801066c1 <alltraps>

80106de3 <vector25>:
.globl vector25
vector25:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $25
80106de5:	6a 19                	push   $0x19
  jmp alltraps
80106de7:	e9 d5 f8 ff ff       	jmp    801066c1 <alltraps>

80106dec <vector26>:
.globl vector26
vector26:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $26
80106dee:	6a 1a                	push   $0x1a
  jmp alltraps
80106df0:	e9 cc f8 ff ff       	jmp    801066c1 <alltraps>

80106df5 <vector27>:
.globl vector27
vector27:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $27
80106df7:	6a 1b                	push   $0x1b
  jmp alltraps
80106df9:	e9 c3 f8 ff ff       	jmp    801066c1 <alltraps>

80106dfe <vector28>:
.globl vector28
vector28:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $28
80106e00:	6a 1c                	push   $0x1c
  jmp alltraps
80106e02:	e9 ba f8 ff ff       	jmp    801066c1 <alltraps>

80106e07 <vector29>:
.globl vector29
vector29:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $29
80106e09:	6a 1d                	push   $0x1d
  jmp alltraps
80106e0b:	e9 b1 f8 ff ff       	jmp    801066c1 <alltraps>

80106e10 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $30
80106e12:	6a 1e                	push   $0x1e
  jmp alltraps
80106e14:	e9 a8 f8 ff ff       	jmp    801066c1 <alltraps>

80106e19 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $31
80106e1b:	6a 1f                	push   $0x1f
  jmp alltraps
80106e1d:	e9 9f f8 ff ff       	jmp    801066c1 <alltraps>

80106e22 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $32
80106e24:	6a 20                	push   $0x20
  jmp alltraps
80106e26:	e9 96 f8 ff ff       	jmp    801066c1 <alltraps>

80106e2b <vector33>:
.globl vector33
vector33:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $33
80106e2d:	6a 21                	push   $0x21
  jmp alltraps
80106e2f:	e9 8d f8 ff ff       	jmp    801066c1 <alltraps>

80106e34 <vector34>:
.globl vector34
vector34:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $34
80106e36:	6a 22                	push   $0x22
  jmp alltraps
80106e38:	e9 84 f8 ff ff       	jmp    801066c1 <alltraps>

80106e3d <vector35>:
.globl vector35
vector35:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $35
80106e3f:	6a 23                	push   $0x23
  jmp alltraps
80106e41:	e9 7b f8 ff ff       	jmp    801066c1 <alltraps>

80106e46 <vector36>:
.globl vector36
vector36:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $36
80106e48:	6a 24                	push   $0x24
  jmp alltraps
80106e4a:	e9 72 f8 ff ff       	jmp    801066c1 <alltraps>

80106e4f <vector37>:
.globl vector37
vector37:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $37
80106e51:	6a 25                	push   $0x25
  jmp alltraps
80106e53:	e9 69 f8 ff ff       	jmp    801066c1 <alltraps>

80106e58 <vector38>:
.globl vector38
vector38:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $38
80106e5a:	6a 26                	push   $0x26
  jmp alltraps
80106e5c:	e9 60 f8 ff ff       	jmp    801066c1 <alltraps>

80106e61 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $39
80106e63:	6a 27                	push   $0x27
  jmp alltraps
80106e65:	e9 57 f8 ff ff       	jmp    801066c1 <alltraps>

80106e6a <vector40>:
.globl vector40
vector40:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $40
80106e6c:	6a 28                	push   $0x28
  jmp alltraps
80106e6e:	e9 4e f8 ff ff       	jmp    801066c1 <alltraps>

80106e73 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $41
80106e75:	6a 29                	push   $0x29
  jmp alltraps
80106e77:	e9 45 f8 ff ff       	jmp    801066c1 <alltraps>

80106e7c <vector42>:
.globl vector42
vector42:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $42
80106e7e:	6a 2a                	push   $0x2a
  jmp alltraps
80106e80:	e9 3c f8 ff ff       	jmp    801066c1 <alltraps>

80106e85 <vector43>:
.globl vector43
vector43:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $43
80106e87:	6a 2b                	push   $0x2b
  jmp alltraps
80106e89:	e9 33 f8 ff ff       	jmp    801066c1 <alltraps>

80106e8e <vector44>:
.globl vector44
vector44:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $44
80106e90:	6a 2c                	push   $0x2c
  jmp alltraps
80106e92:	e9 2a f8 ff ff       	jmp    801066c1 <alltraps>

80106e97 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $45
80106e99:	6a 2d                	push   $0x2d
  jmp alltraps
80106e9b:	e9 21 f8 ff ff       	jmp    801066c1 <alltraps>

80106ea0 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $46
80106ea2:	6a 2e                	push   $0x2e
  jmp alltraps
80106ea4:	e9 18 f8 ff ff       	jmp    801066c1 <alltraps>

80106ea9 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $47
80106eab:	6a 2f                	push   $0x2f
  jmp alltraps
80106ead:	e9 0f f8 ff ff       	jmp    801066c1 <alltraps>

80106eb2 <vector48>:
.globl vector48
vector48:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $48
80106eb4:	6a 30                	push   $0x30
  jmp alltraps
80106eb6:	e9 06 f8 ff ff       	jmp    801066c1 <alltraps>

80106ebb <vector49>:
.globl vector49
vector49:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $49
80106ebd:	6a 31                	push   $0x31
  jmp alltraps
80106ebf:	e9 fd f7 ff ff       	jmp    801066c1 <alltraps>

80106ec4 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $50
80106ec6:	6a 32                	push   $0x32
  jmp alltraps
80106ec8:	e9 f4 f7 ff ff       	jmp    801066c1 <alltraps>

80106ecd <vector51>:
.globl vector51
vector51:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $51
80106ecf:	6a 33                	push   $0x33
  jmp alltraps
80106ed1:	e9 eb f7 ff ff       	jmp    801066c1 <alltraps>

80106ed6 <vector52>:
.globl vector52
vector52:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $52
80106ed8:	6a 34                	push   $0x34
  jmp alltraps
80106eda:	e9 e2 f7 ff ff       	jmp    801066c1 <alltraps>

80106edf <vector53>:
.globl vector53
vector53:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $53
80106ee1:	6a 35                	push   $0x35
  jmp alltraps
80106ee3:	e9 d9 f7 ff ff       	jmp    801066c1 <alltraps>

80106ee8 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $54
80106eea:	6a 36                	push   $0x36
  jmp alltraps
80106eec:	e9 d0 f7 ff ff       	jmp    801066c1 <alltraps>

80106ef1 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $55
80106ef3:	6a 37                	push   $0x37
  jmp alltraps
80106ef5:	e9 c7 f7 ff ff       	jmp    801066c1 <alltraps>

80106efa <vector56>:
.globl vector56
vector56:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $56
80106efc:	6a 38                	push   $0x38
  jmp alltraps
80106efe:	e9 be f7 ff ff       	jmp    801066c1 <alltraps>

80106f03 <vector57>:
.globl vector57
vector57:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $57
80106f05:	6a 39                	push   $0x39
  jmp alltraps
80106f07:	e9 b5 f7 ff ff       	jmp    801066c1 <alltraps>

80106f0c <vector58>:
.globl vector58
vector58:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $58
80106f0e:	6a 3a                	push   $0x3a
  jmp alltraps
80106f10:	e9 ac f7 ff ff       	jmp    801066c1 <alltraps>

80106f15 <vector59>:
.globl vector59
vector59:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $59
80106f17:	6a 3b                	push   $0x3b
  jmp alltraps
80106f19:	e9 a3 f7 ff ff       	jmp    801066c1 <alltraps>

80106f1e <vector60>:
.globl vector60
vector60:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $60
80106f20:	6a 3c                	push   $0x3c
  jmp alltraps
80106f22:	e9 9a f7 ff ff       	jmp    801066c1 <alltraps>

80106f27 <vector61>:
.globl vector61
vector61:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $61
80106f29:	6a 3d                	push   $0x3d
  jmp alltraps
80106f2b:	e9 91 f7 ff ff       	jmp    801066c1 <alltraps>

80106f30 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $62
80106f32:	6a 3e                	push   $0x3e
  jmp alltraps
80106f34:	e9 88 f7 ff ff       	jmp    801066c1 <alltraps>

80106f39 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $63
80106f3b:	6a 3f                	push   $0x3f
  jmp alltraps
80106f3d:	e9 7f f7 ff ff       	jmp    801066c1 <alltraps>

80106f42 <vector64>:
.globl vector64
vector64:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $64
80106f44:	6a 40                	push   $0x40
  jmp alltraps
80106f46:	e9 76 f7 ff ff       	jmp    801066c1 <alltraps>

80106f4b <vector65>:
.globl vector65
vector65:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $65
80106f4d:	6a 41                	push   $0x41
  jmp alltraps
80106f4f:	e9 6d f7 ff ff       	jmp    801066c1 <alltraps>

80106f54 <vector66>:
.globl vector66
vector66:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $66
80106f56:	6a 42                	push   $0x42
  jmp alltraps
80106f58:	e9 64 f7 ff ff       	jmp    801066c1 <alltraps>

80106f5d <vector67>:
.globl vector67
vector67:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $67
80106f5f:	6a 43                	push   $0x43
  jmp alltraps
80106f61:	e9 5b f7 ff ff       	jmp    801066c1 <alltraps>

80106f66 <vector68>:
.globl vector68
vector68:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $68
80106f68:	6a 44                	push   $0x44
  jmp alltraps
80106f6a:	e9 52 f7 ff ff       	jmp    801066c1 <alltraps>

80106f6f <vector69>:
.globl vector69
vector69:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $69
80106f71:	6a 45                	push   $0x45
  jmp alltraps
80106f73:	e9 49 f7 ff ff       	jmp    801066c1 <alltraps>

80106f78 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $70
80106f7a:	6a 46                	push   $0x46
  jmp alltraps
80106f7c:	e9 40 f7 ff ff       	jmp    801066c1 <alltraps>

80106f81 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $71
80106f83:	6a 47                	push   $0x47
  jmp alltraps
80106f85:	e9 37 f7 ff ff       	jmp    801066c1 <alltraps>

80106f8a <vector72>:
.globl vector72
vector72:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $72
80106f8c:	6a 48                	push   $0x48
  jmp alltraps
80106f8e:	e9 2e f7 ff ff       	jmp    801066c1 <alltraps>

80106f93 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $73
80106f95:	6a 49                	push   $0x49
  jmp alltraps
80106f97:	e9 25 f7 ff ff       	jmp    801066c1 <alltraps>

80106f9c <vector74>:
.globl vector74
vector74:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $74
80106f9e:	6a 4a                	push   $0x4a
  jmp alltraps
80106fa0:	e9 1c f7 ff ff       	jmp    801066c1 <alltraps>

80106fa5 <vector75>:
.globl vector75
vector75:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $75
80106fa7:	6a 4b                	push   $0x4b
  jmp alltraps
80106fa9:	e9 13 f7 ff ff       	jmp    801066c1 <alltraps>

80106fae <vector76>:
.globl vector76
vector76:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $76
80106fb0:	6a 4c                	push   $0x4c
  jmp alltraps
80106fb2:	e9 0a f7 ff ff       	jmp    801066c1 <alltraps>

80106fb7 <vector77>:
.globl vector77
vector77:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $77
80106fb9:	6a 4d                	push   $0x4d
  jmp alltraps
80106fbb:	e9 01 f7 ff ff       	jmp    801066c1 <alltraps>

80106fc0 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $78
80106fc2:	6a 4e                	push   $0x4e
  jmp alltraps
80106fc4:	e9 f8 f6 ff ff       	jmp    801066c1 <alltraps>

80106fc9 <vector79>:
.globl vector79
vector79:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $79
80106fcb:	6a 4f                	push   $0x4f
  jmp alltraps
80106fcd:	e9 ef f6 ff ff       	jmp    801066c1 <alltraps>

80106fd2 <vector80>:
.globl vector80
vector80:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $80
80106fd4:	6a 50                	push   $0x50
  jmp alltraps
80106fd6:	e9 e6 f6 ff ff       	jmp    801066c1 <alltraps>

80106fdb <vector81>:
.globl vector81
vector81:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $81
80106fdd:	6a 51                	push   $0x51
  jmp alltraps
80106fdf:	e9 dd f6 ff ff       	jmp    801066c1 <alltraps>

80106fe4 <vector82>:
.globl vector82
vector82:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $82
80106fe6:	6a 52                	push   $0x52
  jmp alltraps
80106fe8:	e9 d4 f6 ff ff       	jmp    801066c1 <alltraps>

80106fed <vector83>:
.globl vector83
vector83:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $83
80106fef:	6a 53                	push   $0x53
  jmp alltraps
80106ff1:	e9 cb f6 ff ff       	jmp    801066c1 <alltraps>

80106ff6 <vector84>:
.globl vector84
vector84:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $84
80106ff8:	6a 54                	push   $0x54
  jmp alltraps
80106ffa:	e9 c2 f6 ff ff       	jmp    801066c1 <alltraps>

80106fff <vector85>:
.globl vector85
vector85:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $85
80107001:	6a 55                	push   $0x55
  jmp alltraps
80107003:	e9 b9 f6 ff ff       	jmp    801066c1 <alltraps>

80107008 <vector86>:
.globl vector86
vector86:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $86
8010700a:	6a 56                	push   $0x56
  jmp alltraps
8010700c:	e9 b0 f6 ff ff       	jmp    801066c1 <alltraps>

80107011 <vector87>:
.globl vector87
vector87:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $87
80107013:	6a 57                	push   $0x57
  jmp alltraps
80107015:	e9 a7 f6 ff ff       	jmp    801066c1 <alltraps>

8010701a <vector88>:
.globl vector88
vector88:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $88
8010701c:	6a 58                	push   $0x58
  jmp alltraps
8010701e:	e9 9e f6 ff ff       	jmp    801066c1 <alltraps>

80107023 <vector89>:
.globl vector89
vector89:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $89
80107025:	6a 59                	push   $0x59
  jmp alltraps
80107027:	e9 95 f6 ff ff       	jmp    801066c1 <alltraps>

8010702c <vector90>:
.globl vector90
vector90:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $90
8010702e:	6a 5a                	push   $0x5a
  jmp alltraps
80107030:	e9 8c f6 ff ff       	jmp    801066c1 <alltraps>

80107035 <vector91>:
.globl vector91
vector91:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $91
80107037:	6a 5b                	push   $0x5b
  jmp alltraps
80107039:	e9 83 f6 ff ff       	jmp    801066c1 <alltraps>

8010703e <vector92>:
.globl vector92
vector92:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $92
80107040:	6a 5c                	push   $0x5c
  jmp alltraps
80107042:	e9 7a f6 ff ff       	jmp    801066c1 <alltraps>

80107047 <vector93>:
.globl vector93
vector93:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $93
80107049:	6a 5d                	push   $0x5d
  jmp alltraps
8010704b:	e9 71 f6 ff ff       	jmp    801066c1 <alltraps>

80107050 <vector94>:
.globl vector94
vector94:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $94
80107052:	6a 5e                	push   $0x5e
  jmp alltraps
80107054:	e9 68 f6 ff ff       	jmp    801066c1 <alltraps>

80107059 <vector95>:
.globl vector95
vector95:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $95
8010705b:	6a 5f                	push   $0x5f
  jmp alltraps
8010705d:	e9 5f f6 ff ff       	jmp    801066c1 <alltraps>

80107062 <vector96>:
.globl vector96
vector96:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $96
80107064:	6a 60                	push   $0x60
  jmp alltraps
80107066:	e9 56 f6 ff ff       	jmp    801066c1 <alltraps>

8010706b <vector97>:
.globl vector97
vector97:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $97
8010706d:	6a 61                	push   $0x61
  jmp alltraps
8010706f:	e9 4d f6 ff ff       	jmp    801066c1 <alltraps>

80107074 <vector98>:
.globl vector98
vector98:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $98
80107076:	6a 62                	push   $0x62
  jmp alltraps
80107078:	e9 44 f6 ff ff       	jmp    801066c1 <alltraps>

8010707d <vector99>:
.globl vector99
vector99:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $99
8010707f:	6a 63                	push   $0x63
  jmp alltraps
80107081:	e9 3b f6 ff ff       	jmp    801066c1 <alltraps>

80107086 <vector100>:
.globl vector100
vector100:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $100
80107088:	6a 64                	push   $0x64
  jmp alltraps
8010708a:	e9 32 f6 ff ff       	jmp    801066c1 <alltraps>

8010708f <vector101>:
.globl vector101
vector101:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $101
80107091:	6a 65                	push   $0x65
  jmp alltraps
80107093:	e9 29 f6 ff ff       	jmp    801066c1 <alltraps>

80107098 <vector102>:
.globl vector102
vector102:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $102
8010709a:	6a 66                	push   $0x66
  jmp alltraps
8010709c:	e9 20 f6 ff ff       	jmp    801066c1 <alltraps>

801070a1 <vector103>:
.globl vector103
vector103:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $103
801070a3:	6a 67                	push   $0x67
  jmp alltraps
801070a5:	e9 17 f6 ff ff       	jmp    801066c1 <alltraps>

801070aa <vector104>:
.globl vector104
vector104:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $104
801070ac:	6a 68                	push   $0x68
  jmp alltraps
801070ae:	e9 0e f6 ff ff       	jmp    801066c1 <alltraps>

801070b3 <vector105>:
.globl vector105
vector105:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $105
801070b5:	6a 69                	push   $0x69
  jmp alltraps
801070b7:	e9 05 f6 ff ff       	jmp    801066c1 <alltraps>

801070bc <vector106>:
.globl vector106
vector106:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $106
801070be:	6a 6a                	push   $0x6a
  jmp alltraps
801070c0:	e9 fc f5 ff ff       	jmp    801066c1 <alltraps>

801070c5 <vector107>:
.globl vector107
vector107:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $107
801070c7:	6a 6b                	push   $0x6b
  jmp alltraps
801070c9:	e9 f3 f5 ff ff       	jmp    801066c1 <alltraps>

801070ce <vector108>:
.globl vector108
vector108:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $108
801070d0:	6a 6c                	push   $0x6c
  jmp alltraps
801070d2:	e9 ea f5 ff ff       	jmp    801066c1 <alltraps>

801070d7 <vector109>:
.globl vector109
vector109:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $109
801070d9:	6a 6d                	push   $0x6d
  jmp alltraps
801070db:	e9 e1 f5 ff ff       	jmp    801066c1 <alltraps>

801070e0 <vector110>:
.globl vector110
vector110:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $110
801070e2:	6a 6e                	push   $0x6e
  jmp alltraps
801070e4:	e9 d8 f5 ff ff       	jmp    801066c1 <alltraps>

801070e9 <vector111>:
.globl vector111
vector111:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $111
801070eb:	6a 6f                	push   $0x6f
  jmp alltraps
801070ed:	e9 cf f5 ff ff       	jmp    801066c1 <alltraps>

801070f2 <vector112>:
.globl vector112
vector112:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $112
801070f4:	6a 70                	push   $0x70
  jmp alltraps
801070f6:	e9 c6 f5 ff ff       	jmp    801066c1 <alltraps>

801070fb <vector113>:
.globl vector113
vector113:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $113
801070fd:	6a 71                	push   $0x71
  jmp alltraps
801070ff:	e9 bd f5 ff ff       	jmp    801066c1 <alltraps>

80107104 <vector114>:
.globl vector114
vector114:
  pushl $0
80107104:	6a 00                	push   $0x0
  pushl $114
80107106:	6a 72                	push   $0x72
  jmp alltraps
80107108:	e9 b4 f5 ff ff       	jmp    801066c1 <alltraps>

8010710d <vector115>:
.globl vector115
vector115:
  pushl $0
8010710d:	6a 00                	push   $0x0
  pushl $115
8010710f:	6a 73                	push   $0x73
  jmp alltraps
80107111:	e9 ab f5 ff ff       	jmp    801066c1 <alltraps>

80107116 <vector116>:
.globl vector116
vector116:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $116
80107118:	6a 74                	push   $0x74
  jmp alltraps
8010711a:	e9 a2 f5 ff ff       	jmp    801066c1 <alltraps>

8010711f <vector117>:
.globl vector117
vector117:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $117
80107121:	6a 75                	push   $0x75
  jmp alltraps
80107123:	e9 99 f5 ff ff       	jmp    801066c1 <alltraps>

80107128 <vector118>:
.globl vector118
vector118:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $118
8010712a:	6a 76                	push   $0x76
  jmp alltraps
8010712c:	e9 90 f5 ff ff       	jmp    801066c1 <alltraps>

80107131 <vector119>:
.globl vector119
vector119:
  pushl $0
80107131:	6a 00                	push   $0x0
  pushl $119
80107133:	6a 77                	push   $0x77
  jmp alltraps
80107135:	e9 87 f5 ff ff       	jmp    801066c1 <alltraps>

8010713a <vector120>:
.globl vector120
vector120:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $120
8010713c:	6a 78                	push   $0x78
  jmp alltraps
8010713e:	e9 7e f5 ff ff       	jmp    801066c1 <alltraps>

80107143 <vector121>:
.globl vector121
vector121:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $121
80107145:	6a 79                	push   $0x79
  jmp alltraps
80107147:	e9 75 f5 ff ff       	jmp    801066c1 <alltraps>

8010714c <vector122>:
.globl vector122
vector122:
  pushl $0
8010714c:	6a 00                	push   $0x0
  pushl $122
8010714e:	6a 7a                	push   $0x7a
  jmp alltraps
80107150:	e9 6c f5 ff ff       	jmp    801066c1 <alltraps>

80107155 <vector123>:
.globl vector123
vector123:
  pushl $0
80107155:	6a 00                	push   $0x0
  pushl $123
80107157:	6a 7b                	push   $0x7b
  jmp alltraps
80107159:	e9 63 f5 ff ff       	jmp    801066c1 <alltraps>

8010715e <vector124>:
.globl vector124
vector124:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $124
80107160:	6a 7c                	push   $0x7c
  jmp alltraps
80107162:	e9 5a f5 ff ff       	jmp    801066c1 <alltraps>

80107167 <vector125>:
.globl vector125
vector125:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $125
80107169:	6a 7d                	push   $0x7d
  jmp alltraps
8010716b:	e9 51 f5 ff ff       	jmp    801066c1 <alltraps>

80107170 <vector126>:
.globl vector126
vector126:
  pushl $0
80107170:	6a 00                	push   $0x0
  pushl $126
80107172:	6a 7e                	push   $0x7e
  jmp alltraps
80107174:	e9 48 f5 ff ff       	jmp    801066c1 <alltraps>

80107179 <vector127>:
.globl vector127
vector127:
  pushl $0
80107179:	6a 00                	push   $0x0
  pushl $127
8010717b:	6a 7f                	push   $0x7f
  jmp alltraps
8010717d:	e9 3f f5 ff ff       	jmp    801066c1 <alltraps>

80107182 <vector128>:
.globl vector128
vector128:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $128
80107184:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107189:	e9 33 f5 ff ff       	jmp    801066c1 <alltraps>

8010718e <vector129>:
.globl vector129
vector129:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $129
80107190:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107195:	e9 27 f5 ff ff       	jmp    801066c1 <alltraps>

8010719a <vector130>:
.globl vector130
vector130:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $130
8010719c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071a1:	e9 1b f5 ff ff       	jmp    801066c1 <alltraps>

801071a6 <vector131>:
.globl vector131
vector131:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $131
801071a8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071ad:	e9 0f f5 ff ff       	jmp    801066c1 <alltraps>

801071b2 <vector132>:
.globl vector132
vector132:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $132
801071b4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071b9:	e9 03 f5 ff ff       	jmp    801066c1 <alltraps>

801071be <vector133>:
.globl vector133
vector133:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $133
801071c0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071c5:	e9 f7 f4 ff ff       	jmp    801066c1 <alltraps>

801071ca <vector134>:
.globl vector134
vector134:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $134
801071cc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071d1:	e9 eb f4 ff ff       	jmp    801066c1 <alltraps>

801071d6 <vector135>:
.globl vector135
vector135:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $135
801071d8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071dd:	e9 df f4 ff ff       	jmp    801066c1 <alltraps>

801071e2 <vector136>:
.globl vector136
vector136:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $136
801071e4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071e9:	e9 d3 f4 ff ff       	jmp    801066c1 <alltraps>

801071ee <vector137>:
.globl vector137
vector137:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $137
801071f0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071f5:	e9 c7 f4 ff ff       	jmp    801066c1 <alltraps>

801071fa <vector138>:
.globl vector138
vector138:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $138
801071fc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107201:	e9 bb f4 ff ff       	jmp    801066c1 <alltraps>

80107206 <vector139>:
.globl vector139
vector139:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $139
80107208:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010720d:	e9 af f4 ff ff       	jmp    801066c1 <alltraps>

80107212 <vector140>:
.globl vector140
vector140:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $140
80107214:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107219:	e9 a3 f4 ff ff       	jmp    801066c1 <alltraps>

8010721e <vector141>:
.globl vector141
vector141:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $141
80107220:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107225:	e9 97 f4 ff ff       	jmp    801066c1 <alltraps>

8010722a <vector142>:
.globl vector142
vector142:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $142
8010722c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107231:	e9 8b f4 ff ff       	jmp    801066c1 <alltraps>

80107236 <vector143>:
.globl vector143
vector143:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $143
80107238:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010723d:	e9 7f f4 ff ff       	jmp    801066c1 <alltraps>

80107242 <vector144>:
.globl vector144
vector144:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $144
80107244:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107249:	e9 73 f4 ff ff       	jmp    801066c1 <alltraps>

8010724e <vector145>:
.globl vector145
vector145:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $145
80107250:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107255:	e9 67 f4 ff ff       	jmp    801066c1 <alltraps>

8010725a <vector146>:
.globl vector146
vector146:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $146
8010725c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107261:	e9 5b f4 ff ff       	jmp    801066c1 <alltraps>

80107266 <vector147>:
.globl vector147
vector147:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $147
80107268:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010726d:	e9 4f f4 ff ff       	jmp    801066c1 <alltraps>

80107272 <vector148>:
.globl vector148
vector148:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $148
80107274:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107279:	e9 43 f4 ff ff       	jmp    801066c1 <alltraps>

8010727e <vector149>:
.globl vector149
vector149:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $149
80107280:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107285:	e9 37 f4 ff ff       	jmp    801066c1 <alltraps>

8010728a <vector150>:
.globl vector150
vector150:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $150
8010728c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107291:	e9 2b f4 ff ff       	jmp    801066c1 <alltraps>

80107296 <vector151>:
.globl vector151
vector151:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $151
80107298:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010729d:	e9 1f f4 ff ff       	jmp    801066c1 <alltraps>

801072a2 <vector152>:
.globl vector152
vector152:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $152
801072a4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072a9:	e9 13 f4 ff ff       	jmp    801066c1 <alltraps>

801072ae <vector153>:
.globl vector153
vector153:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $153
801072b0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072b5:	e9 07 f4 ff ff       	jmp    801066c1 <alltraps>

801072ba <vector154>:
.globl vector154
vector154:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $154
801072bc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072c1:	e9 fb f3 ff ff       	jmp    801066c1 <alltraps>

801072c6 <vector155>:
.globl vector155
vector155:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $155
801072c8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072cd:	e9 ef f3 ff ff       	jmp    801066c1 <alltraps>

801072d2 <vector156>:
.globl vector156
vector156:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $156
801072d4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072d9:	e9 e3 f3 ff ff       	jmp    801066c1 <alltraps>

801072de <vector157>:
.globl vector157
vector157:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $157
801072e0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072e5:	e9 d7 f3 ff ff       	jmp    801066c1 <alltraps>

801072ea <vector158>:
.globl vector158
vector158:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $158
801072ec:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072f1:	e9 cb f3 ff ff       	jmp    801066c1 <alltraps>

801072f6 <vector159>:
.globl vector159
vector159:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $159
801072f8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072fd:	e9 bf f3 ff ff       	jmp    801066c1 <alltraps>

80107302 <vector160>:
.globl vector160
vector160:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $160
80107304:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107309:	e9 b3 f3 ff ff       	jmp    801066c1 <alltraps>

8010730e <vector161>:
.globl vector161
vector161:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $161
80107310:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107315:	e9 a7 f3 ff ff       	jmp    801066c1 <alltraps>

8010731a <vector162>:
.globl vector162
vector162:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $162
8010731c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107321:	e9 9b f3 ff ff       	jmp    801066c1 <alltraps>

80107326 <vector163>:
.globl vector163
vector163:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $163
80107328:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010732d:	e9 8f f3 ff ff       	jmp    801066c1 <alltraps>

80107332 <vector164>:
.globl vector164
vector164:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $164
80107334:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107339:	e9 83 f3 ff ff       	jmp    801066c1 <alltraps>

8010733e <vector165>:
.globl vector165
vector165:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $165
80107340:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107345:	e9 77 f3 ff ff       	jmp    801066c1 <alltraps>

8010734a <vector166>:
.globl vector166
vector166:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $166
8010734c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107351:	e9 6b f3 ff ff       	jmp    801066c1 <alltraps>

80107356 <vector167>:
.globl vector167
vector167:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $167
80107358:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010735d:	e9 5f f3 ff ff       	jmp    801066c1 <alltraps>

80107362 <vector168>:
.globl vector168
vector168:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $168
80107364:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107369:	e9 53 f3 ff ff       	jmp    801066c1 <alltraps>

8010736e <vector169>:
.globl vector169
vector169:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $169
80107370:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107375:	e9 47 f3 ff ff       	jmp    801066c1 <alltraps>

8010737a <vector170>:
.globl vector170
vector170:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $170
8010737c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107381:	e9 3b f3 ff ff       	jmp    801066c1 <alltraps>

80107386 <vector171>:
.globl vector171
vector171:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $171
80107388:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010738d:	e9 2f f3 ff ff       	jmp    801066c1 <alltraps>

80107392 <vector172>:
.globl vector172
vector172:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $172
80107394:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107399:	e9 23 f3 ff ff       	jmp    801066c1 <alltraps>

8010739e <vector173>:
.globl vector173
vector173:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $173
801073a0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073a5:	e9 17 f3 ff ff       	jmp    801066c1 <alltraps>

801073aa <vector174>:
.globl vector174
vector174:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $174
801073ac:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073b1:	e9 0b f3 ff ff       	jmp    801066c1 <alltraps>

801073b6 <vector175>:
.globl vector175
vector175:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $175
801073b8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073bd:	e9 ff f2 ff ff       	jmp    801066c1 <alltraps>

801073c2 <vector176>:
.globl vector176
vector176:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $176
801073c4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073c9:	e9 f3 f2 ff ff       	jmp    801066c1 <alltraps>

801073ce <vector177>:
.globl vector177
vector177:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $177
801073d0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073d5:	e9 e7 f2 ff ff       	jmp    801066c1 <alltraps>

801073da <vector178>:
.globl vector178
vector178:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $178
801073dc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073e1:	e9 db f2 ff ff       	jmp    801066c1 <alltraps>

801073e6 <vector179>:
.globl vector179
vector179:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $179
801073e8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073ed:	e9 cf f2 ff ff       	jmp    801066c1 <alltraps>

801073f2 <vector180>:
.globl vector180
vector180:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $180
801073f4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073f9:	e9 c3 f2 ff ff       	jmp    801066c1 <alltraps>

801073fe <vector181>:
.globl vector181
vector181:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $181
80107400:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107405:	e9 b7 f2 ff ff       	jmp    801066c1 <alltraps>

8010740a <vector182>:
.globl vector182
vector182:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $182
8010740c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107411:	e9 ab f2 ff ff       	jmp    801066c1 <alltraps>

80107416 <vector183>:
.globl vector183
vector183:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $183
80107418:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010741d:	e9 9f f2 ff ff       	jmp    801066c1 <alltraps>

80107422 <vector184>:
.globl vector184
vector184:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $184
80107424:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107429:	e9 93 f2 ff ff       	jmp    801066c1 <alltraps>

8010742e <vector185>:
.globl vector185
vector185:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $185
80107430:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107435:	e9 87 f2 ff ff       	jmp    801066c1 <alltraps>

8010743a <vector186>:
.globl vector186
vector186:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $186
8010743c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107441:	e9 7b f2 ff ff       	jmp    801066c1 <alltraps>

80107446 <vector187>:
.globl vector187
vector187:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $187
80107448:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010744d:	e9 6f f2 ff ff       	jmp    801066c1 <alltraps>

80107452 <vector188>:
.globl vector188
vector188:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $188
80107454:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107459:	e9 63 f2 ff ff       	jmp    801066c1 <alltraps>

8010745e <vector189>:
.globl vector189
vector189:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $189
80107460:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107465:	e9 57 f2 ff ff       	jmp    801066c1 <alltraps>

8010746a <vector190>:
.globl vector190
vector190:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $190
8010746c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107471:	e9 4b f2 ff ff       	jmp    801066c1 <alltraps>

80107476 <vector191>:
.globl vector191
vector191:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $191
80107478:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010747d:	e9 3f f2 ff ff       	jmp    801066c1 <alltraps>

80107482 <vector192>:
.globl vector192
vector192:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $192
80107484:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107489:	e9 33 f2 ff ff       	jmp    801066c1 <alltraps>

8010748e <vector193>:
.globl vector193
vector193:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $193
80107490:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107495:	e9 27 f2 ff ff       	jmp    801066c1 <alltraps>

8010749a <vector194>:
.globl vector194
vector194:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $194
8010749c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074a1:	e9 1b f2 ff ff       	jmp    801066c1 <alltraps>

801074a6 <vector195>:
.globl vector195
vector195:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $195
801074a8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074ad:	e9 0f f2 ff ff       	jmp    801066c1 <alltraps>

801074b2 <vector196>:
.globl vector196
vector196:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $196
801074b4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074b9:	e9 03 f2 ff ff       	jmp    801066c1 <alltraps>

801074be <vector197>:
.globl vector197
vector197:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $197
801074c0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074c5:	e9 f7 f1 ff ff       	jmp    801066c1 <alltraps>

801074ca <vector198>:
.globl vector198
vector198:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $198
801074cc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074d1:	e9 eb f1 ff ff       	jmp    801066c1 <alltraps>

801074d6 <vector199>:
.globl vector199
vector199:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $199
801074d8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074dd:	e9 df f1 ff ff       	jmp    801066c1 <alltraps>

801074e2 <vector200>:
.globl vector200
vector200:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $200
801074e4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074e9:	e9 d3 f1 ff ff       	jmp    801066c1 <alltraps>

801074ee <vector201>:
.globl vector201
vector201:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $201
801074f0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074f5:	e9 c7 f1 ff ff       	jmp    801066c1 <alltraps>

801074fa <vector202>:
.globl vector202
vector202:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $202
801074fc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107501:	e9 bb f1 ff ff       	jmp    801066c1 <alltraps>

80107506 <vector203>:
.globl vector203
vector203:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $203
80107508:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010750d:	e9 af f1 ff ff       	jmp    801066c1 <alltraps>

80107512 <vector204>:
.globl vector204
vector204:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $204
80107514:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107519:	e9 a3 f1 ff ff       	jmp    801066c1 <alltraps>

8010751e <vector205>:
.globl vector205
vector205:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $205
80107520:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107525:	e9 97 f1 ff ff       	jmp    801066c1 <alltraps>

8010752a <vector206>:
.globl vector206
vector206:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $206
8010752c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107531:	e9 8b f1 ff ff       	jmp    801066c1 <alltraps>

80107536 <vector207>:
.globl vector207
vector207:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $207
80107538:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010753d:	e9 7f f1 ff ff       	jmp    801066c1 <alltraps>

80107542 <vector208>:
.globl vector208
vector208:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $208
80107544:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107549:	e9 73 f1 ff ff       	jmp    801066c1 <alltraps>

8010754e <vector209>:
.globl vector209
vector209:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $209
80107550:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107555:	e9 67 f1 ff ff       	jmp    801066c1 <alltraps>

8010755a <vector210>:
.globl vector210
vector210:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $210
8010755c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107561:	e9 5b f1 ff ff       	jmp    801066c1 <alltraps>

80107566 <vector211>:
.globl vector211
vector211:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $211
80107568:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010756d:	e9 4f f1 ff ff       	jmp    801066c1 <alltraps>

80107572 <vector212>:
.globl vector212
vector212:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $212
80107574:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107579:	e9 43 f1 ff ff       	jmp    801066c1 <alltraps>

8010757e <vector213>:
.globl vector213
vector213:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $213
80107580:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107585:	e9 37 f1 ff ff       	jmp    801066c1 <alltraps>

8010758a <vector214>:
.globl vector214
vector214:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $214
8010758c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107591:	e9 2b f1 ff ff       	jmp    801066c1 <alltraps>

80107596 <vector215>:
.globl vector215
vector215:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $215
80107598:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010759d:	e9 1f f1 ff ff       	jmp    801066c1 <alltraps>

801075a2 <vector216>:
.globl vector216
vector216:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $216
801075a4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075a9:	e9 13 f1 ff ff       	jmp    801066c1 <alltraps>

801075ae <vector217>:
.globl vector217
vector217:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $217
801075b0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075b5:	e9 07 f1 ff ff       	jmp    801066c1 <alltraps>

801075ba <vector218>:
.globl vector218
vector218:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $218
801075bc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075c1:	e9 fb f0 ff ff       	jmp    801066c1 <alltraps>

801075c6 <vector219>:
.globl vector219
vector219:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $219
801075c8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075cd:	e9 ef f0 ff ff       	jmp    801066c1 <alltraps>

801075d2 <vector220>:
.globl vector220
vector220:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $220
801075d4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075d9:	e9 e3 f0 ff ff       	jmp    801066c1 <alltraps>

801075de <vector221>:
.globl vector221
vector221:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $221
801075e0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075e5:	e9 d7 f0 ff ff       	jmp    801066c1 <alltraps>

801075ea <vector222>:
.globl vector222
vector222:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $222
801075ec:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075f1:	e9 cb f0 ff ff       	jmp    801066c1 <alltraps>

801075f6 <vector223>:
.globl vector223
vector223:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $223
801075f8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075fd:	e9 bf f0 ff ff       	jmp    801066c1 <alltraps>

80107602 <vector224>:
.globl vector224
vector224:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $224
80107604:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107609:	e9 b3 f0 ff ff       	jmp    801066c1 <alltraps>

8010760e <vector225>:
.globl vector225
vector225:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $225
80107610:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107615:	e9 a7 f0 ff ff       	jmp    801066c1 <alltraps>

8010761a <vector226>:
.globl vector226
vector226:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $226
8010761c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107621:	e9 9b f0 ff ff       	jmp    801066c1 <alltraps>

80107626 <vector227>:
.globl vector227
vector227:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $227
80107628:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010762d:	e9 8f f0 ff ff       	jmp    801066c1 <alltraps>

80107632 <vector228>:
.globl vector228
vector228:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $228
80107634:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107639:	e9 83 f0 ff ff       	jmp    801066c1 <alltraps>

8010763e <vector229>:
.globl vector229
vector229:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $229
80107640:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107645:	e9 77 f0 ff ff       	jmp    801066c1 <alltraps>

8010764a <vector230>:
.globl vector230
vector230:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $230
8010764c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107651:	e9 6b f0 ff ff       	jmp    801066c1 <alltraps>

80107656 <vector231>:
.globl vector231
vector231:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $231
80107658:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010765d:	e9 5f f0 ff ff       	jmp    801066c1 <alltraps>

80107662 <vector232>:
.globl vector232
vector232:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $232
80107664:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107669:	e9 53 f0 ff ff       	jmp    801066c1 <alltraps>

8010766e <vector233>:
.globl vector233
vector233:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $233
80107670:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107675:	e9 47 f0 ff ff       	jmp    801066c1 <alltraps>

8010767a <vector234>:
.globl vector234
vector234:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $234
8010767c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107681:	e9 3b f0 ff ff       	jmp    801066c1 <alltraps>

80107686 <vector235>:
.globl vector235
vector235:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $235
80107688:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010768d:	e9 2f f0 ff ff       	jmp    801066c1 <alltraps>

80107692 <vector236>:
.globl vector236
vector236:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $236
80107694:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107699:	e9 23 f0 ff ff       	jmp    801066c1 <alltraps>

8010769e <vector237>:
.globl vector237
vector237:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $237
801076a0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076a5:	e9 17 f0 ff ff       	jmp    801066c1 <alltraps>

801076aa <vector238>:
.globl vector238
vector238:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $238
801076ac:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076b1:	e9 0b f0 ff ff       	jmp    801066c1 <alltraps>

801076b6 <vector239>:
.globl vector239
vector239:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $239
801076b8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076bd:	e9 ff ef ff ff       	jmp    801066c1 <alltraps>

801076c2 <vector240>:
.globl vector240
vector240:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $240
801076c4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076c9:	e9 f3 ef ff ff       	jmp    801066c1 <alltraps>

801076ce <vector241>:
.globl vector241
vector241:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $241
801076d0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076d5:	e9 e7 ef ff ff       	jmp    801066c1 <alltraps>

801076da <vector242>:
.globl vector242
vector242:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $242
801076dc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076e1:	e9 db ef ff ff       	jmp    801066c1 <alltraps>

801076e6 <vector243>:
.globl vector243
vector243:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $243
801076e8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076ed:	e9 cf ef ff ff       	jmp    801066c1 <alltraps>

801076f2 <vector244>:
.globl vector244
vector244:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $244
801076f4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076f9:	e9 c3 ef ff ff       	jmp    801066c1 <alltraps>

801076fe <vector245>:
.globl vector245
vector245:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $245
80107700:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107705:	e9 b7 ef ff ff       	jmp    801066c1 <alltraps>

8010770a <vector246>:
.globl vector246
vector246:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $246
8010770c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107711:	e9 ab ef ff ff       	jmp    801066c1 <alltraps>

80107716 <vector247>:
.globl vector247
vector247:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $247
80107718:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010771d:	e9 9f ef ff ff       	jmp    801066c1 <alltraps>

80107722 <vector248>:
.globl vector248
vector248:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $248
80107724:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107729:	e9 93 ef ff ff       	jmp    801066c1 <alltraps>

8010772e <vector249>:
.globl vector249
vector249:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $249
80107730:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107735:	e9 87 ef ff ff       	jmp    801066c1 <alltraps>

8010773a <vector250>:
.globl vector250
vector250:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $250
8010773c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107741:	e9 7b ef ff ff       	jmp    801066c1 <alltraps>

80107746 <vector251>:
.globl vector251
vector251:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $251
80107748:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010774d:	e9 6f ef ff ff       	jmp    801066c1 <alltraps>

80107752 <vector252>:
.globl vector252
vector252:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $252
80107754:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107759:	e9 63 ef ff ff       	jmp    801066c1 <alltraps>

8010775e <vector253>:
.globl vector253
vector253:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $253
80107760:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107765:	e9 57 ef ff ff       	jmp    801066c1 <alltraps>

8010776a <vector254>:
.globl vector254
vector254:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $254
8010776c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107771:	e9 4b ef ff ff       	jmp    801066c1 <alltraps>

80107776 <vector255>:
.globl vector255
vector255:
  pushl $0
80107776:	6a 00                	push   $0x0
  pushl $255
80107778:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010777d:	e9 3f ef ff ff       	jmp    801066c1 <alltraps>

80107782 <lgdt>:
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;
80107782:	55                   	push   %ebp
80107783:	89 e5                	mov    %esp,%ebp
80107785:	83 ec 10             	sub    $0x10,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107788:	8b 45 0c             	mov    0xc(%ebp),%eax
8010778b:	83 e8 01             	sub    $0x1,%eax
8010778e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  for(;;){
80107792:	8b 45 08             	mov    0x8(%ebp),%eax
80107795:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107799:	8b 45 08             	mov    0x8(%ebp),%eax
8010779c:	c1 e8 10             	shr    $0x10,%eax
8010779f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
      return -1;
    if(*pte & PTE_P)
801077a3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801077a6:	0f 01 10             	lgdtl  (%eax)
      panic("remap");
801077a9:	90                   	nop
801077aa:	c9                   	leave
801077ab:	c3                   	ret

801077ac <ltr>:
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
801077ac:	55                   	push   %ebp
801077ad:	89 e5                	mov    %esp,%ebp
801077af:	83 ec 04             	sub    $0x4,%esp
801077b2:	8b 45 08             	mov    0x8(%ebp),%eax
801077b5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
//                phys memory allocated by the kernel
801077b9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077bd:	0f 00 d8             	ltr    %eax
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
801077c0:	90                   	nop
801077c1:	c9                   	leave
801077c2:	c3                   	ret

801077c3 <lcr3>:
// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
801077c3:	55                   	push   %ebp
801077c4:	89 e5                	mov    %esp,%ebp
  switchkvm();
801077c6:	8b 45 08             	mov    0x8(%ebp),%eax
801077c9:	0f 22 d8             	mov    %eax,%cr3
}
801077cc:	90                   	nop
801077cd:	5d                   	pop    %ebp
801077ce:	c3                   	ret

801077cf <seginit>:
{
801077cf:	55                   	push   %ebp
801077d0:	89 e5                	mov    %esp,%ebp
801077d2:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077d5:	e8 68 cb ff ff       	call   80104342 <cpuid>
801077da:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801077e0:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
801077e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077eb:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fd:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107804:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107808:	83 e2 f0             	and    $0xfffffff0,%edx
8010780b:	83 ca 0a             	or     $0xa,%edx
8010780e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107814:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107818:	83 ca 10             	or     $0x10,%edx
8010781b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010781e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107821:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107825:	83 e2 9f             	and    $0xffffff9f,%edx
80107828:	88 50 7d             	mov    %dl,0x7d(%eax)
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107832:	83 ca 80             	or     $0xffffff80,%edx
80107835:	88 50 7d             	mov    %dl,0x7d(%eax)
80107838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010783f:	83 ca 0f             	or     $0xf,%edx
80107842:	88 50 7e             	mov    %dl,0x7e(%eax)
80107845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107848:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010784c:	83 e2 ef             	and    $0xffffffef,%edx
8010784f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107855:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107859:	83 e2 df             	and    $0xffffffdf,%edx
8010785c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010785f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107862:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107866:	83 ca 40             	or     $0x40,%edx
80107869:	88 50 7e             	mov    %dl,0x7e(%eax)
8010786c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107873:	83 ca 80             	or     $0xffffff80,%edx
80107876:	88 50 7e             	mov    %dl,0x7e(%eax)
80107879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107883:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010788a:	ff ff 
8010788c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107896:	00 00 
80107898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801078a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078ac:	83 e2 f0             	and    $0xfffffff0,%edx
801078af:	83 ca 02             	or     $0x2,%edx
801078b2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078c2:	83 ca 10             	or     $0x10,%edx
801078c5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ce:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078d5:	83 e2 9f             	and    $0xffffff9f,%edx
801078d8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078e8:	83 ca 80             	or     $0xffffff80,%edx
801078eb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078fb:	83 ca 0f             	or     $0xf,%edx
801078fe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107907:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010790e:	83 e2 ef             	and    $0xffffffef,%edx
80107911:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107921:	83 e2 df             	and    $0xffffffdf,%edx
80107924:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010792a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107934:	83 ca 40             	or     $0x40,%edx
80107937:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010793d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107940:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107947:	83 ca 80             	or     $0xffffff80,%edx
8010794a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107953:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010795a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795d:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107964:	ff ff 
80107966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107969:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107970:	00 00 
80107972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107975:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010797c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107986:	83 e2 f0             	and    $0xfffffff0,%edx
80107989:	83 ca 0a             	or     $0xa,%edx
8010798c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107995:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010799c:	83 ca 10             	or     $0x10,%edx
8010799f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079af:	83 ca 60             	or     $0x60,%edx
801079b2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079c2:	83 ca 80             	or     $0xffffff80,%edx
801079c5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ce:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079d5:	83 ca 0f             	or     $0xf,%edx
801079d8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079e8:	83 e2 ef             	and    $0xffffffef,%edx
801079eb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079fb:	83 e2 df             	and    $0xffffffdf,%edx
801079fe:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a07:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a0e:	83 ca 40             	or     $0x40,%edx
80107a11:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a21:	83 ca 80             	or     $0xffffff80,%edx
80107a24:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2d:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a37:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a3e:	ff ff 
80107a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a43:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a4a:	00 00 
80107a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a59:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a60:	83 e2 f0             	and    $0xfffffff0,%edx
80107a63:	83 ca 02             	or     $0x2,%edx
80107a66:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a76:	83 ca 10             	or     $0x10,%edx
80107a79:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a82:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a89:	83 ca 60             	or     $0x60,%edx
80107a8c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a95:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a9c:	83 ca 80             	or     $0xffffff80,%edx
80107a9f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107aaf:	83 ca 0f             	or     $0xf,%edx
80107ab2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ac2:	83 e2 ef             	and    $0xffffffef,%edx
80107ac5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ace:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ad5:	83 e2 df             	and    $0xffffffdf,%edx
80107ad8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ae8:	83 ca 40             	or     $0x40,%edx
80107aeb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107afb:	83 ca 80             	or     $0xffffff80,%edx
80107afe:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b07:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b11:	83 c0 70             	add    $0x70,%eax
80107b14:	83 ec 08             	sub    $0x8,%esp
80107b17:	6a 30                	push   $0x30
80107b19:	50                   	push   %eax
80107b1a:	e8 63 fc ff ff       	call   80107782 <lgdt>
80107b1f:	83 c4 10             	add    $0x10,%esp
}
80107b22:	90                   	nop
80107b23:	c9                   	leave
80107b24:	c3                   	ret

80107b25 <walkpgdir>:
{
80107b25:	55                   	push   %ebp
80107b26:	89 e5                	mov    %esp,%ebp
80107b28:	83 ec 18             	sub    $0x18,%esp
  pde = &pgdir[PDX(va)];
80107b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b2e:	c1 e8 16             	shr    $0x16,%eax
80107b31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b38:	8b 45 08             	mov    0x8(%ebp),%eax
80107b3b:	01 d0                	add    %edx,%eax
80107b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b43:	8b 00                	mov    (%eax),%eax
80107b45:	83 e0 01             	and    $0x1,%eax
80107b48:	85 c0                	test   %eax,%eax
80107b4a:	74 14                	je     80107b60 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b4f:	8b 00                	mov    (%eax),%eax
80107b51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b56:	05 00 00 00 80       	add    $0x80000000,%eax
80107b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b5e:	eb 42                	jmp    80107ba2 <walkpgdir+0x7d>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b64:	74 0e                	je     80107b74 <walkpgdir+0x4f>
80107b66:	e8 af b1 ff ff       	call   80102d1a <kalloc>
80107b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b72:	75 07                	jne    80107b7b <walkpgdir+0x56>
      return 0;
80107b74:	b8 00 00 00 00       	mov    $0x0,%eax
80107b79:	eb 3e                	jmp    80107bb9 <walkpgdir+0x94>
    memset(pgtab, 0, PGSIZE);
80107b7b:	83 ec 04             	sub    $0x4,%esp
80107b7e:	68 00 10 00 00       	push   $0x1000
80107b83:	6a 00                	push   $0x0
80107b85:	ff 75 f4             	push   -0xc(%ebp)
80107b88:	e8 b8 d7 ff ff       	call   80105345 <memset>
80107b8d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b93:	05 00 00 00 80       	add    $0x80000000,%eax
80107b98:	83 c8 07             	or     $0x7,%eax
80107b9b:	89 c2                	mov    %eax,%edx
80107b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ba0:	89 10                	mov    %edx,(%eax)
  return &pgtab[PTX(va)];
80107ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba5:	c1 e8 0c             	shr    $0xc,%eax
80107ba8:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb7:	01 d0                	add    %edx,%eax
}
80107bb9:	c9                   	leave
80107bba:	c3                   	ret

80107bbb <mappages>:
{
80107bbb:	55                   	push   %ebp
80107bbc:	89 e5                	mov    %esp,%ebp
80107bbe:	83 ec 18             	sub    $0x18,%esp
  a = (char*)PGROUNDDOWN((uint)va);
80107bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bcf:	8b 45 10             	mov    0x10(%ebp),%eax
80107bd2:	01 d0                	add    %edx,%eax
80107bd4:	83 e8 01             	sub    $0x1,%eax
80107bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bdf:	83 ec 04             	sub    $0x4,%esp
80107be2:	6a 01                	push   $0x1
80107be4:	ff 75 f4             	push   -0xc(%ebp)
80107be7:	ff 75 08             	push   0x8(%ebp)
80107bea:	e8 36 ff ff ff       	call   80107b25 <walkpgdir>
80107bef:	83 c4 10             	add    $0x10,%esp
80107bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bf9:	75 07                	jne    80107c02 <mappages+0x47>
      return -1;
80107bfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c00:	eb 47                	jmp    80107c49 <mappages+0x8e>
    if(*pte & PTE_P)
80107c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c05:	8b 00                	mov    (%eax),%eax
80107c07:	83 e0 01             	and    $0x1,%eax
80107c0a:	85 c0                	test   %eax,%eax
80107c0c:	74 0d                	je     80107c1b <mappages+0x60>
      panic("remap");
80107c0e:	83 ec 0c             	sub    $0xc,%esp
80107c11:	68 f0 8c 10 80       	push   $0x80108cf0
80107c16:	e8 98 89 ff ff       	call   801005b3 <panic>
    *pte = pa | perm | PTE_P;
80107c1b:	8b 45 18             	mov    0x18(%ebp),%eax
80107c1e:	0b 45 14             	or     0x14(%ebp),%eax
80107c21:	83 c8 01             	or     $0x1,%eax
80107c24:	89 c2                	mov    %eax,%edx
80107c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c29:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c31:	74 10                	je     80107c43 <mappages+0x88>
    a += PGSIZE;
80107c33:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c3a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c41:	eb 9c                	jmp    80107bdf <mappages+0x24>
      break;
80107c43:	90                   	nop
  return 0;
80107c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c49:	c9                   	leave
80107c4a:	c3                   	ret

80107c4b <setupkvm>:
{
80107c4b:	55                   	push   %ebp
80107c4c:	89 e5                	mov    %esp,%ebp
80107c4e:	53                   	push   %ebx
80107c4f:	83 ec 14             	sub    $0x14,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80107c52:	e8 c3 b0 ff ff       	call   80102d1a <kalloc>
80107c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c5e:	75 07                	jne    80107c67 <setupkvm+0x1c>
    return 0;
80107c60:	b8 00 00 00 00       	mov    $0x0,%eax
80107c65:	eb 78                	jmp    80107cdf <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
80107c67:	83 ec 04             	sub    $0x4,%esp
80107c6a:	68 00 10 00 00       	push   $0x1000
80107c6f:	6a 00                	push   $0x0
80107c71:	ff 75 f0             	push   -0x10(%ebp)
80107c74:	e8 cc d6 ff ff       	call   80105345 <memset>
80107c79:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c7c:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107c83:	eb 4e                	jmp    80107cd3 <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c88:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8e:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c94:	8b 58 08             	mov    0x8(%eax),%ebx
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	8b 40 04             	mov    0x4(%eax),%eax
80107c9d:	29 c3                	sub    %eax,%ebx
80107c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca2:	8b 00                	mov    (%eax),%eax
80107ca4:	83 ec 0c             	sub    $0xc,%esp
80107ca7:	51                   	push   %ecx
80107ca8:	52                   	push   %edx
80107ca9:	53                   	push   %ebx
80107caa:	50                   	push   %eax
80107cab:	ff 75 f0             	push   -0x10(%ebp)
80107cae:	e8 08 ff ff ff       	call   80107bbb <mappages>
80107cb3:	83 c4 20             	add    $0x20,%esp
80107cb6:	85 c0                	test   %eax,%eax
80107cb8:	79 15                	jns    80107ccf <setupkvm+0x84>
      freevm(pgdir);
80107cba:	83 ec 0c             	sub    $0xc,%esp
80107cbd:	ff 75 f0             	push   -0x10(%ebp)
80107cc0:	e8 f5 04 00 00       	call   801081ba <freevm>
80107cc5:	83 c4 10             	add    $0x10,%esp
      return 0;
80107cc8:	b8 00 00 00 00       	mov    $0x0,%eax
80107ccd:	eb 10                	jmp    80107cdf <setupkvm+0x94>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ccf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107cd3:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107cda:	72 a9                	jb     80107c85 <setupkvm+0x3a>
  return pgdir;
80107cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107cdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107ce2:	c9                   	leave
80107ce3:	c3                   	ret

80107ce4 <kvmalloc>:
{
80107ce4:	55                   	push   %ebp
80107ce5:	89 e5                	mov    %esp,%ebp
80107ce7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107cea:	e8 5c ff ff ff       	call   80107c4b <setupkvm>
80107cef:	a3 dc d4 14 80       	mov    %eax,0x8014d4dc
  switchkvm();
80107cf4:	e8 03 00 00 00       	call   80107cfc <switchkvm>
}
80107cf9:	90                   	nop
80107cfa:	c9                   	leave
80107cfb:	c3                   	ret

80107cfc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107cfc:	55                   	push   %ebp
80107cfd:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cff:	a1 dc d4 14 80       	mov    0x8014d4dc,%eax
80107d04:	05 00 00 00 80       	add    $0x80000000,%eax
80107d09:	50                   	push   %eax
80107d0a:	e8 b4 fa ff ff       	call   801077c3 <lcr3>
80107d0f:	83 c4 04             	add    $0x4,%esp
}
80107d12:	90                   	nop
80107d13:	c9                   	leave
80107d14:	c3                   	ret

80107d15 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d15:	55                   	push   %ebp
80107d16:	89 e5                	mov    %esp,%ebp
80107d18:	56                   	push   %esi
80107d19:	53                   	push   %ebx
80107d1a:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d21:	75 0d                	jne    80107d30 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107d23:	83 ec 0c             	sub    $0xc,%esp
80107d26:	68 f6 8c 10 80       	push   $0x80108cf6
80107d2b:	e8 83 88 ff ff       	call   801005b3 <panic>
  if(p->kstack == 0)
80107d30:	8b 45 08             	mov    0x8(%ebp),%eax
80107d33:	8b 40 08             	mov    0x8(%eax),%eax
80107d36:	85 c0                	test   %eax,%eax
80107d38:	75 0d                	jne    80107d47 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107d3a:	83 ec 0c             	sub    $0xc,%esp
80107d3d:	68 0c 8d 10 80       	push   $0x80108d0c
80107d42:	e8 6c 88 ff ff       	call   801005b3 <panic>
  if(p->pgdir == 0)
80107d47:	8b 45 08             	mov    0x8(%ebp),%eax
80107d4a:	8b 40 04             	mov    0x4(%eax),%eax
80107d4d:	85 c0                	test   %eax,%eax
80107d4f:	75 0d                	jne    80107d5e <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107d51:	83 ec 0c             	sub    $0xc,%esp
80107d54:	68 21 8d 10 80       	push   $0x80108d21
80107d59:	e8 55 88 ff ff       	call   801005b3 <panic>

  pushcli();
80107d5e:	e8 d7 d4 ff ff       	call   8010523a <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d63:	e8 f5 c5 ff ff       	call   8010435d <mycpu>
80107d68:	89 c3                	mov    %eax,%ebx
80107d6a:	e8 ee c5 ff ff       	call   8010435d <mycpu>
80107d6f:	83 c0 08             	add    $0x8,%eax
80107d72:	89 c6                	mov    %eax,%esi
80107d74:	e8 e4 c5 ff ff       	call   8010435d <mycpu>
80107d79:	83 c0 08             	add    $0x8,%eax
80107d7c:	c1 e8 10             	shr    $0x10,%eax
80107d7f:	88 45 f7             	mov    %al,-0x9(%ebp)
80107d82:	e8 d6 c5 ff ff       	call   8010435d <mycpu>
80107d87:	83 c0 08             	add    $0x8,%eax
80107d8a:	c1 e8 18             	shr    $0x18,%eax
80107d8d:	89 c2                	mov    %eax,%edx
80107d8f:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107d96:	67 00 
80107d98:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107d9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107da3:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107da9:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107db0:	83 e0 f0             	and    $0xfffffff0,%eax
80107db3:	83 c8 09             	or     $0x9,%eax
80107db6:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107dbc:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107dc3:	83 c8 10             	or     $0x10,%eax
80107dc6:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107dcc:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107dd3:	83 e0 9f             	and    $0xffffff9f,%eax
80107dd6:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107ddc:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107de3:	83 c8 80             	or     $0xffffff80,%eax
80107de6:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107dec:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107df3:	83 e0 f0             	and    $0xfffffff0,%eax
80107df6:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107dfc:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107e03:	83 e0 ef             	and    $0xffffffef,%eax
80107e06:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107e0c:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107e13:	83 e0 df             	and    $0xffffffdf,%eax
80107e16:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107e1c:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107e23:	83 c8 40             	or     $0x40,%eax
80107e26:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107e2c:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107e33:	83 e0 7f             	and    $0x7f,%eax
80107e36:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107e3c:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107e42:	e8 16 c5 ff ff       	call   8010435d <mycpu>
80107e47:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e4e:	83 e2 ef             	and    $0xffffffef,%edx
80107e51:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e57:	e8 01 c5 ff ff       	call   8010435d <mycpu>
80107e5c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e62:	8b 45 08             	mov    0x8(%ebp),%eax
80107e65:	8b 40 08             	mov    0x8(%eax),%eax
80107e68:	89 c3                	mov    %eax,%ebx
80107e6a:	e8 ee c4 ff ff       	call   8010435d <mycpu>
80107e6f:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107e75:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e78:	e8 e0 c4 ff ff       	call   8010435d <mycpu>
80107e7d:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107e83:	83 ec 0c             	sub    $0xc,%esp
80107e86:	6a 28                	push   $0x28
80107e88:	e8 1f f9 ff ff       	call   801077ac <ltr>
80107e8d:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107e90:	8b 45 08             	mov    0x8(%ebp),%eax
80107e93:	8b 40 04             	mov    0x4(%eax),%eax
80107e96:	05 00 00 00 80       	add    $0x80000000,%eax
80107e9b:	83 ec 0c             	sub    $0xc,%esp
80107e9e:	50                   	push   %eax
80107e9f:	e8 1f f9 ff ff       	call   801077c3 <lcr3>
80107ea4:	83 c4 10             	add    $0x10,%esp
  popcli();
80107ea7:	e8 db d3 ff ff       	call   80105287 <popcli>
}
80107eac:	90                   	nop
80107ead:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107eb0:	5b                   	pop    %ebx
80107eb1:	5e                   	pop    %esi
80107eb2:	5d                   	pop    %ebp
80107eb3:	c3                   	ret

80107eb4 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107eb4:	55                   	push   %ebp
80107eb5:	89 e5                	mov    %esp,%ebp
80107eb7:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107eba:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ec1:	76 0d                	jbe    80107ed0 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107ec3:	83 ec 0c             	sub    $0xc,%esp
80107ec6:	68 35 8d 10 80       	push   $0x80108d35
80107ecb:	e8 e3 86 ff ff       	call   801005b3 <panic>
  mem = kalloc();
80107ed0:	e8 45 ae ff ff       	call   80102d1a <kalloc>
80107ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ed8:	83 ec 04             	sub    $0x4,%esp
80107edb:	68 00 10 00 00       	push   $0x1000
80107ee0:	6a 00                	push   $0x0
80107ee2:	ff 75 f4             	push   -0xc(%ebp)
80107ee5:	e8 5b d4 ff ff       	call   80105345 <memset>
80107eea:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ef5:	83 ec 0c             	sub    $0xc,%esp
80107ef8:	6a 06                	push   $0x6
80107efa:	50                   	push   %eax
80107efb:	68 00 10 00 00       	push   $0x1000
80107f00:	6a 00                	push   $0x0
80107f02:	ff 75 08             	push   0x8(%ebp)
80107f05:	e8 b1 fc ff ff       	call   80107bbb <mappages>
80107f0a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107f0d:	83 ec 04             	sub    $0x4,%esp
80107f10:	ff 75 10             	push   0x10(%ebp)
80107f13:	ff 75 0c             	push   0xc(%ebp)
80107f16:	ff 75 f4             	push   -0xc(%ebp)
80107f19:	e8 e6 d4 ff ff       	call   80105404 <memmove>
80107f1e:	83 c4 10             	add    $0x10,%esp
}
80107f21:	90                   	nop
80107f22:	c9                   	leave
80107f23:	c3                   	ret

80107f24 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f24:	55                   	push   %ebp
80107f25:	89 e5                	mov    %esp,%ebp
80107f27:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f2d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f32:	85 c0                	test   %eax,%eax
80107f34:	74 0d                	je     80107f43 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107f36:	83 ec 0c             	sub    $0xc,%esp
80107f39:	68 50 8d 10 80       	push   $0x80108d50
80107f3e:	e8 70 86 ff ff       	call   801005b3 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f4a:	e9 8f 00 00 00       	jmp    80107fde <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f55:	01 d0                	add    %edx,%eax
80107f57:	83 ec 04             	sub    $0x4,%esp
80107f5a:	6a 00                	push   $0x0
80107f5c:	50                   	push   %eax
80107f5d:	ff 75 08             	push   0x8(%ebp)
80107f60:	e8 c0 fb ff ff       	call   80107b25 <walkpgdir>
80107f65:	83 c4 10             	add    $0x10,%esp
80107f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f6f:	75 0d                	jne    80107f7e <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107f71:	83 ec 0c             	sub    $0xc,%esp
80107f74:	68 73 8d 10 80       	push   $0x80108d73
80107f79:	e8 35 86 ff ff       	call   801005b3 <panic>
    pa = PTE_ADDR(*pte);
80107f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f81:	8b 00                	mov    (%eax),%eax
80107f83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f8b:	8b 45 18             	mov    0x18(%ebp),%eax
80107f8e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f91:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f96:	77 0b                	ja     80107fa3 <loaduvm+0x7f>
      n = sz - i;
80107f98:	8b 45 18             	mov    0x18(%ebp),%eax
80107f9b:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fa1:	eb 07                	jmp    80107faa <loaduvm+0x86>
    else
      n = PGSIZE;
80107fa3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107faa:	8b 55 14             	mov    0x14(%ebp),%edx
80107fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb0:	01 d0                	add    %edx,%eax
80107fb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107fb5:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107fbb:	ff 75 f0             	push   -0x10(%ebp)
80107fbe:	50                   	push   %eax
80107fbf:	52                   	push   %edx
80107fc0:	ff 75 10             	push   0x10(%ebp)
80107fc3:	e8 40 9f ff ff       	call   80101f08 <readi>
80107fc8:	83 c4 10             	add    $0x10,%esp
80107fcb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107fce:	74 07                	je     80107fd7 <loaduvm+0xb3>
      return -1;
80107fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fd5:	eb 18                	jmp    80107fef <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107fd7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe1:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fe4:	0f 82 65 ff ff ff    	jb     80107f4f <loaduvm+0x2b>
  }
  return 0;
80107fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fef:	c9                   	leave
80107ff0:	c3                   	ret

80107ff1 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ff1:	55                   	push   %ebp
80107ff2:	89 e5                	mov    %esp,%ebp
80107ff4:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107ff7:	8b 45 10             	mov    0x10(%ebp),%eax
80107ffa:	85 c0                	test   %eax,%eax
80107ffc:	79 0a                	jns    80108008 <allocuvm+0x17>
    return 0;
80107ffe:	b8 00 00 00 00       	mov    $0x0,%eax
80108003:	e9 ec 00 00 00       	jmp    801080f4 <allocuvm+0x103>
  if(newsz < oldsz)
80108008:	8b 45 10             	mov    0x10(%ebp),%eax
8010800b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010800e:	73 08                	jae    80108018 <allocuvm+0x27>
    return oldsz;
80108010:	8b 45 0c             	mov    0xc(%ebp),%eax
80108013:	e9 dc 00 00 00       	jmp    801080f4 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80108018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801b:	05 ff 0f 00 00       	add    $0xfff,%eax
80108020:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108025:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108028:	e9 b8 00 00 00       	jmp    801080e5 <allocuvm+0xf4>
    mem = kalloc();
8010802d:	e8 e8 ac ff ff       	call   80102d1a <kalloc>
80108032:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108035:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108039:	75 2e                	jne    80108069 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
8010803b:	83 ec 0c             	sub    $0xc,%esp
8010803e:	68 91 8d 10 80       	push   $0x80108d91
80108043:	e8 b6 83 ff ff       	call   801003fe <cprintf>
80108048:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010804b:	83 ec 04             	sub    $0x4,%esp
8010804e:	ff 75 0c             	push   0xc(%ebp)
80108051:	ff 75 10             	push   0x10(%ebp)
80108054:	ff 75 08             	push   0x8(%ebp)
80108057:	e8 9a 00 00 00       	call   801080f6 <deallocuvm>
8010805c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010805f:	b8 00 00 00 00       	mov    $0x0,%eax
80108064:	e9 8b 00 00 00       	jmp    801080f4 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80108069:	83 ec 04             	sub    $0x4,%esp
8010806c:	68 00 10 00 00       	push   $0x1000
80108071:	6a 00                	push   $0x0
80108073:	ff 75 f0             	push   -0x10(%ebp)
80108076:	e8 ca d2 ff ff       	call   80105345 <memset>
8010807b:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010807e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108081:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	6a 06                	push   $0x6
8010808f:	52                   	push   %edx
80108090:	68 00 10 00 00       	push   $0x1000
80108095:	50                   	push   %eax
80108096:	ff 75 08             	push   0x8(%ebp)
80108099:	e8 1d fb ff ff       	call   80107bbb <mappages>
8010809e:	83 c4 20             	add    $0x20,%esp
801080a1:	85 c0                	test   %eax,%eax
801080a3:	79 39                	jns    801080de <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
801080a5:	83 ec 0c             	sub    $0xc,%esp
801080a8:	68 a9 8d 10 80       	push   $0x80108da9
801080ad:	e8 4c 83 ff ff       	call   801003fe <cprintf>
801080b2:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801080b5:	83 ec 04             	sub    $0x4,%esp
801080b8:	ff 75 0c             	push   0xc(%ebp)
801080bb:	ff 75 10             	push   0x10(%ebp)
801080be:	ff 75 08             	push   0x8(%ebp)
801080c1:	e8 30 00 00 00       	call   801080f6 <deallocuvm>
801080c6:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801080c9:	83 ec 0c             	sub    $0xc,%esp
801080cc:	ff 75 f0             	push   -0x10(%ebp)
801080cf:	e8 4c ab ff ff       	call   80102c20 <kfree>
801080d4:	83 c4 10             	add    $0x10,%esp
      return 0;
801080d7:	b8 00 00 00 00       	mov    $0x0,%eax
801080dc:	eb 16                	jmp    801080f4 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
801080de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e8:	3b 45 10             	cmp    0x10(%ebp),%eax
801080eb:	0f 82 3c ff ff ff    	jb     8010802d <allocuvm+0x3c>
    }
  }
  return newsz;
801080f1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080f4:	c9                   	leave
801080f5:	c3                   	ret

801080f6 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080f6:	55                   	push   %ebp
801080f7:	89 e5                	mov    %esp,%ebp
801080f9:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080fc:	8b 45 10             	mov    0x10(%ebp),%eax
801080ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108102:	72 08                	jb     8010810c <deallocuvm+0x16>
    return oldsz;
80108104:	8b 45 0c             	mov    0xc(%ebp),%eax
80108107:	e9 ac 00 00 00       	jmp    801081b8 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
8010810c:	8b 45 10             	mov    0x10(%ebp),%eax
8010810f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108114:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108119:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010811c:	e9 88 00 00 00       	jmp    801081a9 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108124:	83 ec 04             	sub    $0x4,%esp
80108127:	6a 00                	push   $0x0
80108129:	50                   	push   %eax
8010812a:	ff 75 08             	push   0x8(%ebp)
8010812d:	e8 f3 f9 ff ff       	call   80107b25 <walkpgdir>
80108132:	83 c4 10             	add    $0x10,%esp
80108135:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010813c:	75 16                	jne    80108154 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010813e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108141:	c1 e8 16             	shr    $0x16,%eax
80108144:	83 c0 01             	add    $0x1,%eax
80108147:	c1 e0 16             	shl    $0x16,%eax
8010814a:	2d 00 10 00 00       	sub    $0x1000,%eax
8010814f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108152:	eb 4e                	jmp    801081a2 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80108154:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108157:	8b 00                	mov    (%eax),%eax
80108159:	83 e0 01             	and    $0x1,%eax
8010815c:	85 c0                	test   %eax,%eax
8010815e:	74 42                	je     801081a2 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80108160:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108163:	8b 00                	mov    (%eax),%eax
80108165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010816a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010816d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108171:	75 0d                	jne    80108180 <deallocuvm+0x8a>
        panic("kfree");
80108173:	83 ec 0c             	sub    $0xc,%esp
80108176:	68 c5 8d 10 80       	push   $0x80108dc5
8010817b:	e8 33 84 ff ff       	call   801005b3 <panic>
      char *v = P2V(pa);
80108180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108183:	05 00 00 00 80       	add    $0x80000000,%eax
80108188:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010818b:	83 ec 0c             	sub    $0xc,%esp
8010818e:	ff 75 e8             	push   -0x18(%ebp)
80108191:	e8 8a aa ff ff       	call   80102c20 <kfree>
80108196:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108199:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010819c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801081a2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081af:	0f 82 6c ff ff ff    	jb     80108121 <deallocuvm+0x2b>
    }
  }
  return newsz;
801081b5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081b8:	c9                   	leave
801081b9:	c3                   	ret

801081ba <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801081ba:	55                   	push   %ebp
801081bb:	89 e5                	mov    %esp,%ebp
801081bd:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801081c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801081c4:	75 0d                	jne    801081d3 <freevm+0x19>
    panic("freevm: no pgdir");
801081c6:	83 ec 0c             	sub    $0xc,%esp
801081c9:	68 cb 8d 10 80       	push   $0x80108dcb
801081ce:	e8 e0 83 ff ff       	call   801005b3 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081d3:	83 ec 04             	sub    $0x4,%esp
801081d6:	6a 00                	push   $0x0
801081d8:	68 00 00 00 80       	push   $0x80000000
801081dd:	ff 75 08             	push   0x8(%ebp)
801081e0:	e8 11 ff ff ff       	call   801080f6 <deallocuvm>
801081e5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801081e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081ef:	eb 48                	jmp    80108239 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
801081f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081fb:	8b 45 08             	mov    0x8(%ebp),%eax
801081fe:	01 d0                	add    %edx,%eax
80108200:	8b 00                	mov    (%eax),%eax
80108202:	83 e0 01             	and    $0x1,%eax
80108205:	85 c0                	test   %eax,%eax
80108207:	74 2c                	je     80108235 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108213:	8b 45 08             	mov    0x8(%ebp),%eax
80108216:	01 d0                	add    %edx,%eax
80108218:	8b 00                	mov    (%eax),%eax
8010821a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010821f:	05 00 00 00 80       	add    $0x80000000,%eax
80108224:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108227:	83 ec 0c             	sub    $0xc,%esp
8010822a:	ff 75 f0             	push   -0x10(%ebp)
8010822d:	e8 ee a9 ff ff       	call   80102c20 <kfree>
80108232:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108235:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108239:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108240:	76 af                	jbe    801081f1 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108242:	83 ec 0c             	sub    $0xc,%esp
80108245:	ff 75 08             	push   0x8(%ebp)
80108248:	e8 d3 a9 ff ff       	call   80102c20 <kfree>
8010824d:	83 c4 10             	add    $0x10,%esp
}
80108250:	90                   	nop
80108251:	c9                   	leave
80108252:	c3                   	ret

80108253 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108253:	55                   	push   %ebp
80108254:	89 e5                	mov    %esp,%ebp
80108256:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108259:	83 ec 04             	sub    $0x4,%esp
8010825c:	6a 00                	push   $0x0
8010825e:	ff 75 0c             	push   0xc(%ebp)
80108261:	ff 75 08             	push   0x8(%ebp)
80108264:	e8 bc f8 ff ff       	call   80107b25 <walkpgdir>
80108269:	83 c4 10             	add    $0x10,%esp
8010826c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010826f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108273:	75 0d                	jne    80108282 <clearpteu+0x2f>
    panic("clearpteu");
80108275:	83 ec 0c             	sub    $0xc,%esp
80108278:	68 dc 8d 10 80       	push   $0x80108ddc
8010827d:	e8 31 83 ff ff       	call   801005b3 <panic>
  *pte &= ~PTE_U;
80108282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108285:	8b 00                	mov    (%eax),%eax
80108287:	83 e0 fb             	and    $0xfffffffb,%eax
8010828a:	89 c2                	mov    %eax,%edx
8010828c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828f:	89 10                	mov    %edx,(%eax)
}
80108291:	90                   	nop
80108292:	c9                   	leave
80108293:	c3                   	ret

80108294 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108294:	55                   	push   %ebp
80108295:	89 e5                	mov    %esp,%ebp
80108297:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0) {
8010829a:	e8 ac f9 ff ff       	call   80107c4b <setupkvm>
8010829f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082a6:	75 0a                	jne    801082b2 <copyuvm+0x1e>
    return 0;
801082a8:	b8 00 00 00 00       	mov    $0x0,%eax
801082ad:	e9 f7 00 00 00       	jmp    801083a9 <copyuvm+0x115>
  }
  for(i = 0; i < sz; i += PGSIZE){
801082b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082b9:	e9 c6 00 00 00       	jmp    80108384 <copyuvm+0xf0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801082be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c1:	83 ec 04             	sub    $0x4,%esp
801082c4:	6a 00                	push   $0x0
801082c6:	50                   	push   %eax
801082c7:	ff 75 08             	push   0x8(%ebp)
801082ca:	e8 56 f8 ff ff       	call   80107b25 <walkpgdir>
801082cf:	83 c4 10             	add    $0x10,%esp
801082d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082d9:	75 0d                	jne    801082e8 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
801082db:	83 ec 0c             	sub    $0xc,%esp
801082de:	68 e6 8d 10 80       	push   $0x80108de6
801082e3:	e8 cb 82 ff ff       	call   801005b3 <panic>
    if(!(*pte & PTE_P))
801082e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082eb:	8b 00                	mov    (%eax),%eax
801082ed:	83 e0 01             	and    $0x1,%eax
801082f0:	85 c0                	test   %eax,%eax
801082f2:	75 0d                	jne    80108301 <copyuvm+0x6d>
      panic("copyuvm: page not present");
801082f4:	83 ec 0c             	sub    $0xc,%esp
801082f7:	68 00 8e 10 80       	push   $0x80108e00
801082fc:	e8 b2 82 ff ff       	call   801005b3 <panic>
    pa = PTE_ADDR(*pte);
80108301:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108304:	8b 00                	mov    (%eax),%eax
80108306:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010830b:	89 45 e8             	mov    %eax,-0x18(%ebp)

    *pte = *pte &~PTE_W; //take away write permission from parent
8010830e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108311:	8b 00                	mov    (%eax),%eax
80108313:	83 e0 fd             	and    $0xfffffffd,%eax
80108316:	89 c2                	mov    %eax,%edx
80108318:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010831b:	89 10                	mov    %edx,(%eax)
    *pte = *pte|PTE_COW; //give COW permission to parent
8010831d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108320:	8b 00                	mov    (%eax),%eax
80108322:	80 cc 01             	or     $0x1,%ah
80108325:	89 c2                	mov    %eax,%edx
80108327:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010832a:	89 10                	mov    %edx,(%eax)
    
    flags = PTE_FLAGS(*pte); // child permission = parent permission
8010832c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010832f:	8b 00                	mov    (%eax),%eax
80108331:	25 ff 0f 00 00       	and    $0xfff,%eax
80108336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    increaseRefCount(pa); // increase the counter for number of processes using pa
80108339:	83 ec 0c             	sub    $0xc,%esp
8010833c:	ff 75 e8             	push   -0x18(%ebp)
8010833f:	e8 b3 aa ff ff       	call   80102df7 <increaseRefCount>
80108344:	83 c4 10             	add    $0x10,%esp

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
80108347:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010834a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834d:	83 ec 0c             	sub    $0xc,%esp
80108350:	52                   	push   %edx
80108351:	ff 75 e8             	push   -0x18(%ebp)
80108354:	68 00 10 00 00       	push   $0x1000
80108359:	50                   	push   %eax
8010835a:	ff 75 f0             	push   -0x10(%ebp)
8010835d:	e8 59 f8 ff ff       	call   80107bbb <mappages>
80108362:	83 c4 20             	add    $0x20,%esp
80108365:	85 c0                	test   %eax,%eax
80108367:	78 2c                	js     80108395 <copyuvm+0x101>
      goto bad;
    }
    lcr3(V2P(pgdir));
80108369:	8b 45 08             	mov    0x8(%ebp),%eax
8010836c:	05 00 00 00 80       	add    $0x80000000,%eax
80108371:	83 ec 0c             	sub    $0xc,%esp
80108374:	50                   	push   %eax
80108375:	e8 49 f4 ff ff       	call   801077c3 <lcr3>
8010837a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
8010837d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108387:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010838a:	0f 82 2e ff ff ff    	jb     801082be <copyuvm+0x2a>
  }
  
  return d;
80108390:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108393:	eb 14                	jmp    801083a9 <copyuvm+0x115>
      goto bad;
80108395:	90                   	nop

bad:
  freevm(d);
80108396:	83 ec 0c             	sub    $0xc,%esp
80108399:	ff 75 f0             	push   -0x10(%ebp)
8010839c:	e8 19 fe ff ff       	call   801081ba <freevm>
801083a1:	83 c4 10             	add    $0x10,%esp
  return 0;
801083a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083a9:	c9                   	leave
801083aa:	c3                   	ret

801083ab <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801083ab:	55                   	push   %ebp
801083ac:	89 e5                	mov    %esp,%ebp
801083ae:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801083b1:	83 ec 04             	sub    $0x4,%esp
801083b4:	6a 00                	push   $0x0
801083b6:	ff 75 0c             	push   0xc(%ebp)
801083b9:	ff 75 08             	push   0x8(%ebp)
801083bc:	e8 64 f7 ff ff       	call   80107b25 <walkpgdir>
801083c1:	83 c4 10             	add    $0x10,%esp
801083c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ca:	8b 00                	mov    (%eax),%eax
801083cc:	83 e0 01             	and    $0x1,%eax
801083cf:	85 c0                	test   %eax,%eax
801083d1:	75 07                	jne    801083da <uva2ka+0x2f>
    return 0;
801083d3:	b8 00 00 00 00       	mov    $0x0,%eax
801083d8:	eb 22                	jmp    801083fc <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
801083da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083dd:	8b 00                	mov    (%eax),%eax
801083df:	83 e0 04             	and    $0x4,%eax
801083e2:	85 c0                	test   %eax,%eax
801083e4:	75 07                	jne    801083ed <uva2ka+0x42>
    return 0;
801083e6:	b8 00 00 00 00       	mov    $0x0,%eax
801083eb:	eb 0f                	jmp    801083fc <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
801083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f0:	8b 00                	mov    (%eax),%eax
801083f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083f7:	05 00 00 00 80       	add    $0x80000000,%eax
}
801083fc:	c9                   	leave
801083fd:	c3                   	ret

801083fe <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083fe:	55                   	push   %ebp
801083ff:	89 e5                	mov    %esp,%ebp
80108401:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108404:	8b 45 10             	mov    0x10(%ebp),%eax
80108407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010840a:	eb 7f                	jmp    8010848b <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010840c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010840f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108414:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108417:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010841a:	83 ec 08             	sub    $0x8,%esp
8010841d:	50                   	push   %eax
8010841e:	ff 75 08             	push   0x8(%ebp)
80108421:	e8 85 ff ff ff       	call   801083ab <uva2ka>
80108426:	83 c4 10             	add    $0x10,%esp
80108429:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010842c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108430:	75 07                	jne    80108439 <copyout+0x3b>
      return -1;
80108432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108437:	eb 61                	jmp    8010849a <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108439:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010843c:	2b 45 0c             	sub    0xc(%ebp),%eax
8010843f:	05 00 10 00 00       	add    $0x1000,%eax
80108444:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010844a:	39 45 14             	cmp    %eax,0x14(%ebp)
8010844d:	73 06                	jae    80108455 <copyout+0x57>
      n = len;
8010844f:	8b 45 14             	mov    0x14(%ebp),%eax
80108452:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108455:	8b 45 0c             	mov    0xc(%ebp),%eax
80108458:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010845b:	89 c2                	mov    %eax,%edx
8010845d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108460:	01 d0                	add    %edx,%eax
80108462:	83 ec 04             	sub    $0x4,%esp
80108465:	ff 75 f0             	push   -0x10(%ebp)
80108468:	ff 75 f4             	push   -0xc(%ebp)
8010846b:	50                   	push   %eax
8010846c:	e8 93 cf ff ff       	call   80105404 <memmove>
80108471:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108477:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010847a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010847d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108480:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108483:	05 00 10 00 00       	add    $0x1000,%eax
80108488:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010848b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010848f:	0f 85 77 ff ff ff    	jne    8010840c <copyout+0xe>
  }
  return 0;
80108495:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010849a:	c9                   	leave
8010849b:	c3                   	ret

8010849c <handlePageFault>:

void handlePageFault(void *va) {
8010849c:	55                   	push   %ebp
8010849d:	89 e5                	mov    %esp,%ebp
8010849f:	57                   	push   %edi
801084a0:	56                   	push   %esi
801084a1:	53                   	push   %ebx
801084a2:	83 ec 3c             	sub    $0x3c,%esp

  pte_t *pgdir = myproc()->pgdir;
801084a5:	e8 2b bf ff ff       	call   801043d5 <myproc>
801084aa:	8b 40 04             	mov    0x4(%eax),%eax
801084ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint flags;
  pte_t *pte = walkpgdir(pgdir,va,0);
801084b0:	83 ec 04             	sub    $0x4,%esp
801084b3:	6a 00                	push   $0x0
801084b5:	ff 75 08             	push   0x8(%ebp)
801084b8:	ff 75 e4             	push   -0x1c(%ebp)
801084bb:	e8 65 f6 ff ff       	call   80107b25 <walkpgdir>
801084c0:	83 c4 10             	add    $0x10,%esp
801084c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (pte == 0) {
801084c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801084ca:	75 0d                	jne    801084d9 <handlePageFault+0x3d>
    panic("segfault");
801084cc:	83 ec 0c             	sub    $0xc,%esp
801084cf:	68 1a 8e 10 80       	push   $0x80108e1a
801084d4:	e8 da 80 ff ff       	call   801005b3 <panic>
  }
  flags = PTE_FLAGS(*pte);
801084d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084dc:	8b 00                	mov    (%eax),%eax
801084de:	25 ff 0f 00 00       	and    $0xfff,%eax
801084e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint pa = PTE_ADDR(*pte);
801084e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084e9:	8b 00                	mov    (%eax),%eax
801084eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (getRefCount(pa) < 1) {
801084f3:	83 ec 0c             	sub    $0xc,%esp
801084f6:	ff 75 d8             	push   -0x28(%ebp)
801084f9:	e8 e7 a8 ff ff       	call   80102de5 <getRefCount>
801084fe:	83 c4 10             	add    $0x10,%esp
80108501:	85 c0                	test   %eax,%eax
80108503:	7f 4a                	jg     8010854f <handlePageFault+0xb3>
    // not theoretically possible! At least one process should be using this!
    cprintf("[DEBUG] vm.c, 400 : refcount = %d pid = %d va = %d, pa/pgsize = %d, process size = %d\n",getRefCount(pa),myproc()->pid,(int)va,pa/PGSIZE,myproc()->sz);
80108505:	e8 cb be ff ff       	call   801043d5 <myproc>
8010850a:	8b 38                	mov    (%eax),%edi
8010850c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010850f:	c1 e8 0c             	shr    $0xc,%eax
80108512:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80108515:	8b 75 08             	mov    0x8(%ebp),%esi
80108518:	e8 b8 be ff ff       	call   801043d5 <myproc>
8010851d:	8b 58 10             	mov    0x10(%eax),%ebx
80108520:	83 ec 0c             	sub    $0xc,%esp
80108523:	ff 75 d8             	push   -0x28(%ebp)
80108526:	e8 ba a8 ff ff       	call   80102de5 <getRefCount>
8010852b:	83 c4 10             	add    $0x10,%esp
8010852e:	83 ec 08             	sub    $0x8,%esp
80108531:	57                   	push   %edi
80108532:	ff 75 c4             	push   -0x3c(%ebp)
80108535:	56                   	push   %esi
80108536:	53                   	push   %ebx
80108537:	50                   	push   %eax
80108538:	68 24 8e 10 80       	push   $0x80108e24
8010853d:	e8 bc 7e ff ff       	call   801003fe <cprintf>
80108542:	83 c4 20             	add    $0x20,%esp
    exit();
80108545:	e8 03 c3 ff ff       	call   8010484d <exit>
    return;
8010854a:	e9 05 01 00 00       	jmp    80108654 <handlePageFault+0x1b8>
  }
  if (getRefCount(pa) == 1) {
8010854f:	83 ec 0c             	sub    $0xc,%esp
80108552:	ff 75 d8             	push   -0x28(%ebp)
80108555:	e8 8b a8 ff ff       	call   80102de5 <getRefCount>
8010855a:	83 c4 10             	add    $0x10,%esp
8010855d:	83 f8 01             	cmp    $0x1,%eax
80108560:	75 5c                	jne    801085be <handlePageFault+0x122>
    // case 1 : You're the last (and only) guy using this page
    //chalo nice and easy. All we have to do is update our permissions... 
    if (flags & PTE_COW) {
80108562:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108565:	25 00 01 00 00       	and    $0x100,%eax
8010856a:	85 c0                	test   %eax,%eax
8010856c:	74 34                	je     801085a2 <handlePageFault+0x106>
      //bing bang boom just update
      *pte = *pte&~PTE_COW; // take away Cow indicator
8010856e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108571:	8b 00                	mov    (%eax),%eax
80108573:	80 e4 fe             	and    $0xfe,%ah
80108576:	89 c2                	mov    %eax,%edx
80108578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010857b:	89 10                	mov    %edx,(%eax)
      *pte = *pte|PTE_W; //give write perms
8010857d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108580:	8b 00                	mov    (%eax),%eax
80108582:	83 c8 02             	or     $0x2,%eax
80108585:	89 c2                	mov    %eax,%edx
80108587:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010858a:	89 10                	mov    %edx,(%eax)

      switchuvm(myproc()); // this internally calls lcr3
8010858c:	e8 44 be ff ff       	call   801043d5 <myproc>
80108591:	83 ec 0c             	sub    $0xc,%esp
80108594:	50                   	push   %eax
80108595:	e8 7b f7 ff ff       	call   80107d15 <switchuvm>
8010859a:	83 c4 10             	add    $0x10,%esp
      return;
8010859d:	e9 b2 00 00 00       	jmp    80108654 <handlePageFault+0x1b8>
    }
    else {
      cprintf("Page fault on address not Cow forked!\n");
801085a2:	83 ec 0c             	sub    $0xc,%esp
801085a5:	68 7c 8e 10 80       	push   $0x80108e7c
801085aa:	e8 4f 7e ff ff       	call   801003fe <cprintf>
801085af:	83 c4 10             	add    $0x10,%esp
      myproc()->killed = 1;
801085b2:	e8 1e be ff ff       	call   801043d5 <myproc>
801085b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }
  }
  
  if (flags & PTE_COW) {
801085be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801085c1:	25 00 01 00 00       	and    $0x100,%eax
801085c6:	85 c0                	test   %eax,%eax
801085c8:	74 62                	je     8010862c <handlePageFault+0x190>
    // us reaching here indicates that there are multiple processes using this pa, we must allocate a seperate pa for ourselves.
    char *mem = kalloc();
801085ca:	e8 4b a7 ff ff       	call   80102d1a <kalloc>
801085cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    memmove(mem,(void*)P2V(pa),PGSIZE);
801085d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801085d5:	05 00 00 00 80       	add    $0x80000000,%eax
801085da:	83 ec 04             	sub    $0x4,%esp
801085dd:	68 00 10 00 00       	push   $0x1000
801085e2:	50                   	push   %eax
801085e3:	ff 75 d4             	push   -0x2c(%ebp)
801085e6:	e8 19 ce ff ff       	call   80105404 <memmove>
801085eb:	83 c4 10             	add    $0x10,%esp

    flags = flags&~PTE_COW; // take away Cow indicator
801085ee:	81 65 dc ff fe ff ff 	andl   $0xfffffeff,-0x24(%ebp)
    flags = flags|PTE_W; // give write permissions
801085f5:	83 4d dc 02          	orl    $0x2,-0x24(%ebp)

    *pte = (V2P(mem) | flags); // change your PTE to point to mem instead of pa
801085f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801085fc:	05 00 00 00 80       	add    $0x80000000,%eax
80108601:	0b 45 dc             	or     -0x24(%ebp),%eax
80108604:	89 c2                	mov    %eax,%edx
80108606:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108609:	89 10                	mov    %edx,(%eax)

    decreaseRefCount(pa); // decrease the count of processes using pa
8010860b:	83 ec 0c             	sub    $0xc,%esp
8010860e:	ff 75 d8             	push   -0x28(%ebp)
80108611:	e8 fe a7 ff ff       	call   80102e14 <decreaseRefCount>
80108616:	83 c4 10             	add    $0x10,%esp
    switchuvm(myproc()); // call lcr3
80108619:	e8 b7 bd ff ff       	call   801043d5 <myproc>
8010861e:	83 ec 0c             	sub    $0xc,%esp
80108621:	50                   	push   %eax
80108622:	e8 ee f6 ff ff       	call   80107d15 <switchuvm>
80108627:	83 c4 10             	add    $0x10,%esp
    return;
8010862a:	eb 28                	jmp    80108654 <handlePageFault+0x1b8>
  }
  else {
    cprintf("[DEBUG] vm.c, 441 : flags = %d and refs = %d\n",flags,getRefCount(pa));
8010862c:	83 ec 0c             	sub    $0xc,%esp
8010862f:	ff 75 d8             	push   -0x28(%ebp)
80108632:	e8 ae a7 ff ff       	call   80102de5 <getRefCount>
80108637:	83 c4 10             	add    $0x10,%esp
8010863a:	83 ec 04             	sub    $0x4,%esp
8010863d:	50                   	push   %eax
8010863e:	ff 75 dc             	push   -0x24(%ebp)
80108641:	68 a4 8e 10 80       	push   $0x80108ea4
80108646:	e8 b3 7d ff ff       	call   801003fe <cprintf>
8010864b:	83 c4 10             	add    $0x10,%esp
    exit();
8010864e:	e8 fa c1 ff ff       	call   8010484d <exit>
    return;
80108653:	90                   	nop
  }

}
80108654:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108657:	5b                   	pop    %ebx
80108658:	5e                   	pop    %esi
80108659:	5f                   	pop    %edi
8010865a:	5d                   	pop    %ebp
8010865b:	c3                   	ret
