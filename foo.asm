
_foo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
    int i = fork();
   a:	e8 6c 02 00 00       	call   27b <fork>
    if (i == 0)
   f:	85 c0                	test   %eax,%eax
  11:	75 02                	jne    15 <main+0x15>
    {
        while (1)
  13:	eb fe                	jmp    13 <main+0x13>
            ;
    }
    else
    {
        for (;;)
  15:	eb fe                	jmp    15 <main+0x15>
  17:	66 90                	xchg   %ax,%ax
  19:	66 90                	xchg   %ax,%ax
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  20:	f3 0f 1e fb          	endbr32 
  24:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  25:	31 c0                	xor    %eax,%eax
{
  27:	89 e5                	mov    %esp,%ebp
  29:	53                   	push   %ebx
  2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
  30:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  34:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  37:	83 c0 01             	add    $0x1,%eax
  3a:	84 d2                	test   %dl,%dl
  3c:	75 f2                	jne    30 <strcpy+0x10>
    ;
  return os;
}
  3e:	89 c8                	mov    %ecx,%eax
  40:	5b                   	pop    %ebx
  41:	5d                   	pop    %ebp
  42:	c3                   	ret    
  43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	53                   	push   %ebx
  58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  5e:	0f b6 01             	movzbl (%ecx),%eax
  61:	0f b6 1a             	movzbl (%edx),%ebx
  64:	84 c0                	test   %al,%al
  66:	75 19                	jne    81 <strcmp+0x31>
  68:	eb 26                	jmp    90 <strcmp+0x40>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  70:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  74:	83 c1 01             	add    $0x1,%ecx
  77:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  7a:	0f b6 1a             	movzbl (%edx),%ebx
  7d:	84 c0                	test   %al,%al
  7f:	74 0f                	je     90 <strcmp+0x40>
  81:	38 d8                	cmp    %bl,%al
  83:	74 eb                	je     70 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  85:	29 d8                	sub    %ebx,%eax
}
  87:	5b                   	pop    %ebx
  88:	5d                   	pop    %ebp
  89:	c3                   	ret    
  8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  90:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  92:	29 d8                	sub    %ebx,%eax
}
  94:	5b                   	pop    %ebx
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    
  97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9e:	66 90                	xchg   %ax,%ax

000000a0 <strlen>:

