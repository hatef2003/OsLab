
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 08 08 00 00       	push   $0x808
  19:	e8 55 03 00 00       	call   373 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 84 00 00 00    	js     ad <main+0xad>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 78 03 00 00       	call   3ab <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 6c 03 00 00       	call   3ab <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
 
    printf(1, "init: starting sh%d\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 10 08 00 00       	push   $0x810
  50:	6a 01                	push   $0x1
  52:	e8 89 04 00 00       	call   4e0 <printf>
    pid = fork();
  57:	e8 cf 02 00 00       	call   32b <fork>
    if(pid < 0){
  5c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  5f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  61:	85 c0                	test   %eax,%eax
  63:	78 11                	js     76 <main+0x76>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  65:	74 22                	je     89 <main+0x89>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  67:	e8 cf 02 00 00       	call   33b <wait>
  6c:	85 c0                	test   %eax,%eax
  6e:	78 d8                	js     48 <main+0x48>
  70:	39 c3                	cmp    %eax,%ebx
  72:	75 f3                	jne    67 <main+0x67>
  74:	eb d2                	jmp    48 <main+0x48>
      printf(1, "init: fork failed\n");
  76:	53                   	push   %ebx
  77:	53                   	push   %ebx
  78:	68 25 08 00 00       	push   $0x825
  7d:	6a 01                	push   $0x1
  7f:	e8 5c 04 00 00       	call   4e0 <printf>
      exit();
  84:	e8 aa 02 00 00       	call   333 <exit>
      exec("sh", argv);
  89:	50                   	push   %eax
  8a:	50                   	push   %eax
  8b:	68 5c 0b 00 00       	push   $0xb5c
  90:	68 38 08 00 00       	push   $0x838
  95:	e8 d1 02 00 00       	call   36b <exec>
      printf(1, "init: exec sh failed\n");
  9a:	5a                   	pop    %edx
  9b:	59                   	pop    %ecx
  9c:	68 3b 08 00 00       	push   $0x83b
  a1:	6a 01                	push   $0x1
  a3:	e8 38 04 00 00       	call   4e0 <printf>
      exit();
  a8:	e8 86 02 00 00       	call   333 <exit>
    mknod("console", 1, 1);
  ad:	50                   	push   %eax
  ae:	6a 01                	push   $0x1
  b0:	6a 01                	push   $0x1
  b2:	68 08 08 00 00       	push   $0x808
  b7:	e8 bf 02 00 00       	call   37b <mknod>
    open("console", O_RDWR);
  bc:	58                   	pop    %eax
  bd:	5a                   	pop    %edx
  be:	6a 02                	push   $0x2
  c0:	68 08 08 00 00       	push   $0x808
  c5:	e8 a9 02 00 00       	call   373 <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	e9 57 ff ff ff       	jmp    29 <main+0x29>
  d2:	66 90                	xchg   %ax,%ax
  d4:	66 90                	xchg   %ax,%ax
  d6:	66 90                	xchg   %ax,%ax
  d8:	66 90                	xchg   %ax,%ax
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e1:	31 c0                	xor    %eax,%eax
{
  e3:	89 e5                	mov    %esp,%ebp
  e5:	53                   	push   %ebx
  e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f7:	83 c0 01             	add    $0x1,%eax
  fa:	84 d2                	test   %dl,%dl
  fc:	75 f2                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
  fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 101:	89 c8                	mov    %ecx,%eax
 103:	c9                   	leave  
 104:	c3                   	ret    
 105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 17                	jne    138 <strcmp+0x28>
 121:	eb 3a                	jmp    15d <strcmp+0x4d>
 123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 127:	90                   	nop
 128:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 12c:	83 c2 01             	add    $0x1,%edx
 12f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 132:	84 c0                	test   %al,%al
 134:	74 1a                	je     150 <strcmp+0x40>
    p++, q++;
 136:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 138:	0f b6 19             	movzbl (%ecx),%ebx
 13b:	38 c3                	cmp    %al,%bl
 13d:	74 e9                	je     128 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 13f:	29 d8                	sub    %ebx,%eax
}
 141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 144:	c9                   	leave  
 145:	c3                   	ret    
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 150:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 154:	31 c0                	xor    %eax,%eax
 156:	29 d8                	sub    %ebx,%eax
}
 158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 15b:	c9                   	leave  
 15c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 15d:	0f b6 19             	movzbl (%ecx),%ebx
 160:	31 c0                	xor    %eax,%eax
 162:	eb db                	jmp    13f <strcmp+0x2f>
 164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <strlen>:

uint
strlen(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 3a 00             	cmpb   $0x0,(%edx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 c0                	xor    %eax,%eax
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c0 01             	add    $0x1,%eax
 183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 187:	89 c1                	mov    %eax,%ecx
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	89 c8                	mov    %ecx,%eax
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    
 18f:	90                   	nop
  for(n = 0; s[n]; n++)
 190:	31 c9                	xor    %ecx,%ecx
}
 192:	5d                   	pop    %ebp
 193:	89 c8                	mov    %ecx,%eax
 195:	c3                   	ret    
 196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	75 12                	jne    1e3 <strchr+0x23>
 1d1:	eb 1d                	jmp    1f0 <strchr+0x30>
 1d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d7:	90                   	nop
 1d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	84 d2                	test   %dl,%dl
 1e1:	74 0d                	je     1f0 <strchr+0x30>
    if(*s == c)
 1e3:	38 d1                	cmp    %dl,%cl
 1e5:	75 f1                	jne    1d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1f0:	31 c0                	xor    %eax,%eax
}
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    
 1f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 205:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 208:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 209:	31 db                	xor    %ebx,%ebx
{
 20b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 20e:	eb 27                	jmp    237 <gets+0x37>
    cc = read(0, &c, 1);
 210:	83 ec 04             	sub    $0x4,%esp
 213:	6a 01                	push   $0x1
 215:	57                   	push   %edi
 216:	6a 00                	push   $0x0
 218:	e8 2e 01 00 00       	call   34b <read>
    if(cc < 1)
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	7e 1d                	jle    241 <gets+0x41>
      break;
    buf[i++] = c;
 224:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 228:	8b 55 08             	mov    0x8(%ebp),%edx
 22b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 22f:	3c 0a                	cmp    $0xa,%al
 231:	74 1d                	je     250 <gets+0x50>
 233:	3c 0d                	cmp    $0xd,%al
 235:	74 19                	je     250 <gets+0x50>
  for(i=0; i+1 < max; ){
 237:	89 de                	mov    %ebx,%esi
 239:	83 c3 01             	add    $0x1,%ebx
 23c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23f:	7c cf                	jl     210 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 248:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24b:	5b                   	pop    %ebx
 24c:	5e                   	pop    %esi
 24d:	5f                   	pop    %edi
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    
  buf[i] = '\0';
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	89 de                	mov    %ebx,%esi
 255:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 259:	8d 65 f4             	lea    -0xc(%ebp),%esp
 25c:	5b                   	pop    %ebx
 25d:	5e                   	pop    %esi
 25e:	5f                   	pop    %edi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop

00000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 275:	83 ec 08             	sub    $0x8,%esp
 278:	6a 00                	push   $0x0
 27a:	ff 75 08             	push   0x8(%ebp)
 27d:	e8 f1 00 00 00       	call   373 <open>
  if(fd < 0)
 282:	83 c4 10             	add    $0x10,%esp
 285:	85 c0                	test   %eax,%eax
 287:	78 27                	js     2b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	ff 75 0c             	push   0xc(%ebp)
 28f:	89 c3                	mov    %eax,%ebx
 291:	50                   	push   %eax
 292:	e8 f4 00 00 00       	call   38b <fstat>
  close(fd);
 297:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 29a:	89 c6                	mov    %eax,%esi
  close(fd);
 29c:	e8 ba 00 00 00       	call   35b <close>
  return r;
 2a1:	83 c4 10             	add    $0x10,%esp
}
 2a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a7:	89 f0                	mov    %esi,%eax
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b5:	eb ed                	jmp    2a4 <stat+0x34>
 2b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2be:	66 90                	xchg   %ax,%ax

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	0f be 02             	movsbl (%edx),%eax
 2ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2d5:	77 1e                	ja     2f5 <atoi+0x35>
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2ea:	0f be 02             	movsbl (%edx),%eax
 2ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2f0:	80 fb 09             	cmp    $0x9,%bl
 2f3:	76 eb                	jbe    2e0 <atoi+0x20>
  return n;
}
 2f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 45 10             	mov    0x10(%ebp),%eax
 307:	8b 55 08             	mov    0x8(%ebp),%edx
 30a:	56                   	push   %esi
 30b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 c0                	test   %eax,%eax
 310:	7e 13                	jle    325 <memmove+0x25>
 312:	01 d0                	add    %edx,%eax
  dst = vdst;
 314:	89 d7                	mov    %edx,%edi
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 320:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 321:	39 f8                	cmp    %edi,%eax
 323:	75 fb                	jne    320 <memmove+0x20>
  return vdst;
}
 325:	5e                   	pop    %esi
 326:	89 d0                	mov    %edx,%eax
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    

