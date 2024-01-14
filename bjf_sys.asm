
_bjf_sys:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "date.h"



int main(int argc, char* argv[]){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp

    if(argc < 5){
  18:	83 39 04             	cmpl   $0x4,(%ecx)
int main(int argc, char* argv[]){
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
    if(argc < 5){
  1e:	7f 20                	jg     40 <main+0x40>
        printf(1, "not enough args\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 38 08 00 00       	push   $0x838
  28:	6a 01                	push   $0x1
  2a:	e8 a1 04 00 00       	call   4d0 <printf>
    }
    bjf_validation_system(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]));
    exit();
    

  2f:	8d 65 f0             	lea    -0x10(%ebp),%esp
  32:	b8 01 00 00 00       	mov    $0x1,%eax
  37:	59                   	pop    %ecx
  38:	5b                   	pop    %ebx
  39:	5e                   	pop    %esi
  3a:	5f                   	pop    %edi
  3b:	5d                   	pop    %ebp
  3c:	8d 61 fc             	lea    -0x4(%ecx),%esp
  3f:	c3                   	ret    
    bjf_validation_system(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]));
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	ff 73 10             	pushl  0x10(%ebx)
  46:	e8 35 02 00 00       	call   280 <atoi>
  4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  4e:	58                   	pop    %eax
  4f:	ff 73 0c             	pushl  0xc(%ebx)
  52:	e8 29 02 00 00       	call   280 <atoi>
  57:	5a                   	pop    %edx
  58:	ff 73 08             	pushl  0x8(%ebx)
  5b:	89 c7                	mov    %eax,%edi
  5d:	e8 1e 02 00 00       	call   280 <atoi>
  62:	59                   	pop    %ecx
  63:	ff 73 04             	pushl  0x4(%ebx)
  66:	89 c6                	mov    %eax,%esi
  68:	e8 13 02 00 00       	call   280 <atoi>
  6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  70:	52                   	push   %edx
  71:	57                   	push   %edi
  72:	56                   	push   %esi
  73:	50                   	push   %eax
  74:	e8 5a 03 00 00       	call   3d3 <bjf_validation_system>
    exit();
  79:	83 c4 20             	add    $0x20,%esp
  7c:	e8 72 02 00 00       	call   2f3 <exit>
  81:	66 90                	xchg   %ax,%ax
  83:	66 90                	xchg   %ax,%ax
  85:	66 90                	xchg   %ax,%ax
  87:	66 90                	xchg   %ax,%ax
  89:	66 90                	xchg   %ax,%ax
  8b:	66 90                	xchg   %ax,%ax
  8d:	66 90                	xchg   %ax,%ax
  8f:	90                   	nop

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  95:	31 c0                	xor    %eax,%eax
{
  97:	89 e5                	mov    %esp,%ebp
  99:	53                   	push   %ebx
  9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
  a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a7:	83 c0 01             	add    $0x1,%eax
  aa:	84 d2                	test   %dl,%dl
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	89 c8                	mov    %ecx,%eax
  b0:	5b                   	pop    %ebx
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    
  b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	f3 0f 1e fb          	endbr32 
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	53                   	push   %ebx
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ce:	0f b6 01             	movzbl (%ecx),%eax
  d1:	0f b6 1a             	movzbl (%edx),%ebx
  d4:	84 c0                	test   %al,%al
  d6:	75 19                	jne    f1 <strcmp+0x31>
  d8:	eb 26                	jmp    100 <strcmp+0x40>
  da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  e0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  e4:	83 c1 01             	add    $0x1,%ecx
  e7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  ea:	0f b6 1a             	movzbl (%edx),%ebx
  ed:	84 c0                	test   %al,%al
  ef:	74 0f                	je     100 <strcmp+0x40>
  f1:	38 d8                	cmp    %bl,%al
  f3:	74 eb                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  f5:	29 d8                	sub    %ebx,%eax
}
  f7:	5b                   	pop    %ebx
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 102:	29 d8                	sub    %ebx,%eax
}
 104:	5b                   	pop    %ebx
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 11a:	80 3a 00             	cmpb   $0x0,(%edx)
 11d:	74 21                	je     140 <strlen+0x30>
 11f:	31 c0                	xor    %eax,%eax
 121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 128:	83 c0 01             	add    $0x1,%eax
 12b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 12f:	89 c1                	mov    %eax,%ecx
 131:	75 f5                	jne    128 <strlen+0x18>
    ;
  return n;
}
 133:	89 c8                	mov    %ecx,%eax
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 140:	31 c9                	xor    %ecx,%ecx
}
 142:	5d                   	pop    %ebp
 143:	89 c8                	mov    %ecx,%eax
 145:	c3                   	ret    
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	57                   	push   %edi
 158:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 15b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	89 d7                	mov    %edx,%edi
 163:	fc                   	cld    
 164:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 166:	89 d0                	mov    %edx,%eax
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 17e:	0f b6 10             	movzbl (%eax),%edx
 181:	84 d2                	test   %dl,%dl
 183:	75 16                	jne    19b <strchr+0x2b>
 185:	eb 21                	jmp    1a8 <strchr+0x38>
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax
 190:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 194:	83 c0 01             	add    $0x1,%eax
 197:	84 d2                	test   %dl,%dl
 199:	74 0d                	je     1a8 <strchr+0x38>
    if(*s == c)
 19b:	38 d1                	cmp    %dl,%cl
 19d:	75 f1                	jne    190 <strchr+0x20>
      return (char*)s;
  return 0;
}
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1a8:	31 c0                	xor    %eax,%eax
}
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b9:	31 f6                	xor    %esi,%esi
{
 1bb:	53                   	push   %ebx
 1bc:	89 f3                	mov    %esi,%ebx
 1be:	83 ec 1c             	sub    $0x1c,%esp
 1c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c4:	eb 33                	jmp    1f9 <gets+0x49>
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1d6:	6a 01                	push   $0x1
 1d8:	50                   	push   %eax
 1d9:	6a 00                	push   $0x0
 1db:	e8 2b 01 00 00       	call   30b <read>
    if(cc < 1)
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	85 c0                	test   %eax,%eax
 1e5:	7e 1c                	jle    203 <gets+0x53>
      break;
    buf[i++] = c;
 1e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1eb:	83 c7 01             	add    $0x1,%edi
 1ee:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1f1:	3c 0a                	cmp    $0xa,%al
 1f3:	74 23                	je     218 <gets+0x68>
 1f5:	3c 0d                	cmp    $0xd,%al
 1f7:	74 1f                	je     218 <gets+0x68>
  for(i=0; i+1 < max; ){
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	89 fe                	mov    %edi,%esi
 1fe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 201:	7c cd                	jl     1d0 <gets+0x20>
 203:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 205:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 208:	c6 03 00             	movb   $0x0,(%ebx)
}
 20b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20e:	5b                   	pop    %ebx
 20f:	5e                   	pop    %esi
 210:	5f                   	pop    %edi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 217:	90                   	nop
 218:	8b 75 08             	mov    0x8(%ebp),%esi
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	01 de                	add    %ebx,%esi
 220:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 222:	c6 03 00             	movb   $0x0,(%ebx)
}
 225:	8d 65 f4             	lea    -0xc(%ebp),%esp
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5f                   	pop    %edi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	56                   	push   %esi
 238:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	6a 00                	push   $0x0
 23e:	ff 75 08             	pushl  0x8(%ebp)
 241:	e8 ed 00 00 00       	call   333 <open>
  if(fd < 0)
 246:	83 c4 10             	add    $0x10,%esp
 249:	85 c0                	test   %eax,%eax
 24b:	78 2b                	js     278 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	ff 75 0c             	pushl  0xc(%ebp)
 253:	89 c3                	mov    %eax,%ebx
 255:	50                   	push   %eax
 256:	e8 f0 00 00 00       	call   34b <fstat>
  close(fd);
 25b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25e:	89 c6                	mov    %eax,%esi
  close(fd);
 260:	e8 b6 00 00 00       	call   31b <close>
  return r;
 265:	83 c4 10             	add    $0x10,%esp
}
 268:	8d 65 f8             	lea    -0x8(%ebp),%esp
 26b:	89 f0                	mov    %esi,%eax
 26d:	5b                   	pop    %ebx
 26e:	5e                   	pop    %esi
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    
 271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 278:	be ff ff ff ff       	mov    $0xffffffff,%esi
 27d:	eb e9                	jmp    268 <stat+0x38>
 27f:	90                   	nop

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	53                   	push   %ebx
 288:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28b:	0f be 02             	movsbl (%edx),%eax
 28e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 291:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 294:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 299:	77 1a                	ja     2b5 <atoi+0x35>
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop
    n = n*10 + *s++ - '0';
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2aa:	0f be 02             	movsbl (%edx),%eax
 2ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	89 c8                	mov    %ecx,%eax
 2b7:	5b                   	pop    %ebx
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    
 2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	8b 45 10             	mov    0x10(%ebp),%eax
 2cb:	8b 55 08             	mov    0x8(%ebp),%edx
 2ce:	56                   	push   %esi
 2cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	85 c0                	test   %eax,%eax
 2d4:	7e 0f                	jle    2e5 <memmove+0x25>
 2d6:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d8:	89 d7                	mov    %edx,%edi
 2da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 393:	b8 18 00 00 00       	mov    $0x18,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <get_uncle_count>:
