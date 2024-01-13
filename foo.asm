
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
SYSCALL(print_info)
 36b:	b8 20 00 00 00       	mov    $0x20,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <print_lopck_que>:
SYSCALL(print_lopck_que)
 373:	b8 21 00 00 00       	mov    $0x21,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <plock_test>:
SYSCALL(plock_test)
 37b:	b8 22 00 00 00       	mov    $0x22,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <open_shm>:
 383:	b8 23 00 00 00       	mov    $0x23,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
 399:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 39c:	89 d1                	mov    %edx,%ecx
{
 39e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3a1:	85 d2                	test   %edx,%edx
 3a3:	0f 89 7f 00 00 00    	jns    428 <printint+0x98>
 3a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ad:	74 79                	je     428 <printint+0x98>
    neg = 1;
 3af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3b8:	31 db                	xor    %ebx,%ebx
 3ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	89 c8                	mov    %ecx,%eax
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	89 cf                	mov    %ecx,%edi
 3c6:	f7 75 c4             	divl   -0x3c(%ebp)
 3c9:	0f b6 92 b0 07 00 00 	movzbl 0x7b0(%edx),%edx
 3d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3d3:	89 d8                	mov    %ebx,%eax
 3d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3e1:	76 dd                	jbe    3c0 <printint+0x30>
  if(neg)
 3e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3e6:	85 c9                	test   %ecx,%ecx
 3e8:	74 0c                	je     3f6 <printint+0x66>
    buf[i++] = '-';
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3fd:	eb 07                	jmp    406 <printint+0x76>
 3ff:	90                   	nop
 400:	0f b6 13             	movzbl (%ebx),%edx
 403:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 406:	83 ec 04             	sub    $0x4,%esp
 409:	88 55 d7             	mov    %dl,-0x29(%ebp)
 40c:	6a 01                	push   $0x1
 40e:	56                   	push   %esi
 40f:	57                   	push   %edi
 410:	e8 8e fe ff ff       	call   2a3 <write>
  while(--i >= 0)
 415:	83 c4 10             	add    $0x10,%esp
 418:	39 de                	cmp    %ebx,%esi
 41a:	75 e4                	jne    400 <printint+0x70>
    putc(fd, buf[i]);
}
 41c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 428:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 42f:	eb 87                	jmp    3b8 <printint+0x28>
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	57                   	push   %edi
 448:	56                   	push   %esi
 449:	53                   	push   %ebx
 44a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 44d:	8b 75 0c             	mov    0xc(%ebp),%esi
 450:	0f b6 1e             	movzbl (%esi),%ebx
 453:	84 db                	test   %bl,%bl
 455:	0f 84 b4 00 00 00    	je     50f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 45b:	8d 45 10             	lea    0x10(%ebp),%eax
 45e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 461:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 464:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 466:	89 45 d0             	mov    %eax,-0x30(%ebp)
 469:	eb 33                	jmp    49e <printf+0x5e>
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop
 470:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 473:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	74 17                	je     494 <printf+0x54>
  write(fd, &c, 1);
 47d:	83 ec 04             	sub    $0x4,%esp
 480:	88 5d e7             	mov    %bl,-0x19(%ebp)
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	ff 75 08             	pushl  0x8(%ebp)
 489:	e8 15 fe ff ff       	call   2a3 <write>
 48e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 491:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 494:	0f b6 1e             	movzbl (%esi),%ebx
 497:	83 c6 01             	add    $0x1,%esi
 49a:	84 db                	test   %bl,%bl
 49c:	74 71                	je     50f <printf+0xcf>
    c = fmt[i] & 0xff;
 49e:	0f be cb             	movsbl %bl,%ecx
 4a1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4a4:	85 d2                	test   %edx,%edx
 4a6:	74 c8                	je     470 <printf+0x30>
      }
    } else if(state == '%'){
 4a8:	83 fa 25             	cmp    $0x25,%edx
 4ab:	75 e7                	jne    494 <printf+0x54>
      if(c == 'd'){
 4ad:	83 f8 64             	cmp    $0x64,%eax
 4b0:	0f 84 9a 00 00 00    	je     550 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4bc:	83 f9 70             	cmp    $0x70,%ecx
 4bf:	74 5f                	je     520 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c1:	83 f8 73             	cmp    $0x73,%eax
 4c4:	0f 84 d6 00 00 00    	je     5a0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ca:	83 f8 63             	cmp    $0x63,%eax
 4cd:	0f 84 8d 00 00 00    	je     560 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d3:	83 f8 25             	cmp    $0x25,%eax
 4d6:	0f 84 b4 00 00 00    	je     590 <printf+0x150>
  write(fd, &c, 1);
 4dc:	83 ec 04             	sub    $0x4,%esp
 4df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4e3:	6a 01                	push   $0x1
 4e5:	57                   	push   %edi
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 b5 fd ff ff       	call   2a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4ee:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4f1:	83 c4 0c             	add    $0xc,%esp
 4f4:	6a 01                	push   $0x1
 4f6:	83 c6 01             	add    $0x1,%esi
 4f9:	57                   	push   %edi
 4fa:	ff 75 08             	pushl  0x8(%ebp)
 4fd:	e8 a1 fd ff ff       	call   2a3 <write>
  for(i = 0; fmt[i]; i++){
 502:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 506:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 509:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 50b:	84 db                	test   %bl,%bl
 50d:	75 8f                	jne    49e <printf+0x5e>
    }
  }
}
 50f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 512:	5b                   	pop    %ebx
 513:	5e                   	pop    %esi
 514:	5f                   	pop    %edi
 515:	5d                   	pop    %ebp
 516:	c3                   	ret    
 517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
 528:	6a 00                	push   $0x0
 52a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	8b 13                	mov    (%ebx),%edx
 532:	e8 59 fe ff ff       	call   390 <printint>
        ap++;
 537:	89 d8                	mov    %ebx,%eax
 539:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53c:	31 d2                	xor    %edx,%edx
        ap++;
 53e:	83 c0 04             	add    $0x4,%eax
 541:	89 45 d0             	mov    %eax,-0x30(%ebp)
 544:	e9 4b ff ff ff       	jmp    494 <printf+0x54>
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 0a 00 00 00       	mov    $0xa,%ecx
 558:	6a 01                	push   $0x1
 55a:	eb ce                	jmp    52a <printf+0xea>
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 560:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 563:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 566:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 568:	6a 01                	push   $0x1
        ap++;
 56a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 56d:	57                   	push   %edi
 56e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 571:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 574:	e8 2a fd ff ff       	call   2a3 <write>
        ap++;
 579:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 57c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 57f:	31 d2                	xor    %edx,%edx
 581:	e9 0e ff ff ff       	jmp    494 <printf+0x54>
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 590:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	e9 59 ff ff ff       	jmp    4f4 <printf+0xb4>
 59b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 59f:	90                   	nop
        s = (char*)*ap;
 5a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5a5:	83 c0 04             	add    $0x4,%eax
 5a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5ab:	85 db                	test   %ebx,%ebx
 5ad:	74 17                	je     5c6 <printf+0x186>
        while(*s != 0){
 5af:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5b2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5b4:	84 c0                	test   %al,%al
 5b6:	0f 84 d8 fe ff ff    	je     494 <printf+0x54>
 5bc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5bf:	89 de                	mov    %ebx,%esi
 5c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c4:	eb 1a                	jmp    5e0 <printf+0x1a0>
          s = "(null)";
 5c6:	bb a8 07 00 00       	mov    $0x7a8,%ebx
        while(*s != 0){
 5cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ce:	b8 28 00 00 00       	mov    $0x28,%eax
 5d3:	89 de                	mov    %ebx,%esi
 5d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5e3:	83 c6 01             	add    $0x1,%esi
 5e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e9:	6a 01                	push   $0x1
 5eb:	57                   	push   %edi
 5ec:	53                   	push   %ebx
 5ed:	e8 b1 fc ff ff       	call   2a3 <write>
        while(*s != 0){
 5f2:	0f b6 06             	movzbl (%esi),%eax
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	84 c0                	test   %al,%al
 5fa:	75 e4                	jne    5e0 <printf+0x1a0>
 5fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5ff:	31 d2                	xor    %edx,%edx
 601:	e9 8e fe ff ff       	jmp    494 <printf+0x54>
 606:	66 90                	xchg   %ax,%ax
 608:	66 90                	xchg   %ax,%ax
 60a:	66 90                	xchg   %ax,%ax
 60c:	66 90                	xchg   %ax,%ax
 60e:	66 90                	xchg   %ax,%ax

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	f3 0f 1e fb          	endbr32 
 614:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 615:	a1 50 0a 00 00       	mov    0xa50,%eax
{
 61a:	89 e5                	mov    %esp,%ebp
 61c:	57                   	push   %edi
 61d:	56                   	push   %esi
 61e:	53                   	push   %ebx
 61f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 622:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 624:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	39 c8                	cmp    %ecx,%eax
 629:	73 15                	jae    640 <free+0x30>
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
 630:	39 d1                	cmp    %edx,%ecx
 632:	72 14                	jb     648 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	39 d0                	cmp    %edx,%eax
 636:	73 10                	jae    648 <free+0x38>
{
 638:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	8b 10                	mov    (%eax),%edx
 63c:	39 c8                	cmp    %ecx,%eax
 63e:	72 f0                	jb     630 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	39 d0                	cmp    %edx,%eax
 642:	72 f4                	jb     638 <free+0x28>
 644:	39 d1                	cmp    %edx,%ecx
 646:	73 f0                	jae    638 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 73 fc             	mov    -0x4(%ebx),%esi
 64b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64e:	39 fa                	cmp    %edi,%edx
 650:	74 1e                	je     670 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 652:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 65b:	39 f1                	cmp    %esi,%ecx
 65d:	74 28                	je     687 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 65f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 661:	5b                   	pop    %ebx
  freep = p;
 662:	a3 50 0a 00 00       	mov    %eax,0xa50
}
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
 66b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 670:	03 72 04             	add    0x4(%edx),%esi
 673:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 12                	mov    (%edx),%edx
 67a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 683:	39 f1                	cmp    %esi,%ecx
 685:	75 d8                	jne    65f <free+0x4f>
    p->s.size += bp->s.size;
 687:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 68a:	a3 50 0a 00 00       	mov    %eax,0xa50
    p->s.size += bp->s.size;
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 692:	8b 53 f8             	mov    -0x8(%ebx),%edx
 695:	89 10                	mov    %edx,(%eax)
}
 697:	5b                   	pop    %ebx
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	57                   	push   %edi
 6a8:	56                   	push   %esi
 6a9:	53                   	push   %ebx
 6aa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6b0:	8b 3d 50 0a 00 00    	mov    0xa50,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b6:	8d 70 07             	lea    0x7(%eax),%esi
 6b9:	c1 ee 03             	shr    $0x3,%esi
 6bc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6bf:	85 ff                	test   %edi,%edi
 6c1:	0f 84 a9 00 00 00    	je     770 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6c9:	8b 48 04             	mov    0x4(%eax),%ecx
 6cc:	39 f1                	cmp    %esi,%ecx
 6ce:	73 6d                	jae    73d <malloc+0x9d>
 6d0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6d6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6db:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6de:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6e5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6e8:	eb 17                	jmp    701 <malloc+0x61>
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6f2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6f5:	39 f1                	cmp    %esi,%ecx
 6f7:	73 4f                	jae    748 <malloc+0xa8>
 6f9:	8b 3d 50 0a 00 00    	mov    0xa50,%edi
 6ff:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 701:	39 c7                	cmp    %eax,%edi
 703:	75 eb                	jne    6f0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 705:	83 ec 0c             	sub    $0xc,%esp
 708:	ff 75 e4             	pushl  -0x1c(%ebp)
 70b:	e8 fb fb ff ff       	call   30b <sbrk>
  if(p == (char*)-1)
 710:	83 c4 10             	add    $0x10,%esp
 713:	83 f8 ff             	cmp    $0xffffffff,%eax
 716:	74 1b                	je     733 <malloc+0x93>
  hp->s.size = nu;
 718:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 71b:	83 ec 0c             	sub    $0xc,%esp
 71e:	83 c0 08             	add    $0x8,%eax
 721:	50                   	push   %eax
 722:	e8 e9 fe ff ff       	call   610 <free>
  return freep;
 727:	a1 50 0a 00 00       	mov    0xa50,%eax
      if((p = morecore(nunits)) == 0)
 72c:	83 c4 10             	add    $0x10,%esp
 72f:	85 c0                	test   %eax,%eax
 731:	75 bd                	jne    6f0 <malloc+0x50>
        return 0;
  }
}
 733:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 736:	31 c0                	xor    %eax,%eax
}
 738:	5b                   	pop    %ebx
 739:	5e                   	pop    %esi
 73a:	5f                   	pop    %edi
 73b:	5d                   	pop    %ebp
 73c:	c3                   	ret    
    if(p->s.size >= nunits){
 73d:	89 c2                	mov    %eax,%edx
 73f:	89 f8                	mov    %edi,%eax
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 748:	39 ce                	cmp    %ecx,%esi
 74a:	74 54                	je     7a0 <malloc+0x100>
        p->s.size -= nunits;
 74c:	29 f1                	sub    %esi,%ecx
 74e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 751:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 754:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 757:	a3 50 0a 00 00       	mov    %eax,0xa50
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 75f:	8d 42 08             	lea    0x8(%edx),%eax
}
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5f                   	pop    %edi
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 770:	c7 05 50 0a 00 00 54 	movl   $0xa54,0xa50
 777:	0a 00 00 
    base.s.size = 0;
 77a:	bf 54 0a 00 00       	mov    $0xa54,%edi
    base.s.ptr = freep = prevp = &base;
 77f:	c7 05 54 0a 00 00 54 	movl   $0xa54,0xa54
 786:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 789:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 78b:	c7 05 58 0a 00 00 00 	movl   $0x0,0xa58
 792:	00 00 00 
    if(p->s.size >= nunits){
 795:	e9 36 ff ff ff       	jmp    6d0 <malloc+0x30>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 0a                	mov    (%edx),%ecx
 7a2:	89 08                	mov    %ecx,(%eax)
 7a4:	eb b1                	jmp    757 <malloc+0xb7>