0000032b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32b:	b8 01 00 00 00       	mov    $0x1,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <exit>:
SYSCALL(exit)
 333:	b8 02 00 00 00       	mov    $0x2,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <wait>:
SYSCALL(wait)
 33b:	b8 03 00 00 00       	mov    $0x3,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <pipe>:
SYSCALL(pipe)
 343:	b8 04 00 00 00       	mov    $0x4,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <read>:
SYSCALL(read)
 34b:	b8 05 00 00 00       	mov    $0x5,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <write>:
SYSCALL(write)
 353:	b8 10 00 00 00       	mov    $0x10,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <close>:
SYSCALL(close)
 35b:	b8 15 00 00 00       	mov    $0x15,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <kill>:
SYSCALL(kill)
 363:	b8 06 00 00 00       	mov    $0x6,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <exec>:
SYSCALL(exec)
 36b:	b8 07 00 00 00       	mov    $0x7,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <open>:
SYSCALL(open)
 373:	b8 0f 00 00 00       	mov    $0xf,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <mknod>:
SYSCALL(mknod)
 37b:	b8 11 00 00 00       	mov    $0x11,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <unlink>:
SYSCALL(unlink)
 383:	b8 12 00 00 00       	mov    $0x12,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <fstat>:
SYSCALL(fstat)
 38b:	b8 08 00 00 00       	mov    $0x8,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <link>:
SYSCALL(link)
 393:	b8 13 00 00 00       	mov    $0x13,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <mkdir>:
SYSCALL(mkdir)
 39b:	b8 14 00 00 00       	mov    $0x14,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <chdir>:
SYSCALL(chdir)
 3a3:	b8 09 00 00 00       	mov    $0x9,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <dup>:
SYSCALL(dup)
 3ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <getpid>:
SYSCALL(getpid)
 3b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <sbrk>:
SYSCALL(sbrk)
 3bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <sleep>:
SYSCALL(sleep)
 3c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <uptime>:
SYSCALL(uptime)
 3cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 3d3:	b8 18 00 00 00       	mov    $0x18,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <get_uncle_count>:
SYSCALL(get_uncle_count)
 3db:	b8 17 00 00 00       	mov    $0x17,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <get_pid>:
SYSCALL(get_pid)
 3e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <copy_file>:
SYSCALL(copy_file)
 3eb:	b8 16 00 00 00       	mov    $0x16,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <find_digital_root>:
SYSCALL(find_digital_root)
 3f3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <get_parent>:
SYSCALL(get_parent)
 3fb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <change_queue>:
SYSCALL(change_queue)
 403:	b8 1d 00 00 00       	mov    $0x1d,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <bjf_validation_process>:
SYSCALL(bjf_validation_process)
 40b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <bjf_validation_system>:
SYSCALL(bjf_validation_system)
 413:	b8 1f 00 00 00       	mov    $0x1f,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <print_info>:
SYSCALL(print_info)
 41b:	b8 20 00 00 00       	mov    $0x20,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <open_sharedmem>:
 423:	b8 21 00 00 00       	mov    $0x21,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    
 42b:	66 90                	xchg   %ax,%ax
 42d:	66 90                	xchg   %ax,%ax
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 3c             	sub    $0x3c,%esp
 439:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 43c:	89 d1                	mov    %edx,%ecx
{
 43e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 441:	85 d2                	test   %edx,%edx
 443:	0f 89 7f 00 00 00    	jns    4c8 <printint+0x98>
 449:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 44d:	74 79                	je     4c8 <printint+0x98>
    neg = 1;
 44f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 456:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 458:	31 db                	xor    %ebx,%ebx
 45a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 460:	89 c8                	mov    %ecx,%eax
 462:	31 d2                	xor    %edx,%edx
 464:	89 cf                	mov    %ecx,%edi
 466:	f7 75 c4             	divl   -0x3c(%ebp)
 469:	0f b6 92 b0 08 00 00 	movzbl 0x8b0(%edx),%edx
 470:	89 45 c0             	mov    %eax,-0x40(%ebp)
 473:	89 d8                	mov    %ebx,%eax
 475:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 478:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 47b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 47e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 481:	76 dd                	jbe    460 <printint+0x30>
  if(neg)
 483:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 486:	85 c9                	test   %ecx,%ecx
 488:	74 0c                	je     496 <printint+0x66>
    buf[i++] = '-';
 48a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 48f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 491:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 496:	8b 7d b8             	mov    -0x48(%ebp),%edi
 499:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 49d:	eb 07                	jmp    4a6 <printint+0x76>
 49f:	90                   	nop
    putc(fd, buf[i]);
 4a0:	0f b6 13             	movzbl (%ebx),%edx
 4a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4a6:	83 ec 04             	sub    $0x4,%esp
 4a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ac:	6a 01                	push   $0x1
 4ae:	56                   	push   %esi
 4af:	57                   	push   %edi
 4b0:	e8 9e fe ff ff       	call   353 <write>
  while(--i >= 0)
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	39 de                	cmp    %ebx,%esi
 4ba:	75 e4                	jne    4a0 <printint+0x70>
}
 4bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5e                   	pop    %esi
 4c1:	5f                   	pop    %edi
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4cf:	eb 87                	jmp    458 <printint+0x28>
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4ec:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4ef:	0f b6 13             	movzbl (%ebx),%edx
 4f2:	84 d2                	test   %dl,%dl
 4f4:	74 6a                	je     560 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4f6:	8d 45 10             	lea    0x10(%ebp),%eax
 4f9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4fc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4ff:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 501:	89 45 d0             	mov    %eax,-0x30(%ebp)
 504:	eb 36                	jmp    53c <printf+0x5c>
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 513:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	74 15                	je     532 <printf+0x52>
  write(fd, &c, 1);
 51d:	83 ec 04             	sub    $0x4,%esp
 520:	88 55 e7             	mov    %dl,-0x19(%ebp)
 523:	6a 01                	push   $0x1
 525:	57                   	push   %edi
 526:	56                   	push   %esi
 527:	e8 27 fe ff ff       	call   353 <write>
 52c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 52f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 532:	0f b6 13             	movzbl (%ebx),%edx
 535:	83 c3 01             	add    $0x1,%ebx
 538:	84 d2                	test   %dl,%dl
 53a:	74 24                	je     560 <printf+0x80>
    c = fmt[i] & 0xff;
 53c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 53f:	85 c9                	test   %ecx,%ecx
 541:	74 cd                	je     510 <printf+0x30>
      }
    } else if(state == '%'){
 543:	83 f9 25             	cmp    $0x25,%ecx
 546:	75 ea                	jne    532 <printf+0x52>
      if(c == 'd'){
 548:	83 f8 25             	cmp    $0x25,%eax
 54b:	0f 84 07 01 00 00    	je     658 <printf+0x178>
 551:	83 e8 63             	sub    $0x63,%eax
 554:	83 f8 15             	cmp    $0x15,%eax
 557:	77 17                	ja     570 <printf+0x90>
 559:	ff 24 85 58 08 00 00 	jmp    *0x858(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 560:	8d 65 f4             	lea    -0xc(%ebp),%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
 568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 576:	6a 01                	push   $0x1
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 57e:	e8 d0 fd ff ff       	call   353 <write>
        putc(fd, c);
 583:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 587:	83 c4 0c             	add    $0xc,%esp
 58a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 58d:	6a 01                	push   $0x1
 58f:	57                   	push   %edi
 590:	56                   	push   %esi
 591:	e8 bd fd ff ff       	call   353 <write>
        putc(fd, c);
 596:	83 c4 10             	add    $0x10,%esp
      state = 0;
 599:	31 c9                	xor    %ecx,%ecx
 59b:	eb 95                	jmp    532 <printf+0x52>
 59d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5a8:	6a 00                	push   $0x0
 5aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5ad:	8b 10                	mov    (%eax),%edx
 5af:	89 f0                	mov    %esi,%eax
 5b1:	e8 7a fe ff ff       	call   430 <printint>
        ap++;
 5b6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bd:	31 c9                	xor    %ecx,%ecx
 5bf:	e9 6e ff ff ff       	jmp    532 <printf+0x52>
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5cb:	8b 10                	mov    (%eax),%edx
        ap++;
 5cd:	83 c0 04             	add    $0x4,%eax
 5d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5d3:	85 d2                	test   %edx,%edx
 5d5:	0f 84 8d 00 00 00    	je     668 <printf+0x188>
        while(*s != 0){
 5db:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5de:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 84 4a ff ff ff    	je     532 <printf+0x52>
 5e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5eb:	89 d3                	mov    %edx,%ebx
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5f3:	83 c3 01             	add    $0x1,%ebx
 5f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5f9:	6a 01                	push   $0x1
 5fb:	57                   	push   %edi
 5fc:	56                   	push   %esi
 5fd:	e8 51 fd ff ff       	call   353 <write>
        while(*s != 0){
 602:	0f b6 03             	movzbl (%ebx),%eax
 605:	83 c4 10             	add    $0x10,%esp
 608:	84 c0                	test   %al,%al
 60a:	75 e4                	jne    5f0 <printf+0x110>
      state = 0;
 60c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 60f:	31 c9                	xor    %ecx,%ecx
 611:	e9 1c ff ff ff       	jmp    532 <printf+0x52>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 620:	83 ec 0c             	sub    $0xc,%esp
 623:	b9 0a 00 00 00       	mov    $0xa,%ecx
 628:	6a 01                	push   $0x1
 62a:	e9 7b ff ff ff       	jmp    5aa <printf+0xca>
 62f:	90                   	nop
        putc(fd, *ap);
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 633:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 636:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 638:	6a 01                	push   $0x1
 63a:	57                   	push   %edi
 63b:	56                   	push   %esi
        putc(fd, *ap);
 63c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 63f:	e8 0f fd ff ff       	call   353 <write>
        ap++;
 644:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 648:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64b:	31 c9                	xor    %ecx,%ecx
 64d:	e9 e0 fe ff ff       	jmp    532 <printf+0x52>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 658:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 65b:	83 ec 04             	sub    $0x4,%esp
 65e:	e9 2a ff ff ff       	jmp    58d <printf+0xad>
 663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 667:	90                   	nop
          s = "(null)";
 668:	ba 51 08 00 00       	mov    $0x851,%edx
        while(*s != 0){
 66d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 670:	b8 28 00 00 00       	mov    $0x28,%eax
 675:	89 d3                	mov    %edx,%ebx
 677:	e9 74 ff ff ff       	jmp    5f0 <printf+0x110>
 67c:	66 90                	xchg   %ax,%ax
 67e:	66 90                	xchg   %ax,%ax

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	a1 64 0b 00 00       	mov    0xb64,%eax
{
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 68e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 698:	89 c2                	mov    %eax,%edx
 69a:	8b 00                	mov    (%eax),%eax
 69c:	39 ca                	cmp    %ecx,%edx
 69e:	73 30                	jae    6d0 <free+0x50>
 6a0:	39 c1                	cmp    %eax,%ecx
 6a2:	72 04                	jb     6a8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	39 c2                	cmp    %eax,%edx
 6a6:	72 f0                	jb     698 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 f8                	cmp    %edi,%eax
 6b0:	74 30                	je     6e2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6b2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b5:	8b 42 04             	mov    0x4(%edx),%eax
 6b8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6bb:	39 f1                	cmp    %esi,%ecx
 6bd:	74 3a                	je     6f9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6bf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6c1:	5b                   	pop    %ebx
  freep = p;
 6c2:	89 15 64 0b 00 00    	mov    %edx,0xb64
}
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	39 c2                	cmp    %eax,%edx
 6d2:	72 c4                	jb     698 <free+0x18>
 6d4:	39 c1                	cmp    %eax,%ecx
 6d6:	73 c0                	jae    698 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6de:	39 f8                	cmp    %edi,%eax
 6e0:	75 d0                	jne    6b2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6e2:	03 70 04             	add    0x4(%eax),%esi
 6e5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	8b 02                	mov    (%edx),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ef:	8b 42 04             	mov    0x4(%edx),%eax
 6f2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6f5:	39 f1                	cmp    %esi,%ecx
 6f7:	75 c6                	jne    6bf <free+0x3f>
    p->s.size += bp->s.size;
 6f9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6fc:	89 15 64 0b 00 00    	mov    %edx,0xb64
    p->s.size += bp->s.size;
 702:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 705:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 708:	89 0a                	mov    %ecx,(%edx)
}
 70a:	5b                   	pop    %ebx
 70b:	5e                   	pop    %esi
 70c:	5f                   	pop    %edi
 70d:	5d                   	pop    %ebp
 70e:	c3                   	ret    
 70f:	90                   	nop

00000710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 71c:	8b 3d 64 0b 00 00    	mov    0xb64,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 722:	8d 70 07             	lea    0x7(%eax),%esi
 725:	c1 ee 03             	shr    $0x3,%esi
 728:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 72b:	85 ff                	test   %edi,%edi
 72d:	0f 84 9d 00 00 00    	je     7d0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 733:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 735:	8b 4a 04             	mov    0x4(%edx),%ecx
 738:	39 f1                	cmp    %esi,%ecx
 73a:	73 6a                	jae    7a6 <malloc+0x96>
 73c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 741:	39 de                	cmp    %ebx,%esi
 743:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 746:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 74d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 750:	eb 17                	jmp    769 <malloc+0x59>
 752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 75a:	8b 48 04             	mov    0x4(%eax),%ecx
 75d:	39 f1                	cmp    %esi,%ecx
 75f:	73 4f                	jae    7b0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 761:	8b 3d 64 0b 00 00    	mov    0xb64,%edi
 767:	89 c2                	mov    %eax,%edx
 769:	39 d7                	cmp    %edx,%edi
 76b:	75 eb                	jne    758 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 76d:	83 ec 0c             	sub    $0xc,%esp
 770:	ff 75 e4             	push   -0x1c(%ebp)
 773:	e8 43 fc ff ff       	call   3bb <sbrk>
  if(p == (char*)-1)
 778:	83 c4 10             	add    $0x10,%esp
 77b:	83 f8 ff             	cmp    $0xffffffff,%eax
 77e:	74 1c                	je     79c <malloc+0x8c>
  hp->s.size = nu;
 780:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	83 c0 08             	add    $0x8,%eax
 789:	50                   	push   %eax
 78a:	e8 f1 fe ff ff       	call   680 <free>
  return freep;
 78f:	8b 15 64 0b 00 00    	mov    0xb64,%edx
      if((p = morecore(nunits)) == 0)
 795:	83 c4 10             	add    $0x10,%esp
 798:	85 d2                	test   %edx,%edx
 79a:	75 bc                	jne    758 <malloc+0x48>
        return 0;
  }
}
 79c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 79f:	31 c0                	xor    %eax,%eax
}
 7a1:	5b                   	pop    %ebx
 7a2:	5e                   	pop    %esi
 7a3:	5f                   	pop    %edi
 7a4:	5d                   	pop    %ebp
 7a5:	c3                   	ret    
    if(p->s.size >= nunits){
 7a6:	89 d0                	mov    %edx,%eax
 7a8:	89 fa                	mov    %edi,%edx
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7b0:	39 ce                	cmp    %ecx,%esi
 7b2:	74 4c                	je     800 <malloc+0xf0>
        p->s.size -= nunits;
 7b4:	29 f1                	sub    %esi,%ecx
 7b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7bc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7bf:	89 15 64 0b 00 00    	mov    %edx,0xb64
}
 7c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7c8:	83 c0 08             	add    $0x8,%eax
}
 7cb:	5b                   	pop    %ebx
 7cc:	5e                   	pop    %esi
 7cd:	5f                   	pop    %edi
 7ce:	5d                   	pop    %ebp
 7cf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 05 64 0b 00 00 68 	movl   $0xb68,0xb64
 7d7:	0b 00 00 
    base.s.size = 0;
 7da:	bf 68 0b 00 00       	mov    $0xb68,%edi
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 68 0b 00 00 68 	movl   $0xb68,0xb68
 7e6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7eb:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 7f2:	00 00 00 
    if(p->s.size >= nunits){
 7f5:	e9 42 ff ff ff       	jmp    73c <malloc+0x2c>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 800:	8b 08                	mov    (%eax),%ecx
 802:	89 0a                	mov    %ecx,(%edx)
 804:	eb b9                	jmp    7bf <malloc+0xaf>