SYSCALL(get_uncle_count)
 39b:	b8 17 00 00 00       	mov    $0x17,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <get_pid>:
SYSCALL(get_pid)
 3a3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <copy_file>:
SYSCALL(copy_file)
 3ab:	b8 16 00 00 00       	mov    $0x16,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <find_digital_root>:
SYSCALL(find_digital_root)
 3b3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <get_parent>:
SYSCALL(get_parent)
 3bb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <change_queue>:
SYSCALL(change_queue)
 3c3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <bjf_validation_process>:
SYSCALL(bjf_validation_process)
 3cb:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <bjf_validation_system>:
SYSCALL(bjf_validation_system)
 3d3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <print_info>:
SYSCALL(print_info)
 3db:	b8 20 00 00 00       	mov    $0x20,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <print_lopck_que>:
SYSCALL(print_lopck_que)
 3e3:	b8 21 00 00 00       	mov    $0x21,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <plock_test>:
SYSCALL(plock_test)
 3eb:	b8 22 00 00 00       	mov    $0x22,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <open_shm>:
SYSCALL(open_shm)
 3f3:	b8 23 00 00 00       	mov    $0x23,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <Aquire>:
SYSCALL(Aquire)
 3fb:	b8 24 00 00 00       	mov    $0x24,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <R>:
SYSCALL(R)
 403:	b8 25 00 00 00       	mov    $0x25,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <C>:
SYSCALL(C)
 40b:	b8 26 00 00 00       	mov    $0x26,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    
 413:	66 90                	xchg   %ax,%ax
 415:	66 90                	xchg   %ax,%ax
 417:	66 90                	xchg   %ax,%ax
 419:	66 90                	xchg   %ax,%ax
 41b:	66 90                	xchg   %ax,%ax
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 3c             	sub    $0x3c,%esp
 429:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 42c:	89 d1                	mov    %edx,%ecx
{
 42e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 431:	85 d2                	test   %edx,%edx
 433:	0f 89 7f 00 00 00    	jns    4b8 <printint+0x98>
 439:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43d:	74 79                	je     4b8 <printint+0x98>
    neg = 1;
 43f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 446:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 448:	31 db                	xor    %ebx,%ebx
 44a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 450:	89 c8                	mov    %ecx,%eax
 452:	31 d2                	xor    %edx,%edx
 454:	89 cf                	mov    %ecx,%edi
 456:	f7 75 c4             	divl   -0x3c(%ebp)
 459:	0f b6 92 50 08 00 00 	movzbl 0x850(%edx),%edx
 460:	89 45 c0             	mov    %eax,-0x40(%ebp)
 463:	89 d8                	mov    %ebx,%eax
 465:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 46b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 46e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 471:	76 dd                	jbe    450 <printint+0x30>
  if(neg)
 473:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 476:	85 c9                	test   %ecx,%ecx
 478:	74 0c                	je     486 <printint+0x66>
    buf[i++] = '-';
 47a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 47f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 481:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 486:	8b 7d b8             	mov    -0x48(%ebp),%edi
 489:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 48d:	eb 07                	jmp    496 <printint+0x76>
 48f:	90                   	nop
 490:	0f b6 13             	movzbl (%ebx),%edx
 493:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 496:	83 ec 04             	sub    $0x4,%esp
 499:	88 55 d7             	mov    %dl,-0x29(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	56                   	push   %esi
 49f:	57                   	push   %edi
 4a0:	e8 6e fe ff ff       	call   313 <write>
  while(--i >= 0)
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x70>
    putc(fd, buf[i]);
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4bf:	eb 87                	jmp    448 <printint+0x28>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	57                   	push   %edi
 4d8:	56                   	push   %esi
 4d9:	53                   	push   %ebx
 4da:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4dd:	8b 75 0c             	mov    0xc(%ebp),%esi
 4e0:	0f b6 1e             	movzbl (%esi),%ebx
 4e3:	84 db                	test   %bl,%bl
 4e5:	0f 84 b4 00 00 00    	je     59f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 4eb:	8d 45 10             	lea    0x10(%ebp),%eax
 4ee:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4f1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4f4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 4f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4f9:	eb 33                	jmp    52e <printf+0x5e>
 4fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop
 500:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 503:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 17                	je     524 <printf+0x54>
  write(fd, &c, 1);
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	88 5d e7             	mov    %bl,-0x19(%ebp)
 513:	6a 01                	push   $0x1
 515:	57                   	push   %edi
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 f5 fd ff ff       	call   313 <write>
 51e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 521:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 524:	0f b6 1e             	movzbl (%esi),%ebx
 527:	83 c6 01             	add    $0x1,%esi
 52a:	84 db                	test   %bl,%bl
 52c:	74 71                	je     59f <printf+0xcf>
    c = fmt[i] & 0xff;
 52e:	0f be cb             	movsbl %bl,%ecx
 531:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 534:	85 d2                	test   %edx,%edx
 536:	74 c8                	je     500 <printf+0x30>
      }
    } else if(state == '%'){
 538:	83 fa 25             	cmp    $0x25,%edx
 53b:	75 e7                	jne    524 <printf+0x54>
      if(c == 'd'){
 53d:	83 f8 64             	cmp    $0x64,%eax
 540:	0f 84 9a 00 00 00    	je     5e0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 546:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 54c:	83 f9 70             	cmp    $0x70,%ecx
 54f:	74 5f                	je     5b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 551:	83 f8 73             	cmp    $0x73,%eax
 554:	0f 84 d6 00 00 00    	je     630 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55a:	83 f8 63             	cmp    $0x63,%eax
 55d:	0f 84 8d 00 00 00    	je     5f0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 563:	83 f8 25             	cmp    $0x25,%eax
 566:	0f 84 b4 00 00 00    	je     620 <printf+0x150>
  write(fd, &c, 1);
 56c:	83 ec 04             	sub    $0x4,%esp
 56f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 573:	6a 01                	push   $0x1
 575:	57                   	push   %edi
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 95 fd ff ff       	call   313 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 57e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 581:	83 c4 0c             	add    $0xc,%esp
 584:	6a 01                	push   $0x1
 586:	83 c6 01             	add    $0x1,%esi
 589:	57                   	push   %edi
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 81 fd ff ff       	call   313 <write>
  for(i = 0; fmt[i]; i++){
 592:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 596:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 599:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 59b:	84 db                	test   %bl,%bl
 59d:	75 8f                	jne    52e <printf+0x5e>
    }
  }
}
 59f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b8:	6a 00                	push   $0x0
 5ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	8b 13                	mov    (%ebx),%edx
 5c2:	e8 59 fe ff ff       	call   420 <printint>
        ap++;
 5c7:	89 d8                	mov    %ebx,%eax
 5c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cc:	31 d2                	xor    %edx,%edx
        ap++;
 5ce:	83 c0 04             	add    $0x4,%eax
 5d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d4:	e9 4b ff ff ff       	jmp    524 <printf+0x54>
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	eb ce                	jmp    5ba <printf+0xea>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 5f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5f6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5f8:	6a 01                	push   $0x1
        ap++;
 5fa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 5fd:	57                   	push   %edi
 5fe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 601:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 604:	e8 0a fd ff ff       	call   313 <write>
        ap++;
 609:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 60c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60f:	31 d2                	xor    %edx,%edx
 611:	e9 0e ff ff ff       	jmp    524 <printf+0x54>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 620:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
 626:	e9 59 ff ff ff       	jmp    584 <printf+0xb4>
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
        s = (char*)*ap;
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
 633:	8b 18                	mov    (%eax),%ebx
        ap++;
 635:	83 c0 04             	add    $0x4,%eax
 638:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 63b:	85 db                	test   %ebx,%ebx
 63d:	74 17                	je     656 <printf+0x186>
        while(*s != 0){
 63f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 642:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 644:	84 c0                	test   %al,%al
 646:	0f 84 d8 fe ff ff    	je     524 <printf+0x54>
 64c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 64f:	89 de                	mov    %ebx,%esi
 651:	8b 5d 08             	mov    0x8(%ebp),%ebx
 654:	eb 1a                	jmp    670 <printf+0x1a0>
          s = "(null)";
 656:	bb 49 08 00 00       	mov    $0x849,%ebx
        while(*s != 0){
 65b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65e:	b8 28 00 00 00       	mov    $0x28,%eax
 663:	89 de                	mov    %ebx,%esi
 665:	8b 5d 08             	mov    0x8(%ebp),%ebx
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
  write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
          s++;
 673:	83 c6 01             	add    $0x1,%esi
 676:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 679:	6a 01                	push   $0x1
 67b:	57                   	push   %edi
 67c:	53                   	push   %ebx
 67d:	e8 91 fc ff ff       	call   313 <write>
        while(*s != 0){
 682:	0f b6 06             	movzbl (%esi),%eax
 685:	83 c4 10             	add    $0x10,%esp
 688:	84 c0                	test   %al,%al
 68a:	75 e4                	jne    670 <printf+0x1a0>
 68c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 8e fe ff ff       	jmp    524 <printf+0x54>
 696:	66 90                	xchg   %ax,%ax
 698:	66 90                	xchg   %ax,%ax
 69a:	66 90                	xchg   %ax,%ax
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	a1 18 0b 00 00       	mov    0xb18,%eax
{
 6aa:	89 e5                	mov    %esp,%ebp
 6ac:	57                   	push   %edi
 6ad:	56                   	push   %esi
 6ae:	53                   	push   %ebx
 6af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 6b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	39 c8                	cmp    %ecx,%eax
 6b9:	73 15                	jae    6d0 <free+0x30>
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
 6c0:	39 d1                	cmp    %edx,%ecx
 6c2:	72 14                	jb     6d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	39 d0                	cmp    %edx,%eax
 6c6:	73 10                	jae    6d8 <free+0x38>
{
 6c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	39 c8                	cmp    %ecx,%eax
 6ce:	72 f0                	jb     6c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	39 d0                	cmp    %edx,%eax
 6d2:	72 f4                	jb     6c8 <free+0x28>
 6d4:	39 d1                	cmp    %edx,%ecx
 6d6:	73 f0                	jae    6c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6de:	39 fa                	cmp    %edi,%edx
 6e0:	74 1e                	je     700 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6e5:	8b 50 04             	mov    0x4(%eax),%edx
 6e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6eb:	39 f1                	cmp    %esi,%ecx
 6ed:	74 28                	je     717 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 6f1:	5b                   	pop    %ebx
  freep = p;
 6f2:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 700:	03 72 04             	add    0x4(%edx),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 12                	mov    (%edx),%edx
 70a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 d8                	jne    6ef <free+0x4f>
    p->s.size += bp->s.size;
 717:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 71a:	a3 18 0b 00 00       	mov    %eax,0xb18
    p->s.size += bp->s.size;
 71f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 722:	8b 53 f8             	mov    -0x8(%ebx),%edx
 725:	89 10                	mov    %edx,(%eax)
}
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	f3 0f 1e fb          	endbr32 
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	57                   	push   %edi
 738:	56                   	push   %esi
 739:	53                   	push   %ebx
 73a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 740:	8b 3d 18 0b 00 00    	mov    0xb18,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 746:	8d 70 07             	lea    0x7(%eax),%esi
 749:	c1 ee 03             	shr    $0x3,%esi
 74c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 74f:	85 ff                	test   %edi,%edi
 751:	0f 84 a9 00 00 00    	je     800 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 757:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 759:	8b 48 04             	mov    0x4(%eax),%ecx
 75c:	39 f1                	cmp    %esi,%ecx
 75e:	73 6d                	jae    7cd <malloc+0x9d>
 760:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 766:	bb 00 10 00 00       	mov    $0x1000,%ebx
 76b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 76e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 778:	eb 17                	jmp    791 <malloc+0x61>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 780:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 782:	8b 4a 04             	mov    0x4(%edx),%ecx
 785:	39 f1                	cmp    %esi,%ecx
 787:	73 4f                	jae    7d8 <malloc+0xa8>
 789:	8b 3d 18 0b 00 00    	mov    0xb18,%edi
 78f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 791:	39 c7                	cmp    %eax,%edi
 793:	75 eb                	jne    780 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	ff 75 e4             	pushl  -0x1c(%ebp)
 79b:	e8 db fb ff ff       	call   37b <sbrk>
  if(p == (char*)-1)
 7a0:	83 c4 10             	add    $0x10,%esp
 7a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7a6:	74 1b                	je     7c3 <malloc+0x93>
  hp->s.size = nu;
 7a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7ab:	83 ec 0c             	sub    $0xc,%esp
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	50                   	push   %eax
 7b2:	e8 e9 fe ff ff       	call   6a0 <free>
  return freep;
 7b7:	a1 18 0b 00 00       	mov    0xb18,%eax
      if((p = morecore(nunits)) == 0)
 7bc:	83 c4 10             	add    $0x10,%esp
 7bf:	85 c0                	test   %eax,%eax
 7c1:	75 bd                	jne    780 <malloc+0x50>
        return 0;
  }
}
 7c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7c6:	31 c0                	xor    %eax,%eax
}
 7c8:	5b                   	pop    %ebx
 7c9:	5e                   	pop    %esi
 7ca:	5f                   	pop    %edi
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret    
    if(p->s.size >= nunits){
 7cd:	89 c2                	mov    %eax,%edx
 7cf:	89 f8                	mov    %edi,%eax
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7d8:	39 ce                	cmp    %ecx,%esi
 7da:	74 54                	je     830 <malloc+0x100>
        p->s.size -= nunits;
 7dc:	29 f1                	sub    %esi,%ecx
 7de:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 7e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 7e4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 7e7:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 7ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7ef:	8d 42 08             	lea    0x8(%edx),%eax
}
 7f2:	5b                   	pop    %ebx
 7f3:	5e                   	pop    %esi
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 800:	c7 05 18 0b 00 00 1c 	movl   $0xb1c,0xb18
 807:	0b 00 00 
    base.s.size = 0;
 80a:	bf 1c 0b 00 00       	mov    $0xb1c,%edi
    base.s.ptr = freep = prevp = &base;
 80f:	c7 05 1c 0b 00 00 1c 	movl   $0xb1c,0xb1c
 816:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 81b:	c7 05 20 0b 00 00 00 	movl   $0x0,0xb20
 822:	00 00 00 
    if(p->s.size >= nunits){
 825:	e9 36 ff ff ff       	jmp    760 <malloc+0x30>
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 830:	8b 0a                	mov    (%edx),%ecx
 832:	89 08                	mov    %ecx,(%eax)
 834:	eb b1                	jmp    7e7 <malloc+0xb7>
