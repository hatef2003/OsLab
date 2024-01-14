
_fdr:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
    if (argc < 2)
   a:	83 39 01             	cmpl   $0x1,(%ecx)
{
   d:	55                   	push   %ebp
   e:	89 e5                	mov    %esp,%ebp
  10:	53                   	push   %ebx
  11:	51                   	push   %ecx
  12:	8b 41 04             	mov    0x4(%ecx),%eax
    if (argc < 2)
  15:	7e 2b                	jle    42 <main+0x42>
    {
        exit();
    }
    int saved_ebx, number = atoi(argv[1]);
  17:	83 ec 0c             	sub    $0xc,%esp
  1a:	ff 70 04             	push   0x4(%eax)
  1d:	e8 0e 02 00 00       	call   230 <atoi>
    //
    asm volatile(
  22:	89 db                	mov    %ebx,%ebx
  24:	89 c3                	mov    %eax,%ebx
        "movl %%ebx, %0;" // saved_ebx = ebx
        "movl %1, %%ebx;" // ebx = number
        : "=r"(saved_ebx)
        : "r"(number));
    printf(1,"digtal root is %d\n",find_digital_root());
  26:	e8 38 03 00 00       	call   363 <find_digital_root>
  2b:	83 c4 0c             	add    $0xc,%esp
  2e:	50                   	push   %eax
  2f:	68 88 07 00 00       	push   $0x788
  34:	6a 01                	push   $0x1
  36:	e8 25 04 00 00       	call   460 <printf>
    asm("movl %0, %%ebx" : : "r"(saved_ebx)); // ebx = saved_ebx -> restore
  3b:	89 db                	mov    %ebx,%ebx
    // 
    exit();
  3d:	e8 61 02 00 00       	call   2a3 <exit>
        exit();
  42:	e8 5c 02 00 00       	call   2a3 <exit>
  47:	66 90                	xchg   %ax,%ax
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  50:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  51:	31 c0                	xor    %eax,%eax
{
  53:	89 e5                	mov    %esp,%ebp
  55:	53                   	push   %ebx
  56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  67:	83 c0 01             	add    $0x1,%eax
  6a:	84 d2                	test   %dl,%dl
  6c:	75 f2                	jne    60 <strcpy+0x10>
    ;
  return os;
}
  6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  71:	89 c8                	mov    %ecx,%eax
  73:	c9                   	leave  
  74:	c3                   	ret    
  75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	8b 55 08             	mov    0x8(%ebp),%edx
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  8a:	0f b6 02             	movzbl (%edx),%eax
  8d:	84 c0                	test   %al,%al
  8f:	75 17                	jne    a8 <strcmp+0x28>
  91:	eb 3a                	jmp    cd <strcmp+0x4d>
  93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  97:	90                   	nop
  98:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  9c:	83 c2 01             	add    $0x1,%edx
  9f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  a2:	84 c0                	test   %al,%al
  a4:	74 1a                	je     c0 <strcmp+0x40>
    p++, q++;
  a6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  a8:	0f b6 19             	movzbl (%ecx),%ebx
  ab:	38 c3                	cmp    %al,%bl
  ad:	74 e9                	je     98 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  af:	29 d8                	sub    %ebx,%eax
}
  b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b4:	c9                   	leave  
  b5:	c3                   	ret    
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  c0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  c4:	31 c0                	xor    %eax,%eax
  c6:	29 d8                	sub    %ebx,%eax
}
  c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cb:	c9                   	leave  
  cc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  cd:	0f b6 19             	movzbl (%ecx),%ebx
  d0:	31 c0                	xor    %eax,%eax
  d2:	eb db                	jmp    af <strcmp+0x2f>
  d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  df:	90                   	nop

