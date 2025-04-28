
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	fa010113          	addi	sp,sp,-96 # 80019fa0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	067050ef          	jal	ra,8000587c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	07078793          	addi	a5,a5,112 # 800220a0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	9e090913          	addi	s2,s2,-1568 # 80008a30 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	222080e7          	jalr	546(ra) # 8000627c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2c2080e7          	jalr	706(ra) # 80006330 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ca8080e7          	jalr	-856(ra) # 80005d32 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	94450513          	addi	a0,a0,-1724 # 80008a30 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0f8080e7          	jalr	248(ra) # 800061ec <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	fa050513          	addi	a0,a0,-96 # 800220a0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	90e48493          	addi	s1,s1,-1778 # 80008a30 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	150080e7          	jalr	336(ra) # 8000627c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	8f650513          	addi	a0,a0,-1802 # 80008a30 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1ec080e7          	jalr	492(ra) # 80006330 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	072080e7          	jalr	114(ra) # 800001c4 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	8ca50513          	addi	a0,a0,-1846 # 80008a30 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1c2080e7          	jalr	450(ra) # 80006330 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreemem>:

uint64 getfreemem(void){
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	e04a                	sd	s2,0(sp)
    80000182:	1000                	addi	s0,sp,32
  struct run *r;
  r = kmem.freelist;
    80000184:	00009517          	auipc	a0,0x9
    80000188:	8ac50513          	addi	a0,a0,-1876 # 80008a30 <kmem>
    8000018c:	6d04                	ld	s1,24(a0)
  uint64 count = 0;
  acquire(&kmem.lock);
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	0ee080e7          	jalr	238(ra) # 8000627c <acquire>
  while(r){
    80000196:	c48d                	beqz	s1,800001c0 <getfreemem+0x48>
  uint64 count = 0;
    80000198:	4901                	li	s2,0
    count++;
    8000019a:	0905                	addi	s2,s2,1
    r = r -> next;
    8000019c:	6084                	ld	s1,0(s1)
  while(r){
    8000019e:	fcf5                	bnez	s1,8000019a <getfreemem+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	89050513          	addi	a0,a0,-1904 # 80008a30 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	188080e7          	jalr	392(ra) # 80006330 <release>
  return (count * 4096);
}
    800001b0:	00c91513          	slli	a0,s2,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6902                	ld	s2,0(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  uint64 count = 0;
    800001c0:	4901                	li	s2,0
    800001c2:	bff9                	j	800001a0 <getfreemem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ce09                	beqz	a2,800001e4 <memset+0x20>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	fff6071b          	addiw	a4,a2,-1
    800001d2:	1702                	slli	a4,a4,0x20
    800001d4:	9301                	srli	a4,a4,0x20
    800001d6:	0705                	addi	a4,a4,1
    800001d8:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001de:	0785                	addi	a5,a5,1
    800001e0:	fee79de3          	bne	a5,a4,800001da <memset+0x16>
  }
  return dst;
}
    800001e4:	6422                	ld	s0,8(sp)
    800001e6:	0141                	addi	sp,sp,16
    800001e8:	8082                	ret

00000000800001ea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001ea:	1141                	addi	sp,sp,-16
    800001ec:	e422                	sd	s0,8(sp)
    800001ee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001f0:	ca05                	beqz	a2,80000220 <memcmp+0x36>
    800001f2:	fff6069b          	addiw	a3,a2,-1
    800001f6:	1682                	slli	a3,a3,0x20
    800001f8:	9281                	srli	a3,a3,0x20
    800001fa:	0685                	addi	a3,a3,1
    800001fc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fe:	00054783          	lbu	a5,0(a0)
    80000202:	0005c703          	lbu	a4,0(a1)
    80000206:	00e79863          	bne	a5,a4,80000216 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000020a:	0505                	addi	a0,a0,1
    8000020c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020e:	fed518e3          	bne	a0,a3,800001fe <memcmp+0x14>
  }

  return 0;
    80000212:	4501                	li	a0,0
    80000214:	a019                	j	8000021a <memcmp+0x30>
      return *s1 - *s2;
    80000216:	40e7853b          	subw	a0,a5,a4
}
    8000021a:	6422                	ld	s0,8(sp)
    8000021c:	0141                	addi	sp,sp,16
    8000021e:	8082                	ret
  return 0;
    80000220:	4501                	li	a0,0
    80000222:	bfe5                	j	8000021a <memcmp+0x30>

0000000080000224 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000224:	1141                	addi	sp,sp,-16
    80000226:	e422                	sd	s0,8(sp)
    80000228:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000022a:	ca0d                	beqz	a2,8000025c <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022c:	00a5f963          	bgeu	a1,a0,8000023e <memmove+0x1a>
    80000230:	02061693          	slli	a3,a2,0x20
    80000234:	9281                	srli	a3,a3,0x20
    80000236:	00d58733          	add	a4,a1,a3
    8000023a:	02e56463          	bltu	a0,a4,80000262 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023e:	fff6079b          	addiw	a5,a2,-1
    80000242:	1782                	slli	a5,a5,0x20
    80000244:	9381                	srli	a5,a5,0x20
    80000246:	0785                	addi	a5,a5,1
    80000248:	97ae                	add	a5,a5,a1
    8000024a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024c:	0585                	addi	a1,a1,1
    8000024e:	0705                	addi	a4,a4,1
    80000250:	fff5c683          	lbu	a3,-1(a1)
    80000254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000258:	fef59ae3          	bne	a1,a5,8000024c <memmove+0x28>

  return dst;
}
    8000025c:	6422                	ld	s0,8(sp)
    8000025e:	0141                	addi	sp,sp,16
    80000260:	8082                	ret
    d += n;
    80000262:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000264:	fff6079b          	addiw	a5,a2,-1
    80000268:	1782                	slli	a5,a5,0x20
    8000026a:	9381                	srli	a5,a5,0x20
    8000026c:	fff7c793          	not	a5,a5
    80000270:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000272:	177d                	addi	a4,a4,-1
    80000274:	16fd                	addi	a3,a3,-1
    80000276:	00074603          	lbu	a2,0(a4)
    8000027a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027e:	fef71ae3          	bne	a4,a5,80000272 <memmove+0x4e>
    80000282:	bfe9                	j	8000025c <memmove+0x38>

0000000080000284 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e406                	sd	ra,8(sp)
    80000288:	e022                	sd	s0,0(sp)
    8000028a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	f98080e7          	jalr	-104(ra) # 80000224 <memmove>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret

000000008000029c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029c:	1141                	addi	sp,sp,-16
    8000029e:	e422                	sd	s0,8(sp)
    800002a0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a2:	ce11                	beqz	a2,800002be <strncmp+0x22>
    800002a4:	00054783          	lbu	a5,0(a0)
    800002a8:	cf89                	beqz	a5,800002c2 <strncmp+0x26>
    800002aa:	0005c703          	lbu	a4,0(a1)
    800002ae:	00f71a63          	bne	a4,a5,800002c2 <strncmp+0x26>
    n--, p++, q++;
    800002b2:	367d                	addiw	a2,a2,-1
    800002b4:	0505                	addi	a0,a0,1
    800002b6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b8:	f675                	bnez	a2,800002a4 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002ba:	4501                	li	a0,0
    800002bc:	a809                	j	800002ce <strncmp+0x32>
    800002be:	4501                	li	a0,0
    800002c0:	a039                	j	800002ce <strncmp+0x32>
  if(n == 0)
    800002c2:	ca09                	beqz	a2,800002d4 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c4:	00054503          	lbu	a0,0(a0)
    800002c8:	0005c783          	lbu	a5,0(a1)
    800002cc:	9d1d                	subw	a0,a0,a5
}
    800002ce:	6422                	ld	s0,8(sp)
    800002d0:	0141                	addi	sp,sp,16
    800002d2:	8082                	ret
    return 0;
    800002d4:	4501                	li	a0,0
    800002d6:	bfe5                	j	800002ce <strncmp+0x32>

00000000800002d8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d8:	1141                	addi	sp,sp,-16
    800002da:	e422                	sd	s0,8(sp)
    800002dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002de:	872a                	mv	a4,a0
    800002e0:	8832                	mv	a6,a2
    800002e2:	367d                	addiw	a2,a2,-1
    800002e4:	01005963          	blez	a6,800002f6 <strncpy+0x1e>
    800002e8:	0705                	addi	a4,a4,1
    800002ea:	0005c783          	lbu	a5,0(a1)
    800002ee:	fef70fa3          	sb	a5,-1(a4)
    800002f2:	0585                	addi	a1,a1,1
    800002f4:	f7f5                	bnez	a5,800002e0 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f6:	00c05d63          	blez	a2,80000310 <strncpy+0x38>
    800002fa:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fc:	0685                	addi	a3,a3,1
    800002fe:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000302:	fff6c793          	not	a5,a3
    80000306:	9fb9                	addw	a5,a5,a4
    80000308:	010787bb          	addw	a5,a5,a6
    8000030c:	fef048e3          	bgtz	a5,800002fc <strncpy+0x24>
  return os;
}
    80000310:	6422                	ld	s0,8(sp)
    80000312:	0141                	addi	sp,sp,16
    80000314:	8082                	ret

0000000080000316 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000316:	1141                	addi	sp,sp,-16
    80000318:	e422                	sd	s0,8(sp)
    8000031a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031c:	02c05363          	blez	a2,80000342 <safestrcpy+0x2c>
    80000320:	fff6069b          	addiw	a3,a2,-1
    80000324:	1682                	slli	a3,a3,0x20
    80000326:	9281                	srli	a3,a3,0x20
    80000328:	96ae                	add	a3,a3,a1
    8000032a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032c:	00d58963          	beq	a1,a3,8000033e <safestrcpy+0x28>
    80000330:	0585                	addi	a1,a1,1
    80000332:	0785                	addi	a5,a5,1
    80000334:	fff5c703          	lbu	a4,-1(a1)
    80000338:	fee78fa3          	sb	a4,-1(a5)
    8000033c:	fb65                	bnez	a4,8000032c <safestrcpy+0x16>
    ;
  *s = 0;
    8000033e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret

0000000080000348 <strlen>:

int
strlen(const char *s)
{
    80000348:	1141                	addi	sp,sp,-16
    8000034a:	e422                	sd	s0,8(sp)
    8000034c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034e:	00054783          	lbu	a5,0(a0)
    80000352:	cf91                	beqz	a5,8000036e <strlen+0x26>
    80000354:	0505                	addi	a0,a0,1
    80000356:	87aa                	mv	a5,a0
    80000358:	4685                	li	a3,1
    8000035a:	9e89                	subw	a3,a3,a0
    8000035c:	00f6853b          	addw	a0,a3,a5
    80000360:	0785                	addi	a5,a5,1
    80000362:	fff7c703          	lbu	a4,-1(a5)
    80000366:	fb7d                	bnez	a4,8000035c <strlen+0x14>
    ;
  return n;
}
    80000368:	6422                	ld	s0,8(sp)
    8000036a:	0141                	addi	sp,sp,16
    8000036c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036e:	4501                	li	a0,0
    80000370:	bfe5                	j	80000368 <strlen+0x20>

0000000080000372 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e406                	sd	ra,8(sp)
    80000376:	e022                	sd	s0,0(sp)
    80000378:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	afe080e7          	jalr	-1282(ra) # 80000e78 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000382:	00008717          	auipc	a4,0x8
    80000386:	66e70713          	addi	a4,a4,1646 # 800089f0 <started>
  if(cpuid() == 0){
    8000038a:	c139                	beqz	a0,800003d0 <main+0x5e>
    while(started == 0)
    8000038c:	431c                	lw	a5,0(a4)
    8000038e:	2781                	sext.w	a5,a5
    80000390:	dff5                	beqz	a5,8000038c <main+0x1a>
      ;
    __sync_synchronize();
    80000392:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000396:	00001097          	auipc	ra,0x1
    8000039a:	ae2080e7          	jalr	-1310(ra) # 80000e78 <cpuid>
    8000039e:	85aa                	mv	a1,a0
    800003a0:	00008517          	auipc	a0,0x8
    800003a4:	c9850513          	addi	a0,a0,-872 # 80008038 <etext+0x38>
    800003a8:	00006097          	auipc	ra,0x6
    800003ac:	9d4080e7          	jalr	-1580(ra) # 80005d7c <printf>
    kvminithart();    // turn on paging
    800003b0:	00000097          	auipc	ra,0x0
    800003b4:	0d8080e7          	jalr	216(ra) # 80000488 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	7c0080e7          	jalr	1984(ra) # 80001b78 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003c0:	00005097          	auipc	ra,0x5
    800003c4:	e10080e7          	jalr	-496(ra) # 800051d0 <plicinithart>
  }

  scheduler();        
    800003c8:	00001097          	auipc	ra,0x1
    800003cc:	fd6080e7          	jalr	-42(ra) # 8000139e <scheduler>
    consoleinit();
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	874080e7          	jalr	-1932(ra) # 80005c44 <consoleinit>
    printfinit();
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	b8a080e7          	jalr	-1142(ra) # 80005f62 <printfinit>
    printf("\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c6850513          	addi	a0,a0,-920 # 80008048 <etext+0x48>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	994080e7          	jalr	-1644(ra) # 80005d7c <printf>
    printf("xv6 kernel is booting\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c3050513          	addi	a0,a0,-976 # 80008020 <etext+0x20>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	984080e7          	jalr	-1660(ra) # 80005d7c <printf>
    printf("\n");
    80000400:	00008517          	auipc	a0,0x8
    80000404:	c4850513          	addi	a0,a0,-952 # 80008048 <etext+0x48>
    80000408:	00006097          	auipc	ra,0x6
    8000040c:	974080e7          	jalr	-1676(ra) # 80005d7c <printf>
    kinit();         // physical page allocator
    80000410:	00000097          	auipc	ra,0x0
    80000414:	ccc080e7          	jalr	-820(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	326080e7          	jalr	806(ra) # 8000073e <kvminit>
    kvminithart();   // turn on paging
    80000420:	00000097          	auipc	ra,0x0
    80000424:	068080e7          	jalr	104(ra) # 80000488 <kvminithart>
    procinit();      // process table
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	99c080e7          	jalr	-1636(ra) # 80000dc4 <procinit>
    trapinit();      // trap vectors
    80000430:	00001097          	auipc	ra,0x1
    80000434:	720080e7          	jalr	1824(ra) # 80001b50 <trapinit>
    trapinithart();  // install kernel trap vector
    80000438:	00001097          	auipc	ra,0x1
    8000043c:	740080e7          	jalr	1856(ra) # 80001b78 <trapinithart>
    plicinit();      // set up interrupt controller
    80000440:	00005097          	auipc	ra,0x5
    80000444:	d7a080e7          	jalr	-646(ra) # 800051ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000448:	00005097          	auipc	ra,0x5
    8000044c:	d88080e7          	jalr	-632(ra) # 800051d0 <plicinithart>
    binit();         // buffer cache
    80000450:	00002097          	auipc	ra,0x2
    80000454:	f42080e7          	jalr	-190(ra) # 80002392 <binit>
    iinit();         // inode table
    80000458:	00002097          	auipc	ra,0x2
    8000045c:	5e6080e7          	jalr	1510(ra) # 80002a3e <iinit>
    fileinit();      // file table
    80000460:	00003097          	auipc	ra,0x3
    80000464:	584080e7          	jalr	1412(ra) # 800039e4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000468:	00005097          	auipc	ra,0x5
    8000046c:	e70080e7          	jalr	-400(ra) # 800052d8 <virtio_disk_init>
    userinit();      // first user process
    80000470:	00001097          	auipc	ra,0x1
    80000474:	d0c080e7          	jalr	-756(ra) # 8000117c <userinit>
    __sync_synchronize();
    80000478:	0ff0000f          	fence
    started = 1;
    8000047c:	4785                	li	a5,1
    8000047e:	00008717          	auipc	a4,0x8
    80000482:	56f72923          	sw	a5,1394(a4) # 800089f0 <started>
    80000486:	b789                	j	800003c8 <main+0x56>

0000000080000488 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e422                	sd	s0,8(sp)
    8000048c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000048e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000492:	00008797          	auipc	a5,0x8
    80000496:	5667b783          	ld	a5,1382(a5) # 800089f8 <kernel_pagetable>
    8000049a:	83b1                	srli	a5,a5,0xc
    8000049c:	577d                	li	a4,-1
    8000049e:	177e                	slli	a4,a4,0x3f
    800004a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004a2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004a6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004aa:	6422                	ld	s0,8(sp)
    800004ac:	0141                	addi	sp,sp,16
    800004ae:	8082                	ret

00000000800004b0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004b0:	7139                	addi	sp,sp,-64
    800004b2:	fc06                	sd	ra,56(sp)
    800004b4:	f822                	sd	s0,48(sp)
    800004b6:	f426                	sd	s1,40(sp)
    800004b8:	f04a                	sd	s2,32(sp)
    800004ba:	ec4e                	sd	s3,24(sp)
    800004bc:	e852                	sd	s4,16(sp)
    800004be:	e456                	sd	s5,8(sp)
    800004c0:	e05a                	sd	s6,0(sp)
    800004c2:	0080                	addi	s0,sp,64
    800004c4:	84aa                	mv	s1,a0
    800004c6:	89ae                	mv	s3,a1
    800004c8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004ca:	57fd                	li	a5,-1
    800004cc:	83e9                	srli	a5,a5,0x1a
    800004ce:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004d0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004d2:	04b7f263          	bgeu	a5,a1,80000516 <walk+0x66>
    panic("walk");
    800004d6:	00008517          	auipc	a0,0x8
    800004da:	b7a50513          	addi	a0,a0,-1158 # 80008050 <etext+0x50>
    800004de:	00006097          	auipc	ra,0x6
    800004e2:	854080e7          	jalr	-1964(ra) # 80005d32 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e6:	060a8663          	beqz	s5,80000552 <walk+0xa2>
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	c2e080e7          	jalr	-978(ra) # 80000118 <kalloc>
    800004f2:	84aa                	mv	s1,a0
    800004f4:	c529                	beqz	a0,8000053e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f6:	6605                	lui	a2,0x1
    800004f8:	4581                	li	a1,0
    800004fa:	00000097          	auipc	ra,0x0
    800004fe:	cca080e7          	jalr	-822(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000502:	00c4d793          	srli	a5,s1,0xc
    80000506:	07aa                	slli	a5,a5,0xa
    80000508:	0017e793          	ori	a5,a5,1
    8000050c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000510:	3a5d                	addiw	s4,s4,-9
    80000512:	036a0063          	beq	s4,s6,80000532 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000516:	0149d933          	srl	s2,s3,s4
    8000051a:	1ff97913          	andi	s2,s2,511
    8000051e:	090e                	slli	s2,s2,0x3
    80000520:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000522:	00093483          	ld	s1,0(s2)
    80000526:	0014f793          	andi	a5,s1,1
    8000052a:	dfd5                	beqz	a5,800004e6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000052c:	80a9                	srli	s1,s1,0xa
    8000052e:	04b2                	slli	s1,s1,0xc
    80000530:	b7c5                	j	80000510 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000532:	00c9d513          	srli	a0,s3,0xc
    80000536:	1ff57513          	andi	a0,a0,511
    8000053a:	050e                	slli	a0,a0,0x3
    8000053c:	9526                	add	a0,a0,s1
}
    8000053e:	70e2                	ld	ra,56(sp)
    80000540:	7442                	ld	s0,48(sp)
    80000542:	74a2                	ld	s1,40(sp)
    80000544:	7902                	ld	s2,32(sp)
    80000546:	69e2                	ld	s3,24(sp)
    80000548:	6a42                	ld	s4,16(sp)
    8000054a:	6aa2                	ld	s5,8(sp)
    8000054c:	6b02                	ld	s6,0(sp)
    8000054e:	6121                	addi	sp,sp,64
    80000550:	8082                	ret
        return 0;
    80000552:	4501                	li	a0,0
    80000554:	b7ed                	j	8000053e <walk+0x8e>

0000000080000556 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000556:	57fd                	li	a5,-1
    80000558:	83e9                	srli	a5,a5,0x1a
    8000055a:	00b7f463          	bgeu	a5,a1,80000562 <walkaddr+0xc>
    return 0;
    8000055e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000560:	8082                	ret
{
    80000562:	1141                	addi	sp,sp,-16
    80000564:	e406                	sd	ra,8(sp)
    80000566:	e022                	sd	s0,0(sp)
    80000568:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000056a:	4601                	li	a2,0
    8000056c:	00000097          	auipc	ra,0x0
    80000570:	f44080e7          	jalr	-188(ra) # 800004b0 <walk>
  if(pte == 0)
    80000574:	c105                	beqz	a0,80000594 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000576:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000578:	0117f693          	andi	a3,a5,17
    8000057c:	4745                	li	a4,17
    return 0;
    8000057e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000580:	00e68663          	beq	a3,a4,8000058c <walkaddr+0x36>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
  pa = PTE2PA(*pte);
    8000058c:	00a7d513          	srli	a0,a5,0xa
    80000590:	0532                	slli	a0,a0,0xc
  return pa;
    80000592:	bfcd                	j	80000584 <walkaddr+0x2e>
    return 0;
    80000594:	4501                	li	a0,0
    80000596:	b7fd                	j	80000584 <walkaddr+0x2e>

0000000080000598 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000598:	715d                	addi	sp,sp,-80
    8000059a:	e486                	sd	ra,72(sp)
    8000059c:	e0a2                	sd	s0,64(sp)
    8000059e:	fc26                	sd	s1,56(sp)
    800005a0:	f84a                	sd	s2,48(sp)
    800005a2:	f44e                	sd	s3,40(sp)
    800005a4:	f052                	sd	s4,32(sp)
    800005a6:	ec56                	sd	s5,24(sp)
    800005a8:	e85a                	sd	s6,16(sp)
    800005aa:	e45e                	sd	s7,8(sp)
    800005ac:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005ae:	c205                	beqz	a2,800005ce <mappages+0x36>
    800005b0:	8aaa                	mv	s5,a0
    800005b2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005b4:	77fd                	lui	a5,0xfffff
    800005b6:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005ba:	15fd                	addi	a1,a1,-1
    800005bc:	00c589b3          	add	s3,a1,a2
    800005c0:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005c4:	8952                	mv	s2,s4
    800005c6:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005ca:	6b85                	lui	s7,0x1
    800005cc:	a015                	j	800005f0 <mappages+0x58>
    panic("mappages: size");
    800005ce:	00008517          	auipc	a0,0x8
    800005d2:	a8a50513          	addi	a0,a0,-1398 # 80008058 <etext+0x58>
    800005d6:	00005097          	auipc	ra,0x5
    800005da:	75c080e7          	jalr	1884(ra) # 80005d32 <panic>
      panic("mappages: remap");
    800005de:	00008517          	auipc	a0,0x8
    800005e2:	a8a50513          	addi	a0,a0,-1398 # 80008068 <etext+0x68>
    800005e6:	00005097          	auipc	ra,0x5
    800005ea:	74c080e7          	jalr	1868(ra) # 80005d32 <panic>
    a += PGSIZE;
    800005ee:	995e                	add	s2,s2,s7
  for(;;){
    800005f0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f4:	4605                	li	a2,1
    800005f6:	85ca                	mv	a1,s2
    800005f8:	8556                	mv	a0,s5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	eb6080e7          	jalr	-330(ra) # 800004b0 <walk>
    80000602:	cd19                	beqz	a0,80000620 <mappages+0x88>
    if(*pte & PTE_V)
    80000604:	611c                	ld	a5,0(a0)
    80000606:	8b85                	andi	a5,a5,1
    80000608:	fbf9                	bnez	a5,800005de <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000060a:	80b1                	srli	s1,s1,0xc
    8000060c:	04aa                	slli	s1,s1,0xa
    8000060e:	0164e4b3          	or	s1,s1,s6
    80000612:	0014e493          	ori	s1,s1,1
    80000616:	e104                	sd	s1,0(a0)
    if(a == last)
    80000618:	fd391be3          	bne	s2,s3,800005ee <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000061c:	4501                	li	a0,0
    8000061e:	a011                	j	80000622 <mappages+0x8a>
      return -1;
    80000620:	557d                	li	a0,-1
}
    80000622:	60a6                	ld	ra,72(sp)
    80000624:	6406                	ld	s0,64(sp)
    80000626:	74e2                	ld	s1,56(sp)
    80000628:	7942                	ld	s2,48(sp)
    8000062a:	79a2                	ld	s3,40(sp)
    8000062c:	7a02                	ld	s4,32(sp)
    8000062e:	6ae2                	ld	s5,24(sp)
    80000630:	6b42                	ld	s6,16(sp)
    80000632:	6ba2                	ld	s7,8(sp)
    80000634:	6161                	addi	sp,sp,80
    80000636:	8082                	ret

0000000080000638 <kvmmap>:
{
    80000638:	1141                	addi	sp,sp,-16
    8000063a:	e406                	sd	ra,8(sp)
    8000063c:	e022                	sd	s0,0(sp)
    8000063e:	0800                	addi	s0,sp,16
    80000640:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000642:	86b2                	mv	a3,a2
    80000644:	863e                	mv	a2,a5
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f52080e7          	jalr	-174(ra) # 80000598 <mappages>
    8000064e:	e509                	bnez	a0,80000658 <kvmmap+0x20>
}
    80000650:	60a2                	ld	ra,8(sp)
    80000652:	6402                	ld	s0,0(sp)
    80000654:	0141                	addi	sp,sp,16
    80000656:	8082                	ret
    panic("kvmmap");
    80000658:	00008517          	auipc	a0,0x8
    8000065c:	a2050513          	addi	a0,a0,-1504 # 80008078 <etext+0x78>
    80000660:	00005097          	auipc	ra,0x5
    80000664:	6d2080e7          	jalr	1746(ra) # 80005d32 <panic>

0000000080000668 <kvmmake>:
{
    80000668:	1101                	addi	sp,sp,-32
    8000066a:	ec06                	sd	ra,24(sp)
    8000066c:	e822                	sd	s0,16(sp)
    8000066e:	e426                	sd	s1,8(sp)
    80000670:	e04a                	sd	s2,0(sp)
    80000672:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000674:	00000097          	auipc	ra,0x0
    80000678:	aa4080e7          	jalr	-1372(ra) # 80000118 <kalloc>
    8000067c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000067e:	6605                	lui	a2,0x1
    80000680:	4581                	li	a1,0
    80000682:	00000097          	auipc	ra,0x0
    80000686:	b42080e7          	jalr	-1214(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000068a:	4719                	li	a4,6
    8000068c:	6685                	lui	a3,0x1
    8000068e:	10000637          	lui	a2,0x10000
    80000692:	100005b7          	lui	a1,0x10000
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	fa0080e7          	jalr	-96(ra) # 80000638 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	6685                	lui	a3,0x1
    800006a4:	10001637          	lui	a2,0x10001
    800006a8:	100015b7          	lui	a1,0x10001
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f8a080e7          	jalr	-118(ra) # 80000638 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b6:	4719                	li	a4,6
    800006b8:	004006b7          	lui	a3,0x400
    800006bc:	0c000637          	lui	a2,0xc000
    800006c0:	0c0005b7          	lui	a1,0xc000
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f72080e7          	jalr	-142(ra) # 80000638 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ce:	00008917          	auipc	s2,0x8
    800006d2:	93290913          	addi	s2,s2,-1742 # 80008000 <etext>
    800006d6:	4729                	li	a4,10
    800006d8:	80008697          	auipc	a3,0x80008
    800006dc:	92868693          	addi	a3,a3,-1752 # 8000 <_entry-0x7fff8000>
    800006e0:	4605                	li	a2,1
    800006e2:	067e                	slli	a2,a2,0x1f
    800006e4:	85b2                	mv	a1,a2
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f50080e7          	jalr	-176(ra) # 80000638 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006f0:	4719                	li	a4,6
    800006f2:	46c5                	li	a3,17
    800006f4:	06ee                	slli	a3,a3,0x1b
    800006f6:	412686b3          	sub	a3,a3,s2
    800006fa:	864a                	mv	a2,s2
    800006fc:	85ca                	mv	a1,s2
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	f38080e7          	jalr	-200(ra) # 80000638 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000708:	4729                	li	a4,10
    8000070a:	6685                	lui	a3,0x1
    8000070c:	00007617          	auipc	a2,0x7
    80000710:	8f460613          	addi	a2,a2,-1804 # 80007000 <_trampoline>
    80000714:	040005b7          	lui	a1,0x4000
    80000718:	15fd                	addi	a1,a1,-1
    8000071a:	05b2                	slli	a1,a1,0xc
    8000071c:	8526                	mv	a0,s1
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f1a080e7          	jalr	-230(ra) # 80000638 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	606080e7          	jalr	1542(ra) # 80000d2e <proc_mapstacks>
}
    80000730:	8526                	mv	a0,s1
    80000732:	60e2                	ld	ra,24(sp)
    80000734:	6442                	ld	s0,16(sp)
    80000736:	64a2                	ld	s1,8(sp)
    80000738:	6902                	ld	s2,0(sp)
    8000073a:	6105                	addi	sp,sp,32
    8000073c:	8082                	ret

000000008000073e <kvminit>:
{
    8000073e:	1141                	addi	sp,sp,-16
    80000740:	e406                	sd	ra,8(sp)
    80000742:	e022                	sd	s0,0(sp)
    80000744:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	f22080e7          	jalr	-222(ra) # 80000668 <kvmmake>
    8000074e:	00008797          	auipc	a5,0x8
    80000752:	2aa7b523          	sd	a0,682(a5) # 800089f8 <kernel_pagetable>
}
    80000756:	60a2                	ld	ra,8(sp)
    80000758:	6402                	ld	s0,0(sp)
    8000075a:	0141                	addi	sp,sp,16
    8000075c:	8082                	ret

000000008000075e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000075e:	715d                	addi	sp,sp,-80
    80000760:	e486                	sd	ra,72(sp)
    80000762:	e0a2                	sd	s0,64(sp)
    80000764:	fc26                	sd	s1,56(sp)
    80000766:	f84a                	sd	s2,48(sp)
    80000768:	f44e                	sd	s3,40(sp)
    8000076a:	f052                	sd	s4,32(sp)
    8000076c:	ec56                	sd	s5,24(sp)
    8000076e:	e85a                	sd	s6,16(sp)
    80000770:	e45e                	sd	s7,8(sp)
    80000772:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000774:	03459793          	slli	a5,a1,0x34
    80000778:	e795                	bnez	a5,800007a4 <uvmunmap+0x46>
    8000077a:	8a2a                	mv	s4,a0
    8000077c:	892e                	mv	s2,a1
    8000077e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000780:	0632                	slli	a2,a2,0xc
    80000782:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000786:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000788:	6b05                	lui	s6,0x1
    8000078a:	0735e863          	bltu	a1,s3,800007fa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000078e:	60a6                	ld	ra,72(sp)
    80000790:	6406                	ld	s0,64(sp)
    80000792:	74e2                	ld	s1,56(sp)
    80000794:	7942                	ld	s2,48(sp)
    80000796:	79a2                	ld	s3,40(sp)
    80000798:	7a02                	ld	s4,32(sp)
    8000079a:	6ae2                	ld	s5,24(sp)
    8000079c:	6b42                	ld	s6,16(sp)
    8000079e:	6ba2                	ld	s7,8(sp)
    800007a0:	6161                	addi	sp,sp,80
    800007a2:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a4:	00008517          	auipc	a0,0x8
    800007a8:	8dc50513          	addi	a0,a0,-1828 # 80008080 <etext+0x80>
    800007ac:	00005097          	auipc	ra,0x5
    800007b0:	586080e7          	jalr	1414(ra) # 80005d32 <panic>
      panic("uvmunmap: walk");
    800007b4:	00008517          	auipc	a0,0x8
    800007b8:	8e450513          	addi	a0,a0,-1820 # 80008098 <etext+0x98>
    800007bc:	00005097          	auipc	ra,0x5
    800007c0:	576080e7          	jalr	1398(ra) # 80005d32 <panic>
      panic("uvmunmap: not mapped");
    800007c4:	00008517          	auipc	a0,0x8
    800007c8:	8e450513          	addi	a0,a0,-1820 # 800080a8 <etext+0xa8>
    800007cc:	00005097          	auipc	ra,0x5
    800007d0:	566080e7          	jalr	1382(ra) # 80005d32 <panic>
      panic("uvmunmap: not a leaf");
    800007d4:	00008517          	auipc	a0,0x8
    800007d8:	8ec50513          	addi	a0,a0,-1812 # 800080c0 <etext+0xc0>
    800007dc:	00005097          	auipc	ra,0x5
    800007e0:	556080e7          	jalr	1366(ra) # 80005d32 <panic>
      uint64 pa = PTE2PA(*pte);
    800007e4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e6:	0532                	slli	a0,a0,0xc
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	834080e7          	jalr	-1996(ra) # 8000001c <kfree>
    *pte = 0;
    800007f0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f4:	995a                	add	s2,s2,s6
    800007f6:	f9397ce3          	bgeu	s2,s3,8000078e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fa:	4601                	li	a2,0
    800007fc:	85ca                	mv	a1,s2
    800007fe:	8552                	mv	a0,s4
    80000800:	00000097          	auipc	ra,0x0
    80000804:	cb0080e7          	jalr	-848(ra) # 800004b0 <walk>
    80000808:	84aa                	mv	s1,a0
    8000080a:	d54d                	beqz	a0,800007b4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000080c:	6108                	ld	a0,0(a0)
    8000080e:	00157793          	andi	a5,a0,1
    80000812:	dbcd                	beqz	a5,800007c4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000814:	3ff57793          	andi	a5,a0,1023
    80000818:	fb778ee3          	beq	a5,s7,800007d4 <uvmunmap+0x76>
    if(do_free){
    8000081c:	fc0a8ae3          	beqz	s5,800007f0 <uvmunmap+0x92>
    80000820:	b7d1                	j	800007e4 <uvmunmap+0x86>

0000000080000822 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000822:	1101                	addi	sp,sp,-32
    80000824:	ec06                	sd	ra,24(sp)
    80000826:	e822                	sd	s0,16(sp)
    80000828:	e426                	sd	s1,8(sp)
    8000082a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	8ec080e7          	jalr	-1812(ra) # 80000118 <kalloc>
    80000834:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000836:	c519                	beqz	a0,80000844 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	988080e7          	jalr	-1656(ra) # 800001c4 <memset>
  return pagetable;
}
    80000844:	8526                	mv	a0,s1
    80000846:	60e2                	ld	ra,24(sp)
    80000848:	6442                	ld	s0,16(sp)
    8000084a:	64a2                	ld	s1,8(sp)
    8000084c:	6105                	addi	sp,sp,32
    8000084e:	8082                	ret

0000000080000850 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000850:	7179                	addi	sp,sp,-48
    80000852:	f406                	sd	ra,40(sp)
    80000854:	f022                	sd	s0,32(sp)
    80000856:	ec26                	sd	s1,24(sp)
    80000858:	e84a                	sd	s2,16(sp)
    8000085a:	e44e                	sd	s3,8(sp)
    8000085c:	e052                	sd	s4,0(sp)
    8000085e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000860:	6785                	lui	a5,0x1
    80000862:	04f67863          	bgeu	a2,a5,800008b2 <uvmfirst+0x62>
    80000866:	8a2a                	mv	s4,a0
    80000868:	89ae                	mv	s3,a1
    8000086a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	8ac080e7          	jalr	-1876(ra) # 80000118 <kalloc>
    80000874:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000876:	6605                	lui	a2,0x1
    80000878:	4581                	li	a1,0
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	94a080e7          	jalr	-1718(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000882:	4779                	li	a4,30
    80000884:	86ca                	mv	a3,s2
    80000886:	6605                	lui	a2,0x1
    80000888:	4581                	li	a1,0
    8000088a:	8552                	mv	a0,s4
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	d0c080e7          	jalr	-756(ra) # 80000598 <mappages>
  memmove(mem, src, sz);
    80000894:	8626                	mv	a2,s1
    80000896:	85ce                	mv	a1,s3
    80000898:	854a                	mv	a0,s2
    8000089a:	00000097          	auipc	ra,0x0
    8000089e:	98a080e7          	jalr	-1654(ra) # 80000224 <memmove>
}
    800008a2:	70a2                	ld	ra,40(sp)
    800008a4:	7402                	ld	s0,32(sp)
    800008a6:	64e2                	ld	s1,24(sp)
    800008a8:	6942                	ld	s2,16(sp)
    800008aa:	69a2                	ld	s3,8(sp)
    800008ac:	6a02                	ld	s4,0(sp)
    800008ae:	6145                	addi	sp,sp,48
    800008b0:	8082                	ret
    panic("uvmfirst: more than a page");
    800008b2:	00008517          	auipc	a0,0x8
    800008b6:	82650513          	addi	a0,a0,-2010 # 800080d8 <etext+0xd8>
    800008ba:	00005097          	auipc	ra,0x5
    800008be:	478080e7          	jalr	1144(ra) # 80005d32 <panic>

00000000800008c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c2:	1101                	addi	sp,sp,-32
    800008c4:	ec06                	sd	ra,24(sp)
    800008c6:	e822                	sd	s0,16(sp)
    800008c8:	e426                	sd	s1,8(sp)
    800008ca:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ce:	00b67d63          	bgeu	a2,a1,800008e8 <uvmdealloc+0x26>
    800008d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1
    800008d8:	00f60733          	add	a4,a2,a5
    800008dc:	767d                	lui	a2,0xfffff
    800008de:	8f71                	and	a4,a4,a2
    800008e0:	97ae                	add	a5,a5,a1
    800008e2:	8ff1                	and	a5,a5,a2
    800008e4:	00f76863          	bltu	a4,a5,800008f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e8:	8526                	mv	a0,s1
    800008ea:	60e2                	ld	ra,24(sp)
    800008ec:	6442                	ld	s0,16(sp)
    800008ee:	64a2                	ld	s1,8(sp)
    800008f0:	6105                	addi	sp,sp,32
    800008f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f4:	8f99                	sub	a5,a5,a4
    800008f6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f8:	4685                	li	a3,1
    800008fa:	0007861b          	sext.w	a2,a5
    800008fe:	85ba                	mv	a1,a4
    80000900:	00000097          	auipc	ra,0x0
    80000904:	e5e080e7          	jalr	-418(ra) # 8000075e <uvmunmap>
    80000908:	b7c5                	j	800008e8 <uvmdealloc+0x26>

000000008000090a <uvmalloc>:
  if(newsz < oldsz)
    8000090a:	0ab66563          	bltu	a2,a1,800009b4 <uvmalloc+0xaa>
{
    8000090e:	7139                	addi	sp,sp,-64
    80000910:	fc06                	sd	ra,56(sp)
    80000912:	f822                	sd	s0,48(sp)
    80000914:	f426                	sd	s1,40(sp)
    80000916:	f04a                	sd	s2,32(sp)
    80000918:	ec4e                	sd	s3,24(sp)
    8000091a:	e852                	sd	s4,16(sp)
    8000091c:	e456                	sd	s5,8(sp)
    8000091e:	e05a                	sd	s6,0(sp)
    80000920:	0080                	addi	s0,sp,64
    80000922:	8aaa                	mv	s5,a0
    80000924:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000926:	6985                	lui	s3,0x1
    80000928:	19fd                	addi	s3,s3,-1
    8000092a:	95ce                	add	a1,a1,s3
    8000092c:	79fd                	lui	s3,0xfffff
    8000092e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000932:	08c9f363          	bgeu	s3,a2,800009b8 <uvmalloc+0xae>
    80000936:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000938:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	7dc080e7          	jalr	2012(ra) # 80000118 <kalloc>
    80000944:	84aa                	mv	s1,a0
    if(mem == 0){
    80000946:	c51d                	beqz	a0,80000974 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000948:	6605                	lui	a2,0x1
    8000094a:	4581                	li	a1,0
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	878080e7          	jalr	-1928(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000954:	875a                	mv	a4,s6
    80000956:	86a6                	mv	a3,s1
    80000958:	6605                	lui	a2,0x1
    8000095a:	85ca                	mv	a1,s2
    8000095c:	8556                	mv	a0,s5
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	c3a080e7          	jalr	-966(ra) # 80000598 <mappages>
    80000966:	e90d                	bnez	a0,80000998 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000968:	6785                	lui	a5,0x1
    8000096a:	993e                	add	s2,s2,a5
    8000096c:	fd4968e3          	bltu	s2,s4,8000093c <uvmalloc+0x32>
  return newsz;
    80000970:	8552                	mv	a0,s4
    80000972:	a809                	j	80000984 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000974:	864e                	mv	a2,s3
    80000976:	85ca                	mv	a1,s2
    80000978:	8556                	mv	a0,s5
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	f48080e7          	jalr	-184(ra) # 800008c2 <uvmdealloc>
      return 0;
    80000982:	4501                	li	a0,0
}
    80000984:	70e2                	ld	ra,56(sp)
    80000986:	7442                	ld	s0,48(sp)
    80000988:	74a2                	ld	s1,40(sp)
    8000098a:	7902                	ld	s2,32(sp)
    8000098c:	69e2                	ld	s3,24(sp)
    8000098e:	6a42                	ld	s4,16(sp)
    80000990:	6aa2                	ld	s5,8(sp)
    80000992:	6b02                	ld	s6,0(sp)
    80000994:	6121                	addi	sp,sp,64
    80000996:	8082                	ret
      kfree(mem);
    80000998:	8526                	mv	a0,s1
    8000099a:	fffff097          	auipc	ra,0xfffff
    8000099e:	682080e7          	jalr	1666(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a2:	864e                	mv	a2,s3
    800009a4:	85ca                	mv	a1,s2
    800009a6:	8556                	mv	a0,s5
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	f1a080e7          	jalr	-230(ra) # 800008c2 <uvmdealloc>
      return 0;
    800009b0:	4501                	li	a0,0
    800009b2:	bfc9                	j	80000984 <uvmalloc+0x7a>
    return oldsz;
    800009b4:	852e                	mv	a0,a1
}
    800009b6:	8082                	ret
  return newsz;
    800009b8:	8532                	mv	a0,a2
    800009ba:	b7e9                	j	80000984 <uvmalloc+0x7a>

00000000800009bc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009bc:	7179                	addi	sp,sp,-48
    800009be:	f406                	sd	ra,40(sp)
    800009c0:	f022                	sd	s0,32(sp)
    800009c2:	ec26                	sd	s1,24(sp)
    800009c4:	e84a                	sd	s2,16(sp)
    800009c6:	e44e                	sd	s3,8(sp)
    800009c8:	e052                	sd	s4,0(sp)
    800009ca:	1800                	addi	s0,sp,48
    800009cc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ce:	84aa                	mv	s1,a0
    800009d0:	6905                	lui	s2,0x1
    800009d2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d4:	4985                	li	s3,1
    800009d6:	a821                	j	800009ee <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009da:	0532                	slli	a0,a0,0xc
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	fe0080e7          	jalr	-32(ra) # 800009bc <freewalk>
      pagetable[i] = 0;
    800009e4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e8:	04a1                	addi	s1,s1,8
    800009ea:	03248163          	beq	s1,s2,80000a0c <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ee:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009f0:	00f57793          	andi	a5,a0,15
    800009f4:	ff3782e3          	beq	a5,s3,800009d8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f8:	8905                	andi	a0,a0,1
    800009fa:	d57d                	beqz	a0,800009e8 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009fc:	00007517          	auipc	a0,0x7
    80000a00:	6fc50513          	addi	a0,a0,1788 # 800080f8 <etext+0xf8>
    80000a04:	00005097          	auipc	ra,0x5
    80000a08:	32e080e7          	jalr	814(ra) # 80005d32 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0c:	8552                	mv	a0,s4
    80000a0e:	fffff097          	auipc	ra,0xfffff
    80000a12:	60e080e7          	jalr	1550(ra) # 8000001c <kfree>
}
    80000a16:	70a2                	ld	ra,40(sp)
    80000a18:	7402                	ld	s0,32(sp)
    80000a1a:	64e2                	ld	s1,24(sp)
    80000a1c:	6942                	ld	s2,16(sp)
    80000a1e:	69a2                	ld	s3,8(sp)
    80000a20:	6a02                	ld	s4,0(sp)
    80000a22:	6145                	addi	sp,sp,48
    80000a24:	8082                	ret

0000000080000a26 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	1000                	addi	s0,sp,32
    80000a30:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a32:	e999                	bnez	a1,80000a48 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a34:	8526                	mv	a0,s1
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	f86080e7          	jalr	-122(ra) # 800009bc <freewalk>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a48:	6605                	lui	a2,0x1
    80000a4a:	167d                	addi	a2,a2,-1
    80000a4c:	962e                	add	a2,a2,a1
    80000a4e:	4685                	li	a3,1
    80000a50:	8231                	srli	a2,a2,0xc
    80000a52:	4581                	li	a1,0
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	d0a080e7          	jalr	-758(ra) # 8000075e <uvmunmap>
    80000a5c:	bfe1                	j	80000a34 <uvmfree+0xe>

0000000080000a5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5e:	c679                	beqz	a2,80000b2c <uvmcopy+0xce>
{
    80000a60:	715d                	addi	sp,sp,-80
    80000a62:	e486                	sd	ra,72(sp)
    80000a64:	e0a2                	sd	s0,64(sp)
    80000a66:	fc26                	sd	s1,56(sp)
    80000a68:	f84a                	sd	s2,48(sp)
    80000a6a:	f44e                	sd	s3,40(sp)
    80000a6c:	f052                	sd	s4,32(sp)
    80000a6e:	ec56                	sd	s5,24(sp)
    80000a70:	e85a                	sd	s6,16(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	addi	s0,sp,80
    80000a76:	8b2a                	mv	s6,a0
    80000a78:	8aae                	mv	s5,a1
    80000a7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7e:	4601                	li	a2,0
    80000a80:	85ce                	mv	a1,s3
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	a2c080e7          	jalr	-1492(ra) # 800004b0 <walk>
    80000a8c:	c531                	beqz	a0,80000ad8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8e:	6118                	ld	a4,0(a0)
    80000a90:	00177793          	andi	a5,a4,1
    80000a94:	cbb1                	beqz	a5,80000ae8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a96:	00a75593          	srli	a1,a4,0xa
    80000a9a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	676080e7          	jalr	1654(ra) # 80000118 <kalloc>
    80000aaa:	892a                	mv	s2,a0
    80000aac:	c939                	beqz	a0,80000b02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85de                	mv	a1,s7
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	772080e7          	jalr	1906(ra) # 80000224 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aba:	8726                	mv	a4,s1
    80000abc:	86ca                	mv	a3,s2
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85ce                	mv	a1,s3
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	ad4080e7          	jalr	-1324(ra) # 80000598 <mappages>
    80000acc:	e515                	bnez	a0,80000af8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ace:	6785                	lui	a5,0x1
    80000ad0:	99be                	add	s3,s3,a5
    80000ad2:	fb49e6e3          	bltu	s3,s4,80000a7e <uvmcopy+0x20>
    80000ad6:	a081                	j	80000b16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	63050513          	addi	a0,a0,1584 # 80008108 <etext+0x108>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	252080e7          	jalr	594(ra) # 80005d32 <panic>
      panic("uvmcopy: page not present");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	64050513          	addi	a0,a0,1600 # 80008128 <etext+0x128>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	242080e7          	jalr	578(ra) # 80005d32 <panic>
      kfree(mem);
    80000af8:	854a                	mv	a0,s2
    80000afa:	fffff097          	auipc	ra,0xfffff
    80000afe:	522080e7          	jalr	1314(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b02:	4685                	li	a3,1
    80000b04:	00c9d613          	srli	a2,s3,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	8556                	mv	a0,s5
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	c52080e7          	jalr	-942(ra) # 8000075e <uvmunmap>
  return -1;
    80000b14:	557d                	li	a0,-1
}
    80000b16:	60a6                	ld	ra,72(sp)
    80000b18:	6406                	ld	s0,64(sp)
    80000b1a:	74e2                	ld	s1,56(sp)
    80000b1c:	7942                	ld	s2,48(sp)
    80000b1e:	79a2                	ld	s3,40(sp)
    80000b20:	7a02                	ld	s4,32(sp)
    80000b22:	6ae2                	ld	s5,24(sp)
    80000b24:	6b42                	ld	s6,16(sp)
    80000b26:	6ba2                	ld	s7,8(sp)
    80000b28:	6161                	addi	sp,sp,80
    80000b2a:	8082                	ret
  return 0;
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret

0000000080000b30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b30:	1141                	addi	sp,sp,-16
    80000b32:	e406                	sd	ra,8(sp)
    80000b34:	e022                	sd	s0,0(sp)
    80000b36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b38:	4601                	li	a2,0
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	976080e7          	jalr	-1674(ra) # 800004b0 <walk>
  if(pte == 0)
    80000b42:	c901                	beqz	a0,80000b52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b44:	611c                	ld	a5,0(a0)
    80000b46:	9bbd                	andi	a5,a5,-17
    80000b48:	e11c                	sd	a5,0(a0)
}
    80000b4a:	60a2                	ld	ra,8(sp)
    80000b4c:	6402                	ld	s0,0(sp)
    80000b4e:	0141                	addi	sp,sp,16
    80000b50:	8082                	ret
    panic("uvmclear");
    80000b52:	00007517          	auipc	a0,0x7
    80000b56:	5f650513          	addi	a0,a0,1526 # 80008148 <etext+0x148>
    80000b5a:	00005097          	auipc	ra,0x5
    80000b5e:	1d8080e7          	jalr	472(ra) # 80005d32 <panic>

0000000080000b62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6bd                	beqz	a3,80000bd0 <copyout+0x6e>
{
    80000b64:	715d                	addi	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8c2e                	mv	s8,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a015                	j	80000bac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	9562                	add	a0,a0,s8
    80000b8c:	0004861b          	sext.w	a2,s1
    80000b90:	85d2                	mv	a1,s4
    80000b92:	41250533          	sub	a0,a0,s2
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	68e080e7          	jalr	1678(ra) # 80000224 <memmove>

    len -= n;
    80000b9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba8:	02098263          	beqz	s3,80000bcc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85ca                	mv	a1,s2
    80000bb2:	855a                	mv	a0,s6
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	9a2080e7          	jalr	-1630(ra) # 80000556 <walkaddr>
    if(pa0 == 0)
    80000bbc:	cd01                	beqz	a0,80000bd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbe:	418904b3          	sub	s1,s2,s8
    80000bc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc4:	fc99f3e3          	bgeu	s3,s1,80000b8a <copyout+0x28>
    80000bc8:	84ce                	mv	s1,s3
    80000bca:	b7c1                	j	80000b8a <copyout+0x28>
  }
  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a021                	j	80000bd6 <copyout+0x74>
    80000bd0:	4501                	li	a0,0
}
    80000bd2:	8082                	ret
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60a6                	ld	ra,72(sp)
    80000bd8:	6406                	ld	s0,64(sp)
    80000bda:	74e2                	ld	s1,56(sp)
    80000bdc:	7942                	ld	s2,48(sp)
    80000bde:	79a2                	ld	s3,40(sp)
    80000be0:	7a02                	ld	s4,32(sp)
    80000be2:	6ae2                	ld	s5,24(sp)
    80000be4:	6b42                	ld	s6,16(sp)
    80000be6:	6ba2                	ld	s7,8(sp)
    80000be8:	6c02                	ld	s8,0(sp)
    80000bea:	6161                	addi	sp,sp,80
    80000bec:	8082                	ret

0000000080000bee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	c6bd                	beqz	a3,80000c5c <copyin+0x6e>
{
    80000bf0:	715d                	addi	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	addi	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8a2e                	mv	s4,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a015                	j	80000c38 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c16:	9562                	add	a0,a0,s8
    80000c18:	0004861b          	sext.w	a2,s1
    80000c1c:	412505b3          	sub	a1,a0,s2
    80000c20:	8552                	mv	a0,s4
    80000c22:	fffff097          	auipc	ra,0xfffff
    80000c26:	602080e7          	jalr	1538(ra) # 80000224 <memmove>

    len -= n;
    80000c2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c34:	02098263          	beqz	s3,80000c58 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3c:	85ca                	mv	a1,s2
    80000c3e:	855a                	mv	a0,s6
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	916080e7          	jalr	-1770(ra) # 80000556 <walkaddr>
    if(pa0 == 0)
    80000c48:	cd01                	beqz	a0,80000c60 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c4a:	418904b3          	sub	s1,s2,s8
    80000c4e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c50:	fc99f3e3          	bgeu	s3,s1,80000c16 <copyin+0x28>
    80000c54:	84ce                	mv	s1,s3
    80000c56:	b7c1                	j	80000c16 <copyin+0x28>
  }
  return 0;
    80000c58:	4501                	li	a0,0
    80000c5a:	a021                	j	80000c62 <copyin+0x74>
    80000c5c:	4501                	li	a0,0
}
    80000c5e:	8082                	ret
      return -1;
    80000c60:	557d                	li	a0,-1
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6c02                	ld	s8,0(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret

0000000080000c7a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7a:	c6c5                	beqz	a3,80000d22 <copyinstr+0xa8>
{
    80000c7c:	715d                	addi	sp,sp,-80
    80000c7e:	e486                	sd	ra,72(sp)
    80000c80:	e0a2                	sd	s0,64(sp)
    80000c82:	fc26                	sd	s1,56(sp)
    80000c84:	f84a                	sd	s2,48(sp)
    80000c86:	f44e                	sd	s3,40(sp)
    80000c88:	f052                	sd	s4,32(sp)
    80000c8a:	ec56                	sd	s5,24(sp)
    80000c8c:	e85a                	sd	s6,16(sp)
    80000c8e:	e45e                	sd	s7,8(sp)
    80000c90:	0880                	addi	s0,sp,80
    80000c92:	8a2a                	mv	s4,a0
    80000c94:	8b2e                	mv	s6,a1
    80000c96:	8bb2                	mv	s7,a2
    80000c98:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9c:	6985                	lui	s3,0x1
    80000c9e:	a035                	j	80000cca <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca6:	0017b793          	seqz	a5,a5
    80000caa:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6161                	addi	sp,sp,80
    80000cc2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cc8:	c8a9                	beqz	s1,80000d1a <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cca:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cce:	85ca                	mv	a1,s2
    80000cd0:	8552                	mv	a0,s4
    80000cd2:	00000097          	auipc	ra,0x0
    80000cd6:	884080e7          	jalr	-1916(ra) # 80000556 <walkaddr>
    if(pa0 == 0)
    80000cda:	c131                	beqz	a0,80000d1e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cdc:	41790833          	sub	a6,s2,s7
    80000ce0:	984e                	add	a6,a6,s3
    if(n > max)
    80000ce2:	0104f363          	bgeu	s1,a6,80000ce8 <copyinstr+0x6e>
    80000ce6:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ce8:	955e                	add	a0,a0,s7
    80000cea:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cee:	fc080be3          	beqz	a6,80000cc4 <copyinstr+0x4a>
    80000cf2:	985a                	add	a6,a6,s6
    80000cf4:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cf6:	41650633          	sub	a2,a0,s6
    80000cfa:	14fd                	addi	s1,s1,-1
    80000cfc:	9b26                	add	s6,s6,s1
    80000cfe:	00f60733          	add	a4,a2,a5
    80000d02:	00074703          	lbu	a4,0(a4)
    80000d06:	df49                	beqz	a4,80000ca0 <copyinstr+0x26>
        *dst = *p;
    80000d08:	00e78023          	sb	a4,0(a5)
      --max;
    80000d0c:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d10:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d12:	ff0796e3          	bne	a5,a6,80000cfe <copyinstr+0x84>
      dst++;
    80000d16:	8b42                	mv	s6,a6
    80000d18:	b775                	j	80000cc4 <copyinstr+0x4a>
    80000d1a:	4781                	li	a5,0
    80000d1c:	b769                	j	80000ca6 <copyinstr+0x2c>
      return -1;
    80000d1e:	557d                	li	a0,-1
    80000d20:	b779                	j	80000cae <copyinstr+0x34>
  int got_null = 0;
    80000d22:	4781                	li	a5,0
  if(got_null){
    80000d24:	0017b793          	seqz	a5,a5
    80000d28:	40f00533          	neg	a0,a5
}
    80000d2c:	8082                	ret

0000000080000d2e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d2e:	7139                	addi	sp,sp,-64
    80000d30:	fc06                	sd	ra,56(sp)
    80000d32:	f822                	sd	s0,48(sp)
    80000d34:	f426                	sd	s1,40(sp)
    80000d36:	f04a                	sd	s2,32(sp)
    80000d38:	ec4e                	sd	s3,24(sp)
    80000d3a:	e852                	sd	s4,16(sp)
    80000d3c:	e456                	sd	s5,8(sp)
    80000d3e:	e05a                	sd	s6,0(sp)
    80000d40:	0080                	addi	s0,sp,64
    80000d42:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	00008497          	auipc	s1,0x8
    80000d48:	13c48493          	addi	s1,s1,316 # 80008e80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d4c:	8b26                	mv	s6,s1
    80000d4e:	00007a97          	auipc	s5,0x7
    80000d52:	2b2a8a93          	addi	s5,s5,690 # 80008000 <etext>
    80000d56:	04000937          	lui	s2,0x4000
    80000d5a:	197d                	addi	s2,s2,-1
    80000d5c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5e:	0000ea17          	auipc	s4,0xe
    80000d62:	d22a0a13          	addi	s4,s4,-734 # 8000ea80 <tickslock>
    char *pa = kalloc();
    80000d66:	fffff097          	auipc	ra,0xfffff
    80000d6a:	3b2080e7          	jalr	946(ra) # 80000118 <kalloc>
    80000d6e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d70:	c131                	beqz	a0,80000db4 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d72:	416485b3          	sub	a1,s1,s6
    80000d76:	8591                	srai	a1,a1,0x4
    80000d78:	000ab783          	ld	a5,0(s5)
    80000d7c:	02f585b3          	mul	a1,a1,a5
    80000d80:	2585                	addiw	a1,a1,1
    80000d82:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d86:	4719                	li	a4,6
    80000d88:	6685                	lui	a3,0x1
    80000d8a:	40b905b3          	sub	a1,s2,a1
    80000d8e:	854e                	mv	a0,s3
    80000d90:	00000097          	auipc	ra,0x0
    80000d94:	8a8080e7          	jalr	-1880(ra) # 80000638 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d98:	17048493          	addi	s1,s1,368
    80000d9c:	fd4495e3          	bne	s1,s4,80000d66 <proc_mapstacks+0x38>
  }
}
    80000da0:	70e2                	ld	ra,56(sp)
    80000da2:	7442                	ld	s0,48(sp)
    80000da4:	74a2                	ld	s1,40(sp)
    80000da6:	7902                	ld	s2,32(sp)
    80000da8:	69e2                	ld	s3,24(sp)
    80000daa:	6a42                	ld	s4,16(sp)
    80000dac:	6aa2                	ld	s5,8(sp)
    80000dae:	6b02                	ld	s6,0(sp)
    80000db0:	6121                	addi	sp,sp,64
    80000db2:	8082                	ret
      panic("kalloc");
    80000db4:	00007517          	auipc	a0,0x7
    80000db8:	3a450513          	addi	a0,a0,932 # 80008158 <etext+0x158>
    80000dbc:	00005097          	auipc	ra,0x5
    80000dc0:	f76080e7          	jalr	-138(ra) # 80005d32 <panic>

0000000080000dc4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dc4:	7139                	addi	sp,sp,-64
    80000dc6:	fc06                	sd	ra,56(sp)
    80000dc8:	f822                	sd	s0,48(sp)
    80000dca:	f426                	sd	s1,40(sp)
    80000dcc:	f04a                	sd	s2,32(sp)
    80000dce:	ec4e                	sd	s3,24(sp)
    80000dd0:	e852                	sd	s4,16(sp)
    80000dd2:	e456                	sd	s5,8(sp)
    80000dd4:	e05a                	sd	s6,0(sp)
    80000dd6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd8:	00007597          	auipc	a1,0x7
    80000ddc:	38858593          	addi	a1,a1,904 # 80008160 <etext+0x160>
    80000de0:	00008517          	auipc	a0,0x8
    80000de4:	c7050513          	addi	a0,a0,-912 # 80008a50 <pid_lock>
    80000de8:	00005097          	auipc	ra,0x5
    80000dec:	404080e7          	jalr	1028(ra) # 800061ec <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df0:	00007597          	auipc	a1,0x7
    80000df4:	37858593          	addi	a1,a1,888 # 80008168 <etext+0x168>
    80000df8:	00008517          	auipc	a0,0x8
    80000dfc:	c7050513          	addi	a0,a0,-912 # 80008a68 <wait_lock>
    80000e00:	00005097          	auipc	ra,0x5
    80000e04:	3ec080e7          	jalr	1004(ra) # 800061ec <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e08:	00008497          	auipc	s1,0x8
    80000e0c:	07848493          	addi	s1,s1,120 # 80008e80 <proc>
      initlock(&p->lock, "proc");
    80000e10:	00007b17          	auipc	s6,0x7
    80000e14:	368b0b13          	addi	s6,s6,872 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e18:	8aa6                	mv	s5,s1
    80000e1a:	00007a17          	auipc	s4,0x7
    80000e1e:	1e6a0a13          	addi	s4,s4,486 # 80008000 <etext>
    80000e22:	04000937          	lui	s2,0x4000
    80000e26:	197d                	addi	s2,s2,-1
    80000e28:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	0000e997          	auipc	s3,0xe
    80000e2e:	c5698993          	addi	s3,s3,-938 # 8000ea80 <tickslock>
      initlock(&p->lock, "proc");
    80000e32:	85da                	mv	a1,s6
    80000e34:	8526                	mv	a0,s1
    80000e36:	00005097          	auipc	ra,0x5
    80000e3a:	3b6080e7          	jalr	950(ra) # 800061ec <initlock>
      p->state = UNUSED;
    80000e3e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e42:	415487b3          	sub	a5,s1,s5
    80000e46:	8791                	srai	a5,a5,0x4
    80000e48:	000a3703          	ld	a4,0(s4)
    80000e4c:	02e787b3          	mul	a5,a5,a4
    80000e50:	2785                	addiw	a5,a5,1
    80000e52:	00d7979b          	slliw	a5,a5,0xd
    80000e56:	40f907b3          	sub	a5,s2,a5
    80000e5a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5c:	17048493          	addi	s1,s1,368
    80000e60:	fd3499e3          	bne	s1,s3,80000e32 <procinit+0x6e>
  }
}
    80000e64:	70e2                	ld	ra,56(sp)
    80000e66:	7442                	ld	s0,48(sp)
    80000e68:	74a2                	ld	s1,40(sp)
    80000e6a:	7902                	ld	s2,32(sp)
    80000e6c:	69e2                	ld	s3,24(sp)
    80000e6e:	6a42                	ld	s4,16(sp)
    80000e70:	6aa2                	ld	s5,8(sp)
    80000e72:	6b02                	ld	s6,0(sp)
    80000e74:	6121                	addi	sp,sp,64
    80000e76:	8082                	ret

0000000080000e78 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e422                	sd	s0,8(sp)
    80000e7c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e7e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e80:	2501                	sext.w	a0,a0
    80000e82:	6422                	ld	s0,8(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret

0000000080000e88 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e88:	1141                	addi	sp,sp,-16
    80000e8a:	e422                	sd	s0,8(sp)
    80000e8c:	0800                	addi	s0,sp,16
    80000e8e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e94:	00008517          	auipc	a0,0x8
    80000e98:	bec50513          	addi	a0,a0,-1044 # 80008a80 <cpus>
    80000e9c:	953e                	add	a0,a0,a5
    80000e9e:	6422                	ld	s0,8(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret

0000000080000ea4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ea4:	1101                	addi	sp,sp,-32
    80000ea6:	ec06                	sd	ra,24(sp)
    80000ea8:	e822                	sd	s0,16(sp)
    80000eaa:	e426                	sd	s1,8(sp)
    80000eac:	1000                	addi	s0,sp,32
  push_off();
    80000eae:	00005097          	auipc	ra,0x5
    80000eb2:	382080e7          	jalr	898(ra) # 80006230 <push_off>
    80000eb6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb8:	2781                	sext.w	a5,a5
    80000eba:	079e                	slli	a5,a5,0x7
    80000ebc:	00008717          	auipc	a4,0x8
    80000ec0:	b9470713          	addi	a4,a4,-1132 # 80008a50 <pid_lock>
    80000ec4:	97ba                	add	a5,a5,a4
    80000ec6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	408080e7          	jalr	1032(ra) # 800062d0 <pop_off>
  return p;
}
    80000ed0:	8526                	mv	a0,s1
    80000ed2:	60e2                	ld	ra,24(sp)
    80000ed4:	6442                	ld	s0,16(sp)
    80000ed6:	64a2                	ld	s1,8(sp)
    80000ed8:	6105                	addi	sp,sp,32
    80000eda:	8082                	ret

0000000080000edc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000edc:	1141                	addi	sp,sp,-16
    80000ede:	e406                	sd	ra,8(sp)
    80000ee0:	e022                	sd	s0,0(sp)
    80000ee2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ee4:	00000097          	auipc	ra,0x0
    80000ee8:	fc0080e7          	jalr	-64(ra) # 80000ea4 <myproc>
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	444080e7          	jalr	1092(ra) # 80006330 <release>

  if (first) {
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	97c7a783          	lw	a5,-1668(a5) # 80008870 <first.1679>
    80000efc:	eb89                	bnez	a5,80000f0e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000efe:	00001097          	auipc	ra,0x1
    80000f02:	c92080e7          	jalr	-878(ra) # 80001b90 <usertrapret>
}
    80000f06:	60a2                	ld	ra,8(sp)
    80000f08:	6402                	ld	s0,0(sp)
    80000f0a:	0141                	addi	sp,sp,16
    80000f0c:	8082                	ret
    first = 0;
    80000f0e:	00008797          	auipc	a5,0x8
    80000f12:	9607a123          	sw	zero,-1694(a5) # 80008870 <first.1679>
    fsinit(ROOTDEV);
    80000f16:	4505                	li	a0,1
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	aa6080e7          	jalr	-1370(ra) # 800029be <fsinit>
    80000f20:	bff9                	j	80000efe <forkret+0x22>

0000000080000f22 <allocpid>:
{
    80000f22:	1101                	addi	sp,sp,-32
    80000f24:	ec06                	sd	ra,24(sp)
    80000f26:	e822                	sd	s0,16(sp)
    80000f28:	e426                	sd	s1,8(sp)
    80000f2a:	e04a                	sd	s2,0(sp)
    80000f2c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f2e:	00008917          	auipc	s2,0x8
    80000f32:	b2290913          	addi	s2,s2,-1246 # 80008a50 <pid_lock>
    80000f36:	854a                	mv	a0,s2
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	344080e7          	jalr	836(ra) # 8000627c <acquire>
  pid = nextpid;
    80000f40:	00008797          	auipc	a5,0x8
    80000f44:	93478793          	addi	a5,a5,-1740 # 80008874 <nextpid>
    80000f48:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f4a:	0014871b          	addiw	a4,s1,1
    80000f4e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f50:	854a                	mv	a0,s2
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	3de080e7          	jalr	990(ra) # 80006330 <release>
}
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6902                	ld	s2,0(sp)
    80000f64:	6105                	addi	sp,sp,32
    80000f66:	8082                	ret

0000000080000f68 <proc_pagetable>:
{
    80000f68:	1101                	addi	sp,sp,-32
    80000f6a:	ec06                	sd	ra,24(sp)
    80000f6c:	e822                	sd	s0,16(sp)
    80000f6e:	e426                	sd	s1,8(sp)
    80000f70:	e04a                	sd	s2,0(sp)
    80000f72:	1000                	addi	s0,sp,32
    80000f74:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	8ac080e7          	jalr	-1876(ra) # 80000822 <uvmcreate>
    80000f7e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f80:	c121                	beqz	a0,80000fc0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f82:	4729                	li	a4,10
    80000f84:	00006697          	auipc	a3,0x6
    80000f88:	07c68693          	addi	a3,a3,124 # 80007000 <_trampoline>
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	040005b7          	lui	a1,0x4000
    80000f92:	15fd                	addi	a1,a1,-1
    80000f94:	05b2                	slli	a1,a1,0xc
    80000f96:	fffff097          	auipc	ra,0xfffff
    80000f9a:	602080e7          	jalr	1538(ra) # 80000598 <mappages>
    80000f9e:	02054863          	bltz	a0,80000fce <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fa2:	4719                	li	a4,6
    80000fa4:	05893683          	ld	a3,88(s2)
    80000fa8:	6605                	lui	a2,0x1
    80000faa:	020005b7          	lui	a1,0x2000
    80000fae:	15fd                	addi	a1,a1,-1
    80000fb0:	05b6                	slli	a1,a1,0xd
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	5e4080e7          	jalr	1508(ra) # 80000598 <mappages>
    80000fbc:	02054163          	bltz	a0,80000fde <proc_pagetable+0x76>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fce:	4581                	li	a1,0
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	a54080e7          	jalr	-1452(ra) # 80000a26 <uvmfree>
    return 0;
    80000fda:	4481                	li	s1,0
    80000fdc:	b7d5                	j	80000fc0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fde:	4681                	li	a3,0
    80000fe0:	4605                	li	a2,1
    80000fe2:	040005b7          	lui	a1,0x4000
    80000fe6:	15fd                	addi	a1,a1,-1
    80000fe8:	05b2                	slli	a1,a1,0xc
    80000fea:	8526                	mv	a0,s1
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	772080e7          	jalr	1906(ra) # 8000075e <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff4:	4581                	li	a1,0
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	00000097          	auipc	ra,0x0
    80000ffc:	a2e080e7          	jalr	-1490(ra) # 80000a26 <uvmfree>
    return 0;
    80001000:	4481                	li	s1,0
    80001002:	bf7d                	j	80000fc0 <proc_pagetable+0x58>

0000000080001004 <proc_freepagetable>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
    80001012:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001014:	4681                	li	a3,0
    80001016:	4605                	li	a2,1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	73e080e7          	jalr	1854(ra) # 8000075e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001028:	4681                	li	a3,0
    8000102a:	4605                	li	a2,1
    8000102c:	020005b7          	lui	a1,0x2000
    80001030:	15fd                	addi	a1,a1,-1
    80001032:	05b6                	slli	a1,a1,0xd
    80001034:	8526                	mv	a0,s1
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	728080e7          	jalr	1832(ra) # 8000075e <uvmunmap>
  uvmfree(pagetable, sz);
    8000103e:	85ca                	mv	a1,s2
    80001040:	8526                	mv	a0,s1
    80001042:	00000097          	auipc	ra,0x0
    80001046:	9e4080e7          	jalr	-1564(ra) # 80000a26 <uvmfree>
}
    8000104a:	60e2                	ld	ra,24(sp)
    8000104c:	6442                	ld	s0,16(sp)
    8000104e:	64a2                	ld	s1,8(sp)
    80001050:	6902                	ld	s2,0(sp)
    80001052:	6105                	addi	sp,sp,32
    80001054:	8082                	ret

0000000080001056 <freeproc>:
{
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	1000                	addi	s0,sp,32
    80001060:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001062:	6d28                	ld	a0,88(a0)
    80001064:	c509                	beqz	a0,8000106e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	fb6080e7          	jalr	-74(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000106e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001072:	68a8                	ld	a0,80(s1)
    80001074:	c511                	beqz	a0,80001080 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001076:	64ac                	ld	a1,72(s1)
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	f8c080e7          	jalr	-116(ra) # 80001004 <proc_freepagetable>
  p->pagetable = 0;
    80001080:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001084:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001088:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000108c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001090:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001094:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001098:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000109c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010a0:	0004ac23          	sw	zero,24(s1)
}
    800010a4:	60e2                	ld	ra,24(sp)
    800010a6:	6442                	ld	s0,16(sp)
    800010a8:	64a2                	ld	s1,8(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret

00000000800010ae <allocproc>:
{
    800010ae:	1101                	addi	sp,sp,-32
    800010b0:	ec06                	sd	ra,24(sp)
    800010b2:	e822                	sd	s0,16(sp)
    800010b4:	e426                	sd	s1,8(sp)
    800010b6:	e04a                	sd	s2,0(sp)
    800010b8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	00008497          	auipc	s1,0x8
    800010be:	dc648493          	addi	s1,s1,-570 # 80008e80 <proc>
    800010c2:	0000e917          	auipc	s2,0xe
    800010c6:	9be90913          	addi	s2,s2,-1602 # 8000ea80 <tickslock>
    acquire(&p->lock);
    800010ca:	8526                	mv	a0,s1
    800010cc:	00005097          	auipc	ra,0x5
    800010d0:	1b0080e7          	jalr	432(ra) # 8000627c <acquire>
    if(p->state == UNUSED) {
    800010d4:	4c9c                	lw	a5,24(s1)
    800010d6:	cf81                	beqz	a5,800010ee <allocproc+0x40>
      release(&p->lock);
    800010d8:	8526                	mv	a0,s1
    800010da:	00005097          	auipc	ra,0x5
    800010de:	256080e7          	jalr	598(ra) # 80006330 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e2:	17048493          	addi	s1,s1,368
    800010e6:	ff2492e3          	bne	s1,s2,800010ca <allocproc+0x1c>
  return 0;
    800010ea:	4481                	li	s1,0
    800010ec:	a889                	j	8000113e <allocproc+0x90>
  p->pid = allocpid();
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	e34080e7          	jalr	-460(ra) # 80000f22 <allocpid>
    800010f6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f8:	4785                	li	a5,1
    800010fa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	01c080e7          	jalr	28(ra) # 80000118 <kalloc>
    80001104:	892a                	mv	s2,a0
    80001106:	eca8                	sd	a0,88(s1)
    80001108:	c131                	beqz	a0,8000114c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	e5c080e7          	jalr	-420(ra) # 80000f68 <proc_pagetable>
    80001114:	892a                	mv	s2,a0
    80001116:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001118:	c531                	beqz	a0,80001164 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000111a:	07000613          	li	a2,112
    8000111e:	4581                	li	a1,0
    80001120:	06048513          	addi	a0,s1,96
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	0a0080e7          	jalr	160(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    8000112c:	00000797          	auipc	a5,0x0
    80001130:	db078793          	addi	a5,a5,-592 # 80000edc <forkret>
    80001134:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001136:	60bc                	ld	a5,64(s1)
    80001138:	6705                	lui	a4,0x1
    8000113a:	97ba                	add	a5,a5,a4
    8000113c:	f4bc                	sd	a5,104(s1)
}
    8000113e:	8526                	mv	a0,s1
    80001140:	60e2                	ld	ra,24(sp)
    80001142:	6442                	ld	s0,16(sp)
    80001144:	64a2                	ld	s1,8(sp)
    80001146:	6902                	ld	s2,0(sp)
    80001148:	6105                	addi	sp,sp,32
    8000114a:	8082                	ret
    freeproc(p);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	f08080e7          	jalr	-248(ra) # 80001056 <freeproc>
    release(&p->lock);
    80001156:	8526                	mv	a0,s1
    80001158:	00005097          	auipc	ra,0x5
    8000115c:	1d8080e7          	jalr	472(ra) # 80006330 <release>
    return 0;
    80001160:	84ca                	mv	s1,s2
    80001162:	bff1                	j	8000113e <allocproc+0x90>
    freeproc(p);
    80001164:	8526                	mv	a0,s1
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	ef0080e7          	jalr	-272(ra) # 80001056 <freeproc>
    release(&p->lock);
    8000116e:	8526                	mv	a0,s1
    80001170:	00005097          	auipc	ra,0x5
    80001174:	1c0080e7          	jalr	448(ra) # 80006330 <release>
    return 0;
    80001178:	84ca                	mv	s1,s2
    8000117a:	b7d1                	j	8000113e <allocproc+0x90>

000000008000117c <userinit>:
{
    8000117c:	1101                	addi	sp,sp,-32
    8000117e:	ec06                	sd	ra,24(sp)
    80001180:	e822                	sd	s0,16(sp)
    80001182:	e426                	sd	s1,8(sp)
    80001184:	1000                	addi	s0,sp,32
  p = allocproc();
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	f28080e7          	jalr	-216(ra) # 800010ae <allocproc>
    8000118e:	84aa                	mv	s1,a0
  initproc = p;
    80001190:	00008797          	auipc	a5,0x8
    80001194:	86a7b823          	sd	a0,-1936(a5) # 80008a00 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001198:	03400613          	li	a2,52
    8000119c:	00007597          	auipc	a1,0x7
    800011a0:	6e458593          	addi	a1,a1,1764 # 80008880 <initcode>
    800011a4:	6928                	ld	a0,80(a0)
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	6aa080e7          	jalr	1706(ra) # 80000850 <uvmfirst>
  p->sz = PGSIZE;
    800011ae:	6785                	lui	a5,0x1
    800011b0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011b2:	6cb8                	ld	a4,88(s1)
    800011b4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b8:	6cb8                	ld	a4,88(s1)
    800011ba:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011bc:	4641                	li	a2,16
    800011be:	00007597          	auipc	a1,0x7
    800011c2:	fc258593          	addi	a1,a1,-62 # 80008180 <etext+0x180>
    800011c6:	15848513          	addi	a0,s1,344
    800011ca:	fffff097          	auipc	ra,0xfffff
    800011ce:	14c080e7          	jalr	332(ra) # 80000316 <safestrcpy>
  p->cwd = namei("/");
    800011d2:	00007517          	auipc	a0,0x7
    800011d6:	fbe50513          	addi	a0,a0,-66 # 80008190 <etext+0x190>
    800011da:	00002097          	auipc	ra,0x2
    800011de:	206080e7          	jalr	518(ra) # 800033e0 <namei>
    800011e2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e6:	478d                	li	a5,3
    800011e8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ea:	8526                	mv	a0,s1
    800011ec:	00005097          	auipc	ra,0x5
    800011f0:	144080e7          	jalr	324(ra) # 80006330 <release>
}
    800011f4:	60e2                	ld	ra,24(sp)
    800011f6:	6442                	ld	s0,16(sp)
    800011f8:	64a2                	ld	s1,8(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret

00000000800011fe <growproc>:
{
    800011fe:	1101                	addi	sp,sp,-32
    80001200:	ec06                	sd	ra,24(sp)
    80001202:	e822                	sd	s0,16(sp)
    80001204:	e426                	sd	s1,8(sp)
    80001206:	e04a                	sd	s2,0(sp)
    80001208:	1000                	addi	s0,sp,32
    8000120a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	c98080e7          	jalr	-872(ra) # 80000ea4 <myproc>
    80001214:	84aa                	mv	s1,a0
  sz = p->sz;
    80001216:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001218:	01204c63          	bgtz	s2,80001230 <growproc+0x32>
  } else if(n < 0){
    8000121c:	02094663          	bltz	s2,80001248 <growproc+0x4a>
  p->sz = sz;
    80001220:	e4ac                	sd	a1,72(s1)
  return 0;
    80001222:	4501                	li	a0,0
}
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6902                	ld	s2,0(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001230:	4691                	li	a3,4
    80001232:	00b90633          	add	a2,s2,a1
    80001236:	6928                	ld	a0,80(a0)
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	6d2080e7          	jalr	1746(ra) # 8000090a <uvmalloc>
    80001240:	85aa                	mv	a1,a0
    80001242:	fd79                	bnez	a0,80001220 <growproc+0x22>
      return -1;
    80001244:	557d                	li	a0,-1
    80001246:	bff9                	j	80001224 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001248:	00b90633          	add	a2,s2,a1
    8000124c:	6928                	ld	a0,80(a0)
    8000124e:	fffff097          	auipc	ra,0xfffff
    80001252:	674080e7          	jalr	1652(ra) # 800008c2 <uvmdealloc>
    80001256:	85aa                	mv	a1,a0
    80001258:	b7e1                	j	80001220 <growproc+0x22>

000000008000125a <fork>:
{
    8000125a:	7179                	addi	sp,sp,-48
    8000125c:	f406                	sd	ra,40(sp)
    8000125e:	f022                	sd	s0,32(sp)
    80001260:	ec26                	sd	s1,24(sp)
    80001262:	e84a                	sd	s2,16(sp)
    80001264:	e44e                	sd	s3,8(sp)
    80001266:	e052                	sd	s4,0(sp)
    80001268:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	c3a080e7          	jalr	-966(ra) # 80000ea4 <myproc>
    80001272:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001274:	00000097          	auipc	ra,0x0
    80001278:	e3a080e7          	jalr	-454(ra) # 800010ae <allocproc>
    8000127c:	10050f63          	beqz	a0,8000139a <fork+0x140>
    80001280:	89aa                	mv	s3,a0
  np -> mask = p -> mask;
    80001282:	16893783          	ld	a5,360(s2)
    80001286:	16f53423          	sd	a5,360(a0)
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128a:	04893603          	ld	a2,72(s2)
    8000128e:	692c                	ld	a1,80(a0)
    80001290:	05093503          	ld	a0,80(s2)
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	7ca080e7          	jalr	1994(ra) # 80000a5e <uvmcopy>
    8000129c:	04054663          	bltz	a0,800012e8 <fork+0x8e>
  np->sz = p->sz;
    800012a0:	04893783          	ld	a5,72(s2)
    800012a4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a8:	05893683          	ld	a3,88(s2)
    800012ac:	87b6                	mv	a5,a3
    800012ae:	0589b703          	ld	a4,88(s3)
    800012b2:	12068693          	addi	a3,a3,288
    800012b6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ba:	6788                	ld	a0,8(a5)
    800012bc:	6b8c                	ld	a1,16(a5)
    800012be:	6f90                	ld	a2,24(a5)
    800012c0:	01073023          	sd	a6,0(a4)
    800012c4:	e708                	sd	a0,8(a4)
    800012c6:	eb0c                	sd	a1,16(a4)
    800012c8:	ef10                	sd	a2,24(a4)
    800012ca:	02078793          	addi	a5,a5,32
    800012ce:	02070713          	addi	a4,a4,32
    800012d2:	fed792e3          	bne	a5,a3,800012b6 <fork+0x5c>
  np->trapframe->a0 = 0;
    800012d6:	0589b783          	ld	a5,88(s3)
    800012da:	0607b823          	sd	zero,112(a5)
    800012de:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e2:	15000a13          	li	s4,336
    800012e6:	a03d                	j	80001314 <fork+0xba>
    freeproc(np);
    800012e8:	854e                	mv	a0,s3
    800012ea:	00000097          	auipc	ra,0x0
    800012ee:	d6c080e7          	jalr	-660(ra) # 80001056 <freeproc>
    release(&np->lock);
    800012f2:	854e                	mv	a0,s3
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	03c080e7          	jalr	60(ra) # 80006330 <release>
    return -1;
    800012fc:	5a7d                	li	s4,-1
    800012fe:	a069                	j	80001388 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	776080e7          	jalr	1910(ra) # 80003a76 <filedup>
    80001308:	009987b3          	add	a5,s3,s1
    8000130c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000130e:	04a1                	addi	s1,s1,8
    80001310:	01448763          	beq	s1,s4,8000131e <fork+0xc4>
    if(p->ofile[i])
    80001314:	009907b3          	add	a5,s2,s1
    80001318:	6388                	ld	a0,0(a5)
    8000131a:	f17d                	bnez	a0,80001300 <fork+0xa6>
    8000131c:	bfcd                	j	8000130e <fork+0xb4>
  np->cwd = idup(p->cwd);
    8000131e:	15093503          	ld	a0,336(s2)
    80001322:	00002097          	auipc	ra,0x2
    80001326:	8da080e7          	jalr	-1830(ra) # 80002bfc <idup>
    8000132a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132e:	4641                	li	a2,16
    80001330:	15890593          	addi	a1,s2,344
    80001334:	15898513          	addi	a0,s3,344
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	fde080e7          	jalr	-34(ra) # 80000316 <safestrcpy>
  pid = np->pid;
    80001340:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001344:	854e                	mv	a0,s3
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	fea080e7          	jalr	-22(ra) # 80006330 <release>
  acquire(&wait_lock);
    8000134e:	00007497          	auipc	s1,0x7
    80001352:	71a48493          	addi	s1,s1,1818 # 80008a68 <wait_lock>
    80001356:	8526                	mv	a0,s1
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	f24080e7          	jalr	-220(ra) # 8000627c <acquire>
  np->parent = p;
    80001360:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001364:	8526                	mv	a0,s1
    80001366:	00005097          	auipc	ra,0x5
    8000136a:	fca080e7          	jalr	-54(ra) # 80006330 <release>
  acquire(&np->lock);
    8000136e:	854e                	mv	a0,s3
    80001370:	00005097          	auipc	ra,0x5
    80001374:	f0c080e7          	jalr	-244(ra) # 8000627c <acquire>
  np->state = RUNNABLE;
    80001378:	478d                	li	a5,3
    8000137a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000137e:	854e                	mv	a0,s3
    80001380:	00005097          	auipc	ra,0x5
    80001384:	fb0080e7          	jalr	-80(ra) # 80006330 <release>
}
    80001388:	8552                	mv	a0,s4
    8000138a:	70a2                	ld	ra,40(sp)
    8000138c:	7402                	ld	s0,32(sp)
    8000138e:	64e2                	ld	s1,24(sp)
    80001390:	6942                	ld	s2,16(sp)
    80001392:	69a2                	ld	s3,8(sp)
    80001394:	6a02                	ld	s4,0(sp)
    80001396:	6145                	addi	sp,sp,48
    80001398:	8082                	ret
    return -1;
    8000139a:	5a7d                	li	s4,-1
    8000139c:	b7f5                	j	80001388 <fork+0x12e>

000000008000139e <scheduler>:
{
    8000139e:	7139                	addi	sp,sp,-64
    800013a0:	fc06                	sd	ra,56(sp)
    800013a2:	f822                	sd	s0,48(sp)
    800013a4:	f426                	sd	s1,40(sp)
    800013a6:	f04a                	sd	s2,32(sp)
    800013a8:	ec4e                	sd	s3,24(sp)
    800013aa:	e852                	sd	s4,16(sp)
    800013ac:	e456                	sd	s5,8(sp)
    800013ae:	e05a                	sd	s6,0(sp)
    800013b0:	0080                	addi	s0,sp,64
    800013b2:	8792                	mv	a5,tp
  int id = r_tp();
    800013b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b6:	00779a93          	slli	s5,a5,0x7
    800013ba:	00007717          	auipc	a4,0x7
    800013be:	69670713          	addi	a4,a4,1686 # 80008a50 <pid_lock>
    800013c2:	9756                	add	a4,a4,s5
    800013c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013c8:	00007717          	auipc	a4,0x7
    800013cc:	6c070713          	addi	a4,a4,1728 # 80008a88 <cpus+0x8>
    800013d0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d2:	498d                	li	s3,3
        p->state = RUNNING;
    800013d4:	4b11                	li	s6,4
        c->proc = p;
    800013d6:	079e                	slli	a5,a5,0x7
    800013d8:	00007a17          	auipc	s4,0x7
    800013dc:	678a0a13          	addi	s4,s4,1656 # 80008a50 <pid_lock>
    800013e0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	0000d917          	auipc	s2,0xd
    800013e6:	69e90913          	addi	s2,s2,1694 # 8000ea80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ea:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f2:	10079073          	csrw	sstatus,a5
    800013f6:	00008497          	auipc	s1,0x8
    800013fa:	a8a48493          	addi	s1,s1,-1398 # 80008e80 <proc>
    800013fe:	a03d                	j	8000142c <scheduler+0x8e>
        p->state = RUNNING;
    80001400:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001404:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001408:	06048593          	addi	a1,s1,96
    8000140c:	8556                	mv	a0,s5
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	6d8080e7          	jalr	1752(ra) # 80001ae6 <swtch>
        c->proc = 0;
    80001416:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	f14080e7          	jalr	-236(ra) # 80006330 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001424:	17048493          	addi	s1,s1,368
    80001428:	fd2481e3          	beq	s1,s2,800013ea <scheduler+0x4c>
      acquire(&p->lock);
    8000142c:	8526                	mv	a0,s1
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	e4e080e7          	jalr	-434(ra) # 8000627c <acquire>
      if(p->state == RUNNABLE) {
    80001436:	4c9c                	lw	a5,24(s1)
    80001438:	ff3791e3          	bne	a5,s3,8000141a <scheduler+0x7c>
    8000143c:	b7d1                	j	80001400 <scheduler+0x62>

000000008000143e <sched>:
{
    8000143e:	7179                	addi	sp,sp,-48
    80001440:	f406                	sd	ra,40(sp)
    80001442:	f022                	sd	s0,32(sp)
    80001444:	ec26                	sd	s1,24(sp)
    80001446:	e84a                	sd	s2,16(sp)
    80001448:	e44e                	sd	s3,8(sp)
    8000144a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	a58080e7          	jalr	-1448(ra) # 80000ea4 <myproc>
    80001454:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	dac080e7          	jalr	-596(ra) # 80006202 <holding>
    8000145e:	c93d                	beqz	a0,800014d4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001460:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	00007717          	auipc	a4,0x7
    8000146a:	5ea70713          	addi	a4,a4,1514 # 80008a50 <pid_lock>
    8000146e:	97ba                	add	a5,a5,a4
    80001470:	0a87a703          	lw	a4,168(a5)
    80001474:	4785                	li	a5,1
    80001476:	06f71763          	bne	a4,a5,800014e4 <sched+0xa6>
  if(p->state == RUNNING)
    8000147a:	4c98                	lw	a4,24(s1)
    8000147c:	4791                	li	a5,4
    8000147e:	06f70b63          	beq	a4,a5,800014f4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001482:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001486:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001488:	efb5                	bnez	a5,80001504 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000148c:	00007917          	auipc	s2,0x7
    80001490:	5c490913          	addi	s2,s2,1476 # 80008a50 <pid_lock>
    80001494:	2781                	sext.w	a5,a5
    80001496:	079e                	slli	a5,a5,0x7
    80001498:	97ca                	add	a5,a5,s2
    8000149a:	0ac7a983          	lw	s3,172(a5)
    8000149e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	00007597          	auipc	a1,0x7
    800014a8:	5e458593          	addi	a1,a1,1508 # 80008a88 <cpus+0x8>
    800014ac:	95be                	add	a1,a1,a5
    800014ae:	06048513          	addi	a0,s1,96
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	634080e7          	jalr	1588(ra) # 80001ae6 <swtch>
    800014ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014bc:	2781                	sext.w	a5,a5
    800014be:	079e                	slli	a5,a5,0x7
    800014c0:	97ca                	add	a5,a5,s2
    800014c2:	0b37a623          	sw	s3,172(a5)
}
    800014c6:	70a2                	ld	ra,40(sp)
    800014c8:	7402                	ld	s0,32(sp)
    800014ca:	64e2                	ld	s1,24(sp)
    800014cc:	6942                	ld	s2,16(sp)
    800014ce:	69a2                	ld	s3,8(sp)
    800014d0:	6145                	addi	sp,sp,48
    800014d2:	8082                	ret
    panic("sched p->lock");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	cc450513          	addi	a0,a0,-828 # 80008198 <etext+0x198>
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	856080e7          	jalr	-1962(ra) # 80005d32 <panic>
    panic("sched locks");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	cc450513          	addi	a0,a0,-828 # 800081a8 <etext+0x1a8>
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	846080e7          	jalr	-1978(ra) # 80005d32 <panic>
    panic("sched running");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	cc450513          	addi	a0,a0,-828 # 800081b8 <etext+0x1b8>
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	836080e7          	jalr	-1994(ra) # 80005d32 <panic>
    panic("sched interruptible");
    80001504:	00007517          	auipc	a0,0x7
    80001508:	cc450513          	addi	a0,a0,-828 # 800081c8 <etext+0x1c8>
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	826080e7          	jalr	-2010(ra) # 80005d32 <panic>

0000000080001514 <yield>:
{
    80001514:	1101                	addi	sp,sp,-32
    80001516:	ec06                	sd	ra,24(sp)
    80001518:	e822                	sd	s0,16(sp)
    8000151a:	e426                	sd	s1,8(sp)
    8000151c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	986080e7          	jalr	-1658(ra) # 80000ea4 <myproc>
    80001526:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	d54080e7          	jalr	-684(ra) # 8000627c <acquire>
  p->state = RUNNABLE;
    80001530:	478d                	li	a5,3
    80001532:	cc9c                	sw	a5,24(s1)
  sched();
    80001534:	00000097          	auipc	ra,0x0
    80001538:	f0a080e7          	jalr	-246(ra) # 8000143e <sched>
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	df2080e7          	jalr	-526(ra) # 80006330 <release>
}
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	addi	sp,sp,32
    8000154e:	8082                	ret

0000000080001550 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001550:	7179                	addi	sp,sp,-48
    80001552:	f406                	sd	ra,40(sp)
    80001554:	f022                	sd	s0,32(sp)
    80001556:	ec26                	sd	s1,24(sp)
    80001558:	e84a                	sd	s2,16(sp)
    8000155a:	e44e                	sd	s3,8(sp)
    8000155c:	1800                	addi	s0,sp,48
    8000155e:	89aa                	mv	s3,a0
    80001560:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	942080e7          	jalr	-1726(ra) # 80000ea4 <myproc>
    8000156a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	d10080e7          	jalr	-752(ra) # 8000627c <acquire>
  release(lk);
    80001574:	854a                	mv	a0,s2
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	dba080e7          	jalr	-582(ra) # 80006330 <release>

  // Go to sleep.
  p->chan = chan;
    8000157e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001582:	4789                	li	a5,2
    80001584:	cc9c                	sw	a5,24(s1)

  sched();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	eb8080e7          	jalr	-328(ra) # 8000143e <sched>

  // Tidy up.
  p->chan = 0;
    8000158e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	d9c080e7          	jalr	-612(ra) # 80006330 <release>
  acquire(lk);
    8000159c:	854a                	mv	a0,s2
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	cde080e7          	jalr	-802(ra) # 8000627c <acquire>
}
    800015a6:	70a2                	ld	ra,40(sp)
    800015a8:	7402                	ld	s0,32(sp)
    800015aa:	64e2                	ld	s1,24(sp)
    800015ac:	6942                	ld	s2,16(sp)
    800015ae:	69a2                	ld	s3,8(sp)
    800015b0:	6145                	addi	sp,sp,48
    800015b2:	8082                	ret

00000000800015b4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015b4:	7139                	addi	sp,sp,-64
    800015b6:	fc06                	sd	ra,56(sp)
    800015b8:	f822                	sd	s0,48(sp)
    800015ba:	f426                	sd	s1,40(sp)
    800015bc:	f04a                	sd	s2,32(sp)
    800015be:	ec4e                	sd	s3,24(sp)
    800015c0:	e852                	sd	s4,16(sp)
    800015c2:	e456                	sd	s5,8(sp)
    800015c4:	0080                	addi	s0,sp,64
    800015c6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015c8:	00008497          	auipc	s1,0x8
    800015cc:	8b848493          	addi	s1,s1,-1864 # 80008e80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d4:	0000d917          	auipc	s2,0xd
    800015d8:	4ac90913          	addi	s2,s2,1196 # 8000ea80 <tickslock>
    800015dc:	a821                	j	800015f4 <wakeup+0x40>
        p->state = RUNNABLE;
    800015de:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	d4c080e7          	jalr	-692(ra) # 80006330 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ec:	17048493          	addi	s1,s1,368
    800015f0:	03248463          	beq	s1,s2,80001618 <wakeup+0x64>
    if(p != myproc()){
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	8b0080e7          	jalr	-1872(ra) # 80000ea4 <myproc>
    800015fc:	fea488e3          	beq	s1,a0,800015ec <wakeup+0x38>
      acquire(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	c7a080e7          	jalr	-902(ra) # 8000627c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000160a:	4c9c                	lw	a5,24(s1)
    8000160c:	fd379be3          	bne	a5,s3,800015e2 <wakeup+0x2e>
    80001610:	709c                	ld	a5,32(s1)
    80001612:	fd4798e3          	bne	a5,s4,800015e2 <wakeup+0x2e>
    80001616:	b7e1                	j	800015de <wakeup+0x2a>
    }
  }
}
    80001618:	70e2                	ld	ra,56(sp)
    8000161a:	7442                	ld	s0,48(sp)
    8000161c:	74a2                	ld	s1,40(sp)
    8000161e:	7902                	ld	s2,32(sp)
    80001620:	69e2                	ld	s3,24(sp)
    80001622:	6a42                	ld	s4,16(sp)
    80001624:	6aa2                	ld	s5,8(sp)
    80001626:	6121                	addi	sp,sp,64
    80001628:	8082                	ret

000000008000162a <reparent>:
{
    8000162a:	7179                	addi	sp,sp,-48
    8000162c:	f406                	sd	ra,40(sp)
    8000162e:	f022                	sd	s0,32(sp)
    80001630:	ec26                	sd	s1,24(sp)
    80001632:	e84a                	sd	s2,16(sp)
    80001634:	e44e                	sd	s3,8(sp)
    80001636:	e052                	sd	s4,0(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163c:	00008497          	auipc	s1,0x8
    80001640:	84448493          	addi	s1,s1,-1980 # 80008e80 <proc>
      pp->parent = initproc;
    80001644:	00007a17          	auipc	s4,0x7
    80001648:	3bca0a13          	addi	s4,s4,956 # 80008a00 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164c:	0000d997          	auipc	s3,0xd
    80001650:	43498993          	addi	s3,s3,1076 # 8000ea80 <tickslock>
    80001654:	a029                	j	8000165e <reparent+0x34>
    80001656:	17048493          	addi	s1,s1,368
    8000165a:	01348d63          	beq	s1,s3,80001674 <reparent+0x4a>
    if(pp->parent == p){
    8000165e:	7c9c                	ld	a5,56(s1)
    80001660:	ff279be3          	bne	a5,s2,80001656 <reparent+0x2c>
      pp->parent = initproc;
    80001664:	000a3503          	ld	a0,0(s4)
    80001668:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	f4a080e7          	jalr	-182(ra) # 800015b4 <wakeup>
    80001672:	b7d5                	j	80001656 <reparent+0x2c>
}
    80001674:	70a2                	ld	ra,40(sp)
    80001676:	7402                	ld	s0,32(sp)
    80001678:	64e2                	ld	s1,24(sp)
    8000167a:	6942                	ld	s2,16(sp)
    8000167c:	69a2                	ld	s3,8(sp)
    8000167e:	6a02                	ld	s4,0(sp)
    80001680:	6145                	addi	sp,sp,48
    80001682:	8082                	ret

0000000080001684 <exit>:
{
    80001684:	7179                	addi	sp,sp,-48
    80001686:	f406                	sd	ra,40(sp)
    80001688:	f022                	sd	s0,32(sp)
    8000168a:	ec26                	sd	s1,24(sp)
    8000168c:	e84a                	sd	s2,16(sp)
    8000168e:	e44e                	sd	s3,8(sp)
    80001690:	e052                	sd	s4,0(sp)
    80001692:	1800                	addi	s0,sp,48
    80001694:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	80e080e7          	jalr	-2034(ra) # 80000ea4 <myproc>
    8000169e:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a0:	00007797          	auipc	a5,0x7
    800016a4:	3607b783          	ld	a5,864(a5) # 80008a00 <initproc>
    800016a8:	0d050493          	addi	s1,a0,208
    800016ac:	15050913          	addi	s2,a0,336
    800016b0:	02a79363          	bne	a5,a0,800016d6 <exit+0x52>
    panic("init exiting");
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	b2c50513          	addi	a0,a0,-1236 # 800081e0 <etext+0x1e0>
    800016bc:	00004097          	auipc	ra,0x4
    800016c0:	676080e7          	jalr	1654(ra) # 80005d32 <panic>
      fileclose(f);
    800016c4:	00002097          	auipc	ra,0x2
    800016c8:	404080e7          	jalr	1028(ra) # 80003ac8 <fileclose>
      p->ofile[fd] = 0;
    800016cc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d0:	04a1                	addi	s1,s1,8
    800016d2:	01248563          	beq	s1,s2,800016dc <exit+0x58>
    if(p->ofile[fd]){
    800016d6:	6088                	ld	a0,0(s1)
    800016d8:	f575                	bnez	a0,800016c4 <exit+0x40>
    800016da:	bfdd                	j	800016d0 <exit+0x4c>
  begin_op();
    800016dc:	00002097          	auipc	ra,0x2
    800016e0:	f20080e7          	jalr	-224(ra) # 800035fc <begin_op>
  iput(p->cwd);
    800016e4:	1509b503          	ld	a0,336(s3)
    800016e8:	00001097          	auipc	ra,0x1
    800016ec:	70c080e7          	jalr	1804(ra) # 80002df4 <iput>
  end_op();
    800016f0:	00002097          	auipc	ra,0x2
    800016f4:	f8c080e7          	jalr	-116(ra) # 8000367c <end_op>
  p->cwd = 0;
    800016f8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016fc:	00007497          	auipc	s1,0x7
    80001700:	36c48493          	addi	s1,s1,876 # 80008a68 <wait_lock>
    80001704:	8526                	mv	a0,s1
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	b76080e7          	jalr	-1162(ra) # 8000627c <acquire>
  reparent(p);
    8000170e:	854e                	mv	a0,s3
    80001710:	00000097          	auipc	ra,0x0
    80001714:	f1a080e7          	jalr	-230(ra) # 8000162a <reparent>
  wakeup(p->parent);
    80001718:	0389b503          	ld	a0,56(s3)
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	e98080e7          	jalr	-360(ra) # 800015b4 <wakeup>
  acquire(&p->lock);
    80001724:	854e                	mv	a0,s3
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	b56080e7          	jalr	-1194(ra) # 8000627c <acquire>
  p->xstate = status;
    8000172e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001732:	4795                	li	a5,5
    80001734:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	bf6080e7          	jalr	-1034(ra) # 80006330 <release>
  sched();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	cfc080e7          	jalr	-772(ra) # 8000143e <sched>
  panic("zombie exit");
    8000174a:	00007517          	auipc	a0,0x7
    8000174e:	aa650513          	addi	a0,a0,-1370 # 800081f0 <etext+0x1f0>
    80001752:	00004097          	auipc	ra,0x4
    80001756:	5e0080e7          	jalr	1504(ra) # 80005d32 <panic>

000000008000175a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000175a:	7179                	addi	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000176a:	00007497          	auipc	s1,0x7
    8000176e:	71648493          	addi	s1,s1,1814 # 80008e80 <proc>
    80001772:	0000d997          	auipc	s3,0xd
    80001776:	30e98993          	addi	s3,s3,782 # 8000ea80 <tickslock>
    acquire(&p->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	b00080e7          	jalr	-1280(ra) # 8000627c <acquire>
    if(p->pid == pid){
    80001784:	589c                	lw	a5,48(s1)
    80001786:	01278d63          	beq	a5,s2,800017a0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000178a:	8526                	mv	a0,s1
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	ba4080e7          	jalr	-1116(ra) # 80006330 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001794:	17048493          	addi	s1,s1,368
    80001798:	ff3491e3          	bne	s1,s3,8000177a <kill+0x20>
  }
  return -1;
    8000179c:	557d                	li	a0,-1
    8000179e:	a829                	j	800017b8 <kill+0x5e>
      p->killed = 1;
    800017a0:	4785                	li	a5,1
    800017a2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017a4:	4c98                	lw	a4,24(s1)
    800017a6:	4789                	li	a5,2
    800017a8:	00f70f63          	beq	a4,a5,800017c6 <kill+0x6c>
      release(&p->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	b82080e7          	jalr	-1150(ra) # 80006330 <release>
      return 0;
    800017b6:	4501                	li	a0,0
}
    800017b8:	70a2                	ld	ra,40(sp)
    800017ba:	7402                	ld	s0,32(sp)
    800017bc:	64e2                	ld	s1,24(sp)
    800017be:	6942                	ld	s2,16(sp)
    800017c0:	69a2                	ld	s3,8(sp)
    800017c2:	6145                	addi	sp,sp,48
    800017c4:	8082                	ret
        p->state = RUNNABLE;
    800017c6:	478d                	li	a5,3
    800017c8:	cc9c                	sw	a5,24(s1)
    800017ca:	b7cd                	j	800017ac <kill+0x52>

00000000800017cc <setkilled>:

void
setkilled(struct proc *p)
{
    800017cc:	1101                	addi	sp,sp,-32
    800017ce:	ec06                	sd	ra,24(sp)
    800017d0:	e822                	sd	s0,16(sp)
    800017d2:	e426                	sd	s1,8(sp)
    800017d4:	1000                	addi	s0,sp,32
    800017d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	aa4080e7          	jalr	-1372(ra) # 8000627c <acquire>
  p->killed = 1;
    800017e0:	4785                	li	a5,1
    800017e2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	b4a080e7          	jalr	-1206(ra) # 80006330 <release>
}
    800017ee:	60e2                	ld	ra,24(sp)
    800017f0:	6442                	ld	s0,16(sp)
    800017f2:	64a2                	ld	s1,8(sp)
    800017f4:	6105                	addi	sp,sp,32
    800017f6:	8082                	ret

00000000800017f8 <killed>:

int
killed(struct proc *p)
{
    800017f8:	1101                	addi	sp,sp,-32
    800017fa:	ec06                	sd	ra,24(sp)
    800017fc:	e822                	sd	s0,16(sp)
    800017fe:	e426                	sd	s1,8(sp)
    80001800:	e04a                	sd	s2,0(sp)
    80001802:	1000                	addi	s0,sp,32
    80001804:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	a76080e7          	jalr	-1418(ra) # 8000627c <acquire>
  k = p->killed;
    8000180e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	b1c080e7          	jalr	-1252(ra) # 80006330 <release>
  return k;
}
    8000181c:	854a                	mv	a0,s2
    8000181e:	60e2                	ld	ra,24(sp)
    80001820:	6442                	ld	s0,16(sp)
    80001822:	64a2                	ld	s1,8(sp)
    80001824:	6902                	ld	s2,0(sp)
    80001826:	6105                	addi	sp,sp,32
    80001828:	8082                	ret

000000008000182a <wait>:
{
    8000182a:	715d                	addi	sp,sp,-80
    8000182c:	e486                	sd	ra,72(sp)
    8000182e:	e0a2                	sd	s0,64(sp)
    80001830:	fc26                	sd	s1,56(sp)
    80001832:	f84a                	sd	s2,48(sp)
    80001834:	f44e                	sd	s3,40(sp)
    80001836:	f052                	sd	s4,32(sp)
    80001838:	ec56                	sd	s5,24(sp)
    8000183a:	e85a                	sd	s6,16(sp)
    8000183c:	e45e                	sd	s7,8(sp)
    8000183e:	e062                	sd	s8,0(sp)
    80001840:	0880                	addi	s0,sp,80
    80001842:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	660080e7          	jalr	1632(ra) # 80000ea4 <myproc>
    8000184c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	21a50513          	addi	a0,a0,538 # 80008a68 <wait_lock>
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	a26080e7          	jalr	-1498(ra) # 8000627c <acquire>
    havekids = 0;
    8000185e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001860:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001862:	0000d997          	auipc	s3,0xd
    80001866:	21e98993          	addi	s3,s3,542 # 8000ea80 <tickslock>
        havekids = 1;
    8000186a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000186c:	00007c17          	auipc	s8,0x7
    80001870:	1fcc0c13          	addi	s8,s8,508 # 80008a68 <wait_lock>
    havekids = 0;
    80001874:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001876:	00007497          	auipc	s1,0x7
    8000187a:	60a48493          	addi	s1,s1,1546 # 80008e80 <proc>
    8000187e:	a0bd                	j	800018ec <wait+0xc2>
          pid = pp->pid;
    80001880:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001884:	000b0e63          	beqz	s6,800018a0 <wait+0x76>
    80001888:	4691                	li	a3,4
    8000188a:	02c48613          	addi	a2,s1,44
    8000188e:	85da                	mv	a1,s6
    80001890:	05093503          	ld	a0,80(s2)
    80001894:	fffff097          	auipc	ra,0xfffff
    80001898:	2ce080e7          	jalr	718(ra) # 80000b62 <copyout>
    8000189c:	02054563          	bltz	a0,800018c6 <wait+0x9c>
          freeproc(pp);
    800018a0:	8526                	mv	a0,s1
    800018a2:	fffff097          	auipc	ra,0xfffff
    800018a6:	7b4080e7          	jalr	1972(ra) # 80001056 <freeproc>
          release(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	a84080e7          	jalr	-1404(ra) # 80006330 <release>
          release(&wait_lock);
    800018b4:	00007517          	auipc	a0,0x7
    800018b8:	1b450513          	addi	a0,a0,436 # 80008a68 <wait_lock>
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	a74080e7          	jalr	-1420(ra) # 80006330 <release>
          return pid;
    800018c4:	a0b5                	j	80001930 <wait+0x106>
            release(&pp->lock);
    800018c6:	8526                	mv	a0,s1
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	a68080e7          	jalr	-1432(ra) # 80006330 <release>
            release(&wait_lock);
    800018d0:	00007517          	auipc	a0,0x7
    800018d4:	19850513          	addi	a0,a0,408 # 80008a68 <wait_lock>
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	a58080e7          	jalr	-1448(ra) # 80006330 <release>
            return -1;
    800018e0:	59fd                	li	s3,-1
    800018e2:	a0b9                	j	80001930 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	17048493          	addi	s1,s1,368
    800018e8:	03348463          	beq	s1,s3,80001910 <wait+0xe6>
      if(pp->parent == p){
    800018ec:	7c9c                	ld	a5,56(s1)
    800018ee:	ff279be3          	bne	a5,s2,800018e4 <wait+0xba>
        acquire(&pp->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	988080e7          	jalr	-1656(ra) # 8000627c <acquire>
        if(pp->state == ZOMBIE){
    800018fc:	4c9c                	lw	a5,24(s1)
    800018fe:	f94781e3          	beq	a5,s4,80001880 <wait+0x56>
        release(&pp->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	a2c080e7          	jalr	-1492(ra) # 80006330 <release>
        havekids = 1;
    8000190c:	8756                	mv	a4,s5
    8000190e:	bfd9                	j	800018e4 <wait+0xba>
    if(!havekids || killed(p)){
    80001910:	c719                	beqz	a4,8000191e <wait+0xf4>
    80001912:	854a                	mv	a0,s2
    80001914:	00000097          	auipc	ra,0x0
    80001918:	ee4080e7          	jalr	-284(ra) # 800017f8 <killed>
    8000191c:	c51d                	beqz	a0,8000194a <wait+0x120>
      release(&wait_lock);
    8000191e:	00007517          	auipc	a0,0x7
    80001922:	14a50513          	addi	a0,a0,330 # 80008a68 <wait_lock>
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	a0a080e7          	jalr	-1526(ra) # 80006330 <release>
      return -1;
    8000192e:	59fd                	li	s3,-1
}
    80001930:	854e                	mv	a0,s3
    80001932:	60a6                	ld	ra,72(sp)
    80001934:	6406                	ld	s0,64(sp)
    80001936:	74e2                	ld	s1,56(sp)
    80001938:	7942                	ld	s2,48(sp)
    8000193a:	79a2                	ld	s3,40(sp)
    8000193c:	7a02                	ld	s4,32(sp)
    8000193e:	6ae2                	ld	s5,24(sp)
    80001940:	6b42                	ld	s6,16(sp)
    80001942:	6ba2                	ld	s7,8(sp)
    80001944:	6c02                	ld	s8,0(sp)
    80001946:	6161                	addi	sp,sp,80
    80001948:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000194a:	85e2                	mv	a1,s8
    8000194c:	854a                	mv	a0,s2
    8000194e:	00000097          	auipc	ra,0x0
    80001952:	c02080e7          	jalr	-1022(ra) # 80001550 <sleep>
    havekids = 0;
    80001956:	bf39                	j	80001874 <wait+0x4a>

0000000080001958 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	84aa                	mv	s1,a0
    8000196a:	892e                	mv	s2,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	534080e7          	jalr	1332(ra) # 80000ea4 <myproc>
  if(user_dst){
    80001978:	c08d                	beqz	s1,8000199a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	1e0080e7          	jalr	480(ra) # 80000b62 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove((char *)dst, src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	882080e7          	jalr	-1918(ra) # 80000224 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyout+0x32>

00000000800019ae <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ae:	7179                	addi	sp,sp,-48
    800019b0:	f406                	sd	ra,40(sp)
    800019b2:	f022                	sd	s0,32(sp)
    800019b4:	ec26                	sd	s1,24(sp)
    800019b6:	e84a                	sd	s2,16(sp)
    800019b8:	e44e                	sd	s3,8(sp)
    800019ba:	e052                	sd	s4,0(sp)
    800019bc:	1800                	addi	s0,sp,48
    800019be:	892a                	mv	s2,a0
    800019c0:	84ae                	mv	s1,a1
    800019c2:	89b2                	mv	s3,a2
    800019c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	4de080e7          	jalr	1246(ra) # 80000ea4 <myproc>
  if(user_src){
    800019ce:	c08d                	beqz	s1,800019f0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d0:	86d2                	mv	a3,s4
    800019d2:	864e                	mv	a2,s3
    800019d4:	85ca                	mv	a1,s2
    800019d6:	6928                	ld	a0,80(a0)
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	216080e7          	jalr	534(ra) # 80000bee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e0:	70a2                	ld	ra,40(sp)
    800019e2:	7402                	ld	s0,32(sp)
    800019e4:	64e2                	ld	s1,24(sp)
    800019e6:	6942                	ld	s2,16(sp)
    800019e8:	69a2                	ld	s3,8(sp)
    800019ea:	6a02                	ld	s4,0(sp)
    800019ec:	6145                	addi	sp,sp,48
    800019ee:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f0:	000a061b          	sext.w	a2,s4
    800019f4:	85ce                	mv	a1,s3
    800019f6:	854a                	mv	a0,s2
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	82c080e7          	jalr	-2004(ra) # 80000224 <memmove>
    return 0;
    80001a00:	8526                	mv	a0,s1
    80001a02:	bff9                	j	800019e0 <either_copyin+0x32>

0000000080001a04 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a04:	715d                	addi	sp,sp,-80
    80001a06:	e486                	sd	ra,72(sp)
    80001a08:	e0a2                	sd	s0,64(sp)
    80001a0a:	fc26                	sd	s1,56(sp)
    80001a0c:	f84a                	sd	s2,48(sp)
    80001a0e:	f44e                	sd	s3,40(sp)
    80001a10:	f052                	sd	s4,32(sp)
    80001a12:	ec56                	sd	s5,24(sp)
    80001a14:	e85a                	sd	s6,16(sp)
    80001a16:	e45e                	sd	s7,8(sp)
    80001a18:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1a:	00006517          	auipc	a0,0x6
    80001a1e:	62e50513          	addi	a0,a0,1582 # 80008048 <etext+0x48>
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	35a080e7          	jalr	858(ra) # 80005d7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2a:	00007497          	auipc	s1,0x7
    80001a2e:	5ae48493          	addi	s1,s1,1454 # 80008fd8 <proc+0x158>
    80001a32:	0000d917          	auipc	s2,0xd
    80001a36:	1a690913          	addi	s2,s2,422 # 8000ebd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a3c:	00006997          	auipc	s3,0x6
    80001a40:	7c498993          	addi	s3,s3,1988 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a44:	00006a97          	auipc	s5,0x6
    80001a48:	7c4a8a93          	addi	s5,s5,1988 # 80008208 <etext+0x208>
    printf("\n");
    80001a4c:	00006a17          	auipc	s4,0x6
    80001a50:	5fca0a13          	addi	s4,s4,1532 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a54:	00006b97          	auipc	s7,0x6
    80001a58:	7f4b8b93          	addi	s7,s7,2036 # 80008248 <states.1723>
    80001a5c:	a00d                	j	80001a7e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a5e:	ed86a583          	lw	a1,-296(a3)
    80001a62:	8556                	mv	a0,s5
    80001a64:	00004097          	auipc	ra,0x4
    80001a68:	318080e7          	jalr	792(ra) # 80005d7c <printf>
    printf("\n");
    80001a6c:	8552                	mv	a0,s4
    80001a6e:	00004097          	auipc	ra,0x4
    80001a72:	30e080e7          	jalr	782(ra) # 80005d7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a76:	17048493          	addi	s1,s1,368
    80001a7a:	03248163          	beq	s1,s2,80001a9c <procdump+0x98>
    if(p->state == UNUSED)
    80001a7e:	86a6                	mv	a3,s1
    80001a80:	ec04a783          	lw	a5,-320(s1)
    80001a84:	dbed                	beqz	a5,80001a76 <procdump+0x72>
      state = "???";
    80001a86:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	fcfb6be3          	bltu	s6,a5,80001a5e <procdump+0x5a>
    80001a8c:	1782                	slli	a5,a5,0x20
    80001a8e:	9381                	srli	a5,a5,0x20
    80001a90:	078e                	slli	a5,a5,0x3
    80001a92:	97de                	add	a5,a5,s7
    80001a94:	6390                	ld	a2,0(a5)
    80001a96:	f661                	bnez	a2,80001a5e <procdump+0x5a>
      state = "???";
    80001a98:	864e                	mv	a2,s3
    80001a9a:	b7d1                	j	80001a5e <procdump+0x5a>
  }
}
    80001a9c:	60a6                	ld	ra,72(sp)
    80001a9e:	6406                	ld	s0,64(sp)
    80001aa0:	74e2                	ld	s1,56(sp)
    80001aa2:	7942                	ld	s2,48(sp)
    80001aa4:	79a2                	ld	s3,40(sp)
    80001aa6:	7a02                	ld	s4,32(sp)
    80001aa8:	6ae2                	ld	s5,24(sp)
    80001aaa:	6b42                	ld	s6,16(sp)
    80001aac:	6ba2                	ld	s7,8(sp)
    80001aae:	6161                	addi	sp,sp,80
    80001ab0:	8082                	ret

0000000080001ab2 <getnproc>:

uint64 getnproc(void){
    80001ab2:	1141                	addi	sp,sp,-16
    80001ab4:	e422                	sd	s0,8(sp)
    80001ab6:	0800                	addi	s0,sp,16
  uint count = 0;
  for(int i = 0; i < NPROC; i++){
    80001ab8:	00007797          	auipc	a5,0x7
    80001abc:	3e078793          	addi	a5,a5,992 # 80008e98 <proc+0x18>
    80001ac0:	0000d697          	auipc	a3,0xd
    80001ac4:	fd868693          	addi	a3,a3,-40 # 8000ea98 <bcache>
  uint count = 0;
    80001ac8:	4501                	li	a0,0
    80001aca:	a029                	j	80001ad4 <getnproc+0x22>
  for(int i = 0; i < NPROC; i++){
    80001acc:	17078793          	addi	a5,a5,368
    80001ad0:	00d78663          	beq	a5,a3,80001adc <getnproc+0x2a>
    if(proc[i].state != UNUSED){
    80001ad4:	4398                	lw	a4,0(a5)
    80001ad6:	db7d                	beqz	a4,80001acc <getnproc+0x1a>
      count++;
    80001ad8:	2505                	addiw	a0,a0,1
    80001ada:	bfcd                	j	80001acc <getnproc+0x1a>
    }
  }
  return count;
    80001adc:	1502                	slli	a0,a0,0x20
    80001ade:	9101                	srli	a0,a0,0x20
    80001ae0:	6422                	ld	s0,8(sp)
    80001ae2:	0141                	addi	sp,sp,16
    80001ae4:	8082                	ret

0000000080001ae6 <swtch>:
    80001ae6:	00153023          	sd	ra,0(a0)
    80001aea:	00253423          	sd	sp,8(a0)
    80001aee:	e900                	sd	s0,16(a0)
    80001af0:	ed04                	sd	s1,24(a0)
    80001af2:	03253023          	sd	s2,32(a0)
    80001af6:	03353423          	sd	s3,40(a0)
    80001afa:	03453823          	sd	s4,48(a0)
    80001afe:	03553c23          	sd	s5,56(a0)
    80001b02:	05653023          	sd	s6,64(a0)
    80001b06:	05753423          	sd	s7,72(a0)
    80001b0a:	05853823          	sd	s8,80(a0)
    80001b0e:	05953c23          	sd	s9,88(a0)
    80001b12:	07a53023          	sd	s10,96(a0)
    80001b16:	07b53423          	sd	s11,104(a0)
    80001b1a:	0005b083          	ld	ra,0(a1)
    80001b1e:	0085b103          	ld	sp,8(a1)
    80001b22:	6980                	ld	s0,16(a1)
    80001b24:	6d84                	ld	s1,24(a1)
    80001b26:	0205b903          	ld	s2,32(a1)
    80001b2a:	0285b983          	ld	s3,40(a1)
    80001b2e:	0305ba03          	ld	s4,48(a1)
    80001b32:	0385ba83          	ld	s5,56(a1)
    80001b36:	0405bb03          	ld	s6,64(a1)
    80001b3a:	0485bb83          	ld	s7,72(a1)
    80001b3e:	0505bc03          	ld	s8,80(a1)
    80001b42:	0585bc83          	ld	s9,88(a1)
    80001b46:	0605bd03          	ld	s10,96(a1)
    80001b4a:	0685bd83          	ld	s11,104(a1)
    80001b4e:	8082                	ret

0000000080001b50 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b50:	1141                	addi	sp,sp,-16
    80001b52:	e406                	sd	ra,8(sp)
    80001b54:	e022                	sd	s0,0(sp)
    80001b56:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b58:	00006597          	auipc	a1,0x6
    80001b5c:	72058593          	addi	a1,a1,1824 # 80008278 <states.1723+0x30>
    80001b60:	0000d517          	auipc	a0,0xd
    80001b64:	f2050513          	addi	a0,a0,-224 # 8000ea80 <tickslock>
    80001b68:	00004097          	auipc	ra,0x4
    80001b6c:	684080e7          	jalr	1668(ra) # 800061ec <initlock>
}
    80001b70:	60a2                	ld	ra,8(sp)
    80001b72:	6402                	ld	s0,0(sp)
    80001b74:	0141                	addi	sp,sp,16
    80001b76:	8082                	ret

0000000080001b78 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b78:	1141                	addi	sp,sp,-16
    80001b7a:	e422                	sd	s0,8(sp)
    80001b7c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7e:	00003797          	auipc	a5,0x3
    80001b82:	58278793          	addi	a5,a5,1410 # 80005100 <kernelvec>
    80001b86:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b8a:	6422                	ld	s0,8(sp)
    80001b8c:	0141                	addi	sp,sp,16
    80001b8e:	8082                	ret

0000000080001b90 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b90:	1141                	addi	sp,sp,-16
    80001b92:	e406                	sd	ra,8(sp)
    80001b94:	e022                	sd	s0,0(sp)
    80001b96:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	30c080e7          	jalr	780(ra) # 80000ea4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001baa:	00005617          	auipc	a2,0x5
    80001bae:	45660613          	addi	a2,a2,1110 # 80007000 <_trampoline>
    80001bb2:	00005697          	auipc	a3,0x5
    80001bb6:	44e68693          	addi	a3,a3,1102 # 80007000 <_trampoline>
    80001bba:	8e91                	sub	a3,a3,a2
    80001bbc:	040007b7          	lui	a5,0x4000
    80001bc0:	17fd                	addi	a5,a5,-1
    80001bc2:	07b2                	slli	a5,a5,0xc
    80001bc4:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc6:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bca:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bcc:	180026f3          	csrr	a3,satp
    80001bd0:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd2:	6d38                	ld	a4,88(a0)
    80001bd4:	6134                	ld	a3,64(a0)
    80001bd6:	6585                	lui	a1,0x1
    80001bd8:	96ae                	add	a3,a3,a1
    80001bda:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bdc:	6d38                	ld	a4,88(a0)
    80001bde:	00000697          	auipc	a3,0x0
    80001be2:	13068693          	addi	a3,a3,304 # 80001d0e <usertrap>
    80001be6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001be8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bea:	8692                	mv	a3,tp
    80001bec:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bee:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfa:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bfe:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c00:	6f18                	ld	a4,24(a4)
    80001c02:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c06:	6928                	ld	a0,80(a0)
    80001c08:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c0a:	00005717          	auipc	a4,0x5
    80001c0e:	49270713          	addi	a4,a4,1170 # 8000709c <userret>
    80001c12:	8f11                	sub	a4,a4,a2
    80001c14:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c16:	577d                	li	a4,-1
    80001c18:	177e                	slli	a4,a4,0x3f
    80001c1a:	8d59                	or	a0,a0,a4
    80001c1c:	9782                	jalr	a5
}
    80001c1e:	60a2                	ld	ra,8(sp)
    80001c20:	6402                	ld	s0,0(sp)
    80001c22:	0141                	addi	sp,sp,16
    80001c24:	8082                	ret

0000000080001c26 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c26:	1101                	addi	sp,sp,-32
    80001c28:	ec06                	sd	ra,24(sp)
    80001c2a:	e822                	sd	s0,16(sp)
    80001c2c:	e426                	sd	s1,8(sp)
    80001c2e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c30:	0000d497          	auipc	s1,0xd
    80001c34:	e5048493          	addi	s1,s1,-432 # 8000ea80 <tickslock>
    80001c38:	8526                	mv	a0,s1
    80001c3a:	00004097          	auipc	ra,0x4
    80001c3e:	642080e7          	jalr	1602(ra) # 8000627c <acquire>
  ticks++;
    80001c42:	00007517          	auipc	a0,0x7
    80001c46:	dc650513          	addi	a0,a0,-570 # 80008a08 <ticks>
    80001c4a:	411c                	lw	a5,0(a0)
    80001c4c:	2785                	addiw	a5,a5,1
    80001c4e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c50:	00000097          	auipc	ra,0x0
    80001c54:	964080e7          	jalr	-1692(ra) # 800015b4 <wakeup>
  release(&tickslock);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	6d6080e7          	jalr	1750(ra) # 80006330 <release>
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6105                	addi	sp,sp,32
    80001c6a:	8082                	ret

0000000080001c6c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c76:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c7a:	00074d63          	bltz	a4,80001c94 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c7e:	57fd                	li	a5,-1
    80001c80:	17fe                	slli	a5,a5,0x3f
    80001c82:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c84:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c86:	06f70363          	beq	a4,a5,80001cec <devintr+0x80>
  }
}
    80001c8a:	60e2                	ld	ra,24(sp)
    80001c8c:	6442                	ld	s0,16(sp)
    80001c8e:	64a2                	ld	s1,8(sp)
    80001c90:	6105                	addi	sp,sp,32
    80001c92:	8082                	ret
     (scause & 0xff) == 9){
    80001c94:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c98:	46a5                	li	a3,9
    80001c9a:	fed792e3          	bne	a5,a3,80001c7e <devintr+0x12>
    int irq = plic_claim();
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	56a080e7          	jalr	1386(ra) # 80005208 <plic_claim>
    80001ca6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ca8:	47a9                	li	a5,10
    80001caa:	02f50763          	beq	a0,a5,80001cd8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cae:	4785                	li	a5,1
    80001cb0:	02f50963          	beq	a0,a5,80001ce2 <devintr+0x76>
    return 1;
    80001cb4:	4505                	li	a0,1
    } else if(irq){
    80001cb6:	d8f1                	beqz	s1,80001c8a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	5c650513          	addi	a0,a0,1478 # 80008280 <states.1723+0x38>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	0ba080e7          	jalr	186(ra) # 80005d7c <printf>
      plic_complete(irq);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00003097          	auipc	ra,0x3
    80001cd0:	560080e7          	jalr	1376(ra) # 8000522c <plic_complete>
    return 1;
    80001cd4:	4505                	li	a0,1
    80001cd6:	bf55                	j	80001c8a <devintr+0x1e>
      uartintr();
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	4c4080e7          	jalr	1220(ra) # 8000619c <uartintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0x5e>
      virtio_disk_intr();
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	a74080e7          	jalr	-1420(ra) # 80005756 <virtio_disk_intr>
    80001cea:	b7c5                	j	80001cca <devintr+0x5e>
    if(cpuid() == 0){
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	18c080e7          	jalr	396(ra) # 80000e78 <cpuid>
    80001cf4:	c901                	beqz	a0,80001d04 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cf6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cfa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cfc:	14479073          	csrw	sip,a5
    return 2;
    80001d00:	4509                	li	a0,2
    80001d02:	b761                	j	80001c8a <devintr+0x1e>
      clockintr();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f22080e7          	jalr	-222(ra) # 80001c26 <clockintr>
    80001d0c:	b7ed                	j	80001cf6 <devintr+0x8a>

0000000080001d0e <usertrap>:
{
    80001d0e:	1101                	addi	sp,sp,-32
    80001d10:	ec06                	sd	ra,24(sp)
    80001d12:	e822                	sd	s0,16(sp)
    80001d14:	e426                	sd	s1,8(sp)
    80001d16:	e04a                	sd	s2,0(sp)
    80001d18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d1e:	1007f793          	andi	a5,a5,256
    80001d22:	e3b1                	bnez	a5,80001d66 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d24:	00003797          	auipc	a5,0x3
    80001d28:	3dc78793          	addi	a5,a5,988 # 80005100 <kernelvec>
    80001d2c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	174080e7          	jalr	372(ra) # 80000ea4 <myproc>
    80001d38:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d3a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3c:	14102773          	csrr	a4,sepc
    80001d40:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d42:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d46:	47a1                	li	a5,8
    80001d48:	02f70763          	beq	a4,a5,80001d76 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	f20080e7          	jalr	-224(ra) # 80001c6c <devintr>
    80001d54:	892a                	mv	s2,a0
    80001d56:	c151                	beqz	a0,80001dda <usertrap+0xcc>
  if(killed(p))
    80001d58:	8526                	mv	a0,s1
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	a9e080e7          	jalr	-1378(ra) # 800017f8 <killed>
    80001d62:	c929                	beqz	a0,80001db4 <usertrap+0xa6>
    80001d64:	a099                	j	80001daa <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d66:	00006517          	auipc	a0,0x6
    80001d6a:	53a50513          	addi	a0,a0,1338 # 800082a0 <states.1723+0x58>
    80001d6e:	00004097          	auipc	ra,0x4
    80001d72:	fc4080e7          	jalr	-60(ra) # 80005d32 <panic>
    if(killed(p))
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	a82080e7          	jalr	-1406(ra) # 800017f8 <killed>
    80001d7e:	e921                	bnez	a0,80001dce <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d80:	6cb8                	ld	a4,88(s1)
    80001d82:	6f1c                	ld	a5,24(a4)
    80001d84:	0791                	addi	a5,a5,4
    80001d86:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d8c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d90:	10079073          	csrw	sstatus,a5
    syscall();
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	2d4080e7          	jalr	724(ra) # 80002068 <syscall>
  if(killed(p))
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	a5a080e7          	jalr	-1446(ra) # 800017f8 <killed>
    80001da6:	c911                	beqz	a0,80001dba <usertrap+0xac>
    80001da8:	4901                	li	s2,0
    exit(-1);
    80001daa:	557d                	li	a0,-1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	8d8080e7          	jalr	-1832(ra) # 80001684 <exit>
  if(which_dev == 2)
    80001db4:	4789                	li	a5,2
    80001db6:	04f90f63          	beq	s2,a5,80001e14 <usertrap+0x106>
  usertrapret();
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	dd6080e7          	jalr	-554(ra) # 80001b90 <usertrapret>
}
    80001dc2:	60e2                	ld	ra,24(sp)
    80001dc4:	6442                	ld	s0,16(sp)
    80001dc6:	64a2                	ld	s1,8(sp)
    80001dc8:	6902                	ld	s2,0(sp)
    80001dca:	6105                	addi	sp,sp,32
    80001dcc:	8082                	ret
      exit(-1);
    80001dce:	557d                	li	a0,-1
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	8b4080e7          	jalr	-1868(ra) # 80001684 <exit>
    80001dd8:	b765                	j	80001d80 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dda:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dde:	5890                	lw	a2,48(s1)
    80001de0:	00006517          	auipc	a0,0x6
    80001de4:	4e050513          	addi	a0,a0,1248 # 800082c0 <states.1723+0x78>
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	f94080e7          	jalr	-108(ra) # 80005d7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	4f850513          	addi	a0,a0,1272 # 800082f0 <states.1723+0xa8>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	f7c080e7          	jalr	-132(ra) # 80005d7c <printf>
    setkilled(p);
    80001e08:	8526                	mv	a0,s1
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	9c2080e7          	jalr	-1598(ra) # 800017cc <setkilled>
    80001e12:	b769                	j	80001d9c <usertrap+0x8e>
    yield();
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	700080e7          	jalr	1792(ra) # 80001514 <yield>
    80001e1c:	bf79                	j	80001dba <usertrap+0xac>

0000000080001e1e <kerneltrap>:
{
    80001e1e:	7179                	addi	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	e84a                	sd	s2,16(sp)
    80001e28:	e44e                	sd	s3,8(sp)
    80001e2a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e30:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e34:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e38:	1004f793          	andi	a5,s1,256
    80001e3c:	cb85                	beqz	a5,80001e6c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e42:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e44:	ef85                	bnez	a5,80001e7c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	e26080e7          	jalr	-474(ra) # 80001c6c <devintr>
    80001e4e:	cd1d                	beqz	a0,80001e8c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e50:	4789                	li	a5,2
    80001e52:	06f50a63          	beq	a0,a5,80001ec6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e56:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5a:	10049073          	csrw	sstatus,s1
}
    80001e5e:	70a2                	ld	ra,40(sp)
    80001e60:	7402                	ld	s0,32(sp)
    80001e62:	64e2                	ld	s1,24(sp)
    80001e64:	6942                	ld	s2,16(sp)
    80001e66:	69a2                	ld	s3,8(sp)
    80001e68:	6145                	addi	sp,sp,48
    80001e6a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	4a450513          	addi	a0,a0,1188 # 80008310 <states.1723+0xc8>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	ebe080e7          	jalr	-322(ra) # 80005d32 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e7c:	00006517          	auipc	a0,0x6
    80001e80:	4bc50513          	addi	a0,a0,1212 # 80008338 <states.1723+0xf0>
    80001e84:	00004097          	auipc	ra,0x4
    80001e88:	eae080e7          	jalr	-338(ra) # 80005d32 <panic>
    printf("scause %p\n", scause);
    80001e8c:	85ce                	mv	a1,s3
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	4ca50513          	addi	a0,a0,1226 # 80008358 <states.1723+0x110>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	ee6080e7          	jalr	-282(ra) # 80005d7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ea2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea6:	00006517          	auipc	a0,0x6
    80001eaa:	4c250513          	addi	a0,a0,1218 # 80008368 <states.1723+0x120>
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	ece080e7          	jalr	-306(ra) # 80005d7c <printf>
    panic("kerneltrap");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	4ca50513          	addi	a0,a0,1226 # 80008380 <states.1723+0x138>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	e74080e7          	jalr	-396(ra) # 80005d32 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	fde080e7          	jalr	-34(ra) # 80000ea4 <myproc>
    80001ece:	d541                	beqz	a0,80001e56 <kerneltrap+0x38>
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	fd4080e7          	jalr	-44(ra) # 80000ea4 <myproc>
    80001ed8:	4d18                	lw	a4,24(a0)
    80001eda:	4791                	li	a5,4
    80001edc:	f6f71de3          	bne	a4,a5,80001e56 <kerneltrap+0x38>
    yield();
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	634080e7          	jalr	1588(ra) # 80001514 <yield>
    80001ee8:	b7bd                	j	80001e56 <kerneltrap+0x38>

0000000080001eea <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	e426                	sd	s1,8(sp)
    80001ef2:	1000                	addi	s0,sp,32
    80001ef4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	fae080e7          	jalr	-82(ra) # 80000ea4 <myproc>
  switch (n) {
    80001efe:	4795                	li	a5,5
    80001f00:	0497e163          	bltu	a5,s1,80001f42 <argraw+0x58>
    80001f04:	048a                	slli	s1,s1,0x2
    80001f06:	00006717          	auipc	a4,0x6
    80001f0a:	4ca70713          	addi	a4,a4,1226 # 800083d0 <states.1723+0x188>
    80001f0e:	94ba                	add	s1,s1,a4
    80001f10:	409c                	lw	a5,0(s1)
    80001f12:	97ba                	add	a5,a5,a4
    80001f14:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f16:	6d3c                	ld	a5,88(a0)
    80001f18:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f1a:	60e2                	ld	ra,24(sp)
    80001f1c:	6442                	ld	s0,16(sp)
    80001f1e:	64a2                	ld	s1,8(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret
    return p->trapframe->a1;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	7fa8                	ld	a0,120(a5)
    80001f28:	bfcd                	j	80001f1a <argraw+0x30>
    return p->trapframe->a2;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	63c8                	ld	a0,128(a5)
    80001f2e:	b7f5                	j	80001f1a <argraw+0x30>
    return p->trapframe->a3;
    80001f30:	6d3c                	ld	a5,88(a0)
    80001f32:	67c8                	ld	a0,136(a5)
    80001f34:	b7dd                	j	80001f1a <argraw+0x30>
    return p->trapframe->a4;
    80001f36:	6d3c                	ld	a5,88(a0)
    80001f38:	6bc8                	ld	a0,144(a5)
    80001f3a:	b7c5                	j	80001f1a <argraw+0x30>
    return p->trapframe->a5;
    80001f3c:	6d3c                	ld	a5,88(a0)
    80001f3e:	6fc8                	ld	a0,152(a5)
    80001f40:	bfe9                	j	80001f1a <argraw+0x30>
  panic("argraw");
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	44e50513          	addi	a0,a0,1102 # 80008390 <states.1723+0x148>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	de8080e7          	jalr	-536(ra) # 80005d32 <panic>

0000000080001f52 <fetchaddr>:
{
    80001f52:	1101                	addi	sp,sp,-32
    80001f54:	ec06                	sd	ra,24(sp)
    80001f56:	e822                	sd	s0,16(sp)
    80001f58:	e426                	sd	s1,8(sp)
    80001f5a:	e04a                	sd	s2,0(sp)
    80001f5c:	1000                	addi	s0,sp,32
    80001f5e:	84aa                	mv	s1,a0
    80001f60:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	f42080e7          	jalr	-190(ra) # 80000ea4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f6a:	653c                	ld	a5,72(a0)
    80001f6c:	02f4f863          	bgeu	s1,a5,80001f9c <fetchaddr+0x4a>
    80001f70:	00848713          	addi	a4,s1,8
    80001f74:	02e7e663          	bltu	a5,a4,80001fa0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f78:	46a1                	li	a3,8
    80001f7a:	8626                	mv	a2,s1
    80001f7c:	85ca                	mv	a1,s2
    80001f7e:	6928                	ld	a0,80(a0)
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	c6e080e7          	jalr	-914(ra) # 80000bee <copyin>
    80001f88:	00a03533          	snez	a0,a0
    80001f8c:	40a00533          	neg	a0,a0
}
    80001f90:	60e2                	ld	ra,24(sp)
    80001f92:	6442                	ld	s0,16(sp)
    80001f94:	64a2                	ld	s1,8(sp)
    80001f96:	6902                	ld	s2,0(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret
    return -1;
    80001f9c:	557d                	li	a0,-1
    80001f9e:	bfcd                	j	80001f90 <fetchaddr+0x3e>
    80001fa0:	557d                	li	a0,-1
    80001fa2:	b7fd                	j	80001f90 <fetchaddr+0x3e>

0000000080001fa4 <fetchstr>:
{
    80001fa4:	7179                	addi	sp,sp,-48
    80001fa6:	f406                	sd	ra,40(sp)
    80001fa8:	f022                	sd	s0,32(sp)
    80001faa:	ec26                	sd	s1,24(sp)
    80001fac:	e84a                	sd	s2,16(sp)
    80001fae:	e44e                	sd	s3,8(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	892a                	mv	s2,a0
    80001fb4:	84ae                	mv	s1,a1
    80001fb6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	eec080e7          	jalr	-276(ra) # 80000ea4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fc0:	86ce                	mv	a3,s3
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	6928                	ld	a0,80(a0)
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	cb2080e7          	jalr	-846(ra) # 80000c7a <copyinstr>
    80001fd0:	00054e63          	bltz	a0,80001fec <fetchstr+0x48>
  return strlen(buf);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	ffffe097          	auipc	ra,0xffffe
    80001fda:	372080e7          	jalr	882(ra) # 80000348 <strlen>
}
    80001fde:	70a2                	ld	ra,40(sp)
    80001fe0:	7402                	ld	s0,32(sp)
    80001fe2:	64e2                	ld	s1,24(sp)
    80001fe4:	6942                	ld	s2,16(sp)
    80001fe6:	69a2                	ld	s3,8(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret
    return -1;
    80001fec:	557d                	li	a0,-1
    80001fee:	bfc5                	j	80001fde <fetchstr+0x3a>

0000000080001ff0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	eee080e7          	jalr	-274(ra) # 80001eea <argraw>
    80002004:	c088                	sw	a0,0(s1)
}
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	64a2                	ld	s1,8(sp)
    8000200c:	6105                	addi	sp,sp,32
    8000200e:	8082                	ret

0000000080002010 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	addi	s0,sp,32
    8000201a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	ece080e7          	jalr	-306(ra) # 80001eea <argraw>
    80002024:	e088                	sd	a0,0(s1)
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002030:	7179                	addi	sp,sp,-48
    80002032:	f406                	sd	ra,40(sp)
    80002034:	f022                	sd	s0,32(sp)
    80002036:	ec26                	sd	s1,24(sp)
    80002038:	e84a                	sd	s2,16(sp)
    8000203a:	1800                	addi	s0,sp,48
    8000203c:	84ae                	mv	s1,a1
    8000203e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002040:	fd840593          	addi	a1,s0,-40
    80002044:	00000097          	auipc	ra,0x0
    80002048:	fcc080e7          	jalr	-52(ra) # 80002010 <argaddr>
  return fetchstr(addr, buf, max);
    8000204c:	864a                	mv	a2,s2
    8000204e:	85a6                	mv	a1,s1
    80002050:	fd843503          	ld	a0,-40(s0)
    80002054:	00000097          	auipc	ra,0x0
    80002058:	f50080e7          	jalr	-176(ra) # 80001fa4 <fetchstr>
}
    8000205c:	70a2                	ld	ra,40(sp)
    8000205e:	7402                	ld	s0,32(sp)
    80002060:	64e2                	ld	s1,24(sp)
    80002062:	6942                	ld	s2,16(sp)
    80002064:	6145                	addi	sp,sp,48
    80002066:	8082                	ret

0000000080002068 <syscall>:
  "trace",
};

void
syscall(void)
{
    80002068:	7179                	addi	sp,sp,-48
    8000206a:	f406                	sd	ra,40(sp)
    8000206c:	f022                	sd	s0,32(sp)
    8000206e:	ec26                	sd	s1,24(sp)
    80002070:	e84a                	sd	s2,16(sp)
    80002072:	e44e                	sd	s3,8(sp)
    80002074:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	e2e080e7          	jalr	-466(ra) # 80000ea4 <myproc>
    8000207e:	84aa                	mv	s1,a0

  //num = * (int *) 0; 
  num = p->trapframe->a7;
    80002080:	05853903          	ld	s2,88(a0)
    80002084:	0a893783          	ld	a5,168(s2)
    80002088:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000208c:	37fd                	addiw	a5,a5,-1
    8000208e:	4759                	li	a4,22
    80002090:	04f76a63          	bltu	a4,a5,800020e4 <syscall+0x7c>
    80002094:	00399713          	slli	a4,s3,0x3
    80002098:	00006797          	auipc	a5,0x6
    8000209c:	35078793          	addi	a5,a5,848 # 800083e8 <syscalls>
    800020a0:	97ba                	add	a5,a5,a4
    800020a2:	639c                	ld	a5,0(a5)
    800020a4:	c3a1                	beqz	a5,800020e4 <syscall+0x7c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020a6:	9782                	jalr	a5
    800020a8:	06a93823          	sd	a0,112(s2)
    if(p -> mask & (1 << num)) printf("%d: syscall %s -> %d\n", p -> pid, name[num], p->trapframe->a0);
    800020ac:	4785                	li	a5,1
    800020ae:	013797bb          	sllw	a5,a5,s3
    800020b2:	1684b703          	ld	a4,360(s1)
    800020b6:	8ff9                	and	a5,a5,a4
    800020b8:	c7a9                	beqz	a5,80002102 <syscall+0x9a>
    800020ba:	6cbc                	ld	a5,88(s1)
    800020bc:	00299613          	slli	a2,s3,0x2
    800020c0:	99b2                	add	s3,s3,a2
    800020c2:	0986                	slli	s3,s3,0x1
    800020c4:	7bb4                	ld	a3,112(a5)
    800020c6:	00006617          	auipc	a2,0x6
    800020ca:	7f260613          	addi	a2,a2,2034 # 800088b8 <name>
    800020ce:	964e                	add	a2,a2,s3
    800020d0:	588c                	lw	a1,48(s1)
    800020d2:	00006517          	auipc	a0,0x6
    800020d6:	2c650513          	addi	a0,a0,710 # 80008398 <states.1723+0x150>
    800020da:	00004097          	auipc	ra,0x4
    800020de:	ca2080e7          	jalr	-862(ra) # 80005d7c <printf>
    800020e2:	a005                	j	80002102 <syscall+0x9a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020e4:	86ce                	mv	a3,s3
    800020e6:	15848613          	addi	a2,s1,344
    800020ea:	588c                	lw	a1,48(s1)
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	2c450513          	addi	a0,a0,708 # 800083b0 <states.1723+0x168>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	c88080e7          	jalr	-888(ra) # 80005d7c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020fc:	6cbc                	ld	a5,88(s1)
    800020fe:	577d                	li	a4,-1
    80002100:	fbb8                	sd	a4,112(a5)
  }
}
    80002102:	70a2                	ld	ra,40(sp)
    80002104:	7402                	ld	s0,32(sp)
    80002106:	64e2                	ld	s1,24(sp)
    80002108:	6942                	ld	s2,16(sp)
    8000210a:	69a2                	ld	s3,8(sp)
    8000210c:	6145                	addi	sp,sp,48
    8000210e:	8082                	ret

0000000080002110 <sys_exit>:
extern uint64 getfreemem(void);
extern uint64 getnproc(void);

uint64
sys_exit(void)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002118:	fec40593          	addi	a1,s0,-20
    8000211c:	4501                	li	a0,0
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	ed2080e7          	jalr	-302(ra) # 80001ff0 <argint>
  exit(n);
    80002126:	fec42503          	lw	a0,-20(s0)
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	55a080e7          	jalr	1370(ra) # 80001684 <exit>
  return 0;  // not reached
}
    80002132:	4501                	li	a0,0
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000213c:	1141                	addi	sp,sp,-16
    8000213e:	e406                	sd	ra,8(sp)
    80002140:	e022                	sd	s0,0(sp)
    80002142:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	d60080e7          	jalr	-672(ra) # 80000ea4 <myproc>
}
    8000214c:	5908                	lw	a0,48(a0)
    8000214e:	60a2                	ld	ra,8(sp)
    80002150:	6402                	ld	s0,0(sp)
    80002152:	0141                	addi	sp,sp,16
    80002154:	8082                	ret

0000000080002156 <sys_fork>:

uint64
sys_fork(void)
{
    80002156:	1141                	addi	sp,sp,-16
    80002158:	e406                	sd	ra,8(sp)
    8000215a:	e022                	sd	s0,0(sp)
    8000215c:	0800                	addi	s0,sp,16
  return fork();
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	0fc080e7          	jalr	252(ra) # 8000125a <fork>
}
    80002166:	60a2                	ld	ra,8(sp)
    80002168:	6402                	ld	s0,0(sp)
    8000216a:	0141                	addi	sp,sp,16
    8000216c:	8082                	ret

000000008000216e <sys_wait>:

uint64
sys_wait(void)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002176:	fe840593          	addi	a1,s0,-24
    8000217a:	4501                	li	a0,0
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	e94080e7          	jalr	-364(ra) # 80002010 <argaddr>
  return wait(p);
    80002184:	fe843503          	ld	a0,-24(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	6a2080e7          	jalr	1698(ra) # 8000182a <wait>
}
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002198:	7179                	addi	sp,sp,-48
    8000219a:	f406                	sd	ra,40(sp)
    8000219c:	f022                	sd	s0,32(sp)
    8000219e:	ec26                	sd	s1,24(sp)
    800021a0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021a2:	fdc40593          	addi	a1,s0,-36
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	e48080e7          	jalr	-440(ra) # 80001ff0 <argint>
  addr = myproc()->sz;
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	cf4080e7          	jalr	-780(ra) # 80000ea4 <myproc>
    800021b8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021ba:	fdc42503          	lw	a0,-36(s0)
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	040080e7          	jalr	64(ra) # 800011fe <growproc>
    800021c6:	00054863          	bltz	a0,800021d6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021ca:	8526                	mv	a0,s1
    800021cc:	70a2                	ld	ra,40(sp)
    800021ce:	7402                	ld	s0,32(sp)
    800021d0:	64e2                	ld	s1,24(sp)
    800021d2:	6145                	addi	sp,sp,48
    800021d4:	8082                	ret
    return -1;
    800021d6:	54fd                	li	s1,-1
    800021d8:	bfcd                	j	800021ca <sys_sbrk+0x32>

00000000800021da <sys_sleep>:

uint64
sys_sleep(void)
{
    800021da:	7139                	addi	sp,sp,-64
    800021dc:	fc06                	sd	ra,56(sp)
    800021de:	f822                	sd	s0,48(sp)
    800021e0:	f426                	sd	s1,40(sp)
    800021e2:	f04a                	sd	s2,32(sp)
    800021e4:	ec4e                	sd	s3,24(sp)
    800021e6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021e8:	fcc40593          	addi	a1,s0,-52
    800021ec:	4501                	li	a0,0
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	e02080e7          	jalr	-510(ra) # 80001ff0 <argint>
  if(n < 0)
    800021f6:	fcc42783          	lw	a5,-52(s0)
    800021fa:	0607cf63          	bltz	a5,80002278 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021fe:	0000d517          	auipc	a0,0xd
    80002202:	88250513          	addi	a0,a0,-1918 # 8000ea80 <tickslock>
    80002206:	00004097          	auipc	ra,0x4
    8000220a:	076080e7          	jalr	118(ra) # 8000627c <acquire>
  ticks0 = ticks;
    8000220e:	00006917          	auipc	s2,0x6
    80002212:	7fa92903          	lw	s2,2042(s2) # 80008a08 <ticks>
  while(ticks - ticks0 < n){
    80002216:	fcc42783          	lw	a5,-52(s0)
    8000221a:	cf9d                	beqz	a5,80002258 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000221c:	0000d997          	auipc	s3,0xd
    80002220:	86498993          	addi	s3,s3,-1948 # 8000ea80 <tickslock>
    80002224:	00006497          	auipc	s1,0x6
    80002228:	7e448493          	addi	s1,s1,2020 # 80008a08 <ticks>
    if(killed(myproc())){
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	c78080e7          	jalr	-904(ra) # 80000ea4 <myproc>
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	5c4080e7          	jalr	1476(ra) # 800017f8 <killed>
    8000223c:	e129                	bnez	a0,8000227e <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000223e:	85ce                	mv	a1,s3
    80002240:	8526                	mv	a0,s1
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	30e080e7          	jalr	782(ra) # 80001550 <sleep>
  while(ticks - ticks0 < n){
    8000224a:	409c                	lw	a5,0(s1)
    8000224c:	412787bb          	subw	a5,a5,s2
    80002250:	fcc42703          	lw	a4,-52(s0)
    80002254:	fce7ece3          	bltu	a5,a4,8000222c <sys_sleep+0x52>
  }
  release(&tickslock);
    80002258:	0000d517          	auipc	a0,0xd
    8000225c:	82850513          	addi	a0,a0,-2008 # 8000ea80 <tickslock>
    80002260:	00004097          	auipc	ra,0x4
    80002264:	0d0080e7          	jalr	208(ra) # 80006330 <release>
  return 0;
    80002268:	4501                	li	a0,0
}
    8000226a:	70e2                	ld	ra,56(sp)
    8000226c:	7442                	ld	s0,48(sp)
    8000226e:	74a2                	ld	s1,40(sp)
    80002270:	7902                	ld	s2,32(sp)
    80002272:	69e2                	ld	s3,24(sp)
    80002274:	6121                	addi	sp,sp,64
    80002276:	8082                	ret
    n = 0;
    80002278:	fc042623          	sw	zero,-52(s0)
    8000227c:	b749                	j	800021fe <sys_sleep+0x24>
      release(&tickslock);
    8000227e:	0000d517          	auipc	a0,0xd
    80002282:	80250513          	addi	a0,a0,-2046 # 8000ea80 <tickslock>
    80002286:	00004097          	auipc	ra,0x4
    8000228a:	0aa080e7          	jalr	170(ra) # 80006330 <release>
      return -1;
    8000228e:	557d                	li	a0,-1
    80002290:	bfe9                	j	8000226a <sys_sleep+0x90>

0000000080002292 <sys_kill>:

uint64
sys_kill(void)
{
    80002292:	1101                	addi	sp,sp,-32
    80002294:	ec06                	sd	ra,24(sp)
    80002296:	e822                	sd	s0,16(sp)
    80002298:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000229a:	fec40593          	addi	a1,s0,-20
    8000229e:	4501                	li	a0,0
    800022a0:	00000097          	auipc	ra,0x0
    800022a4:	d50080e7          	jalr	-688(ra) # 80001ff0 <argint>
  return kill(pid);
    800022a8:	fec42503          	lw	a0,-20(s0)
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	4ae080e7          	jalr	1198(ra) # 8000175a <kill>
}
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	e426                	sd	s1,8(sp)
    800022c4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c6:	0000c517          	auipc	a0,0xc
    800022ca:	7ba50513          	addi	a0,a0,1978 # 8000ea80 <tickslock>
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	fae080e7          	jalr	-82(ra) # 8000627c <acquire>
  xticks = ticks;
    800022d6:	00006497          	auipc	s1,0x6
    800022da:	7324a483          	lw	s1,1842(s1) # 80008a08 <ticks>
  release(&tickslock);
    800022de:	0000c517          	auipc	a0,0xc
    800022e2:	7a250513          	addi	a0,a0,1954 # 8000ea80 <tickslock>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	04a080e7          	jalr	74(ra) # 80006330 <release>
  return xticks;
}
    800022ee:	02049513          	slli	a0,s1,0x20
    800022f2:	9101                	srli	a0,a0,0x20
    800022f4:	60e2                	ld	ra,24(sp)
    800022f6:	6442                	ld	s0,16(sp)
    800022f8:	64a2                	ld	s1,8(sp)
    800022fa:	6105                	addi	sp,sp,32
    800022fc:	8082                	ret

00000000800022fe <sys_trace>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_trace(void)
{
    800022fe:	7179                	addi	sp,sp,-48
    80002300:	f406                	sd	ra,40(sp)
    80002302:	f022                	sd	s0,32(sp)
    80002304:	ec26                	sd	s1,24(sp)
    80002306:	1800                	addi	s0,sp,48
  int mask = 0;
    80002308:	fc042e23          	sw	zero,-36(s0)
  struct proc *p = myproc();
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	b98080e7          	jalr	-1128(ra) # 80000ea4 <myproc>
    80002314:	84aa                	mv	s1,a0
  argint(0, &mask);
    80002316:	fdc40593          	addi	a1,s0,-36
    8000231a:	4501                	li	a0,0
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	cd4080e7          	jalr	-812(ra) # 80001ff0 <argint>
  p -> mask = mask;
    80002324:	fdc42783          	lw	a5,-36(s0)
    80002328:	16f4b423          	sd	a5,360(s1)
  return 0;
}
    8000232c:	4501                	li	a0,0
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6145                	addi	sp,sp,48
    80002336:	8082                	ret

0000000080002338 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002338:	7139                	addi	sp,sp,-64
    8000233a:	fc06                	sd	ra,56(sp)
    8000233c:	f822                	sd	s0,48(sp)
    8000233e:	f426                	sd	s1,40(sp)
    80002340:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	b62080e7          	jalr	-1182(ra) # 80000ea4 <myproc>
    8000234a:	84aa                	mv	s1,a0
  struct sysinfo si;
  si.freemem = getfreemem();
    8000234c:	ffffe097          	auipc	ra,0xffffe
    80002350:	e2c080e7          	jalr	-468(ra) # 80000178 <getfreemem>
    80002354:	fca43823          	sd	a0,-48(s0)
  si.nproc = getnproc();
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	75a080e7          	jalr	1882(ra) # 80001ab2 <getnproc>
    80002360:	fca43c23          	sd	a0,-40(s0)
  uint64 addr;
  argaddr(0, &addr);
    80002364:	fc840593          	addi	a1,s0,-56
    80002368:	4501                	li	a0,0
    8000236a:	00000097          	auipc	ra,0x0
    8000236e:	ca6080e7          	jalr	-858(ra) # 80002010 <argaddr>
  if(copyout(p->pagetable, addr, (char *)&si, sizeof(si)) < 0)  return -1;
    80002372:	46c1                	li	a3,16
    80002374:	fd040613          	addi	a2,s0,-48
    80002378:	fc843583          	ld	a1,-56(s0)
    8000237c:	68a8                	ld	a0,80(s1)
    8000237e:	ffffe097          	auipc	ra,0xffffe
    80002382:	7e4080e7          	jalr	2020(ra) # 80000b62 <copyout>
  return 0;
    80002386:	957d                	srai	a0,a0,0x3f
    80002388:	70e2                	ld	ra,56(sp)
    8000238a:	7442                	ld	s0,48(sp)
    8000238c:	74a2                	ld	s1,40(sp)
    8000238e:	6121                	addi	sp,sp,64
    80002390:	8082                	ret

0000000080002392 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002392:	7179                	addi	sp,sp,-48
    80002394:	f406                	sd	ra,40(sp)
    80002396:	f022                	sd	s0,32(sp)
    80002398:	ec26                	sd	s1,24(sp)
    8000239a:	e84a                	sd	s2,16(sp)
    8000239c:	e44e                	sd	s3,8(sp)
    8000239e:	e052                	sd	s4,0(sp)
    800023a0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023a2:	00006597          	auipc	a1,0x6
    800023a6:	10658593          	addi	a1,a1,262 # 800084a8 <syscalls+0xc0>
    800023aa:	0000c517          	auipc	a0,0xc
    800023ae:	6ee50513          	addi	a0,a0,1774 # 8000ea98 <bcache>
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	e3a080e7          	jalr	-454(ra) # 800061ec <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023ba:	00014797          	auipc	a5,0x14
    800023be:	6de78793          	addi	a5,a5,1758 # 80016a98 <bcache+0x8000>
    800023c2:	00015717          	auipc	a4,0x15
    800023c6:	93e70713          	addi	a4,a4,-1730 # 80016d00 <bcache+0x8268>
    800023ca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ce:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d2:	0000c497          	auipc	s1,0xc
    800023d6:	6de48493          	addi	s1,s1,1758 # 8000eab0 <bcache+0x18>
    b->next = bcache.head.next;
    800023da:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023dc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023de:	00006a17          	auipc	s4,0x6
    800023e2:	0d2a0a13          	addi	s4,s4,210 # 800084b0 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023e6:	2b893783          	ld	a5,696(s2)
    800023ea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023f0:	85d2                	mv	a1,s4
    800023f2:	01048513          	addi	a0,s1,16
    800023f6:	00001097          	auipc	ra,0x1
    800023fa:	4c4080e7          	jalr	1220(ra) # 800038ba <initsleeplock>
    bcache.head.next->prev = b;
    800023fe:	2b893783          	ld	a5,696(s2)
    80002402:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002404:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002408:	45848493          	addi	s1,s1,1112
    8000240c:	fd349de3          	bne	s1,s3,800023e6 <binit+0x54>
  }
}
    80002410:	70a2                	ld	ra,40(sp)
    80002412:	7402                	ld	s0,32(sp)
    80002414:	64e2                	ld	s1,24(sp)
    80002416:	6942                	ld	s2,16(sp)
    80002418:	69a2                	ld	s3,8(sp)
    8000241a:	6a02                	ld	s4,0(sp)
    8000241c:	6145                	addi	sp,sp,48
    8000241e:	8082                	ret

0000000080002420 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	1800                	addi	s0,sp,48
    8000242e:	89aa                	mv	s3,a0
    80002430:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002432:	0000c517          	auipc	a0,0xc
    80002436:	66650513          	addi	a0,a0,1638 # 8000ea98 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	e42080e7          	jalr	-446(ra) # 8000627c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002442:	00015497          	auipc	s1,0x15
    80002446:	90e4b483          	ld	s1,-1778(s1) # 80016d50 <bcache+0x82b8>
    8000244a:	00015797          	auipc	a5,0x15
    8000244e:	8b678793          	addi	a5,a5,-1866 # 80016d00 <bcache+0x8268>
    80002452:	02f48f63          	beq	s1,a5,80002490 <bread+0x70>
    80002456:	873e                	mv	a4,a5
    80002458:	a021                	j	80002460 <bread+0x40>
    8000245a:	68a4                	ld	s1,80(s1)
    8000245c:	02e48a63          	beq	s1,a4,80002490 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002460:	449c                	lw	a5,8(s1)
    80002462:	ff379ce3          	bne	a5,s3,8000245a <bread+0x3a>
    80002466:	44dc                	lw	a5,12(s1)
    80002468:	ff2799e3          	bne	a5,s2,8000245a <bread+0x3a>
      b->refcnt++;
    8000246c:	40bc                	lw	a5,64(s1)
    8000246e:	2785                	addiw	a5,a5,1
    80002470:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002472:	0000c517          	auipc	a0,0xc
    80002476:	62650513          	addi	a0,a0,1574 # 8000ea98 <bcache>
    8000247a:	00004097          	auipc	ra,0x4
    8000247e:	eb6080e7          	jalr	-330(ra) # 80006330 <release>
      acquiresleep(&b->lock);
    80002482:	01048513          	addi	a0,s1,16
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	46e080e7          	jalr	1134(ra) # 800038f4 <acquiresleep>
      return b;
    8000248e:	a8b9                	j	800024ec <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002490:	00015497          	auipc	s1,0x15
    80002494:	8b84b483          	ld	s1,-1864(s1) # 80016d48 <bcache+0x82b0>
    80002498:	00015797          	auipc	a5,0x15
    8000249c:	86878793          	addi	a5,a5,-1944 # 80016d00 <bcache+0x8268>
    800024a0:	00f48863          	beq	s1,a5,800024b0 <bread+0x90>
    800024a4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024a6:	40bc                	lw	a5,64(s1)
    800024a8:	cf81                	beqz	a5,800024c0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024aa:	64a4                	ld	s1,72(s1)
    800024ac:	fee49de3          	bne	s1,a4,800024a6 <bread+0x86>
  panic("bget: no buffers");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	00850513          	addi	a0,a0,8 # 800084b8 <syscalls+0xd0>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	87a080e7          	jalr	-1926(ra) # 80005d32 <panic>
      b->dev = dev;
    800024c0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024c4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024c8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024cc:	4785                	li	a5,1
    800024ce:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d0:	0000c517          	auipc	a0,0xc
    800024d4:	5c850513          	addi	a0,a0,1480 # 8000ea98 <bcache>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	e58080e7          	jalr	-424(ra) # 80006330 <release>
      acquiresleep(&b->lock);
    800024e0:	01048513          	addi	a0,s1,16
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	410080e7          	jalr	1040(ra) # 800038f4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ec:	409c                	lw	a5,0(s1)
    800024ee:	cb89                	beqz	a5,80002500 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024f0:	8526                	mv	a0,s1
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6145                	addi	sp,sp,48
    800024fe:	8082                	ret
    virtio_disk_rw(b, 0);
    80002500:	4581                	li	a1,0
    80002502:	8526                	mv	a0,s1
    80002504:	00003097          	auipc	ra,0x3
    80002508:	fc4080e7          	jalr	-60(ra) # 800054c8 <virtio_disk_rw>
    b->valid = 1;
    8000250c:	4785                	li	a5,1
    8000250e:	c09c                	sw	a5,0(s1)
  return b;
    80002510:	b7c5                	j	800024f0 <bread+0xd0>

0000000080002512 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251e:	0541                	addi	a0,a0,16
    80002520:	00001097          	auipc	ra,0x1
    80002524:	46e080e7          	jalr	1134(ra) # 8000398e <holdingsleep>
    80002528:	cd01                	beqz	a0,80002540 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000252a:	4585                	li	a1,1
    8000252c:	8526                	mv	a0,s1
    8000252e:	00003097          	auipc	ra,0x3
    80002532:	f9a080e7          	jalr	-102(ra) # 800054c8 <virtio_disk_rw>
}
    80002536:	60e2                	ld	ra,24(sp)
    80002538:	6442                	ld	s0,16(sp)
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret
    panic("bwrite");
    80002540:	00006517          	auipc	a0,0x6
    80002544:	f9050513          	addi	a0,a0,-112 # 800084d0 <syscalls+0xe8>
    80002548:	00003097          	auipc	ra,0x3
    8000254c:	7ea080e7          	jalr	2026(ra) # 80005d32 <panic>

0000000080002550 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	e04a                	sd	s2,0(sp)
    8000255a:	1000                	addi	s0,sp,32
    8000255c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000255e:	01050913          	addi	s2,a0,16
    80002562:	854a                	mv	a0,s2
    80002564:	00001097          	auipc	ra,0x1
    80002568:	42a080e7          	jalr	1066(ra) # 8000398e <holdingsleep>
    8000256c:	c92d                	beqz	a0,800025de <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000256e:	854a                	mv	a0,s2
    80002570:	00001097          	auipc	ra,0x1
    80002574:	3da080e7          	jalr	986(ra) # 8000394a <releasesleep>

  acquire(&bcache.lock);
    80002578:	0000c517          	auipc	a0,0xc
    8000257c:	52050513          	addi	a0,a0,1312 # 8000ea98 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	cfc080e7          	jalr	-772(ra) # 8000627c <acquire>
  b->refcnt--;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	37fd                	addiw	a5,a5,-1
    8000258c:	0007871b          	sext.w	a4,a5
    80002590:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002592:	eb05                	bnez	a4,800025c2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002594:	68bc                	ld	a5,80(s1)
    80002596:	64b8                	ld	a4,72(s1)
    80002598:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000259a:	64bc                	ld	a5,72(s1)
    8000259c:	68b8                	ld	a4,80(s1)
    8000259e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025a0:	00014797          	auipc	a5,0x14
    800025a4:	4f878793          	addi	a5,a5,1272 # 80016a98 <bcache+0x8000>
    800025a8:	2b87b703          	ld	a4,696(a5)
    800025ac:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025ae:	00014717          	auipc	a4,0x14
    800025b2:	75270713          	addi	a4,a4,1874 # 80016d00 <bcache+0x8268>
    800025b6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025b8:	2b87b703          	ld	a4,696(a5)
    800025bc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025be:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025c2:	0000c517          	auipc	a0,0xc
    800025c6:	4d650513          	addi	a0,a0,1238 # 8000ea98 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	d66080e7          	jalr	-666(ra) # 80006330 <release>
}
    800025d2:	60e2                	ld	ra,24(sp)
    800025d4:	6442                	ld	s0,16(sp)
    800025d6:	64a2                	ld	s1,8(sp)
    800025d8:	6902                	ld	s2,0(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret
    panic("brelse");
    800025de:	00006517          	auipc	a0,0x6
    800025e2:	efa50513          	addi	a0,a0,-262 # 800084d8 <syscalls+0xf0>
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	74c080e7          	jalr	1868(ra) # 80005d32 <panic>

00000000800025ee <bpin>:

void
bpin(struct buf *b) {
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	1000                	addi	s0,sp,32
    800025f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fa:	0000c517          	auipc	a0,0xc
    800025fe:	49e50513          	addi	a0,a0,1182 # 8000ea98 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	c7a080e7          	jalr	-902(ra) # 8000627c <acquire>
  b->refcnt++;
    8000260a:	40bc                	lw	a5,64(s1)
    8000260c:	2785                	addiw	a5,a5,1
    8000260e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002610:	0000c517          	auipc	a0,0xc
    80002614:	48850513          	addi	a0,a0,1160 # 8000ea98 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	d18080e7          	jalr	-744(ra) # 80006330 <release>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret

000000008000262a <bunpin>:

void
bunpin(struct buf *b) {
    8000262a:	1101                	addi	sp,sp,-32
    8000262c:	ec06                	sd	ra,24(sp)
    8000262e:	e822                	sd	s0,16(sp)
    80002630:	e426                	sd	s1,8(sp)
    80002632:	1000                	addi	s0,sp,32
    80002634:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002636:	0000c517          	auipc	a0,0xc
    8000263a:	46250513          	addi	a0,a0,1122 # 8000ea98 <bcache>
    8000263e:	00004097          	auipc	ra,0x4
    80002642:	c3e080e7          	jalr	-962(ra) # 8000627c <acquire>
  b->refcnt--;
    80002646:	40bc                	lw	a5,64(s1)
    80002648:	37fd                	addiw	a5,a5,-1
    8000264a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000264c:	0000c517          	auipc	a0,0xc
    80002650:	44c50513          	addi	a0,a0,1100 # 8000ea98 <bcache>
    80002654:	00004097          	auipc	ra,0x4
    80002658:	cdc080e7          	jalr	-804(ra) # 80006330 <release>
}
    8000265c:	60e2                	ld	ra,24(sp)
    8000265e:	6442                	ld	s0,16(sp)
    80002660:	64a2                	ld	s1,8(sp)
    80002662:	6105                	addi	sp,sp,32
    80002664:	8082                	ret

0000000080002666 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002666:	1101                	addi	sp,sp,-32
    80002668:	ec06                	sd	ra,24(sp)
    8000266a:	e822                	sd	s0,16(sp)
    8000266c:	e426                	sd	s1,8(sp)
    8000266e:	e04a                	sd	s2,0(sp)
    80002670:	1000                	addi	s0,sp,32
    80002672:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002674:	00d5d59b          	srliw	a1,a1,0xd
    80002678:	00015797          	auipc	a5,0x15
    8000267c:	afc7a783          	lw	a5,-1284(a5) # 80017174 <sb+0x1c>
    80002680:	9dbd                	addw	a1,a1,a5
    80002682:	00000097          	auipc	ra,0x0
    80002686:	d9e080e7          	jalr	-610(ra) # 80002420 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000268a:	0074f713          	andi	a4,s1,7
    8000268e:	4785                	li	a5,1
    80002690:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002694:	14ce                	slli	s1,s1,0x33
    80002696:	90d9                	srli	s1,s1,0x36
    80002698:	00950733          	add	a4,a0,s1
    8000269c:	05874703          	lbu	a4,88(a4)
    800026a0:	00e7f6b3          	and	a3,a5,a4
    800026a4:	c69d                	beqz	a3,800026d2 <bfree+0x6c>
    800026a6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026a8:	94aa                	add	s1,s1,a0
    800026aa:	fff7c793          	not	a5,a5
    800026ae:	8ff9                	and	a5,a5,a4
    800026b0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026b4:	00001097          	auipc	ra,0x1
    800026b8:	120080e7          	jalr	288(ra) # 800037d4 <log_write>
  brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	e92080e7          	jalr	-366(ra) # 80002550 <brelse>
}
    800026c6:	60e2                	ld	ra,24(sp)
    800026c8:	6442                	ld	s0,16(sp)
    800026ca:	64a2                	ld	s1,8(sp)
    800026cc:	6902                	ld	s2,0(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret
    panic("freeing free block");
    800026d2:	00006517          	auipc	a0,0x6
    800026d6:	e0e50513          	addi	a0,a0,-498 # 800084e0 <syscalls+0xf8>
    800026da:	00003097          	auipc	ra,0x3
    800026de:	658080e7          	jalr	1624(ra) # 80005d32 <panic>

00000000800026e2 <balloc>:
{
    800026e2:	711d                	addi	sp,sp,-96
    800026e4:	ec86                	sd	ra,88(sp)
    800026e6:	e8a2                	sd	s0,80(sp)
    800026e8:	e4a6                	sd	s1,72(sp)
    800026ea:	e0ca                	sd	s2,64(sp)
    800026ec:	fc4e                	sd	s3,56(sp)
    800026ee:	f852                	sd	s4,48(sp)
    800026f0:	f456                	sd	s5,40(sp)
    800026f2:	f05a                	sd	s6,32(sp)
    800026f4:	ec5e                	sd	s7,24(sp)
    800026f6:	e862                	sd	s8,16(sp)
    800026f8:	e466                	sd	s9,8(sp)
    800026fa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026fc:	00015797          	auipc	a5,0x15
    80002700:	a607a783          	lw	a5,-1440(a5) # 8001715c <sb+0x4>
    80002704:	10078163          	beqz	a5,80002806 <balloc+0x124>
    80002708:	8baa                	mv	s7,a0
    8000270a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000270c:	00015b17          	auipc	s6,0x15
    80002710:	a4cb0b13          	addi	s6,s6,-1460 # 80017158 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002714:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002716:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002718:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000271a:	6c89                	lui	s9,0x2
    8000271c:	a061                	j	800027a4 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000271e:	974a                	add	a4,a4,s2
    80002720:	8fd5                	or	a5,a5,a3
    80002722:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00001097          	auipc	ra,0x1
    8000272c:	0ac080e7          	jalr	172(ra) # 800037d4 <log_write>
        brelse(bp);
    80002730:	854a                	mv	a0,s2
    80002732:	00000097          	auipc	ra,0x0
    80002736:	e1e080e7          	jalr	-482(ra) # 80002550 <brelse>
  bp = bread(dev, bno);
    8000273a:	85a6                	mv	a1,s1
    8000273c:	855e                	mv	a0,s7
    8000273e:	00000097          	auipc	ra,0x0
    80002742:	ce2080e7          	jalr	-798(ra) # 80002420 <bread>
    80002746:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002748:	40000613          	li	a2,1024
    8000274c:	4581                	li	a1,0
    8000274e:	05850513          	addi	a0,a0,88
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	a72080e7          	jalr	-1422(ra) # 800001c4 <memset>
  log_write(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00001097          	auipc	ra,0x1
    80002760:	078080e7          	jalr	120(ra) # 800037d4 <log_write>
  brelse(bp);
    80002764:	854a                	mv	a0,s2
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	dea080e7          	jalr	-534(ra) # 80002550 <brelse>
}
    8000276e:	8526                	mv	a0,s1
    80002770:	60e6                	ld	ra,88(sp)
    80002772:	6446                	ld	s0,80(sp)
    80002774:	64a6                	ld	s1,72(sp)
    80002776:	6906                	ld	s2,64(sp)
    80002778:	79e2                	ld	s3,56(sp)
    8000277a:	7a42                	ld	s4,48(sp)
    8000277c:	7aa2                	ld	s5,40(sp)
    8000277e:	7b02                	ld	s6,32(sp)
    80002780:	6be2                	ld	s7,24(sp)
    80002782:	6c42                	ld	s8,16(sp)
    80002784:	6ca2                	ld	s9,8(sp)
    80002786:	6125                	addi	sp,sp,96
    80002788:	8082                	ret
    brelse(bp);
    8000278a:	854a                	mv	a0,s2
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	dc4080e7          	jalr	-572(ra) # 80002550 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002794:	015c87bb          	addw	a5,s9,s5
    80002798:	00078a9b          	sext.w	s5,a5
    8000279c:	004b2703          	lw	a4,4(s6)
    800027a0:	06eaf363          	bgeu	s5,a4,80002806 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800027a4:	41fad79b          	sraiw	a5,s5,0x1f
    800027a8:	0137d79b          	srliw	a5,a5,0x13
    800027ac:	015787bb          	addw	a5,a5,s5
    800027b0:	40d7d79b          	sraiw	a5,a5,0xd
    800027b4:	01cb2583          	lw	a1,28(s6)
    800027b8:	9dbd                	addw	a1,a1,a5
    800027ba:	855e                	mv	a0,s7
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	c64080e7          	jalr	-924(ra) # 80002420 <bread>
    800027c4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c6:	004b2503          	lw	a0,4(s6)
    800027ca:	000a849b          	sext.w	s1,s5
    800027ce:	8662                	mv	a2,s8
    800027d0:	faa4fde3          	bgeu	s1,a0,8000278a <balloc+0xa8>
      m = 1 << (bi % 8);
    800027d4:	41f6579b          	sraiw	a5,a2,0x1f
    800027d8:	01d7d69b          	srliw	a3,a5,0x1d
    800027dc:	00c6873b          	addw	a4,a3,a2
    800027e0:	00777793          	andi	a5,a4,7
    800027e4:	9f95                	subw	a5,a5,a3
    800027e6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027ea:	4037571b          	sraiw	a4,a4,0x3
    800027ee:	00e906b3          	add	a3,s2,a4
    800027f2:	0586c683          	lbu	a3,88(a3)
    800027f6:	00d7f5b3          	and	a1,a5,a3
    800027fa:	d195                	beqz	a1,8000271e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fc:	2605                	addiw	a2,a2,1
    800027fe:	2485                	addiw	s1,s1,1
    80002800:	fd4618e3          	bne	a2,s4,800027d0 <balloc+0xee>
    80002804:	b759                	j	8000278a <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002806:	00006517          	auipc	a0,0x6
    8000280a:	cf250513          	addi	a0,a0,-782 # 800084f8 <syscalls+0x110>
    8000280e:	00003097          	auipc	ra,0x3
    80002812:	56e080e7          	jalr	1390(ra) # 80005d7c <printf>
  return 0;
    80002816:	4481                	li	s1,0
    80002818:	bf99                	j	8000276e <balloc+0x8c>

000000008000281a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000281a:	7179                	addi	sp,sp,-48
    8000281c:	f406                	sd	ra,40(sp)
    8000281e:	f022                	sd	s0,32(sp)
    80002820:	ec26                	sd	s1,24(sp)
    80002822:	e84a                	sd	s2,16(sp)
    80002824:	e44e                	sd	s3,8(sp)
    80002826:	e052                	sd	s4,0(sp)
    80002828:	1800                	addi	s0,sp,48
    8000282a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000282c:	47ad                	li	a5,11
    8000282e:	02b7e763          	bltu	a5,a1,8000285c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002832:	02059493          	slli	s1,a1,0x20
    80002836:	9081                	srli	s1,s1,0x20
    80002838:	048a                	slli	s1,s1,0x2
    8000283a:	94aa                	add	s1,s1,a0
    8000283c:	0504a903          	lw	s2,80(s1)
    80002840:	06091e63          	bnez	s2,800028bc <bmap+0xa2>
      addr = balloc(ip->dev);
    80002844:	4108                	lw	a0,0(a0)
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e9c080e7          	jalr	-356(ra) # 800026e2 <balloc>
    8000284e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002852:	06090563          	beqz	s2,800028bc <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002856:	0524a823          	sw	s2,80(s1)
    8000285a:	a08d                	j	800028bc <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000285c:	ff45849b          	addiw	s1,a1,-12
    80002860:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002864:	0ff00793          	li	a5,255
    80002868:	08e7e563          	bltu	a5,a4,800028f2 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000286c:	08052903          	lw	s2,128(a0)
    80002870:	00091d63          	bnez	s2,8000288a <bmap+0x70>
      addr = balloc(ip->dev);
    80002874:	4108                	lw	a0,0(a0)
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e6c080e7          	jalr	-404(ra) # 800026e2 <balloc>
    8000287e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002882:	02090d63          	beqz	s2,800028bc <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002886:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000288a:	85ca                	mv	a1,s2
    8000288c:	0009a503          	lw	a0,0(s3)
    80002890:	00000097          	auipc	ra,0x0
    80002894:	b90080e7          	jalr	-1136(ra) # 80002420 <bread>
    80002898:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000289a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000289e:	02049593          	slli	a1,s1,0x20
    800028a2:	9181                	srli	a1,a1,0x20
    800028a4:	058a                	slli	a1,a1,0x2
    800028a6:	00b784b3          	add	s1,a5,a1
    800028aa:	0004a903          	lw	s2,0(s1)
    800028ae:	02090063          	beqz	s2,800028ce <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028b2:	8552                	mv	a0,s4
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	c9c080e7          	jalr	-868(ra) # 80002550 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028bc:	854a                	mv	a0,s2
    800028be:	70a2                	ld	ra,40(sp)
    800028c0:	7402                	ld	s0,32(sp)
    800028c2:	64e2                	ld	s1,24(sp)
    800028c4:	6942                	ld	s2,16(sp)
    800028c6:	69a2                	ld	s3,8(sp)
    800028c8:	6a02                	ld	s4,0(sp)
    800028ca:	6145                	addi	sp,sp,48
    800028cc:	8082                	ret
      addr = balloc(ip->dev);
    800028ce:	0009a503          	lw	a0,0(s3)
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	e10080e7          	jalr	-496(ra) # 800026e2 <balloc>
    800028da:	0005091b          	sext.w	s2,a0
      if(addr){
    800028de:	fc090ae3          	beqz	s2,800028b2 <bmap+0x98>
        a[bn] = addr;
    800028e2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028e6:	8552                	mv	a0,s4
    800028e8:	00001097          	auipc	ra,0x1
    800028ec:	eec080e7          	jalr	-276(ra) # 800037d4 <log_write>
    800028f0:	b7c9                	j	800028b2 <bmap+0x98>
  panic("bmap: out of range");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	c1e50513          	addi	a0,a0,-994 # 80008510 <syscalls+0x128>
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	438080e7          	jalr	1080(ra) # 80005d32 <panic>

0000000080002902 <iget>:
{
    80002902:	7179                	addi	sp,sp,-48
    80002904:	f406                	sd	ra,40(sp)
    80002906:	f022                	sd	s0,32(sp)
    80002908:	ec26                	sd	s1,24(sp)
    8000290a:	e84a                	sd	s2,16(sp)
    8000290c:	e44e                	sd	s3,8(sp)
    8000290e:	e052                	sd	s4,0(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	89aa                	mv	s3,a0
    80002914:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002916:	00015517          	auipc	a0,0x15
    8000291a:	86250513          	addi	a0,a0,-1950 # 80017178 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	95e080e7          	jalr	-1698(ra) # 8000627c <acquire>
  empty = 0;
    80002926:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002928:	00015497          	auipc	s1,0x15
    8000292c:	86848493          	addi	s1,s1,-1944 # 80017190 <itable+0x18>
    80002930:	00016697          	auipc	a3,0x16
    80002934:	2f068693          	addi	a3,a3,752 # 80018c20 <log>
    80002938:	a039                	j	80002946 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000293a:	02090b63          	beqz	s2,80002970 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000293e:	08848493          	addi	s1,s1,136
    80002942:	02d48a63          	beq	s1,a3,80002976 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002946:	449c                	lw	a5,8(s1)
    80002948:	fef059e3          	blez	a5,8000293a <iget+0x38>
    8000294c:	4098                	lw	a4,0(s1)
    8000294e:	ff3716e3          	bne	a4,s3,8000293a <iget+0x38>
    80002952:	40d8                	lw	a4,4(s1)
    80002954:	ff4713e3          	bne	a4,s4,8000293a <iget+0x38>
      ip->ref++;
    80002958:	2785                	addiw	a5,a5,1
    8000295a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000295c:	00015517          	auipc	a0,0x15
    80002960:	81c50513          	addi	a0,a0,-2020 # 80017178 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	9cc080e7          	jalr	-1588(ra) # 80006330 <release>
      return ip;
    8000296c:	8926                	mv	s2,s1
    8000296e:	a03d                	j	8000299c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002970:	f7f9                	bnez	a5,8000293e <iget+0x3c>
    80002972:	8926                	mv	s2,s1
    80002974:	b7e9                	j	8000293e <iget+0x3c>
  if(empty == 0)
    80002976:	02090c63          	beqz	s2,800029ae <iget+0xac>
  ip->dev = dev;
    8000297a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000297e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002982:	4785                	li	a5,1
    80002984:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002988:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000298c:	00014517          	auipc	a0,0x14
    80002990:	7ec50513          	addi	a0,a0,2028 # 80017178 <itable>
    80002994:	00004097          	auipc	ra,0x4
    80002998:	99c080e7          	jalr	-1636(ra) # 80006330 <release>
}
    8000299c:	854a                	mv	a0,s2
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6a02                	ld	s4,0(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret
    panic("iget: no inodes");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	b7a50513          	addi	a0,a0,-1158 # 80008528 <syscalls+0x140>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	37c080e7          	jalr	892(ra) # 80005d32 <panic>

00000000800029be <fsinit>:
fsinit(int dev) {
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	1800                	addi	s0,sp,48
    800029cc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ce:	4585                	li	a1,1
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	a50080e7          	jalr	-1456(ra) # 80002420 <bread>
    800029d8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029da:	00014997          	auipc	s3,0x14
    800029de:	77e98993          	addi	s3,s3,1918 # 80017158 <sb>
    800029e2:	02000613          	li	a2,32
    800029e6:	05850593          	addi	a1,a0,88
    800029ea:	854e                	mv	a0,s3
    800029ec:	ffffe097          	auipc	ra,0xffffe
    800029f0:	838080e7          	jalr	-1992(ra) # 80000224 <memmove>
  brelse(bp);
    800029f4:	8526                	mv	a0,s1
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	b5a080e7          	jalr	-1190(ra) # 80002550 <brelse>
  if(sb.magic != FSMAGIC)
    800029fe:	0009a703          	lw	a4,0(s3)
    80002a02:	102037b7          	lui	a5,0x10203
    80002a06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a0a:	02f71263          	bne	a4,a5,80002a2e <fsinit+0x70>
  initlog(dev, &sb);
    80002a0e:	00014597          	auipc	a1,0x14
    80002a12:	74a58593          	addi	a1,a1,1866 # 80017158 <sb>
    80002a16:	854a                	mv	a0,s2
    80002a18:	00001097          	auipc	ra,0x1
    80002a1c:	b40080e7          	jalr	-1216(ra) # 80003558 <initlog>
}
    80002a20:	70a2                	ld	ra,40(sp)
    80002a22:	7402                	ld	s0,32(sp)
    80002a24:	64e2                	ld	s1,24(sp)
    80002a26:	6942                	ld	s2,16(sp)
    80002a28:	69a2                	ld	s3,8(sp)
    80002a2a:	6145                	addi	sp,sp,48
    80002a2c:	8082                	ret
    panic("invalid file system");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	b0a50513          	addi	a0,a0,-1270 # 80008538 <syscalls+0x150>
    80002a36:	00003097          	auipc	ra,0x3
    80002a3a:	2fc080e7          	jalr	764(ra) # 80005d32 <panic>

0000000080002a3e <iinit>:
{
    80002a3e:	7179                	addi	sp,sp,-48
    80002a40:	f406                	sd	ra,40(sp)
    80002a42:	f022                	sd	s0,32(sp)
    80002a44:	ec26                	sd	s1,24(sp)
    80002a46:	e84a                	sd	s2,16(sp)
    80002a48:	e44e                	sd	s3,8(sp)
    80002a4a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a4c:	00006597          	auipc	a1,0x6
    80002a50:	b0458593          	addi	a1,a1,-1276 # 80008550 <syscalls+0x168>
    80002a54:	00014517          	auipc	a0,0x14
    80002a58:	72450513          	addi	a0,a0,1828 # 80017178 <itable>
    80002a5c:	00003097          	auipc	ra,0x3
    80002a60:	790080e7          	jalr	1936(ra) # 800061ec <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a64:	00014497          	auipc	s1,0x14
    80002a68:	73c48493          	addi	s1,s1,1852 # 800171a0 <itable+0x28>
    80002a6c:	00016997          	auipc	s3,0x16
    80002a70:	1c498993          	addi	s3,s3,452 # 80018c30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a74:	00006917          	auipc	s2,0x6
    80002a78:	ae490913          	addi	s2,s2,-1308 # 80008558 <syscalls+0x170>
    80002a7c:	85ca                	mv	a1,s2
    80002a7e:	8526                	mv	a0,s1
    80002a80:	00001097          	auipc	ra,0x1
    80002a84:	e3a080e7          	jalr	-454(ra) # 800038ba <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a88:	08848493          	addi	s1,s1,136
    80002a8c:	ff3498e3          	bne	s1,s3,80002a7c <iinit+0x3e>
}
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret

0000000080002a9e <ialloc>:
{
    80002a9e:	715d                	addi	sp,sp,-80
    80002aa0:	e486                	sd	ra,72(sp)
    80002aa2:	e0a2                	sd	s0,64(sp)
    80002aa4:	fc26                	sd	s1,56(sp)
    80002aa6:	f84a                	sd	s2,48(sp)
    80002aa8:	f44e                	sd	s3,40(sp)
    80002aaa:	f052                	sd	s4,32(sp)
    80002aac:	ec56                	sd	s5,24(sp)
    80002aae:	e85a                	sd	s6,16(sp)
    80002ab0:	e45e                	sd	s7,8(sp)
    80002ab2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab4:	00014717          	auipc	a4,0x14
    80002ab8:	6b072703          	lw	a4,1712(a4) # 80017164 <sb+0xc>
    80002abc:	4785                	li	a5,1
    80002abe:	04e7fa63          	bgeu	a5,a4,80002b12 <ialloc+0x74>
    80002ac2:	8aaa                	mv	s5,a0
    80002ac4:	8bae                	mv	s7,a1
    80002ac6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac8:	00014a17          	auipc	s4,0x14
    80002acc:	690a0a13          	addi	s4,s4,1680 # 80017158 <sb>
    80002ad0:	00048b1b          	sext.w	s6,s1
    80002ad4:	0044d593          	srli	a1,s1,0x4
    80002ad8:	018a2783          	lw	a5,24(s4)
    80002adc:	9dbd                	addw	a1,a1,a5
    80002ade:	8556                	mv	a0,s5
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	940080e7          	jalr	-1728(ra) # 80002420 <bread>
    80002ae8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aea:	05850993          	addi	s3,a0,88
    80002aee:	00f4f793          	andi	a5,s1,15
    80002af2:	079a                	slli	a5,a5,0x6
    80002af4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002af6:	00099783          	lh	a5,0(s3)
    80002afa:	c3a1                	beqz	a5,80002b3a <ialloc+0x9c>
    brelse(bp);
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	a54080e7          	jalr	-1452(ra) # 80002550 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b04:	0485                	addi	s1,s1,1
    80002b06:	00ca2703          	lw	a4,12(s4)
    80002b0a:	0004879b          	sext.w	a5,s1
    80002b0e:	fce7e1e3          	bltu	a5,a4,80002ad0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	a4e50513          	addi	a0,a0,-1458 # 80008560 <syscalls+0x178>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	262080e7          	jalr	610(ra) # 80005d7c <printf>
  return 0;
    80002b22:	4501                	li	a0,0
}
    80002b24:	60a6                	ld	ra,72(sp)
    80002b26:	6406                	ld	s0,64(sp)
    80002b28:	74e2                	ld	s1,56(sp)
    80002b2a:	7942                	ld	s2,48(sp)
    80002b2c:	79a2                	ld	s3,40(sp)
    80002b2e:	7a02                	ld	s4,32(sp)
    80002b30:	6ae2                	ld	s5,24(sp)
    80002b32:	6b42                	ld	s6,16(sp)
    80002b34:	6ba2                	ld	s7,8(sp)
    80002b36:	6161                	addi	sp,sp,80
    80002b38:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b3a:	04000613          	li	a2,64
    80002b3e:	4581                	li	a1,0
    80002b40:	854e                	mv	a0,s3
    80002b42:	ffffd097          	auipc	ra,0xffffd
    80002b46:	682080e7          	jalr	1666(ra) # 800001c4 <memset>
      dip->type = type;
    80002b4a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b4e:	854a                	mv	a0,s2
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	c84080e7          	jalr	-892(ra) # 800037d4 <log_write>
      brelse(bp);
    80002b58:	854a                	mv	a0,s2
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	9f6080e7          	jalr	-1546(ra) # 80002550 <brelse>
      return iget(dev, inum);
    80002b62:	85da                	mv	a1,s6
    80002b64:	8556                	mv	a0,s5
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	d9c080e7          	jalr	-612(ra) # 80002902 <iget>
    80002b6e:	bf5d                	j	80002b24 <ialloc+0x86>

0000000080002b70 <iupdate>:
{
    80002b70:	1101                	addi	sp,sp,-32
    80002b72:	ec06                	sd	ra,24(sp)
    80002b74:	e822                	sd	s0,16(sp)
    80002b76:	e426                	sd	s1,8(sp)
    80002b78:	e04a                	sd	s2,0(sp)
    80002b7a:	1000                	addi	s0,sp,32
    80002b7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7e:	415c                	lw	a5,4(a0)
    80002b80:	0047d79b          	srliw	a5,a5,0x4
    80002b84:	00014597          	auipc	a1,0x14
    80002b88:	5ec5a583          	lw	a1,1516(a1) # 80017170 <sb+0x18>
    80002b8c:	9dbd                	addw	a1,a1,a5
    80002b8e:	4108                	lw	a0,0(a0)
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	890080e7          	jalr	-1904(ra) # 80002420 <bread>
    80002b98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b9a:	05850793          	addi	a5,a0,88
    80002b9e:	40c8                	lw	a0,4(s1)
    80002ba0:	893d                	andi	a0,a0,15
    80002ba2:	051a                	slli	a0,a0,0x6
    80002ba4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ba6:	04449703          	lh	a4,68(s1)
    80002baa:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bae:	04649703          	lh	a4,70(s1)
    80002bb2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bb6:	04849703          	lh	a4,72(s1)
    80002bba:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bbe:	04a49703          	lh	a4,74(s1)
    80002bc2:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bc6:	44f8                	lw	a4,76(s1)
    80002bc8:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bca:	03400613          	li	a2,52
    80002bce:	05048593          	addi	a1,s1,80
    80002bd2:	0531                	addi	a0,a0,12
    80002bd4:	ffffd097          	auipc	ra,0xffffd
    80002bd8:	650080e7          	jalr	1616(ra) # 80000224 <memmove>
  log_write(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00001097          	auipc	ra,0x1
    80002be2:	bf6080e7          	jalr	-1034(ra) # 800037d4 <log_write>
  brelse(bp);
    80002be6:	854a                	mv	a0,s2
    80002be8:	00000097          	auipc	ra,0x0
    80002bec:	968080e7          	jalr	-1688(ra) # 80002550 <brelse>
}
    80002bf0:	60e2                	ld	ra,24(sp)
    80002bf2:	6442                	ld	s0,16(sp)
    80002bf4:	64a2                	ld	s1,8(sp)
    80002bf6:	6902                	ld	s2,0(sp)
    80002bf8:	6105                	addi	sp,sp,32
    80002bfa:	8082                	ret

0000000080002bfc <idup>:
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	1000                	addi	s0,sp,32
    80002c06:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c08:	00014517          	auipc	a0,0x14
    80002c0c:	57050513          	addi	a0,a0,1392 # 80017178 <itable>
    80002c10:	00003097          	auipc	ra,0x3
    80002c14:	66c080e7          	jalr	1644(ra) # 8000627c <acquire>
  ip->ref++;
    80002c18:	449c                	lw	a5,8(s1)
    80002c1a:	2785                	addiw	a5,a5,1
    80002c1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c1e:	00014517          	auipc	a0,0x14
    80002c22:	55a50513          	addi	a0,a0,1370 # 80017178 <itable>
    80002c26:	00003097          	auipc	ra,0x3
    80002c2a:	70a080e7          	jalr	1802(ra) # 80006330 <release>
}
    80002c2e:	8526                	mv	a0,s1
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6105                	addi	sp,sp,32
    80002c38:	8082                	ret

0000000080002c3a <ilock>:
{
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	e04a                	sd	s2,0(sp)
    80002c44:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c46:	c115                	beqz	a0,80002c6a <ilock+0x30>
    80002c48:	84aa                	mv	s1,a0
    80002c4a:	451c                	lw	a5,8(a0)
    80002c4c:	00f05f63          	blez	a5,80002c6a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c50:	0541                	addi	a0,a0,16
    80002c52:	00001097          	auipc	ra,0x1
    80002c56:	ca2080e7          	jalr	-862(ra) # 800038f4 <acquiresleep>
  if(ip->valid == 0){
    80002c5a:	40bc                	lw	a5,64(s1)
    80002c5c:	cf99                	beqz	a5,80002c7a <ilock+0x40>
}
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	64a2                	ld	s1,8(sp)
    80002c64:	6902                	ld	s2,0(sp)
    80002c66:	6105                	addi	sp,sp,32
    80002c68:	8082                	ret
    panic("ilock");
    80002c6a:	00006517          	auipc	a0,0x6
    80002c6e:	90e50513          	addi	a0,a0,-1778 # 80008578 <syscalls+0x190>
    80002c72:	00003097          	auipc	ra,0x3
    80002c76:	0c0080e7          	jalr	192(ra) # 80005d32 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c7a:	40dc                	lw	a5,4(s1)
    80002c7c:	0047d79b          	srliw	a5,a5,0x4
    80002c80:	00014597          	auipc	a1,0x14
    80002c84:	4f05a583          	lw	a1,1264(a1) # 80017170 <sb+0x18>
    80002c88:	9dbd                	addw	a1,a1,a5
    80002c8a:	4088                	lw	a0,0(s1)
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	794080e7          	jalr	1940(ra) # 80002420 <bread>
    80002c94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c96:	05850593          	addi	a1,a0,88
    80002c9a:	40dc                	lw	a5,4(s1)
    80002c9c:	8bbd                	andi	a5,a5,15
    80002c9e:	079a                	slli	a5,a5,0x6
    80002ca0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ca2:	00059783          	lh	a5,0(a1)
    80002ca6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002caa:	00259783          	lh	a5,2(a1)
    80002cae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cb2:	00459783          	lh	a5,4(a1)
    80002cb6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cba:	00659783          	lh	a5,6(a1)
    80002cbe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cc2:	459c                	lw	a5,8(a1)
    80002cc4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cc6:	03400613          	li	a2,52
    80002cca:	05b1                	addi	a1,a1,12
    80002ccc:	05048513          	addi	a0,s1,80
    80002cd0:	ffffd097          	auipc	ra,0xffffd
    80002cd4:	554080e7          	jalr	1364(ra) # 80000224 <memmove>
    brelse(bp);
    80002cd8:	854a                	mv	a0,s2
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	876080e7          	jalr	-1930(ra) # 80002550 <brelse>
    ip->valid = 1;
    80002ce2:	4785                	li	a5,1
    80002ce4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ce6:	04449783          	lh	a5,68(s1)
    80002cea:	fbb5                	bnez	a5,80002c5e <ilock+0x24>
      panic("ilock: no type");
    80002cec:	00006517          	auipc	a0,0x6
    80002cf0:	89450513          	addi	a0,a0,-1900 # 80008580 <syscalls+0x198>
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	03e080e7          	jalr	62(ra) # 80005d32 <panic>

0000000080002cfc <iunlock>:
{
    80002cfc:	1101                	addi	sp,sp,-32
    80002cfe:	ec06                	sd	ra,24(sp)
    80002d00:	e822                	sd	s0,16(sp)
    80002d02:	e426                	sd	s1,8(sp)
    80002d04:	e04a                	sd	s2,0(sp)
    80002d06:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d08:	c905                	beqz	a0,80002d38 <iunlock+0x3c>
    80002d0a:	84aa                	mv	s1,a0
    80002d0c:	01050913          	addi	s2,a0,16
    80002d10:	854a                	mv	a0,s2
    80002d12:	00001097          	auipc	ra,0x1
    80002d16:	c7c080e7          	jalr	-900(ra) # 8000398e <holdingsleep>
    80002d1a:	cd19                	beqz	a0,80002d38 <iunlock+0x3c>
    80002d1c:	449c                	lw	a5,8(s1)
    80002d1e:	00f05d63          	blez	a5,80002d38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d22:	854a                	mv	a0,s2
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	c26080e7          	jalr	-986(ra) # 8000394a <releasesleep>
}
    80002d2c:	60e2                	ld	ra,24(sp)
    80002d2e:	6442                	ld	s0,16(sp)
    80002d30:	64a2                	ld	s1,8(sp)
    80002d32:	6902                	ld	s2,0(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret
    panic("iunlock");
    80002d38:	00006517          	auipc	a0,0x6
    80002d3c:	85850513          	addi	a0,a0,-1960 # 80008590 <syscalls+0x1a8>
    80002d40:	00003097          	auipc	ra,0x3
    80002d44:	ff2080e7          	jalr	-14(ra) # 80005d32 <panic>

0000000080002d48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d48:	7179                	addi	sp,sp,-48
    80002d4a:	f406                	sd	ra,40(sp)
    80002d4c:	f022                	sd	s0,32(sp)
    80002d4e:	ec26                	sd	s1,24(sp)
    80002d50:	e84a                	sd	s2,16(sp)
    80002d52:	e44e                	sd	s3,8(sp)
    80002d54:	e052                	sd	s4,0(sp)
    80002d56:	1800                	addi	s0,sp,48
    80002d58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d5a:	05050493          	addi	s1,a0,80
    80002d5e:	08050913          	addi	s2,a0,128
    80002d62:	a021                	j	80002d6a <itrunc+0x22>
    80002d64:	0491                	addi	s1,s1,4
    80002d66:	01248d63          	beq	s1,s2,80002d80 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d6a:	408c                	lw	a1,0(s1)
    80002d6c:	dde5                	beqz	a1,80002d64 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d6e:	0009a503          	lw	a0,0(s3)
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	8f4080e7          	jalr	-1804(ra) # 80002666 <bfree>
      ip->addrs[i] = 0;
    80002d7a:	0004a023          	sw	zero,0(s1)
    80002d7e:	b7dd                	j	80002d64 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d80:	0809a583          	lw	a1,128(s3)
    80002d84:	e185                	bnez	a1,80002da4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d8a:	854e                	mv	a0,s3
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	de4080e7          	jalr	-540(ra) # 80002b70 <iupdate>
}
    80002d94:	70a2                	ld	ra,40(sp)
    80002d96:	7402                	ld	s0,32(sp)
    80002d98:	64e2                	ld	s1,24(sp)
    80002d9a:	6942                	ld	s2,16(sp)
    80002d9c:	69a2                	ld	s3,8(sp)
    80002d9e:	6a02                	ld	s4,0(sp)
    80002da0:	6145                	addi	sp,sp,48
    80002da2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002da4:	0009a503          	lw	a0,0(s3)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	678080e7          	jalr	1656(ra) # 80002420 <bread>
    80002db0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002db2:	05850493          	addi	s1,a0,88
    80002db6:	45850913          	addi	s2,a0,1112
    80002dba:	a811                	j	80002dce <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dbc:	0009a503          	lw	a0,0(s3)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	8a6080e7          	jalr	-1882(ra) # 80002666 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002dc8:	0491                	addi	s1,s1,4
    80002dca:	01248563          	beq	s1,s2,80002dd4 <itrunc+0x8c>
      if(a[j])
    80002dce:	408c                	lw	a1,0(s1)
    80002dd0:	dde5                	beqz	a1,80002dc8 <itrunc+0x80>
    80002dd2:	b7ed                	j	80002dbc <itrunc+0x74>
    brelse(bp);
    80002dd4:	8552                	mv	a0,s4
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	77a080e7          	jalr	1914(ra) # 80002550 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dde:	0809a583          	lw	a1,128(s3)
    80002de2:	0009a503          	lw	a0,0(s3)
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	880080e7          	jalr	-1920(ra) # 80002666 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dee:	0809a023          	sw	zero,128(s3)
    80002df2:	bf51                	j	80002d86 <itrunc+0x3e>

0000000080002df4 <iput>:
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	e04a                	sd	s2,0(sp)
    80002dfe:	1000                	addi	s0,sp,32
    80002e00:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e02:	00014517          	auipc	a0,0x14
    80002e06:	37650513          	addi	a0,a0,886 # 80017178 <itable>
    80002e0a:	00003097          	auipc	ra,0x3
    80002e0e:	472080e7          	jalr	1138(ra) # 8000627c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e12:	4498                	lw	a4,8(s1)
    80002e14:	4785                	li	a5,1
    80002e16:	02f70363          	beq	a4,a5,80002e3c <iput+0x48>
  ip->ref--;
    80002e1a:	449c                	lw	a5,8(s1)
    80002e1c:	37fd                	addiw	a5,a5,-1
    80002e1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e20:	00014517          	auipc	a0,0x14
    80002e24:	35850513          	addi	a0,a0,856 # 80017178 <itable>
    80002e28:	00003097          	auipc	ra,0x3
    80002e2c:	508080e7          	jalr	1288(ra) # 80006330 <release>
}
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	64a2                	ld	s1,8(sp)
    80002e36:	6902                	ld	s2,0(sp)
    80002e38:	6105                	addi	sp,sp,32
    80002e3a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e3c:	40bc                	lw	a5,64(s1)
    80002e3e:	dff1                	beqz	a5,80002e1a <iput+0x26>
    80002e40:	04a49783          	lh	a5,74(s1)
    80002e44:	fbf9                	bnez	a5,80002e1a <iput+0x26>
    acquiresleep(&ip->lock);
    80002e46:	01048913          	addi	s2,s1,16
    80002e4a:	854a                	mv	a0,s2
    80002e4c:	00001097          	auipc	ra,0x1
    80002e50:	aa8080e7          	jalr	-1368(ra) # 800038f4 <acquiresleep>
    release(&itable.lock);
    80002e54:	00014517          	auipc	a0,0x14
    80002e58:	32450513          	addi	a0,a0,804 # 80017178 <itable>
    80002e5c:	00003097          	auipc	ra,0x3
    80002e60:	4d4080e7          	jalr	1236(ra) # 80006330 <release>
    itrunc(ip);
    80002e64:	8526                	mv	a0,s1
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	ee2080e7          	jalr	-286(ra) # 80002d48 <itrunc>
    ip->type = 0;
    80002e6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e72:	8526                	mv	a0,s1
    80002e74:	00000097          	auipc	ra,0x0
    80002e78:	cfc080e7          	jalr	-772(ra) # 80002b70 <iupdate>
    ip->valid = 0;
    80002e7c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e80:	854a                	mv	a0,s2
    80002e82:	00001097          	auipc	ra,0x1
    80002e86:	ac8080e7          	jalr	-1336(ra) # 8000394a <releasesleep>
    acquire(&itable.lock);
    80002e8a:	00014517          	auipc	a0,0x14
    80002e8e:	2ee50513          	addi	a0,a0,750 # 80017178 <itable>
    80002e92:	00003097          	auipc	ra,0x3
    80002e96:	3ea080e7          	jalr	1002(ra) # 8000627c <acquire>
    80002e9a:	b741                	j	80002e1a <iput+0x26>

0000000080002e9c <iunlockput>:
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	1000                	addi	s0,sp,32
    80002ea6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	e54080e7          	jalr	-428(ra) # 80002cfc <iunlock>
  iput(ip);
    80002eb0:	8526                	mv	a0,s1
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	f42080e7          	jalr	-190(ra) # 80002df4 <iput>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	64a2                	ld	s1,8(sp)
    80002ec0:	6105                	addi	sp,sp,32
    80002ec2:	8082                	ret

0000000080002ec4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ec4:	1141                	addi	sp,sp,-16
    80002ec6:	e422                	sd	s0,8(sp)
    80002ec8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eca:	411c                	lw	a5,0(a0)
    80002ecc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ece:	415c                	lw	a5,4(a0)
    80002ed0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ed2:	04451783          	lh	a5,68(a0)
    80002ed6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eda:	04a51783          	lh	a5,74(a0)
    80002ede:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ee2:	04c56783          	lwu	a5,76(a0)
    80002ee6:	e99c                	sd	a5,16(a1)
}
    80002ee8:	6422                	ld	s0,8(sp)
    80002eea:	0141                	addi	sp,sp,16
    80002eec:	8082                	ret

0000000080002eee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eee:	457c                	lw	a5,76(a0)
    80002ef0:	0ed7e963          	bltu	a5,a3,80002fe2 <readi+0xf4>
{
    80002ef4:	7159                	addi	sp,sp,-112
    80002ef6:	f486                	sd	ra,104(sp)
    80002ef8:	f0a2                	sd	s0,96(sp)
    80002efa:	eca6                	sd	s1,88(sp)
    80002efc:	e8ca                	sd	s2,80(sp)
    80002efe:	e4ce                	sd	s3,72(sp)
    80002f00:	e0d2                	sd	s4,64(sp)
    80002f02:	fc56                	sd	s5,56(sp)
    80002f04:	f85a                	sd	s6,48(sp)
    80002f06:	f45e                	sd	s7,40(sp)
    80002f08:	f062                	sd	s8,32(sp)
    80002f0a:	ec66                	sd	s9,24(sp)
    80002f0c:	e86a                	sd	s10,16(sp)
    80002f0e:	e46e                	sd	s11,8(sp)
    80002f10:	1880                	addi	s0,sp,112
    80002f12:	8b2a                	mv	s6,a0
    80002f14:	8bae                	mv	s7,a1
    80002f16:	8a32                	mv	s4,a2
    80002f18:	84b6                	mv	s1,a3
    80002f1a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f1c:	9f35                	addw	a4,a4,a3
    return 0;
    80002f1e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f20:	0ad76063          	bltu	a4,a3,80002fc0 <readi+0xd2>
  if(off + n > ip->size)
    80002f24:	00e7f463          	bgeu	a5,a4,80002f2c <readi+0x3e>
    n = ip->size - off;
    80002f28:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2c:	0a0a8963          	beqz	s5,80002fde <readi+0xf0>
    80002f30:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f32:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f36:	5c7d                	li	s8,-1
    80002f38:	a82d                	j	80002f72 <readi+0x84>
    80002f3a:	020d1d93          	slli	s11,s10,0x20
    80002f3e:	020ddd93          	srli	s11,s11,0x20
    80002f42:	05890613          	addi	a2,s2,88
    80002f46:	86ee                	mv	a3,s11
    80002f48:	963a                	add	a2,a2,a4
    80002f4a:	85d2                	mv	a1,s4
    80002f4c:	855e                	mv	a0,s7
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	a0a080e7          	jalr	-1526(ra) # 80001958 <either_copyout>
    80002f56:	05850d63          	beq	a0,s8,80002fb0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	5f4080e7          	jalr	1524(ra) # 80002550 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f64:	013d09bb          	addw	s3,s10,s3
    80002f68:	009d04bb          	addw	s1,s10,s1
    80002f6c:	9a6e                	add	s4,s4,s11
    80002f6e:	0559f763          	bgeu	s3,s5,80002fbc <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f72:	00a4d59b          	srliw	a1,s1,0xa
    80002f76:	855a                	mv	a0,s6
    80002f78:	00000097          	auipc	ra,0x0
    80002f7c:	8a2080e7          	jalr	-1886(ra) # 8000281a <bmap>
    80002f80:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f84:	cd85                	beqz	a1,80002fbc <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f86:	000b2503          	lw	a0,0(s6)
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	496080e7          	jalr	1174(ra) # 80002420 <bread>
    80002f92:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f94:	3ff4f713          	andi	a4,s1,1023
    80002f98:	40ec87bb          	subw	a5,s9,a4
    80002f9c:	413a86bb          	subw	a3,s5,s3
    80002fa0:	8d3e                	mv	s10,a5
    80002fa2:	2781                	sext.w	a5,a5
    80002fa4:	0006861b          	sext.w	a2,a3
    80002fa8:	f8f679e3          	bgeu	a2,a5,80002f3a <readi+0x4c>
    80002fac:	8d36                	mv	s10,a3
    80002fae:	b771                	j	80002f3a <readi+0x4c>
      brelse(bp);
    80002fb0:	854a                	mv	a0,s2
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	59e080e7          	jalr	1438(ra) # 80002550 <brelse>
      tot = -1;
    80002fba:	59fd                	li	s3,-1
  }
  return tot;
    80002fbc:	0009851b          	sext.w	a0,s3
}
    80002fc0:	70a6                	ld	ra,104(sp)
    80002fc2:	7406                	ld	s0,96(sp)
    80002fc4:	64e6                	ld	s1,88(sp)
    80002fc6:	6946                	ld	s2,80(sp)
    80002fc8:	69a6                	ld	s3,72(sp)
    80002fca:	6a06                	ld	s4,64(sp)
    80002fcc:	7ae2                	ld	s5,56(sp)
    80002fce:	7b42                	ld	s6,48(sp)
    80002fd0:	7ba2                	ld	s7,40(sp)
    80002fd2:	7c02                	ld	s8,32(sp)
    80002fd4:	6ce2                	ld	s9,24(sp)
    80002fd6:	6d42                	ld	s10,16(sp)
    80002fd8:	6da2                	ld	s11,8(sp)
    80002fda:	6165                	addi	sp,sp,112
    80002fdc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fde:	89d6                	mv	s3,s5
    80002fe0:	bff1                	j	80002fbc <readi+0xce>
    return 0;
    80002fe2:	4501                	li	a0,0
}
    80002fe4:	8082                	ret

0000000080002fe6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe6:	457c                	lw	a5,76(a0)
    80002fe8:	10d7e863          	bltu	a5,a3,800030f8 <writei+0x112>
{
    80002fec:	7159                	addi	sp,sp,-112
    80002fee:	f486                	sd	ra,104(sp)
    80002ff0:	f0a2                	sd	s0,96(sp)
    80002ff2:	eca6                	sd	s1,88(sp)
    80002ff4:	e8ca                	sd	s2,80(sp)
    80002ff6:	e4ce                	sd	s3,72(sp)
    80002ff8:	e0d2                	sd	s4,64(sp)
    80002ffa:	fc56                	sd	s5,56(sp)
    80002ffc:	f85a                	sd	s6,48(sp)
    80002ffe:	f45e                	sd	s7,40(sp)
    80003000:	f062                	sd	s8,32(sp)
    80003002:	ec66                	sd	s9,24(sp)
    80003004:	e86a                	sd	s10,16(sp)
    80003006:	e46e                	sd	s11,8(sp)
    80003008:	1880                	addi	s0,sp,112
    8000300a:	8aaa                	mv	s5,a0
    8000300c:	8bae                	mv	s7,a1
    8000300e:	8a32                	mv	s4,a2
    80003010:	8936                	mv	s2,a3
    80003012:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003014:	00e687bb          	addw	a5,a3,a4
    80003018:	0ed7e263          	bltu	a5,a3,800030fc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000301c:	00043737          	lui	a4,0x43
    80003020:	0ef76063          	bltu	a4,a5,80003100 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003024:	0c0b0863          	beqz	s6,800030f4 <writei+0x10e>
    80003028:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000302e:	5c7d                	li	s8,-1
    80003030:	a091                	j	80003074 <writei+0x8e>
    80003032:	020d1d93          	slli	s11,s10,0x20
    80003036:	020ddd93          	srli	s11,s11,0x20
    8000303a:	05848513          	addi	a0,s1,88
    8000303e:	86ee                	mv	a3,s11
    80003040:	8652                	mv	a2,s4
    80003042:	85de                	mv	a1,s7
    80003044:	953a                	add	a0,a0,a4
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	968080e7          	jalr	-1688(ra) # 800019ae <either_copyin>
    8000304e:	07850263          	beq	a0,s8,800030b2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	00000097          	auipc	ra,0x0
    80003058:	780080e7          	jalr	1920(ra) # 800037d4 <log_write>
    brelse(bp);
    8000305c:	8526                	mv	a0,s1
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	4f2080e7          	jalr	1266(ra) # 80002550 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003066:	013d09bb          	addw	s3,s10,s3
    8000306a:	012d093b          	addw	s2,s10,s2
    8000306e:	9a6e                	add	s4,s4,s11
    80003070:	0569f663          	bgeu	s3,s6,800030bc <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003074:	00a9559b          	srliw	a1,s2,0xa
    80003078:	8556                	mv	a0,s5
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	7a0080e7          	jalr	1952(ra) # 8000281a <bmap>
    80003082:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003086:	c99d                	beqz	a1,800030bc <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003088:	000aa503          	lw	a0,0(s5)
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	394080e7          	jalr	916(ra) # 80002420 <bread>
    80003094:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003096:	3ff97713          	andi	a4,s2,1023
    8000309a:	40ec87bb          	subw	a5,s9,a4
    8000309e:	413b06bb          	subw	a3,s6,s3
    800030a2:	8d3e                	mv	s10,a5
    800030a4:	2781                	sext.w	a5,a5
    800030a6:	0006861b          	sext.w	a2,a3
    800030aa:	f8f674e3          	bgeu	a2,a5,80003032 <writei+0x4c>
    800030ae:	8d36                	mv	s10,a3
    800030b0:	b749                	j	80003032 <writei+0x4c>
      brelse(bp);
    800030b2:	8526                	mv	a0,s1
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	49c080e7          	jalr	1180(ra) # 80002550 <brelse>
  }

  if(off > ip->size)
    800030bc:	04caa783          	lw	a5,76(s5)
    800030c0:	0127f463          	bgeu	a5,s2,800030c8 <writei+0xe2>
    ip->size = off;
    800030c4:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030c8:	8556                	mv	a0,s5
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	aa6080e7          	jalr	-1370(ra) # 80002b70 <iupdate>

  return tot;
    800030d2:	0009851b          	sext.w	a0,s3
}
    800030d6:	70a6                	ld	ra,104(sp)
    800030d8:	7406                	ld	s0,96(sp)
    800030da:	64e6                	ld	s1,88(sp)
    800030dc:	6946                	ld	s2,80(sp)
    800030de:	69a6                	ld	s3,72(sp)
    800030e0:	6a06                	ld	s4,64(sp)
    800030e2:	7ae2                	ld	s5,56(sp)
    800030e4:	7b42                	ld	s6,48(sp)
    800030e6:	7ba2                	ld	s7,40(sp)
    800030e8:	7c02                	ld	s8,32(sp)
    800030ea:	6ce2                	ld	s9,24(sp)
    800030ec:	6d42                	ld	s10,16(sp)
    800030ee:	6da2                	ld	s11,8(sp)
    800030f0:	6165                	addi	sp,sp,112
    800030f2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f4:	89da                	mv	s3,s6
    800030f6:	bfc9                	j	800030c8 <writei+0xe2>
    return -1;
    800030f8:	557d                	li	a0,-1
}
    800030fa:	8082                	ret
    return -1;
    800030fc:	557d                	li	a0,-1
    800030fe:	bfe1                	j	800030d6 <writei+0xf0>
    return -1;
    80003100:	557d                	li	a0,-1
    80003102:	bfd1                	j	800030d6 <writei+0xf0>

0000000080003104 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003104:	1141                	addi	sp,sp,-16
    80003106:	e406                	sd	ra,8(sp)
    80003108:	e022                	sd	s0,0(sp)
    8000310a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000310c:	4639                	li	a2,14
    8000310e:	ffffd097          	auipc	ra,0xffffd
    80003112:	18e080e7          	jalr	398(ra) # 8000029c <strncmp>
}
    80003116:	60a2                	ld	ra,8(sp)
    80003118:	6402                	ld	s0,0(sp)
    8000311a:	0141                	addi	sp,sp,16
    8000311c:	8082                	ret

000000008000311e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000311e:	7139                	addi	sp,sp,-64
    80003120:	fc06                	sd	ra,56(sp)
    80003122:	f822                	sd	s0,48(sp)
    80003124:	f426                	sd	s1,40(sp)
    80003126:	f04a                	sd	s2,32(sp)
    80003128:	ec4e                	sd	s3,24(sp)
    8000312a:	e852                	sd	s4,16(sp)
    8000312c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000312e:	04451703          	lh	a4,68(a0)
    80003132:	4785                	li	a5,1
    80003134:	00f71a63          	bne	a4,a5,80003148 <dirlookup+0x2a>
    80003138:	892a                	mv	s2,a0
    8000313a:	89ae                	mv	s3,a1
    8000313c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313e:	457c                	lw	a5,76(a0)
    80003140:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003142:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003144:	e79d                	bnez	a5,80003172 <dirlookup+0x54>
    80003146:	a8a5                	j	800031be <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003148:	00005517          	auipc	a0,0x5
    8000314c:	45050513          	addi	a0,a0,1104 # 80008598 <syscalls+0x1b0>
    80003150:	00003097          	auipc	ra,0x3
    80003154:	be2080e7          	jalr	-1054(ra) # 80005d32 <panic>
      panic("dirlookup read");
    80003158:	00005517          	auipc	a0,0x5
    8000315c:	45850513          	addi	a0,a0,1112 # 800085b0 <syscalls+0x1c8>
    80003160:	00003097          	auipc	ra,0x3
    80003164:	bd2080e7          	jalr	-1070(ra) # 80005d32 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003168:	24c1                	addiw	s1,s1,16
    8000316a:	04c92783          	lw	a5,76(s2)
    8000316e:	04f4f763          	bgeu	s1,a5,800031bc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003172:	4741                	li	a4,16
    80003174:	86a6                	mv	a3,s1
    80003176:	fc040613          	addi	a2,s0,-64
    8000317a:	4581                	li	a1,0
    8000317c:	854a                	mv	a0,s2
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	d70080e7          	jalr	-656(ra) # 80002eee <readi>
    80003186:	47c1                	li	a5,16
    80003188:	fcf518e3          	bne	a0,a5,80003158 <dirlookup+0x3a>
    if(de.inum == 0)
    8000318c:	fc045783          	lhu	a5,-64(s0)
    80003190:	dfe1                	beqz	a5,80003168 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003192:	fc240593          	addi	a1,s0,-62
    80003196:	854e                	mv	a0,s3
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	f6c080e7          	jalr	-148(ra) # 80003104 <namecmp>
    800031a0:	f561                	bnez	a0,80003168 <dirlookup+0x4a>
      if(poff)
    800031a2:	000a0463          	beqz	s4,800031aa <dirlookup+0x8c>
        *poff = off;
    800031a6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031aa:	fc045583          	lhu	a1,-64(s0)
    800031ae:	00092503          	lw	a0,0(s2)
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	750080e7          	jalr	1872(ra) # 80002902 <iget>
    800031ba:	a011                	j	800031be <dirlookup+0xa0>
  return 0;
    800031bc:	4501                	li	a0,0
}
    800031be:	70e2                	ld	ra,56(sp)
    800031c0:	7442                	ld	s0,48(sp)
    800031c2:	74a2                	ld	s1,40(sp)
    800031c4:	7902                	ld	s2,32(sp)
    800031c6:	69e2                	ld	s3,24(sp)
    800031c8:	6a42                	ld	s4,16(sp)
    800031ca:	6121                	addi	sp,sp,64
    800031cc:	8082                	ret

00000000800031ce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031ce:	711d                	addi	sp,sp,-96
    800031d0:	ec86                	sd	ra,88(sp)
    800031d2:	e8a2                	sd	s0,80(sp)
    800031d4:	e4a6                	sd	s1,72(sp)
    800031d6:	e0ca                	sd	s2,64(sp)
    800031d8:	fc4e                	sd	s3,56(sp)
    800031da:	f852                	sd	s4,48(sp)
    800031dc:	f456                	sd	s5,40(sp)
    800031de:	f05a                	sd	s6,32(sp)
    800031e0:	ec5e                	sd	s7,24(sp)
    800031e2:	e862                	sd	s8,16(sp)
    800031e4:	e466                	sd	s9,8(sp)
    800031e6:	1080                	addi	s0,sp,96
    800031e8:	84aa                	mv	s1,a0
    800031ea:	8b2e                	mv	s6,a1
    800031ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ee:	00054703          	lbu	a4,0(a0)
    800031f2:	02f00793          	li	a5,47
    800031f6:	02f70363          	beq	a4,a5,8000321c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031fa:	ffffe097          	auipc	ra,0xffffe
    800031fe:	caa080e7          	jalr	-854(ra) # 80000ea4 <myproc>
    80003202:	15053503          	ld	a0,336(a0)
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	9f6080e7          	jalr	-1546(ra) # 80002bfc <idup>
    8000320e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003210:	02f00913          	li	s2,47
  len = path - s;
    80003214:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003216:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003218:	4c05                	li	s8,1
    8000321a:	a865                	j	800032d2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000321c:	4585                	li	a1,1
    8000321e:	4505                	li	a0,1
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	6e2080e7          	jalr	1762(ra) # 80002902 <iget>
    80003228:	89aa                	mv	s3,a0
    8000322a:	b7dd                	j	80003210 <namex+0x42>
      iunlockput(ip);
    8000322c:	854e                	mv	a0,s3
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	c6e080e7          	jalr	-914(ra) # 80002e9c <iunlockput>
      return 0;
    80003236:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003238:	854e                	mv	a0,s3
    8000323a:	60e6                	ld	ra,88(sp)
    8000323c:	6446                	ld	s0,80(sp)
    8000323e:	64a6                	ld	s1,72(sp)
    80003240:	6906                	ld	s2,64(sp)
    80003242:	79e2                	ld	s3,56(sp)
    80003244:	7a42                	ld	s4,48(sp)
    80003246:	7aa2                	ld	s5,40(sp)
    80003248:	7b02                	ld	s6,32(sp)
    8000324a:	6be2                	ld	s7,24(sp)
    8000324c:	6c42                	ld	s8,16(sp)
    8000324e:	6ca2                	ld	s9,8(sp)
    80003250:	6125                	addi	sp,sp,96
    80003252:	8082                	ret
      iunlock(ip);
    80003254:	854e                	mv	a0,s3
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	aa6080e7          	jalr	-1370(ra) # 80002cfc <iunlock>
      return ip;
    8000325e:	bfe9                	j	80003238 <namex+0x6a>
      iunlockput(ip);
    80003260:	854e                	mv	a0,s3
    80003262:	00000097          	auipc	ra,0x0
    80003266:	c3a080e7          	jalr	-966(ra) # 80002e9c <iunlockput>
      return 0;
    8000326a:	89d2                	mv	s3,s4
    8000326c:	b7f1                	j	80003238 <namex+0x6a>
  len = path - s;
    8000326e:	40b48633          	sub	a2,s1,a1
    80003272:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003276:	094cd463          	bge	s9,s4,800032fe <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000327a:	4639                	li	a2,14
    8000327c:	8556                	mv	a0,s5
    8000327e:	ffffd097          	auipc	ra,0xffffd
    80003282:	fa6080e7          	jalr	-90(ra) # 80000224 <memmove>
  while(*path == '/')
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	01279763          	bne	a5,s2,80003298 <namex+0xca>
    path++;
    8000328e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	ff278de3          	beq	a5,s2,8000328e <namex+0xc0>
    ilock(ip);
    80003298:	854e                	mv	a0,s3
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	9a0080e7          	jalr	-1632(ra) # 80002c3a <ilock>
    if(ip->type != T_DIR){
    800032a2:	04499783          	lh	a5,68(s3)
    800032a6:	f98793e3          	bne	a5,s8,8000322c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032aa:	000b0563          	beqz	s6,800032b4 <namex+0xe6>
    800032ae:	0004c783          	lbu	a5,0(s1)
    800032b2:	d3cd                	beqz	a5,80003254 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032b4:	865e                	mv	a2,s7
    800032b6:	85d6                	mv	a1,s5
    800032b8:	854e                	mv	a0,s3
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	e64080e7          	jalr	-412(ra) # 8000311e <dirlookup>
    800032c2:	8a2a                	mv	s4,a0
    800032c4:	dd51                	beqz	a0,80003260 <namex+0x92>
    iunlockput(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	bd4080e7          	jalr	-1068(ra) # 80002e9c <iunlockput>
    ip = next;
    800032d0:	89d2                	mv	s3,s4
  while(*path == '/')
    800032d2:	0004c783          	lbu	a5,0(s1)
    800032d6:	05279763          	bne	a5,s2,80003324 <namex+0x156>
    path++;
    800032da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032dc:	0004c783          	lbu	a5,0(s1)
    800032e0:	ff278de3          	beq	a5,s2,800032da <namex+0x10c>
  if(*path == 0)
    800032e4:	c79d                	beqz	a5,80003312 <namex+0x144>
    path++;
    800032e6:	85a6                	mv	a1,s1
  len = path - s;
    800032e8:	8a5e                	mv	s4,s7
    800032ea:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032ec:	01278963          	beq	a5,s2,800032fe <namex+0x130>
    800032f0:	dfbd                	beqz	a5,8000326e <namex+0xa0>
    path++;
    800032f2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	ff279ce3          	bne	a5,s2,800032f0 <namex+0x122>
    800032fc:	bf8d                	j	8000326e <namex+0xa0>
    memmove(name, s, len);
    800032fe:	2601                	sext.w	a2,a2
    80003300:	8556                	mv	a0,s5
    80003302:	ffffd097          	auipc	ra,0xffffd
    80003306:	f22080e7          	jalr	-222(ra) # 80000224 <memmove>
    name[len] = 0;
    8000330a:	9a56                	add	s4,s4,s5
    8000330c:	000a0023          	sb	zero,0(s4)
    80003310:	bf9d                	j	80003286 <namex+0xb8>
  if(nameiparent){
    80003312:	f20b03e3          	beqz	s6,80003238 <namex+0x6a>
    iput(ip);
    80003316:	854e                	mv	a0,s3
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	adc080e7          	jalr	-1316(ra) # 80002df4 <iput>
    return 0;
    80003320:	4981                	li	s3,0
    80003322:	bf19                	j	80003238 <namex+0x6a>
  if(*path == 0)
    80003324:	d7fd                	beqz	a5,80003312 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003326:	0004c783          	lbu	a5,0(s1)
    8000332a:	85a6                	mv	a1,s1
    8000332c:	b7d1                	j	800032f0 <namex+0x122>

000000008000332e <dirlink>:
{
    8000332e:	7139                	addi	sp,sp,-64
    80003330:	fc06                	sd	ra,56(sp)
    80003332:	f822                	sd	s0,48(sp)
    80003334:	f426                	sd	s1,40(sp)
    80003336:	f04a                	sd	s2,32(sp)
    80003338:	ec4e                	sd	s3,24(sp)
    8000333a:	e852                	sd	s4,16(sp)
    8000333c:	0080                	addi	s0,sp,64
    8000333e:	892a                	mv	s2,a0
    80003340:	8a2e                	mv	s4,a1
    80003342:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003344:	4601                	li	a2,0
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	dd8080e7          	jalr	-552(ra) # 8000311e <dirlookup>
    8000334e:	e93d                	bnez	a0,800033c4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003350:	04c92483          	lw	s1,76(s2)
    80003354:	c49d                	beqz	s1,80003382 <dirlink+0x54>
    80003356:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003358:	4741                	li	a4,16
    8000335a:	86a6                	mv	a3,s1
    8000335c:	fc040613          	addi	a2,s0,-64
    80003360:	4581                	li	a1,0
    80003362:	854a                	mv	a0,s2
    80003364:	00000097          	auipc	ra,0x0
    80003368:	b8a080e7          	jalr	-1142(ra) # 80002eee <readi>
    8000336c:	47c1                	li	a5,16
    8000336e:	06f51163          	bne	a0,a5,800033d0 <dirlink+0xa2>
    if(de.inum == 0)
    80003372:	fc045783          	lhu	a5,-64(s0)
    80003376:	c791                	beqz	a5,80003382 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003378:	24c1                	addiw	s1,s1,16
    8000337a:	04c92783          	lw	a5,76(s2)
    8000337e:	fcf4ede3          	bltu	s1,a5,80003358 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003382:	4639                	li	a2,14
    80003384:	85d2                	mv	a1,s4
    80003386:	fc240513          	addi	a0,s0,-62
    8000338a:	ffffd097          	auipc	ra,0xffffd
    8000338e:	f4e080e7          	jalr	-178(ra) # 800002d8 <strncpy>
  de.inum = inum;
    80003392:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003396:	4741                	li	a4,16
    80003398:	86a6                	mv	a3,s1
    8000339a:	fc040613          	addi	a2,s0,-64
    8000339e:	4581                	li	a1,0
    800033a0:	854a                	mv	a0,s2
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	c44080e7          	jalr	-956(ra) # 80002fe6 <writei>
    800033aa:	1541                	addi	a0,a0,-16
    800033ac:	00a03533          	snez	a0,a0
    800033b0:	40a00533          	neg	a0,a0
}
    800033b4:	70e2                	ld	ra,56(sp)
    800033b6:	7442                	ld	s0,48(sp)
    800033b8:	74a2                	ld	s1,40(sp)
    800033ba:	7902                	ld	s2,32(sp)
    800033bc:	69e2                	ld	s3,24(sp)
    800033be:	6a42                	ld	s4,16(sp)
    800033c0:	6121                	addi	sp,sp,64
    800033c2:	8082                	ret
    iput(ip);
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	a30080e7          	jalr	-1488(ra) # 80002df4 <iput>
    return -1;
    800033cc:	557d                	li	a0,-1
    800033ce:	b7dd                	j	800033b4 <dirlink+0x86>
      panic("dirlink read");
    800033d0:	00005517          	auipc	a0,0x5
    800033d4:	1f050513          	addi	a0,a0,496 # 800085c0 <syscalls+0x1d8>
    800033d8:	00003097          	auipc	ra,0x3
    800033dc:	95a080e7          	jalr	-1702(ra) # 80005d32 <panic>

00000000800033e0 <namei>:

struct inode*
namei(char *path)
{
    800033e0:	1101                	addi	sp,sp,-32
    800033e2:	ec06                	sd	ra,24(sp)
    800033e4:	e822                	sd	s0,16(sp)
    800033e6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033e8:	fe040613          	addi	a2,s0,-32
    800033ec:	4581                	li	a1,0
    800033ee:	00000097          	auipc	ra,0x0
    800033f2:	de0080e7          	jalr	-544(ra) # 800031ce <namex>
}
    800033f6:	60e2                	ld	ra,24(sp)
    800033f8:	6442                	ld	s0,16(sp)
    800033fa:	6105                	addi	sp,sp,32
    800033fc:	8082                	ret

00000000800033fe <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033fe:	1141                	addi	sp,sp,-16
    80003400:	e406                	sd	ra,8(sp)
    80003402:	e022                	sd	s0,0(sp)
    80003404:	0800                	addi	s0,sp,16
    80003406:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003408:	4585                	li	a1,1
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	dc4080e7          	jalr	-572(ra) # 800031ce <namex>
}
    80003412:	60a2                	ld	ra,8(sp)
    80003414:	6402                	ld	s0,0(sp)
    80003416:	0141                	addi	sp,sp,16
    80003418:	8082                	ret

000000008000341a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000341a:	1101                	addi	sp,sp,-32
    8000341c:	ec06                	sd	ra,24(sp)
    8000341e:	e822                	sd	s0,16(sp)
    80003420:	e426                	sd	s1,8(sp)
    80003422:	e04a                	sd	s2,0(sp)
    80003424:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003426:	00015917          	auipc	s2,0x15
    8000342a:	7fa90913          	addi	s2,s2,2042 # 80018c20 <log>
    8000342e:	01892583          	lw	a1,24(s2)
    80003432:	02892503          	lw	a0,40(s2)
    80003436:	fffff097          	auipc	ra,0xfffff
    8000343a:	fea080e7          	jalr	-22(ra) # 80002420 <bread>
    8000343e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003440:	02c92683          	lw	a3,44(s2)
    80003444:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003446:	02d05763          	blez	a3,80003474 <write_head+0x5a>
    8000344a:	00016797          	auipc	a5,0x16
    8000344e:	80678793          	addi	a5,a5,-2042 # 80018c50 <log+0x30>
    80003452:	05c50713          	addi	a4,a0,92
    80003456:	36fd                	addiw	a3,a3,-1
    80003458:	1682                	slli	a3,a3,0x20
    8000345a:	9281                	srli	a3,a3,0x20
    8000345c:	068a                	slli	a3,a3,0x2
    8000345e:	00015617          	auipc	a2,0x15
    80003462:	7f660613          	addi	a2,a2,2038 # 80018c54 <log+0x34>
    80003466:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003468:	4390                	lw	a2,0(a5)
    8000346a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000346c:	0791                	addi	a5,a5,4
    8000346e:	0711                	addi	a4,a4,4
    80003470:	fed79ce3          	bne	a5,a3,80003468 <write_head+0x4e>
  }
  bwrite(buf);
    80003474:	8526                	mv	a0,s1
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	09c080e7          	jalr	156(ra) # 80002512 <bwrite>
  brelse(buf);
    8000347e:	8526                	mv	a0,s1
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	0d0080e7          	jalr	208(ra) # 80002550 <brelse>
}
    80003488:	60e2                	ld	ra,24(sp)
    8000348a:	6442                	ld	s0,16(sp)
    8000348c:	64a2                	ld	s1,8(sp)
    8000348e:	6902                	ld	s2,0(sp)
    80003490:	6105                	addi	sp,sp,32
    80003492:	8082                	ret

0000000080003494 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003494:	00015797          	auipc	a5,0x15
    80003498:	7b87a783          	lw	a5,1976(a5) # 80018c4c <log+0x2c>
    8000349c:	0af05d63          	blez	a5,80003556 <install_trans+0xc2>
{
    800034a0:	7139                	addi	sp,sp,-64
    800034a2:	fc06                	sd	ra,56(sp)
    800034a4:	f822                	sd	s0,48(sp)
    800034a6:	f426                	sd	s1,40(sp)
    800034a8:	f04a                	sd	s2,32(sp)
    800034aa:	ec4e                	sd	s3,24(sp)
    800034ac:	e852                	sd	s4,16(sp)
    800034ae:	e456                	sd	s5,8(sp)
    800034b0:	e05a                	sd	s6,0(sp)
    800034b2:	0080                	addi	s0,sp,64
    800034b4:	8b2a                	mv	s6,a0
    800034b6:	00015a97          	auipc	s5,0x15
    800034ba:	79aa8a93          	addi	s5,s5,1946 # 80018c50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034be:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c0:	00015997          	auipc	s3,0x15
    800034c4:	76098993          	addi	s3,s3,1888 # 80018c20 <log>
    800034c8:	a035                	j	800034f4 <install_trans+0x60>
      bunpin(dbuf);
    800034ca:	8526                	mv	a0,s1
    800034cc:	fffff097          	auipc	ra,0xfffff
    800034d0:	15e080e7          	jalr	350(ra) # 8000262a <bunpin>
    brelse(lbuf);
    800034d4:	854a                	mv	a0,s2
    800034d6:	fffff097          	auipc	ra,0xfffff
    800034da:	07a080e7          	jalr	122(ra) # 80002550 <brelse>
    brelse(dbuf);
    800034de:	8526                	mv	a0,s1
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	070080e7          	jalr	112(ra) # 80002550 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e8:	2a05                	addiw	s4,s4,1
    800034ea:	0a91                	addi	s5,s5,4
    800034ec:	02c9a783          	lw	a5,44(s3)
    800034f0:	04fa5963          	bge	s4,a5,80003542 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f4:	0189a583          	lw	a1,24(s3)
    800034f8:	014585bb          	addw	a1,a1,s4
    800034fc:	2585                	addiw	a1,a1,1
    800034fe:	0289a503          	lw	a0,40(s3)
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	f1e080e7          	jalr	-226(ra) # 80002420 <bread>
    8000350a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000350c:	000aa583          	lw	a1,0(s5)
    80003510:	0289a503          	lw	a0,40(s3)
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	f0c080e7          	jalr	-244(ra) # 80002420 <bread>
    8000351c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000351e:	40000613          	li	a2,1024
    80003522:	05890593          	addi	a1,s2,88
    80003526:	05850513          	addi	a0,a0,88
    8000352a:	ffffd097          	auipc	ra,0xffffd
    8000352e:	cfa080e7          	jalr	-774(ra) # 80000224 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003532:	8526                	mv	a0,s1
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	fde080e7          	jalr	-34(ra) # 80002512 <bwrite>
    if(recovering == 0)
    8000353c:	f80b1ce3          	bnez	s6,800034d4 <install_trans+0x40>
    80003540:	b769                	j	800034ca <install_trans+0x36>
}
    80003542:	70e2                	ld	ra,56(sp)
    80003544:	7442                	ld	s0,48(sp)
    80003546:	74a2                	ld	s1,40(sp)
    80003548:	7902                	ld	s2,32(sp)
    8000354a:	69e2                	ld	s3,24(sp)
    8000354c:	6a42                	ld	s4,16(sp)
    8000354e:	6aa2                	ld	s5,8(sp)
    80003550:	6b02                	ld	s6,0(sp)
    80003552:	6121                	addi	sp,sp,64
    80003554:	8082                	ret
    80003556:	8082                	ret

0000000080003558 <initlog>:
{
    80003558:	7179                	addi	sp,sp,-48
    8000355a:	f406                	sd	ra,40(sp)
    8000355c:	f022                	sd	s0,32(sp)
    8000355e:	ec26                	sd	s1,24(sp)
    80003560:	e84a                	sd	s2,16(sp)
    80003562:	e44e                	sd	s3,8(sp)
    80003564:	1800                	addi	s0,sp,48
    80003566:	892a                	mv	s2,a0
    80003568:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000356a:	00015497          	auipc	s1,0x15
    8000356e:	6b648493          	addi	s1,s1,1718 # 80018c20 <log>
    80003572:	00005597          	auipc	a1,0x5
    80003576:	05e58593          	addi	a1,a1,94 # 800085d0 <syscalls+0x1e8>
    8000357a:	8526                	mv	a0,s1
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	c70080e7          	jalr	-912(ra) # 800061ec <initlock>
  log.start = sb->logstart;
    80003584:	0149a583          	lw	a1,20(s3)
    80003588:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000358a:	0109a783          	lw	a5,16(s3)
    8000358e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003590:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003594:	854a                	mv	a0,s2
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	e8a080e7          	jalr	-374(ra) # 80002420 <bread>
  log.lh.n = lh->n;
    8000359e:	4d3c                	lw	a5,88(a0)
    800035a0:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035a2:	02f05563          	blez	a5,800035cc <initlog+0x74>
    800035a6:	05c50713          	addi	a4,a0,92
    800035aa:	00015697          	auipc	a3,0x15
    800035ae:	6a668693          	addi	a3,a3,1702 # 80018c50 <log+0x30>
    800035b2:	37fd                	addiw	a5,a5,-1
    800035b4:	1782                	slli	a5,a5,0x20
    800035b6:	9381                	srli	a5,a5,0x20
    800035b8:	078a                	slli	a5,a5,0x2
    800035ba:	06050613          	addi	a2,a0,96
    800035be:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035c0:	4310                	lw	a2,0(a4)
    800035c2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035c4:	0711                	addi	a4,a4,4
    800035c6:	0691                	addi	a3,a3,4
    800035c8:	fef71ce3          	bne	a4,a5,800035c0 <initlog+0x68>
  brelse(buf);
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	f84080e7          	jalr	-124(ra) # 80002550 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035d4:	4505                	li	a0,1
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	ebe080e7          	jalr	-322(ra) # 80003494 <install_trans>
  log.lh.n = 0;
    800035de:	00015797          	auipc	a5,0x15
    800035e2:	6607a723          	sw	zero,1646(a5) # 80018c4c <log+0x2c>
  write_head(); // clear the log
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	e34080e7          	jalr	-460(ra) # 8000341a <write_head>
}
    800035ee:	70a2                	ld	ra,40(sp)
    800035f0:	7402                	ld	s0,32(sp)
    800035f2:	64e2                	ld	s1,24(sp)
    800035f4:	6942                	ld	s2,16(sp)
    800035f6:	69a2                	ld	s3,8(sp)
    800035f8:	6145                	addi	sp,sp,48
    800035fa:	8082                	ret

00000000800035fc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035fc:	1101                	addi	sp,sp,-32
    800035fe:	ec06                	sd	ra,24(sp)
    80003600:	e822                	sd	s0,16(sp)
    80003602:	e426                	sd	s1,8(sp)
    80003604:	e04a                	sd	s2,0(sp)
    80003606:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003608:	00015517          	auipc	a0,0x15
    8000360c:	61850513          	addi	a0,a0,1560 # 80018c20 <log>
    80003610:	00003097          	auipc	ra,0x3
    80003614:	c6c080e7          	jalr	-916(ra) # 8000627c <acquire>
  while(1){
    if(log.committing){
    80003618:	00015497          	auipc	s1,0x15
    8000361c:	60848493          	addi	s1,s1,1544 # 80018c20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003620:	4979                	li	s2,30
    80003622:	a039                	j	80003630 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003624:	85a6                	mv	a1,s1
    80003626:	8526                	mv	a0,s1
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	f28080e7          	jalr	-216(ra) # 80001550 <sleep>
    if(log.committing){
    80003630:	50dc                	lw	a5,36(s1)
    80003632:	fbed                	bnez	a5,80003624 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003634:	509c                	lw	a5,32(s1)
    80003636:	0017871b          	addiw	a4,a5,1
    8000363a:	0007069b          	sext.w	a3,a4
    8000363e:	0027179b          	slliw	a5,a4,0x2
    80003642:	9fb9                	addw	a5,a5,a4
    80003644:	0017979b          	slliw	a5,a5,0x1
    80003648:	54d8                	lw	a4,44(s1)
    8000364a:	9fb9                	addw	a5,a5,a4
    8000364c:	00f95963          	bge	s2,a5,8000365e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003650:	85a6                	mv	a1,s1
    80003652:	8526                	mv	a0,s1
    80003654:	ffffe097          	auipc	ra,0xffffe
    80003658:	efc080e7          	jalr	-260(ra) # 80001550 <sleep>
    8000365c:	bfd1                	j	80003630 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000365e:	00015517          	auipc	a0,0x15
    80003662:	5c250513          	addi	a0,a0,1474 # 80018c20 <log>
    80003666:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003668:	00003097          	auipc	ra,0x3
    8000366c:	cc8080e7          	jalr	-824(ra) # 80006330 <release>
      break;
    }
  }
}
    80003670:	60e2                	ld	ra,24(sp)
    80003672:	6442                	ld	s0,16(sp)
    80003674:	64a2                	ld	s1,8(sp)
    80003676:	6902                	ld	s2,0(sp)
    80003678:	6105                	addi	sp,sp,32
    8000367a:	8082                	ret

000000008000367c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000367c:	7139                	addi	sp,sp,-64
    8000367e:	fc06                	sd	ra,56(sp)
    80003680:	f822                	sd	s0,48(sp)
    80003682:	f426                	sd	s1,40(sp)
    80003684:	f04a                	sd	s2,32(sp)
    80003686:	ec4e                	sd	s3,24(sp)
    80003688:	e852                	sd	s4,16(sp)
    8000368a:	e456                	sd	s5,8(sp)
    8000368c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000368e:	00015497          	auipc	s1,0x15
    80003692:	59248493          	addi	s1,s1,1426 # 80018c20 <log>
    80003696:	8526                	mv	a0,s1
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	be4080e7          	jalr	-1052(ra) # 8000627c <acquire>
  log.outstanding -= 1;
    800036a0:	509c                	lw	a5,32(s1)
    800036a2:	37fd                	addiw	a5,a5,-1
    800036a4:	0007891b          	sext.w	s2,a5
    800036a8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036aa:	50dc                	lw	a5,36(s1)
    800036ac:	efb9                	bnez	a5,8000370a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036ae:	06091663          	bnez	s2,8000371a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036b2:	00015497          	auipc	s1,0x15
    800036b6:	56e48493          	addi	s1,s1,1390 # 80018c20 <log>
    800036ba:	4785                	li	a5,1
    800036bc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036be:	8526                	mv	a0,s1
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	c70080e7          	jalr	-912(ra) # 80006330 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036c8:	54dc                	lw	a5,44(s1)
    800036ca:	06f04763          	bgtz	a5,80003738 <end_op+0xbc>
    acquire(&log.lock);
    800036ce:	00015497          	auipc	s1,0x15
    800036d2:	55248493          	addi	s1,s1,1362 # 80018c20 <log>
    800036d6:	8526                	mv	a0,s1
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	ba4080e7          	jalr	-1116(ra) # 8000627c <acquire>
    log.committing = 0;
    800036e0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036e4:	8526                	mv	a0,s1
    800036e6:	ffffe097          	auipc	ra,0xffffe
    800036ea:	ece080e7          	jalr	-306(ra) # 800015b4 <wakeup>
    release(&log.lock);
    800036ee:	8526                	mv	a0,s1
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	c40080e7          	jalr	-960(ra) # 80006330 <release>
}
    800036f8:	70e2                	ld	ra,56(sp)
    800036fa:	7442                	ld	s0,48(sp)
    800036fc:	74a2                	ld	s1,40(sp)
    800036fe:	7902                	ld	s2,32(sp)
    80003700:	69e2                	ld	s3,24(sp)
    80003702:	6a42                	ld	s4,16(sp)
    80003704:	6aa2                	ld	s5,8(sp)
    80003706:	6121                	addi	sp,sp,64
    80003708:	8082                	ret
    panic("log.committing");
    8000370a:	00005517          	auipc	a0,0x5
    8000370e:	ece50513          	addi	a0,a0,-306 # 800085d8 <syscalls+0x1f0>
    80003712:	00002097          	auipc	ra,0x2
    80003716:	620080e7          	jalr	1568(ra) # 80005d32 <panic>
    wakeup(&log);
    8000371a:	00015497          	auipc	s1,0x15
    8000371e:	50648493          	addi	s1,s1,1286 # 80018c20 <log>
    80003722:	8526                	mv	a0,s1
    80003724:	ffffe097          	auipc	ra,0xffffe
    80003728:	e90080e7          	jalr	-368(ra) # 800015b4 <wakeup>
  release(&log.lock);
    8000372c:	8526                	mv	a0,s1
    8000372e:	00003097          	auipc	ra,0x3
    80003732:	c02080e7          	jalr	-1022(ra) # 80006330 <release>
  if(do_commit){
    80003736:	b7c9                	j	800036f8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003738:	00015a97          	auipc	s5,0x15
    8000373c:	518a8a93          	addi	s5,s5,1304 # 80018c50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003740:	00015a17          	auipc	s4,0x15
    80003744:	4e0a0a13          	addi	s4,s4,1248 # 80018c20 <log>
    80003748:	018a2583          	lw	a1,24(s4)
    8000374c:	012585bb          	addw	a1,a1,s2
    80003750:	2585                	addiw	a1,a1,1
    80003752:	028a2503          	lw	a0,40(s4)
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	cca080e7          	jalr	-822(ra) # 80002420 <bread>
    8000375e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003760:	000aa583          	lw	a1,0(s5)
    80003764:	028a2503          	lw	a0,40(s4)
    80003768:	fffff097          	auipc	ra,0xfffff
    8000376c:	cb8080e7          	jalr	-840(ra) # 80002420 <bread>
    80003770:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003772:	40000613          	li	a2,1024
    80003776:	05850593          	addi	a1,a0,88
    8000377a:	05848513          	addi	a0,s1,88
    8000377e:	ffffd097          	auipc	ra,0xffffd
    80003782:	aa6080e7          	jalr	-1370(ra) # 80000224 <memmove>
    bwrite(to);  // write the log
    80003786:	8526                	mv	a0,s1
    80003788:	fffff097          	auipc	ra,0xfffff
    8000378c:	d8a080e7          	jalr	-630(ra) # 80002512 <bwrite>
    brelse(from);
    80003790:	854e                	mv	a0,s3
    80003792:	fffff097          	auipc	ra,0xfffff
    80003796:	dbe080e7          	jalr	-578(ra) # 80002550 <brelse>
    brelse(to);
    8000379a:	8526                	mv	a0,s1
    8000379c:	fffff097          	auipc	ra,0xfffff
    800037a0:	db4080e7          	jalr	-588(ra) # 80002550 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a4:	2905                	addiw	s2,s2,1
    800037a6:	0a91                	addi	s5,s5,4
    800037a8:	02ca2783          	lw	a5,44(s4)
    800037ac:	f8f94ee3          	blt	s2,a5,80003748 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	c6a080e7          	jalr	-918(ra) # 8000341a <write_head>
    install_trans(0); // Now install writes to home locations
    800037b8:	4501                	li	a0,0
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	cda080e7          	jalr	-806(ra) # 80003494 <install_trans>
    log.lh.n = 0;
    800037c2:	00015797          	auipc	a5,0x15
    800037c6:	4807a523          	sw	zero,1162(a5) # 80018c4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	c50080e7          	jalr	-944(ra) # 8000341a <write_head>
    800037d2:	bdf5                	j	800036ce <end_op+0x52>

00000000800037d4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037d4:	1101                	addi	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	e426                	sd	s1,8(sp)
    800037dc:	e04a                	sd	s2,0(sp)
    800037de:	1000                	addi	s0,sp,32
    800037e0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037e2:	00015917          	auipc	s2,0x15
    800037e6:	43e90913          	addi	s2,s2,1086 # 80018c20 <log>
    800037ea:	854a                	mv	a0,s2
    800037ec:	00003097          	auipc	ra,0x3
    800037f0:	a90080e7          	jalr	-1392(ra) # 8000627c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037f4:	02c92603          	lw	a2,44(s2)
    800037f8:	47f5                	li	a5,29
    800037fa:	06c7c563          	blt	a5,a2,80003864 <log_write+0x90>
    800037fe:	00015797          	auipc	a5,0x15
    80003802:	43e7a783          	lw	a5,1086(a5) # 80018c3c <log+0x1c>
    80003806:	37fd                	addiw	a5,a5,-1
    80003808:	04f65e63          	bge	a2,a5,80003864 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000380c:	00015797          	auipc	a5,0x15
    80003810:	4347a783          	lw	a5,1076(a5) # 80018c40 <log+0x20>
    80003814:	06f05063          	blez	a5,80003874 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003818:	4781                	li	a5,0
    8000381a:	06c05563          	blez	a2,80003884 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381e:	44cc                	lw	a1,12(s1)
    80003820:	00015717          	auipc	a4,0x15
    80003824:	43070713          	addi	a4,a4,1072 # 80018c50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003828:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000382a:	4314                	lw	a3,0(a4)
    8000382c:	04b68c63          	beq	a3,a1,80003884 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003830:	2785                	addiw	a5,a5,1
    80003832:	0711                	addi	a4,a4,4
    80003834:	fef61be3          	bne	a2,a5,8000382a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003838:	0621                	addi	a2,a2,8
    8000383a:	060a                	slli	a2,a2,0x2
    8000383c:	00015797          	auipc	a5,0x15
    80003840:	3e478793          	addi	a5,a5,996 # 80018c20 <log>
    80003844:	963e                	add	a2,a2,a5
    80003846:	44dc                	lw	a5,12(s1)
    80003848:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000384a:	8526                	mv	a0,s1
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	da2080e7          	jalr	-606(ra) # 800025ee <bpin>
    log.lh.n++;
    80003854:	00015717          	auipc	a4,0x15
    80003858:	3cc70713          	addi	a4,a4,972 # 80018c20 <log>
    8000385c:	575c                	lw	a5,44(a4)
    8000385e:	2785                	addiw	a5,a5,1
    80003860:	d75c                	sw	a5,44(a4)
    80003862:	a835                	j	8000389e <log_write+0xca>
    panic("too big a transaction");
    80003864:	00005517          	auipc	a0,0x5
    80003868:	d8450513          	addi	a0,a0,-636 # 800085e8 <syscalls+0x200>
    8000386c:	00002097          	auipc	ra,0x2
    80003870:	4c6080e7          	jalr	1222(ra) # 80005d32 <panic>
    panic("log_write outside of trans");
    80003874:	00005517          	auipc	a0,0x5
    80003878:	d8c50513          	addi	a0,a0,-628 # 80008600 <syscalls+0x218>
    8000387c:	00002097          	auipc	ra,0x2
    80003880:	4b6080e7          	jalr	1206(ra) # 80005d32 <panic>
  log.lh.block[i] = b->blockno;
    80003884:	00878713          	addi	a4,a5,8
    80003888:	00271693          	slli	a3,a4,0x2
    8000388c:	00015717          	auipc	a4,0x15
    80003890:	39470713          	addi	a4,a4,916 # 80018c20 <log>
    80003894:	9736                	add	a4,a4,a3
    80003896:	44d4                	lw	a3,12(s1)
    80003898:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000389a:	faf608e3          	beq	a2,a5,8000384a <log_write+0x76>
  }
  release(&log.lock);
    8000389e:	00015517          	auipc	a0,0x15
    800038a2:	38250513          	addi	a0,a0,898 # 80018c20 <log>
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	a8a080e7          	jalr	-1398(ra) # 80006330 <release>
}
    800038ae:	60e2                	ld	ra,24(sp)
    800038b0:	6442                	ld	s0,16(sp)
    800038b2:	64a2                	ld	s1,8(sp)
    800038b4:	6902                	ld	s2,0(sp)
    800038b6:	6105                	addi	sp,sp,32
    800038b8:	8082                	ret

00000000800038ba <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038ba:	1101                	addi	sp,sp,-32
    800038bc:	ec06                	sd	ra,24(sp)
    800038be:	e822                	sd	s0,16(sp)
    800038c0:	e426                	sd	s1,8(sp)
    800038c2:	e04a                	sd	s2,0(sp)
    800038c4:	1000                	addi	s0,sp,32
    800038c6:	84aa                	mv	s1,a0
    800038c8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038ca:	00005597          	auipc	a1,0x5
    800038ce:	d5658593          	addi	a1,a1,-682 # 80008620 <syscalls+0x238>
    800038d2:	0521                	addi	a0,a0,8
    800038d4:	00003097          	auipc	ra,0x3
    800038d8:	918080e7          	jalr	-1768(ra) # 800061ec <initlock>
  lk->name = name;
    800038dc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e4:	0204a423          	sw	zero,40(s1)
}
    800038e8:	60e2                	ld	ra,24(sp)
    800038ea:	6442                	ld	s0,16(sp)
    800038ec:	64a2                	ld	s1,8(sp)
    800038ee:	6902                	ld	s2,0(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003902:	00850913          	addi	s2,a0,8
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	974080e7          	jalr	-1676(ra) # 8000627c <acquire>
  while (lk->locked) {
    80003910:	409c                	lw	a5,0(s1)
    80003912:	cb89                	beqz	a5,80003924 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003914:	85ca                	mv	a1,s2
    80003916:	8526                	mv	a0,s1
    80003918:	ffffe097          	auipc	ra,0xffffe
    8000391c:	c38080e7          	jalr	-968(ra) # 80001550 <sleep>
  while (lk->locked) {
    80003920:	409c                	lw	a5,0(s1)
    80003922:	fbed                	bnez	a5,80003914 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003924:	4785                	li	a5,1
    80003926:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003928:	ffffd097          	auipc	ra,0xffffd
    8000392c:	57c080e7          	jalr	1404(ra) # 80000ea4 <myproc>
    80003930:	591c                	lw	a5,48(a0)
    80003932:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	9fa080e7          	jalr	-1542(ra) # 80006330 <release>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	64a2                	ld	s1,8(sp)
    80003944:	6902                	ld	s2,0(sp)
    80003946:	6105                	addi	sp,sp,32
    80003948:	8082                	ret

000000008000394a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000394a:	1101                	addi	sp,sp,-32
    8000394c:	ec06                	sd	ra,24(sp)
    8000394e:	e822                	sd	s0,16(sp)
    80003950:	e426                	sd	s1,8(sp)
    80003952:	e04a                	sd	s2,0(sp)
    80003954:	1000                	addi	s0,sp,32
    80003956:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003958:	00850913          	addi	s2,a0,8
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	91e080e7          	jalr	-1762(ra) # 8000627c <acquire>
  lk->locked = 0;
    80003966:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000396a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000396e:	8526                	mv	a0,s1
    80003970:	ffffe097          	auipc	ra,0xffffe
    80003974:	c44080e7          	jalr	-956(ra) # 800015b4 <wakeup>
  release(&lk->lk);
    80003978:	854a                	mv	a0,s2
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	9b6080e7          	jalr	-1610(ra) # 80006330 <release>
}
    80003982:	60e2                	ld	ra,24(sp)
    80003984:	6442                	ld	s0,16(sp)
    80003986:	64a2                	ld	s1,8(sp)
    80003988:	6902                	ld	s2,0(sp)
    8000398a:	6105                	addi	sp,sp,32
    8000398c:	8082                	ret

000000008000398e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000398e:	7179                	addi	sp,sp,-48
    80003990:	f406                	sd	ra,40(sp)
    80003992:	f022                	sd	s0,32(sp)
    80003994:	ec26                	sd	s1,24(sp)
    80003996:	e84a                	sd	s2,16(sp)
    80003998:	e44e                	sd	s3,8(sp)
    8000399a:	1800                	addi	s0,sp,48
    8000399c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000399e:	00850913          	addi	s2,a0,8
    800039a2:	854a                	mv	a0,s2
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	8d8080e7          	jalr	-1832(ra) # 8000627c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ac:	409c                	lw	a5,0(s1)
    800039ae:	ef99                	bnez	a5,800039cc <holdingsleep+0x3e>
    800039b0:	4481                	li	s1,0
  release(&lk->lk);
    800039b2:	854a                	mv	a0,s2
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	97c080e7          	jalr	-1668(ra) # 80006330 <release>
  return r;
}
    800039bc:	8526                	mv	a0,s1
    800039be:	70a2                	ld	ra,40(sp)
    800039c0:	7402                	ld	s0,32(sp)
    800039c2:	64e2                	ld	s1,24(sp)
    800039c4:	6942                	ld	s2,16(sp)
    800039c6:	69a2                	ld	s3,8(sp)
    800039c8:	6145                	addi	sp,sp,48
    800039ca:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039cc:	0284a983          	lw	s3,40(s1)
    800039d0:	ffffd097          	auipc	ra,0xffffd
    800039d4:	4d4080e7          	jalr	1236(ra) # 80000ea4 <myproc>
    800039d8:	5904                	lw	s1,48(a0)
    800039da:	413484b3          	sub	s1,s1,s3
    800039de:	0014b493          	seqz	s1,s1
    800039e2:	bfc1                	j	800039b2 <holdingsleep+0x24>

00000000800039e4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039e4:	1141                	addi	sp,sp,-16
    800039e6:	e406                	sd	ra,8(sp)
    800039e8:	e022                	sd	s0,0(sp)
    800039ea:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ec:	00005597          	auipc	a1,0x5
    800039f0:	c4458593          	addi	a1,a1,-956 # 80008630 <syscalls+0x248>
    800039f4:	00015517          	auipc	a0,0x15
    800039f8:	37450513          	addi	a0,a0,884 # 80018d68 <ftable>
    800039fc:	00002097          	auipc	ra,0x2
    80003a00:	7f0080e7          	jalr	2032(ra) # 800061ec <initlock>
}
    80003a04:	60a2                	ld	ra,8(sp)
    80003a06:	6402                	ld	s0,0(sp)
    80003a08:	0141                	addi	sp,sp,16
    80003a0a:	8082                	ret

0000000080003a0c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a0c:	1101                	addi	sp,sp,-32
    80003a0e:	ec06                	sd	ra,24(sp)
    80003a10:	e822                	sd	s0,16(sp)
    80003a12:	e426                	sd	s1,8(sp)
    80003a14:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a16:	00015517          	auipc	a0,0x15
    80003a1a:	35250513          	addi	a0,a0,850 # 80018d68 <ftable>
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	85e080e7          	jalr	-1954(ra) # 8000627c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a26:	00015497          	auipc	s1,0x15
    80003a2a:	35a48493          	addi	s1,s1,858 # 80018d80 <ftable+0x18>
    80003a2e:	00016717          	auipc	a4,0x16
    80003a32:	2f270713          	addi	a4,a4,754 # 80019d20 <disk>
    if(f->ref == 0){
    80003a36:	40dc                	lw	a5,4(s1)
    80003a38:	cf99                	beqz	a5,80003a56 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a3a:	02848493          	addi	s1,s1,40
    80003a3e:	fee49ce3          	bne	s1,a4,80003a36 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a42:	00015517          	auipc	a0,0x15
    80003a46:	32650513          	addi	a0,a0,806 # 80018d68 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	8e6080e7          	jalr	-1818(ra) # 80006330 <release>
  return 0;
    80003a52:	4481                	li	s1,0
    80003a54:	a819                	j	80003a6a <filealloc+0x5e>
      f->ref = 1;
    80003a56:	4785                	li	a5,1
    80003a58:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a5a:	00015517          	auipc	a0,0x15
    80003a5e:	30e50513          	addi	a0,a0,782 # 80018d68 <ftable>
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	8ce080e7          	jalr	-1842(ra) # 80006330 <release>
}
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a76:	1101                	addi	sp,sp,-32
    80003a78:	ec06                	sd	ra,24(sp)
    80003a7a:	e822                	sd	s0,16(sp)
    80003a7c:	e426                	sd	s1,8(sp)
    80003a7e:	1000                	addi	s0,sp,32
    80003a80:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a82:	00015517          	auipc	a0,0x15
    80003a86:	2e650513          	addi	a0,a0,742 # 80018d68 <ftable>
    80003a8a:	00002097          	auipc	ra,0x2
    80003a8e:	7f2080e7          	jalr	2034(ra) # 8000627c <acquire>
  if(f->ref < 1)
    80003a92:	40dc                	lw	a5,4(s1)
    80003a94:	02f05263          	blez	a5,80003ab8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a98:	2785                	addiw	a5,a5,1
    80003a9a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a9c:	00015517          	auipc	a0,0x15
    80003aa0:	2cc50513          	addi	a0,a0,716 # 80018d68 <ftable>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	88c080e7          	jalr	-1908(ra) # 80006330 <release>
  return f;
}
    80003aac:	8526                	mv	a0,s1
    80003aae:	60e2                	ld	ra,24(sp)
    80003ab0:	6442                	ld	s0,16(sp)
    80003ab2:	64a2                	ld	s1,8(sp)
    80003ab4:	6105                	addi	sp,sp,32
    80003ab6:	8082                	ret
    panic("filedup");
    80003ab8:	00005517          	auipc	a0,0x5
    80003abc:	b8050513          	addi	a0,a0,-1152 # 80008638 <syscalls+0x250>
    80003ac0:	00002097          	auipc	ra,0x2
    80003ac4:	272080e7          	jalr	626(ra) # 80005d32 <panic>

0000000080003ac8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ac8:	7139                	addi	sp,sp,-64
    80003aca:	fc06                	sd	ra,56(sp)
    80003acc:	f822                	sd	s0,48(sp)
    80003ace:	f426                	sd	s1,40(sp)
    80003ad0:	f04a                	sd	s2,32(sp)
    80003ad2:	ec4e                	sd	s3,24(sp)
    80003ad4:	e852                	sd	s4,16(sp)
    80003ad6:	e456                	sd	s5,8(sp)
    80003ad8:	0080                	addi	s0,sp,64
    80003ada:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003adc:	00015517          	auipc	a0,0x15
    80003ae0:	28c50513          	addi	a0,a0,652 # 80018d68 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	798080e7          	jalr	1944(ra) # 8000627c <acquire>
  if(f->ref < 1)
    80003aec:	40dc                	lw	a5,4(s1)
    80003aee:	06f05163          	blez	a5,80003b50 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003af2:	37fd                	addiw	a5,a5,-1
    80003af4:	0007871b          	sext.w	a4,a5
    80003af8:	c0dc                	sw	a5,4(s1)
    80003afa:	06e04363          	bgtz	a4,80003b60 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003afe:	0004a903          	lw	s2,0(s1)
    80003b02:	0094ca83          	lbu	s5,9(s1)
    80003b06:	0104ba03          	ld	s4,16(s1)
    80003b0a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b0e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b12:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b16:	00015517          	auipc	a0,0x15
    80003b1a:	25250513          	addi	a0,a0,594 # 80018d68 <ftable>
    80003b1e:	00003097          	auipc	ra,0x3
    80003b22:	812080e7          	jalr	-2030(ra) # 80006330 <release>

  if(ff.type == FD_PIPE){
    80003b26:	4785                	li	a5,1
    80003b28:	04f90d63          	beq	s2,a5,80003b82 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b2c:	3979                	addiw	s2,s2,-2
    80003b2e:	4785                	li	a5,1
    80003b30:	0527e063          	bltu	a5,s2,80003b70 <fileclose+0xa8>
    begin_op();
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	ac8080e7          	jalr	-1336(ra) # 800035fc <begin_op>
    iput(ff.ip);
    80003b3c:	854e                	mv	a0,s3
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	2b6080e7          	jalr	694(ra) # 80002df4 <iput>
    end_op();
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	b36080e7          	jalr	-1226(ra) # 8000367c <end_op>
    80003b4e:	a00d                	j	80003b70 <fileclose+0xa8>
    panic("fileclose");
    80003b50:	00005517          	auipc	a0,0x5
    80003b54:	af050513          	addi	a0,a0,-1296 # 80008640 <syscalls+0x258>
    80003b58:	00002097          	auipc	ra,0x2
    80003b5c:	1da080e7          	jalr	474(ra) # 80005d32 <panic>
    release(&ftable.lock);
    80003b60:	00015517          	auipc	a0,0x15
    80003b64:	20850513          	addi	a0,a0,520 # 80018d68 <ftable>
    80003b68:	00002097          	auipc	ra,0x2
    80003b6c:	7c8080e7          	jalr	1992(ra) # 80006330 <release>
  }
}
    80003b70:	70e2                	ld	ra,56(sp)
    80003b72:	7442                	ld	s0,48(sp)
    80003b74:	74a2                	ld	s1,40(sp)
    80003b76:	7902                	ld	s2,32(sp)
    80003b78:	69e2                	ld	s3,24(sp)
    80003b7a:	6a42                	ld	s4,16(sp)
    80003b7c:	6aa2                	ld	s5,8(sp)
    80003b7e:	6121                	addi	sp,sp,64
    80003b80:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b82:	85d6                	mv	a1,s5
    80003b84:	8552                	mv	a0,s4
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	34c080e7          	jalr	844(ra) # 80003ed2 <pipeclose>
    80003b8e:	b7cd                	j	80003b70 <fileclose+0xa8>

0000000080003b90 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b90:	715d                	addi	sp,sp,-80
    80003b92:	e486                	sd	ra,72(sp)
    80003b94:	e0a2                	sd	s0,64(sp)
    80003b96:	fc26                	sd	s1,56(sp)
    80003b98:	f84a                	sd	s2,48(sp)
    80003b9a:	f44e                	sd	s3,40(sp)
    80003b9c:	0880                	addi	s0,sp,80
    80003b9e:	84aa                	mv	s1,a0
    80003ba0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ba2:	ffffd097          	auipc	ra,0xffffd
    80003ba6:	302080e7          	jalr	770(ra) # 80000ea4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003baa:	409c                	lw	a5,0(s1)
    80003bac:	37f9                	addiw	a5,a5,-2
    80003bae:	4705                	li	a4,1
    80003bb0:	04f76763          	bltu	a4,a5,80003bfe <filestat+0x6e>
    80003bb4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bb6:	6c88                	ld	a0,24(s1)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	082080e7          	jalr	130(ra) # 80002c3a <ilock>
    stati(f->ip, &st);
    80003bc0:	fb840593          	addi	a1,s0,-72
    80003bc4:	6c88                	ld	a0,24(s1)
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	2fe080e7          	jalr	766(ra) # 80002ec4 <stati>
    iunlock(f->ip);
    80003bce:	6c88                	ld	a0,24(s1)
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	12c080e7          	jalr	300(ra) # 80002cfc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bd8:	46e1                	li	a3,24
    80003bda:	fb840613          	addi	a2,s0,-72
    80003bde:	85ce                	mv	a1,s3
    80003be0:	05093503          	ld	a0,80(s2)
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	f7e080e7          	jalr	-130(ra) # 80000b62 <copyout>
    80003bec:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bf0:	60a6                	ld	ra,72(sp)
    80003bf2:	6406                	ld	s0,64(sp)
    80003bf4:	74e2                	ld	s1,56(sp)
    80003bf6:	7942                	ld	s2,48(sp)
    80003bf8:	79a2                	ld	s3,40(sp)
    80003bfa:	6161                	addi	sp,sp,80
    80003bfc:	8082                	ret
  return -1;
    80003bfe:	557d                	li	a0,-1
    80003c00:	bfc5                	j	80003bf0 <filestat+0x60>

0000000080003c02 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c02:	7179                	addi	sp,sp,-48
    80003c04:	f406                	sd	ra,40(sp)
    80003c06:	f022                	sd	s0,32(sp)
    80003c08:	ec26                	sd	s1,24(sp)
    80003c0a:	e84a                	sd	s2,16(sp)
    80003c0c:	e44e                	sd	s3,8(sp)
    80003c0e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c10:	00854783          	lbu	a5,8(a0)
    80003c14:	c3d5                	beqz	a5,80003cb8 <fileread+0xb6>
    80003c16:	84aa                	mv	s1,a0
    80003c18:	89ae                	mv	s3,a1
    80003c1a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c1c:	411c                	lw	a5,0(a0)
    80003c1e:	4705                	li	a4,1
    80003c20:	04e78963          	beq	a5,a4,80003c72 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c24:	470d                	li	a4,3
    80003c26:	04e78d63          	beq	a5,a4,80003c80 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c2a:	4709                	li	a4,2
    80003c2c:	06e79e63          	bne	a5,a4,80003ca8 <fileread+0xa6>
    ilock(f->ip);
    80003c30:	6d08                	ld	a0,24(a0)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	008080e7          	jalr	8(ra) # 80002c3a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c3a:	874a                	mv	a4,s2
    80003c3c:	5094                	lw	a3,32(s1)
    80003c3e:	864e                	mv	a2,s3
    80003c40:	4585                	li	a1,1
    80003c42:	6c88                	ld	a0,24(s1)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	2aa080e7          	jalr	682(ra) # 80002eee <readi>
    80003c4c:	892a                	mv	s2,a0
    80003c4e:	00a05563          	blez	a0,80003c58 <fileread+0x56>
      f->off += r;
    80003c52:	509c                	lw	a5,32(s1)
    80003c54:	9fa9                	addw	a5,a5,a0
    80003c56:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c58:	6c88                	ld	a0,24(s1)
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	0a2080e7          	jalr	162(ra) # 80002cfc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c62:	854a                	mv	a0,s2
    80003c64:	70a2                	ld	ra,40(sp)
    80003c66:	7402                	ld	s0,32(sp)
    80003c68:	64e2                	ld	s1,24(sp)
    80003c6a:	6942                	ld	s2,16(sp)
    80003c6c:	69a2                	ld	s3,8(sp)
    80003c6e:	6145                	addi	sp,sp,48
    80003c70:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c72:	6908                	ld	a0,16(a0)
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	3ce080e7          	jalr	974(ra) # 80004042 <piperead>
    80003c7c:	892a                	mv	s2,a0
    80003c7e:	b7d5                	j	80003c62 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c80:	02451783          	lh	a5,36(a0)
    80003c84:	03079693          	slli	a3,a5,0x30
    80003c88:	92c1                	srli	a3,a3,0x30
    80003c8a:	4725                	li	a4,9
    80003c8c:	02d76863          	bltu	a4,a3,80003cbc <fileread+0xba>
    80003c90:	0792                	slli	a5,a5,0x4
    80003c92:	00015717          	auipc	a4,0x15
    80003c96:	03670713          	addi	a4,a4,54 # 80018cc8 <devsw>
    80003c9a:	97ba                	add	a5,a5,a4
    80003c9c:	639c                	ld	a5,0(a5)
    80003c9e:	c38d                	beqz	a5,80003cc0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ca0:	4505                	li	a0,1
    80003ca2:	9782                	jalr	a5
    80003ca4:	892a                	mv	s2,a0
    80003ca6:	bf75                	j	80003c62 <fileread+0x60>
    panic("fileread");
    80003ca8:	00005517          	auipc	a0,0x5
    80003cac:	9a850513          	addi	a0,a0,-1624 # 80008650 <syscalls+0x268>
    80003cb0:	00002097          	auipc	ra,0x2
    80003cb4:	082080e7          	jalr	130(ra) # 80005d32 <panic>
    return -1;
    80003cb8:	597d                	li	s2,-1
    80003cba:	b765                	j	80003c62 <fileread+0x60>
      return -1;
    80003cbc:	597d                	li	s2,-1
    80003cbe:	b755                	j	80003c62 <fileread+0x60>
    80003cc0:	597d                	li	s2,-1
    80003cc2:	b745                	j	80003c62 <fileread+0x60>

0000000080003cc4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cc4:	715d                	addi	sp,sp,-80
    80003cc6:	e486                	sd	ra,72(sp)
    80003cc8:	e0a2                	sd	s0,64(sp)
    80003cca:	fc26                	sd	s1,56(sp)
    80003ccc:	f84a                	sd	s2,48(sp)
    80003cce:	f44e                	sd	s3,40(sp)
    80003cd0:	f052                	sd	s4,32(sp)
    80003cd2:	ec56                	sd	s5,24(sp)
    80003cd4:	e85a                	sd	s6,16(sp)
    80003cd6:	e45e                	sd	s7,8(sp)
    80003cd8:	e062                	sd	s8,0(sp)
    80003cda:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cdc:	00954783          	lbu	a5,9(a0)
    80003ce0:	10078663          	beqz	a5,80003dec <filewrite+0x128>
    80003ce4:	892a                	mv	s2,a0
    80003ce6:	8aae                	mv	s5,a1
    80003ce8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cea:	411c                	lw	a5,0(a0)
    80003cec:	4705                	li	a4,1
    80003cee:	02e78263          	beq	a5,a4,80003d12 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cf2:	470d                	li	a4,3
    80003cf4:	02e78663          	beq	a5,a4,80003d20 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cf8:	4709                	li	a4,2
    80003cfa:	0ee79163          	bne	a5,a4,80003ddc <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cfe:	0ac05d63          	blez	a2,80003db8 <filewrite+0xf4>
    int i = 0;
    80003d02:	4981                	li	s3,0
    80003d04:	6b05                	lui	s6,0x1
    80003d06:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d0a:	6b85                	lui	s7,0x1
    80003d0c:	c00b8b9b          	addiw	s7,s7,-1024
    80003d10:	a861                	j	80003da8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d12:	6908                	ld	a0,16(a0)
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	22e080e7          	jalr	558(ra) # 80003f42 <pipewrite>
    80003d1c:	8a2a                	mv	s4,a0
    80003d1e:	a045                	j	80003dbe <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d20:	02451783          	lh	a5,36(a0)
    80003d24:	03079693          	slli	a3,a5,0x30
    80003d28:	92c1                	srli	a3,a3,0x30
    80003d2a:	4725                	li	a4,9
    80003d2c:	0cd76263          	bltu	a4,a3,80003df0 <filewrite+0x12c>
    80003d30:	0792                	slli	a5,a5,0x4
    80003d32:	00015717          	auipc	a4,0x15
    80003d36:	f9670713          	addi	a4,a4,-106 # 80018cc8 <devsw>
    80003d3a:	97ba                	add	a5,a5,a4
    80003d3c:	679c                	ld	a5,8(a5)
    80003d3e:	cbdd                	beqz	a5,80003df4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d40:	4505                	li	a0,1
    80003d42:	9782                	jalr	a5
    80003d44:	8a2a                	mv	s4,a0
    80003d46:	a8a5                	j	80003dbe <filewrite+0xfa>
    80003d48:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	8b0080e7          	jalr	-1872(ra) # 800035fc <begin_op>
      ilock(f->ip);
    80003d54:	01893503          	ld	a0,24(s2)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	ee2080e7          	jalr	-286(ra) # 80002c3a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d60:	8762                	mv	a4,s8
    80003d62:	02092683          	lw	a3,32(s2)
    80003d66:	01598633          	add	a2,s3,s5
    80003d6a:	4585                	li	a1,1
    80003d6c:	01893503          	ld	a0,24(s2)
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	276080e7          	jalr	630(ra) # 80002fe6 <writei>
    80003d78:	84aa                	mv	s1,a0
    80003d7a:	00a05763          	blez	a0,80003d88 <filewrite+0xc4>
        f->off += r;
    80003d7e:	02092783          	lw	a5,32(s2)
    80003d82:	9fa9                	addw	a5,a5,a0
    80003d84:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d88:	01893503          	ld	a0,24(s2)
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	f70080e7          	jalr	-144(ra) # 80002cfc <iunlock>
      end_op();
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	8e8080e7          	jalr	-1816(ra) # 8000367c <end_op>

      if(r != n1){
    80003d9c:	009c1f63          	bne	s8,s1,80003dba <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003da0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003da4:	0149db63          	bge	s3,s4,80003dba <filewrite+0xf6>
      int n1 = n - i;
    80003da8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dac:	84be                	mv	s1,a5
    80003dae:	2781                	sext.w	a5,a5
    80003db0:	f8fb5ce3          	bge	s6,a5,80003d48 <filewrite+0x84>
    80003db4:	84de                	mv	s1,s7
    80003db6:	bf49                	j	80003d48 <filewrite+0x84>
    int i = 0;
    80003db8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dba:	013a1f63          	bne	s4,s3,80003dd8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dbe:	8552                	mv	a0,s4
    80003dc0:	60a6                	ld	ra,72(sp)
    80003dc2:	6406                	ld	s0,64(sp)
    80003dc4:	74e2                	ld	s1,56(sp)
    80003dc6:	7942                	ld	s2,48(sp)
    80003dc8:	79a2                	ld	s3,40(sp)
    80003dca:	7a02                	ld	s4,32(sp)
    80003dcc:	6ae2                	ld	s5,24(sp)
    80003dce:	6b42                	ld	s6,16(sp)
    80003dd0:	6ba2                	ld	s7,8(sp)
    80003dd2:	6c02                	ld	s8,0(sp)
    80003dd4:	6161                	addi	sp,sp,80
    80003dd6:	8082                	ret
    ret = (i == n ? n : -1);
    80003dd8:	5a7d                	li	s4,-1
    80003dda:	b7d5                	j	80003dbe <filewrite+0xfa>
    panic("filewrite");
    80003ddc:	00005517          	auipc	a0,0x5
    80003de0:	88450513          	addi	a0,a0,-1916 # 80008660 <syscalls+0x278>
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	f4e080e7          	jalr	-178(ra) # 80005d32 <panic>
    return -1;
    80003dec:	5a7d                	li	s4,-1
    80003dee:	bfc1                	j	80003dbe <filewrite+0xfa>
      return -1;
    80003df0:	5a7d                	li	s4,-1
    80003df2:	b7f1                	j	80003dbe <filewrite+0xfa>
    80003df4:	5a7d                	li	s4,-1
    80003df6:	b7e1                	j	80003dbe <filewrite+0xfa>

0000000080003df8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003df8:	7179                	addi	sp,sp,-48
    80003dfa:	f406                	sd	ra,40(sp)
    80003dfc:	f022                	sd	s0,32(sp)
    80003dfe:	ec26                	sd	s1,24(sp)
    80003e00:	e84a                	sd	s2,16(sp)
    80003e02:	e44e                	sd	s3,8(sp)
    80003e04:	e052                	sd	s4,0(sp)
    80003e06:	1800                	addi	s0,sp,48
    80003e08:	84aa                	mv	s1,a0
    80003e0a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e0c:	0005b023          	sd	zero,0(a1)
    80003e10:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	bf8080e7          	jalr	-1032(ra) # 80003a0c <filealloc>
    80003e1c:	e088                	sd	a0,0(s1)
    80003e1e:	c551                	beqz	a0,80003eaa <pipealloc+0xb2>
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	bec080e7          	jalr	-1044(ra) # 80003a0c <filealloc>
    80003e28:	00aa3023          	sd	a0,0(s4)
    80003e2c:	c92d                	beqz	a0,80003e9e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e2e:	ffffc097          	auipc	ra,0xffffc
    80003e32:	2ea080e7          	jalr	746(ra) # 80000118 <kalloc>
    80003e36:	892a                	mv	s2,a0
    80003e38:	c125                	beqz	a0,80003e98 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e3a:	4985                	li	s3,1
    80003e3c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e40:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e44:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e48:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e4c:	00005597          	auipc	a1,0x5
    80003e50:	82458593          	addi	a1,a1,-2012 # 80008670 <syscalls+0x288>
    80003e54:	00002097          	auipc	ra,0x2
    80003e58:	398080e7          	jalr	920(ra) # 800061ec <initlock>
  (*f0)->type = FD_PIPE;
    80003e5c:	609c                	ld	a5,0(s1)
    80003e5e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e62:	609c                	ld	a5,0(s1)
    80003e64:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e68:	609c                	ld	a5,0(s1)
    80003e6a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e74:	000a3783          	ld	a5,0(s4)
    80003e78:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e7c:	000a3783          	ld	a5,0(s4)
    80003e80:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e84:	000a3783          	ld	a5,0(s4)
    80003e88:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e8c:	000a3783          	ld	a5,0(s4)
    80003e90:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e94:	4501                	li	a0,0
    80003e96:	a025                	j	80003ebe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e98:	6088                	ld	a0,0(s1)
    80003e9a:	e501                	bnez	a0,80003ea2 <pipealloc+0xaa>
    80003e9c:	a039                	j	80003eaa <pipealloc+0xb2>
    80003e9e:	6088                	ld	a0,0(s1)
    80003ea0:	c51d                	beqz	a0,80003ece <pipealloc+0xd6>
    fileclose(*f0);
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	c26080e7          	jalr	-986(ra) # 80003ac8 <fileclose>
  if(*f1)
    80003eaa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eae:	557d                	li	a0,-1
  if(*f1)
    80003eb0:	c799                	beqz	a5,80003ebe <pipealloc+0xc6>
    fileclose(*f1);
    80003eb2:	853e                	mv	a0,a5
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	c14080e7          	jalr	-1004(ra) # 80003ac8 <fileclose>
  return -1;
    80003ebc:	557d                	li	a0,-1
}
    80003ebe:	70a2                	ld	ra,40(sp)
    80003ec0:	7402                	ld	s0,32(sp)
    80003ec2:	64e2                	ld	s1,24(sp)
    80003ec4:	6942                	ld	s2,16(sp)
    80003ec6:	69a2                	ld	s3,8(sp)
    80003ec8:	6a02                	ld	s4,0(sp)
    80003eca:	6145                	addi	sp,sp,48
    80003ecc:	8082                	ret
  return -1;
    80003ece:	557d                	li	a0,-1
    80003ed0:	b7fd                	j	80003ebe <pipealloc+0xc6>

0000000080003ed2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ed2:	1101                	addi	sp,sp,-32
    80003ed4:	ec06                	sd	ra,24(sp)
    80003ed6:	e822                	sd	s0,16(sp)
    80003ed8:	e426                	sd	s1,8(sp)
    80003eda:	e04a                	sd	s2,0(sp)
    80003edc:	1000                	addi	s0,sp,32
    80003ede:	84aa                	mv	s1,a0
    80003ee0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	39a080e7          	jalr	922(ra) # 8000627c <acquire>
  if(writable){
    80003eea:	02090d63          	beqz	s2,80003f24 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eee:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ef2:	21848513          	addi	a0,s1,536
    80003ef6:	ffffd097          	auipc	ra,0xffffd
    80003efa:	6be080e7          	jalr	1726(ra) # 800015b4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003efe:	2204b783          	ld	a5,544(s1)
    80003f02:	eb95                	bnez	a5,80003f36 <pipeclose+0x64>
    release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	42a080e7          	jalr	1066(ra) # 80006330 <release>
    kfree((char*)pi);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	ffffc097          	auipc	ra,0xffffc
    80003f14:	10c080e7          	jalr	268(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f18:	60e2                	ld	ra,24(sp)
    80003f1a:	6442                	ld	s0,16(sp)
    80003f1c:	64a2                	ld	s1,8(sp)
    80003f1e:	6902                	ld	s2,0(sp)
    80003f20:	6105                	addi	sp,sp,32
    80003f22:	8082                	ret
    pi->readopen = 0;
    80003f24:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f28:	21c48513          	addi	a0,s1,540
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	688080e7          	jalr	1672(ra) # 800015b4 <wakeup>
    80003f34:	b7e9                	j	80003efe <pipeclose+0x2c>
    release(&pi->lock);
    80003f36:	8526                	mv	a0,s1
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	3f8080e7          	jalr	1016(ra) # 80006330 <release>
}
    80003f40:	bfe1                	j	80003f18 <pipeclose+0x46>

0000000080003f42 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f42:	7159                	addi	sp,sp,-112
    80003f44:	f486                	sd	ra,104(sp)
    80003f46:	f0a2                	sd	s0,96(sp)
    80003f48:	eca6                	sd	s1,88(sp)
    80003f4a:	e8ca                	sd	s2,80(sp)
    80003f4c:	e4ce                	sd	s3,72(sp)
    80003f4e:	e0d2                	sd	s4,64(sp)
    80003f50:	fc56                	sd	s5,56(sp)
    80003f52:	f85a                	sd	s6,48(sp)
    80003f54:	f45e                	sd	s7,40(sp)
    80003f56:	f062                	sd	s8,32(sp)
    80003f58:	ec66                	sd	s9,24(sp)
    80003f5a:	1880                	addi	s0,sp,112
    80003f5c:	84aa                	mv	s1,a0
    80003f5e:	8aae                	mv	s5,a1
    80003f60:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f62:	ffffd097          	auipc	ra,0xffffd
    80003f66:	f42080e7          	jalr	-190(ra) # 80000ea4 <myproc>
    80003f6a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	00002097          	auipc	ra,0x2
    80003f72:	30e080e7          	jalr	782(ra) # 8000627c <acquire>
  while(i < n){
    80003f76:	0d405463          	blez	s4,8000403e <pipewrite+0xfc>
    80003f7a:	8ba6                	mv	s7,s1
  int i = 0;
    80003f7c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f80:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f84:	21c48c13          	addi	s8,s1,540
    80003f88:	a08d                	j	80003fea <pipewrite+0xa8>
      release(&pi->lock);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	00002097          	auipc	ra,0x2
    80003f90:	3a4080e7          	jalr	932(ra) # 80006330 <release>
      return -1;
    80003f94:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f96:	854a                	mv	a0,s2
    80003f98:	70a6                	ld	ra,104(sp)
    80003f9a:	7406                	ld	s0,96(sp)
    80003f9c:	64e6                	ld	s1,88(sp)
    80003f9e:	6946                	ld	s2,80(sp)
    80003fa0:	69a6                	ld	s3,72(sp)
    80003fa2:	6a06                	ld	s4,64(sp)
    80003fa4:	7ae2                	ld	s5,56(sp)
    80003fa6:	7b42                	ld	s6,48(sp)
    80003fa8:	7ba2                	ld	s7,40(sp)
    80003faa:	7c02                	ld	s8,32(sp)
    80003fac:	6ce2                	ld	s9,24(sp)
    80003fae:	6165                	addi	sp,sp,112
    80003fb0:	8082                	ret
      wakeup(&pi->nread);
    80003fb2:	8566                	mv	a0,s9
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	600080e7          	jalr	1536(ra) # 800015b4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fbc:	85de                	mv	a1,s7
    80003fbe:	8562                	mv	a0,s8
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	590080e7          	jalr	1424(ra) # 80001550 <sleep>
    80003fc8:	a839                	j	80003fe6 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fca:	21c4a783          	lw	a5,540(s1)
    80003fce:	0017871b          	addiw	a4,a5,1
    80003fd2:	20e4ae23          	sw	a4,540(s1)
    80003fd6:	1ff7f793          	andi	a5,a5,511
    80003fda:	97a6                	add	a5,a5,s1
    80003fdc:	f9f44703          	lbu	a4,-97(s0)
    80003fe0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fe4:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fe6:	05495063          	bge	s2,s4,80004026 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003fea:	2204a783          	lw	a5,544(s1)
    80003fee:	dfd1                	beqz	a5,80003f8a <pipewrite+0x48>
    80003ff0:	854e                	mv	a0,s3
    80003ff2:	ffffe097          	auipc	ra,0xffffe
    80003ff6:	806080e7          	jalr	-2042(ra) # 800017f8 <killed>
    80003ffa:	f941                	bnez	a0,80003f8a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ffc:	2184a783          	lw	a5,536(s1)
    80004000:	21c4a703          	lw	a4,540(s1)
    80004004:	2007879b          	addiw	a5,a5,512
    80004008:	faf705e3          	beq	a4,a5,80003fb2 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000400c:	4685                	li	a3,1
    8000400e:	01590633          	add	a2,s2,s5
    80004012:	f9f40593          	addi	a1,s0,-97
    80004016:	0509b503          	ld	a0,80(s3)
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	bd4080e7          	jalr	-1068(ra) # 80000bee <copyin>
    80004022:	fb6514e3          	bne	a0,s6,80003fca <pipewrite+0x88>
  wakeup(&pi->nread);
    80004026:	21848513          	addi	a0,s1,536
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	58a080e7          	jalr	1418(ra) # 800015b4 <wakeup>
  release(&pi->lock);
    80004032:	8526                	mv	a0,s1
    80004034:	00002097          	auipc	ra,0x2
    80004038:	2fc080e7          	jalr	764(ra) # 80006330 <release>
  return i;
    8000403c:	bfa9                	j	80003f96 <pipewrite+0x54>
  int i = 0;
    8000403e:	4901                	li	s2,0
    80004040:	b7dd                	j	80004026 <pipewrite+0xe4>

0000000080004042 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004042:	715d                	addi	sp,sp,-80
    80004044:	e486                	sd	ra,72(sp)
    80004046:	e0a2                	sd	s0,64(sp)
    80004048:	fc26                	sd	s1,56(sp)
    8000404a:	f84a                	sd	s2,48(sp)
    8000404c:	f44e                	sd	s3,40(sp)
    8000404e:	f052                	sd	s4,32(sp)
    80004050:	ec56                	sd	s5,24(sp)
    80004052:	e85a                	sd	s6,16(sp)
    80004054:	0880                	addi	s0,sp,80
    80004056:	84aa                	mv	s1,a0
    80004058:	892e                	mv	s2,a1
    8000405a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	e48080e7          	jalr	-440(ra) # 80000ea4 <myproc>
    80004064:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004066:	8b26                	mv	s6,s1
    80004068:	8526                	mv	a0,s1
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	212080e7          	jalr	530(ra) # 8000627c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004072:	2184a703          	lw	a4,536(s1)
    80004076:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000407a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407e:	02f71763          	bne	a4,a5,800040ac <piperead+0x6a>
    80004082:	2244a783          	lw	a5,548(s1)
    80004086:	c39d                	beqz	a5,800040ac <piperead+0x6a>
    if(killed(pr)){
    80004088:	8552                	mv	a0,s4
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	76e080e7          	jalr	1902(ra) # 800017f8 <killed>
    80004092:	e941                	bnez	a0,80004122 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004094:	85da                	mv	a1,s6
    80004096:	854e                	mv	a0,s3
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	4b8080e7          	jalr	1208(ra) # 80001550 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040a0:	2184a703          	lw	a4,536(s1)
    800040a4:	21c4a783          	lw	a5,540(s1)
    800040a8:	fcf70de3          	beq	a4,a5,80004082 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ac:	09505263          	blez	s5,80004130 <piperead+0xee>
    800040b0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040b2:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040b4:	2184a783          	lw	a5,536(s1)
    800040b8:	21c4a703          	lw	a4,540(s1)
    800040bc:	02f70d63          	beq	a4,a5,800040f6 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040c0:	0017871b          	addiw	a4,a5,1
    800040c4:	20e4ac23          	sw	a4,536(s1)
    800040c8:	1ff7f793          	andi	a5,a5,511
    800040cc:	97a6                	add	a5,a5,s1
    800040ce:	0187c783          	lbu	a5,24(a5)
    800040d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d6:	4685                	li	a3,1
    800040d8:	fbf40613          	addi	a2,s0,-65
    800040dc:	85ca                	mv	a1,s2
    800040de:	050a3503          	ld	a0,80(s4)
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	a80080e7          	jalr	-1408(ra) # 80000b62 <copyout>
    800040ea:	01650663          	beq	a0,s6,800040f6 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	2985                	addiw	s3,s3,1
    800040f0:	0905                	addi	s2,s2,1
    800040f2:	fd3a91e3          	bne	s5,s3,800040b4 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040f6:	21c48513          	addi	a0,s1,540
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	4ba080e7          	jalr	1210(ra) # 800015b4 <wakeup>
  release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	22c080e7          	jalr	556(ra) # 80006330 <release>
  return i;
}
    8000410c:	854e                	mv	a0,s3
    8000410e:	60a6                	ld	ra,72(sp)
    80004110:	6406                	ld	s0,64(sp)
    80004112:	74e2                	ld	s1,56(sp)
    80004114:	7942                	ld	s2,48(sp)
    80004116:	79a2                	ld	s3,40(sp)
    80004118:	7a02                	ld	s4,32(sp)
    8000411a:	6ae2                	ld	s5,24(sp)
    8000411c:	6b42                	ld	s6,16(sp)
    8000411e:	6161                	addi	sp,sp,80
    80004120:	8082                	ret
      release(&pi->lock);
    80004122:	8526                	mv	a0,s1
    80004124:	00002097          	auipc	ra,0x2
    80004128:	20c080e7          	jalr	524(ra) # 80006330 <release>
      return -1;
    8000412c:	59fd                	li	s3,-1
    8000412e:	bff9                	j	8000410c <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004130:	4981                	li	s3,0
    80004132:	b7d1                	j	800040f6 <piperead+0xb4>

0000000080004134 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004134:	1141                	addi	sp,sp,-16
    80004136:	e422                	sd	s0,8(sp)
    80004138:	0800                	addi	s0,sp,16
    8000413a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000413c:	8905                	andi	a0,a0,1
    8000413e:	c111                	beqz	a0,80004142 <flags2perm+0xe>
      perm = PTE_X;
    80004140:	4521                	li	a0,8
    if(flags & 0x2)
    80004142:	8b89                	andi	a5,a5,2
    80004144:	c399                	beqz	a5,8000414a <flags2perm+0x16>
      perm |= PTE_W;
    80004146:	00456513          	ori	a0,a0,4
    return perm;
}
    8000414a:	6422                	ld	s0,8(sp)
    8000414c:	0141                	addi	sp,sp,16
    8000414e:	8082                	ret

0000000080004150 <exec>:

int
exec(char *path, char **argv)
{
    80004150:	df010113          	addi	sp,sp,-528
    80004154:	20113423          	sd	ra,520(sp)
    80004158:	20813023          	sd	s0,512(sp)
    8000415c:	ffa6                	sd	s1,504(sp)
    8000415e:	fbca                	sd	s2,496(sp)
    80004160:	f7ce                	sd	s3,488(sp)
    80004162:	f3d2                	sd	s4,480(sp)
    80004164:	efd6                	sd	s5,472(sp)
    80004166:	ebda                	sd	s6,464(sp)
    80004168:	e7de                	sd	s7,456(sp)
    8000416a:	e3e2                	sd	s8,448(sp)
    8000416c:	ff66                	sd	s9,440(sp)
    8000416e:	fb6a                	sd	s10,432(sp)
    80004170:	f76e                	sd	s11,424(sp)
    80004172:	0c00                	addi	s0,sp,528
    80004174:	84aa                	mv	s1,a0
    80004176:	dea43c23          	sd	a0,-520(s0)
    8000417a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	d26080e7          	jalr	-730(ra) # 80000ea4 <myproc>
    80004186:	892a                	mv	s2,a0

  begin_op();
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	474080e7          	jalr	1140(ra) # 800035fc <begin_op>

  if((ip = namei(path)) == 0){
    80004190:	8526                	mv	a0,s1
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	24e080e7          	jalr	590(ra) # 800033e0 <namei>
    8000419a:	c92d                	beqz	a0,8000420c <exec+0xbc>
    8000419c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	a9c080e7          	jalr	-1380(ra) # 80002c3a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041a6:	04000713          	li	a4,64
    800041aa:	4681                	li	a3,0
    800041ac:	e5040613          	addi	a2,s0,-432
    800041b0:	4581                	li	a1,0
    800041b2:	8526                	mv	a0,s1
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	d3a080e7          	jalr	-710(ra) # 80002eee <readi>
    800041bc:	04000793          	li	a5,64
    800041c0:	00f51a63          	bne	a0,a5,800041d4 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041c4:	e5042703          	lw	a4,-432(s0)
    800041c8:	464c47b7          	lui	a5,0x464c4
    800041cc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041d0:	04f70463          	beq	a4,a5,80004218 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041d4:	8526                	mv	a0,s1
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	cc6080e7          	jalr	-826(ra) # 80002e9c <iunlockput>
    end_op();
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	49e080e7          	jalr	1182(ra) # 8000367c <end_op>
  }
  return -1;
    800041e6:	557d                	li	a0,-1
}
    800041e8:	20813083          	ld	ra,520(sp)
    800041ec:	20013403          	ld	s0,512(sp)
    800041f0:	74fe                	ld	s1,504(sp)
    800041f2:	795e                	ld	s2,496(sp)
    800041f4:	79be                	ld	s3,488(sp)
    800041f6:	7a1e                	ld	s4,480(sp)
    800041f8:	6afe                	ld	s5,472(sp)
    800041fa:	6b5e                	ld	s6,464(sp)
    800041fc:	6bbe                	ld	s7,456(sp)
    800041fe:	6c1e                	ld	s8,448(sp)
    80004200:	7cfa                	ld	s9,440(sp)
    80004202:	7d5a                	ld	s10,432(sp)
    80004204:	7dba                	ld	s11,424(sp)
    80004206:	21010113          	addi	sp,sp,528
    8000420a:	8082                	ret
    end_op();
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	470080e7          	jalr	1136(ra) # 8000367c <end_op>
    return -1;
    80004214:	557d                	li	a0,-1
    80004216:	bfc9                	j	800041e8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004218:	854a                	mv	a0,s2
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	d4e080e7          	jalr	-690(ra) # 80000f68 <proc_pagetable>
    80004222:	8baa                	mv	s7,a0
    80004224:	d945                	beqz	a0,800041d4 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004226:	e7042983          	lw	s3,-400(s0)
    8000422a:	e8845783          	lhu	a5,-376(s0)
    8000422e:	c7ad                	beqz	a5,80004298 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004230:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004232:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004234:	6c85                	lui	s9,0x1
    80004236:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000423a:	def43823          	sd	a5,-528(s0)
    8000423e:	ac0d                	j	80004470 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004240:	00004517          	auipc	a0,0x4
    80004244:	43850513          	addi	a0,a0,1080 # 80008678 <syscalls+0x290>
    80004248:	00002097          	auipc	ra,0x2
    8000424c:	aea080e7          	jalr	-1302(ra) # 80005d32 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004250:	8756                	mv	a4,s5
    80004252:	012d86bb          	addw	a3,s11,s2
    80004256:	4581                	li	a1,0
    80004258:	8526                	mv	a0,s1
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	c94080e7          	jalr	-876(ra) # 80002eee <readi>
    80004262:	2501                	sext.w	a0,a0
    80004264:	1aaa9a63          	bne	s5,a0,80004418 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004268:	6785                	lui	a5,0x1
    8000426a:	0127893b          	addw	s2,a5,s2
    8000426e:	77fd                	lui	a5,0xfffff
    80004270:	01478a3b          	addw	s4,a5,s4
    80004274:	1f897563          	bgeu	s2,s8,8000445e <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004278:	02091593          	slli	a1,s2,0x20
    8000427c:	9181                	srli	a1,a1,0x20
    8000427e:	95ea                	add	a1,a1,s10
    80004280:	855e                	mv	a0,s7
    80004282:	ffffc097          	auipc	ra,0xffffc
    80004286:	2d4080e7          	jalr	724(ra) # 80000556 <walkaddr>
    8000428a:	862a                	mv	a2,a0
    if(pa == 0)
    8000428c:	d955                	beqz	a0,80004240 <exec+0xf0>
      n = PGSIZE;
    8000428e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004290:	fd9a70e3          	bgeu	s4,s9,80004250 <exec+0x100>
      n = sz - i;
    80004294:	8ad2                	mv	s5,s4
    80004296:	bf6d                	j	80004250 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004298:	4a01                	li	s4,0
  iunlockput(ip);
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	c00080e7          	jalr	-1024(ra) # 80002e9c <iunlockput>
  end_op();
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	3d8080e7          	jalr	984(ra) # 8000367c <end_op>
  p = myproc();
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	bf8080e7          	jalr	-1032(ra) # 80000ea4 <myproc>
    800042b4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042b6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042ba:	6785                	lui	a5,0x1
    800042bc:	17fd                	addi	a5,a5,-1
    800042be:	9a3e                	add	s4,s4,a5
    800042c0:	757d                	lui	a0,0xfffff
    800042c2:	00aa77b3          	and	a5,s4,a0
    800042c6:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042ca:	4691                	li	a3,4
    800042cc:	6609                	lui	a2,0x2
    800042ce:	963e                	add	a2,a2,a5
    800042d0:	85be                	mv	a1,a5
    800042d2:	855e                	mv	a0,s7
    800042d4:	ffffc097          	auipc	ra,0xffffc
    800042d8:	636080e7          	jalr	1590(ra) # 8000090a <uvmalloc>
    800042dc:	8b2a                	mv	s6,a0
  ip = 0;
    800042de:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042e0:	12050c63          	beqz	a0,80004418 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042e4:	75f9                	lui	a1,0xffffe
    800042e6:	95aa                	add	a1,a1,a0
    800042e8:	855e                	mv	a0,s7
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	846080e7          	jalr	-1978(ra) # 80000b30 <uvmclear>
  stackbase = sp - PGSIZE;
    800042f2:	7c7d                	lui	s8,0xfffff
    800042f4:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042f6:	e0043783          	ld	a5,-512(s0)
    800042fa:	6388                	ld	a0,0(a5)
    800042fc:	c535                	beqz	a0,80004368 <exec+0x218>
    800042fe:	e9040993          	addi	s3,s0,-368
    80004302:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004306:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	040080e7          	jalr	64(ra) # 80000348 <strlen>
    80004310:	2505                	addiw	a0,a0,1
    80004312:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004316:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000431a:	13896663          	bltu	s2,s8,80004446 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000431e:	e0043d83          	ld	s11,-512(s0)
    80004322:	000dba03          	ld	s4,0(s11)
    80004326:	8552                	mv	a0,s4
    80004328:	ffffc097          	auipc	ra,0xffffc
    8000432c:	020080e7          	jalr	32(ra) # 80000348 <strlen>
    80004330:	0015069b          	addiw	a3,a0,1
    80004334:	8652                	mv	a2,s4
    80004336:	85ca                	mv	a1,s2
    80004338:	855e                	mv	a0,s7
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	828080e7          	jalr	-2008(ra) # 80000b62 <copyout>
    80004342:	10054663          	bltz	a0,8000444e <exec+0x2fe>
    ustack[argc] = sp;
    80004346:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000434a:	0485                	addi	s1,s1,1
    8000434c:	008d8793          	addi	a5,s11,8
    80004350:	e0f43023          	sd	a5,-512(s0)
    80004354:	008db503          	ld	a0,8(s11)
    80004358:	c911                	beqz	a0,8000436c <exec+0x21c>
    if(argc >= MAXARG)
    8000435a:	09a1                	addi	s3,s3,8
    8000435c:	fb3c96e3          	bne	s9,s3,80004308 <exec+0x1b8>
  sz = sz1;
    80004360:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004364:	4481                	li	s1,0
    80004366:	a84d                	j	80004418 <exec+0x2c8>
  sp = sz;
    80004368:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000436a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000436c:	00349793          	slli	a5,s1,0x3
    80004370:	f9040713          	addi	a4,s0,-112
    80004374:	97ba                	add	a5,a5,a4
    80004376:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000437a:	00148693          	addi	a3,s1,1
    8000437e:	068e                	slli	a3,a3,0x3
    80004380:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004384:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004388:	01897663          	bgeu	s2,s8,80004394 <exec+0x244>
  sz = sz1;
    8000438c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004390:	4481                	li	s1,0
    80004392:	a059                	j	80004418 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004394:	e9040613          	addi	a2,s0,-368
    80004398:	85ca                	mv	a1,s2
    8000439a:	855e                	mv	a0,s7
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	7c6080e7          	jalr	1990(ra) # 80000b62 <copyout>
    800043a4:	0a054963          	bltz	a0,80004456 <exec+0x306>
  p->trapframe->a1 = sp;
    800043a8:	058ab783          	ld	a5,88(s5)
    800043ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043b0:	df843783          	ld	a5,-520(s0)
    800043b4:	0007c703          	lbu	a4,0(a5)
    800043b8:	cf11                	beqz	a4,800043d4 <exec+0x284>
    800043ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043bc:	02f00693          	li	a3,47
    800043c0:	a039                	j	800043ce <exec+0x27e>
      last = s+1;
    800043c2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043c6:	0785                	addi	a5,a5,1
    800043c8:	fff7c703          	lbu	a4,-1(a5)
    800043cc:	c701                	beqz	a4,800043d4 <exec+0x284>
    if(*s == '/')
    800043ce:	fed71ce3          	bne	a4,a3,800043c6 <exec+0x276>
    800043d2:	bfc5                	j	800043c2 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800043d4:	4641                	li	a2,16
    800043d6:	df843583          	ld	a1,-520(s0)
    800043da:	158a8513          	addi	a0,s5,344
    800043de:	ffffc097          	auipc	ra,0xffffc
    800043e2:	f38080e7          	jalr	-200(ra) # 80000316 <safestrcpy>
  oldpagetable = p->pagetable;
    800043e6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043ea:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043ee:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043f2:	058ab783          	ld	a5,88(s5)
    800043f6:	e6843703          	ld	a4,-408(s0)
    800043fa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043fc:	058ab783          	ld	a5,88(s5)
    80004400:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004404:	85ea                	mv	a1,s10
    80004406:	ffffd097          	auipc	ra,0xffffd
    8000440a:	bfe080e7          	jalr	-1026(ra) # 80001004 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000440e:	0004851b          	sext.w	a0,s1
    80004412:	bbd9                	j	800041e8 <exec+0x98>
    80004414:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004418:	e0843583          	ld	a1,-504(s0)
    8000441c:	855e                	mv	a0,s7
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	be6080e7          	jalr	-1050(ra) # 80001004 <proc_freepagetable>
  if(ip){
    80004426:	da0497e3          	bnez	s1,800041d4 <exec+0x84>
  return -1;
    8000442a:	557d                	li	a0,-1
    8000442c:	bb75                	j	800041e8 <exec+0x98>
    8000442e:	e1443423          	sd	s4,-504(s0)
    80004432:	b7dd                	j	80004418 <exec+0x2c8>
    80004434:	e1443423          	sd	s4,-504(s0)
    80004438:	b7c5                	j	80004418 <exec+0x2c8>
    8000443a:	e1443423          	sd	s4,-504(s0)
    8000443e:	bfe9                	j	80004418 <exec+0x2c8>
    80004440:	e1443423          	sd	s4,-504(s0)
    80004444:	bfd1                	j	80004418 <exec+0x2c8>
  sz = sz1;
    80004446:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000444a:	4481                	li	s1,0
    8000444c:	b7f1                	j	80004418 <exec+0x2c8>
  sz = sz1;
    8000444e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004452:	4481                	li	s1,0
    80004454:	b7d1                	j	80004418 <exec+0x2c8>
  sz = sz1;
    80004456:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000445a:	4481                	li	s1,0
    8000445c:	bf75                	j	80004418 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000445e:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004462:	2b05                	addiw	s6,s6,1
    80004464:	0389899b          	addiw	s3,s3,56
    80004468:	e8845783          	lhu	a5,-376(s0)
    8000446c:	e2fb57e3          	bge	s6,a5,8000429a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004470:	2981                	sext.w	s3,s3
    80004472:	03800713          	li	a4,56
    80004476:	86ce                	mv	a3,s3
    80004478:	e1840613          	addi	a2,s0,-488
    8000447c:	4581                	li	a1,0
    8000447e:	8526                	mv	a0,s1
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	a6e080e7          	jalr	-1426(ra) # 80002eee <readi>
    80004488:	03800793          	li	a5,56
    8000448c:	f8f514e3          	bne	a0,a5,80004414 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004490:	e1842783          	lw	a5,-488(s0)
    80004494:	4705                	li	a4,1
    80004496:	fce796e3          	bne	a5,a4,80004462 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000449a:	e4043903          	ld	s2,-448(s0)
    8000449e:	e3843783          	ld	a5,-456(s0)
    800044a2:	f8f966e3          	bltu	s2,a5,8000442e <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044a6:	e2843783          	ld	a5,-472(s0)
    800044aa:	993e                	add	s2,s2,a5
    800044ac:	f8f964e3          	bltu	s2,a5,80004434 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044b0:	df043703          	ld	a4,-528(s0)
    800044b4:	8ff9                	and	a5,a5,a4
    800044b6:	f3d1                	bnez	a5,8000443a <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044b8:	e1c42503          	lw	a0,-484(s0)
    800044bc:	00000097          	auipc	ra,0x0
    800044c0:	c78080e7          	jalr	-904(ra) # 80004134 <flags2perm>
    800044c4:	86aa                	mv	a3,a0
    800044c6:	864a                	mv	a2,s2
    800044c8:	85d2                	mv	a1,s4
    800044ca:	855e                	mv	a0,s7
    800044cc:	ffffc097          	auipc	ra,0xffffc
    800044d0:	43e080e7          	jalr	1086(ra) # 8000090a <uvmalloc>
    800044d4:	e0a43423          	sd	a0,-504(s0)
    800044d8:	d525                	beqz	a0,80004440 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044da:	e2843d03          	ld	s10,-472(s0)
    800044de:	e2042d83          	lw	s11,-480(s0)
    800044e2:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044e6:	f60c0ce3          	beqz	s8,8000445e <exec+0x30e>
    800044ea:	8a62                	mv	s4,s8
    800044ec:	4901                	li	s2,0
    800044ee:	b369                	j	80004278 <exec+0x128>

00000000800044f0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044f0:	7179                	addi	sp,sp,-48
    800044f2:	f406                	sd	ra,40(sp)
    800044f4:	f022                	sd	s0,32(sp)
    800044f6:	ec26                	sd	s1,24(sp)
    800044f8:	e84a                	sd	s2,16(sp)
    800044fa:	1800                	addi	s0,sp,48
    800044fc:	892e                	mv	s2,a1
    800044fe:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004500:	fdc40593          	addi	a1,s0,-36
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	aec080e7          	jalr	-1300(ra) # 80001ff0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000450c:	fdc42703          	lw	a4,-36(s0)
    80004510:	47bd                	li	a5,15
    80004512:	02e7eb63          	bltu	a5,a4,80004548 <argfd+0x58>
    80004516:	ffffd097          	auipc	ra,0xffffd
    8000451a:	98e080e7          	jalr	-1650(ra) # 80000ea4 <myproc>
    8000451e:	fdc42703          	lw	a4,-36(s0)
    80004522:	01a70793          	addi	a5,a4,26
    80004526:	078e                	slli	a5,a5,0x3
    80004528:	953e                	add	a0,a0,a5
    8000452a:	611c                	ld	a5,0(a0)
    8000452c:	c385                	beqz	a5,8000454c <argfd+0x5c>
    return -1;
  if(pfd)
    8000452e:	00090463          	beqz	s2,80004536 <argfd+0x46>
    *pfd = fd;
    80004532:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004536:	4501                	li	a0,0
  if(pf)
    80004538:	c091                	beqz	s1,8000453c <argfd+0x4c>
    *pf = f;
    8000453a:	e09c                	sd	a5,0(s1)
}
    8000453c:	70a2                	ld	ra,40(sp)
    8000453e:	7402                	ld	s0,32(sp)
    80004540:	64e2                	ld	s1,24(sp)
    80004542:	6942                	ld	s2,16(sp)
    80004544:	6145                	addi	sp,sp,48
    80004546:	8082                	ret
    return -1;
    80004548:	557d                	li	a0,-1
    8000454a:	bfcd                	j	8000453c <argfd+0x4c>
    8000454c:	557d                	li	a0,-1
    8000454e:	b7fd                	j	8000453c <argfd+0x4c>

0000000080004550 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004550:	1101                	addi	sp,sp,-32
    80004552:	ec06                	sd	ra,24(sp)
    80004554:	e822                	sd	s0,16(sp)
    80004556:	e426                	sd	s1,8(sp)
    80004558:	1000                	addi	s0,sp,32
    8000455a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000455c:	ffffd097          	auipc	ra,0xffffd
    80004560:	948080e7          	jalr	-1720(ra) # 80000ea4 <myproc>
    80004564:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004566:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd030>
    8000456a:	4501                	li	a0,0
    8000456c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000456e:	6398                	ld	a4,0(a5)
    80004570:	cb19                	beqz	a4,80004586 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004572:	2505                	addiw	a0,a0,1
    80004574:	07a1                	addi	a5,a5,8
    80004576:	fed51ce3          	bne	a0,a3,8000456e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000457a:	557d                	li	a0,-1
}
    8000457c:	60e2                	ld	ra,24(sp)
    8000457e:	6442                	ld	s0,16(sp)
    80004580:	64a2                	ld	s1,8(sp)
    80004582:	6105                	addi	sp,sp,32
    80004584:	8082                	ret
      p->ofile[fd] = f;
    80004586:	01a50793          	addi	a5,a0,26
    8000458a:	078e                	slli	a5,a5,0x3
    8000458c:	963e                	add	a2,a2,a5
    8000458e:	e204                	sd	s1,0(a2)
      return fd;
    80004590:	b7f5                	j	8000457c <fdalloc+0x2c>

0000000080004592 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004592:	715d                	addi	sp,sp,-80
    80004594:	e486                	sd	ra,72(sp)
    80004596:	e0a2                	sd	s0,64(sp)
    80004598:	fc26                	sd	s1,56(sp)
    8000459a:	f84a                	sd	s2,48(sp)
    8000459c:	f44e                	sd	s3,40(sp)
    8000459e:	f052                	sd	s4,32(sp)
    800045a0:	ec56                	sd	s5,24(sp)
    800045a2:	e85a                	sd	s6,16(sp)
    800045a4:	0880                	addi	s0,sp,80
    800045a6:	8b2e                	mv	s6,a1
    800045a8:	89b2                	mv	s3,a2
    800045aa:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ac:	fb040593          	addi	a1,s0,-80
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	e4e080e7          	jalr	-434(ra) # 800033fe <nameiparent>
    800045b8:	84aa                	mv	s1,a0
    800045ba:	16050063          	beqz	a0,8000471a <create+0x188>
    return 0;

  ilock(dp);
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	67c080e7          	jalr	1660(ra) # 80002c3a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045c6:	4601                	li	a2,0
    800045c8:	fb040593          	addi	a1,s0,-80
    800045cc:	8526                	mv	a0,s1
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	b50080e7          	jalr	-1200(ra) # 8000311e <dirlookup>
    800045d6:	8aaa                	mv	s5,a0
    800045d8:	c931                	beqz	a0,8000462c <create+0x9a>
    iunlockput(dp);
    800045da:	8526                	mv	a0,s1
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	8c0080e7          	jalr	-1856(ra) # 80002e9c <iunlockput>
    ilock(ip);
    800045e4:	8556                	mv	a0,s5
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	654080e7          	jalr	1620(ra) # 80002c3a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045ee:	000b059b          	sext.w	a1,s6
    800045f2:	4789                	li	a5,2
    800045f4:	02f59563          	bne	a1,a5,8000461e <create+0x8c>
    800045f8:	044ad783          	lhu	a5,68(s5)
    800045fc:	37f9                	addiw	a5,a5,-2
    800045fe:	17c2                	slli	a5,a5,0x30
    80004600:	93c1                	srli	a5,a5,0x30
    80004602:	4705                	li	a4,1
    80004604:	00f76d63          	bltu	a4,a5,8000461e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004608:	8556                	mv	a0,s5
    8000460a:	60a6                	ld	ra,72(sp)
    8000460c:	6406                	ld	s0,64(sp)
    8000460e:	74e2                	ld	s1,56(sp)
    80004610:	7942                	ld	s2,48(sp)
    80004612:	79a2                	ld	s3,40(sp)
    80004614:	7a02                	ld	s4,32(sp)
    80004616:	6ae2                	ld	s5,24(sp)
    80004618:	6b42                	ld	s6,16(sp)
    8000461a:	6161                	addi	sp,sp,80
    8000461c:	8082                	ret
    iunlockput(ip);
    8000461e:	8556                	mv	a0,s5
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	87c080e7          	jalr	-1924(ra) # 80002e9c <iunlockput>
    return 0;
    80004628:	4a81                	li	s5,0
    8000462a:	bff9                	j	80004608 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000462c:	85da                	mv	a1,s6
    8000462e:	4088                	lw	a0,0(s1)
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	46e080e7          	jalr	1134(ra) # 80002a9e <ialloc>
    80004638:	8a2a                	mv	s4,a0
    8000463a:	c921                	beqz	a0,8000468a <create+0xf8>
  ilock(ip);
    8000463c:	ffffe097          	auipc	ra,0xffffe
    80004640:	5fe080e7          	jalr	1534(ra) # 80002c3a <ilock>
  ip->major = major;
    80004644:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004648:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000464c:	4785                	li	a5,1
    8000464e:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004652:	8552                	mv	a0,s4
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	51c080e7          	jalr	1308(ra) # 80002b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000465c:	000b059b          	sext.w	a1,s6
    80004660:	4785                	li	a5,1
    80004662:	02f58b63          	beq	a1,a5,80004698 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004666:	004a2603          	lw	a2,4(s4)
    8000466a:	fb040593          	addi	a1,s0,-80
    8000466e:	8526                	mv	a0,s1
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	cbe080e7          	jalr	-834(ra) # 8000332e <dirlink>
    80004678:	06054f63          	bltz	a0,800046f6 <create+0x164>
  iunlockput(dp);
    8000467c:	8526                	mv	a0,s1
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	81e080e7          	jalr	-2018(ra) # 80002e9c <iunlockput>
  return ip;
    80004686:	8ad2                	mv	s5,s4
    80004688:	b741                	j	80004608 <create+0x76>
    iunlockput(dp);
    8000468a:	8526                	mv	a0,s1
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	810080e7          	jalr	-2032(ra) # 80002e9c <iunlockput>
    return 0;
    80004694:	8ad2                	mv	s5,s4
    80004696:	bf8d                	j	80004608 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004698:	004a2603          	lw	a2,4(s4)
    8000469c:	00004597          	auipc	a1,0x4
    800046a0:	ffc58593          	addi	a1,a1,-4 # 80008698 <syscalls+0x2b0>
    800046a4:	8552                	mv	a0,s4
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	c88080e7          	jalr	-888(ra) # 8000332e <dirlink>
    800046ae:	04054463          	bltz	a0,800046f6 <create+0x164>
    800046b2:	40d0                	lw	a2,4(s1)
    800046b4:	00004597          	auipc	a1,0x4
    800046b8:	fec58593          	addi	a1,a1,-20 # 800086a0 <syscalls+0x2b8>
    800046bc:	8552                	mv	a0,s4
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	c70080e7          	jalr	-912(ra) # 8000332e <dirlink>
    800046c6:	02054863          	bltz	a0,800046f6 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ca:	004a2603          	lw	a2,4(s4)
    800046ce:	fb040593          	addi	a1,s0,-80
    800046d2:	8526                	mv	a0,s1
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c5a080e7          	jalr	-934(ra) # 8000332e <dirlink>
    800046dc:	00054d63          	bltz	a0,800046f6 <create+0x164>
    dp->nlink++;  // for ".."
    800046e0:	04a4d783          	lhu	a5,74(s1)
    800046e4:	2785                	addiw	a5,a5,1
    800046e6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046ea:	8526                	mv	a0,s1
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	484080e7          	jalr	1156(ra) # 80002b70 <iupdate>
    800046f4:	b761                	j	8000467c <create+0xea>
  ip->nlink = 0;
    800046f6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046fa:	8552                	mv	a0,s4
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	474080e7          	jalr	1140(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    80004704:	8552                	mv	a0,s4
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	796080e7          	jalr	1942(ra) # 80002e9c <iunlockput>
  iunlockput(dp);
    8000470e:	8526                	mv	a0,s1
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	78c080e7          	jalr	1932(ra) # 80002e9c <iunlockput>
  return 0;
    80004718:	bdc5                	j	80004608 <create+0x76>
    return 0;
    8000471a:	8aaa                	mv	s5,a0
    8000471c:	b5f5                	j	80004608 <create+0x76>

000000008000471e <sys_dup>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	ec26                	sd	s1,24(sp)
    80004726:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004728:	fd840613          	addi	a2,s0,-40
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	dc0080e7          	jalr	-576(ra) # 800044f0 <argfd>
    return -1;
    80004738:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000473a:	02054363          	bltz	a0,80004760 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000473e:	fd843503          	ld	a0,-40(s0)
    80004742:	00000097          	auipc	ra,0x0
    80004746:	e0e080e7          	jalr	-498(ra) # 80004550 <fdalloc>
    8000474a:	84aa                	mv	s1,a0
    return -1;
    8000474c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000474e:	00054963          	bltz	a0,80004760 <sys_dup+0x42>
  filedup(f);
    80004752:	fd843503          	ld	a0,-40(s0)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	320080e7          	jalr	800(ra) # 80003a76 <filedup>
  return fd;
    8000475e:	87a6                	mv	a5,s1
}
    80004760:	853e                	mv	a0,a5
    80004762:	70a2                	ld	ra,40(sp)
    80004764:	7402                	ld	s0,32(sp)
    80004766:	64e2                	ld	s1,24(sp)
    80004768:	6145                	addi	sp,sp,48
    8000476a:	8082                	ret

000000008000476c <sys_read>:
{
    8000476c:	7179                	addi	sp,sp,-48
    8000476e:	f406                	sd	ra,40(sp)
    80004770:	f022                	sd	s0,32(sp)
    80004772:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004774:	fd840593          	addi	a1,s0,-40
    80004778:	4505                	li	a0,1
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	896080e7          	jalr	-1898(ra) # 80002010 <argaddr>
  argint(2, &n);
    80004782:	fe440593          	addi	a1,s0,-28
    80004786:	4509                	li	a0,2
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	868080e7          	jalr	-1944(ra) # 80001ff0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004790:	fe840613          	addi	a2,s0,-24
    80004794:	4581                	li	a1,0
    80004796:	4501                	li	a0,0
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	d58080e7          	jalr	-680(ra) # 800044f0 <argfd>
    800047a0:	87aa                	mv	a5,a0
    return -1;
    800047a2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047a4:	0007cc63          	bltz	a5,800047bc <sys_read+0x50>
  return fileread(f, p, n);
    800047a8:	fe442603          	lw	a2,-28(s0)
    800047ac:	fd843583          	ld	a1,-40(s0)
    800047b0:	fe843503          	ld	a0,-24(s0)
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	44e080e7          	jalr	1102(ra) # 80003c02 <fileread>
}
    800047bc:	70a2                	ld	ra,40(sp)
    800047be:	7402                	ld	s0,32(sp)
    800047c0:	6145                	addi	sp,sp,48
    800047c2:	8082                	ret

00000000800047c4 <sys_write>:
{
    800047c4:	7179                	addi	sp,sp,-48
    800047c6:	f406                	sd	ra,40(sp)
    800047c8:	f022                	sd	s0,32(sp)
    800047ca:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047cc:	fd840593          	addi	a1,s0,-40
    800047d0:	4505                	li	a0,1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	83e080e7          	jalr	-1986(ra) # 80002010 <argaddr>
  argint(2, &n);
    800047da:	fe440593          	addi	a1,s0,-28
    800047de:	4509                	li	a0,2
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	810080e7          	jalr	-2032(ra) # 80001ff0 <argint>
  if(argfd(0, 0, &f) < 0)
    800047e8:	fe840613          	addi	a2,s0,-24
    800047ec:	4581                	li	a1,0
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	d00080e7          	jalr	-768(ra) # 800044f0 <argfd>
    800047f8:	87aa                	mv	a5,a0
    return -1;
    800047fa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047fc:	0007cc63          	bltz	a5,80004814 <sys_write+0x50>
  return filewrite(f, p, n);
    80004800:	fe442603          	lw	a2,-28(s0)
    80004804:	fd843583          	ld	a1,-40(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	4b8080e7          	jalr	1208(ra) # 80003cc4 <filewrite>
}
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	6145                	addi	sp,sp,48
    8000481a:	8082                	ret

000000008000481c <sys_close>:
{
    8000481c:	1101                	addi	sp,sp,-32
    8000481e:	ec06                	sd	ra,24(sp)
    80004820:	e822                	sd	s0,16(sp)
    80004822:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004824:	fe040613          	addi	a2,s0,-32
    80004828:	fec40593          	addi	a1,s0,-20
    8000482c:	4501                	li	a0,0
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	cc2080e7          	jalr	-830(ra) # 800044f0 <argfd>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004838:	02054463          	bltz	a0,80004860 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	668080e7          	jalr	1640(ra) # 80000ea4 <myproc>
    80004844:	fec42783          	lw	a5,-20(s0)
    80004848:	07e9                	addi	a5,a5,26
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	97aa                	add	a5,a5,a0
    8000484e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004852:	fe043503          	ld	a0,-32(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	272080e7          	jalr	626(ra) # 80003ac8 <fileclose>
  return 0;
    8000485e:	4781                	li	a5,0
}
    80004860:	853e                	mv	a0,a5
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <sys_fstat>:
{
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004872:	fe040593          	addi	a1,s0,-32
    80004876:	4505                	li	a0,1
    80004878:	ffffd097          	auipc	ra,0xffffd
    8000487c:	798080e7          	jalr	1944(ra) # 80002010 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004880:	fe840613          	addi	a2,s0,-24
    80004884:	4581                	li	a1,0
    80004886:	4501                	li	a0,0
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	c68080e7          	jalr	-920(ra) # 800044f0 <argfd>
    80004890:	87aa                	mv	a5,a0
    return -1;
    80004892:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004894:	0007ca63          	bltz	a5,800048a8 <sys_fstat+0x3e>
  return filestat(f, st);
    80004898:	fe043583          	ld	a1,-32(s0)
    8000489c:	fe843503          	ld	a0,-24(s0)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	2f0080e7          	jalr	752(ra) # 80003b90 <filestat>
}
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	6105                	addi	sp,sp,32
    800048ae:	8082                	ret

00000000800048b0 <sys_link>:
{
    800048b0:	7169                	addi	sp,sp,-304
    800048b2:	f606                	sd	ra,296(sp)
    800048b4:	f222                	sd	s0,288(sp)
    800048b6:	ee26                	sd	s1,280(sp)
    800048b8:	ea4a                	sd	s2,272(sp)
    800048ba:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048bc:	08000613          	li	a2,128
    800048c0:	ed040593          	addi	a1,s0,-304
    800048c4:	4501                	li	a0,0
    800048c6:	ffffd097          	auipc	ra,0xffffd
    800048ca:	76a080e7          	jalr	1898(ra) # 80002030 <argstr>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048d0:	10054e63          	bltz	a0,800049ec <sys_link+0x13c>
    800048d4:	08000613          	li	a2,128
    800048d8:	f5040593          	addi	a1,s0,-176
    800048dc:	4505                	li	a0,1
    800048de:	ffffd097          	auipc	ra,0xffffd
    800048e2:	752080e7          	jalr	1874(ra) # 80002030 <argstr>
    return -1;
    800048e6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e8:	10054263          	bltz	a0,800049ec <sys_link+0x13c>
  begin_op();
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	d10080e7          	jalr	-752(ra) # 800035fc <begin_op>
  if((ip = namei(old)) == 0){
    800048f4:	ed040513          	addi	a0,s0,-304
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	ae8080e7          	jalr	-1304(ra) # 800033e0 <namei>
    80004900:	84aa                	mv	s1,a0
    80004902:	c551                	beqz	a0,8000498e <sys_link+0xde>
  ilock(ip);
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	336080e7          	jalr	822(ra) # 80002c3a <ilock>
  if(ip->type == T_DIR){
    8000490c:	04449703          	lh	a4,68(s1)
    80004910:	4785                	li	a5,1
    80004912:	08f70463          	beq	a4,a5,8000499a <sys_link+0xea>
  ip->nlink++;
    80004916:	04a4d783          	lhu	a5,74(s1)
    8000491a:	2785                	addiw	a5,a5,1
    8000491c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	24e080e7          	jalr	590(ra) # 80002b70 <iupdate>
  iunlock(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	3d0080e7          	jalr	976(ra) # 80002cfc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004934:	fd040593          	addi	a1,s0,-48
    80004938:	f5040513          	addi	a0,s0,-176
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	ac2080e7          	jalr	-1342(ra) # 800033fe <nameiparent>
    80004944:	892a                	mv	s2,a0
    80004946:	c935                	beqz	a0,800049ba <sys_link+0x10a>
  ilock(dp);
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	2f2080e7          	jalr	754(ra) # 80002c3a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004950:	00092703          	lw	a4,0(s2)
    80004954:	409c                	lw	a5,0(s1)
    80004956:	04f71d63          	bne	a4,a5,800049b0 <sys_link+0x100>
    8000495a:	40d0                	lw	a2,4(s1)
    8000495c:	fd040593          	addi	a1,s0,-48
    80004960:	854a                	mv	a0,s2
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	9cc080e7          	jalr	-1588(ra) # 8000332e <dirlink>
    8000496a:	04054363          	bltz	a0,800049b0 <sys_link+0x100>
  iunlockput(dp);
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	52c080e7          	jalr	1324(ra) # 80002e9c <iunlockput>
  iput(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	47a080e7          	jalr	1146(ra) # 80002df4 <iput>
  end_op();
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	cfa080e7          	jalr	-774(ra) # 8000367c <end_op>
  return 0;
    8000498a:	4781                	li	a5,0
    8000498c:	a085                	j	800049ec <sys_link+0x13c>
    end_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	cee080e7          	jalr	-786(ra) # 8000367c <end_op>
    return -1;
    80004996:	57fd                	li	a5,-1
    80004998:	a891                	j	800049ec <sys_link+0x13c>
    iunlockput(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	500080e7          	jalr	1280(ra) # 80002e9c <iunlockput>
    end_op();
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	cd8080e7          	jalr	-808(ra) # 8000367c <end_op>
    return -1;
    800049ac:	57fd                	li	a5,-1
    800049ae:	a83d                	j	800049ec <sys_link+0x13c>
    iunlockput(dp);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	4ea080e7          	jalr	1258(ra) # 80002e9c <iunlockput>
  ilock(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	27e080e7          	jalr	638(ra) # 80002c3a <ilock>
  ip->nlink--;
    800049c4:	04a4d783          	lhu	a5,74(s1)
    800049c8:	37fd                	addiw	a5,a5,-1
    800049ca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	1a0080e7          	jalr	416(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	4c2080e7          	jalr	1218(ra) # 80002e9c <iunlockput>
  end_op();
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	c9a080e7          	jalr	-870(ra) # 8000367c <end_op>
  return -1;
    800049ea:	57fd                	li	a5,-1
}
    800049ec:	853e                	mv	a0,a5
    800049ee:	70b2                	ld	ra,296(sp)
    800049f0:	7412                	ld	s0,288(sp)
    800049f2:	64f2                	ld	s1,280(sp)
    800049f4:	6952                	ld	s2,272(sp)
    800049f6:	6155                	addi	sp,sp,304
    800049f8:	8082                	ret

00000000800049fa <sys_unlink>:
{
    800049fa:	7151                	addi	sp,sp,-240
    800049fc:	f586                	sd	ra,232(sp)
    800049fe:	f1a2                	sd	s0,224(sp)
    80004a00:	eda6                	sd	s1,216(sp)
    80004a02:	e9ca                	sd	s2,208(sp)
    80004a04:	e5ce                	sd	s3,200(sp)
    80004a06:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a08:	08000613          	li	a2,128
    80004a0c:	f3040593          	addi	a1,s0,-208
    80004a10:	4501                	li	a0,0
    80004a12:	ffffd097          	auipc	ra,0xffffd
    80004a16:	61e080e7          	jalr	1566(ra) # 80002030 <argstr>
    80004a1a:	18054163          	bltz	a0,80004b9c <sys_unlink+0x1a2>
  begin_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	bde080e7          	jalr	-1058(ra) # 800035fc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a26:	fb040593          	addi	a1,s0,-80
    80004a2a:	f3040513          	addi	a0,s0,-208
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	9d0080e7          	jalr	-1584(ra) # 800033fe <nameiparent>
    80004a36:	84aa                	mv	s1,a0
    80004a38:	c979                	beqz	a0,80004b0e <sys_unlink+0x114>
  ilock(dp);
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	200080e7          	jalr	512(ra) # 80002c3a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a42:	00004597          	auipc	a1,0x4
    80004a46:	c5658593          	addi	a1,a1,-938 # 80008698 <syscalls+0x2b0>
    80004a4a:	fb040513          	addi	a0,s0,-80
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	6b6080e7          	jalr	1718(ra) # 80003104 <namecmp>
    80004a56:	14050a63          	beqz	a0,80004baa <sys_unlink+0x1b0>
    80004a5a:	00004597          	auipc	a1,0x4
    80004a5e:	c4658593          	addi	a1,a1,-954 # 800086a0 <syscalls+0x2b8>
    80004a62:	fb040513          	addi	a0,s0,-80
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	69e080e7          	jalr	1694(ra) # 80003104 <namecmp>
    80004a6e:	12050e63          	beqz	a0,80004baa <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a72:	f2c40613          	addi	a2,s0,-212
    80004a76:	fb040593          	addi	a1,s0,-80
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	6a2080e7          	jalr	1698(ra) # 8000311e <dirlookup>
    80004a84:	892a                	mv	s2,a0
    80004a86:	12050263          	beqz	a0,80004baa <sys_unlink+0x1b0>
  ilock(ip);
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	1b0080e7          	jalr	432(ra) # 80002c3a <ilock>
  if(ip->nlink < 1)
    80004a92:	04a91783          	lh	a5,74(s2)
    80004a96:	08f05263          	blez	a5,80004b1a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a9a:	04491703          	lh	a4,68(s2)
    80004a9e:	4785                	li	a5,1
    80004aa0:	08f70563          	beq	a4,a5,80004b2a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aa4:	4641                	li	a2,16
    80004aa6:	4581                	li	a1,0
    80004aa8:	fc040513          	addi	a0,s0,-64
    80004aac:	ffffb097          	auipc	ra,0xffffb
    80004ab0:	718080e7          	jalr	1816(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab4:	4741                	li	a4,16
    80004ab6:	f2c42683          	lw	a3,-212(s0)
    80004aba:	fc040613          	addi	a2,s0,-64
    80004abe:	4581                	li	a1,0
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	524080e7          	jalr	1316(ra) # 80002fe6 <writei>
    80004aca:	47c1                	li	a5,16
    80004acc:	0af51563          	bne	a0,a5,80004b76 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ad0:	04491703          	lh	a4,68(s2)
    80004ad4:	4785                	li	a5,1
    80004ad6:	0af70863          	beq	a4,a5,80004b86 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	3c0080e7          	jalr	960(ra) # 80002e9c <iunlockput>
  ip->nlink--;
    80004ae4:	04a95783          	lhu	a5,74(s2)
    80004ae8:	37fd                	addiw	a5,a5,-1
    80004aea:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	080080e7          	jalr	128(ra) # 80002b70 <iupdate>
  iunlockput(ip);
    80004af8:	854a                	mv	a0,s2
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	3a2080e7          	jalr	930(ra) # 80002e9c <iunlockput>
  end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	b7a080e7          	jalr	-1158(ra) # 8000367c <end_op>
  return 0;
    80004b0a:	4501                	li	a0,0
    80004b0c:	a84d                	j	80004bbe <sys_unlink+0x1c4>
    end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	b6e080e7          	jalr	-1170(ra) # 8000367c <end_op>
    return -1;
    80004b16:	557d                	li	a0,-1
    80004b18:	a05d                	j	80004bbe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b1a:	00004517          	auipc	a0,0x4
    80004b1e:	b8e50513          	addi	a0,a0,-1138 # 800086a8 <syscalls+0x2c0>
    80004b22:	00001097          	auipc	ra,0x1
    80004b26:	210080e7          	jalr	528(ra) # 80005d32 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b2a:	04c92703          	lw	a4,76(s2)
    80004b2e:	02000793          	li	a5,32
    80004b32:	f6e7f9e3          	bgeu	a5,a4,80004aa4 <sys_unlink+0xaa>
    80004b36:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b3a:	4741                	li	a4,16
    80004b3c:	86ce                	mv	a3,s3
    80004b3e:	f1840613          	addi	a2,s0,-232
    80004b42:	4581                	li	a1,0
    80004b44:	854a                	mv	a0,s2
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	3a8080e7          	jalr	936(ra) # 80002eee <readi>
    80004b4e:	47c1                	li	a5,16
    80004b50:	00f51b63          	bne	a0,a5,80004b66 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b54:	f1845783          	lhu	a5,-232(s0)
    80004b58:	e7a1                	bnez	a5,80004ba0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b5a:	29c1                	addiw	s3,s3,16
    80004b5c:	04c92783          	lw	a5,76(s2)
    80004b60:	fcf9ede3          	bltu	s3,a5,80004b3a <sys_unlink+0x140>
    80004b64:	b781                	j	80004aa4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b66:	00004517          	auipc	a0,0x4
    80004b6a:	b5a50513          	addi	a0,a0,-1190 # 800086c0 <syscalls+0x2d8>
    80004b6e:	00001097          	auipc	ra,0x1
    80004b72:	1c4080e7          	jalr	452(ra) # 80005d32 <panic>
    panic("unlink: writei");
    80004b76:	00004517          	auipc	a0,0x4
    80004b7a:	b6250513          	addi	a0,a0,-1182 # 800086d8 <syscalls+0x2f0>
    80004b7e:	00001097          	auipc	ra,0x1
    80004b82:	1b4080e7          	jalr	436(ra) # 80005d32 <panic>
    dp->nlink--;
    80004b86:	04a4d783          	lhu	a5,74(s1)
    80004b8a:	37fd                	addiw	a5,a5,-1
    80004b8c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	fde080e7          	jalr	-34(ra) # 80002b70 <iupdate>
    80004b9a:	b781                	j	80004ada <sys_unlink+0xe0>
    return -1;
    80004b9c:	557d                	li	a0,-1
    80004b9e:	a005                	j	80004bbe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	2fa080e7          	jalr	762(ra) # 80002e9c <iunlockput>
  iunlockput(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	2f0080e7          	jalr	752(ra) # 80002e9c <iunlockput>
  end_op();
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	ac8080e7          	jalr	-1336(ra) # 8000367c <end_op>
  return -1;
    80004bbc:	557d                	li	a0,-1
}
    80004bbe:	70ae                	ld	ra,232(sp)
    80004bc0:	740e                	ld	s0,224(sp)
    80004bc2:	64ee                	ld	s1,216(sp)
    80004bc4:	694e                	ld	s2,208(sp)
    80004bc6:	69ae                	ld	s3,200(sp)
    80004bc8:	616d                	addi	sp,sp,240
    80004bca:	8082                	ret

0000000080004bcc <sys_open>:

uint64
sys_open(void)
{
    80004bcc:	7131                	addi	sp,sp,-192
    80004bce:	fd06                	sd	ra,184(sp)
    80004bd0:	f922                	sd	s0,176(sp)
    80004bd2:	f526                	sd	s1,168(sp)
    80004bd4:	f14a                	sd	s2,160(sp)
    80004bd6:	ed4e                	sd	s3,152(sp)
    80004bd8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bda:	f4c40593          	addi	a1,s0,-180
    80004bde:	4505                	li	a0,1
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	410080e7          	jalr	1040(ra) # 80001ff0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004be8:	08000613          	li	a2,128
    80004bec:	f5040593          	addi	a1,s0,-176
    80004bf0:	4501                	li	a0,0
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	43e080e7          	jalr	1086(ra) # 80002030 <argstr>
    80004bfa:	87aa                	mv	a5,a0
    return -1;
    80004bfc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bfe:	0a07c963          	bltz	a5,80004cb0 <sys_open+0xe4>

  begin_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	9fa080e7          	jalr	-1542(ra) # 800035fc <begin_op>

  if(omode & O_CREATE){
    80004c0a:	f4c42783          	lw	a5,-180(s0)
    80004c0e:	2007f793          	andi	a5,a5,512
    80004c12:	cfc5                	beqz	a5,80004cca <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c14:	4681                	li	a3,0
    80004c16:	4601                	li	a2,0
    80004c18:	4589                	li	a1,2
    80004c1a:	f5040513          	addi	a0,s0,-176
    80004c1e:	00000097          	auipc	ra,0x0
    80004c22:	974080e7          	jalr	-1676(ra) # 80004592 <create>
    80004c26:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c28:	c959                	beqz	a0,80004cbe <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c2a:	04449703          	lh	a4,68(s1)
    80004c2e:	478d                	li	a5,3
    80004c30:	00f71763          	bne	a4,a5,80004c3e <sys_open+0x72>
    80004c34:	0464d703          	lhu	a4,70(s1)
    80004c38:	47a5                	li	a5,9
    80004c3a:	0ce7ed63          	bltu	a5,a4,80004d14 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	dce080e7          	jalr	-562(ra) # 80003a0c <filealloc>
    80004c46:	89aa                	mv	s3,a0
    80004c48:	10050363          	beqz	a0,80004d4e <sys_open+0x182>
    80004c4c:	00000097          	auipc	ra,0x0
    80004c50:	904080e7          	jalr	-1788(ra) # 80004550 <fdalloc>
    80004c54:	892a                	mv	s2,a0
    80004c56:	0e054763          	bltz	a0,80004d44 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c5a:	04449703          	lh	a4,68(s1)
    80004c5e:	478d                	li	a5,3
    80004c60:	0cf70563          	beq	a4,a5,80004d2a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c64:	4789                	li	a5,2
    80004c66:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c6a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c6e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c72:	f4c42783          	lw	a5,-180(s0)
    80004c76:	0017c713          	xori	a4,a5,1
    80004c7a:	8b05                	andi	a4,a4,1
    80004c7c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c80:	0037f713          	andi	a4,a5,3
    80004c84:	00e03733          	snez	a4,a4
    80004c88:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c8c:	4007f793          	andi	a5,a5,1024
    80004c90:	c791                	beqz	a5,80004c9c <sys_open+0xd0>
    80004c92:	04449703          	lh	a4,68(s1)
    80004c96:	4789                	li	a5,2
    80004c98:	0af70063          	beq	a4,a5,80004d38 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	05e080e7          	jalr	94(ra) # 80002cfc <iunlock>
  end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	9d6080e7          	jalr	-1578(ra) # 8000367c <end_op>

  return fd;
    80004cae:	854a                	mv	a0,s2
}
    80004cb0:	70ea                	ld	ra,184(sp)
    80004cb2:	744a                	ld	s0,176(sp)
    80004cb4:	74aa                	ld	s1,168(sp)
    80004cb6:	790a                	ld	s2,160(sp)
    80004cb8:	69ea                	ld	s3,152(sp)
    80004cba:	6129                	addi	sp,sp,192
    80004cbc:	8082                	ret
      end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	9be080e7          	jalr	-1602(ra) # 8000367c <end_op>
      return -1;
    80004cc6:	557d                	li	a0,-1
    80004cc8:	b7e5                	j	80004cb0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cca:	f5040513          	addi	a0,s0,-176
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	712080e7          	jalr	1810(ra) # 800033e0 <namei>
    80004cd6:	84aa                	mv	s1,a0
    80004cd8:	c905                	beqz	a0,80004d08 <sys_open+0x13c>
    ilock(ip);
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	f60080e7          	jalr	-160(ra) # 80002c3a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ce2:	04449703          	lh	a4,68(s1)
    80004ce6:	4785                	li	a5,1
    80004ce8:	f4f711e3          	bne	a4,a5,80004c2a <sys_open+0x5e>
    80004cec:	f4c42783          	lw	a5,-180(s0)
    80004cf0:	d7b9                	beqz	a5,80004c3e <sys_open+0x72>
      iunlockput(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	1a8080e7          	jalr	424(ra) # 80002e9c <iunlockput>
      end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	980080e7          	jalr	-1664(ra) # 8000367c <end_op>
      return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	b76d                	j	80004cb0 <sys_open+0xe4>
      end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	974080e7          	jalr	-1676(ra) # 8000367c <end_op>
      return -1;
    80004d10:	557d                	li	a0,-1
    80004d12:	bf79                	j	80004cb0 <sys_open+0xe4>
    iunlockput(ip);
    80004d14:	8526                	mv	a0,s1
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	186080e7          	jalr	390(ra) # 80002e9c <iunlockput>
    end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	95e080e7          	jalr	-1698(ra) # 8000367c <end_op>
    return -1;
    80004d26:	557d                	li	a0,-1
    80004d28:	b761                	j	80004cb0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d2a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d2e:	04649783          	lh	a5,70(s1)
    80004d32:	02f99223          	sh	a5,36(s3)
    80004d36:	bf25                	j	80004c6e <sys_open+0xa2>
    itrunc(ip);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	00e080e7          	jalr	14(ra) # 80002d48 <itrunc>
    80004d42:	bfa9                	j	80004c9c <sys_open+0xd0>
      fileclose(f);
    80004d44:	854e                	mv	a0,s3
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	d82080e7          	jalr	-638(ra) # 80003ac8 <fileclose>
    iunlockput(ip);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	14c080e7          	jalr	332(ra) # 80002e9c <iunlockput>
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	924080e7          	jalr	-1756(ra) # 8000367c <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7b9                	j	80004cb0 <sys_open+0xe4>

0000000080004d64 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d64:	7175                	addi	sp,sp,-144
    80004d66:	e506                	sd	ra,136(sp)
    80004d68:	e122                	sd	s0,128(sp)
    80004d6a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	890080e7          	jalr	-1904(ra) # 800035fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d74:	08000613          	li	a2,128
    80004d78:	f7040593          	addi	a1,s0,-144
    80004d7c:	4501                	li	a0,0
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	2b2080e7          	jalr	690(ra) # 80002030 <argstr>
    80004d86:	02054963          	bltz	a0,80004db8 <sys_mkdir+0x54>
    80004d8a:	4681                	li	a3,0
    80004d8c:	4601                	li	a2,0
    80004d8e:	4585                	li	a1,1
    80004d90:	f7040513          	addi	a0,s0,-144
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	7fe080e7          	jalr	2046(ra) # 80004592 <create>
    80004d9c:	cd11                	beqz	a0,80004db8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	0fe080e7          	jalr	254(ra) # 80002e9c <iunlockput>
  end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	8d6080e7          	jalr	-1834(ra) # 8000367c <end_op>
  return 0;
    80004dae:	4501                	li	a0,0
}
    80004db0:	60aa                	ld	ra,136(sp)
    80004db2:	640a                	ld	s0,128(sp)
    80004db4:	6149                	addi	sp,sp,144
    80004db6:	8082                	ret
    end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	8c4080e7          	jalr	-1852(ra) # 8000367c <end_op>
    return -1;
    80004dc0:	557d                	li	a0,-1
    80004dc2:	b7fd                	j	80004db0 <sys_mkdir+0x4c>

0000000080004dc4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dc4:	7135                	addi	sp,sp,-160
    80004dc6:	ed06                	sd	ra,152(sp)
    80004dc8:	e922                	sd	s0,144(sp)
    80004dca:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	830080e7          	jalr	-2000(ra) # 800035fc <begin_op>
  argint(1, &major);
    80004dd4:	f6c40593          	addi	a1,s0,-148
    80004dd8:	4505                	li	a0,1
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	216080e7          	jalr	534(ra) # 80001ff0 <argint>
  argint(2, &minor);
    80004de2:	f6840593          	addi	a1,s0,-152
    80004de6:	4509                	li	a0,2
    80004de8:	ffffd097          	auipc	ra,0xffffd
    80004dec:	208080e7          	jalr	520(ra) # 80001ff0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004df0:	08000613          	li	a2,128
    80004df4:	f7040593          	addi	a1,s0,-144
    80004df8:	4501                	li	a0,0
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	236080e7          	jalr	566(ra) # 80002030 <argstr>
    80004e02:	02054b63          	bltz	a0,80004e38 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e06:	f6841683          	lh	a3,-152(s0)
    80004e0a:	f6c41603          	lh	a2,-148(s0)
    80004e0e:	458d                	li	a1,3
    80004e10:	f7040513          	addi	a0,s0,-144
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	77e080e7          	jalr	1918(ra) # 80004592 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e1c:	cd11                	beqz	a0,80004e38 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	07e080e7          	jalr	126(ra) # 80002e9c <iunlockput>
  end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	856080e7          	jalr	-1962(ra) # 8000367c <end_op>
  return 0;
    80004e2e:	4501                	li	a0,0
}
    80004e30:	60ea                	ld	ra,152(sp)
    80004e32:	644a                	ld	s0,144(sp)
    80004e34:	610d                	addi	sp,sp,160
    80004e36:	8082                	ret
    end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	844080e7          	jalr	-1980(ra) # 8000367c <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	b7fd                	j	80004e30 <sys_mknod+0x6c>

0000000080004e44 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e44:	7135                	addi	sp,sp,-160
    80004e46:	ed06                	sd	ra,152(sp)
    80004e48:	e922                	sd	s0,144(sp)
    80004e4a:	e526                	sd	s1,136(sp)
    80004e4c:	e14a                	sd	s2,128(sp)
    80004e4e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	054080e7          	jalr	84(ra) # 80000ea4 <myproc>
    80004e58:	892a                	mv	s2,a0
  
  begin_op();
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	7a2080e7          	jalr	1954(ra) # 800035fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e62:	08000613          	li	a2,128
    80004e66:	f6040593          	addi	a1,s0,-160
    80004e6a:	4501                	li	a0,0
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	1c4080e7          	jalr	452(ra) # 80002030 <argstr>
    80004e74:	04054b63          	bltz	a0,80004eca <sys_chdir+0x86>
    80004e78:	f6040513          	addi	a0,s0,-160
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	564080e7          	jalr	1380(ra) # 800033e0 <namei>
    80004e84:	84aa                	mv	s1,a0
    80004e86:	c131                	beqz	a0,80004eca <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	db2080e7          	jalr	-590(ra) # 80002c3a <ilock>
  if(ip->type != T_DIR){
    80004e90:	04449703          	lh	a4,68(s1)
    80004e94:	4785                	li	a5,1
    80004e96:	04f71063          	bne	a4,a5,80004ed6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	e60080e7          	jalr	-416(ra) # 80002cfc <iunlock>
  iput(p->cwd);
    80004ea4:	15093503          	ld	a0,336(s2)
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	f4c080e7          	jalr	-180(ra) # 80002df4 <iput>
  end_op();
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	7cc080e7          	jalr	1996(ra) # 8000367c <end_op>
  p->cwd = ip;
    80004eb8:	14993823          	sd	s1,336(s2)
  return 0;
    80004ebc:	4501                	li	a0,0
}
    80004ebe:	60ea                	ld	ra,152(sp)
    80004ec0:	644a                	ld	s0,144(sp)
    80004ec2:	64aa                	ld	s1,136(sp)
    80004ec4:	690a                	ld	s2,128(sp)
    80004ec6:	610d                	addi	sp,sp,160
    80004ec8:	8082                	ret
    end_op();
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	7b2080e7          	jalr	1970(ra) # 8000367c <end_op>
    return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	b7ed                	j	80004ebe <sys_chdir+0x7a>
    iunlockput(ip);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	fc4080e7          	jalr	-60(ra) # 80002e9c <iunlockput>
    end_op();
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	79c080e7          	jalr	1948(ra) # 8000367c <end_op>
    return -1;
    80004ee8:	557d                	li	a0,-1
    80004eea:	bfd1                	j	80004ebe <sys_chdir+0x7a>

0000000080004eec <sys_exec>:

uint64
sys_exec(void)
{
    80004eec:	7145                	addi	sp,sp,-464
    80004eee:	e786                	sd	ra,456(sp)
    80004ef0:	e3a2                	sd	s0,448(sp)
    80004ef2:	ff26                	sd	s1,440(sp)
    80004ef4:	fb4a                	sd	s2,432(sp)
    80004ef6:	f74e                	sd	s3,424(sp)
    80004ef8:	f352                	sd	s4,416(sp)
    80004efa:	ef56                	sd	s5,408(sp)
    80004efc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004efe:	e3840593          	addi	a1,s0,-456
    80004f02:	4505                	li	a0,1
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	10c080e7          	jalr	268(ra) # 80002010 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f0c:	08000613          	li	a2,128
    80004f10:	f4040593          	addi	a1,s0,-192
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	11a080e7          	jalr	282(ra) # 80002030 <argstr>
    80004f1e:	87aa                	mv	a5,a0
    return -1;
    80004f20:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f22:	0c07c263          	bltz	a5,80004fe6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f26:	10000613          	li	a2,256
    80004f2a:	4581                	li	a1,0
    80004f2c:	e4040513          	addi	a0,s0,-448
    80004f30:	ffffb097          	auipc	ra,0xffffb
    80004f34:	294080e7          	jalr	660(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f38:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f3c:	89a6                	mv	s3,s1
    80004f3e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f40:	02000a13          	li	s4,32
    80004f44:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f48:	00391513          	slli	a0,s2,0x3
    80004f4c:	e3040593          	addi	a1,s0,-464
    80004f50:	e3843783          	ld	a5,-456(s0)
    80004f54:	953e                	add	a0,a0,a5
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	ffc080e7          	jalr	-4(ra) # 80001f52 <fetchaddr>
    80004f5e:	02054a63          	bltz	a0,80004f92 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f62:	e3043783          	ld	a5,-464(s0)
    80004f66:	c3b9                	beqz	a5,80004fac <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f68:	ffffb097          	auipc	ra,0xffffb
    80004f6c:	1b0080e7          	jalr	432(ra) # 80000118 <kalloc>
    80004f70:	85aa                	mv	a1,a0
    80004f72:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f76:	cd11                	beqz	a0,80004f92 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f78:	6605                	lui	a2,0x1
    80004f7a:	e3043503          	ld	a0,-464(s0)
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	026080e7          	jalr	38(ra) # 80001fa4 <fetchstr>
    80004f86:	00054663          	bltz	a0,80004f92 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f8a:	0905                	addi	s2,s2,1
    80004f8c:	09a1                	addi	s3,s3,8
    80004f8e:	fb491be3          	bne	s2,s4,80004f44 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f92:	10048913          	addi	s2,s1,256
    80004f96:	6088                	ld	a0,0(s1)
    80004f98:	c531                	beqz	a0,80004fe4 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f9a:	ffffb097          	auipc	ra,0xffffb
    80004f9e:	082080e7          	jalr	130(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa2:	04a1                	addi	s1,s1,8
    80004fa4:	ff2499e3          	bne	s1,s2,80004f96 <sys_exec+0xaa>
  return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	a835                	j	80004fe6 <sys_exec+0xfa>
      argv[i] = 0;
    80004fac:	0a8e                	slli	s5,s5,0x3
    80004fae:	fc040793          	addi	a5,s0,-64
    80004fb2:	9abe                	add	s5,s5,a5
    80004fb4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fb8:	e4040593          	addi	a1,s0,-448
    80004fbc:	f4040513          	addi	a0,s0,-192
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	190080e7          	jalr	400(ra) # 80004150 <exec>
    80004fc8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fca:	10048993          	addi	s3,s1,256
    80004fce:	6088                	ld	a0,0(s1)
    80004fd0:	c901                	beqz	a0,80004fe0 <sys_exec+0xf4>
    kfree(argv[i]);
    80004fd2:	ffffb097          	auipc	ra,0xffffb
    80004fd6:	04a080e7          	jalr	74(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fda:	04a1                	addi	s1,s1,8
    80004fdc:	ff3499e3          	bne	s1,s3,80004fce <sys_exec+0xe2>
  return ret;
    80004fe0:	854a                	mv	a0,s2
    80004fe2:	a011                	j	80004fe6 <sys_exec+0xfa>
  return -1;
    80004fe4:	557d                	li	a0,-1
}
    80004fe6:	60be                	ld	ra,456(sp)
    80004fe8:	641e                	ld	s0,448(sp)
    80004fea:	74fa                	ld	s1,440(sp)
    80004fec:	795a                	ld	s2,432(sp)
    80004fee:	79ba                	ld	s3,424(sp)
    80004ff0:	7a1a                	ld	s4,416(sp)
    80004ff2:	6afa                	ld	s5,408(sp)
    80004ff4:	6179                	addi	sp,sp,464
    80004ff6:	8082                	ret

0000000080004ff8 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ff8:	7139                	addi	sp,sp,-64
    80004ffa:	fc06                	sd	ra,56(sp)
    80004ffc:	f822                	sd	s0,48(sp)
    80004ffe:	f426                	sd	s1,40(sp)
    80005000:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	ea2080e7          	jalr	-350(ra) # 80000ea4 <myproc>
    8000500a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000500c:	fd840593          	addi	a1,s0,-40
    80005010:	4501                	li	a0,0
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	ffe080e7          	jalr	-2(ra) # 80002010 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000501a:	fc840593          	addi	a1,s0,-56
    8000501e:	fd040513          	addi	a0,s0,-48
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	dd6080e7          	jalr	-554(ra) # 80003df8 <pipealloc>
    return -1;
    8000502a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000502c:	0c054463          	bltz	a0,800050f4 <sys_pipe+0xfc>
  fd0 = -1;
    80005030:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005034:	fd043503          	ld	a0,-48(s0)
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	518080e7          	jalr	1304(ra) # 80004550 <fdalloc>
    80005040:	fca42223          	sw	a0,-60(s0)
    80005044:	08054b63          	bltz	a0,800050da <sys_pipe+0xe2>
    80005048:	fc843503          	ld	a0,-56(s0)
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	504080e7          	jalr	1284(ra) # 80004550 <fdalloc>
    80005054:	fca42023          	sw	a0,-64(s0)
    80005058:	06054863          	bltz	a0,800050c8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000505c:	4691                	li	a3,4
    8000505e:	fc440613          	addi	a2,s0,-60
    80005062:	fd843583          	ld	a1,-40(s0)
    80005066:	68a8                	ld	a0,80(s1)
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	afa080e7          	jalr	-1286(ra) # 80000b62 <copyout>
    80005070:	02054063          	bltz	a0,80005090 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005074:	4691                	li	a3,4
    80005076:	fc040613          	addi	a2,s0,-64
    8000507a:	fd843583          	ld	a1,-40(s0)
    8000507e:	0591                	addi	a1,a1,4
    80005080:	68a8                	ld	a0,80(s1)
    80005082:	ffffc097          	auipc	ra,0xffffc
    80005086:	ae0080e7          	jalr	-1312(ra) # 80000b62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000508a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000508c:	06055463          	bgez	a0,800050f4 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005090:	fc442783          	lw	a5,-60(s0)
    80005094:	07e9                	addi	a5,a5,26
    80005096:	078e                	slli	a5,a5,0x3
    80005098:	97a6                	add	a5,a5,s1
    8000509a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000509e:	fc042503          	lw	a0,-64(s0)
    800050a2:	0569                	addi	a0,a0,26
    800050a4:	050e                	slli	a0,a0,0x3
    800050a6:	94aa                	add	s1,s1,a0
    800050a8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050ac:	fd043503          	ld	a0,-48(s0)
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	a18080e7          	jalr	-1512(ra) # 80003ac8 <fileclose>
    fileclose(wf);
    800050b8:	fc843503          	ld	a0,-56(s0)
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	a0c080e7          	jalr	-1524(ra) # 80003ac8 <fileclose>
    return -1;
    800050c4:	57fd                	li	a5,-1
    800050c6:	a03d                	j	800050f4 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800050c8:	fc442783          	lw	a5,-60(s0)
    800050cc:	0007c763          	bltz	a5,800050da <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800050d0:	07e9                	addi	a5,a5,26
    800050d2:	078e                	slli	a5,a5,0x3
    800050d4:	94be                	add	s1,s1,a5
    800050d6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050da:	fd043503          	ld	a0,-48(s0)
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	9ea080e7          	jalr	-1558(ra) # 80003ac8 <fileclose>
    fileclose(wf);
    800050e6:	fc843503          	ld	a0,-56(s0)
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	9de080e7          	jalr	-1570(ra) # 80003ac8 <fileclose>
    return -1;
    800050f2:	57fd                	li	a5,-1
}
    800050f4:	853e                	mv	a0,a5
    800050f6:	70e2                	ld	ra,56(sp)
    800050f8:	7442                	ld	s0,48(sp)
    800050fa:	74a2                	ld	s1,40(sp)
    800050fc:	6121                	addi	sp,sp,64
    800050fe:	8082                	ret

0000000080005100 <kernelvec>:
    80005100:	7111                	addi	sp,sp,-256
    80005102:	e006                	sd	ra,0(sp)
    80005104:	e40a                	sd	sp,8(sp)
    80005106:	e80e                	sd	gp,16(sp)
    80005108:	ec12                	sd	tp,24(sp)
    8000510a:	f016                	sd	t0,32(sp)
    8000510c:	f41a                	sd	t1,40(sp)
    8000510e:	f81e                	sd	t2,48(sp)
    80005110:	fc22                	sd	s0,56(sp)
    80005112:	e0a6                	sd	s1,64(sp)
    80005114:	e4aa                	sd	a0,72(sp)
    80005116:	e8ae                	sd	a1,80(sp)
    80005118:	ecb2                	sd	a2,88(sp)
    8000511a:	f0b6                	sd	a3,96(sp)
    8000511c:	f4ba                	sd	a4,104(sp)
    8000511e:	f8be                	sd	a5,112(sp)
    80005120:	fcc2                	sd	a6,120(sp)
    80005122:	e146                	sd	a7,128(sp)
    80005124:	e54a                	sd	s2,136(sp)
    80005126:	e94e                	sd	s3,144(sp)
    80005128:	ed52                	sd	s4,152(sp)
    8000512a:	f156                	sd	s5,160(sp)
    8000512c:	f55a                	sd	s6,168(sp)
    8000512e:	f95e                	sd	s7,176(sp)
    80005130:	fd62                	sd	s8,184(sp)
    80005132:	e1e6                	sd	s9,192(sp)
    80005134:	e5ea                	sd	s10,200(sp)
    80005136:	e9ee                	sd	s11,208(sp)
    80005138:	edf2                	sd	t3,216(sp)
    8000513a:	f1f6                	sd	t4,224(sp)
    8000513c:	f5fa                	sd	t5,232(sp)
    8000513e:	f9fe                	sd	t6,240(sp)
    80005140:	cdffc0ef          	jal	ra,80001e1e <kerneltrap>
    80005144:	6082                	ld	ra,0(sp)
    80005146:	6122                	ld	sp,8(sp)
    80005148:	61c2                	ld	gp,16(sp)
    8000514a:	7282                	ld	t0,32(sp)
    8000514c:	7322                	ld	t1,40(sp)
    8000514e:	73c2                	ld	t2,48(sp)
    80005150:	7462                	ld	s0,56(sp)
    80005152:	6486                	ld	s1,64(sp)
    80005154:	6526                	ld	a0,72(sp)
    80005156:	65c6                	ld	a1,80(sp)
    80005158:	6666                	ld	a2,88(sp)
    8000515a:	7686                	ld	a3,96(sp)
    8000515c:	7726                	ld	a4,104(sp)
    8000515e:	77c6                	ld	a5,112(sp)
    80005160:	7866                	ld	a6,120(sp)
    80005162:	688a                	ld	a7,128(sp)
    80005164:	692a                	ld	s2,136(sp)
    80005166:	69ca                	ld	s3,144(sp)
    80005168:	6a6a                	ld	s4,152(sp)
    8000516a:	7a8a                	ld	s5,160(sp)
    8000516c:	7b2a                	ld	s6,168(sp)
    8000516e:	7bca                	ld	s7,176(sp)
    80005170:	7c6a                	ld	s8,184(sp)
    80005172:	6c8e                	ld	s9,192(sp)
    80005174:	6d2e                	ld	s10,200(sp)
    80005176:	6dce                	ld	s11,208(sp)
    80005178:	6e6e                	ld	t3,216(sp)
    8000517a:	7e8e                	ld	t4,224(sp)
    8000517c:	7f2e                	ld	t5,232(sp)
    8000517e:	7fce                	ld	t6,240(sp)
    80005180:	6111                	addi	sp,sp,256
    80005182:	10200073          	sret
    80005186:	00000013          	nop
    8000518a:	00000013          	nop
    8000518e:	0001                	nop

0000000080005190 <timervec>:
    80005190:	34051573          	csrrw	a0,mscratch,a0
    80005194:	e10c                	sd	a1,0(a0)
    80005196:	e510                	sd	a2,8(a0)
    80005198:	e914                	sd	a3,16(a0)
    8000519a:	6d0c                	ld	a1,24(a0)
    8000519c:	7110                	ld	a2,32(a0)
    8000519e:	6194                	ld	a3,0(a1)
    800051a0:	96b2                	add	a3,a3,a2
    800051a2:	e194                	sd	a3,0(a1)
    800051a4:	4589                	li	a1,2
    800051a6:	14459073          	csrw	sip,a1
    800051aa:	6914                	ld	a3,16(a0)
    800051ac:	6510                	ld	a2,8(a0)
    800051ae:	610c                	ld	a1,0(a0)
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	30200073          	mret
	...

00000000800051ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ba:	1141                	addi	sp,sp,-16
    800051bc:	e422                	sd	s0,8(sp)
    800051be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051c0:	0c0007b7          	lui	a5,0xc000
    800051c4:	4705                	li	a4,1
    800051c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051c8:	c3d8                	sw	a4,4(a5)
}
    800051ca:	6422                	ld	s0,8(sp)
    800051cc:	0141                	addi	sp,sp,16
    800051ce:	8082                	ret

00000000800051d0 <plicinithart>:

void
plicinithart(void)
{
    800051d0:	1141                	addi	sp,sp,-16
    800051d2:	e406                	sd	ra,8(sp)
    800051d4:	e022                	sd	s0,0(sp)
    800051d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	ca0080e7          	jalr	-864(ra) # 80000e78 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051e0:	0085171b          	slliw	a4,a0,0x8
    800051e4:	0c0027b7          	lui	a5,0xc002
    800051e8:	97ba                	add	a5,a5,a4
    800051ea:	40200713          	li	a4,1026
    800051ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051f2:	00d5151b          	slliw	a0,a0,0xd
    800051f6:	0c2017b7          	lui	a5,0xc201
    800051fa:	953e                	add	a0,a0,a5
    800051fc:	00052023          	sw	zero,0(a0)
}
    80005200:	60a2                	ld	ra,8(sp)
    80005202:	6402                	ld	s0,0(sp)
    80005204:	0141                	addi	sp,sp,16
    80005206:	8082                	ret

0000000080005208 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005208:	1141                	addi	sp,sp,-16
    8000520a:	e406                	sd	ra,8(sp)
    8000520c:	e022                	sd	s0,0(sp)
    8000520e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	c68080e7          	jalr	-920(ra) # 80000e78 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005218:	00d5179b          	slliw	a5,a0,0xd
    8000521c:	0c201537          	lui	a0,0xc201
    80005220:	953e                	add	a0,a0,a5
  return irq;
}
    80005222:	4148                	lw	a0,4(a0)
    80005224:	60a2                	ld	ra,8(sp)
    80005226:	6402                	ld	s0,0(sp)
    80005228:	0141                	addi	sp,sp,16
    8000522a:	8082                	ret

000000008000522c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000522c:	1101                	addi	sp,sp,-32
    8000522e:	ec06                	sd	ra,24(sp)
    80005230:	e822                	sd	s0,16(sp)
    80005232:	e426                	sd	s1,8(sp)
    80005234:	1000                	addi	s0,sp,32
    80005236:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	c40080e7          	jalr	-960(ra) # 80000e78 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005240:	00d5151b          	slliw	a0,a0,0xd
    80005244:	0c2017b7          	lui	a5,0xc201
    80005248:	97aa                	add	a5,a5,a0
    8000524a:	c3c4                	sw	s1,4(a5)
}
    8000524c:	60e2                	ld	ra,24(sp)
    8000524e:	6442                	ld	s0,16(sp)
    80005250:	64a2                	ld	s1,8(sp)
    80005252:	6105                	addi	sp,sp,32
    80005254:	8082                	ret

0000000080005256 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005256:	1141                	addi	sp,sp,-16
    80005258:	e406                	sd	ra,8(sp)
    8000525a:	e022                	sd	s0,0(sp)
    8000525c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000525e:	479d                	li	a5,7
    80005260:	04a7cc63          	blt	a5,a0,800052b8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005264:	00015797          	auipc	a5,0x15
    80005268:	abc78793          	addi	a5,a5,-1348 # 80019d20 <disk>
    8000526c:	97aa                	add	a5,a5,a0
    8000526e:	0187c783          	lbu	a5,24(a5)
    80005272:	ebb9                	bnez	a5,800052c8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005274:	00451613          	slli	a2,a0,0x4
    80005278:	00015797          	auipc	a5,0x15
    8000527c:	aa878793          	addi	a5,a5,-1368 # 80019d20 <disk>
    80005280:	6394                	ld	a3,0(a5)
    80005282:	96b2                	add	a3,a3,a2
    80005284:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005288:	6398                	ld	a4,0(a5)
    8000528a:	9732                	add	a4,a4,a2
    8000528c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005290:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005294:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005298:	953e                	add	a0,a0,a5
    8000529a:	4785                	li	a5,1
    8000529c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052a0:	00015517          	auipc	a0,0x15
    800052a4:	a9850513          	addi	a0,a0,-1384 # 80019d38 <disk+0x18>
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	30c080e7          	jalr	780(ra) # 800015b4 <wakeup>
}
    800052b0:	60a2                	ld	ra,8(sp)
    800052b2:	6402                	ld	s0,0(sp)
    800052b4:	0141                	addi	sp,sp,16
    800052b6:	8082                	ret
    panic("free_desc 1");
    800052b8:	00003517          	auipc	a0,0x3
    800052bc:	43050513          	addi	a0,a0,1072 # 800086e8 <syscalls+0x300>
    800052c0:	00001097          	auipc	ra,0x1
    800052c4:	a72080e7          	jalr	-1422(ra) # 80005d32 <panic>
    panic("free_desc 2");
    800052c8:	00003517          	auipc	a0,0x3
    800052cc:	43050513          	addi	a0,a0,1072 # 800086f8 <syscalls+0x310>
    800052d0:	00001097          	auipc	ra,0x1
    800052d4:	a62080e7          	jalr	-1438(ra) # 80005d32 <panic>

00000000800052d8 <virtio_disk_init>:
{
    800052d8:	1101                	addi	sp,sp,-32
    800052da:	ec06                	sd	ra,24(sp)
    800052dc:	e822                	sd	s0,16(sp)
    800052de:	e426                	sd	s1,8(sp)
    800052e0:	e04a                	sd	s2,0(sp)
    800052e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052e4:	00003597          	auipc	a1,0x3
    800052e8:	42458593          	addi	a1,a1,1060 # 80008708 <syscalls+0x320>
    800052ec:	00015517          	auipc	a0,0x15
    800052f0:	b5c50513          	addi	a0,a0,-1188 # 80019e48 <disk+0x128>
    800052f4:	00001097          	auipc	ra,0x1
    800052f8:	ef8080e7          	jalr	-264(ra) # 800061ec <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052fc:	100017b7          	lui	a5,0x10001
    80005300:	4398                	lw	a4,0(a5)
    80005302:	2701                	sext.w	a4,a4
    80005304:	747277b7          	lui	a5,0x74727
    80005308:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000530c:	14f71e63          	bne	a4,a5,80005468 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005310:	100017b7          	lui	a5,0x10001
    80005314:	43dc                	lw	a5,4(a5)
    80005316:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005318:	4709                	li	a4,2
    8000531a:	14e79763          	bne	a5,a4,80005468 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000531e:	100017b7          	lui	a5,0x10001
    80005322:	479c                	lw	a5,8(a5)
    80005324:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005326:	14e79163          	bne	a5,a4,80005468 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000532a:	100017b7          	lui	a5,0x10001
    8000532e:	47d8                	lw	a4,12(a5)
    80005330:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005332:	554d47b7          	lui	a5,0x554d4
    80005336:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000533a:	12f71763          	bne	a4,a5,80005468 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533e:	100017b7          	lui	a5,0x10001
    80005342:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005346:	4705                	li	a4,1
    80005348:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000534a:	470d                	li	a4,3
    8000534c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000534e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005350:	c7ffe737          	lui	a4,0xc7ffe
    80005354:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc6bf>
    80005358:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000535a:	2701                	sext.w	a4,a4
    8000535c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000535e:	472d                	li	a4,11
    80005360:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005362:	0707a903          	lw	s2,112(a5)
    80005366:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005368:	00897793          	andi	a5,s2,8
    8000536c:	10078663          	beqz	a5,80005478 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005370:	100017b7          	lui	a5,0x10001
    80005374:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005378:	43fc                	lw	a5,68(a5)
    8000537a:	2781                	sext.w	a5,a5
    8000537c:	10079663          	bnez	a5,80005488 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005380:	100017b7          	lui	a5,0x10001
    80005384:	5bdc                	lw	a5,52(a5)
    80005386:	2781                	sext.w	a5,a5
  if(max == 0)
    80005388:	10078863          	beqz	a5,80005498 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000538c:	471d                	li	a4,7
    8000538e:	10f77d63          	bgeu	a4,a5,800054a8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005392:	ffffb097          	auipc	ra,0xffffb
    80005396:	d86080e7          	jalr	-634(ra) # 80000118 <kalloc>
    8000539a:	00015497          	auipc	s1,0x15
    8000539e:	98648493          	addi	s1,s1,-1658 # 80019d20 <disk>
    800053a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053a4:	ffffb097          	auipc	ra,0xffffb
    800053a8:	d74080e7          	jalr	-652(ra) # 80000118 <kalloc>
    800053ac:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053ae:	ffffb097          	auipc	ra,0xffffb
    800053b2:	d6a080e7          	jalr	-662(ra) # 80000118 <kalloc>
    800053b6:	87aa                	mv	a5,a0
    800053b8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053ba:	6088                	ld	a0,0(s1)
    800053bc:	cd75                	beqz	a0,800054b8 <virtio_disk_init+0x1e0>
    800053be:	00015717          	auipc	a4,0x15
    800053c2:	96a73703          	ld	a4,-1686(a4) # 80019d28 <disk+0x8>
    800053c6:	cb6d                	beqz	a4,800054b8 <virtio_disk_init+0x1e0>
    800053c8:	cbe5                	beqz	a5,800054b8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800053ca:	6605                	lui	a2,0x1
    800053cc:	4581                	li	a1,0
    800053ce:	ffffb097          	auipc	ra,0xffffb
    800053d2:	df6080e7          	jalr	-522(ra) # 800001c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800053d6:	00015497          	auipc	s1,0x15
    800053da:	94a48493          	addi	s1,s1,-1718 # 80019d20 <disk>
    800053de:	6605                	lui	a2,0x1
    800053e0:	4581                	li	a1,0
    800053e2:	6488                	ld	a0,8(s1)
    800053e4:	ffffb097          	auipc	ra,0xffffb
    800053e8:	de0080e7          	jalr	-544(ra) # 800001c4 <memset>
  memset(disk.used, 0, PGSIZE);
    800053ec:	6605                	lui	a2,0x1
    800053ee:	4581                	li	a1,0
    800053f0:	6888                	ld	a0,16(s1)
    800053f2:	ffffb097          	auipc	ra,0xffffb
    800053f6:	dd2080e7          	jalr	-558(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053fa:	100017b7          	lui	a5,0x10001
    800053fe:	4721                	li	a4,8
    80005400:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005402:	4098                	lw	a4,0(s1)
    80005404:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005408:	40d8                	lw	a4,4(s1)
    8000540a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000540e:	6498                	ld	a4,8(s1)
    80005410:	0007069b          	sext.w	a3,a4
    80005414:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005418:	9701                	srai	a4,a4,0x20
    8000541a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000541e:	6898                	ld	a4,16(s1)
    80005420:	0007069b          	sext.w	a3,a4
    80005424:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005428:	9701                	srai	a4,a4,0x20
    8000542a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000542e:	4685                	li	a3,1
    80005430:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005432:	4705                	li	a4,1
    80005434:	00d48c23          	sb	a3,24(s1)
    80005438:	00e48ca3          	sb	a4,25(s1)
    8000543c:	00e48d23          	sb	a4,26(s1)
    80005440:	00e48da3          	sb	a4,27(s1)
    80005444:	00e48e23          	sb	a4,28(s1)
    80005448:	00e48ea3          	sb	a4,29(s1)
    8000544c:	00e48f23          	sb	a4,30(s1)
    80005450:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005454:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005458:	0727a823          	sw	s2,112(a5)
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	64a2                	ld	s1,8(sp)
    80005462:	6902                	ld	s2,0(sp)
    80005464:	6105                	addi	sp,sp,32
    80005466:	8082                	ret
    panic("could not find virtio disk");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	2b050513          	addi	a0,a0,688 # 80008718 <syscalls+0x330>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	8c2080e7          	jalr	-1854(ra) # 80005d32 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	2c050513          	addi	a0,a0,704 # 80008738 <syscalls+0x350>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	8b2080e7          	jalr	-1870(ra) # 80005d32 <panic>
    panic("virtio disk should not be ready");
    80005488:	00003517          	auipc	a0,0x3
    8000548c:	2d050513          	addi	a0,a0,720 # 80008758 <syscalls+0x370>
    80005490:	00001097          	auipc	ra,0x1
    80005494:	8a2080e7          	jalr	-1886(ra) # 80005d32 <panic>
    panic("virtio disk has no queue 0");
    80005498:	00003517          	auipc	a0,0x3
    8000549c:	2e050513          	addi	a0,a0,736 # 80008778 <syscalls+0x390>
    800054a0:	00001097          	auipc	ra,0x1
    800054a4:	892080e7          	jalr	-1902(ra) # 80005d32 <panic>
    panic("virtio disk max queue too short");
    800054a8:	00003517          	auipc	a0,0x3
    800054ac:	2f050513          	addi	a0,a0,752 # 80008798 <syscalls+0x3b0>
    800054b0:	00001097          	auipc	ra,0x1
    800054b4:	882080e7          	jalr	-1918(ra) # 80005d32 <panic>
    panic("virtio disk kalloc");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	30050513          	addi	a0,a0,768 # 800087b8 <syscalls+0x3d0>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	872080e7          	jalr	-1934(ra) # 80005d32 <panic>

00000000800054c8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054c8:	7159                	addi	sp,sp,-112
    800054ca:	f486                	sd	ra,104(sp)
    800054cc:	f0a2                	sd	s0,96(sp)
    800054ce:	eca6                	sd	s1,88(sp)
    800054d0:	e8ca                	sd	s2,80(sp)
    800054d2:	e4ce                	sd	s3,72(sp)
    800054d4:	e0d2                	sd	s4,64(sp)
    800054d6:	fc56                	sd	s5,56(sp)
    800054d8:	f85a                	sd	s6,48(sp)
    800054da:	f45e                	sd	s7,40(sp)
    800054dc:	f062                	sd	s8,32(sp)
    800054de:	ec66                	sd	s9,24(sp)
    800054e0:	e86a                	sd	s10,16(sp)
    800054e2:	1880                	addi	s0,sp,112
    800054e4:	892a                	mv	s2,a0
    800054e6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054e8:	00c52c83          	lw	s9,12(a0)
    800054ec:	001c9c9b          	slliw	s9,s9,0x1
    800054f0:	1c82                	slli	s9,s9,0x20
    800054f2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054f6:	00015517          	auipc	a0,0x15
    800054fa:	95250513          	addi	a0,a0,-1710 # 80019e48 <disk+0x128>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	d7e080e7          	jalr	-642(ra) # 8000627c <acquire>
  for(int i = 0; i < 3; i++){
    80005506:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005508:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000550a:	00015b17          	auipc	s6,0x15
    8000550e:	816b0b13          	addi	s6,s6,-2026 # 80019d20 <disk>
  for(int i = 0; i < 3; i++){
    80005512:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005514:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005516:	00015c17          	auipc	s8,0x15
    8000551a:	932c0c13          	addi	s8,s8,-1742 # 80019e48 <disk+0x128>
    8000551e:	a8b5                	j	8000559a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005520:	00fb06b3          	add	a3,s6,a5
    80005524:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005528:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000552a:	0207c563          	bltz	a5,80005554 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000552e:	2485                	addiw	s1,s1,1
    80005530:	0711                	addi	a4,a4,4
    80005532:	1f548a63          	beq	s1,s5,80005726 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005536:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005538:	00014697          	auipc	a3,0x14
    8000553c:	7e868693          	addi	a3,a3,2024 # 80019d20 <disk>
    80005540:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005542:	0186c583          	lbu	a1,24(a3)
    80005546:	fde9                	bnez	a1,80005520 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005548:	2785                	addiw	a5,a5,1
    8000554a:	0685                	addi	a3,a3,1
    8000554c:	ff779be3          	bne	a5,s7,80005542 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005550:	57fd                	li	a5,-1
    80005552:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005554:	02905a63          	blez	s1,80005588 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005558:	f9042503          	lw	a0,-112(s0)
    8000555c:	00000097          	auipc	ra,0x0
    80005560:	cfa080e7          	jalr	-774(ra) # 80005256 <free_desc>
      for(int j = 0; j < i; j++)
    80005564:	4785                	li	a5,1
    80005566:	0297d163          	bge	a5,s1,80005588 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000556a:	f9442503          	lw	a0,-108(s0)
    8000556e:	00000097          	auipc	ra,0x0
    80005572:	ce8080e7          	jalr	-792(ra) # 80005256 <free_desc>
      for(int j = 0; j < i; j++)
    80005576:	4789                	li	a5,2
    80005578:	0097d863          	bge	a5,s1,80005588 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000557c:	f9842503          	lw	a0,-104(s0)
    80005580:	00000097          	auipc	ra,0x0
    80005584:	cd6080e7          	jalr	-810(ra) # 80005256 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005588:	85e2                	mv	a1,s8
    8000558a:	00014517          	auipc	a0,0x14
    8000558e:	7ae50513          	addi	a0,a0,1966 # 80019d38 <disk+0x18>
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	fbe080e7          	jalr	-66(ra) # 80001550 <sleep>
  for(int i = 0; i < 3; i++){
    8000559a:	f9040713          	addi	a4,s0,-112
    8000559e:	84ce                	mv	s1,s3
    800055a0:	bf59                	j	80005536 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055a2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800055a6:	00479693          	slli	a3,a5,0x4
    800055aa:	00014797          	auipc	a5,0x14
    800055ae:	77678793          	addi	a5,a5,1910 # 80019d20 <disk>
    800055b2:	97b6                	add	a5,a5,a3
    800055b4:	4685                	li	a3,1
    800055b6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055b8:	00014597          	auipc	a1,0x14
    800055bc:	76858593          	addi	a1,a1,1896 # 80019d20 <disk>
    800055c0:	00a60793          	addi	a5,a2,10
    800055c4:	0792                	slli	a5,a5,0x4
    800055c6:	97ae                	add	a5,a5,a1
    800055c8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800055cc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d0:	f6070693          	addi	a3,a4,-160
    800055d4:	619c                	ld	a5,0(a1)
    800055d6:	97b6                	add	a5,a5,a3
    800055d8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055da:	6188                	ld	a0,0(a1)
    800055dc:	96aa                	add	a3,a3,a0
    800055de:	47c1                	li	a5,16
    800055e0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055e2:	4785                	li	a5,1
    800055e4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800055e8:	f9442783          	lw	a5,-108(s0)
    800055ec:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055f0:	0792                	slli	a5,a5,0x4
    800055f2:	953e                	add	a0,a0,a5
    800055f4:	05890693          	addi	a3,s2,88
    800055f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800055fa:	6188                	ld	a0,0(a1)
    800055fc:	97aa                	add	a5,a5,a0
    800055fe:	40000693          	li	a3,1024
    80005602:	c794                	sw	a3,8(a5)
  if(write)
    80005604:	100d0d63          	beqz	s10,8000571e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005608:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000560c:	00c7d683          	lhu	a3,12(a5)
    80005610:	0016e693          	ori	a3,a3,1
    80005614:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005618:	f9842583          	lw	a1,-104(s0)
    8000561c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005620:	00014697          	auipc	a3,0x14
    80005624:	70068693          	addi	a3,a3,1792 # 80019d20 <disk>
    80005628:	00260793          	addi	a5,a2,2
    8000562c:	0792                	slli	a5,a5,0x4
    8000562e:	97b6                	add	a5,a5,a3
    80005630:	587d                	li	a6,-1
    80005632:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005636:	0592                	slli	a1,a1,0x4
    80005638:	952e                	add	a0,a0,a1
    8000563a:	f9070713          	addi	a4,a4,-112
    8000563e:	9736                	add	a4,a4,a3
    80005640:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005642:	6298                	ld	a4,0(a3)
    80005644:	972e                	add	a4,a4,a1
    80005646:	4585                	li	a1,1
    80005648:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000564a:	4509                	li	a0,2
    8000564c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005650:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005654:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005658:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000565c:	6698                	ld	a4,8(a3)
    8000565e:	00275783          	lhu	a5,2(a4)
    80005662:	8b9d                	andi	a5,a5,7
    80005664:	0786                	slli	a5,a5,0x1
    80005666:	97ba                	add	a5,a5,a4
    80005668:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000566c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005670:	6698                	ld	a4,8(a3)
    80005672:	00275783          	lhu	a5,2(a4)
    80005676:	2785                	addiw	a5,a5,1
    80005678:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000567c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005680:	100017b7          	lui	a5,0x10001
    80005684:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005688:	00492703          	lw	a4,4(s2)
    8000568c:	4785                	li	a5,1
    8000568e:	02f71163          	bne	a4,a5,800056b0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005692:	00014997          	auipc	s3,0x14
    80005696:	7b698993          	addi	s3,s3,1974 # 80019e48 <disk+0x128>
  while(b->disk == 1) {
    8000569a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000569c:	85ce                	mv	a1,s3
    8000569e:	854a                	mv	a0,s2
    800056a0:	ffffc097          	auipc	ra,0xffffc
    800056a4:	eb0080e7          	jalr	-336(ra) # 80001550 <sleep>
  while(b->disk == 1) {
    800056a8:	00492783          	lw	a5,4(s2)
    800056ac:	fe9788e3          	beq	a5,s1,8000569c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800056b0:	f9042903          	lw	s2,-112(s0)
    800056b4:	00290793          	addi	a5,s2,2
    800056b8:	00479713          	slli	a4,a5,0x4
    800056bc:	00014797          	auipc	a5,0x14
    800056c0:	66478793          	addi	a5,a5,1636 # 80019d20 <disk>
    800056c4:	97ba                	add	a5,a5,a4
    800056c6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056ca:	00014997          	auipc	s3,0x14
    800056ce:	65698993          	addi	s3,s3,1622 # 80019d20 <disk>
    800056d2:	00491713          	slli	a4,s2,0x4
    800056d6:	0009b783          	ld	a5,0(s3)
    800056da:	97ba                	add	a5,a5,a4
    800056dc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056e0:	854a                	mv	a0,s2
    800056e2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056e6:	00000097          	auipc	ra,0x0
    800056ea:	b70080e7          	jalr	-1168(ra) # 80005256 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ee:	8885                	andi	s1,s1,1
    800056f0:	f0ed                	bnez	s1,800056d2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056f2:	00014517          	auipc	a0,0x14
    800056f6:	75650513          	addi	a0,a0,1878 # 80019e48 <disk+0x128>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	c36080e7          	jalr	-970(ra) # 80006330 <release>
}
    80005702:	70a6                	ld	ra,104(sp)
    80005704:	7406                	ld	s0,96(sp)
    80005706:	64e6                	ld	s1,88(sp)
    80005708:	6946                	ld	s2,80(sp)
    8000570a:	69a6                	ld	s3,72(sp)
    8000570c:	6a06                	ld	s4,64(sp)
    8000570e:	7ae2                	ld	s5,56(sp)
    80005710:	7b42                	ld	s6,48(sp)
    80005712:	7ba2                	ld	s7,40(sp)
    80005714:	7c02                	ld	s8,32(sp)
    80005716:	6ce2                	ld	s9,24(sp)
    80005718:	6d42                	ld	s10,16(sp)
    8000571a:	6165                	addi	sp,sp,112
    8000571c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000571e:	4689                	li	a3,2
    80005720:	00d79623          	sh	a3,12(a5)
    80005724:	b5e5                	j	8000560c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005726:	f9042603          	lw	a2,-112(s0)
    8000572a:	00a60713          	addi	a4,a2,10
    8000572e:	0712                	slli	a4,a4,0x4
    80005730:	00014517          	auipc	a0,0x14
    80005734:	5f850513          	addi	a0,a0,1528 # 80019d28 <disk+0x8>
    80005738:	953a                	add	a0,a0,a4
  if(write)
    8000573a:	e60d14e3          	bnez	s10,800055a2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000573e:	00a60793          	addi	a5,a2,10
    80005742:	00479693          	slli	a3,a5,0x4
    80005746:	00014797          	auipc	a5,0x14
    8000574a:	5da78793          	addi	a5,a5,1498 # 80019d20 <disk>
    8000574e:	97b6                	add	a5,a5,a3
    80005750:	0007a423          	sw	zero,8(a5)
    80005754:	b595                	j	800055b8 <virtio_disk_rw+0xf0>

0000000080005756 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005756:	1101                	addi	sp,sp,-32
    80005758:	ec06                	sd	ra,24(sp)
    8000575a:	e822                	sd	s0,16(sp)
    8000575c:	e426                	sd	s1,8(sp)
    8000575e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005760:	00014497          	auipc	s1,0x14
    80005764:	5c048493          	addi	s1,s1,1472 # 80019d20 <disk>
    80005768:	00014517          	auipc	a0,0x14
    8000576c:	6e050513          	addi	a0,a0,1760 # 80019e48 <disk+0x128>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	b0c080e7          	jalr	-1268(ra) # 8000627c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005778:	10001737          	lui	a4,0x10001
    8000577c:	533c                	lw	a5,96(a4)
    8000577e:	8b8d                	andi	a5,a5,3
    80005780:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005782:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005786:	689c                	ld	a5,16(s1)
    80005788:	0204d703          	lhu	a4,32(s1)
    8000578c:	0027d783          	lhu	a5,2(a5)
    80005790:	04f70863          	beq	a4,a5,800057e0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005794:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005798:	6898                	ld	a4,16(s1)
    8000579a:	0204d783          	lhu	a5,32(s1)
    8000579e:	8b9d                	andi	a5,a5,7
    800057a0:	078e                	slli	a5,a5,0x3
    800057a2:	97ba                	add	a5,a5,a4
    800057a4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057a6:	00278713          	addi	a4,a5,2
    800057aa:	0712                	slli	a4,a4,0x4
    800057ac:	9726                	add	a4,a4,s1
    800057ae:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057b2:	e721                	bnez	a4,800057fa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057b4:	0789                	addi	a5,a5,2
    800057b6:	0792                	slli	a5,a5,0x4
    800057b8:	97a6                	add	a5,a5,s1
    800057ba:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057bc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057c0:	ffffc097          	auipc	ra,0xffffc
    800057c4:	df4080e7          	jalr	-524(ra) # 800015b4 <wakeup>

    disk.used_idx += 1;
    800057c8:	0204d783          	lhu	a5,32(s1)
    800057cc:	2785                	addiw	a5,a5,1
    800057ce:	17c2                	slli	a5,a5,0x30
    800057d0:	93c1                	srli	a5,a5,0x30
    800057d2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057d6:	6898                	ld	a4,16(s1)
    800057d8:	00275703          	lhu	a4,2(a4)
    800057dc:	faf71ce3          	bne	a4,a5,80005794 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057e0:	00014517          	auipc	a0,0x14
    800057e4:	66850513          	addi	a0,a0,1640 # 80019e48 <disk+0x128>
    800057e8:	00001097          	auipc	ra,0x1
    800057ec:	b48080e7          	jalr	-1208(ra) # 80006330 <release>
}
    800057f0:	60e2                	ld	ra,24(sp)
    800057f2:	6442                	ld	s0,16(sp)
    800057f4:	64a2                	ld	s1,8(sp)
    800057f6:	6105                	addi	sp,sp,32
    800057f8:	8082                	ret
      panic("virtio_disk_intr status");
    800057fa:	00003517          	auipc	a0,0x3
    800057fe:	fd650513          	addi	a0,a0,-42 # 800087d0 <syscalls+0x3e8>
    80005802:	00000097          	auipc	ra,0x0
    80005806:	530080e7          	jalr	1328(ra) # 80005d32 <panic>

000000008000580a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000580a:	1141                	addi	sp,sp,-16
    8000580c:	e422                	sd	s0,8(sp)
    8000580e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005810:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005814:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005818:	0037979b          	slliw	a5,a5,0x3
    8000581c:	02004737          	lui	a4,0x2004
    80005820:	97ba                	add	a5,a5,a4
    80005822:	0200c737          	lui	a4,0x200c
    80005826:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000582a:	000f4637          	lui	a2,0xf4
    8000582e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005832:	95b2                	add	a1,a1,a2
    80005834:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005836:	00269713          	slli	a4,a3,0x2
    8000583a:	9736                	add	a4,a4,a3
    8000583c:	00371693          	slli	a3,a4,0x3
    80005840:	00014717          	auipc	a4,0x14
    80005844:	62070713          	addi	a4,a4,1568 # 80019e60 <timer_scratch>
    80005848:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000584a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000584c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000584e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005852:	00000797          	auipc	a5,0x0
    80005856:	93e78793          	addi	a5,a5,-1730 # 80005190 <timervec>
    8000585a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000585e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005862:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005866:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000586a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000586e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005872:	30479073          	csrw	mie,a5
}
    80005876:	6422                	ld	s0,8(sp)
    80005878:	0141                	addi	sp,sp,16
    8000587a:	8082                	ret

000000008000587c <start>:
{
    8000587c:	1141                	addi	sp,sp,-16
    8000587e:	e406                	sd	ra,8(sp)
    80005880:	e022                	sd	s0,0(sp)
    80005882:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005884:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005888:	7779                	lui	a4,0xffffe
    8000588a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc75f>
    8000588e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005890:	6705                	lui	a4,0x1
    80005892:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005896:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005898:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000589c:	ffffb797          	auipc	a5,0xffffb
    800058a0:	ad678793          	addi	a5,a5,-1322 # 80000372 <main>
    800058a4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058a8:	4781                	li	a5,0
    800058aa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ae:	67c1                	lui	a5,0x10
    800058b0:	17fd                	addi	a5,a5,-1
    800058b2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058b6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058ba:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058be:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058c2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058c6:	57fd                	li	a5,-1
    800058c8:	83a9                	srli	a5,a5,0xa
    800058ca:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058ce:	47bd                	li	a5,15
    800058d0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058d4:	00000097          	auipc	ra,0x0
    800058d8:	f36080e7          	jalr	-202(ra) # 8000580a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058dc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058e0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058e2:	823e                	mv	tp,a5
  asm volatile("mret");
    800058e4:	30200073          	mret
}
    800058e8:	60a2                	ld	ra,8(sp)
    800058ea:	6402                	ld	s0,0(sp)
    800058ec:	0141                	addi	sp,sp,16
    800058ee:	8082                	ret

00000000800058f0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058f0:	715d                	addi	sp,sp,-80
    800058f2:	e486                	sd	ra,72(sp)
    800058f4:	e0a2                	sd	s0,64(sp)
    800058f6:	fc26                	sd	s1,56(sp)
    800058f8:	f84a                	sd	s2,48(sp)
    800058fa:	f44e                	sd	s3,40(sp)
    800058fc:	f052                	sd	s4,32(sp)
    800058fe:	ec56                	sd	s5,24(sp)
    80005900:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005902:	04c05663          	blez	a2,8000594e <consolewrite+0x5e>
    80005906:	8a2a                	mv	s4,a0
    80005908:	84ae                	mv	s1,a1
    8000590a:	89b2                	mv	s3,a2
    8000590c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000590e:	5afd                	li	s5,-1
    80005910:	4685                	li	a3,1
    80005912:	8626                	mv	a2,s1
    80005914:	85d2                	mv	a1,s4
    80005916:	fbf40513          	addi	a0,s0,-65
    8000591a:	ffffc097          	auipc	ra,0xffffc
    8000591e:	094080e7          	jalr	148(ra) # 800019ae <either_copyin>
    80005922:	01550c63          	beq	a0,s5,8000593a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005926:	fbf44503          	lbu	a0,-65(s0)
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	794080e7          	jalr	1940(ra) # 800060be <uartputc>
  for(i = 0; i < n; i++){
    80005932:	2905                	addiw	s2,s2,1
    80005934:	0485                	addi	s1,s1,1
    80005936:	fd299de3          	bne	s3,s2,80005910 <consolewrite+0x20>
  }

  return i;
}
    8000593a:	854a                	mv	a0,s2
    8000593c:	60a6                	ld	ra,72(sp)
    8000593e:	6406                	ld	s0,64(sp)
    80005940:	74e2                	ld	s1,56(sp)
    80005942:	7942                	ld	s2,48(sp)
    80005944:	79a2                	ld	s3,40(sp)
    80005946:	7a02                	ld	s4,32(sp)
    80005948:	6ae2                	ld	s5,24(sp)
    8000594a:	6161                	addi	sp,sp,80
    8000594c:	8082                	ret
  for(i = 0; i < n; i++){
    8000594e:	4901                	li	s2,0
    80005950:	b7ed                	j	8000593a <consolewrite+0x4a>

0000000080005952 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005952:	7119                	addi	sp,sp,-128
    80005954:	fc86                	sd	ra,120(sp)
    80005956:	f8a2                	sd	s0,112(sp)
    80005958:	f4a6                	sd	s1,104(sp)
    8000595a:	f0ca                	sd	s2,96(sp)
    8000595c:	ecce                	sd	s3,88(sp)
    8000595e:	e8d2                	sd	s4,80(sp)
    80005960:	e4d6                	sd	s5,72(sp)
    80005962:	e0da                	sd	s6,64(sp)
    80005964:	fc5e                	sd	s7,56(sp)
    80005966:	f862                	sd	s8,48(sp)
    80005968:	f466                	sd	s9,40(sp)
    8000596a:	f06a                	sd	s10,32(sp)
    8000596c:	ec6e                	sd	s11,24(sp)
    8000596e:	0100                	addi	s0,sp,128
    80005970:	8b2a                	mv	s6,a0
    80005972:	8aae                	mv	s5,a1
    80005974:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005976:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000597a:	0001c517          	auipc	a0,0x1c
    8000597e:	62650513          	addi	a0,a0,1574 # 80021fa0 <cons>
    80005982:	00001097          	auipc	ra,0x1
    80005986:	8fa080e7          	jalr	-1798(ra) # 8000627c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000598a:	0001c497          	auipc	s1,0x1c
    8000598e:	61648493          	addi	s1,s1,1558 # 80021fa0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005992:	89a6                	mv	s3,s1
    80005994:	0001c917          	auipc	s2,0x1c
    80005998:	6a490913          	addi	s2,s2,1700 # 80022038 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000599c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000599e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059a0:	4da9                	li	s11,10
  while(n > 0){
    800059a2:	07405b63          	blez	s4,80005a18 <consoleread+0xc6>
    while(cons.r == cons.w){
    800059a6:	0984a783          	lw	a5,152(s1)
    800059aa:	09c4a703          	lw	a4,156(s1)
    800059ae:	02f71763          	bne	a4,a5,800059dc <consoleread+0x8a>
      if(killed(myproc())){
    800059b2:	ffffb097          	auipc	ra,0xffffb
    800059b6:	4f2080e7          	jalr	1266(ra) # 80000ea4 <myproc>
    800059ba:	ffffc097          	auipc	ra,0xffffc
    800059be:	e3e080e7          	jalr	-450(ra) # 800017f8 <killed>
    800059c2:	e535                	bnez	a0,80005a2e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800059c4:	85ce                	mv	a1,s3
    800059c6:	854a                	mv	a0,s2
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	b88080e7          	jalr	-1144(ra) # 80001550 <sleep>
    while(cons.r == cons.w){
    800059d0:	0984a783          	lw	a5,152(s1)
    800059d4:	09c4a703          	lw	a4,156(s1)
    800059d8:	fcf70de3          	beq	a4,a5,800059b2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059dc:	0017871b          	addiw	a4,a5,1
    800059e0:	08e4ac23          	sw	a4,152(s1)
    800059e4:	07f7f713          	andi	a4,a5,127
    800059e8:	9726                	add	a4,a4,s1
    800059ea:	01874703          	lbu	a4,24(a4)
    800059ee:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059f2:	079c0663          	beq	s8,s9,80005a5e <consoleread+0x10c>
    cbuf = c;
    800059f6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059fa:	4685                	li	a3,1
    800059fc:	f8f40613          	addi	a2,s0,-113
    80005a00:	85d6                	mv	a1,s5
    80005a02:	855a                	mv	a0,s6
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	f54080e7          	jalr	-172(ra) # 80001958 <either_copyout>
    80005a0c:	01a50663          	beq	a0,s10,80005a18 <consoleread+0xc6>
    dst++;
    80005a10:	0a85                	addi	s5,s5,1
    --n;
    80005a12:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a14:	f9bc17e3          	bne	s8,s11,800059a2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a18:	0001c517          	auipc	a0,0x1c
    80005a1c:	58850513          	addi	a0,a0,1416 # 80021fa0 <cons>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	910080e7          	jalr	-1776(ra) # 80006330 <release>

  return target - n;
    80005a28:	414b853b          	subw	a0,s7,s4
    80005a2c:	a811                	j	80005a40 <consoleread+0xee>
        release(&cons.lock);
    80005a2e:	0001c517          	auipc	a0,0x1c
    80005a32:	57250513          	addi	a0,a0,1394 # 80021fa0 <cons>
    80005a36:	00001097          	auipc	ra,0x1
    80005a3a:	8fa080e7          	jalr	-1798(ra) # 80006330 <release>
        return -1;
    80005a3e:	557d                	li	a0,-1
}
    80005a40:	70e6                	ld	ra,120(sp)
    80005a42:	7446                	ld	s0,112(sp)
    80005a44:	74a6                	ld	s1,104(sp)
    80005a46:	7906                	ld	s2,96(sp)
    80005a48:	69e6                	ld	s3,88(sp)
    80005a4a:	6a46                	ld	s4,80(sp)
    80005a4c:	6aa6                	ld	s5,72(sp)
    80005a4e:	6b06                	ld	s6,64(sp)
    80005a50:	7be2                	ld	s7,56(sp)
    80005a52:	7c42                	ld	s8,48(sp)
    80005a54:	7ca2                	ld	s9,40(sp)
    80005a56:	7d02                	ld	s10,32(sp)
    80005a58:	6de2                	ld	s11,24(sp)
    80005a5a:	6109                	addi	sp,sp,128
    80005a5c:	8082                	ret
      if(n < target){
    80005a5e:	000a071b          	sext.w	a4,s4
    80005a62:	fb777be3          	bgeu	a4,s7,80005a18 <consoleread+0xc6>
        cons.r--;
    80005a66:	0001c717          	auipc	a4,0x1c
    80005a6a:	5cf72923          	sw	a5,1490(a4) # 80022038 <cons+0x98>
    80005a6e:	b76d                	j	80005a18 <consoleread+0xc6>

0000000080005a70 <consputc>:
{
    80005a70:	1141                	addi	sp,sp,-16
    80005a72:	e406                	sd	ra,8(sp)
    80005a74:	e022                	sd	s0,0(sp)
    80005a76:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a78:	10000793          	li	a5,256
    80005a7c:	00f50a63          	beq	a0,a5,80005a90 <consputc+0x20>
    uartputc_sync(c);
    80005a80:	00000097          	auipc	ra,0x0
    80005a84:	564080e7          	jalr	1380(ra) # 80005fe4 <uartputc_sync>
}
    80005a88:	60a2                	ld	ra,8(sp)
    80005a8a:	6402                	ld	s0,0(sp)
    80005a8c:	0141                	addi	sp,sp,16
    80005a8e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a90:	4521                	li	a0,8
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	552080e7          	jalr	1362(ra) # 80005fe4 <uartputc_sync>
    80005a9a:	02000513          	li	a0,32
    80005a9e:	00000097          	auipc	ra,0x0
    80005aa2:	546080e7          	jalr	1350(ra) # 80005fe4 <uartputc_sync>
    80005aa6:	4521                	li	a0,8
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	53c080e7          	jalr	1340(ra) # 80005fe4 <uartputc_sync>
    80005ab0:	bfe1                	j	80005a88 <consputc+0x18>

0000000080005ab2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ab2:	1101                	addi	sp,sp,-32
    80005ab4:	ec06                	sd	ra,24(sp)
    80005ab6:	e822                	sd	s0,16(sp)
    80005ab8:	e426                	sd	s1,8(sp)
    80005aba:	e04a                	sd	s2,0(sp)
    80005abc:	1000                	addi	s0,sp,32
    80005abe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ac0:	0001c517          	auipc	a0,0x1c
    80005ac4:	4e050513          	addi	a0,a0,1248 # 80021fa0 <cons>
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	7b4080e7          	jalr	1972(ra) # 8000627c <acquire>

  switch(c){
    80005ad0:	47d5                	li	a5,21
    80005ad2:	0af48663          	beq	s1,a5,80005b7e <consoleintr+0xcc>
    80005ad6:	0297ca63          	blt	a5,s1,80005b0a <consoleintr+0x58>
    80005ada:	47a1                	li	a5,8
    80005adc:	0ef48763          	beq	s1,a5,80005bca <consoleintr+0x118>
    80005ae0:	47c1                	li	a5,16
    80005ae2:	10f49a63          	bne	s1,a5,80005bf6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ae6:	ffffc097          	auipc	ra,0xffffc
    80005aea:	f1e080e7          	jalr	-226(ra) # 80001a04 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005aee:	0001c517          	auipc	a0,0x1c
    80005af2:	4b250513          	addi	a0,a0,1202 # 80021fa0 <cons>
    80005af6:	00001097          	auipc	ra,0x1
    80005afa:	83a080e7          	jalr	-1990(ra) # 80006330 <release>
}
    80005afe:	60e2                	ld	ra,24(sp)
    80005b00:	6442                	ld	s0,16(sp)
    80005b02:	64a2                	ld	s1,8(sp)
    80005b04:	6902                	ld	s2,0(sp)
    80005b06:	6105                	addi	sp,sp,32
    80005b08:	8082                	ret
  switch(c){
    80005b0a:	07f00793          	li	a5,127
    80005b0e:	0af48e63          	beq	s1,a5,80005bca <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b12:	0001c717          	auipc	a4,0x1c
    80005b16:	48e70713          	addi	a4,a4,1166 # 80021fa0 <cons>
    80005b1a:	0a072783          	lw	a5,160(a4)
    80005b1e:	09872703          	lw	a4,152(a4)
    80005b22:	9f99                	subw	a5,a5,a4
    80005b24:	07f00713          	li	a4,127
    80005b28:	fcf763e3          	bltu	a4,a5,80005aee <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b2c:	47b5                	li	a5,13
    80005b2e:	0cf48763          	beq	s1,a5,80005bfc <consoleintr+0x14a>
      consputc(c);
    80005b32:	8526                	mv	a0,s1
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	f3c080e7          	jalr	-196(ra) # 80005a70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b3c:	0001c797          	auipc	a5,0x1c
    80005b40:	46478793          	addi	a5,a5,1124 # 80021fa0 <cons>
    80005b44:	0a07a683          	lw	a3,160(a5)
    80005b48:	0016871b          	addiw	a4,a3,1
    80005b4c:	0007061b          	sext.w	a2,a4
    80005b50:	0ae7a023          	sw	a4,160(a5)
    80005b54:	07f6f693          	andi	a3,a3,127
    80005b58:	97b6                	add	a5,a5,a3
    80005b5a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b5e:	47a9                	li	a5,10
    80005b60:	0cf48563          	beq	s1,a5,80005c2a <consoleintr+0x178>
    80005b64:	4791                	li	a5,4
    80005b66:	0cf48263          	beq	s1,a5,80005c2a <consoleintr+0x178>
    80005b6a:	0001c797          	auipc	a5,0x1c
    80005b6e:	4ce7a783          	lw	a5,1230(a5) # 80022038 <cons+0x98>
    80005b72:	9f1d                	subw	a4,a4,a5
    80005b74:	08000793          	li	a5,128
    80005b78:	f6f71be3          	bne	a4,a5,80005aee <consoleintr+0x3c>
    80005b7c:	a07d                	j	80005c2a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b7e:	0001c717          	auipc	a4,0x1c
    80005b82:	42270713          	addi	a4,a4,1058 # 80021fa0 <cons>
    80005b86:	0a072783          	lw	a5,160(a4)
    80005b8a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b8e:	0001c497          	auipc	s1,0x1c
    80005b92:	41248493          	addi	s1,s1,1042 # 80021fa0 <cons>
    while(cons.e != cons.w &&
    80005b96:	4929                	li	s2,10
    80005b98:	f4f70be3          	beq	a4,a5,80005aee <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b9c:	37fd                	addiw	a5,a5,-1
    80005b9e:	07f7f713          	andi	a4,a5,127
    80005ba2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ba4:	01874703          	lbu	a4,24(a4)
    80005ba8:	f52703e3          	beq	a4,s2,80005aee <consoleintr+0x3c>
      cons.e--;
    80005bac:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bb0:	10000513          	li	a0,256
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	ebc080e7          	jalr	-324(ra) # 80005a70 <consputc>
    while(cons.e != cons.w &&
    80005bbc:	0a04a783          	lw	a5,160(s1)
    80005bc0:	09c4a703          	lw	a4,156(s1)
    80005bc4:	fcf71ce3          	bne	a4,a5,80005b9c <consoleintr+0xea>
    80005bc8:	b71d                	j	80005aee <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bca:	0001c717          	auipc	a4,0x1c
    80005bce:	3d670713          	addi	a4,a4,982 # 80021fa0 <cons>
    80005bd2:	0a072783          	lw	a5,160(a4)
    80005bd6:	09c72703          	lw	a4,156(a4)
    80005bda:	f0f70ae3          	beq	a4,a5,80005aee <consoleintr+0x3c>
      cons.e--;
    80005bde:	37fd                	addiw	a5,a5,-1
    80005be0:	0001c717          	auipc	a4,0x1c
    80005be4:	46f72023          	sw	a5,1120(a4) # 80022040 <cons+0xa0>
      consputc(BACKSPACE);
    80005be8:	10000513          	li	a0,256
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	e84080e7          	jalr	-380(ra) # 80005a70 <consputc>
    80005bf4:	bded                	j	80005aee <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bf6:	ee048ce3          	beqz	s1,80005aee <consoleintr+0x3c>
    80005bfa:	bf21                	j	80005b12 <consoleintr+0x60>
      consputc(c);
    80005bfc:	4529                	li	a0,10
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	e72080e7          	jalr	-398(ra) # 80005a70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c06:	0001c797          	auipc	a5,0x1c
    80005c0a:	39a78793          	addi	a5,a5,922 # 80021fa0 <cons>
    80005c0e:	0a07a703          	lw	a4,160(a5)
    80005c12:	0017069b          	addiw	a3,a4,1
    80005c16:	0006861b          	sext.w	a2,a3
    80005c1a:	0ad7a023          	sw	a3,160(a5)
    80005c1e:	07f77713          	andi	a4,a4,127
    80005c22:	97ba                	add	a5,a5,a4
    80005c24:	4729                	li	a4,10
    80005c26:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c2a:	0001c797          	auipc	a5,0x1c
    80005c2e:	40c7a923          	sw	a2,1042(a5) # 8002203c <cons+0x9c>
        wakeup(&cons.r);
    80005c32:	0001c517          	auipc	a0,0x1c
    80005c36:	40650513          	addi	a0,a0,1030 # 80022038 <cons+0x98>
    80005c3a:	ffffc097          	auipc	ra,0xffffc
    80005c3e:	97a080e7          	jalr	-1670(ra) # 800015b4 <wakeup>
    80005c42:	b575                	j	80005aee <consoleintr+0x3c>

0000000080005c44 <consoleinit>:

void
consoleinit(void)
{
    80005c44:	1141                	addi	sp,sp,-16
    80005c46:	e406                	sd	ra,8(sp)
    80005c48:	e022                	sd	s0,0(sp)
    80005c4a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c4c:	00003597          	auipc	a1,0x3
    80005c50:	b9c58593          	addi	a1,a1,-1124 # 800087e8 <syscalls+0x400>
    80005c54:	0001c517          	auipc	a0,0x1c
    80005c58:	34c50513          	addi	a0,a0,844 # 80021fa0 <cons>
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	590080e7          	jalr	1424(ra) # 800061ec <initlock>

  uartinit();
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	330080e7          	jalr	816(ra) # 80005f94 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c6c:	00013797          	auipc	a5,0x13
    80005c70:	05c78793          	addi	a5,a5,92 # 80018cc8 <devsw>
    80005c74:	00000717          	auipc	a4,0x0
    80005c78:	cde70713          	addi	a4,a4,-802 # 80005952 <consoleread>
    80005c7c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c7e:	00000717          	auipc	a4,0x0
    80005c82:	c7270713          	addi	a4,a4,-910 # 800058f0 <consolewrite>
    80005c86:	ef98                	sd	a4,24(a5)
}
    80005c88:	60a2                	ld	ra,8(sp)
    80005c8a:	6402                	ld	s0,0(sp)
    80005c8c:	0141                	addi	sp,sp,16
    80005c8e:	8082                	ret

0000000080005c90 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c90:	7179                	addi	sp,sp,-48
    80005c92:	f406                	sd	ra,40(sp)
    80005c94:	f022                	sd	s0,32(sp)
    80005c96:	ec26                	sd	s1,24(sp)
    80005c98:	e84a                	sd	s2,16(sp)
    80005c9a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c9c:	c219                	beqz	a2,80005ca2 <printint+0x12>
    80005c9e:	08054663          	bltz	a0,80005d2a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ca2:	2501                	sext.w	a0,a0
    80005ca4:	4881                	li	a7,0
    80005ca6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005caa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cac:	2581                	sext.w	a1,a1
    80005cae:	00003617          	auipc	a2,0x3
    80005cb2:	b6a60613          	addi	a2,a2,-1174 # 80008818 <digits>
    80005cb6:	883a                	mv	a6,a4
    80005cb8:	2705                	addiw	a4,a4,1
    80005cba:	02b577bb          	remuw	a5,a0,a1
    80005cbe:	1782                	slli	a5,a5,0x20
    80005cc0:	9381                	srli	a5,a5,0x20
    80005cc2:	97b2                	add	a5,a5,a2
    80005cc4:	0007c783          	lbu	a5,0(a5)
    80005cc8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ccc:	0005079b          	sext.w	a5,a0
    80005cd0:	02b5553b          	divuw	a0,a0,a1
    80005cd4:	0685                	addi	a3,a3,1
    80005cd6:	feb7f0e3          	bgeu	a5,a1,80005cb6 <printint+0x26>

  if(sign)
    80005cda:	00088b63          	beqz	a7,80005cf0 <printint+0x60>
    buf[i++] = '-';
    80005cde:	fe040793          	addi	a5,s0,-32
    80005ce2:	973e                	add	a4,a4,a5
    80005ce4:	02d00793          	li	a5,45
    80005ce8:	fef70823          	sb	a5,-16(a4)
    80005cec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cf0:	02e05763          	blez	a4,80005d1e <printint+0x8e>
    80005cf4:	fd040793          	addi	a5,s0,-48
    80005cf8:	00e784b3          	add	s1,a5,a4
    80005cfc:	fff78913          	addi	s2,a5,-1
    80005d00:	993a                	add	s2,s2,a4
    80005d02:	377d                	addiw	a4,a4,-1
    80005d04:	1702                	slli	a4,a4,0x20
    80005d06:	9301                	srli	a4,a4,0x20
    80005d08:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d0c:	fff4c503          	lbu	a0,-1(s1)
    80005d10:	00000097          	auipc	ra,0x0
    80005d14:	d60080e7          	jalr	-672(ra) # 80005a70 <consputc>
  while(--i >= 0)
    80005d18:	14fd                	addi	s1,s1,-1
    80005d1a:	ff2499e3          	bne	s1,s2,80005d0c <printint+0x7c>
}
    80005d1e:	70a2                	ld	ra,40(sp)
    80005d20:	7402                	ld	s0,32(sp)
    80005d22:	64e2                	ld	s1,24(sp)
    80005d24:	6942                	ld	s2,16(sp)
    80005d26:	6145                	addi	sp,sp,48
    80005d28:	8082                	ret
    x = -xx;
    80005d2a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d2e:	4885                	li	a7,1
    x = -xx;
    80005d30:	bf9d                	j	80005ca6 <printint+0x16>

0000000080005d32 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d32:	1101                	addi	sp,sp,-32
    80005d34:	ec06                	sd	ra,24(sp)
    80005d36:	e822                	sd	s0,16(sp)
    80005d38:	e426                	sd	s1,8(sp)
    80005d3a:	1000                	addi	s0,sp,32
    80005d3c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d3e:	0001c797          	auipc	a5,0x1c
    80005d42:	3207a123          	sw	zero,802(a5) # 80022060 <pr+0x18>
  printf("panic: ");
    80005d46:	00003517          	auipc	a0,0x3
    80005d4a:	aaa50513          	addi	a0,a0,-1366 # 800087f0 <syscalls+0x408>
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	02e080e7          	jalr	46(ra) # 80005d7c <printf>
  printf(s);
    80005d56:	8526                	mv	a0,s1
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	024080e7          	jalr	36(ra) # 80005d7c <printf>
  printf("\n");
    80005d60:	00002517          	auipc	a0,0x2
    80005d64:	2e850513          	addi	a0,a0,744 # 80008048 <etext+0x48>
    80005d68:	00000097          	auipc	ra,0x0
    80005d6c:	014080e7          	jalr	20(ra) # 80005d7c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d70:	4785                	li	a5,1
    80005d72:	00003717          	auipc	a4,0x3
    80005d76:	caf72323          	sw	a5,-858(a4) # 80008a18 <panicked>
  for(;;)
    80005d7a:	a001                	j	80005d7a <panic+0x48>

0000000080005d7c <printf>:
{
    80005d7c:	7131                	addi	sp,sp,-192
    80005d7e:	fc86                	sd	ra,120(sp)
    80005d80:	f8a2                	sd	s0,112(sp)
    80005d82:	f4a6                	sd	s1,104(sp)
    80005d84:	f0ca                	sd	s2,96(sp)
    80005d86:	ecce                	sd	s3,88(sp)
    80005d88:	e8d2                	sd	s4,80(sp)
    80005d8a:	e4d6                	sd	s5,72(sp)
    80005d8c:	e0da                	sd	s6,64(sp)
    80005d8e:	fc5e                	sd	s7,56(sp)
    80005d90:	f862                	sd	s8,48(sp)
    80005d92:	f466                	sd	s9,40(sp)
    80005d94:	f06a                	sd	s10,32(sp)
    80005d96:	ec6e                	sd	s11,24(sp)
    80005d98:	0100                	addi	s0,sp,128
    80005d9a:	8a2a                	mv	s4,a0
    80005d9c:	e40c                	sd	a1,8(s0)
    80005d9e:	e810                	sd	a2,16(s0)
    80005da0:	ec14                	sd	a3,24(s0)
    80005da2:	f018                	sd	a4,32(s0)
    80005da4:	f41c                	sd	a5,40(s0)
    80005da6:	03043823          	sd	a6,48(s0)
    80005daa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dae:	0001cd97          	auipc	s11,0x1c
    80005db2:	2b2dad83          	lw	s11,690(s11) # 80022060 <pr+0x18>
  if(locking)
    80005db6:	020d9b63          	bnez	s11,80005dec <printf+0x70>
  if (fmt == 0)
    80005dba:	040a0263          	beqz	s4,80005dfe <printf+0x82>
  va_start(ap, fmt);
    80005dbe:	00840793          	addi	a5,s0,8
    80005dc2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dc6:	000a4503          	lbu	a0,0(s4)
    80005dca:	16050263          	beqz	a0,80005f2e <printf+0x1b2>
    80005dce:	4481                	li	s1,0
    if(c != '%'){
    80005dd0:	02500a93          	li	s5,37
    switch(c){
    80005dd4:	07000b13          	li	s6,112
  consputc('x');
    80005dd8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dda:	00003b97          	auipc	s7,0x3
    80005dde:	a3eb8b93          	addi	s7,s7,-1474 # 80008818 <digits>
    switch(c){
    80005de2:	07300c93          	li	s9,115
    80005de6:	06400c13          	li	s8,100
    80005dea:	a82d                	j	80005e24 <printf+0xa8>
    acquire(&pr.lock);
    80005dec:	0001c517          	auipc	a0,0x1c
    80005df0:	25c50513          	addi	a0,a0,604 # 80022048 <pr>
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	488080e7          	jalr	1160(ra) # 8000627c <acquire>
    80005dfc:	bf7d                	j	80005dba <printf+0x3e>
    panic("null fmt");
    80005dfe:	00003517          	auipc	a0,0x3
    80005e02:	a0250513          	addi	a0,a0,-1534 # 80008800 <syscalls+0x418>
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	f2c080e7          	jalr	-212(ra) # 80005d32 <panic>
      consputc(c);
    80005e0e:	00000097          	auipc	ra,0x0
    80005e12:	c62080e7          	jalr	-926(ra) # 80005a70 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e16:	2485                	addiw	s1,s1,1
    80005e18:	009a07b3          	add	a5,s4,s1
    80005e1c:	0007c503          	lbu	a0,0(a5)
    80005e20:	10050763          	beqz	a0,80005f2e <printf+0x1b2>
    if(c != '%'){
    80005e24:	ff5515e3          	bne	a0,s5,80005e0e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e28:	2485                	addiw	s1,s1,1
    80005e2a:	009a07b3          	add	a5,s4,s1
    80005e2e:	0007c783          	lbu	a5,0(a5)
    80005e32:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e36:	cfe5                	beqz	a5,80005f2e <printf+0x1b2>
    switch(c){
    80005e38:	05678a63          	beq	a5,s6,80005e8c <printf+0x110>
    80005e3c:	02fb7663          	bgeu	s6,a5,80005e68 <printf+0xec>
    80005e40:	09978963          	beq	a5,s9,80005ed2 <printf+0x156>
    80005e44:	07800713          	li	a4,120
    80005e48:	0ce79863          	bne	a5,a4,80005f18 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e4c:	f8843783          	ld	a5,-120(s0)
    80005e50:	00878713          	addi	a4,a5,8
    80005e54:	f8e43423          	sd	a4,-120(s0)
    80005e58:	4605                	li	a2,1
    80005e5a:	85ea                	mv	a1,s10
    80005e5c:	4388                	lw	a0,0(a5)
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	e32080e7          	jalr	-462(ra) # 80005c90 <printint>
      break;
    80005e66:	bf45                	j	80005e16 <printf+0x9a>
    switch(c){
    80005e68:	0b578263          	beq	a5,s5,80005f0c <printf+0x190>
    80005e6c:	0b879663          	bne	a5,s8,80005f18 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e70:	f8843783          	ld	a5,-120(s0)
    80005e74:	00878713          	addi	a4,a5,8
    80005e78:	f8e43423          	sd	a4,-120(s0)
    80005e7c:	4605                	li	a2,1
    80005e7e:	45a9                	li	a1,10
    80005e80:	4388                	lw	a0,0(a5)
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	e0e080e7          	jalr	-498(ra) # 80005c90 <printint>
      break;
    80005e8a:	b771                	j	80005e16 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e8c:	f8843783          	ld	a5,-120(s0)
    80005e90:	00878713          	addi	a4,a5,8
    80005e94:	f8e43423          	sd	a4,-120(s0)
    80005e98:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e9c:	03000513          	li	a0,48
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	bd0080e7          	jalr	-1072(ra) # 80005a70 <consputc>
  consputc('x');
    80005ea8:	07800513          	li	a0,120
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	bc4080e7          	jalr	-1084(ra) # 80005a70 <consputc>
    80005eb4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eb6:	03c9d793          	srli	a5,s3,0x3c
    80005eba:	97de                	add	a5,a5,s7
    80005ebc:	0007c503          	lbu	a0,0(a5)
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	bb0080e7          	jalr	-1104(ra) # 80005a70 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ec8:	0992                	slli	s3,s3,0x4
    80005eca:	397d                	addiw	s2,s2,-1
    80005ecc:	fe0915e3          	bnez	s2,80005eb6 <printf+0x13a>
    80005ed0:	b799                	j	80005e16 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ed2:	f8843783          	ld	a5,-120(s0)
    80005ed6:	00878713          	addi	a4,a5,8
    80005eda:	f8e43423          	sd	a4,-120(s0)
    80005ede:	0007b903          	ld	s2,0(a5)
    80005ee2:	00090e63          	beqz	s2,80005efe <printf+0x182>
      for(; *s; s++)
    80005ee6:	00094503          	lbu	a0,0(s2)
    80005eea:	d515                	beqz	a0,80005e16 <printf+0x9a>
        consputc(*s);
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	b84080e7          	jalr	-1148(ra) # 80005a70 <consputc>
      for(; *s; s++)
    80005ef4:	0905                	addi	s2,s2,1
    80005ef6:	00094503          	lbu	a0,0(s2)
    80005efa:	f96d                	bnez	a0,80005eec <printf+0x170>
    80005efc:	bf29                	j	80005e16 <printf+0x9a>
        s = "(null)";
    80005efe:	00003917          	auipc	s2,0x3
    80005f02:	8fa90913          	addi	s2,s2,-1798 # 800087f8 <syscalls+0x410>
      for(; *s; s++)
    80005f06:	02800513          	li	a0,40
    80005f0a:	b7cd                	j	80005eec <printf+0x170>
      consputc('%');
    80005f0c:	8556                	mv	a0,s5
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	b62080e7          	jalr	-1182(ra) # 80005a70 <consputc>
      break;
    80005f16:	b701                	j	80005e16 <printf+0x9a>
      consputc('%');
    80005f18:	8556                	mv	a0,s5
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	b56080e7          	jalr	-1194(ra) # 80005a70 <consputc>
      consputc(c);
    80005f22:	854a                	mv	a0,s2
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	b4c080e7          	jalr	-1204(ra) # 80005a70 <consputc>
      break;
    80005f2c:	b5ed                	j	80005e16 <printf+0x9a>
  if(locking)
    80005f2e:	020d9163          	bnez	s11,80005f50 <printf+0x1d4>
}
    80005f32:	70e6                	ld	ra,120(sp)
    80005f34:	7446                	ld	s0,112(sp)
    80005f36:	74a6                	ld	s1,104(sp)
    80005f38:	7906                	ld	s2,96(sp)
    80005f3a:	69e6                	ld	s3,88(sp)
    80005f3c:	6a46                	ld	s4,80(sp)
    80005f3e:	6aa6                	ld	s5,72(sp)
    80005f40:	6b06                	ld	s6,64(sp)
    80005f42:	7be2                	ld	s7,56(sp)
    80005f44:	7c42                	ld	s8,48(sp)
    80005f46:	7ca2                	ld	s9,40(sp)
    80005f48:	7d02                	ld	s10,32(sp)
    80005f4a:	6de2                	ld	s11,24(sp)
    80005f4c:	6129                	addi	sp,sp,192
    80005f4e:	8082                	ret
    release(&pr.lock);
    80005f50:	0001c517          	auipc	a0,0x1c
    80005f54:	0f850513          	addi	a0,a0,248 # 80022048 <pr>
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	3d8080e7          	jalr	984(ra) # 80006330 <release>
}
    80005f60:	bfc9                	j	80005f32 <printf+0x1b6>

0000000080005f62 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f62:	1101                	addi	sp,sp,-32
    80005f64:	ec06                	sd	ra,24(sp)
    80005f66:	e822                	sd	s0,16(sp)
    80005f68:	e426                	sd	s1,8(sp)
    80005f6a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f6c:	0001c497          	auipc	s1,0x1c
    80005f70:	0dc48493          	addi	s1,s1,220 # 80022048 <pr>
    80005f74:	00003597          	auipc	a1,0x3
    80005f78:	89c58593          	addi	a1,a1,-1892 # 80008810 <syscalls+0x428>
    80005f7c:	8526                	mv	a0,s1
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	26e080e7          	jalr	622(ra) # 800061ec <initlock>
  pr.locking = 1;
    80005f86:	4785                	li	a5,1
    80005f88:	cc9c                	sw	a5,24(s1)
}
    80005f8a:	60e2                	ld	ra,24(sp)
    80005f8c:	6442                	ld	s0,16(sp)
    80005f8e:	64a2                	ld	s1,8(sp)
    80005f90:	6105                	addi	sp,sp,32
    80005f92:	8082                	ret

0000000080005f94 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f94:	1141                	addi	sp,sp,-16
    80005f96:	e406                	sd	ra,8(sp)
    80005f98:	e022                	sd	s0,0(sp)
    80005f9a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f9c:	100007b7          	lui	a5,0x10000
    80005fa0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fa4:	f8000713          	li	a4,-128
    80005fa8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fac:	470d                	li	a4,3
    80005fae:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fb2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fb6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fba:	469d                	li	a3,7
    80005fbc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fc0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fc4:	00003597          	auipc	a1,0x3
    80005fc8:	86c58593          	addi	a1,a1,-1940 # 80008830 <digits+0x18>
    80005fcc:	0001c517          	auipc	a0,0x1c
    80005fd0:	09c50513          	addi	a0,a0,156 # 80022068 <uart_tx_lock>
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	218080e7          	jalr	536(ra) # 800061ec <initlock>
}
    80005fdc:	60a2                	ld	ra,8(sp)
    80005fde:	6402                	ld	s0,0(sp)
    80005fe0:	0141                	addi	sp,sp,16
    80005fe2:	8082                	ret

0000000080005fe4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fe4:	1101                	addi	sp,sp,-32
    80005fe6:	ec06                	sd	ra,24(sp)
    80005fe8:	e822                	sd	s0,16(sp)
    80005fea:	e426                	sd	s1,8(sp)
    80005fec:	1000                	addi	s0,sp,32
    80005fee:	84aa                	mv	s1,a0
  push_off();
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	240080e7          	jalr	576(ra) # 80006230 <push_off>

  if(panicked){
    80005ff8:	00003797          	auipc	a5,0x3
    80005ffc:	a207a783          	lw	a5,-1504(a5) # 80008a18 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006000:	10000737          	lui	a4,0x10000
  if(panicked){
    80006004:	c391                	beqz	a5,80006008 <uartputc_sync+0x24>
    for(;;)
    80006006:	a001                	j	80006006 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006008:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000600c:	0ff7f793          	andi	a5,a5,255
    80006010:	0207f793          	andi	a5,a5,32
    80006014:	dbf5                	beqz	a5,80006008 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006016:	0ff4f793          	andi	a5,s1,255
    8000601a:	10000737          	lui	a4,0x10000
    8000601e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006022:	00000097          	auipc	ra,0x0
    80006026:	2ae080e7          	jalr	686(ra) # 800062d0 <pop_off>
}
    8000602a:	60e2                	ld	ra,24(sp)
    8000602c:	6442                	ld	s0,16(sp)
    8000602e:	64a2                	ld	s1,8(sp)
    80006030:	6105                	addi	sp,sp,32
    80006032:	8082                	ret

0000000080006034 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006034:	00003717          	auipc	a4,0x3
    80006038:	9ec73703          	ld	a4,-1556(a4) # 80008a20 <uart_tx_r>
    8000603c:	00003797          	auipc	a5,0x3
    80006040:	9ec7b783          	ld	a5,-1556(a5) # 80008a28 <uart_tx_w>
    80006044:	06e78c63          	beq	a5,a4,800060bc <uartstart+0x88>
{
    80006048:	7139                	addi	sp,sp,-64
    8000604a:	fc06                	sd	ra,56(sp)
    8000604c:	f822                	sd	s0,48(sp)
    8000604e:	f426                	sd	s1,40(sp)
    80006050:	f04a                	sd	s2,32(sp)
    80006052:	ec4e                	sd	s3,24(sp)
    80006054:	e852                	sd	s4,16(sp)
    80006056:	e456                	sd	s5,8(sp)
    80006058:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000605a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000605e:	0001ca17          	auipc	s4,0x1c
    80006062:	00aa0a13          	addi	s4,s4,10 # 80022068 <uart_tx_lock>
    uart_tx_r += 1;
    80006066:	00003497          	auipc	s1,0x3
    8000606a:	9ba48493          	addi	s1,s1,-1606 # 80008a20 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000606e:	00003997          	auipc	s3,0x3
    80006072:	9ba98993          	addi	s3,s3,-1606 # 80008a28 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006076:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000607a:	0ff7f793          	andi	a5,a5,255
    8000607e:	0207f793          	andi	a5,a5,32
    80006082:	c785                	beqz	a5,800060aa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006084:	01f77793          	andi	a5,a4,31
    80006088:	97d2                	add	a5,a5,s4
    8000608a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000608e:	0705                	addi	a4,a4,1
    80006090:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006092:	8526                	mv	a0,s1
    80006094:	ffffb097          	auipc	ra,0xffffb
    80006098:	520080e7          	jalr	1312(ra) # 800015b4 <wakeup>
    
    WriteReg(THR, c);
    8000609c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060a0:	6098                	ld	a4,0(s1)
    800060a2:	0009b783          	ld	a5,0(s3)
    800060a6:	fce798e3          	bne	a5,a4,80006076 <uartstart+0x42>
  }
}
    800060aa:	70e2                	ld	ra,56(sp)
    800060ac:	7442                	ld	s0,48(sp)
    800060ae:	74a2                	ld	s1,40(sp)
    800060b0:	7902                	ld	s2,32(sp)
    800060b2:	69e2                	ld	s3,24(sp)
    800060b4:	6a42                	ld	s4,16(sp)
    800060b6:	6aa2                	ld	s5,8(sp)
    800060b8:	6121                	addi	sp,sp,64
    800060ba:	8082                	ret
    800060bc:	8082                	ret

00000000800060be <uartputc>:
{
    800060be:	7179                	addi	sp,sp,-48
    800060c0:	f406                	sd	ra,40(sp)
    800060c2:	f022                	sd	s0,32(sp)
    800060c4:	ec26                	sd	s1,24(sp)
    800060c6:	e84a                	sd	s2,16(sp)
    800060c8:	e44e                	sd	s3,8(sp)
    800060ca:	e052                	sd	s4,0(sp)
    800060cc:	1800                	addi	s0,sp,48
    800060ce:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060d0:	0001c517          	auipc	a0,0x1c
    800060d4:	f9850513          	addi	a0,a0,-104 # 80022068 <uart_tx_lock>
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	1a4080e7          	jalr	420(ra) # 8000627c <acquire>
  if(panicked){
    800060e0:	00003797          	auipc	a5,0x3
    800060e4:	9387a783          	lw	a5,-1736(a5) # 80008a18 <panicked>
    800060e8:	e7c9                	bnez	a5,80006172 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060ea:	00003797          	auipc	a5,0x3
    800060ee:	93e7b783          	ld	a5,-1730(a5) # 80008a28 <uart_tx_w>
    800060f2:	00003717          	auipc	a4,0x3
    800060f6:	92e73703          	ld	a4,-1746(a4) # 80008a20 <uart_tx_r>
    800060fa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060fe:	0001ca17          	auipc	s4,0x1c
    80006102:	f6aa0a13          	addi	s4,s4,-150 # 80022068 <uart_tx_lock>
    80006106:	00003497          	auipc	s1,0x3
    8000610a:	91a48493          	addi	s1,s1,-1766 # 80008a20 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610e:	00003917          	auipc	s2,0x3
    80006112:	91a90913          	addi	s2,s2,-1766 # 80008a28 <uart_tx_w>
    80006116:	00f71f63          	bne	a4,a5,80006134 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000611a:	85d2                	mv	a1,s4
    8000611c:	8526                	mv	a0,s1
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	432080e7          	jalr	1074(ra) # 80001550 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006126:	00093783          	ld	a5,0(s2)
    8000612a:	6098                	ld	a4,0(s1)
    8000612c:	02070713          	addi	a4,a4,32
    80006130:	fef705e3          	beq	a4,a5,8000611a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006134:	0001c497          	auipc	s1,0x1c
    80006138:	f3448493          	addi	s1,s1,-204 # 80022068 <uart_tx_lock>
    8000613c:	01f7f713          	andi	a4,a5,31
    80006140:	9726                	add	a4,a4,s1
    80006142:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006146:	0785                	addi	a5,a5,1
    80006148:	00003717          	auipc	a4,0x3
    8000614c:	8ef73023          	sd	a5,-1824(a4) # 80008a28 <uart_tx_w>
  uartstart();
    80006150:	00000097          	auipc	ra,0x0
    80006154:	ee4080e7          	jalr	-284(ra) # 80006034 <uartstart>
  release(&uart_tx_lock);
    80006158:	8526                	mv	a0,s1
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	1d6080e7          	jalr	470(ra) # 80006330 <release>
}
    80006162:	70a2                	ld	ra,40(sp)
    80006164:	7402                	ld	s0,32(sp)
    80006166:	64e2                	ld	s1,24(sp)
    80006168:	6942                	ld	s2,16(sp)
    8000616a:	69a2                	ld	s3,8(sp)
    8000616c:	6a02                	ld	s4,0(sp)
    8000616e:	6145                	addi	sp,sp,48
    80006170:	8082                	ret
    for(;;)
    80006172:	a001                	j	80006172 <uartputc+0xb4>

0000000080006174 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006174:	1141                	addi	sp,sp,-16
    80006176:	e422                	sd	s0,8(sp)
    80006178:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000617a:	100007b7          	lui	a5,0x10000
    8000617e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006182:	8b85                	andi	a5,a5,1
    80006184:	cb91                	beqz	a5,80006198 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006186:	100007b7          	lui	a5,0x10000
    8000618a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000618e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006192:	6422                	ld	s0,8(sp)
    80006194:	0141                	addi	sp,sp,16
    80006196:	8082                	ret
    return -1;
    80006198:	557d                	li	a0,-1
    8000619a:	bfe5                	j	80006192 <uartgetc+0x1e>

000000008000619c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000619c:	1101                	addi	sp,sp,-32
    8000619e:	ec06                	sd	ra,24(sp)
    800061a0:	e822                	sd	s0,16(sp)
    800061a2:	e426                	sd	s1,8(sp)
    800061a4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061a6:	54fd                	li	s1,-1
    int c = uartgetc();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	fcc080e7          	jalr	-52(ra) # 80006174 <uartgetc>
    if(c == -1)
    800061b0:	00950763          	beq	a0,s1,800061be <uartintr+0x22>
      break;
    consoleintr(c);
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	8fe080e7          	jalr	-1794(ra) # 80005ab2 <consoleintr>
  while(1){
    800061bc:	b7f5                	j	800061a8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061be:	0001c497          	auipc	s1,0x1c
    800061c2:	eaa48493          	addi	s1,s1,-342 # 80022068 <uart_tx_lock>
    800061c6:	8526                	mv	a0,s1
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	0b4080e7          	jalr	180(ra) # 8000627c <acquire>
  uartstart();
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	e64080e7          	jalr	-412(ra) # 80006034 <uartstart>
  release(&uart_tx_lock);
    800061d8:	8526                	mv	a0,s1
    800061da:	00000097          	auipc	ra,0x0
    800061de:	156080e7          	jalr	342(ra) # 80006330 <release>
}
    800061e2:	60e2                	ld	ra,24(sp)
    800061e4:	6442                	ld	s0,16(sp)
    800061e6:	64a2                	ld	s1,8(sp)
    800061e8:	6105                	addi	sp,sp,32
    800061ea:	8082                	ret

00000000800061ec <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061ec:	1141                	addi	sp,sp,-16
    800061ee:	e422                	sd	s0,8(sp)
    800061f0:	0800                	addi	s0,sp,16
  lk->name = name;
    800061f2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061f4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061f8:	00053823          	sd	zero,16(a0)
}
    800061fc:	6422                	ld	s0,8(sp)
    800061fe:	0141                	addi	sp,sp,16
    80006200:	8082                	ret

0000000080006202 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006202:	411c                	lw	a5,0(a0)
    80006204:	e399                	bnez	a5,8000620a <holding+0x8>
    80006206:	4501                	li	a0,0
  return r;
}
    80006208:	8082                	ret
{
    8000620a:	1101                	addi	sp,sp,-32
    8000620c:	ec06                	sd	ra,24(sp)
    8000620e:	e822                	sd	s0,16(sp)
    80006210:	e426                	sd	s1,8(sp)
    80006212:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006214:	6904                	ld	s1,16(a0)
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	c72080e7          	jalr	-910(ra) # 80000e88 <mycpu>
    8000621e:	40a48533          	sub	a0,s1,a0
    80006222:	00153513          	seqz	a0,a0
}
    80006226:	60e2                	ld	ra,24(sp)
    80006228:	6442                	ld	s0,16(sp)
    8000622a:	64a2                	ld	s1,8(sp)
    8000622c:	6105                	addi	sp,sp,32
    8000622e:	8082                	ret

0000000080006230 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006230:	1101                	addi	sp,sp,-32
    80006232:	ec06                	sd	ra,24(sp)
    80006234:	e822                	sd	s0,16(sp)
    80006236:	e426                	sd	s1,8(sp)
    80006238:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623a:	100024f3          	csrr	s1,sstatus
    8000623e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006242:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006244:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	c40080e7          	jalr	-960(ra) # 80000e88 <mycpu>
    80006250:	5d3c                	lw	a5,120(a0)
    80006252:	cf89                	beqz	a5,8000626c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	c34080e7          	jalr	-972(ra) # 80000e88 <mycpu>
    8000625c:	5d3c                	lw	a5,120(a0)
    8000625e:	2785                	addiw	a5,a5,1
    80006260:	dd3c                	sw	a5,120(a0)
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret
    mycpu()->intena = old;
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	c1c080e7          	jalr	-996(ra) # 80000e88 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006274:	8085                	srli	s1,s1,0x1
    80006276:	8885                	andi	s1,s1,1
    80006278:	dd64                	sw	s1,124(a0)
    8000627a:	bfe9                	j	80006254 <push_off+0x24>

000000008000627c <acquire>:
{
    8000627c:	1101                	addi	sp,sp,-32
    8000627e:	ec06                	sd	ra,24(sp)
    80006280:	e822                	sd	s0,16(sp)
    80006282:	e426                	sd	s1,8(sp)
    80006284:	1000                	addi	s0,sp,32
    80006286:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	fa8080e7          	jalr	-88(ra) # 80006230 <push_off>
  if(holding(lk))
    80006290:	8526                	mv	a0,s1
    80006292:	00000097          	auipc	ra,0x0
    80006296:	f70080e7          	jalr	-144(ra) # 80006202 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000629a:	4705                	li	a4,1
  if(holding(lk))
    8000629c:	e115                	bnez	a0,800062c0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000629e:	87ba                	mv	a5,a4
    800062a0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062a4:	2781                	sext.w	a5,a5
    800062a6:	ffe5                	bnez	a5,8000629e <acquire+0x22>
  __sync_synchronize();
    800062a8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	bdc080e7          	jalr	-1060(ra) # 80000e88 <mycpu>
    800062b4:	e888                	sd	a0,16(s1)
}
    800062b6:	60e2                	ld	ra,24(sp)
    800062b8:	6442                	ld	s0,16(sp)
    800062ba:	64a2                	ld	s1,8(sp)
    800062bc:	6105                	addi	sp,sp,32
    800062be:	8082                	ret
    panic("acquire");
    800062c0:	00002517          	auipc	a0,0x2
    800062c4:	57850513          	addi	a0,a0,1400 # 80008838 <digits+0x20>
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	a6a080e7          	jalr	-1430(ra) # 80005d32 <panic>

00000000800062d0 <pop_off>:

void
pop_off(void)
{
    800062d0:	1141                	addi	sp,sp,-16
    800062d2:	e406                	sd	ra,8(sp)
    800062d4:	e022                	sd	s0,0(sp)
    800062d6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062d8:	ffffb097          	auipc	ra,0xffffb
    800062dc:	bb0080e7          	jalr	-1104(ra) # 80000e88 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062e6:	e78d                	bnez	a5,80006310 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062e8:	5d3c                	lw	a5,120(a0)
    800062ea:	02f05b63          	blez	a5,80006320 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062ee:	37fd                	addiw	a5,a5,-1
    800062f0:	0007871b          	sext.w	a4,a5
    800062f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062f6:	eb09                	bnez	a4,80006308 <pop_off+0x38>
    800062f8:	5d7c                	lw	a5,124(a0)
    800062fa:	c799                	beqz	a5,80006308 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006300:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006304:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006308:	60a2                	ld	ra,8(sp)
    8000630a:	6402                	ld	s0,0(sp)
    8000630c:	0141                	addi	sp,sp,16
    8000630e:	8082                	ret
    panic("pop_off - interruptible");
    80006310:	00002517          	auipc	a0,0x2
    80006314:	53050513          	addi	a0,a0,1328 # 80008840 <digits+0x28>
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	a1a080e7          	jalr	-1510(ra) # 80005d32 <panic>
    panic("pop_off");
    80006320:	00002517          	auipc	a0,0x2
    80006324:	53850513          	addi	a0,a0,1336 # 80008858 <digits+0x40>
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	a0a080e7          	jalr	-1526(ra) # 80005d32 <panic>

0000000080006330 <release>:
{
    80006330:	1101                	addi	sp,sp,-32
    80006332:	ec06                	sd	ra,24(sp)
    80006334:	e822                	sd	s0,16(sp)
    80006336:	e426                	sd	s1,8(sp)
    80006338:	1000                	addi	s0,sp,32
    8000633a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	ec6080e7          	jalr	-314(ra) # 80006202 <holding>
    80006344:	c115                	beqz	a0,80006368 <release+0x38>
  lk->cpu = 0;
    80006346:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000634a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000634e:	0f50000f          	fence	iorw,ow
    80006352:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006356:	00000097          	auipc	ra,0x0
    8000635a:	f7a080e7          	jalr	-134(ra) # 800062d0 <pop_off>
}
    8000635e:	60e2                	ld	ra,24(sp)
    80006360:	6442                	ld	s0,16(sp)
    80006362:	64a2                	ld	s1,8(sp)
    80006364:	6105                	addi	sp,sp,32
    80006366:	8082                	ret
    panic("release");
    80006368:	00002517          	auipc	a0,0x2
    8000636c:	4f850513          	addi	a0,a0,1272 # 80008860 <digits+0x48>
    80006370:	00000097          	auipc	ra,0x0
    80006374:	9c2080e7          	jalr	-1598(ra) # 80005d32 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