uint
strlen(const char *s)
{
  a0:	f3 0f 1e fb          	endbr32 
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  aa:	80 3a 00             	cmpb   $0x0,(%edx)
  ad:	74 21                	je     d0 <strlen+0x30>
  af:	31 c0                	xor    %eax,%eax
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  bf:	89 c1                	mov    %eax,%ecx
  c1:	75 f5                	jne    b8 <strlen+0x18>
    ;
  return n;
}
  c3:	89 c8                	mov    %ecx,%eax
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
  d0:	31 c9                	xor    %ecx,%ecx
}
  d2:	5d                   	pop    %ebp
  d3:	89 c8                	mov    %ecx,%eax
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
  e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	89 d7                	mov    %edx,%edi
  f3:	fc                   	cld    
  f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f6:	89 d0                	mov    %edx,%eax
  f8:	5f                   	pop    %edi
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    
  fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ff:	90                   	nop

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10e:	0f b6 10             	movzbl (%eax),%edx
 111:	84 d2                	test   %dl,%dl
 113:	75 16                	jne    12b <strchr+0x2b>
 115:	eb 21                	jmp    138 <strchr+0x38>
 117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11e:	66 90                	xchg   %ax,%ax
 120:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 124:	83 c0 01             	add    $0x1,%eax
 127:	84 d2                	test   %dl,%dl
 129:	74 0d                	je     138 <strchr+0x38>
    if(*s == c)
 12b:	38 d1                	cmp    %dl,%cl
 12d:	75 f1                	jne    120 <strchr+0x20>
      return (char*)s;
  return 0;
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 138:	31 c0                	xor    %eax,%eax
}
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	57                   	push   %edi
 148:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 149:	31 f6                	xor    %esi,%esi
{
 14b:	53                   	push   %ebx
 14c:	89 f3                	mov    %esi,%ebx
 14e:	83 ec 1c             	sub    $0x1c,%esp
 151:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 154:	eb 33                	jmp    189 <gets+0x49>
 156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	8d 45 e7             	lea    -0x19(%ebp),%eax
 166:	6a 01                	push   $0x1
 168:	50                   	push   %eax
 169:	6a 00                	push   $0x0
 16b:	e8 2b 01 00 00       	call   29b <read>
    if(cc < 1)
 170:	83 c4 10             	add    $0x10,%esp
 173:	85 c0                	test   %eax,%eax
 175:	7e 1c                	jle    193 <gets+0x53>
      break;
    buf[i++] = c;
 177:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 17b:	83 c7 01             	add    $0x1,%edi
 17e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 181:	3c 0a                	cmp    $0xa,%al
 183:	74 23                	je     1a8 <gets+0x68>
 185:	3c 0d                	cmp    $0xd,%al
 187:	74 1f                	je     1a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 189:	83 c3 01             	add    $0x1,%ebx
 18c:	89 fe                	mov    %edi,%esi
 18e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 191:	7c cd                	jl     160 <gets+0x20>
 193:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 195:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 198:	c6 03 00             	movb   $0x0,(%ebx)
}
 19b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19e:	5b                   	pop    %ebx
 19f:	5e                   	pop    %esi
 1a0:	5f                   	pop    %edi
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	8b 75 08             	mov    0x8(%ebp),%esi
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	01 de                	add    %ebx,%esi
 1b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 1b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1b8:	5b                   	pop    %ebx
 1b9:	5e                   	pop    %esi
 1ba:	5f                   	pop    %edi
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	56                   	push   %esi
 1c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	6a 00                	push   $0x0
 1ce:	ff 75 08             	pushl  0x8(%ebp)
 1d1:	e8 ed 00 00 00       	call   2c3 <open>
  if(fd < 0)
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	85 c0                	test   %eax,%eax
 1db:	78 2b                	js     208 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1dd:	83 ec 08             	sub    $0x8,%esp
 1e0:	ff 75 0c             	pushl  0xc(%ebp)
 1e3:	89 c3                	mov    %eax,%ebx
 1e5:	50                   	push   %eax
 1e6:	e8 f0 00 00 00       	call   2db <fstat>
  close(fd);
 1eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ee:	89 c6                	mov    %eax,%esi
  close(fd);
 1f0:	e8 b6 00 00 00       	call   2ab <close>
  return r;
 1f5:	83 c4 10             	add    $0x10,%esp
}
 1f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1fb:	89 f0                	mov    %esi,%eax
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 208:	be ff ff ff ff       	mov    $0xffffffff,%esi
 20d:	eb e9                	jmp    1f8 <stat+0x38>
 20f:	90                   	nop

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	53                   	push   %ebx
 218:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21b:	0f be 02             	movsbl (%edx),%eax
 21e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 221:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 224:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 229:	77 1a                	ja     245 <atoi+0x35>
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop
    n = n*10 + *s++ - '0';
 230:	83 c2 01             	add    $0x1,%edx
 233:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 236:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 23a:	0f be 02             	movsbl (%edx),%eax
 23d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x20>
  return n;
}
 245:	89 c8                	mov    %ecx,%eax
 247:	5b                   	pop    %ebx
 248:	5d                   	pop    %ebp
 249:	c3                   	ret    
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000250 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	57                   	push   %edi
 258:	8b 45 10             	mov    0x10(%ebp),%eax
 25b:	8b 55 08             	mov    0x8(%ebp),%edx
 25e:	56                   	push   %esi
 25f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 262:	85 c0                	test   %eax,%eax
 264:	7e 0f                	jle    275 <memmove+0x25>
 266:	01 d0                	add    %edx,%eax
  dst = vdst;
 268:	89 d7                	mov    %edx,%edi
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 270:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 271:	39 f8                	cmp    %edi,%eax
 273:	75 fb                	jne    270 <memmove+0x20>
  return vdst;
}
 275:	5e                   	pop    %esi
 276:	89 d0                	mov    %edx,%eax
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 323:	b8 18 00 00 00       	mov    $0x18,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <get_uncle_count>:
SYSCALL(get_uncle_count)
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <get_pid>:
SYSCALL(get_pid)
 333:	b8 1a 00 00 00       	mov    $0x1a,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <copy_file>:
SYSCALL(copy_file)
 33b:	b8 16 00 00 00       	mov    $0x16,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <find_digital_root>:
SYSCALL(find_digital_root)
 343:	b8 1b 00 00 00       	mov    $0x1b,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <get_parent>:
SYSCALL(get_parent)
 34b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <change_queue>:
SYSCALL(change_queue)
 353:	b8 1d 00 00 00       	mov    $0x1d,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <bjf_validation_process>:
SYSCALL(bjf_validation_process)
 35b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <bjf_validation_system>:
SYSCALL(bjf_validation_system)
 363:	b8 1f 00 00 00       	mov    $0x1f,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <print_info>:
 36b:	b8 20 00 00 00       	mov    $0x20,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    
 373:	66 90                	xchg   %ax,%ax
 375:	66 90                	xchg   %ax,%ax
 377:	66 90                	xchg   %ax,%ax
 379:	66 90                	xchg   %ax,%ax
 37b:	66 90                	xchg   %ax,%ax
 37d:	66 90                	xchg   %ax,%ax
 37f:	90                   	nop

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 3c             	sub    $0x3c,%esp
 389:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 38c:	89 d1                	mov    %edx,%ecx
{
 38e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 391:	85 d2                	test   %edx,%edx
 393:	0f 89 7f 00 00 00    	jns    418 <printint+0x98>
 399:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 39d:	74 79                	je     418 <printint+0x98>
    neg = 1;
 39f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3a8:	31 db                	xor    %ebx,%ebx
 3aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	89 c8                	mov    %ecx,%eax
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	89 cf                	mov    %ecx,%edi
 3b6:	f7 75 c4             	divl   -0x3c(%ebp)
 3b9:	0f b6 92 a0 07 00 00 	movzbl 0x7a0(%edx),%edx
 3c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3c3:	89 d8                	mov    %ebx,%eax
 3c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3d1:	76 dd                	jbe    3b0 <printint+0x30>
  if(neg)
 3d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3d6:	85 c9                	test   %ecx,%ecx
 3d8:	74 0c                	je     3e6 <printint+0x66>
    buf[i++] = '-';
 3da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3ed:	eb 07                	jmp    3f6 <printint+0x76>
 3ef:	90                   	nop
 3f0:	0f b6 13             	movzbl (%ebx),%edx
 3f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3f6:	83 ec 04             	sub    $0x4,%esp
 3f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3fc:	6a 01                	push   $0x1
 3fe:	56                   	push   %esi
 3ff:	57                   	push   %edi
 400:	e8 9e fe ff ff       	call   2a3 <write>
  while(--i >= 0)
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 de                	cmp    %ebx,%esi
 40a:	75 e4                	jne    3f0 <printint+0x70>
    putc(fd, buf[i]);
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 41f:	eb 87                	jmp    3a8 <printint+0x28>
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	56                   	push   %esi
 439:	53                   	push   %ebx
 43a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 43d:	8b 75 0c             	mov    0xc(%ebp),%esi
 440:	0f b6 1e             	movzbl (%esi),%ebx
 443:	84 db                	test   %bl,%bl
 445:	0f 84 b4 00 00 00    	je     4ff <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 44b:	8d 45 10             	lea    0x10(%ebp),%eax
 44e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 451:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 454:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 456:	89 45 d0             	mov    %eax,-0x30(%ebp)
 459:	eb 33                	jmp    48e <printf+0x5e>
 45b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop
 460:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 463:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 468:	83 f8 25             	cmp    $0x25,%eax
 46b:	74 17                	je     484 <printf+0x54>
  write(fd, &c, 1);
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	88 5d e7             	mov    %bl,-0x19(%ebp)
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	ff 75 08             	pushl  0x8(%ebp)
 479:	e8 25 fe ff ff       	call   2a3 <write>
 47e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 481:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 484:	0f b6 1e             	movzbl (%esi),%ebx
 487:	83 c6 01             	add    $0x1,%esi
 48a:	84 db                	test   %bl,%bl
 48c:	74 71                	je     4ff <printf+0xcf>
    c = fmt[i] & 0xff;
 48e:	0f be cb             	movsbl %bl,%ecx
 491:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 494:	85 d2                	test   %edx,%edx
 496:	74 c8                	je     460 <printf+0x30>
      }
    } else if(state == '%'){
 498:	83 fa 25             	cmp    $0x25,%edx
 49b:	75 e7                	jne    484 <printf+0x54>
      if(c == 'd'){
 49d:	83 f8 64             	cmp    $0x64,%eax
 4a0:	0f 84 9a 00 00 00    	je     540 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ac:	83 f9 70             	cmp    $0x70,%ecx
 4af:	74 5f                	je     510 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4b1:	83 f8 73             	cmp    $0x73,%eax
 4b4:	0f 84 d6 00 00 00    	je     590 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ba:	83 f8 63             	cmp    $0x63,%eax
 4bd:	0f 84 8d 00 00 00    	je     550 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c3:	83 f8 25             	cmp    $0x25,%eax
 4c6:	0f 84 b4 00 00 00    	je     580 <printf+0x150>
  write(fd, &c, 1);
 4cc:	83 ec 04             	sub    $0x4,%esp
 4cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4d3:	6a 01                	push   $0x1
 4d5:	57                   	push   %edi
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 c5 fd ff ff       	call   2a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4de:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4e1:	83 c4 0c             	add    $0xc,%esp
 4e4:	6a 01                	push   $0x1
 4e6:	83 c6 01             	add    $0x1,%esi
 4e9:	57                   	push   %edi
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 b1 fd ff ff       	call   2a3 <write>
  for(i = 0; fmt[i]; i++){
 4f2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4fb:	84 db                	test   %bl,%bl
 4fd:	75 8f                	jne    48e <printf+0x5e>
    }
  }
}
 4ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 502:	5b                   	pop    %ebx
 503:	5e                   	pop    %esi
 504:	5f                   	pop    %edi
 505:	5d                   	pop    %ebp
 506:	c3                   	ret    
 507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	b9 10 00 00 00       	mov    $0x10,%ecx
 518:	6a 00                	push   $0x0
 51a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	8b 13                	mov    (%ebx),%edx
 522:	e8 59 fe ff ff       	call   380 <printint>
        ap++;
 527:	89 d8                	mov    %ebx,%eax
 529:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52c:	31 d2                	xor    %edx,%edx
        ap++;
 52e:	83 c0 04             	add    $0x4,%eax
 531:	89 45 d0             	mov    %eax,-0x30(%ebp)
 534:	e9 4b ff ff ff       	jmp    484 <printf+0x54>
 539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	b9 0a 00 00 00       	mov    $0xa,%ecx
 548:	6a 01                	push   $0x1
 54a:	eb ce                	jmp    51a <printf+0xea>
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 550:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 553:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 556:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 558:	6a 01                	push   $0x1
        ap++;
 55a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 55d:	57                   	push   %edi
 55e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 561:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 564:	e8 3a fd ff ff       	call   2a3 <write>
        ap++;
 569:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 56c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56f:	31 d2                	xor    %edx,%edx
 571:	e9 0e ff ff ff       	jmp    484 <printf+0x54>
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 580:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
 586:	e9 59 ff ff ff       	jmp    4e4 <printf+0xb4>
 58b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
        s = (char*)*ap;
 590:	8b 45 d0             	mov    -0x30(%ebp),%eax
 593:	8b 18                	mov    (%eax),%ebx
        ap++;
 595:	83 c0 04             	add    $0x4,%eax
 598:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 59b:	85 db                	test   %ebx,%ebx
 59d:	74 17                	je     5b6 <printf+0x186>
        while(*s != 0){
 59f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5a2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5a4:	84 c0                	test   %al,%al
 5a6:	0f 84 d8 fe ff ff    	je     484 <printf+0x54>
 5ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5af:	89 de                	mov    %ebx,%esi
 5b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5b4:	eb 1a                	jmp    5d0 <printf+0x1a0>
          s = "(null)";
 5b6:	bb 98 07 00 00       	mov    $0x798,%ebx
        while(*s != 0){
 5bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5be:	b8 28 00 00 00       	mov    $0x28,%eax
 5c3:	89 de                	mov    %ebx,%esi
 5c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5d3:	83 c6 01             	add    $0x1,%esi
 5d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5d9:	6a 01                	push   $0x1
 5db:	57                   	push   %edi
 5dc:	53                   	push   %ebx
 5dd:	e8 c1 fc ff ff       	call   2a3 <write>
        while(*s != 0){
 5e2:	0f b6 06             	movzbl (%esi),%eax
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	84 c0                	test   %al,%al
 5ea:	75 e4                	jne    5d0 <printf+0x1a0>
 5ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5ef:	31 d2                	xor    %edx,%edx
 5f1:	e9 8e fe ff ff       	jmp    484 <printf+0x54>
 5f6:	66 90                	xchg   %ax,%ax
 5f8:	66 90                	xchg   %ax,%ax
 5fa:	66 90                	xchg   %ax,%ax
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	f3 0f 1e fb          	endbr32 
 604:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 605:	a1 40 0a 00 00       	mov    0xa40,%eax
{
 60a:	89 e5                	mov    %esp,%ebp
 60c:	57                   	push   %edi
 60d:	56                   	push   %esi
 60e:	53                   	push   %ebx
 60f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 612:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 614:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 617:	39 c8                	cmp    %ecx,%eax
 619:	73 15                	jae    630 <free+0x30>
 61b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop
 620:	39 d1                	cmp    %edx,%ecx
 622:	72 14                	jb     638 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	39 d0                	cmp    %edx,%eax
 626:	73 10                	jae    638 <free+0x38>
{
 628:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	8b 10                	mov    (%eax),%edx
 62c:	39 c8                	cmp    %ecx,%eax
 62e:	72 f0                	jb     620 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 d0                	cmp    %edx,%eax
 632:	72 f4                	jb     628 <free+0x28>
 634:	39 d1                	cmp    %edx,%ecx
 636:	73 f0                	jae    628 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63e:	39 fa                	cmp    %edi,%edx
 640:	74 1e                	je     660 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 642:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 645:	8b 50 04             	mov    0x4(%eax),%edx
 648:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64b:	39 f1                	cmp    %esi,%ecx
 64d:	74 28                	je     677 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 651:	5b                   	pop    %ebx
  freep = p;
 652:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 657:	5e                   	pop    %esi
 658:	5f                   	pop    %edi
 659:	5d                   	pop    %ebp
 65a:	c3                   	ret    
 65b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 660:	03 72 04             	add    0x4(%edx),%esi
 663:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 12                	mov    (%edx),%edx
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 f1                	cmp    %esi,%ecx
 675:	75 d8                	jne    64f <free+0x4f>
    p->s.size += bp->s.size;
 677:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 67a:	a3 40 0a 00 00       	mov    %eax,0xa40
    p->s.size += bp->s.size;
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 53 f8             	mov    -0x8(%ebx),%edx
 685:	89 10                	mov    %edx,(%eax)
}
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	57                   	push   %edi
 698:	56                   	push   %esi
 699:	53                   	push   %ebx
 69a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6a0:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a6:	8d 70 07             	lea    0x7(%eax),%esi
 6a9:	c1 ee 03             	shr    $0x3,%esi
 6ac:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6af:	85 ff                	test   %edi,%edi
 6b1:	0f 84 a9 00 00 00    	je     760 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6b9:	8b 48 04             	mov    0x4(%eax),%ecx
 6bc:	39 f1                	cmp    %esi,%ecx
 6be:	73 6d                	jae    72d <malloc+0x9d>
 6c0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6cb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ce:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6d8:	eb 17                	jmp    6f1 <malloc+0x61>
 6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6e2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6e5:	39 f1                	cmp    %esi,%ecx
 6e7:	73 4f                	jae    738 <malloc+0xa8>
 6e9:	8b 3d 40 0a 00 00    	mov    0xa40,%edi
 6ef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6f1:	39 c7                	cmp    %eax,%edi
 6f3:	75 eb                	jne    6e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6f5:	83 ec 0c             	sub    $0xc,%esp
 6f8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6fb:	e8 0b fc ff ff       	call   30b <sbrk>
  if(p == (char*)-1)
 700:	83 c4 10             	add    $0x10,%esp
 703:	83 f8 ff             	cmp    $0xffffffff,%eax
 706:	74 1b                	je     723 <malloc+0x93>
  hp->s.size = nu;
 708:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	83 c0 08             	add    $0x8,%eax
 711:	50                   	push   %eax
 712:	e8 e9 fe ff ff       	call   600 <free>
  return freep;
 717:	a1 40 0a 00 00       	mov    0xa40,%eax
      if((p = morecore(nunits)) == 0)
 71c:	83 c4 10             	add    $0x10,%esp
 71f:	85 c0                	test   %eax,%eax
 721:	75 bd                	jne    6e0 <malloc+0x50>
        return 0;
  }
}
 723:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 726:	31 c0                	xor    %eax,%eax
}
 728:	5b                   	pop    %ebx
 729:	5e                   	pop    %esi
 72a:	5f                   	pop    %edi
 72b:	5d                   	pop    %ebp
 72c:	c3                   	ret    
    if(p->s.size >= nunits){
 72d:	89 c2                	mov    %eax,%edx
 72f:	89 f8                	mov    %edi,%eax
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 738:	39 ce                	cmp    %ecx,%esi
 73a:	74 54                	je     790 <malloc+0x100>
        p->s.size -= nunits;
 73c:	29 f1                	sub    %esi,%ecx
 73e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 741:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 744:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 747:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 74c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 74f:	8d 42 08             	lea    0x8(%edx),%eax
}
 752:	5b                   	pop    %ebx
 753:	5e                   	pop    %esi
 754:	5f                   	pop    %edi
 755:	5d                   	pop    %ebp
 756:	c3                   	ret    
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 760:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 767:	0a 00 00 
    base.s.size = 0;
 76a:	bf 44 0a 00 00       	mov    $0xa44,%edi
    base.s.ptr = freep = prevp = &base;
 76f:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 776:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 779:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 77b:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 782:	00 00 00 
    if(p->s.size >= nunits){
 785:	e9 36 ff ff ff       	jmp    6c0 <malloc+0x30>
 78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 790:	8b 0a                	mov    (%edx),%ecx
 792:	89 08                	mov    %ecx,(%eax)
 794:	eb b1                	jmp    747 <malloc+0xb7>