000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 3a 00             	cmpb   $0x0,(%edx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 c0                	xor    %eax,%eax
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c0 01             	add    $0x1,%eax
  f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  f7:	89 c1                	mov    %eax,%ecx
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	89 c8                	mov    %ecx,%eax
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    
  ff:	90                   	nop
  for(n = 0; s[n]; n++)
 100:	31 c9                	xor    %ecx,%ecx
}
 102:	5d                   	pop    %ebp
 103:	89 c8                	mov    %ecx,%eax
 105:	c3                   	ret    
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	8b 7d fc             	mov    -0x4(%ebp),%edi
 125:	89 d0                	mov    %edx,%eax
 127:	c9                   	leave  
 128:	c3                   	ret    
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	75 12                	jne    153 <strchr+0x23>
 141:	eb 1d                	jmp    160 <strchr+0x30>
 143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 147:	90                   	nop
 148:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 14c:	83 c0 01             	add    $0x1,%eax
 14f:	84 d2                	test   %dl,%dl
 151:	74 0d                	je     160 <strchr+0x30>
    if(*s == c)
 153:	38 d1                	cmp    %dl,%cl
 155:	75 f1                	jne    148 <strchr+0x18>
      return (char*)s;
  return 0;
}
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 160:	31 c0                	xor    %eax,%eax
}
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
 164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 175:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 178:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 179:	31 db                	xor    %ebx,%ebx
{
 17b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 17e:	eb 27                	jmp    1a7 <gets+0x37>
    cc = read(0, &c, 1);
 180:	83 ec 04             	sub    $0x4,%esp
 183:	6a 01                	push   $0x1
 185:	57                   	push   %edi
 186:	6a 00                	push   $0x0
 188:	e8 2e 01 00 00       	call   2bb <read>
    if(cc < 1)
 18d:	83 c4 10             	add    $0x10,%esp
 190:	85 c0                	test   %eax,%eax
 192:	7e 1d                	jle    1b1 <gets+0x41>
      break;
    buf[i++] = c;
 194:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 198:	8b 55 08             	mov    0x8(%ebp),%edx
 19b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 19f:	3c 0a                	cmp    $0xa,%al
 1a1:	74 1d                	je     1c0 <gets+0x50>
 1a3:	3c 0d                	cmp    $0xd,%al
 1a5:	74 19                	je     1c0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1a7:	89 de                	mov    %ebx,%esi
 1a9:	83 c3 01             	add    $0x1,%ebx
 1ac:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1af:	7c cf                	jl     180 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5f                   	pop    %edi
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    
  buf[i] = '\0';
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	89 de                	mov    %ebx,%esi
 1c5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cc:	5b                   	pop    %ebx
 1cd:	5e                   	pop    %esi
 1ce:	5f                   	pop    %edi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    
 1d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1df:	90                   	nop

000001e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	6a 00                	push   $0x0
 1ea:	ff 75 08             	push   0x8(%ebp)
 1ed:	e8 f1 00 00 00       	call   2e3 <open>
  if(fd < 0)
 1f2:	83 c4 10             	add    $0x10,%esp
 1f5:	85 c0                	test   %eax,%eax
 1f7:	78 27                	js     220 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1f9:	83 ec 08             	sub    $0x8,%esp
 1fc:	ff 75 0c             	push   0xc(%ebp)
 1ff:	89 c3                	mov    %eax,%ebx
 201:	50                   	push   %eax
 202:	e8 f4 00 00 00       	call   2fb <fstat>
  close(fd);
 207:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 20a:	89 c6                	mov    %eax,%esi
  close(fd);
 20c:	e8 ba 00 00 00       	call   2cb <close>
  return r;
 211:	83 c4 10             	add    $0x10,%esp
}
 214:	8d 65 f8             	lea    -0x8(%ebp),%esp
 217:	89 f0                	mov    %esi,%eax
 219:	5b                   	pop    %ebx
 21a:	5e                   	pop    %esi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    
 21d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 220:	be ff ff ff ff       	mov    $0xffffffff,%esi
 225:	eb ed                	jmp    214 <stat+0x34>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <atoi>:

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	0f be 02             	movsbl (%edx),%eax
 23a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 23d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 240:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 245:	77 1e                	ja     265 <atoi+0x35>
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 250:	83 c2 01             	add    $0x1,%edx
 253:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 256:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 25a:	0f be 02             	movsbl (%edx),%eax
 25d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 260:	80 fb 09             	cmp    $0x9,%bl
 263:	76 eb                	jbe    250 <atoi+0x20>
  return n;
}
 265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 268:	89 c8                	mov    %ecx,%eax
 26a:	c9                   	leave  
 26b:	c3                   	ret    
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	8b 55 08             	mov    0x8(%ebp),%edx
 27a:	56                   	push   %esi
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 c0                	test   %eax,%eax
 280:	7e 13                	jle    295 <memmove+0x25>
 282:	01 d0                	add    %edx,%eax
  dst = vdst;
 284:	89 d7                	mov    %edx,%edi
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 290:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 291:	39 f8                	cmp    %edi,%eax
 293:	75 fb                	jne    290 <memmove+0x20>
  return vdst;
}
 295:	5e                   	pop    %esi
 296:	89 d0                	mov    %edx,%eax
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    

0000029b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29b:	b8 01 00 00 00       	mov    $0x1,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <exit>:
SYSCALL(exit)
 2a3:	b8 02 00 00 00       	mov    $0x2,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <wait>:
SYSCALL(wait)
 2ab:	b8 03 00 00 00       	mov    $0x3,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <pipe>:
SYSCALL(pipe)
 2b3:	b8 04 00 00 00       	mov    $0x4,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <read>:
SYSCALL(read)
 2bb:	b8 05 00 00 00       	mov    $0x5,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <write>:
SYSCALL(write)
 2c3:	b8 10 00 00 00       	mov    $0x10,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <close>:
SYSCALL(close)
 2cb:	b8 15 00 00 00       	mov    $0x15,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <kill>:
SYSCALL(kill)
 2d3:	b8 06 00 00 00       	mov    $0x6,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <exec>:
SYSCALL(exec)
 2db:	b8 07 00 00 00       	mov    $0x7,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <open>:
SYSCALL(open)
 2e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mknod>:
SYSCALL(mknod)
 2eb:	b8 11 00 00 00       	mov    $0x11,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <unlink>:
SYSCALL(unlink)
 2f3:	b8 12 00 00 00       	mov    $0x12,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <fstat>:
SYSCALL(fstat)
 2fb:	b8 08 00 00 00       	mov    $0x8,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <link>:
SYSCALL(link)
 303:	b8 13 00 00 00       	mov    $0x13,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mkdir>:
SYSCALL(mkdir)
 30b:	b8 14 00 00 00       	mov    $0x14,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <chdir>:
SYSCALL(chdir)
 313:	b8 09 00 00 00       	mov    $0x9,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <dup>:
SYSCALL(dup)
 31b:	b8 0a 00 00 00       	mov    $0xa,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <getpid>:
SYSCALL(getpid)
 323:	b8 0b 00 00 00       	mov    $0xb,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <sbrk>:
SYSCALL(sbrk)
 32b:	b8 0c 00 00 00       	mov    $0xc,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <sleep>:
SYSCALL(sleep)
 333:	b8 0d 00 00 00       	mov    $0xd,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <uptime>:
SYSCALL(uptime)
 33b:	b8 0e 00 00 00       	mov    $0xe,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 343:	b8 18 00 00 00       	mov    $0x18,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <get_uncle_count>:
SYSCALL(get_uncle_count)
 34b:	b8 17 00 00 00       	mov    $0x17,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <get_pid>:
SYSCALL(get_pid)
 353:	b8 1a 00 00 00       	mov    $0x1a,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <copy_file>:
SYSCALL(copy_file)
 35b:	b8 16 00 00 00       	mov    $0x16,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <find_digital_root>:
SYSCALL(find_digital_root)
 363:	b8 1b 00 00 00       	mov    $0x1b,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <get_parent>:
SYSCALL(get_parent)
 36b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <change_queue>:
SYSCALL(change_queue)
 373:	b8 1d 00 00 00       	mov    $0x1d,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <bjf_validation_process>:
SYSCALL(bjf_validation_process)
 37b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <bjf_validation_system>:
SYSCALL(bjf_validation_system)
 383:	b8 1f 00 00 00       	mov    $0x1f,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <print_info>:
SYSCALL(print_info)
 38b:	b8 20 00 00 00       	mov    $0x20,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <open_sharedmem>:
SYSCALL(open_sharedmem)
 393:	b8 21 00 00 00       	mov    $0x21,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <close_sharedmem>:
 39b:	b8 22 00 00 00       	mov    $0x22,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    
 3a3:	66 90                	xchg   %ax,%ax
 3a5:	66 90                	xchg   %ax,%ax
 3a7:	66 90                	xchg   %ax,%ax
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 3c             	sub    $0x3c,%esp
 3b9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3bc:	89 d1                	mov    %edx,%ecx
{
 3be:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3c1:	85 d2                	test   %edx,%edx
 3c3:	0f 89 7f 00 00 00    	jns    448 <printint+0x98>
 3c9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3cd:	74 79                	je     448 <printint+0x98>
    neg = 1;
 3cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3d6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3d8:	31 db                	xor    %ebx,%ebx
 3da:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	89 c8                	mov    %ecx,%eax
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	89 cf                	mov    %ecx,%edi
 3e6:	f7 75 c4             	divl   -0x3c(%ebp)
 3e9:	0f b6 92 fc 07 00 00 	movzbl 0x7fc(%edx),%edx
 3f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3f3:	89 d8                	mov    %ebx,%eax
 3f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3fb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3fe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 401:	76 dd                	jbe    3e0 <printint+0x30>
  if(neg)
 403:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 406:	85 c9                	test   %ecx,%ecx
 408:	74 0c                	je     416 <printint+0x66>
    buf[i++] = '-';
 40a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 40f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 411:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 416:	8b 7d b8             	mov    -0x48(%ebp),%edi
 419:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 41d:	eb 07                	jmp    426 <printint+0x76>
 41f:	90                   	nop
    putc(fd, buf[i]);
 420:	0f b6 13             	movzbl (%ebx),%edx
 423:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 426:	83 ec 04             	sub    $0x4,%esp
 429:	88 55 d7             	mov    %dl,-0x29(%ebp)
 42c:	6a 01                	push   $0x1
 42e:	56                   	push   %esi
 42f:	57                   	push   %edi
 430:	e8 8e fe ff ff       	call   2c3 <write>
  while(--i >= 0)
 435:	83 c4 10             	add    $0x10,%esp
 438:	39 de                	cmp    %ebx,%esi
 43a:	75 e4                	jne    420 <printint+0x70>
}
 43c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43f:	5b                   	pop    %ebx
 440:	5e                   	pop    %esi
 441:	5f                   	pop    %edi
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 448:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 44f:	eb 87                	jmp    3d8 <printint+0x28>
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop

00000460 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 469:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 46c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 46f:	0f b6 13             	movzbl (%ebx),%edx
 472:	84 d2                	test   %dl,%dl
 474:	74 6a                	je     4e0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 476:	8d 45 10             	lea    0x10(%ebp),%eax
 479:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 47c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 47f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 481:	89 45 d0             	mov    %eax,-0x30(%ebp)
 484:	eb 36                	jmp    4bc <printf+0x5c>
 486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 493:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	74 15                	je     4b2 <printf+0x52>
  write(fd, &c, 1);
 49d:	83 ec 04             	sub    $0x4,%esp
 4a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4a3:	6a 01                	push   $0x1
 4a5:	57                   	push   %edi
 4a6:	56                   	push   %esi
 4a7:	e8 17 fe ff ff       	call   2c3 <write>
 4ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4af:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4b2:	0f b6 13             	movzbl (%ebx),%edx
 4b5:	83 c3 01             	add    $0x1,%ebx
 4b8:	84 d2                	test   %dl,%dl
 4ba:	74 24                	je     4e0 <printf+0x80>
    c = fmt[i] & 0xff;
 4bc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4bf:	85 c9                	test   %ecx,%ecx
 4c1:	74 cd                	je     490 <printf+0x30>
      }
    } else if(state == '%'){
 4c3:	83 f9 25             	cmp    $0x25,%ecx
 4c6:	75 ea                	jne    4b2 <printf+0x52>
      if(c == 'd'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	0f 84 07 01 00 00    	je     5d8 <printf+0x178>
 4d1:	83 e8 63             	sub    $0x63,%eax
 4d4:	83 f8 15             	cmp    $0x15,%eax
 4d7:	77 17                	ja     4f0 <printf+0x90>
 4d9:	ff 24 85 a4 07 00 00 	jmp    *0x7a4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4f6:	6a 01                	push   $0x1
 4f8:	57                   	push   %edi
 4f9:	56                   	push   %esi
 4fa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4fe:	e8 c0 fd ff ff       	call   2c3 <write>
        putc(fd, c);
 503:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 507:	83 c4 0c             	add    $0xc,%esp
 50a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 50d:	6a 01                	push   $0x1
 50f:	57                   	push   %edi
 510:	56                   	push   %esi
 511:	e8 ad fd ff ff       	call   2c3 <write>
        putc(fd, c);
 516:	83 c4 10             	add    $0x10,%esp
      state = 0;
 519:	31 c9                	xor    %ecx,%ecx
 51b:	eb 95                	jmp    4b2 <printf+0x52>
 51d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
 528:	6a 00                	push   $0x0
 52a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 52d:	8b 10                	mov    (%eax),%edx
 52f:	89 f0                	mov    %esi,%eax
 531:	e8 7a fe ff ff       	call   3b0 <printint>
        ap++;
 536:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 53a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53d:	31 c9                	xor    %ecx,%ecx
 53f:	e9 6e ff ff ff       	jmp    4b2 <printf+0x52>
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 548:	8b 45 d0             	mov    -0x30(%ebp),%eax
 54b:	8b 10                	mov    (%eax),%edx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 553:	85 d2                	test   %edx,%edx
 555:	0f 84 8d 00 00 00    	je     5e8 <printf+0x188>
        while(*s != 0){
 55b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 55e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 560:	84 c0                	test   %al,%al
 562:	0f 84 4a ff ff ff    	je     4b2 <printf+0x52>
 568:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 56b:	89 d3                	mov    %edx,%ebx
 56d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
          s++;
 573:	83 c3 01             	add    $0x1,%ebx
 576:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 579:	6a 01                	push   $0x1
 57b:	57                   	push   %edi
 57c:	56                   	push   %esi
 57d:	e8 41 fd ff ff       	call   2c3 <write>
        while(*s != 0){
 582:	0f b6 03             	movzbl (%ebx),%eax
 585:	83 c4 10             	add    $0x10,%esp
 588:	84 c0                	test   %al,%al
 58a:	75 e4                	jne    570 <printf+0x110>
      state = 0;
 58c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 58f:	31 c9                	xor    %ecx,%ecx
 591:	e9 1c ff ff ff       	jmp    4b2 <printf+0x52>
 596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a8:	6a 01                	push   $0x1
 5aa:	e9 7b ff ff ff       	jmp    52a <printf+0xca>
 5af:	90                   	nop
        putc(fd, *ap);
 5b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5b6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5b8:	6a 01                	push   $0x1
 5ba:	57                   	push   %edi
 5bb:	56                   	push   %esi
        putc(fd, *ap);
 5bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5bf:	e8 ff fc ff ff       	call   2c3 <write>
        ap++;
 5c4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cb:	31 c9                	xor    %ecx,%ecx
 5cd:	e9 e0 fe ff ff       	jmp    4b2 <printf+0x52>
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5d8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5db:	83 ec 04             	sub    $0x4,%esp
 5de:	e9 2a ff ff ff       	jmp    50d <printf+0xad>
 5e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5e7:	90                   	nop
          s = "(null)";
 5e8:	ba 9b 07 00 00       	mov    $0x79b,%edx
        while(*s != 0){
 5ed:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5f0:	b8 28 00 00 00       	mov    $0x28,%eax
 5f5:	89 d3                	mov    %edx,%ebx
 5f7:	e9 74 ff ff ff       	jmp    570 <printf+0x110>
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 a8 0a 00 00       	mov    0xaa8,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 618:	89 c2                	mov    %eax,%edx
 61a:	8b 00                	mov    (%eax),%eax
 61c:	39 ca                	cmp    %ecx,%edx
 61e:	73 30                	jae    650 <free+0x50>
 620:	39 c1                	cmp    %eax,%ecx
 622:	72 04                	jb     628 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	39 c2                	cmp    %eax,%edx
 626:	72 f0                	jb     618 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 f8                	cmp    %edi,%eax
 630:	74 30                	je     662 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 632:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 635:	8b 42 04             	mov    0x4(%edx),%eax
 638:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 63b:	39 f1                	cmp    %esi,%ecx
 63d:	74 3a                	je     679 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 63f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 641:	5b                   	pop    %ebx
  freep = p;
 642:	89 15 a8 0a 00 00    	mov    %edx,0xaa8
}
 648:	5e                   	pop    %esi
 649:	5f                   	pop    %edi
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret    
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 c2                	cmp    %eax,%edx
 652:	72 c4                	jb     618 <free+0x18>
 654:	39 c1                	cmp    %eax,%ecx
 656:	73 c0                	jae    618 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 73 fc             	mov    -0x4(%ebx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 f8                	cmp    %edi,%eax
 660:	75 d0                	jne    632 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 662:	03 70 04             	add    0x4(%eax),%esi
 665:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 02                	mov    (%edx),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 66f:	8b 42 04             	mov    0x4(%edx),%eax
 672:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 675:	39 f1                	cmp    %esi,%ecx
 677:	75 c6                	jne    63f <free+0x3f>
    p->s.size += bp->s.size;
 679:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 67c:	89 15 a8 0a 00 00    	mov    %edx,0xaa8
    p->s.size += bp->s.size;
 682:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 685:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 688:	89 0a                	mov    %ecx,(%edx)
}
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5f                   	pop    %edi
 68d:	5d                   	pop    %ebp
 68e:	c3                   	ret    
 68f:	90                   	nop

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 3d a8 0a 00 00    	mov    0xaa8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 70 07             	lea    0x7(%eax),%esi
 6a5:	c1 ee 03             	shr    $0x3,%esi
 6a8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6ab:	85 ff                	test   %edi,%edi
 6ad:	0f 84 9d 00 00 00    	je     750 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6b5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6b8:	39 f1                	cmp    %esi,%ecx
 6ba:	73 6a                	jae    726 <malloc+0x96>
 6bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c1:	39 de                	cmp    %ebx,%esi
 6c3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6c6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6d0:	eb 17                	jmp    6e9 <malloc+0x59>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 f1                	cmp    %esi,%ecx
 6df:	73 4f                	jae    730 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	8b 3d a8 0a 00 00    	mov    0xaa8,%edi
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	39 d7                	cmp    %edx,%edi
 6eb:	75 eb                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	ff 75 e4             	push   -0x1c(%ebp)
 6f3:	e8 33 fc ff ff       	call   32b <sbrk>
  if(p == (char*)-1)
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fe:	74 1c                	je     71c <malloc+0x8c>
  hp->s.size = nu;
 700:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	83 c0 08             	add    $0x8,%eax
 709:	50                   	push   %eax
 70a:	e8 f1 fe ff ff       	call   600 <free>
  return freep;
 70f:	8b 15 a8 0a 00 00    	mov    0xaa8,%edx
      if((p = morecore(nunits)) == 0)
 715:	83 c4 10             	add    $0x10,%esp
 718:	85 d2                	test   %edx,%edx
 71a:	75 bc                	jne    6d8 <malloc+0x48>
        return 0;
  }
}
 71c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 71f:	31 c0                	xor    %eax,%eax
}
 721:	5b                   	pop    %ebx
 722:	5e                   	pop    %esi
 723:	5f                   	pop    %edi
 724:	5d                   	pop    %ebp
 725:	c3                   	ret    
    if(p->s.size >= nunits){
 726:	89 d0                	mov    %edx,%eax
 728:	89 fa                	mov    %edi,%edx
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 730:	39 ce                	cmp    %ecx,%esi
 732:	74 4c                	je     780 <malloc+0xf0>
        p->s.size -= nunits;
 734:	29 f1                	sub    %esi,%ecx
 736:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 739:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 73c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 73f:	89 15 a8 0a 00 00    	mov    %edx,0xaa8
}
 745:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 748:	83 c0 08             	add    $0x8,%eax
}
 74b:	5b                   	pop    %ebx
 74c:	5e                   	pop    %esi
 74d:	5f                   	pop    %edi
 74e:	5d                   	pop    %ebp
 74f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 750:	c7 05 a8 0a 00 00 ac 	movl   $0xaac,0xaa8
 757:	0a 00 00 
    base.s.size = 0;
 75a:	bf ac 0a 00 00       	mov    $0xaac,%edi
    base.s.ptr = freep = prevp = &base;
 75f:	c7 05 ac 0a 00 00 ac 	movl   $0xaac,0xaac
 766:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 769:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 76b:	c7 05 b0 0a 00 00 00 	movl   $0x0,0xab0
 772:	00 00 00 
    if(p->s.size >= nunits){
 775:	e9 42 ff ff ff       	jmp    6bc <malloc+0x2c>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb b9                	jmp    73f <malloc+0xaf>
