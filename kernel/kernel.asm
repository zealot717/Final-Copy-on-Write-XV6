
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0bd050ef          	jal	ra,800058d2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	eba5                	bnez	a5,8000009e <kfree+0x82>
    80000030:	84aa                	mv	s1,a0
    80000032:	00246797          	auipc	a5,0x246
    80000036:	20e78793          	addi	a5,a5,526 # 80246240 <end>
    8000003a:	06f56263          	bltu	a0,a5,8000009e <kfree+0x82>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57e63          	bgeu	a0,a5,8000009e <kfree+0x82>
    panic("kfree");

  // lock first
  acquire(&reflock);
    80000046:	00009517          	auipc	a0,0x9
    8000004a:	fea50513          	addi	a0,a0,-22 # 80009030 <reflock>
    8000004e:	00006097          	auipc	ra,0x6
    80000052:	26a080e7          	jalr	618(ra) # 800062b8 <acquire>
  
  // if it's a page pointed to by more than one
  if (reference_counter[((uint64)pa)/PGSIZE]<=1){
    80000056:	00c4d793          	srli	a5,s1,0xc
    8000005a:	00279693          	slli	a3,a5,0x2
    8000005e:	00009717          	auipc	a4,0x9
    80000062:	00a70713          	addi	a4,a4,10 # 80009068 <reference_counter>
    80000066:	9736                	add	a4,a4,a3
    80000068:	4318                	lw	a4,0(a4)
    8000006a:	4685                	li	a3,1
    8000006c:	04e6d163          	bge	a3,a4,800000ae <kfree+0x92>
    release(&kmem.lock);

  }
  else { 
    // else just decrease the reference counter
    reference_counter[((uint64)pa)/PGSIZE]-=1;
    80000070:	078a                	slli	a5,a5,0x2
    80000072:	00009697          	auipc	a3,0x9
    80000076:	ff668693          	addi	a3,a3,-10 # 80009068 <reference_counter>
    8000007a:	97b6                	add	a5,a5,a3
    8000007c:	377d                	addiw	a4,a4,-1
    8000007e:	c398                	sw	a4,0(a5)
    release(&reflock);
    80000080:	00009517          	auipc	a0,0x9
    80000084:	fb050513          	addi	a0,a0,-80 # 80009030 <reflock>
    80000088:	00006097          	auipc	ra,0x6
    8000008c:	2e4080e7          	jalr	740(ra) # 8000636c <release>
  }
  
}
    80000090:	70a2                	ld	ra,40(sp)
    80000092:	7402                	ld	s0,32(sp)
    80000094:	64e2                	ld	s1,24(sp)
    80000096:	6942                	ld	s2,16(sp)
    80000098:	69a2                	ld	s3,8(sp)
    8000009a:	6145                	addi	sp,sp,48
    8000009c:	8082                	ret
    panic("kfree");
    8000009e:	00008517          	auipc	a0,0x8
    800000a2:	f7250513          	addi	a0,a0,-142 # 80008010 <etext+0x10>
    800000a6:	00006097          	auipc	ra,0x6
    800000aa:	cda080e7          	jalr	-806(ra) # 80005d80 <panic>
    reference_counter[((uint64)pa)/PGSIZE]=0;
    800000ae:	078a                	slli	a5,a5,0x2
    800000b0:	00009717          	auipc	a4,0x9
    800000b4:	fb870713          	addi	a4,a4,-72 # 80009068 <reference_counter>
    800000b8:	97ba                	add	a5,a5,a4
    800000ba:	0007a023          	sw	zero,0(a5)
    release(&reflock);
    800000be:	00009917          	auipc	s2,0x9
    800000c2:	f7290913          	addi	s2,s2,-142 # 80009030 <reflock>
    800000c6:	854a                	mv	a0,s2
    800000c8:	00006097          	auipc	ra,0x6
    800000cc:	2a4080e7          	jalr	676(ra) # 8000636c <release>
    memset(pa, 1, PGSIZE);
    800000d0:	6605                	lui	a2,0x1
    800000d2:	4585                	li	a1,1
    800000d4:	8526                	mv	a0,s1
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	1aa080e7          	jalr	426(ra) # 80000280 <memset>
    acquire(&kmem.lock);
    800000de:	00009997          	auipc	s3,0x9
    800000e2:	f6a98993          	addi	s3,s3,-150 # 80009048 <kmem>
    800000e6:	854e                	mv	a0,s3
    800000e8:	00006097          	auipc	ra,0x6
    800000ec:	1d0080e7          	jalr	464(ra) # 800062b8 <acquire>
    r->next = kmem.freelist;
    800000f0:	03093783          	ld	a5,48(s2)
    800000f4:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    800000f6:	02993823          	sd	s1,48(s2)
    release(&kmem.lock);
    800000fa:	854e                	mv	a0,s3
    800000fc:	00006097          	auipc	ra,0x6
    80000100:	270080e7          	jalr	624(ra) # 8000636c <release>
    80000104:	b771                	j	80000090 <kfree+0x74>

0000000080000106 <freerange>:
{
    80000106:	715d                	addi	sp,sp,-80
    80000108:	e486                	sd	ra,72(sp)
    8000010a:	e0a2                	sd	s0,64(sp)
    8000010c:	fc26                	sd	s1,56(sp)
    8000010e:	f84a                	sd	s2,48(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	e85a                	sd	s6,16(sp)
    80000118:	e45e                	sd	s7,8(sp)
    8000011a:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000011c:	6785                	lui	a5,0x1
    8000011e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000122:	953a                	add	a0,a0,a4
    80000124:	777d                	lui	a4,0xfffff
    80000126:	00e574b3          	and	s1,a0,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    8000012a:	97a6                	add	a5,a5,s1
    8000012c:	04f5e863          	bltu	a1,a5,8000017c <freerange+0x76>
    80000130:	89ae                	mv	s3,a1
    acquire(&reflock);
    80000132:	00009917          	auipc	s2,0x9
    80000136:	efe90913          	addi	s2,s2,-258 # 80009030 <reflock>
    reference_counter[((uint64)p)/PGSIZE]=1; 
    8000013a:	00009b97          	auipc	s7,0x9
    8000013e:	f2eb8b93          	addi	s7,s7,-210 # 80009068 <reference_counter>
    80000142:	4b05                	li	s6,1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000144:	6a85                	lui	s5,0x1
    80000146:	6a09                	lui	s4,0x2
    acquire(&reflock);
    80000148:	854a                	mv	a0,s2
    8000014a:	00006097          	auipc	ra,0x6
    8000014e:	16e080e7          	jalr	366(ra) # 800062b8 <acquire>
    reference_counter[((uint64)p)/PGSIZE]=1; 
    80000152:	00c4d793          	srli	a5,s1,0xc
    80000156:	078a                	slli	a5,a5,0x2
    80000158:	97de                	add	a5,a5,s7
    8000015a:	0167a023          	sw	s6,0(a5)
    release(&reflock);
    8000015e:	854a                	mv	a0,s2
    80000160:	00006097          	auipc	ra,0x6
    80000164:	20c080e7          	jalr	524(ra) # 8000636c <release>
    kfree(p);
    80000168:	8526                	mv	a0,s1
    8000016a:	00000097          	auipc	ra,0x0
    8000016e:	eb2080e7          	jalr	-334(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000172:	87a6                	mv	a5,s1
    80000174:	94d6                	add	s1,s1,s5
    80000176:	97d2                	add	a5,a5,s4
    80000178:	fcf9f8e3          	bgeu	s3,a5,80000148 <freerange+0x42>
}
    8000017c:	60a6                	ld	ra,72(sp)
    8000017e:	6406                	ld	s0,64(sp)
    80000180:	74e2                	ld	s1,56(sp)
    80000182:	7942                	ld	s2,48(sp)
    80000184:	79a2                	ld	s3,40(sp)
    80000186:	7a02                	ld	s4,32(sp)
    80000188:	6ae2                	ld	s5,24(sp)
    8000018a:	6b42                	ld	s6,16(sp)
    8000018c:	6ba2                	ld	s7,8(sp)
    8000018e:	6161                	addi	sp,sp,80
    80000190:	8082                	ret

0000000080000192 <kinit>:
{
    80000192:	1141                	addi	sp,sp,-16
    80000194:	e406                	sd	ra,8(sp)
    80000196:	e022                	sd	s0,0(sp)
    80000198:	0800                	addi	s0,sp,16
  initlock(&reflock, "refcounter");
    8000019a:	00008597          	auipc	a1,0x8
    8000019e:	e7e58593          	addi	a1,a1,-386 # 80008018 <etext+0x18>
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <reflock>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	07e080e7          	jalr	126(ra) # 80006228 <initlock>
  initlock(&kmem.lock, "kmem");
    800001b2:	00008597          	auipc	a1,0x8
    800001b6:	e7658593          	addi	a1,a1,-394 # 80008028 <etext+0x28>
    800001ba:	00009517          	auipc	a0,0x9
    800001be:	e8e50513          	addi	a0,a0,-370 # 80009048 <kmem>
    800001c2:	00006097          	auipc	ra,0x6
    800001c6:	066080e7          	jalr	102(ra) # 80006228 <initlock>
  freerange(end, (void*)PHYSTOP);
    800001ca:	45c5                	li	a1,17
    800001cc:	05ee                	slli	a1,a1,0x1b
    800001ce:	00246517          	auipc	a0,0x246
    800001d2:	07250513          	addi	a0,a0,114 # 80246240 <end>
    800001d6:	00000097          	auipc	ra,0x0
    800001da:	f30080e7          	jalr	-208(ra) # 80000106 <freerange>
}
    800001de:	60a2                	ld	ra,8(sp)
    800001e0:	6402                	ld	s0,0(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001e6:	1101                	addi	sp,sp,-32
    800001e8:	ec06                	sd	ra,24(sp)
    800001ea:	e822                	sd	s0,16(sp)
    800001ec:	e426                	sd	s1,8(sp)
    800001ee:	e04a                	sd	s2,0(sp)
    800001f0:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001f2:	00009517          	auipc	a0,0x9
    800001f6:	e5650513          	addi	a0,a0,-426 # 80009048 <kmem>
    800001fa:	00006097          	auipc	ra,0x6
    800001fe:	0be080e7          	jalr	190(ra) # 800062b8 <acquire>
  r = kmem.freelist;
    80000202:	00009497          	auipc	s1,0x9
    80000206:	e5e4b483          	ld	s1,-418(s1) # 80009060 <kmem+0x18>
  if(r){
    8000020a:	c0b5                	beqz	s1,8000026e <kalloc+0x88>
    kmem.freelist = r->next;
    8000020c:	609c                	ld	a5,0(s1)
    8000020e:	00009917          	auipc	s2,0x9
    80000212:	e2290913          	addi	s2,s2,-478 # 80009030 <reflock>
    80000216:	02f93823          	sd	a5,48(s2)
  }
  release(&kmem.lock);
    8000021a:	00009517          	auipc	a0,0x9
    8000021e:	e2e50513          	addi	a0,a0,-466 # 80009048 <kmem>
    80000222:	00006097          	auipc	ra,0x6
    80000226:	14a080e7          	jalr	330(ra) # 8000636c <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000022a:	6605                	lui	a2,0x1
    8000022c:	4595                	li	a1,5
    8000022e:	8526                	mv	a0,s1
    80000230:	00000097          	auipc	ra,0x0
    80000234:	050080e7          	jalr	80(ra) # 80000280 <memset>

    // initialize the counter to 1
    acquire(&reflock);
    80000238:	854a                	mv	a0,s2
    8000023a:	00006097          	auipc	ra,0x6
    8000023e:	07e080e7          	jalr	126(ra) # 800062b8 <acquire>
    reference_counter[((uint64)r)/PGSIZE]=1;
    80000242:	00c4d713          	srli	a4,s1,0xc
    80000246:	070a                	slli	a4,a4,0x2
    80000248:	00009797          	auipc	a5,0x9
    8000024c:	e2078793          	addi	a5,a5,-480 # 80009068 <reference_counter>
    80000250:	97ba                	add	a5,a5,a4
    80000252:	4705                	li	a4,1
    80000254:	c398                	sw	a4,0(a5)
    release(&reflock);
    80000256:	854a                	mv	a0,s2
    80000258:	00006097          	auipc	ra,0x6
    8000025c:	114080e7          	jalr	276(ra) # 8000636c <release>

  }

  return (void*)r;
}
    80000260:	8526                	mv	a0,s1
    80000262:	60e2                	ld	ra,24(sp)
    80000264:	6442                	ld	s0,16(sp)
    80000266:	64a2                	ld	s1,8(sp)
    80000268:	6902                	ld	s2,0(sp)
    8000026a:	6105                	addi	sp,sp,32
    8000026c:	8082                	ret
  release(&kmem.lock);
    8000026e:	00009517          	auipc	a0,0x9
    80000272:	dda50513          	addi	a0,a0,-550 # 80009048 <kmem>
    80000276:	00006097          	auipc	ra,0x6
    8000027a:	0f6080e7          	jalr	246(ra) # 8000636c <release>
  if(r){
    8000027e:	b7cd                	j	80000260 <kalloc+0x7a>

0000000080000280 <memset>:
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
    80000286:	ca19                	beqz	a2,8000029c <memset+0x1c>
    80000288:	87aa                	mv	a5,a0
    8000028a:	1602                	slli	a2,a2,0x20
    8000028c:	9201                	srli	a2,a2,0x20
    8000028e:	00a60733          	add	a4,a2,a0
    80000292:	00b78023          	sb	a1,0(a5)
    80000296:	0785                	addi	a5,a5,1
    80000298:	fee79de3          	bne	a5,a4,80000292 <memset+0x12>
    8000029c:	6422                	ld	s0,8(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret

00000000800002a2 <memcmp>:
    800002a2:	1141                	addi	sp,sp,-16
    800002a4:	e422                	sd	s0,8(sp)
    800002a6:	0800                	addi	s0,sp,16
    800002a8:	ca05                	beqz	a2,800002d8 <memcmp+0x36>
    800002aa:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002ae:	1682                	slli	a3,a3,0x20
    800002b0:	9281                	srli	a3,a3,0x20
    800002b2:	0685                	addi	a3,a3,1
    800002b4:	96aa                	add	a3,a3,a0
    800002b6:	00054783          	lbu	a5,0(a0)
    800002ba:	0005c703          	lbu	a4,0(a1)
    800002be:	00e79863          	bne	a5,a4,800002ce <memcmp+0x2c>
    800002c2:	0505                	addi	a0,a0,1
    800002c4:	0585                	addi	a1,a1,1
    800002c6:	fed518e3          	bne	a0,a3,800002b6 <memcmp+0x14>
    800002ca:	4501                	li	a0,0
    800002cc:	a019                	j	800002d2 <memcmp+0x30>
    800002ce:	40e7853b          	subw	a0,a5,a4
    800002d2:	6422                	ld	s0,8(sp)
    800002d4:	0141                	addi	sp,sp,16
    800002d6:	8082                	ret
    800002d8:	4501                	li	a0,0
    800002da:	bfe5                	j	800002d2 <memcmp+0x30>

00000000800002dc <memmove>:
    800002dc:	1141                	addi	sp,sp,-16
    800002de:	e422                	sd	s0,8(sp)
    800002e0:	0800                	addi	s0,sp,16
    800002e2:	c205                	beqz	a2,80000302 <memmove+0x26>
    800002e4:	02a5e263          	bltu	a1,a0,80000308 <memmove+0x2c>
    800002e8:	1602                	slli	a2,a2,0x20
    800002ea:	9201                	srli	a2,a2,0x20
    800002ec:	00c587b3          	add	a5,a1,a2
    800002f0:	872a                	mv	a4,a0
    800002f2:	0585                	addi	a1,a1,1
    800002f4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    800002f6:	fff5c683          	lbu	a3,-1(a1)
    800002fa:	fed70fa3          	sb	a3,-1(a4)
    800002fe:	fef59ae3          	bne	a1,a5,800002f2 <memmove+0x16>
    80000302:	6422                	ld	s0,8(sp)
    80000304:	0141                	addi	sp,sp,16
    80000306:	8082                	ret
    80000308:	02061693          	slli	a3,a2,0x20
    8000030c:	9281                	srli	a3,a3,0x20
    8000030e:	00d58733          	add	a4,a1,a3
    80000312:	fce57be3          	bgeu	a0,a4,800002e8 <memmove+0xc>
    80000316:	96aa                	add	a3,a3,a0
    80000318:	fff6079b          	addiw	a5,a2,-1
    8000031c:	1782                	slli	a5,a5,0x20
    8000031e:	9381                	srli	a5,a5,0x20
    80000320:	fff7c793          	not	a5,a5
    80000324:	97ba                	add	a5,a5,a4
    80000326:	177d                	addi	a4,a4,-1
    80000328:	16fd                	addi	a3,a3,-1
    8000032a:	00074603          	lbu	a2,0(a4)
    8000032e:	00c68023          	sb	a2,0(a3)
    80000332:	fee79ae3          	bne	a5,a4,80000326 <memmove+0x4a>
    80000336:	b7f1                	j	80000302 <memmove+0x26>

0000000080000338 <memcpy>:
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e406                	sd	ra,8(sp)
    8000033c:	e022                	sd	s0,0(sp)
    8000033e:	0800                	addi	s0,sp,16
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f9c080e7          	jalr	-100(ra) # 800002dc <memmove>
    80000348:	60a2                	ld	ra,8(sp)
    8000034a:	6402                	ld	s0,0(sp)
    8000034c:	0141                	addi	sp,sp,16
    8000034e:	8082                	ret

0000000080000350 <strncmp>:
    80000350:	1141                	addi	sp,sp,-16
    80000352:	e422                	sd	s0,8(sp)
    80000354:	0800                	addi	s0,sp,16
    80000356:	ce11                	beqz	a2,80000372 <strncmp+0x22>
    80000358:	00054783          	lbu	a5,0(a0)
    8000035c:	cf89                	beqz	a5,80000376 <strncmp+0x26>
    8000035e:	0005c703          	lbu	a4,0(a1)
    80000362:	00f71a63          	bne	a4,a5,80000376 <strncmp+0x26>
    80000366:	367d                	addiw	a2,a2,-1
    80000368:	0505                	addi	a0,a0,1
    8000036a:	0585                	addi	a1,a1,1
    8000036c:	f675                	bnez	a2,80000358 <strncmp+0x8>
    8000036e:	4501                	li	a0,0
    80000370:	a809                	j	80000382 <strncmp+0x32>
    80000372:	4501                	li	a0,0
    80000374:	a039                	j	80000382 <strncmp+0x32>
    80000376:	ca09                	beqz	a2,80000388 <strncmp+0x38>
    80000378:	00054503          	lbu	a0,0(a0)
    8000037c:	0005c783          	lbu	a5,0(a1)
    80000380:	9d1d                	subw	a0,a0,a5
    80000382:	6422                	ld	s0,8(sp)
    80000384:	0141                	addi	sp,sp,16
    80000386:	8082                	ret
    80000388:	4501                	li	a0,0
    8000038a:	bfe5                	j	80000382 <strncmp+0x32>

000000008000038c <strncpy>:
    8000038c:	1141                	addi	sp,sp,-16
    8000038e:	e422                	sd	s0,8(sp)
    80000390:	0800                	addi	s0,sp,16
    80000392:	872a                	mv	a4,a0
    80000394:	8832                	mv	a6,a2
    80000396:	367d                	addiw	a2,a2,-1
    80000398:	01005963          	blez	a6,800003aa <strncpy+0x1e>
    8000039c:	0705                	addi	a4,a4,1
    8000039e:	0005c783          	lbu	a5,0(a1)
    800003a2:	fef70fa3          	sb	a5,-1(a4)
    800003a6:	0585                	addi	a1,a1,1
    800003a8:	f7f5                	bnez	a5,80000394 <strncpy+0x8>
    800003aa:	86ba                	mv	a3,a4
    800003ac:	00c05c63          	blez	a2,800003c4 <strncpy+0x38>
    800003b0:	0685                	addi	a3,a3,1
    800003b2:	fe068fa3          	sb	zero,-1(a3)
    800003b6:	40d707bb          	subw	a5,a4,a3
    800003ba:	37fd                	addiw	a5,a5,-1
    800003bc:	010787bb          	addw	a5,a5,a6
    800003c0:	fef048e3          	bgtz	a5,800003b0 <strncpy+0x24>
    800003c4:	6422                	ld	s0,8(sp)
    800003c6:	0141                	addi	sp,sp,16
    800003c8:	8082                	ret

00000000800003ca <safestrcpy>:
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e422                	sd	s0,8(sp)
    800003ce:	0800                	addi	s0,sp,16
    800003d0:	02c05363          	blez	a2,800003f6 <safestrcpy+0x2c>
    800003d4:	fff6069b          	addiw	a3,a2,-1
    800003d8:	1682                	slli	a3,a3,0x20
    800003da:	9281                	srli	a3,a3,0x20
    800003dc:	96ae                	add	a3,a3,a1
    800003de:	87aa                	mv	a5,a0
    800003e0:	00d58963          	beq	a1,a3,800003f2 <safestrcpy+0x28>
    800003e4:	0585                	addi	a1,a1,1
    800003e6:	0785                	addi	a5,a5,1
    800003e8:	fff5c703          	lbu	a4,-1(a1)
    800003ec:	fee78fa3          	sb	a4,-1(a5)
    800003f0:	fb65                	bnez	a4,800003e0 <safestrcpy+0x16>
    800003f2:	00078023          	sb	zero,0(a5)
    800003f6:	6422                	ld	s0,8(sp)
    800003f8:	0141                	addi	sp,sp,16
    800003fa:	8082                	ret

00000000800003fc <strlen>:
    800003fc:	1141                	addi	sp,sp,-16
    800003fe:	e422                	sd	s0,8(sp)
    80000400:	0800                	addi	s0,sp,16
    80000402:	00054783          	lbu	a5,0(a0)
    80000406:	cf91                	beqz	a5,80000422 <strlen+0x26>
    80000408:	0505                	addi	a0,a0,1
    8000040a:	87aa                	mv	a5,a0
    8000040c:	4685                	li	a3,1
    8000040e:	9e89                	subw	a3,a3,a0
    80000410:	00f6853b          	addw	a0,a3,a5
    80000414:	0785                	addi	a5,a5,1
    80000416:	fff7c703          	lbu	a4,-1(a5)
    8000041a:	fb7d                	bnez	a4,80000410 <strlen+0x14>
    8000041c:	6422                	ld	s0,8(sp)
    8000041e:	0141                	addi	sp,sp,16
    80000420:	8082                	ret
    80000422:	4501                	li	a0,0
    80000424:	bfe5                	j	8000041c <strlen+0x20>

0000000080000426 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000426:	1141                	addi	sp,sp,-16
    80000428:	e406                	sd	ra,8(sp)
    8000042a:	e022                	sd	s0,0(sp)
    8000042c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	bac080e7          	jalr	-1108(ra) # 80000fda <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000436:	00009717          	auipc	a4,0x9
    8000043a:	bca70713          	addi	a4,a4,-1078 # 80009000 <started>
  if(cpuid() == 0){
    8000043e:	c139                	beqz	a0,80000484 <main+0x5e>
    while(started == 0)
    80000440:	431c                	lw	a5,0(a4)
    80000442:	2781                	sext.w	a5,a5
    80000444:	dff5                	beqz	a5,80000440 <main+0x1a>
      ;
    __sync_synchronize();
    80000446:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000044a:	00001097          	auipc	ra,0x1
    8000044e:	b90080e7          	jalr	-1136(ra) # 80000fda <cpuid>
    80000452:	85aa                	mv	a1,a0
    80000454:	00008517          	auipc	a0,0x8
    80000458:	bf450513          	addi	a0,a0,-1036 # 80008048 <etext+0x48>
    8000045c:	00006097          	auipc	ra,0x6
    80000460:	96e080e7          	jalr	-1682(ra) # 80005dca <printf>
    kvminithart();    // turn on paging
    80000464:	00000097          	auipc	ra,0x0
    80000468:	0d8080e7          	jalr	216(ra) # 8000053c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	7f0080e7          	jalr	2032(ra) # 80001c5c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000474:	00005097          	auipc	ra,0x5
    80000478:	e3c080e7          	jalr	-452(ra) # 800052b0 <plicinithart>
  }

  scheduler();        
    8000047c:	00001097          	auipc	ra,0x1
    80000480:	09c080e7          	jalr	156(ra) # 80001518 <scheduler>
    consoleinit();
    80000484:	00006097          	auipc	ra,0x6
    80000488:	80c080e7          	jalr	-2036(ra) # 80005c90 <consoleinit>
    printfinit();
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	b1e080e7          	jalr	-1250(ra) # 80005faa <printfinit>
    printf("\n");
    80000494:	00008517          	auipc	a0,0x8
    80000498:	bc450513          	addi	a0,a0,-1084 # 80008058 <etext+0x58>
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	92e080e7          	jalr	-1746(ra) # 80005dca <printf>
    printf("xv6 kernel is booting\n");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	b8c50513          	addi	a0,a0,-1140 # 80008030 <etext+0x30>
    800004ac:	00006097          	auipc	ra,0x6
    800004b0:	91e080e7          	jalr	-1762(ra) # 80005dca <printf>
    printf("\n");
    800004b4:	00008517          	auipc	a0,0x8
    800004b8:	ba450513          	addi	a0,a0,-1116 # 80008058 <etext+0x58>
    800004bc:	00006097          	auipc	ra,0x6
    800004c0:	90e080e7          	jalr	-1778(ra) # 80005dca <printf>
    kinit();         // physical page allocator
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	cce080e7          	jalr	-818(ra) # 80000192 <kinit>
    kvminit();       // create kernel page table
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	322080e7          	jalr	802(ra) # 800007ee <kvminit>
    kvminithart();   // turn on paging
    800004d4:	00000097          	auipc	ra,0x0
    800004d8:	068080e7          	jalr	104(ra) # 8000053c <kvminithart>
    procinit();      // process table
    800004dc:	00001097          	auipc	ra,0x1
    800004e0:	a4e080e7          	jalr	-1458(ra) # 80000f2a <procinit>
    trapinit();      // trap vectors
    800004e4:	00001097          	auipc	ra,0x1
    800004e8:	750080e7          	jalr	1872(ra) # 80001c34 <trapinit>
    trapinithart();  // install kernel trap vector
    800004ec:	00001097          	auipc	ra,0x1
    800004f0:	770080e7          	jalr	1904(ra) # 80001c5c <trapinithart>
    plicinit();      // set up interrupt controller
    800004f4:	00005097          	auipc	ra,0x5
    800004f8:	da6080e7          	jalr	-602(ra) # 8000529a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004fc:	00005097          	auipc	ra,0x5
    80000500:	db4080e7          	jalr	-588(ra) # 800052b0 <plicinithart>
    binit();         // buffer cache
    80000504:	00002097          	auipc	ra,0x2
    80000508:	f78080e7          	jalr	-136(ra) # 8000247c <binit>
    iinit();         // inode table
    8000050c:	00002097          	auipc	ra,0x2
    80000510:	606080e7          	jalr	1542(ra) # 80002b12 <iinit>
    fileinit();      // file table
    80000514:	00003097          	auipc	ra,0x3
    80000518:	5b8080e7          	jalr	1464(ra) # 80003acc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000051c:	00005097          	auipc	ra,0x5
    80000520:	eb4080e7          	jalr	-332(ra) # 800053d0 <virtio_disk_init>
    userinit();      // first user process
    80000524:	00001097          	auipc	ra,0x1
    80000528:	dba080e7          	jalr	-582(ra) # 800012de <userinit>
    __sync_synchronize();
    8000052c:	0ff0000f          	fence
    started = 1;
    80000530:	4785                	li	a5,1
    80000532:	00009717          	auipc	a4,0x9
    80000536:	acf72723          	sw	a5,-1330(a4) # 80009000 <started>
    8000053a:	b789                	j	8000047c <main+0x56>

000000008000053c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000053c:	1141                	addi	sp,sp,-16
    8000053e:	e422                	sd	s0,8(sp)
    80000540:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000542:	00009797          	auipc	a5,0x9
    80000546:	ac67b783          	ld	a5,-1338(a5) # 80009008 <kernel_pagetable>
    8000054a:	83b1                	srli	a5,a5,0xc
    8000054c:	577d                	li	a4,-1
    8000054e:	177e                	slli	a4,a4,0x3f
    80000550:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000552:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000556:	12000073          	sfence.vma
  sfence_vma();
}
    8000055a:	6422                	ld	s0,8(sp)
    8000055c:	0141                	addi	sp,sp,16
    8000055e:	8082                	ret

0000000080000560 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000560:	7139                	addi	sp,sp,-64
    80000562:	fc06                	sd	ra,56(sp)
    80000564:	f822                	sd	s0,48(sp)
    80000566:	f426                	sd	s1,40(sp)
    80000568:	f04a                	sd	s2,32(sp)
    8000056a:	ec4e                	sd	s3,24(sp)
    8000056c:	e852                	sd	s4,16(sp)
    8000056e:	e456                	sd	s5,8(sp)
    80000570:	e05a                	sd	s6,0(sp)
    80000572:	0080                	addi	s0,sp,64
    80000574:	84aa                	mv	s1,a0
    80000576:	89ae                	mv	s3,a1
    80000578:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000057a:	57fd                	li	a5,-1
    8000057c:	83e9                	srli	a5,a5,0x1a
    8000057e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000580:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000582:	04b7f263          	bgeu	a5,a1,800005c6 <walk+0x66>
    panic("walk");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ada50513          	addi	a0,a0,-1318 # 80008060 <etext+0x60>
    8000058e:	00005097          	auipc	ra,0x5
    80000592:	7f2080e7          	jalr	2034(ra) # 80005d80 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000596:	060a8663          	beqz	s5,80000602 <walk+0xa2>
    8000059a:	00000097          	auipc	ra,0x0
    8000059e:	c4c080e7          	jalr	-948(ra) # 800001e6 <kalloc>
    800005a2:	84aa                	mv	s1,a0
    800005a4:	c529                	beqz	a0,800005ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005a6:	6605                	lui	a2,0x1
    800005a8:	4581                	li	a1,0
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	cd6080e7          	jalr	-810(ra) # 80000280 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005b2:	00c4d793          	srli	a5,s1,0xc
    800005b6:	07aa                	slli	a5,a5,0xa
    800005b8:	0017e793          	ori	a5,a5,1
    800005bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005c0:	3a5d                	addiw	s4,s4,-9 # 1ff7 <_entry-0x7fffe009>
    800005c2:	036a0063          	beq	s4,s6,800005e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005c6:	0149d933          	srl	s2,s3,s4
    800005ca:	1ff97913          	andi	s2,s2,511
    800005ce:	090e                	slli	s2,s2,0x3
    800005d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005d2:	00093483          	ld	s1,0(s2)
    800005d6:	0014f793          	andi	a5,s1,1
    800005da:	dfd5                	beqz	a5,80000596 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005dc:	80a9                	srli	s1,s1,0xa
    800005de:	04b2                	slli	s1,s1,0xc
    800005e0:	b7c5                	j	800005c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005e2:	00c9d513          	srli	a0,s3,0xc
    800005e6:	1ff57513          	andi	a0,a0,511
    800005ea:	050e                	slli	a0,a0,0x3
    800005ec:	9526                	add	a0,a0,s1
}
    800005ee:	70e2                	ld	ra,56(sp)
    800005f0:	7442                	ld	s0,48(sp)
    800005f2:	74a2                	ld	s1,40(sp)
    800005f4:	7902                	ld	s2,32(sp)
    800005f6:	69e2                	ld	s3,24(sp)
    800005f8:	6a42                	ld	s4,16(sp)
    800005fa:	6aa2                	ld	s5,8(sp)
    800005fc:	6b02                	ld	s6,0(sp)
    800005fe:	6121                	addi	sp,sp,64
    80000600:	8082                	ret
        return 0;
    80000602:	4501                	li	a0,0
    80000604:	b7ed                	j	800005ee <walk+0x8e>

0000000080000606 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000606:	57fd                	li	a5,-1
    80000608:	83e9                	srli	a5,a5,0x1a
    8000060a:	00b7f463          	bgeu	a5,a1,80000612 <walkaddr+0xc>
    return 0;
    8000060e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000610:	8082                	ret
{
    80000612:	1141                	addi	sp,sp,-16
    80000614:	e406                	sd	ra,8(sp)
    80000616:	e022                	sd	s0,0(sp)
    80000618:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000061a:	4601                	li	a2,0
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f44080e7          	jalr	-188(ra) # 80000560 <walk>
  if(pte == 0)
    80000624:	c105                	beqz	a0,80000644 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000626:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000628:	0117f693          	andi	a3,a5,17
    8000062c:	4745                	li	a4,17
    return 0;
    8000062e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000630:	00e68663          	beq	a3,a4,8000063c <walkaddr+0x36>
}
    80000634:	60a2                	ld	ra,8(sp)
    80000636:	6402                	ld	s0,0(sp)
    80000638:	0141                	addi	sp,sp,16
    8000063a:	8082                	ret
  pa = PTE2PA(*pte);
    8000063c:	83a9                	srli	a5,a5,0xa
    8000063e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000642:	bfcd                	j	80000634 <walkaddr+0x2e>
    return 0;
    80000644:	4501                	li	a0,0
    80000646:	b7fd                	j	80000634 <walkaddr+0x2e>

0000000080000648 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000648:	715d                	addi	sp,sp,-80
    8000064a:	e486                	sd	ra,72(sp)
    8000064c:	e0a2                	sd	s0,64(sp)
    8000064e:	fc26                	sd	s1,56(sp)
    80000650:	f84a                	sd	s2,48(sp)
    80000652:	f44e                	sd	s3,40(sp)
    80000654:	f052                	sd	s4,32(sp)
    80000656:	ec56                	sd	s5,24(sp)
    80000658:	e85a                	sd	s6,16(sp)
    8000065a:	e45e                	sd	s7,8(sp)
    8000065c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;


  if(size == 0)
    8000065e:	c639                	beqz	a2,800006ac <mappages+0x64>
    80000660:	8aaa                	mv	s5,a0
    80000662:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000664:	777d                	lui	a4,0xfffff
    80000666:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000066a:	fff58993          	addi	s3,a1,-1
    8000066e:	99b2                	add	s3,s3,a2
    80000670:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000674:	893e                	mv	s2,a5
    80000676:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000067a:	6b85                	lui	s7,0x1
    8000067c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000680:	4605                	li	a2,1
    80000682:	85ca                	mv	a1,s2
    80000684:	8556                	mv	a0,s5
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	eda080e7          	jalr	-294(ra) # 80000560 <walk>
    8000068e:	cd1d                	beqz	a0,800006cc <mappages+0x84>
    if(*pte & PTE_V)
    80000690:	611c                	ld	a5,0(a0)
    80000692:	8b85                	andi	a5,a5,1
    80000694:	e785                	bnez	a5,800006bc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000696:	80b1                	srli	s1,s1,0xc
    80000698:	04aa                	slli	s1,s1,0xa
    8000069a:	0164e4b3          	or	s1,s1,s6
    8000069e:	0014e493          	ori	s1,s1,1
    800006a2:	e104                	sd	s1,0(a0)
    if(a == last)
    800006a4:	05390063          	beq	s2,s3,800006e4 <mappages+0x9c>
    a += PGSIZE;
    800006a8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006aa:	bfc9                	j	8000067c <mappages+0x34>
    panic("mappages: size");
    800006ac:	00008517          	auipc	a0,0x8
    800006b0:	9bc50513          	addi	a0,a0,-1604 # 80008068 <etext+0x68>
    800006b4:	00005097          	auipc	ra,0x5
    800006b8:	6cc080e7          	jalr	1740(ra) # 80005d80 <panic>
      panic("mappages: remap");
    800006bc:	00008517          	auipc	a0,0x8
    800006c0:	9bc50513          	addi	a0,a0,-1604 # 80008078 <etext+0x78>
    800006c4:	00005097          	auipc	ra,0x5
    800006c8:	6bc080e7          	jalr	1724(ra) # 80005d80 <panic>
      return -1;
    800006cc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ce:	60a6                	ld	ra,72(sp)
    800006d0:	6406                	ld	s0,64(sp)
    800006d2:	74e2                	ld	s1,56(sp)
    800006d4:	7942                	ld	s2,48(sp)
    800006d6:	79a2                	ld	s3,40(sp)
    800006d8:	7a02                	ld	s4,32(sp)
    800006da:	6ae2                	ld	s5,24(sp)
    800006dc:	6b42                	ld	s6,16(sp)
    800006de:	6ba2                	ld	s7,8(sp)
    800006e0:	6161                	addi	sp,sp,80
    800006e2:	8082                	ret
  return 0;
    800006e4:	4501                	li	a0,0
    800006e6:	b7e5                	j	800006ce <mappages+0x86>

00000000800006e8 <kvmmap>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
    800006f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006f2:	86b2                	mv	a3,a2
    800006f4:	863e                	mv	a2,a5
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f52080e7          	jalr	-174(ra) # 80000648 <mappages>
    800006fe:	e509                	bnez	a0,80000708 <kvmmap+0x20>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret
    panic("kvmmap");
    80000708:	00008517          	auipc	a0,0x8
    8000070c:	98050513          	addi	a0,a0,-1664 # 80008088 <etext+0x88>
    80000710:	00005097          	auipc	ra,0x5
    80000714:	670080e7          	jalr	1648(ra) # 80005d80 <panic>

0000000080000718 <kvmmake>:
{
    80000718:	1101                	addi	sp,sp,-32
    8000071a:	ec06                	sd	ra,24(sp)
    8000071c:	e822                	sd	s0,16(sp)
    8000071e:	e426                	sd	s1,8(sp)
    80000720:	e04a                	sd	s2,0(sp)
    80000722:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000724:	00000097          	auipc	ra,0x0
    80000728:	ac2080e7          	jalr	-1342(ra) # 800001e6 <kalloc>
    8000072c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	00000097          	auipc	ra,0x0
    80000736:	b4e080e7          	jalr	-1202(ra) # 80000280 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000073a:	4719                	li	a4,6
    8000073c:	6685                	lui	a3,0x1
    8000073e:	10000637          	lui	a2,0x10000
    80000742:	100005b7          	lui	a1,0x10000
    80000746:	8526                	mv	a0,s1
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	fa0080e7          	jalr	-96(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000750:	4719                	li	a4,6
    80000752:	6685                	lui	a3,0x1
    80000754:	10001637          	lui	a2,0x10001
    80000758:	100015b7          	lui	a1,0x10001
    8000075c:	8526                	mv	a0,s1
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	f8a080e7          	jalr	-118(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000766:	4719                	li	a4,6
    80000768:	004006b7          	lui	a3,0x400
    8000076c:	0c000637          	lui	a2,0xc000
    80000770:	0c0005b7          	lui	a1,0xc000
    80000774:	8526                	mv	a0,s1
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	f72080e7          	jalr	-142(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000077e:	00008917          	auipc	s2,0x8
    80000782:	88290913          	addi	s2,s2,-1918 # 80008000 <etext>
    80000786:	4729                	li	a4,10
    80000788:	80008697          	auipc	a3,0x80008
    8000078c:	87868693          	addi	a3,a3,-1928 # 8000 <_entry-0x7fff8000>
    80000790:	4605                	li	a2,1
    80000792:	067e                	slli	a2,a2,0x1f
    80000794:	85b2                	mv	a1,a2
    80000796:	8526                	mv	a0,s1
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	f50080e7          	jalr	-176(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007a0:	4719                	li	a4,6
    800007a2:	46c5                	li	a3,17
    800007a4:	06ee                	slli	a3,a3,0x1b
    800007a6:	412686b3          	sub	a3,a3,s2
    800007aa:	864a                	mv	a2,s2
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	f38080e7          	jalr	-200(ra) # 800006e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007b8:	4729                	li	a4,10
    800007ba:	6685                	lui	a3,0x1
    800007bc:	00007617          	auipc	a2,0x7
    800007c0:	84460613          	addi	a2,a2,-1980 # 80007000 <_trampoline>
    800007c4:	040005b7          	lui	a1,0x4000
    800007c8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007ca:	05b2                	slli	a1,a1,0xc
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f1a080e7          	jalr	-230(ra) # 800006e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	6bc080e7          	jalr	1724(ra) # 80000e94 <proc_mapstacks>
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6902                	ld	s2,0(sp)
    800007ea:	6105                	addi	sp,sp,32
    800007ec:	8082                	ret

00000000800007ee <kvminit>:
{
    800007ee:	1141                	addi	sp,sp,-16
    800007f0:	e406                	sd	ra,8(sp)
    800007f2:	e022                	sd	s0,0(sp)
    800007f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	f22080e7          	jalr	-222(ra) # 80000718 <kvmmake>
    800007fe:	00009797          	auipc	a5,0x9
    80000802:	80a7b523          	sd	a0,-2038(a5) # 80009008 <kernel_pagetable>
}
    80000806:	60a2                	ld	ra,8(sp)
    80000808:	6402                	ld	s0,0(sp)
    8000080a:	0141                	addi	sp,sp,16
    8000080c:	8082                	ret

000000008000080e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000080e:	715d                	addi	sp,sp,-80
    80000810:	e486                	sd	ra,72(sp)
    80000812:	e0a2                	sd	s0,64(sp)
    80000814:	fc26                	sd	s1,56(sp)
    80000816:	f84a                	sd	s2,48(sp)
    80000818:	f44e                	sd	s3,40(sp)
    8000081a:	f052                	sd	s4,32(sp)
    8000081c:	ec56                	sd	s5,24(sp)
    8000081e:	e85a                	sd	s6,16(sp)
    80000820:	e45e                	sd	s7,8(sp)
    80000822:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000824:	03459793          	slli	a5,a1,0x34
    80000828:	e795                	bnez	a5,80000854 <uvmunmap+0x46>
    8000082a:	8a2a                	mv	s4,a0
    8000082c:	892e                	mv	s2,a1
    8000082e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000830:	0632                	slli	a2,a2,0xc
    80000832:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000836:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000838:	6b05                	lui	s6,0x1
    8000083a:	0735e263          	bltu	a1,s3,8000089e <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000083e:	60a6                	ld	ra,72(sp)
    80000840:	6406                	ld	s0,64(sp)
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	7a02                	ld	s4,32(sp)
    8000084a:	6ae2                	ld	s5,24(sp)
    8000084c:	6b42                	ld	s6,16(sp)
    8000084e:	6ba2                	ld	s7,8(sp)
    80000850:	6161                	addi	sp,sp,80
    80000852:	8082                	ret
    panic("uvmunmap: not aligned");
    80000854:	00008517          	auipc	a0,0x8
    80000858:	83c50513          	addi	a0,a0,-1988 # 80008090 <etext+0x90>
    8000085c:	00005097          	auipc	ra,0x5
    80000860:	524080e7          	jalr	1316(ra) # 80005d80 <panic>
      panic("uvmunmap: walk");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	84450513          	addi	a0,a0,-1980 # 800080a8 <etext+0xa8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	514080e7          	jalr	1300(ra) # 80005d80 <panic>
      panic("uvmunmap: not mapped");
    80000874:	00008517          	auipc	a0,0x8
    80000878:	84450513          	addi	a0,a0,-1980 # 800080b8 <etext+0xb8>
    8000087c:	00005097          	auipc	ra,0x5
    80000880:	504080e7          	jalr	1284(ra) # 80005d80 <panic>
      panic("uvmunmap: not a leaf");
    80000884:	00008517          	auipc	a0,0x8
    80000888:	84c50513          	addi	a0,a0,-1972 # 800080d0 <etext+0xd0>
    8000088c:	00005097          	auipc	ra,0x5
    80000890:	4f4080e7          	jalr	1268(ra) # 80005d80 <panic>
    *pte = 0;
    80000894:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000898:	995a                	add	s2,s2,s6
    8000089a:	fb3972e3          	bgeu	s2,s3,8000083e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000089e:	4601                	li	a2,0
    800008a0:	85ca                	mv	a1,s2
    800008a2:	8552                	mv	a0,s4
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	cbc080e7          	jalr	-836(ra) # 80000560 <walk>
    800008ac:	84aa                	mv	s1,a0
    800008ae:	d95d                	beqz	a0,80000864 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008b0:	6108                	ld	a0,0(a0)
    800008b2:	00157793          	andi	a5,a0,1
    800008b6:	dfdd                	beqz	a5,80000874 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008b8:	3ff57793          	andi	a5,a0,1023
    800008bc:	fd7784e3          	beq	a5,s7,80000884 <uvmunmap+0x76>
    if(do_free){
    800008c0:	fc0a8ae3          	beqz	s5,80000894 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008c4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008c6:	0532                	slli	a0,a0,0xc
    800008c8:	fffff097          	auipc	ra,0xfffff
    800008cc:	754080e7          	jalr	1876(ra) # 8000001c <kfree>
    800008d0:	b7d1                	j	80000894 <uvmunmap+0x86>

00000000800008d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008d2:	1101                	addi	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	90a080e7          	jalr	-1782(ra) # 800001e6 <kalloc>
    800008e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008e6:	c519                	beqz	a0,800008f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	994080e7          	jalr	-1644(ra) # 80000280 <memset>
  return pagetable;
}
    800008f4:	8526                	mv	a0,s1
    800008f6:	60e2                	ld	ra,24(sp)
    800008f8:	6442                	ld	s0,16(sp)
    800008fa:	64a2                	ld	s1,8(sp)
    800008fc:	6105                	addi	sp,sp,32
    800008fe:	8082                	ret

0000000080000900 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000900:	7179                	addi	sp,sp,-48
    80000902:	f406                	sd	ra,40(sp)
    80000904:	f022                	sd	s0,32(sp)
    80000906:	ec26                	sd	s1,24(sp)
    80000908:	e84a                	sd	s2,16(sp)
    8000090a:	e44e                	sd	s3,8(sp)
    8000090c:	e052                	sd	s4,0(sp)
    8000090e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000910:	6785                	lui	a5,0x1
    80000912:	04f67863          	bgeu	a2,a5,80000962 <uvminit+0x62>
    80000916:	8a2a                	mv	s4,a0
    80000918:	89ae                	mv	s3,a1
    8000091a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	8ca080e7          	jalr	-1846(ra) # 800001e6 <kalloc>
    80000924:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000926:	6605                	lui	a2,0x1
    80000928:	4581                	li	a1,0
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	956080e7          	jalr	-1706(ra) # 80000280 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000932:	4779                	li	a4,30
    80000934:	86ca                	mv	a3,s2
    80000936:	6605                	lui	a2,0x1
    80000938:	4581                	li	a1,0
    8000093a:	8552                	mv	a0,s4
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	d0c080e7          	jalr	-756(ra) # 80000648 <mappages>
  memmove(mem, src, sz);
    80000944:	8626                	mv	a2,s1
    80000946:	85ce                	mv	a1,s3
    80000948:	854a                	mv	a0,s2
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	992080e7          	jalr	-1646(ra) # 800002dc <memmove>
}
    80000952:	70a2                	ld	ra,40(sp)
    80000954:	7402                	ld	s0,32(sp)
    80000956:	64e2                	ld	s1,24(sp)
    80000958:	6942                	ld	s2,16(sp)
    8000095a:	69a2                	ld	s3,8(sp)
    8000095c:	6a02                	ld	s4,0(sp)
    8000095e:	6145                	addi	sp,sp,48
    80000960:	8082                	ret
    panic("inituvm: more than a page");
    80000962:	00007517          	auipc	a0,0x7
    80000966:	78650513          	addi	a0,a0,1926 # 800080e8 <etext+0xe8>
    8000096a:	00005097          	auipc	ra,0x5
    8000096e:	416080e7          	jalr	1046(ra) # 80005d80 <panic>

0000000080000972 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000972:	1101                	addi	sp,sp,-32
    80000974:	ec06                	sd	ra,24(sp)
    80000976:	e822                	sd	s0,16(sp)
    80000978:	e426                	sd	s1,8(sp)
    8000097a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000097c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000097e:	00b67d63          	bgeu	a2,a1,80000998 <uvmdealloc+0x26>
    80000982:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000984:	6785                	lui	a5,0x1
    80000986:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000988:	00f60733          	add	a4,a2,a5
    8000098c:	76fd                	lui	a3,0xfffff
    8000098e:	8f75                	and	a4,a4,a3
    80000990:	97ae                	add	a5,a5,a1
    80000992:	8ff5                	and	a5,a5,a3
    80000994:	00f76863          	bltu	a4,a5,800009a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000998:	8526                	mv	a0,s1
    8000099a:	60e2                	ld	ra,24(sp)
    8000099c:	6442                	ld	s0,16(sp)
    8000099e:	64a2                	ld	s1,8(sp)
    800009a0:	6105                	addi	sp,sp,32
    800009a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009a4:	8f99                	sub	a5,a5,a4
    800009a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009a8:	4685                	li	a3,1
    800009aa:	0007861b          	sext.w	a2,a5
    800009ae:	85ba                	mv	a1,a4
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	e5e080e7          	jalr	-418(ra) # 8000080e <uvmunmap>
    800009b8:	b7c5                	j	80000998 <uvmdealloc+0x26>

00000000800009ba <uvmalloc>:
  if(newsz < oldsz)
    800009ba:	0ab66163          	bltu	a2,a1,80000a5c <uvmalloc+0xa2>
{
    800009be:	7139                	addi	sp,sp,-64
    800009c0:	fc06                	sd	ra,56(sp)
    800009c2:	f822                	sd	s0,48(sp)
    800009c4:	f426                	sd	s1,40(sp)
    800009c6:	f04a                	sd	s2,32(sp)
    800009c8:	ec4e                	sd	s3,24(sp)
    800009ca:	e852                	sd	s4,16(sp)
    800009cc:	e456                	sd	s5,8(sp)
    800009ce:	0080                	addi	s0,sp,64
    800009d0:	8aaa                	mv	s5,a0
    800009d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009d4:	6785                	lui	a5,0x1
    800009d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009d8:	95be                	add	a1,a1,a5
    800009da:	77fd                	lui	a5,0xfffff
    800009dc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009e0:	08c9f063          	bgeu	s3,a2,80000a60 <uvmalloc+0xa6>
    800009e4:	894e                	mv	s2,s3
    mem = kalloc();
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	800080e7          	jalr	-2048(ra) # 800001e6 <kalloc>
    800009ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800009f0:	c51d                	beqz	a0,80000a1e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009f2:	6605                	lui	a2,0x1
    800009f4:	4581                	li	a1,0
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	88a080e7          	jalr	-1910(ra) # 80000280 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009fe:	4779                	li	a4,30
    80000a00:	86a6                	mv	a3,s1
    80000a02:	6605                	lui	a2,0x1
    80000a04:	85ca                	mv	a1,s2
    80000a06:	8556                	mv	a0,s5
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	c40080e7          	jalr	-960(ra) # 80000648 <mappages>
    80000a10:	e905                	bnez	a0,80000a40 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a12:	6785                	lui	a5,0x1
    80000a14:	993e                	add	s2,s2,a5
    80000a16:	fd4968e3          	bltu	s2,s4,800009e6 <uvmalloc+0x2c>
  return newsz;
    80000a1a:	8552                	mv	a0,s4
    80000a1c:	a809                	j	80000a2e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a1e:	864e                	mv	a2,s3
    80000a20:	85ca                	mv	a1,s2
    80000a22:	8556                	mv	a0,s5
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	f4e080e7          	jalr	-178(ra) # 80000972 <uvmdealloc>
      return 0;
    80000a2c:	4501                	li	a0,0
}
    80000a2e:	70e2                	ld	ra,56(sp)
    80000a30:	7442                	ld	s0,48(sp)
    80000a32:	74a2                	ld	s1,40(sp)
    80000a34:	7902                	ld	s2,32(sp)
    80000a36:	69e2                	ld	s3,24(sp)
    80000a38:	6a42                	ld	s4,16(sp)
    80000a3a:	6aa2                	ld	s5,8(sp)
    80000a3c:	6121                	addi	sp,sp,64
    80000a3e:	8082                	ret
      kfree(mem);
    80000a40:	8526                	mv	a0,s1
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	5da080e7          	jalr	1498(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a4a:	864e                	mv	a2,s3
    80000a4c:	85ca                	mv	a1,s2
    80000a4e:	8556                	mv	a0,s5
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	f22080e7          	jalr	-222(ra) # 80000972 <uvmdealloc>
      return 0;
    80000a58:	4501                	li	a0,0
    80000a5a:	bfd1                	j	80000a2e <uvmalloc+0x74>
    return oldsz;
    80000a5c:	852e                	mv	a0,a1
}
    80000a5e:	8082                	ret
  return newsz;
    80000a60:	8532                	mv	a0,a2
    80000a62:	b7f1                	j	80000a2e <uvmalloc+0x74>

0000000080000a64 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a64:	7179                	addi	sp,sp,-48
    80000a66:	f406                	sd	ra,40(sp)
    80000a68:	f022                	sd	s0,32(sp)
    80000a6a:	ec26                	sd	s1,24(sp)
    80000a6c:	e84a                	sd	s2,16(sp)
    80000a6e:	e44e                	sd	s3,8(sp)
    80000a70:	e052                	sd	s4,0(sp)
    80000a72:	1800                	addi	s0,sp,48
    80000a74:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a76:	84aa                	mv	s1,a0
    80000a78:	6905                	lui	s2,0x1
    80000a7a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a7c:	4985                	li	s3,1
    80000a7e:	a829                	j	80000a98 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a80:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a82:	00c79513          	slli	a0,a5,0xc
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	fde080e7          	jalr	-34(ra) # 80000a64 <freewalk>
      pagetable[i] = 0;
    80000a8e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a92:	04a1                	addi	s1,s1,8
    80000a94:	03248163          	beq	s1,s2,80000ab6 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a98:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a9a:	00f7f713          	andi	a4,a5,15
    80000a9e:	ff3701e3          	beq	a4,s3,80000a80 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000aa2:	8b85                	andi	a5,a5,1
    80000aa4:	d7fd                	beqz	a5,80000a92 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000aa6:	00007517          	auipc	a0,0x7
    80000aaa:	66250513          	addi	a0,a0,1634 # 80008108 <etext+0x108>
    80000aae:	00005097          	auipc	ra,0x5
    80000ab2:	2d2080e7          	jalr	722(ra) # 80005d80 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ab6:	8552                	mv	a0,s4
    80000ab8:	fffff097          	auipc	ra,0xfffff
    80000abc:	564080e7          	jalr	1380(ra) # 8000001c <kfree>
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6942                	ld	s2,16(sp)
    80000ac8:	69a2                	ld	s3,8(sp)
    80000aca:	6a02                	ld	s4,0(sp)
    80000acc:	6145                	addi	sp,sp,48
    80000ace:	8082                	ret

0000000080000ad0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ad0:	1101                	addi	sp,sp,-32
    80000ad2:	ec06                	sd	ra,24(sp)
    80000ad4:	e822                	sd	s0,16(sp)
    80000ad6:	e426                	sd	s1,8(sp)
    80000ad8:	1000                	addi	s0,sp,32
    80000ada:	84aa                	mv	s1,a0
  if(sz > 0)
    80000adc:	e999                	bnez	a1,80000af2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ade:	8526                	mv	a0,s1
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	f84080e7          	jalr	-124(ra) # 80000a64 <freewalk>
}
    80000ae8:	60e2                	ld	ra,24(sp)
    80000aea:	6442                	ld	s0,16(sp)
    80000aec:	64a2                	ld	s1,8(sp)
    80000aee:	6105                	addi	sp,sp,32
    80000af0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000af2:	6785                	lui	a5,0x1
    80000af4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000af6:	95be                	add	a1,a1,a5
    80000af8:	4685                	li	a3,1
    80000afa:	00c5d613          	srli	a2,a1,0xc
    80000afe:	4581                	li	a1,0
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	d0e080e7          	jalr	-754(ra) # 8000080e <uvmunmap>
    80000b08:	bfd9                	j	80000ade <uvmfree+0xe>

0000000080000b0a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  

  for(i = 0; i < sz; i += PGSIZE){
    80000b0a:	c66d                	beqz	a2,80000bf4 <uvmcopy+0xea>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8baa                	mv	s7,a0
    80000b26:	8b2e                	mv	s6,a1
    80000b28:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b2a:	4981                	li	s3,0
    
    
    pa = PTE2PA(*pte);

   
    acquire(&reflock);
    80000b2c:	00008a17          	auipc	s4,0x8
    80000b30:	504a0a13          	addi	s4,s4,1284 # 80009030 <reflock>
    reference_counter[pa/PGSIZE]+=1;
    80000b34:	00008c17          	auipc	s8,0x8
    80000b38:	534c0c13          	addi	s8,s8,1332 # 80009068 <reference_counter>
    if((pte = walk(old, i, 0)) == 0)
    80000b3c:	4601                	li	a2,0
    80000b3e:	85ce                	mv	a1,s3
    80000b40:	855e                	mv	a0,s7
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	a1e080e7          	jalr	-1506(ra) # 80000560 <walk>
    80000b4a:	892a                	mv	s2,a0
    80000b4c:	cd31                	beqz	a0,80000ba8 <uvmcopy+0x9e>
    if((*pte & PTE_V) == 0)
    80000b4e:	611c                	ld	a5,0(a0)
    80000b50:	0017f713          	andi	a4,a5,1
    80000b54:	c335                	beqz	a4,80000bb8 <uvmcopy+0xae>
    *pte &= ~PTE_W;
    80000b56:	9bed                	andi	a5,a5,-5
    *pte |= PTE_COW;
    80000b58:	1007e793          	ori	a5,a5,256
    80000b5c:	e11c                	sd	a5,0(a0)
    pa = PTE2PA(*pte);
    80000b5e:	83a9                	srli	a5,a5,0xa
    80000b60:	00c79493          	slli	s1,a5,0xc
    acquire(&reflock);
    80000b64:	8552                	mv	a0,s4
    80000b66:	00005097          	auipc	ra,0x5
    80000b6a:	752080e7          	jalr	1874(ra) # 800062b8 <acquire>
    reference_counter[pa/PGSIZE]+=1;
    80000b6e:	00a4d793          	srli	a5,s1,0xa
    80000b72:	97e2                	add	a5,a5,s8
    80000b74:	4398                	lw	a4,0(a5)
    80000b76:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    80000b78:	c398                	sw	a4,0(a5)
    release(&reflock);
    80000b7a:	8552                	mv	a0,s4
    80000b7c:	00005097          	auipc	ra,0x5
    80000b80:	7f0080e7          	jalr	2032(ra) # 8000636c <release>
    
    flags = PTE_FLAGS(*pte);
    80000b84:	00093703          	ld	a4,0(s2) # 1000 <_entry-0x7ffff000>
    
   
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000b88:	3ff77713          	andi	a4,a4,1023
    80000b8c:	86a6                	mv	a3,s1
    80000b8e:	6605                	lui	a2,0x1
    80000b90:	85ce                	mv	a1,s3
    80000b92:	855a                	mv	a0,s6
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	ab4080e7          	jalr	-1356(ra) # 80000648 <mappages>
    80000b9c:	e515                	bnez	a0,80000bc8 <uvmcopy+0xbe>
  for(i = 0; i < sz; i += PGSIZE){
    80000b9e:	6785                	lui	a5,0x1
    80000ba0:	99be                	add	s3,s3,a5
    80000ba2:	f959ede3          	bltu	s3,s5,80000b3c <uvmcopy+0x32>
    80000ba6:	a81d                	j	80000bdc <uvmcopy+0xd2>
      panic("uvmcopy: pte should exist");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	57050513          	addi	a0,a0,1392 # 80008118 <etext+0x118>
    80000bb0:	00005097          	auipc	ra,0x5
    80000bb4:	1d0080e7          	jalr	464(ra) # 80005d80 <panic>
      panic("uvmcopy: page not present");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	58050513          	addi	a0,a0,1408 # 80008138 <etext+0x138>
    80000bc0:	00005097          	auipc	ra,0x5
    80000bc4:	1c0080e7          	jalr	448(ra) # 80005d80 <panic>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bc8:	4685                	li	a3,1
    80000bca:	00c9d613          	srli	a2,s3,0xc
    80000bce:	4581                	li	a1,0
    80000bd0:	855a                	mv	a0,s6
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	c3c080e7          	jalr	-964(ra) # 8000080e <uvmunmap>
  return -1;
    80000bda:	557d                	li	a0,-1
}
    80000bdc:	60a6                	ld	ra,72(sp)
    80000bde:	6406                	ld	s0,64(sp)
    80000be0:	74e2                	ld	s1,56(sp)
    80000be2:	7942                	ld	s2,48(sp)
    80000be4:	79a2                	ld	s3,40(sp)
    80000be6:	7a02                	ld	s4,32(sp)
    80000be8:	6ae2                	ld	s5,24(sp)
    80000bea:	6b42                	ld	s6,16(sp)
    80000bec:	6ba2                	ld	s7,8(sp)
    80000bee:	6c02                	ld	s8,0(sp)
    80000bf0:	6161                	addi	sp,sp,80
    80000bf2:	8082                	ret
  return 0;
    80000bf4:	4501                	li	a0,0
}
    80000bf6:	8082                	ret

0000000080000bf8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bf8:	1141                	addi	sp,sp,-16
    80000bfa:	e406                	sd	ra,8(sp)
    80000bfc:	e022                	sd	s0,0(sp)
    80000bfe:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c00:	4601                	li	a2,0
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	95e080e7          	jalr	-1698(ra) # 80000560 <walk>
  if(pte == 0)
    80000c0a:	c901                	beqz	a0,80000c1a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c0c:	611c                	ld	a5,0(a0)
    80000c0e:	9bbd                	andi	a5,a5,-17
    80000c10:	e11c                	sd	a5,0(a0)
}
    80000c12:	60a2                	ld	ra,8(sp)
    80000c14:	6402                	ld	s0,0(sp)
    80000c16:	0141                	addi	sp,sp,16
    80000c18:	8082                	ret
    panic("uvmclear");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	53e50513          	addi	a0,a0,1342 # 80008158 <etext+0x158>
    80000c22:	00005097          	auipc	ra,0x5
    80000c26:	15e080e7          	jalr	350(ra) # 80005d80 <panic>

0000000080000c2a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c2a:	cee5                	beqz	a3,80000d22 <copyout+0xf8>
{
    80000c2c:	7159                	addi	sp,sp,-112
    80000c2e:	f486                	sd	ra,104(sp)
    80000c30:	f0a2                	sd	s0,96(sp)
    80000c32:	eca6                	sd	s1,88(sp)
    80000c34:	e8ca                	sd	s2,80(sp)
    80000c36:	e4ce                	sd	s3,72(sp)
    80000c38:	e0d2                	sd	s4,64(sp)
    80000c3a:	fc56                	sd	s5,56(sp)
    80000c3c:	f85a                	sd	s6,48(sp)
    80000c3e:	f45e                	sd	s7,40(sp)
    80000c40:	f062                	sd	s8,32(sp)
    80000c42:	ec66                	sd	s9,24(sp)
    80000c44:	e86a                	sd	s10,16(sp)
    80000c46:	e46e                	sd	s11,8(sp)
    80000c48:	1880                	addi	s0,sp,112
    80000c4a:	8c2a                	mv	s8,a0
    80000c4c:	8aae                	mv	s5,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000c52:	74fd                	lui	s1,0xfffff
    80000c54:	8ced                	and	s1,s1,a1
    

    if (va0>=MAXVA){
    80000c56:	57fd                	li	a5,-1
    80000c58:	83e9                	srli	a5,a5,0x1a
    80000c5a:	0c97e663          	bltu	a5,s1,80000d26 <copyout+0xfc>
    }
    
    pte_t *my_pte = walk(pagetable, va0, 0);

    
    if (my_pte==0||(*my_pte&PTE_U)==0||(*my_pte&PTE_V)==0){
    80000c5e:	4d45                	li	s10,17
    if (va0>=MAXVA){
    80000c60:	57fd                	li	a5,-1
    80000c62:	01a7dd93          	srli	s11,a5,0x1a
    80000c66:	a89d                	j	80000cdc <copyout+0xb2>
    // if it's a COW page
    if (*my_pte&PTE_COW){
      
      uint flags;
      char *mem;
      uint64 pa = PTE2PA(*my_pte);
    80000c68:	00a95c93          	srli	s9,s2,0xa
    80000c6c:	0cb2                	slli	s9,s9,0xc

      flags = PTE_FLAGS(*my_pte);
      flags |= PTE_W; 
      flags &= ~PTE_COW; 
    80000c6e:	2ff97913          	andi	s2,s2,767
    80000c72:	00496913          	ori	s2,s2,4
      
      if((mem = kalloc()) == 0){ 
    80000c76:	fffff097          	auipc	ra,0xfffff
    80000c7a:	570080e7          	jalr	1392(ra) # 800001e6 <kalloc>
    80000c7e:	8b2a                	mv	s6,a0
    80000c80:	c50d                	beqz	a0,80000caa <copyout+0x80>
     
          exit(-1);
      }

      memmove(mem, (char*)pa, PGSIZE);
    80000c82:	6605                	lui	a2,0x1
    80000c84:	85e6                	mv	a1,s9
    80000c86:	855a                	mv	a0,s6
    80000c88:	fffff097          	auipc	ra,0xfffff
    80000c8c:	654080e7          	jalr	1620(ra) # 800002dc <memmove>
      
      
      *my_pte = PA2PTE(mem) | flags;
    80000c90:	00cb5b13          	srli	s6,s6,0xc
    80000c94:	0b2a                	slli	s6,s6,0xa
    80000c96:	01696933          	or	s2,s2,s6
    80000c9a:	0129b023          	sd	s2,0(s3)

      kfree((char*)pa); 
    80000c9e:	8566                	mv	a0,s9
    80000ca0:	fffff097          	auipc	ra,0xfffff
    80000ca4:	37c080e7          	jalr	892(ra) # 8000001c <kfree>
    80000ca8:	a8a1                	j	80000d00 <copyout+0xd6>
          exit(-1);
    80000caa:	557d                	li	a0,-1
    80000cac:	00001097          	auipc	ra,0x1
    80000cb0:	c7a080e7          	jalr	-902(ra) # 80001926 <exit>
    80000cb4:	b7f9                	j	80000c82 <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cb6:	409a84b3          	sub	s1,s5,s1
    80000cba:	0009861b          	sext.w	a2,s3
    80000cbe:	85de                	mv	a1,s7
    80000cc0:	9526                	add	a0,a0,s1
    80000cc2:	fffff097          	auipc	ra,0xfffff
    80000cc6:	61a080e7          	jalr	1562(ra) # 800002dc <memmove>

    len -= n;
    80000cca:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000cce:	9bce                	add	s7,s7,s3
  while(len > 0){
    80000cd0:	040a0763          	beqz	s4,80000d1e <copyout+0xf4>
    if (va0>=MAXVA){
    80000cd4:	052deb63          	bltu	s11,s2,80000d2a <copyout+0x100>
    va0 = PGROUNDDOWN(dstva);
    80000cd8:	84ca                	mv	s1,s2
    dstva = va0 + PGSIZE;
    80000cda:	8aca                	mv	s5,s2
    pte_t *my_pte = walk(pagetable, va0, 0);
    80000cdc:	4601                	li	a2,0
    80000cde:	85a6                	mv	a1,s1
    80000ce0:	8562                	mv	a0,s8
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	87e080e7          	jalr	-1922(ra) # 80000560 <walk>
    80000cea:	89aa                	mv	s3,a0
    if (my_pte==0||(*my_pte&PTE_U)==0||(*my_pte&PTE_V)==0){
    80000cec:	c129                	beqz	a0,80000d2e <copyout+0x104>
    80000cee:	00053903          	ld	s2,0(a0)
    80000cf2:	01197793          	andi	a5,s2,17
    80000cf6:	05a79c63          	bne	a5,s10,80000d4e <copyout+0x124>
    if (*my_pte&PTE_COW){
    80000cfa:	10097793          	andi	a5,s2,256
    80000cfe:	f7ad                	bnez	a5,80000c68 <copyout+0x3e>
    pa0 = walkaddr(pagetable, va0);
    80000d00:	85a6                	mv	a1,s1
    80000d02:	8562                	mv	a0,s8
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	902080e7          	jalr	-1790(ra) # 80000606 <walkaddr>
    if(pa0 == 0)
    80000d0c:	c139                	beqz	a0,80000d52 <copyout+0x128>
    n = PGSIZE - (dstva - va0);
    80000d0e:	6905                	lui	s2,0x1
    80000d10:	9926                	add	s2,s2,s1
    80000d12:	415909b3          	sub	s3,s2,s5
    80000d16:	fb3a70e3          	bgeu	s4,s3,80000cb6 <copyout+0x8c>
    80000d1a:	89d2                	mv	s3,s4
    80000d1c:	bf69                	j	80000cb6 <copyout+0x8c>
  }
  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a801                	j	80000d30 <copyout+0x106>
    80000d22:	4501                	li	a0,0
}
    80000d24:	8082                	ret
      return -1;
    80000d26:	557d                	li	a0,-1
    80000d28:	a021                	j	80000d30 <copyout+0x106>
    80000d2a:	557d                	li	a0,-1
    80000d2c:	a011                	j	80000d30 <copyout+0x106>
      return -1;
    80000d2e:	557d                	li	a0,-1
}
    80000d30:	70a6                	ld	ra,104(sp)
    80000d32:	7406                	ld	s0,96(sp)
    80000d34:	64e6                	ld	s1,88(sp)
    80000d36:	6946                	ld	s2,80(sp)
    80000d38:	69a6                	ld	s3,72(sp)
    80000d3a:	6a06                	ld	s4,64(sp)
    80000d3c:	7ae2                	ld	s5,56(sp)
    80000d3e:	7b42                	ld	s6,48(sp)
    80000d40:	7ba2                	ld	s7,40(sp)
    80000d42:	7c02                	ld	s8,32(sp)
    80000d44:	6ce2                	ld	s9,24(sp)
    80000d46:	6d42                	ld	s10,16(sp)
    80000d48:	6da2                	ld	s11,8(sp)
    80000d4a:	6165                	addi	sp,sp,112
    80000d4c:	8082                	ret
      return -1;
    80000d4e:	557d                	li	a0,-1
    80000d50:	b7c5                	j	80000d30 <copyout+0x106>
      return -1;
    80000d52:	557d                	li	a0,-1
    80000d54:	bff1                	j	80000d30 <copyout+0x106>

0000000080000d56 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d56:	caa5                	beqz	a3,80000dc6 <copyin+0x70>
{
    80000d58:	715d                	addi	sp,sp,-80
    80000d5a:	e486                	sd	ra,72(sp)
    80000d5c:	e0a2                	sd	s0,64(sp)
    80000d5e:	fc26                	sd	s1,56(sp)
    80000d60:	f84a                	sd	s2,48(sp)
    80000d62:	f44e                	sd	s3,40(sp)
    80000d64:	f052                	sd	s4,32(sp)
    80000d66:	ec56                	sd	s5,24(sp)
    80000d68:	e85a                	sd	s6,16(sp)
    80000d6a:	e45e                	sd	s7,8(sp)
    80000d6c:	e062                	sd	s8,0(sp)
    80000d6e:	0880                	addi	s0,sp,80
    80000d70:	8b2a                	mv	s6,a0
    80000d72:	8a2e                	mv	s4,a1
    80000d74:	8c32                	mv	s8,a2
    80000d76:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d78:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d7a:	6a85                	lui	s5,0x1
    80000d7c:	a01d                	j	80000da2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d7e:	018505b3          	add	a1,a0,s8
    80000d82:	0004861b          	sext.w	a2,s1
    80000d86:	412585b3          	sub	a1,a1,s2
    80000d8a:	8552                	mv	a0,s4
    80000d8c:	fffff097          	auipc	ra,0xfffff
    80000d90:	550080e7          	jalr	1360(ra) # 800002dc <memmove>

    len -= n;
    80000d94:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d98:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d9a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d9e:	02098263          	beqz	s3,80000dc2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000da2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000da6:	85ca                	mv	a1,s2
    80000da8:	855a                	mv	a0,s6
    80000daa:	00000097          	auipc	ra,0x0
    80000dae:	85c080e7          	jalr	-1956(ra) # 80000606 <walkaddr>
    if(pa0 == 0)
    80000db2:	cd01                	beqz	a0,80000dca <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000db4:	418904b3          	sub	s1,s2,s8
    80000db8:	94d6                	add	s1,s1,s5
    80000dba:	fc99f2e3          	bgeu	s3,s1,80000d7e <copyin+0x28>
    80000dbe:	84ce                	mv	s1,s3
    80000dc0:	bf7d                	j	80000d7e <copyin+0x28>
  }
  return 0;
    80000dc2:	4501                	li	a0,0
    80000dc4:	a021                	j	80000dcc <copyin+0x76>
    80000dc6:	4501                	li	a0,0
}
    80000dc8:	8082                	ret
      return -1;
    80000dca:	557d                	li	a0,-1
}
    80000dcc:	60a6                	ld	ra,72(sp)
    80000dce:	6406                	ld	s0,64(sp)
    80000dd0:	74e2                	ld	s1,56(sp)
    80000dd2:	7942                	ld	s2,48(sp)
    80000dd4:	79a2                	ld	s3,40(sp)
    80000dd6:	7a02                	ld	s4,32(sp)
    80000dd8:	6ae2                	ld	s5,24(sp)
    80000dda:	6b42                	ld	s6,16(sp)
    80000ddc:	6ba2                	ld	s7,8(sp)
    80000dde:	6c02                	ld	s8,0(sp)
    80000de0:	6161                	addi	sp,sp,80
    80000de2:	8082                	ret

0000000080000de4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000de4:	c2dd                	beqz	a3,80000e8a <copyinstr+0xa6>
{
    80000de6:	715d                	addi	sp,sp,-80
    80000de8:	e486                	sd	ra,72(sp)
    80000dea:	e0a2                	sd	s0,64(sp)
    80000dec:	fc26                	sd	s1,56(sp)
    80000dee:	f84a                	sd	s2,48(sp)
    80000df0:	f44e                	sd	s3,40(sp)
    80000df2:	f052                	sd	s4,32(sp)
    80000df4:	ec56                	sd	s5,24(sp)
    80000df6:	e85a                	sd	s6,16(sp)
    80000df8:	e45e                	sd	s7,8(sp)
    80000dfa:	0880                	addi	s0,sp,80
    80000dfc:	8a2a                	mv	s4,a0
    80000dfe:	8b2e                	mv	s6,a1
    80000e00:	8bb2                	mv	s7,a2
    80000e02:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e04:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e06:	6985                	lui	s3,0x1
    80000e08:	a02d                	j	80000e32 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e0a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e0e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e10:	37fd                	addiw	a5,a5,-1
    80000e12:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e16:	60a6                	ld	ra,72(sp)
    80000e18:	6406                	ld	s0,64(sp)
    80000e1a:	74e2                	ld	s1,56(sp)
    80000e1c:	7942                	ld	s2,48(sp)
    80000e1e:	79a2                	ld	s3,40(sp)
    80000e20:	7a02                	ld	s4,32(sp)
    80000e22:	6ae2                	ld	s5,24(sp)
    80000e24:	6b42                	ld	s6,16(sp)
    80000e26:	6ba2                	ld	s7,8(sp)
    80000e28:	6161                	addi	sp,sp,80
    80000e2a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e2c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e30:	c8a9                	beqz	s1,80000e82 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000e32:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e36:	85ca                	mv	a1,s2
    80000e38:	8552                	mv	a0,s4
    80000e3a:	fffff097          	auipc	ra,0xfffff
    80000e3e:	7cc080e7          	jalr	1996(ra) # 80000606 <walkaddr>
    if(pa0 == 0)
    80000e42:	c131                	beqz	a0,80000e86 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000e44:	417906b3          	sub	a3,s2,s7
    80000e48:	96ce                	add	a3,a3,s3
    80000e4a:	00d4f363          	bgeu	s1,a3,80000e50 <copyinstr+0x6c>
    80000e4e:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e50:	955e                	add	a0,a0,s7
    80000e52:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e56:	daf9                	beqz	a3,80000e2c <copyinstr+0x48>
    80000e58:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e5a:	41650633          	sub	a2,a0,s6
    80000e5e:	fff48593          	addi	a1,s1,-1 # ffffffffffffefff <end+0xffffffff7fdb8dbf>
    80000e62:	95da                	add	a1,a1,s6
    while(n > 0){
    80000e64:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000e66:	00f60733          	add	a4,a2,a5
    80000e6a:	00074703          	lbu	a4,0(a4)
    80000e6e:	df51                	beqz	a4,80000e0a <copyinstr+0x26>
        *dst = *p;
    80000e70:	00e78023          	sb	a4,0(a5)
      --max;
    80000e74:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000e78:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e7a:	fed796e3          	bne	a5,a3,80000e66 <copyinstr+0x82>
      dst++;
    80000e7e:	8b3e                	mv	s6,a5
    80000e80:	b775                	j	80000e2c <copyinstr+0x48>
    80000e82:	4781                	li	a5,0
    80000e84:	b771                	j	80000e10 <copyinstr+0x2c>
      return -1;
    80000e86:	557d                	li	a0,-1
    80000e88:	b779                	j	80000e16 <copyinstr+0x32>
  int got_null = 0;
    80000e8a:	4781                	li	a5,0
  if(got_null){
    80000e8c:	37fd                	addiw	a5,a5,-1
    80000e8e:	0007851b          	sext.w	a0,a5
}
    80000e92:	8082                	ret

0000000080000e94 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e94:	7139                	addi	sp,sp,-64
    80000e96:	fc06                	sd	ra,56(sp)
    80000e98:	f822                	sd	s0,48(sp)
    80000e9a:	f426                	sd	s1,40(sp)
    80000e9c:	f04a                	sd	s2,32(sp)
    80000e9e:	ec4e                	sd	s3,24(sp)
    80000ea0:	e852                	sd	s4,16(sp)
    80000ea2:	e456                	sd	s5,8(sp)
    80000ea4:	e05a                	sd	s6,0(sp)
    80000ea6:	0080                	addi	s0,sp,64
    80000ea8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eaa:	00228497          	auipc	s1,0x228
    80000eae:	5ee48493          	addi	s1,s1,1518 # 80229498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000eb2:	8b26                	mv	s6,s1
    80000eb4:	00007a97          	auipc	s5,0x7
    80000eb8:	14ca8a93          	addi	s5,s5,332 # 80008000 <etext>
    80000ebc:	04000937          	lui	s2,0x4000
    80000ec0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ec2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec4:	0022ea17          	auipc	s4,0x22e
    80000ec8:	fd4a0a13          	addi	s4,s4,-44 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000ecc:	fffff097          	auipc	ra,0xfffff
    80000ed0:	31a080e7          	jalr	794(ra) # 800001e6 <kalloc>
    80000ed4:	862a                	mv	a2,a0
    if(pa == 0)
    80000ed6:	c131                	beqz	a0,80000f1a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ed8:	416485b3          	sub	a1,s1,s6
    80000edc:	858d                	srai	a1,a1,0x3
    80000ede:	000ab783          	ld	a5,0(s5)
    80000ee2:	02f585b3          	mul	a1,a1,a5
    80000ee6:	2585                	addiw	a1,a1,1
    80000ee8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eec:	4719                	li	a4,6
    80000eee:	6685                	lui	a3,0x1
    80000ef0:	40b905b3          	sub	a1,s2,a1
    80000ef4:	854e                	mv	a0,s3
    80000ef6:	fffff097          	auipc	ra,0xfffff
    80000efa:	7f2080e7          	jalr	2034(ra) # 800006e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efe:	16848493          	addi	s1,s1,360
    80000f02:	fd4495e3          	bne	s1,s4,80000ecc <proc_mapstacks+0x38>
  }
}
    80000f06:	70e2                	ld	ra,56(sp)
    80000f08:	7442                	ld	s0,48(sp)
    80000f0a:	74a2                	ld	s1,40(sp)
    80000f0c:	7902                	ld	s2,32(sp)
    80000f0e:	69e2                	ld	s3,24(sp)
    80000f10:	6a42                	ld	s4,16(sp)
    80000f12:	6aa2                	ld	s5,8(sp)
    80000f14:	6b02                	ld	s6,0(sp)
    80000f16:	6121                	addi	sp,sp,64
    80000f18:	8082                	ret
      panic("kalloc");
    80000f1a:	00007517          	auipc	a0,0x7
    80000f1e:	24e50513          	addi	a0,a0,590 # 80008168 <etext+0x168>
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	e5e080e7          	jalr	-418(ra) # 80005d80 <panic>

0000000080000f2a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f2a:	7139                	addi	sp,sp,-64
    80000f2c:	fc06                	sd	ra,56(sp)
    80000f2e:	f822                	sd	s0,48(sp)
    80000f30:	f426                	sd	s1,40(sp)
    80000f32:	f04a                	sd	s2,32(sp)
    80000f34:	ec4e                	sd	s3,24(sp)
    80000f36:	e852                	sd	s4,16(sp)
    80000f38:	e456                	sd	s5,8(sp)
    80000f3a:	e05a                	sd	s6,0(sp)
    80000f3c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f3e:	00007597          	auipc	a1,0x7
    80000f42:	23258593          	addi	a1,a1,562 # 80008170 <etext+0x170>
    80000f46:	00228517          	auipc	a0,0x228
    80000f4a:	12250513          	addi	a0,a0,290 # 80229068 <pid_lock>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	2da080e7          	jalr	730(ra) # 80006228 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f56:	00007597          	auipc	a1,0x7
    80000f5a:	22258593          	addi	a1,a1,546 # 80008178 <etext+0x178>
    80000f5e:	00228517          	auipc	a0,0x228
    80000f62:	12250513          	addi	a0,a0,290 # 80229080 <wait_lock>
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	2c2080e7          	jalr	706(ra) # 80006228 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f6e:	00228497          	auipc	s1,0x228
    80000f72:	52a48493          	addi	s1,s1,1322 # 80229498 <proc>
      initlock(&p->lock, "proc");
    80000f76:	00007b17          	auipc	s6,0x7
    80000f7a:	212b0b13          	addi	s6,s6,530 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000f7e:	8aa6                	mv	s5,s1
    80000f80:	00007a17          	auipc	s4,0x7
    80000f84:	080a0a13          	addi	s4,s4,128 # 80008000 <etext>
    80000f88:	04000937          	lui	s2,0x4000
    80000f8c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f8e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f90:	0022e997          	auipc	s3,0x22e
    80000f94:	f0898993          	addi	s3,s3,-248 # 8022ee98 <tickslock>
      initlock(&p->lock, "proc");
    80000f98:	85da                	mv	a1,s6
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00005097          	auipc	ra,0x5
    80000fa0:	28c080e7          	jalr	652(ra) # 80006228 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000fa4:	415487b3          	sub	a5,s1,s5
    80000fa8:	878d                	srai	a5,a5,0x3
    80000faa:	000a3703          	ld	a4,0(s4)
    80000fae:	02e787b3          	mul	a5,a5,a4
    80000fb2:	2785                	addiw	a5,a5,1
    80000fb4:	00d7979b          	slliw	a5,a5,0xd
    80000fb8:	40f907b3          	sub	a5,s2,a5
    80000fbc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fbe:	16848493          	addi	s1,s1,360
    80000fc2:	fd349be3          	bne	s1,s3,80000f98 <procinit+0x6e>
  }
}
    80000fc6:	70e2                	ld	ra,56(sp)
    80000fc8:	7442                	ld	s0,48(sp)
    80000fca:	74a2                	ld	s1,40(sp)
    80000fcc:	7902                	ld	s2,32(sp)
    80000fce:	69e2                	ld	s3,24(sp)
    80000fd0:	6a42                	ld	s4,16(sp)
    80000fd2:	6aa2                	ld	s5,8(sp)
    80000fd4:	6b02                	ld	s6,0(sp)
    80000fd6:	6121                	addi	sp,sp,64
    80000fd8:	8082                	ret

0000000080000fda <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fda:	1141                	addi	sp,sp,-16
    80000fdc:	e422                	sd	s0,8(sp)
    80000fde:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fe0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fe2:	2501                	sext.w	a0,a0
    80000fe4:	6422                	ld	s0,8(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret

0000000080000fea <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fea:	1141                	addi	sp,sp,-16
    80000fec:	e422                	sd	s0,8(sp)
    80000fee:	0800                	addi	s0,sp,16
    80000ff0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ff2:	2781                	sext.w	a5,a5
    80000ff4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ff6:	00228517          	auipc	a0,0x228
    80000ffa:	0a250513          	addi	a0,a0,162 # 80229098 <cpus>
    80000ffe:	953e                	add	a0,a0,a5
    80001000:	6422                	ld	s0,8(sp)
    80001002:	0141                	addi	sp,sp,16
    80001004:	8082                	ret

0000000080001006 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	1000                	addi	s0,sp,32
  push_off();
    80001010:	00005097          	auipc	ra,0x5
    80001014:	25c080e7          	jalr	604(ra) # 8000626c <push_off>
    80001018:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000101a:	2781                	sext.w	a5,a5
    8000101c:	079e                	slli	a5,a5,0x7
    8000101e:	00228717          	auipc	a4,0x228
    80001022:	04a70713          	addi	a4,a4,74 # 80229068 <pid_lock>
    80001026:	97ba                	add	a5,a5,a4
    80001028:	7b84                	ld	s1,48(a5)
  pop_off();
    8000102a:	00005097          	auipc	ra,0x5
    8000102e:	2e2080e7          	jalr	738(ra) # 8000630c <pop_off>
  return p;
}
    80001032:	8526                	mv	a0,s1
    80001034:	60e2                	ld	ra,24(sp)
    80001036:	6442                	ld	s0,16(sp)
    80001038:	64a2                	ld	s1,8(sp)
    8000103a:	6105                	addi	sp,sp,32
    8000103c:	8082                	ret

000000008000103e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000103e:	1141                	addi	sp,sp,-16
    80001040:	e406                	sd	ra,8(sp)
    80001042:	e022                	sd	s0,0(sp)
    80001044:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	fc0080e7          	jalr	-64(ra) # 80001006 <myproc>
    8000104e:	00005097          	auipc	ra,0x5
    80001052:	31e080e7          	jalr	798(ra) # 8000636c <release>

  if (first) {
    80001056:	00007797          	auipc	a5,0x7
    8000105a:	7ca7a783          	lw	a5,1994(a5) # 80008820 <first.1>
    8000105e:	eb89                	bnez	a5,80001070 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001060:	00001097          	auipc	ra,0x1
    80001064:	c14080e7          	jalr	-1004(ra) # 80001c74 <usertrapret>
}
    80001068:	60a2                	ld	ra,8(sp)
    8000106a:	6402                	ld	s0,0(sp)
    8000106c:	0141                	addi	sp,sp,16
    8000106e:	8082                	ret
    first = 0;
    80001070:	00007797          	auipc	a5,0x7
    80001074:	7a07a823          	sw	zero,1968(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80001078:	4505                	li	a0,1
    8000107a:	00002097          	auipc	ra,0x2
    8000107e:	a18080e7          	jalr	-1512(ra) # 80002a92 <fsinit>
    80001082:	bff9                	j	80001060 <forkret+0x22>

0000000080001084 <allocpid>:
allocpid() {
    80001084:	1101                	addi	sp,sp,-32
    80001086:	ec06                	sd	ra,24(sp)
    80001088:	e822                	sd	s0,16(sp)
    8000108a:	e426                	sd	s1,8(sp)
    8000108c:	e04a                	sd	s2,0(sp)
    8000108e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001090:	00228917          	auipc	s2,0x228
    80001094:	fd890913          	addi	s2,s2,-40 # 80229068 <pid_lock>
    80001098:	854a                	mv	a0,s2
    8000109a:	00005097          	auipc	ra,0x5
    8000109e:	21e080e7          	jalr	542(ra) # 800062b8 <acquire>
  pid = nextpid;
    800010a2:	00007797          	auipc	a5,0x7
    800010a6:	78278793          	addi	a5,a5,1922 # 80008824 <nextpid>
    800010aa:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010ac:	0014871b          	addiw	a4,s1,1
    800010b0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010b2:	854a                	mv	a0,s2
    800010b4:	00005097          	auipc	ra,0x5
    800010b8:	2b8080e7          	jalr	696(ra) # 8000636c <release>
}
    800010bc:	8526                	mv	a0,s1
    800010be:	60e2                	ld	ra,24(sp)
    800010c0:	6442                	ld	s0,16(sp)
    800010c2:	64a2                	ld	s1,8(sp)
    800010c4:	6902                	ld	s2,0(sp)
    800010c6:	6105                	addi	sp,sp,32
    800010c8:	8082                	ret

00000000800010ca <proc_pagetable>:
{
    800010ca:	1101                	addi	sp,sp,-32
    800010cc:	ec06                	sd	ra,24(sp)
    800010ce:	e822                	sd	s0,16(sp)
    800010d0:	e426                	sd	s1,8(sp)
    800010d2:	e04a                	sd	s2,0(sp)
    800010d4:	1000                	addi	s0,sp,32
    800010d6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	7fa080e7          	jalr	2042(ra) # 800008d2 <uvmcreate>
    800010e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010e2:	c121                	beqz	a0,80001122 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010e4:	4729                	li	a4,10
    800010e6:	00006697          	auipc	a3,0x6
    800010ea:	f1a68693          	addi	a3,a3,-230 # 80007000 <_trampoline>
    800010ee:	6605                	lui	a2,0x1
    800010f0:	040005b7          	lui	a1,0x4000
    800010f4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010f6:	05b2                	slli	a1,a1,0xc
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	550080e7          	jalr	1360(ra) # 80000648 <mappages>
    80001100:	02054863          	bltz	a0,80001130 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001104:	4719                	li	a4,6
    80001106:	05893683          	ld	a3,88(s2)
    8000110a:	6605                	lui	a2,0x1
    8000110c:	020005b7          	lui	a1,0x2000
    80001110:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001112:	05b6                	slli	a1,a1,0xd
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	532080e7          	jalr	1330(ra) # 80000648 <mappages>
    8000111e:	02054163          	bltz	a0,80001140 <proc_pagetable+0x76>
}
    80001122:	8526                	mv	a0,s1
    80001124:	60e2                	ld	ra,24(sp)
    80001126:	6442                	ld	s0,16(sp)
    80001128:	64a2                	ld	s1,8(sp)
    8000112a:	6902                	ld	s2,0(sp)
    8000112c:	6105                	addi	sp,sp,32
    8000112e:	8082                	ret
    uvmfree(pagetable, 0);
    80001130:	4581                	li	a1,0
    80001132:	8526                	mv	a0,s1
    80001134:	00000097          	auipc	ra,0x0
    80001138:	99c080e7          	jalr	-1636(ra) # 80000ad0 <uvmfree>
    return 0;
    8000113c:	4481                	li	s1,0
    8000113e:	b7d5                	j	80001122 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001140:	4681                	li	a3,0
    80001142:	4605                	li	a2,1
    80001144:	040005b7          	lui	a1,0x4000
    80001148:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000114a:	05b2                	slli	a1,a1,0xc
    8000114c:	8526                	mv	a0,s1
    8000114e:	fffff097          	auipc	ra,0xfffff
    80001152:	6c0080e7          	jalr	1728(ra) # 8000080e <uvmunmap>
    uvmfree(pagetable, 0);
    80001156:	4581                	li	a1,0
    80001158:	8526                	mv	a0,s1
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	976080e7          	jalr	-1674(ra) # 80000ad0 <uvmfree>
    return 0;
    80001162:	4481                	li	s1,0
    80001164:	bf7d                	j	80001122 <proc_pagetable+0x58>

0000000080001166 <proc_freepagetable>:
{
    80001166:	1101                	addi	sp,sp,-32
    80001168:	ec06                	sd	ra,24(sp)
    8000116a:	e822                	sd	s0,16(sp)
    8000116c:	e426                	sd	s1,8(sp)
    8000116e:	e04a                	sd	s2,0(sp)
    80001170:	1000                	addi	s0,sp,32
    80001172:	84aa                	mv	s1,a0
    80001174:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001176:	4681                	li	a3,0
    80001178:	4605                	li	a2,1
    8000117a:	040005b7          	lui	a1,0x4000
    8000117e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001180:	05b2                	slli	a1,a1,0xc
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	68c080e7          	jalr	1676(ra) # 8000080e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000118a:	4681                	li	a3,0
    8000118c:	4605                	li	a2,1
    8000118e:	020005b7          	lui	a1,0x2000
    80001192:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001194:	05b6                	slli	a1,a1,0xd
    80001196:	8526                	mv	a0,s1
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	676080e7          	jalr	1654(ra) # 8000080e <uvmunmap>
  uvmfree(pagetable, sz);
    800011a0:	85ca                	mv	a1,s2
    800011a2:	8526                	mv	a0,s1
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	92c080e7          	jalr	-1748(ra) # 80000ad0 <uvmfree>
}
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6902                	ld	s2,0(sp)
    800011b4:	6105                	addi	sp,sp,32
    800011b6:	8082                	ret

00000000800011b8 <freeproc>:
{
    800011b8:	1101                	addi	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	1000                	addi	s0,sp,32
    800011c2:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011c4:	6d28                	ld	a0,88(a0)
    800011c6:	c509                	beqz	a0,800011d0 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	e54080e7          	jalr	-428(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011d0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011d4:	68a8                	ld	a0,80(s1)
    800011d6:	c511                	beqz	a0,800011e2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011d8:	64ac                	ld	a1,72(s1)
    800011da:	00000097          	auipc	ra,0x0
    800011de:	f8c080e7          	jalr	-116(ra) # 80001166 <proc_freepagetable>
  p->pagetable = 0;
    800011e2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011e6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011ea:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011ee:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011f2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011f6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011fa:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011fe:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001202:	0004ac23          	sw	zero,24(s1)
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6105                	addi	sp,sp,32
    8000120e:	8082                	ret

0000000080001210 <allocproc>:
{
    80001210:	1101                	addi	sp,sp,-32
    80001212:	ec06                	sd	ra,24(sp)
    80001214:	e822                	sd	s0,16(sp)
    80001216:	e426                	sd	s1,8(sp)
    80001218:	e04a                	sd	s2,0(sp)
    8000121a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121c:	00228497          	auipc	s1,0x228
    80001220:	27c48493          	addi	s1,s1,636 # 80229498 <proc>
    80001224:	0022e917          	auipc	s2,0x22e
    80001228:	c7490913          	addi	s2,s2,-908 # 8022ee98 <tickslock>
    acquire(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00005097          	auipc	ra,0x5
    80001232:	08a080e7          	jalr	138(ra) # 800062b8 <acquire>
    if(p->state == UNUSED) {
    80001236:	4c9c                	lw	a5,24(s1)
    80001238:	cf81                	beqz	a5,80001250 <allocproc+0x40>
      release(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	00005097          	auipc	ra,0x5
    80001240:	130080e7          	jalr	304(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001244:	16848493          	addi	s1,s1,360
    80001248:	ff2492e3          	bne	s1,s2,8000122c <allocproc+0x1c>
  return 0;
    8000124c:	4481                	li	s1,0
    8000124e:	a889                	j	800012a0 <allocproc+0x90>
  p->pid = allocpid();
    80001250:	00000097          	auipc	ra,0x0
    80001254:	e34080e7          	jalr	-460(ra) # 80001084 <allocpid>
    80001258:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000125a:	4785                	li	a5,1
    8000125c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	f88080e7          	jalr	-120(ra) # 800001e6 <kalloc>
    80001266:	892a                	mv	s2,a0
    80001268:	eca8                	sd	a0,88(s1)
    8000126a:	c131                	beqz	a0,800012ae <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000126c:	8526                	mv	a0,s1
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	e5c080e7          	jalr	-420(ra) # 800010ca <proc_pagetable>
    80001276:	892a                	mv	s2,a0
    80001278:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000127a:	c531                	beqz	a0,800012c6 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000127c:	07000613          	li	a2,112
    80001280:	4581                	li	a1,0
    80001282:	06048513          	addi	a0,s1,96
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	ffa080e7          	jalr	-6(ra) # 80000280 <memset>
  p->context.ra = (uint64)forkret;
    8000128e:	00000797          	auipc	a5,0x0
    80001292:	db078793          	addi	a5,a5,-592 # 8000103e <forkret>
    80001296:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001298:	60bc                	ld	a5,64(s1)
    8000129a:	6705                	lui	a4,0x1
    8000129c:	97ba                	add	a5,a5,a4
    8000129e:	f4bc                	sd	a5,104(s1)
}
    800012a0:	8526                	mv	a0,s1
    800012a2:	60e2                	ld	ra,24(sp)
    800012a4:	6442                	ld	s0,16(sp)
    800012a6:	64a2                	ld	s1,8(sp)
    800012a8:	6902                	ld	s2,0(sp)
    800012aa:	6105                	addi	sp,sp,32
    800012ac:	8082                	ret
    freeproc(p);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	f08080e7          	jalr	-248(ra) # 800011b8 <freeproc>
    release(&p->lock);
    800012b8:	8526                	mv	a0,s1
    800012ba:	00005097          	auipc	ra,0x5
    800012be:	0b2080e7          	jalr	178(ra) # 8000636c <release>
    return 0;
    800012c2:	84ca                	mv	s1,s2
    800012c4:	bff1                	j	800012a0 <allocproc+0x90>
    freeproc(p);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	ef0080e7          	jalr	-272(ra) # 800011b8 <freeproc>
    release(&p->lock);
    800012d0:	8526                	mv	a0,s1
    800012d2:	00005097          	auipc	ra,0x5
    800012d6:	09a080e7          	jalr	154(ra) # 8000636c <release>
    return 0;
    800012da:	84ca                	mv	s1,s2
    800012dc:	b7d1                	j	800012a0 <allocproc+0x90>

00000000800012de <userinit>:
{
    800012de:	1101                	addi	sp,sp,-32
    800012e0:	ec06                	sd	ra,24(sp)
    800012e2:	e822                	sd	s0,16(sp)
    800012e4:	e426                	sd	s1,8(sp)
    800012e6:	1000                	addi	s0,sp,32
  p = allocproc();
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	f28080e7          	jalr	-216(ra) # 80001210 <allocproc>
    800012f0:	84aa                	mv	s1,a0
  initproc = p;
    800012f2:	00008797          	auipc	a5,0x8
    800012f6:	d0a7bf23          	sd	a0,-738(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012fa:	03400613          	li	a2,52
    800012fe:	00007597          	auipc	a1,0x7
    80001302:	53258593          	addi	a1,a1,1330 # 80008830 <initcode>
    80001306:	6928                	ld	a0,80(a0)
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	5f8080e7          	jalr	1528(ra) # 80000900 <uvminit>
  p->sz = PGSIZE;
    80001310:	6785                	lui	a5,0x1
    80001312:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001314:	6cb8                	ld	a4,88(s1)
    80001316:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000131a:	6cb8                	ld	a4,88(s1)
    8000131c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	00007597          	auipc	a1,0x7
    80001324:	e7058593          	addi	a1,a1,-400 # 80008190 <etext+0x190>
    80001328:	15848513          	addi	a0,s1,344
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	09e080e7          	jalr	158(ra) # 800003ca <safestrcpy>
  p->cwd = namei("/");
    80001334:	00007517          	auipc	a0,0x7
    80001338:	e6c50513          	addi	a0,a0,-404 # 800081a0 <etext+0x1a0>
    8000133c:	00002097          	auipc	ra,0x2
    80001340:	18c080e7          	jalr	396(ra) # 800034c8 <namei>
    80001344:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001348:	478d                	li	a5,3
    8000134a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	01e080e7          	jalr	30(ra) # 8000636c <release>
}
    80001356:	60e2                	ld	ra,24(sp)
    80001358:	6442                	ld	s0,16(sp)
    8000135a:	64a2                	ld	s1,8(sp)
    8000135c:	6105                	addi	sp,sp,32
    8000135e:	8082                	ret

0000000080001360 <growproc>:
{
    80001360:	1101                	addi	sp,sp,-32
    80001362:	ec06                	sd	ra,24(sp)
    80001364:	e822                	sd	s0,16(sp)
    80001366:	e426                	sd	s1,8(sp)
    80001368:	e04a                	sd	s2,0(sp)
    8000136a:	1000                	addi	s0,sp,32
    8000136c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	c98080e7          	jalr	-872(ra) # 80001006 <myproc>
    80001376:	892a                	mv	s2,a0
  sz = p->sz;
    80001378:	652c                	ld	a1,72(a0)
    8000137a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000137e:	00904f63          	bgtz	s1,8000139c <growproc+0x3c>
  } else if(n < 0){
    80001382:	0204cd63          	bltz	s1,800013bc <growproc+0x5c>
  p->sz = sz;
    80001386:	1782                	slli	a5,a5,0x20
    80001388:	9381                	srli	a5,a5,0x20
    8000138a:	04f93423          	sd	a5,72(s2)
  return 0;
    8000138e:	4501                	li	a0,0
}
    80001390:	60e2                	ld	ra,24(sp)
    80001392:	6442                	ld	s0,16(sp)
    80001394:	64a2                	ld	s1,8(sp)
    80001396:	6902                	ld	s2,0(sp)
    80001398:	6105                	addi	sp,sp,32
    8000139a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000139c:	00f4863b          	addw	a2,s1,a5
    800013a0:	1602                	slli	a2,a2,0x20
    800013a2:	9201                	srli	a2,a2,0x20
    800013a4:	1582                	slli	a1,a1,0x20
    800013a6:	9181                	srli	a1,a1,0x20
    800013a8:	6928                	ld	a0,80(a0)
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	610080e7          	jalr	1552(ra) # 800009ba <uvmalloc>
    800013b2:	0005079b          	sext.w	a5,a0
    800013b6:	fbe1                	bnez	a5,80001386 <growproc+0x26>
      return -1;
    800013b8:	557d                	li	a0,-1
    800013ba:	bfd9                	j	80001390 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013bc:	00f4863b          	addw	a2,s1,a5
    800013c0:	1602                	slli	a2,a2,0x20
    800013c2:	9201                	srli	a2,a2,0x20
    800013c4:	1582                	slli	a1,a1,0x20
    800013c6:	9181                	srli	a1,a1,0x20
    800013c8:	6928                	ld	a0,80(a0)
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	5a8080e7          	jalr	1448(ra) # 80000972 <uvmdealloc>
    800013d2:	0005079b          	sext.w	a5,a0
    800013d6:	bf45                	j	80001386 <growproc+0x26>

00000000800013d8 <fork>:
{
    800013d8:	7139                	addi	sp,sp,-64
    800013da:	fc06                	sd	ra,56(sp)
    800013dc:	f822                	sd	s0,48(sp)
    800013de:	f426                	sd	s1,40(sp)
    800013e0:	f04a                	sd	s2,32(sp)
    800013e2:	ec4e                	sd	s3,24(sp)
    800013e4:	e852                	sd	s4,16(sp)
    800013e6:	e456                	sd	s5,8(sp)
    800013e8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	c1c080e7          	jalr	-996(ra) # 80001006 <myproc>
    800013f2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	e1c080e7          	jalr	-484(ra) # 80001210 <allocproc>
    800013fc:	10050c63          	beqz	a0,80001514 <fork+0x13c>
    80001400:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001402:	048ab603          	ld	a2,72(s5)
    80001406:	692c                	ld	a1,80(a0)
    80001408:	050ab503          	ld	a0,80(s5)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	6fe080e7          	jalr	1790(ra) # 80000b0a <uvmcopy>
    80001414:	04054863          	bltz	a0,80001464 <fork+0x8c>
  np->sz = p->sz;
    80001418:	048ab783          	ld	a5,72(s5)
    8000141c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001420:	058ab683          	ld	a3,88(s5)
    80001424:	87b6                	mv	a5,a3
    80001426:	058a3703          	ld	a4,88(s4)
    8000142a:	12068693          	addi	a3,a3,288
    8000142e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001432:	6788                	ld	a0,8(a5)
    80001434:	6b8c                	ld	a1,16(a5)
    80001436:	6f90                	ld	a2,24(a5)
    80001438:	01073023          	sd	a6,0(a4)
    8000143c:	e708                	sd	a0,8(a4)
    8000143e:	eb0c                	sd	a1,16(a4)
    80001440:	ef10                	sd	a2,24(a4)
    80001442:	02078793          	addi	a5,a5,32
    80001446:	02070713          	addi	a4,a4,32
    8000144a:	fed792e3          	bne	a5,a3,8000142e <fork+0x56>
  np->trapframe->a0 = 0;
    8000144e:	058a3783          	ld	a5,88(s4)
    80001452:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001456:	0d0a8493          	addi	s1,s5,208
    8000145a:	0d0a0913          	addi	s2,s4,208
    8000145e:	150a8993          	addi	s3,s5,336
    80001462:	a00d                	j	80001484 <fork+0xac>
    freeproc(np);
    80001464:	8552                	mv	a0,s4
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	d52080e7          	jalr	-686(ra) # 800011b8 <freeproc>
    release(&np->lock);
    8000146e:	8552                	mv	a0,s4
    80001470:	00005097          	auipc	ra,0x5
    80001474:	efc080e7          	jalr	-260(ra) # 8000636c <release>
    return -1;
    80001478:	597d                	li	s2,-1
    8000147a:	a059                	j	80001500 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000147c:	04a1                	addi	s1,s1,8
    8000147e:	0921                	addi	s2,s2,8
    80001480:	01348b63          	beq	s1,s3,80001496 <fork+0xbe>
    if(p->ofile[i])
    80001484:	6088                	ld	a0,0(s1)
    80001486:	d97d                	beqz	a0,8000147c <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001488:	00002097          	auipc	ra,0x2
    8000148c:	6d6080e7          	jalr	1750(ra) # 80003b5e <filedup>
    80001490:	00a93023          	sd	a0,0(s2)
    80001494:	b7e5                	j	8000147c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001496:	150ab503          	ld	a0,336(s5)
    8000149a:	00002097          	auipc	ra,0x2
    8000149e:	834080e7          	jalr	-1996(ra) # 80002cce <idup>
    800014a2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014a6:	4641                	li	a2,16
    800014a8:	158a8593          	addi	a1,s5,344
    800014ac:	158a0513          	addi	a0,s4,344
    800014b0:	fffff097          	auipc	ra,0xfffff
    800014b4:	f1a080e7          	jalr	-230(ra) # 800003ca <safestrcpy>
  pid = np->pid;
    800014b8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014bc:	8552                	mv	a0,s4
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	eae080e7          	jalr	-338(ra) # 8000636c <release>
  acquire(&wait_lock);
    800014c6:	00228497          	auipc	s1,0x228
    800014ca:	bba48493          	addi	s1,s1,-1094 # 80229080 <wait_lock>
    800014ce:	8526                	mv	a0,s1
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	de8080e7          	jalr	-536(ra) # 800062b8 <acquire>
  np->parent = p;
    800014d8:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014dc:	8526                	mv	a0,s1
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	e8e080e7          	jalr	-370(ra) # 8000636c <release>
  acquire(&np->lock);
    800014e6:	8552                	mv	a0,s4
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	dd0080e7          	jalr	-560(ra) # 800062b8 <acquire>
  np->state = RUNNABLE;
    800014f0:	478d                	li	a5,3
    800014f2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014f6:	8552                	mv	a0,s4
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	e74080e7          	jalr	-396(ra) # 8000636c <release>
}
    80001500:	854a                	mv	a0,s2
    80001502:	70e2                	ld	ra,56(sp)
    80001504:	7442                	ld	s0,48(sp)
    80001506:	74a2                	ld	s1,40(sp)
    80001508:	7902                	ld	s2,32(sp)
    8000150a:	69e2                	ld	s3,24(sp)
    8000150c:	6a42                	ld	s4,16(sp)
    8000150e:	6aa2                	ld	s5,8(sp)
    80001510:	6121                	addi	sp,sp,64
    80001512:	8082                	ret
    return -1;
    80001514:	597d                	li	s2,-1
    80001516:	b7ed                	j	80001500 <fork+0x128>

0000000080001518 <scheduler>:
{
    80001518:	7139                	addi	sp,sp,-64
    8000151a:	fc06                	sd	ra,56(sp)
    8000151c:	f822                	sd	s0,48(sp)
    8000151e:	f426                	sd	s1,40(sp)
    80001520:	f04a                	sd	s2,32(sp)
    80001522:	ec4e                	sd	s3,24(sp)
    80001524:	e852                	sd	s4,16(sp)
    80001526:	e456                	sd	s5,8(sp)
    80001528:	e05a                	sd	s6,0(sp)
    8000152a:	0080                	addi	s0,sp,64
    8000152c:	8792                	mv	a5,tp
  int id = r_tp();
    8000152e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001530:	00779a93          	slli	s5,a5,0x7
    80001534:	00228717          	auipc	a4,0x228
    80001538:	b3470713          	addi	a4,a4,-1228 # 80229068 <pid_lock>
    8000153c:	9756                	add	a4,a4,s5
    8000153e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001542:	00228717          	auipc	a4,0x228
    80001546:	b5e70713          	addi	a4,a4,-1186 # 802290a0 <cpus+0x8>
    8000154a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000154c:	498d                	li	s3,3
        p->state = RUNNING;
    8000154e:	4b11                	li	s6,4
        c->proc = p;
    80001550:	079e                	slli	a5,a5,0x7
    80001552:	00228a17          	auipc	s4,0x228
    80001556:	b16a0a13          	addi	s4,s4,-1258 # 80229068 <pid_lock>
    8000155a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000155c:	0022e917          	auipc	s2,0x22e
    80001560:	93c90913          	addi	s2,s2,-1732 # 8022ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001564:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001568:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000156c:	10079073          	csrw	sstatus,a5
    80001570:	00228497          	auipc	s1,0x228
    80001574:	f2848493          	addi	s1,s1,-216 # 80229498 <proc>
    80001578:	a811                	j	8000158c <scheduler+0x74>
      release(&p->lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	df0080e7          	jalr	-528(ra) # 8000636c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001584:	16848493          	addi	s1,s1,360
    80001588:	fd248ee3          	beq	s1,s2,80001564 <scheduler+0x4c>
      acquire(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	d2a080e7          	jalr	-726(ra) # 800062b8 <acquire>
      if(p->state == RUNNABLE) {
    80001596:	4c9c                	lw	a5,24(s1)
    80001598:	ff3791e3          	bne	a5,s3,8000157a <scheduler+0x62>
        p->state = RUNNING;
    8000159c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015a0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015a4:	06048593          	addi	a1,s1,96
    800015a8:	8556                	mv	a0,s5
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	620080e7          	jalr	1568(ra) # 80001bca <swtch>
        c->proc = 0;
    800015b2:	020a3823          	sd	zero,48(s4)
    800015b6:	b7d1                	j	8000157a <scheduler+0x62>

00000000800015b8 <sched>:
{
    800015b8:	7179                	addi	sp,sp,-48
    800015ba:	f406                	sd	ra,40(sp)
    800015bc:	f022                	sd	s0,32(sp)
    800015be:	ec26                	sd	s1,24(sp)
    800015c0:	e84a                	sd	s2,16(sp)
    800015c2:	e44e                	sd	s3,8(sp)
    800015c4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	a40080e7          	jalr	-1472(ra) # 80001006 <myproc>
    800015ce:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	c6e080e7          	jalr	-914(ra) # 8000623e <holding>
    800015d8:	c93d                	beqz	a0,8000164e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015da:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015dc:	2781                	sext.w	a5,a5
    800015de:	079e                	slli	a5,a5,0x7
    800015e0:	00228717          	auipc	a4,0x228
    800015e4:	a8870713          	addi	a4,a4,-1400 # 80229068 <pid_lock>
    800015e8:	97ba                	add	a5,a5,a4
    800015ea:	0a87a703          	lw	a4,168(a5)
    800015ee:	4785                	li	a5,1
    800015f0:	06f71763          	bne	a4,a5,8000165e <sched+0xa6>
  if(p->state == RUNNING)
    800015f4:	4c98                	lw	a4,24(s1)
    800015f6:	4791                	li	a5,4
    800015f8:	06f70b63          	beq	a4,a5,8000166e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001600:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001602:	efb5                	bnez	a5,8000167e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001604:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001606:	00228917          	auipc	s2,0x228
    8000160a:	a6290913          	addi	s2,s2,-1438 # 80229068 <pid_lock>
    8000160e:	2781                	sext.w	a5,a5
    80001610:	079e                	slli	a5,a5,0x7
    80001612:	97ca                	add	a5,a5,s2
    80001614:	0ac7a983          	lw	s3,172(a5)
    80001618:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000161a:	2781                	sext.w	a5,a5
    8000161c:	079e                	slli	a5,a5,0x7
    8000161e:	00228597          	auipc	a1,0x228
    80001622:	a8258593          	addi	a1,a1,-1406 # 802290a0 <cpus+0x8>
    80001626:	95be                	add	a1,a1,a5
    80001628:	06048513          	addi	a0,s1,96
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	59e080e7          	jalr	1438(ra) # 80001bca <swtch>
    80001634:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001636:	2781                	sext.w	a5,a5
    80001638:	079e                	slli	a5,a5,0x7
    8000163a:	993e                	add	s2,s2,a5
    8000163c:	0b392623          	sw	s3,172(s2)
}
    80001640:	70a2                	ld	ra,40(sp)
    80001642:	7402                	ld	s0,32(sp)
    80001644:	64e2                	ld	s1,24(sp)
    80001646:	6942                	ld	s2,16(sp)
    80001648:	69a2                	ld	s3,8(sp)
    8000164a:	6145                	addi	sp,sp,48
    8000164c:	8082                	ret
    panic("sched p->lock");
    8000164e:	00007517          	auipc	a0,0x7
    80001652:	b5a50513          	addi	a0,a0,-1190 # 800081a8 <etext+0x1a8>
    80001656:	00004097          	auipc	ra,0x4
    8000165a:	72a080e7          	jalr	1834(ra) # 80005d80 <panic>
    panic("sched locks");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	b5a50513          	addi	a0,a0,-1190 # 800081b8 <etext+0x1b8>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	71a080e7          	jalr	1818(ra) # 80005d80 <panic>
    panic("sched running");
    8000166e:	00007517          	auipc	a0,0x7
    80001672:	b5a50513          	addi	a0,a0,-1190 # 800081c8 <etext+0x1c8>
    80001676:	00004097          	auipc	ra,0x4
    8000167a:	70a080e7          	jalr	1802(ra) # 80005d80 <panic>
    panic("sched interruptible");
    8000167e:	00007517          	auipc	a0,0x7
    80001682:	b5a50513          	addi	a0,a0,-1190 # 800081d8 <etext+0x1d8>
    80001686:	00004097          	auipc	ra,0x4
    8000168a:	6fa080e7          	jalr	1786(ra) # 80005d80 <panic>

000000008000168e <yield>:
{
    8000168e:	1101                	addi	sp,sp,-32
    80001690:	ec06                	sd	ra,24(sp)
    80001692:	e822                	sd	s0,16(sp)
    80001694:	e426                	sd	s1,8(sp)
    80001696:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	96e080e7          	jalr	-1682(ra) # 80001006 <myproc>
    800016a0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	c16080e7          	jalr	-1002(ra) # 800062b8 <acquire>
  p->state = RUNNABLE;
    800016aa:	478d                	li	a5,3
    800016ac:	cc9c                	sw	a5,24(s1)
  sched();
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	f0a080e7          	jalr	-246(ra) # 800015b8 <sched>
  release(&p->lock);
    800016b6:	8526                	mv	a0,s1
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	cb4080e7          	jalr	-844(ra) # 8000636c <release>
}
    800016c0:	60e2                	ld	ra,24(sp)
    800016c2:	6442                	ld	s0,16(sp)
    800016c4:	64a2                	ld	s1,8(sp)
    800016c6:	6105                	addi	sp,sp,32
    800016c8:	8082                	ret

00000000800016ca <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016ca:	7179                	addi	sp,sp,-48
    800016cc:	f406                	sd	ra,40(sp)
    800016ce:	f022                	sd	s0,32(sp)
    800016d0:	ec26                	sd	s1,24(sp)
    800016d2:	e84a                	sd	s2,16(sp)
    800016d4:	e44e                	sd	s3,8(sp)
    800016d6:	1800                	addi	s0,sp,48
    800016d8:	89aa                	mv	s3,a0
    800016da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016dc:	00000097          	auipc	ra,0x0
    800016e0:	92a080e7          	jalr	-1750(ra) # 80001006 <myproc>
    800016e4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	bd2080e7          	jalr	-1070(ra) # 800062b8 <acquire>
  release(lk);
    800016ee:	854a                	mv	a0,s2
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	c7c080e7          	jalr	-900(ra) # 8000636c <release>

  // Go to sleep.
  p->chan = chan;
    800016f8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016fc:	4789                	li	a5,2
    800016fe:	cc9c                	sw	a5,24(s1)

  sched();
    80001700:	00000097          	auipc	ra,0x0
    80001704:	eb8080e7          	jalr	-328(ra) # 800015b8 <sched>

  // Tidy up.
  p->chan = 0;
    80001708:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	c5e080e7          	jalr	-930(ra) # 8000636c <release>
  acquire(lk);
    80001716:	854a                	mv	a0,s2
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	ba0080e7          	jalr	-1120(ra) # 800062b8 <acquire>
}
    80001720:	70a2                	ld	ra,40(sp)
    80001722:	7402                	ld	s0,32(sp)
    80001724:	64e2                	ld	s1,24(sp)
    80001726:	6942                	ld	s2,16(sp)
    80001728:	69a2                	ld	s3,8(sp)
    8000172a:	6145                	addi	sp,sp,48
    8000172c:	8082                	ret

000000008000172e <wait>:
{
    8000172e:	715d                	addi	sp,sp,-80
    80001730:	e486                	sd	ra,72(sp)
    80001732:	e0a2                	sd	s0,64(sp)
    80001734:	fc26                	sd	s1,56(sp)
    80001736:	f84a                	sd	s2,48(sp)
    80001738:	f44e                	sd	s3,40(sp)
    8000173a:	f052                	sd	s4,32(sp)
    8000173c:	ec56                	sd	s5,24(sp)
    8000173e:	e85a                	sd	s6,16(sp)
    80001740:	e45e                	sd	s7,8(sp)
    80001742:	e062                	sd	s8,0(sp)
    80001744:	0880                	addi	s0,sp,80
    80001746:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	8be080e7          	jalr	-1858(ra) # 80001006 <myproc>
    80001750:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001752:	00228517          	auipc	a0,0x228
    80001756:	92e50513          	addi	a0,a0,-1746 # 80229080 <wait_lock>
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	b5e080e7          	jalr	-1186(ra) # 800062b8 <acquire>
    havekids = 0;
    80001762:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001764:	4a15                	li	s4,5
        havekids = 1;
    80001766:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001768:	0022d997          	auipc	s3,0x22d
    8000176c:	73098993          	addi	s3,s3,1840 # 8022ee98 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001770:	00228c17          	auipc	s8,0x228
    80001774:	910c0c13          	addi	s8,s8,-1776 # 80229080 <wait_lock>
    havekids = 0;
    80001778:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000177a:	00228497          	auipc	s1,0x228
    8000177e:	d1e48493          	addi	s1,s1,-738 # 80229498 <proc>
    80001782:	a0bd                	j	800017f0 <wait+0xc2>
          pid = np->pid;
    80001784:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001788:	000b0e63          	beqz	s6,800017a4 <wait+0x76>
    8000178c:	4691                	li	a3,4
    8000178e:	02c48613          	addi	a2,s1,44
    80001792:	85da                	mv	a1,s6
    80001794:	05093503          	ld	a0,80(s2)
    80001798:	fffff097          	auipc	ra,0xfffff
    8000179c:	492080e7          	jalr	1170(ra) # 80000c2a <copyout>
    800017a0:	02054563          	bltz	a0,800017ca <wait+0x9c>
          freeproc(np);
    800017a4:	8526                	mv	a0,s1
    800017a6:	00000097          	auipc	ra,0x0
    800017aa:	a12080e7          	jalr	-1518(ra) # 800011b8 <freeproc>
          release(&np->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	bbc080e7          	jalr	-1092(ra) # 8000636c <release>
          release(&wait_lock);
    800017b8:	00228517          	auipc	a0,0x228
    800017bc:	8c850513          	addi	a0,a0,-1848 # 80229080 <wait_lock>
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	bac080e7          	jalr	-1108(ra) # 8000636c <release>
          return pid;
    800017c8:	a09d                	j	8000182e <wait+0x100>
            release(&np->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	ba0080e7          	jalr	-1120(ra) # 8000636c <release>
            release(&wait_lock);
    800017d4:	00228517          	auipc	a0,0x228
    800017d8:	8ac50513          	addi	a0,a0,-1876 # 80229080 <wait_lock>
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	b90080e7          	jalr	-1136(ra) # 8000636c <release>
            return -1;
    800017e4:	59fd                	li	s3,-1
    800017e6:	a0a1                	j	8000182e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017e8:	16848493          	addi	s1,s1,360
    800017ec:	03348463          	beq	s1,s3,80001814 <wait+0xe6>
      if(np->parent == p){
    800017f0:	7c9c                	ld	a5,56(s1)
    800017f2:	ff279be3          	bne	a5,s2,800017e8 <wait+0xba>
        acquire(&np->lock);
    800017f6:	8526                	mv	a0,s1
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	ac0080e7          	jalr	-1344(ra) # 800062b8 <acquire>
        if(np->state == ZOMBIE){
    80001800:	4c9c                	lw	a5,24(s1)
    80001802:	f94781e3          	beq	a5,s4,80001784 <wait+0x56>
        release(&np->lock);
    80001806:	8526                	mv	a0,s1
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	b64080e7          	jalr	-1180(ra) # 8000636c <release>
        havekids = 1;
    80001810:	8756                	mv	a4,s5
    80001812:	bfd9                	j	800017e8 <wait+0xba>
    if(!havekids || p->killed){
    80001814:	c701                	beqz	a4,8000181c <wait+0xee>
    80001816:	02892783          	lw	a5,40(s2)
    8000181a:	c79d                	beqz	a5,80001848 <wait+0x11a>
      release(&wait_lock);
    8000181c:	00228517          	auipc	a0,0x228
    80001820:	86450513          	addi	a0,a0,-1948 # 80229080 <wait_lock>
    80001824:	00005097          	auipc	ra,0x5
    80001828:	b48080e7          	jalr	-1208(ra) # 8000636c <release>
      return -1;
    8000182c:	59fd                	li	s3,-1
}
    8000182e:	854e                	mv	a0,s3
    80001830:	60a6                	ld	ra,72(sp)
    80001832:	6406                	ld	s0,64(sp)
    80001834:	74e2                	ld	s1,56(sp)
    80001836:	7942                	ld	s2,48(sp)
    80001838:	79a2                	ld	s3,40(sp)
    8000183a:	7a02                	ld	s4,32(sp)
    8000183c:	6ae2                	ld	s5,24(sp)
    8000183e:	6b42                	ld	s6,16(sp)
    80001840:	6ba2                	ld	s7,8(sp)
    80001842:	6c02                	ld	s8,0(sp)
    80001844:	6161                	addi	sp,sp,80
    80001846:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001848:	85e2                	mv	a1,s8
    8000184a:	854a                	mv	a0,s2
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	e7e080e7          	jalr	-386(ra) # 800016ca <sleep>
    havekids = 0;
    80001854:	b715                	j	80001778 <wait+0x4a>

0000000080001856 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001856:	7139                	addi	sp,sp,-64
    80001858:	fc06                	sd	ra,56(sp)
    8000185a:	f822                	sd	s0,48(sp)
    8000185c:	f426                	sd	s1,40(sp)
    8000185e:	f04a                	sd	s2,32(sp)
    80001860:	ec4e                	sd	s3,24(sp)
    80001862:	e852                	sd	s4,16(sp)
    80001864:	e456                	sd	s5,8(sp)
    80001866:	0080                	addi	s0,sp,64
    80001868:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000186a:	00228497          	auipc	s1,0x228
    8000186e:	c2e48493          	addi	s1,s1,-978 # 80229498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001872:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001874:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001876:	0022d917          	auipc	s2,0x22d
    8000187a:	62290913          	addi	s2,s2,1570 # 8022ee98 <tickslock>
    8000187e:	a811                	j	80001892 <wakeup+0x3c>
      }
      release(&p->lock);
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	aea080e7          	jalr	-1302(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188a:	16848493          	addi	s1,s1,360
    8000188e:	03248663          	beq	s1,s2,800018ba <wakeup+0x64>
    if(p != myproc()){
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	774080e7          	jalr	1908(ra) # 80001006 <myproc>
    8000189a:	fea488e3          	beq	s1,a0,8000188a <wakeup+0x34>
      acquire(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	a18080e7          	jalr	-1512(ra) # 800062b8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	fd379be3          	bne	a5,s3,80001880 <wakeup+0x2a>
    800018ae:	709c                	ld	a5,32(s1)
    800018b0:	fd4798e3          	bne	a5,s4,80001880 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018b4:	0154ac23          	sw	s5,24(s1)
    800018b8:	b7e1                	j	80001880 <wakeup+0x2a>
    }
  }
}
    800018ba:	70e2                	ld	ra,56(sp)
    800018bc:	7442                	ld	s0,48(sp)
    800018be:	74a2                	ld	s1,40(sp)
    800018c0:	7902                	ld	s2,32(sp)
    800018c2:	69e2                	ld	s3,24(sp)
    800018c4:	6a42                	ld	s4,16(sp)
    800018c6:	6aa2                	ld	s5,8(sp)
    800018c8:	6121                	addi	sp,sp,64
    800018ca:	8082                	ret

00000000800018cc <reparent>:
{
    800018cc:	7179                	addi	sp,sp,-48
    800018ce:	f406                	sd	ra,40(sp)
    800018d0:	f022                	sd	s0,32(sp)
    800018d2:	ec26                	sd	s1,24(sp)
    800018d4:	e84a                	sd	s2,16(sp)
    800018d6:	e44e                	sd	s3,8(sp)
    800018d8:	e052                	sd	s4,0(sp)
    800018da:	1800                	addi	s0,sp,48
    800018dc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018de:	00228497          	auipc	s1,0x228
    800018e2:	bba48493          	addi	s1,s1,-1094 # 80229498 <proc>
      pp->parent = initproc;
    800018e6:	00007a17          	auipc	s4,0x7
    800018ea:	72aa0a13          	addi	s4,s4,1834 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ee:	0022d997          	auipc	s3,0x22d
    800018f2:	5aa98993          	addi	s3,s3,1450 # 8022ee98 <tickslock>
    800018f6:	a029                	j	80001900 <reparent+0x34>
    800018f8:	16848493          	addi	s1,s1,360
    800018fc:	01348d63          	beq	s1,s3,80001916 <reparent+0x4a>
    if(pp->parent == p){
    80001900:	7c9c                	ld	a5,56(s1)
    80001902:	ff279be3          	bne	a5,s2,800018f8 <reparent+0x2c>
      pp->parent = initproc;
    80001906:	000a3503          	ld	a0,0(s4)
    8000190a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000190c:	00000097          	auipc	ra,0x0
    80001910:	f4a080e7          	jalr	-182(ra) # 80001856 <wakeup>
    80001914:	b7d5                	j	800018f8 <reparent+0x2c>
}
    80001916:	70a2                	ld	ra,40(sp)
    80001918:	7402                	ld	s0,32(sp)
    8000191a:	64e2                	ld	s1,24(sp)
    8000191c:	6942                	ld	s2,16(sp)
    8000191e:	69a2                	ld	s3,8(sp)
    80001920:	6a02                	ld	s4,0(sp)
    80001922:	6145                	addi	sp,sp,48
    80001924:	8082                	ret

0000000080001926 <exit>:
{
    80001926:	7179                	addi	sp,sp,-48
    80001928:	f406                	sd	ra,40(sp)
    8000192a:	f022                	sd	s0,32(sp)
    8000192c:	ec26                	sd	s1,24(sp)
    8000192e:	e84a                	sd	s2,16(sp)
    80001930:	e44e                	sd	s3,8(sp)
    80001932:	e052                	sd	s4,0(sp)
    80001934:	1800                	addi	s0,sp,48
    80001936:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	6ce080e7          	jalr	1742(ra) # 80001006 <myproc>
    80001940:	89aa                	mv	s3,a0
  if(p == initproc)
    80001942:	00007797          	auipc	a5,0x7
    80001946:	6ce7b783          	ld	a5,1742(a5) # 80009010 <initproc>
    8000194a:	0d050493          	addi	s1,a0,208
    8000194e:	15050913          	addi	s2,a0,336
    80001952:	02a79363          	bne	a5,a0,80001978 <exit+0x52>
    panic("init exiting");
    80001956:	00007517          	auipc	a0,0x7
    8000195a:	89a50513          	addi	a0,a0,-1894 # 800081f0 <etext+0x1f0>
    8000195e:	00004097          	auipc	ra,0x4
    80001962:	422080e7          	jalr	1058(ra) # 80005d80 <panic>
      fileclose(f);
    80001966:	00002097          	auipc	ra,0x2
    8000196a:	24a080e7          	jalr	586(ra) # 80003bb0 <fileclose>
      p->ofile[fd] = 0;
    8000196e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001972:	04a1                	addi	s1,s1,8
    80001974:	01248563          	beq	s1,s2,8000197e <exit+0x58>
    if(p->ofile[fd]){
    80001978:	6088                	ld	a0,0(s1)
    8000197a:	f575                	bnez	a0,80001966 <exit+0x40>
    8000197c:	bfdd                	j	80001972 <exit+0x4c>
  begin_op();
    8000197e:	00002097          	auipc	ra,0x2
    80001982:	d6a080e7          	jalr	-662(ra) # 800036e8 <begin_op>
  iput(p->cwd);
    80001986:	1509b503          	ld	a0,336(s3)
    8000198a:	00001097          	auipc	ra,0x1
    8000198e:	53c080e7          	jalr	1340(ra) # 80002ec6 <iput>
  end_op();
    80001992:	00002097          	auipc	ra,0x2
    80001996:	dd4080e7          	jalr	-556(ra) # 80003766 <end_op>
  p->cwd = 0;
    8000199a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000199e:	00227497          	auipc	s1,0x227
    800019a2:	6e248493          	addi	s1,s1,1762 # 80229080 <wait_lock>
    800019a6:	8526                	mv	a0,s1
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	910080e7          	jalr	-1776(ra) # 800062b8 <acquire>
  reparent(p);
    800019b0:	854e                	mv	a0,s3
    800019b2:	00000097          	auipc	ra,0x0
    800019b6:	f1a080e7          	jalr	-230(ra) # 800018cc <reparent>
  wakeup(p->parent);
    800019ba:	0389b503          	ld	a0,56(s3)
    800019be:	00000097          	auipc	ra,0x0
    800019c2:	e98080e7          	jalr	-360(ra) # 80001856 <wakeup>
  acquire(&p->lock);
    800019c6:	854e                	mv	a0,s3
    800019c8:	00005097          	auipc	ra,0x5
    800019cc:	8f0080e7          	jalr	-1808(ra) # 800062b8 <acquire>
  p->xstate = status;
    800019d0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019d4:	4795                	li	a5,5
    800019d6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019da:	8526                	mv	a0,s1
    800019dc:	00005097          	auipc	ra,0x5
    800019e0:	990080e7          	jalr	-1648(ra) # 8000636c <release>
  sched();
    800019e4:	00000097          	auipc	ra,0x0
    800019e8:	bd4080e7          	jalr	-1068(ra) # 800015b8 <sched>
  panic("zombie exit");
    800019ec:	00007517          	auipc	a0,0x7
    800019f0:	81450513          	addi	a0,a0,-2028 # 80008200 <etext+0x200>
    800019f4:	00004097          	auipc	ra,0x4
    800019f8:	38c080e7          	jalr	908(ra) # 80005d80 <panic>

00000000800019fc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019fc:	7179                	addi	sp,sp,-48
    800019fe:	f406                	sd	ra,40(sp)
    80001a00:	f022                	sd	s0,32(sp)
    80001a02:	ec26                	sd	s1,24(sp)
    80001a04:	e84a                	sd	s2,16(sp)
    80001a06:	e44e                	sd	s3,8(sp)
    80001a08:	1800                	addi	s0,sp,48
    80001a0a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a0c:	00228497          	auipc	s1,0x228
    80001a10:	a8c48493          	addi	s1,s1,-1396 # 80229498 <proc>
    80001a14:	0022d997          	auipc	s3,0x22d
    80001a18:	48498993          	addi	s3,s3,1156 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	00005097          	auipc	ra,0x5
    80001a22:	89a080e7          	jalr	-1894(ra) # 800062b8 <acquire>
    if(p->pid == pid){
    80001a26:	589c                	lw	a5,48(s1)
    80001a28:	01278d63          	beq	a5,s2,80001a42 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	00005097          	auipc	ra,0x5
    80001a32:	93e080e7          	jalr	-1730(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a36:	16848493          	addi	s1,s1,360
    80001a3a:	ff3491e3          	bne	s1,s3,80001a1c <kill+0x20>
  }
  return -1;
    80001a3e:	557d                	li	a0,-1
    80001a40:	a829                	j	80001a5a <kill+0x5e>
      p->killed = 1;
    80001a42:	4785                	li	a5,1
    80001a44:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a46:	4c98                	lw	a4,24(s1)
    80001a48:	4789                	li	a5,2
    80001a4a:	00f70f63          	beq	a4,a5,80001a68 <kill+0x6c>
      release(&p->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	00005097          	auipc	ra,0x5
    80001a54:	91c080e7          	jalr	-1764(ra) # 8000636c <release>
      return 0;
    80001a58:	4501                	li	a0,0
}
    80001a5a:	70a2                	ld	ra,40(sp)
    80001a5c:	7402                	ld	s0,32(sp)
    80001a5e:	64e2                	ld	s1,24(sp)
    80001a60:	6942                	ld	s2,16(sp)
    80001a62:	69a2                	ld	s3,8(sp)
    80001a64:	6145                	addi	sp,sp,48
    80001a66:	8082                	ret
        p->state = RUNNABLE;
    80001a68:	478d                	li	a5,3
    80001a6a:	cc9c                	sw	a5,24(s1)
    80001a6c:	b7cd                	j	80001a4e <kill+0x52>

0000000080001a6e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a6e:	7179                	addi	sp,sp,-48
    80001a70:	f406                	sd	ra,40(sp)
    80001a72:	f022                	sd	s0,32(sp)
    80001a74:	ec26                	sd	s1,24(sp)
    80001a76:	e84a                	sd	s2,16(sp)
    80001a78:	e44e                	sd	s3,8(sp)
    80001a7a:	e052                	sd	s4,0(sp)
    80001a7c:	1800                	addi	s0,sp,48
    80001a7e:	84aa                	mv	s1,a0
    80001a80:	892e                	mv	s2,a1
    80001a82:	89b2                	mv	s3,a2
    80001a84:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	580080e7          	jalr	1408(ra) # 80001006 <myproc>
  if(user_dst){
    80001a8e:	c08d                	beqz	s1,80001ab0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a90:	86d2                	mv	a3,s4
    80001a92:	864e                	mv	a2,s3
    80001a94:	85ca                	mv	a1,s2
    80001a96:	6928                	ld	a0,80(a0)
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	192080e7          	jalr	402(ra) # 80000c2a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa0:	70a2                	ld	ra,40(sp)
    80001aa2:	7402                	ld	s0,32(sp)
    80001aa4:	64e2                	ld	s1,24(sp)
    80001aa6:	6942                	ld	s2,16(sp)
    80001aa8:	69a2                	ld	s3,8(sp)
    80001aaa:	6a02                	ld	s4,0(sp)
    80001aac:	6145                	addi	sp,sp,48
    80001aae:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab0:	000a061b          	sext.w	a2,s4
    80001ab4:	85ce                	mv	a1,s3
    80001ab6:	854a                	mv	a0,s2
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	824080e7          	jalr	-2012(ra) # 800002dc <memmove>
    return 0;
    80001ac0:	8526                	mv	a0,s1
    80001ac2:	bff9                	j	80001aa0 <either_copyout+0x32>

0000000080001ac4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ac4:	7179                	addi	sp,sp,-48
    80001ac6:	f406                	sd	ra,40(sp)
    80001ac8:	f022                	sd	s0,32(sp)
    80001aca:	ec26                	sd	s1,24(sp)
    80001acc:	e84a                	sd	s2,16(sp)
    80001ace:	e44e                	sd	s3,8(sp)
    80001ad0:	e052                	sd	s4,0(sp)
    80001ad2:	1800                	addi	s0,sp,48
    80001ad4:	892a                	mv	s2,a0
    80001ad6:	84ae                	mv	s1,a1
    80001ad8:	89b2                	mv	s3,a2
    80001ada:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	52a080e7          	jalr	1322(ra) # 80001006 <myproc>
  if(user_src){
    80001ae4:	c08d                	beqz	s1,80001b06 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ae6:	86d2                	mv	a3,s4
    80001ae8:	864e                	mv	a2,s3
    80001aea:	85ca                	mv	a1,s2
    80001aec:	6928                	ld	a0,80(a0)
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	268080e7          	jalr	616(ra) # 80000d56 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001af6:	70a2                	ld	ra,40(sp)
    80001af8:	7402                	ld	s0,32(sp)
    80001afa:	64e2                	ld	s1,24(sp)
    80001afc:	6942                	ld	s2,16(sp)
    80001afe:	69a2                	ld	s3,8(sp)
    80001b00:	6a02                	ld	s4,0(sp)
    80001b02:	6145                	addi	sp,sp,48
    80001b04:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b06:	000a061b          	sext.w	a2,s4
    80001b0a:	85ce                	mv	a1,s3
    80001b0c:	854a                	mv	a0,s2
    80001b0e:	ffffe097          	auipc	ra,0xffffe
    80001b12:	7ce080e7          	jalr	1998(ra) # 800002dc <memmove>
    return 0;
    80001b16:	8526                	mv	a0,s1
    80001b18:	bff9                	j	80001af6 <either_copyin+0x32>

0000000080001b1a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b1a:	715d                	addi	sp,sp,-80
    80001b1c:	e486                	sd	ra,72(sp)
    80001b1e:	e0a2                	sd	s0,64(sp)
    80001b20:	fc26                	sd	s1,56(sp)
    80001b22:	f84a                	sd	s2,48(sp)
    80001b24:	f44e                	sd	s3,40(sp)
    80001b26:	f052                	sd	s4,32(sp)
    80001b28:	ec56                	sd	s5,24(sp)
    80001b2a:	e85a                	sd	s6,16(sp)
    80001b2c:	e45e                	sd	s7,8(sp)
    80001b2e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b30:	00006517          	auipc	a0,0x6
    80001b34:	52850513          	addi	a0,a0,1320 # 80008058 <etext+0x58>
    80001b38:	00004097          	auipc	ra,0x4
    80001b3c:	292080e7          	jalr	658(ra) # 80005dca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b40:	00228497          	auipc	s1,0x228
    80001b44:	ab048493          	addi	s1,s1,-1360 # 802295f0 <proc+0x158>
    80001b48:	0022d917          	auipc	s2,0x22d
    80001b4c:	4a890913          	addi	s2,s2,1192 # 8022eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b50:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b52:	00006997          	auipc	s3,0x6
    80001b56:	6be98993          	addi	s3,s3,1726 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001b5a:	00006a97          	auipc	s5,0x6
    80001b5e:	6bea8a93          	addi	s5,s5,1726 # 80008218 <etext+0x218>
    printf("\n");
    80001b62:	00006a17          	auipc	s4,0x6
    80001b66:	4f6a0a13          	addi	s4,s4,1270 # 80008058 <etext+0x58>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6a:	00006b97          	auipc	s7,0x6
    80001b6e:	6e6b8b93          	addi	s7,s7,1766 # 80008250 <states.0>
    80001b72:	a00d                	j	80001b94 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b74:	ed86a583          	lw	a1,-296(a3)
    80001b78:	8556                	mv	a0,s5
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	250080e7          	jalr	592(ra) # 80005dca <printf>
    printf("\n");
    80001b82:	8552                	mv	a0,s4
    80001b84:	00004097          	auipc	ra,0x4
    80001b88:	246080e7          	jalr	582(ra) # 80005dca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8c:	16848493          	addi	s1,s1,360
    80001b90:	03248263          	beq	s1,s2,80001bb4 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b94:	86a6                	mv	a3,s1
    80001b96:	ec04a783          	lw	a5,-320(s1)
    80001b9a:	dbed                	beqz	a5,80001b8c <procdump+0x72>
      state = "???";
    80001b9c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b9e:	fcfb6be3          	bltu	s6,a5,80001b74 <procdump+0x5a>
    80001ba2:	02079713          	slli	a4,a5,0x20
    80001ba6:	01d75793          	srli	a5,a4,0x1d
    80001baa:	97de                	add	a5,a5,s7
    80001bac:	6390                	ld	a2,0(a5)
    80001bae:	f279                	bnez	a2,80001b74 <procdump+0x5a>
      state = "???";
    80001bb0:	864e                	mv	a2,s3
    80001bb2:	b7c9                	j	80001b74 <procdump+0x5a>
  }
}
    80001bb4:	60a6                	ld	ra,72(sp)
    80001bb6:	6406                	ld	s0,64(sp)
    80001bb8:	74e2                	ld	s1,56(sp)
    80001bba:	7942                	ld	s2,48(sp)
    80001bbc:	79a2                	ld	s3,40(sp)
    80001bbe:	7a02                	ld	s4,32(sp)
    80001bc0:	6ae2                	ld	s5,24(sp)
    80001bc2:	6b42                	ld	s6,16(sp)
    80001bc4:	6ba2                	ld	s7,8(sp)
    80001bc6:	6161                	addi	sp,sp,80
    80001bc8:	8082                	ret

0000000080001bca <swtch>:
    80001bca:	00153023          	sd	ra,0(a0)
    80001bce:	00253423          	sd	sp,8(a0)
    80001bd2:	e900                	sd	s0,16(a0)
    80001bd4:	ed04                	sd	s1,24(a0)
    80001bd6:	03253023          	sd	s2,32(a0)
    80001bda:	03353423          	sd	s3,40(a0)
    80001bde:	03453823          	sd	s4,48(a0)
    80001be2:	03553c23          	sd	s5,56(a0)
    80001be6:	05653023          	sd	s6,64(a0)
    80001bea:	05753423          	sd	s7,72(a0)
    80001bee:	05853823          	sd	s8,80(a0)
    80001bf2:	05953c23          	sd	s9,88(a0)
    80001bf6:	07a53023          	sd	s10,96(a0)
    80001bfa:	07b53423          	sd	s11,104(a0)
    80001bfe:	0005b083          	ld	ra,0(a1)
    80001c02:	0085b103          	ld	sp,8(a1)
    80001c06:	6980                	ld	s0,16(a1)
    80001c08:	6d84                	ld	s1,24(a1)
    80001c0a:	0205b903          	ld	s2,32(a1)
    80001c0e:	0285b983          	ld	s3,40(a1)
    80001c12:	0305ba03          	ld	s4,48(a1)
    80001c16:	0385ba83          	ld	s5,56(a1)
    80001c1a:	0405bb03          	ld	s6,64(a1)
    80001c1e:	0485bb83          	ld	s7,72(a1)
    80001c22:	0505bc03          	ld	s8,80(a1)
    80001c26:	0585bc83          	ld	s9,88(a1)
    80001c2a:	0605bd03          	ld	s10,96(a1)
    80001c2e:	0685bd83          	ld	s11,104(a1)
    80001c32:	8082                	ret

0000000080001c34 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c34:	1141                	addi	sp,sp,-16
    80001c36:	e406                	sd	ra,8(sp)
    80001c38:	e022                	sd	s0,0(sp)
    80001c3a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c3c:	00006597          	auipc	a1,0x6
    80001c40:	64458593          	addi	a1,a1,1604 # 80008280 <states.0+0x30>
    80001c44:	0022d517          	auipc	a0,0x22d
    80001c48:	25450513          	addi	a0,a0,596 # 8022ee98 <tickslock>
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	5dc080e7          	jalr	1500(ra) # 80006228 <initlock>
}
    80001c54:	60a2                	ld	ra,8(sp)
    80001c56:	6402                	ld	s0,0(sp)
    80001c58:	0141                	addi	sp,sp,16
    80001c5a:	8082                	ret

0000000080001c5c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c5c:	1141                	addi	sp,sp,-16
    80001c5e:	e422                	sd	s0,8(sp)
    80001c60:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c62:	00003797          	auipc	a5,0x3
    80001c66:	57e78793          	addi	a5,a5,1406 # 800051e0 <kernelvec>
    80001c6a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c6e:	6422                	ld	s0,8(sp)
    80001c70:	0141                	addi	sp,sp,16
    80001c72:	8082                	ret

0000000080001c74 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c74:	1141                	addi	sp,sp,-16
    80001c76:	e406                	sd	ra,8(sp)
    80001c78:	e022                	sd	s0,0(sp)
    80001c7a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c7c:	fffff097          	auipc	ra,0xfffff
    80001c80:	38a080e7          	jalr	906(ra) # 80001006 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c8e:	00005697          	auipc	a3,0x5
    80001c92:	37268693          	addi	a3,a3,882 # 80007000 <_trampoline>
    80001c96:	00005717          	auipc	a4,0x5
    80001c9a:	36a70713          	addi	a4,a4,874 # 80007000 <_trampoline>
    80001c9e:	8f15                	sub	a4,a4,a3
    80001ca0:	040007b7          	lui	a5,0x4000
    80001ca4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ca6:	07b2                	slli	a5,a5,0xc
    80001ca8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001caa:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cae:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb0:	18002673          	csrr	a2,satp
    80001cb4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cb6:	6d30                	ld	a2,88(a0)
    80001cb8:	6138                	ld	a4,64(a0)
    80001cba:	6585                	lui	a1,0x1
    80001cbc:	972e                	add	a4,a4,a1
    80001cbe:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc0:	6d38                	ld	a4,88(a0)
    80001cc2:	00000617          	auipc	a2,0x0
    80001cc6:	13860613          	addi	a2,a2,312 # 80001dfa <usertrap>
    80001cca:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ccc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cce:	8612                	mv	a2,tp
    80001cd0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cd6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cda:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cde:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ce4:	6f18                	ld	a4,24(a4)
    80001ce6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cea:	692c                	ld	a1,80(a0)
    80001cec:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cee:	00005717          	auipc	a4,0x5
    80001cf2:	3a270713          	addi	a4,a4,930 # 80007090 <userret>
    80001cf6:	8f15                	sub	a4,a4,a3
    80001cf8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cfa:	577d                	li	a4,-1
    80001cfc:	177e                	slli	a4,a4,0x3f
    80001cfe:	8dd9                	or	a1,a1,a4
    80001d00:	02000537          	lui	a0,0x2000
    80001d04:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d06:	0536                	slli	a0,a0,0xd
    80001d08:	9782                	jalr	a5
}
    80001d0a:	60a2                	ld	ra,8(sp)
    80001d0c:	6402                	ld	s0,0(sp)
    80001d0e:	0141                	addi	sp,sp,16
    80001d10:	8082                	ret

0000000080001d12 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d12:	1101                	addi	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d1c:	0022d497          	auipc	s1,0x22d
    80001d20:	17c48493          	addi	s1,s1,380 # 8022ee98 <tickslock>
    80001d24:	8526                	mv	a0,s1
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	592080e7          	jalr	1426(ra) # 800062b8 <acquire>
  ticks++;
    80001d2e:	00007517          	auipc	a0,0x7
    80001d32:	2ea50513          	addi	a0,a0,746 # 80009018 <ticks>
    80001d36:	411c                	lw	a5,0(a0)
    80001d38:	2785                	addiw	a5,a5,1
    80001d3a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	b1a080e7          	jalr	-1254(ra) # 80001856 <wakeup>
  release(&tickslock);
    80001d44:	8526                	mv	a0,s1
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	626080e7          	jalr	1574(ra) # 8000636c <release>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	64a2                	ld	s1,8(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret

0000000080001d58 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d58:	1101                	addi	sp,sp,-32
    80001d5a:	ec06                	sd	ra,24(sp)
    80001d5c:	e822                	sd	s0,16(sp)
    80001d5e:	e426                	sd	s1,8(sp)
    80001d60:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d62:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d66:	00074d63          	bltz	a4,80001d80 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d6a:	57fd                	li	a5,-1
    80001d6c:	17fe                	slli	a5,a5,0x3f
    80001d6e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d70:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d72:	06f70363          	beq	a4,a5,80001dd8 <devintr+0x80>
  }
}
    80001d76:	60e2                	ld	ra,24(sp)
    80001d78:	6442                	ld	s0,16(sp)
    80001d7a:	64a2                	ld	s1,8(sp)
    80001d7c:	6105                	addi	sp,sp,32
    80001d7e:	8082                	ret
     (scause & 0xff) == 9){
    80001d80:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d84:	46a5                	li	a3,9
    80001d86:	fed792e3          	bne	a5,a3,80001d6a <devintr+0x12>
    int irq = plic_claim();
    80001d8a:	00003097          	auipc	ra,0x3
    80001d8e:	55e080e7          	jalr	1374(ra) # 800052e8 <plic_claim>
    80001d92:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d94:	47a9                	li	a5,10
    80001d96:	02f50763          	beq	a0,a5,80001dc4 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d9a:	4785                	li	a5,1
    80001d9c:	02f50963          	beq	a0,a5,80001dce <devintr+0x76>
    return 1;
    80001da0:	4505                	li	a0,1
    } else if(irq){
    80001da2:	d8f1                	beqz	s1,80001d76 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001da4:	85a6                	mv	a1,s1
    80001da6:	00006517          	auipc	a0,0x6
    80001daa:	4e250513          	addi	a0,a0,1250 # 80008288 <states.0+0x38>
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	01c080e7          	jalr	28(ra) # 80005dca <printf>
      plic_complete(irq);
    80001db6:	8526                	mv	a0,s1
    80001db8:	00003097          	auipc	ra,0x3
    80001dbc:	554080e7          	jalr	1364(ra) # 8000530c <plic_complete>
    return 1;
    80001dc0:	4505                	li	a0,1
    80001dc2:	bf55                	j	80001d76 <devintr+0x1e>
      uartintr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	414080e7          	jalr	1044(ra) # 800061d8 <uartintr>
    80001dcc:	b7ed                	j	80001db6 <devintr+0x5e>
      virtio_disk_intr();
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	9ca080e7          	jalr	-1590(ra) # 80005798 <virtio_disk_intr>
    80001dd6:	b7c5                	j	80001db6 <devintr+0x5e>
    if(cpuid() == 0){
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	202080e7          	jalr	514(ra) # 80000fda <cpuid>
    80001de0:	c901                	beqz	a0,80001df0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001de2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001de6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001de8:	14479073          	csrw	sip,a5
    return 2;
    80001dec:	4509                	li	a0,2
    80001dee:	b761                	j	80001d76 <devintr+0x1e>
      clockintr();
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	f22080e7          	jalr	-222(ra) # 80001d12 <clockintr>
    80001df8:	b7ed                	j	80001de2 <devintr+0x8a>

0000000080001dfa <usertrap>:
{
    80001dfa:	7139                	addi	sp,sp,-64
    80001dfc:	fc06                	sd	ra,56(sp)
    80001dfe:	f822                	sd	s0,48(sp)
    80001e00:	f426                	sd	s1,40(sp)
    80001e02:	f04a                	sd	s2,32(sp)
    80001e04:	ec4e                	sd	s3,24(sp)
    80001e06:	e852                	sd	s4,16(sp)
    80001e08:	e456                	sd	s5,8(sp)
    80001e0a:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e10:	1007f793          	andi	a5,a5,256
    80001e14:	e7ad                	bnez	a5,80001e7e <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e16:	00003797          	auipc	a5,0x3
    80001e1a:	3ca78793          	addi	a5,a5,970 # 800051e0 <kernelvec>
    80001e1e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	1e4080e7          	jalr	484(ra) # 80001006 <myproc>
    80001e2a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e2c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	14102773          	csrr	a4,sepc
    80001e32:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e34:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e38:	47a1                	li	a5,8
    80001e3a:	06f71063          	bne	a4,a5,80001e9a <usertrap+0xa0>
    if(p->killed)
    80001e3e:	551c                	lw	a5,40(a0)
    80001e40:	e7b9                	bnez	a5,80001e8e <usertrap+0x94>
    p->trapframe->epc += 4;
    80001e42:	6cb8                	ld	a4,88(s1)
    80001e44:	6f1c                	ld	a5,24(a4)
    80001e46:	0791                	addi	a5,a5,4
    80001e48:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e52:	10079073          	csrw	sstatus,a5
    syscall();
    80001e56:	00000097          	auipc	ra,0x0
    80001e5a:	3b8080e7          	jalr	952(ra) # 8000220e <syscall>
  if(p->killed)
    80001e5e:	549c                	lw	a5,40(s1)
    80001e60:	14079863          	bnez	a5,80001fb0 <usertrap+0x1b6>
  usertrapret();
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e10080e7          	jalr	-496(ra) # 80001c74 <usertrapret>
}
    80001e6c:	70e2                	ld	ra,56(sp)
    80001e6e:	7442                	ld	s0,48(sp)
    80001e70:	74a2                	ld	s1,40(sp)
    80001e72:	7902                	ld	s2,32(sp)
    80001e74:	69e2                	ld	s3,24(sp)
    80001e76:	6a42                	ld	s4,16(sp)
    80001e78:	6aa2                	ld	s5,8(sp)
    80001e7a:	6121                	addi	sp,sp,64
    80001e7c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	42a50513          	addi	a0,a0,1066 # 800082a8 <states.0+0x58>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	efa080e7          	jalr	-262(ra) # 80005d80 <panic>
      exit(-1);
    80001e8e:	557d                	li	a0,-1
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	a96080e7          	jalr	-1386(ra) # 80001926 <exit>
    80001e98:	b76d                	j	80001e42 <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	ebe080e7          	jalr	-322(ra) # 80001d58 <devintr>
    80001ea2:	892a                	mv	s2,a0
    80001ea4:	10051363          	bnez	a0,80001faa <usertrap+0x1b0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea8:	14202773          	csrr	a4,scause
  else if(r_scause()== 15){ 
    80001eac:	47bd                	li	a5,15
    80001eae:	0cf71463          	bne	a4,a5,80001f76 <usertrap+0x17c>
    pagetable_t my_pagetable =p->pagetable;
    80001eb2:	0504b903          	ld	s2,80(s1)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eb6:	14302773          	csrr	a4,stval
    if (r_stval()>=MAXVA){
    80001eba:	57fd                	li	a5,-1
    80001ebc:	83e9                	srli	a5,a5,0x1a
    80001ebe:	08e7e563          	bltu	a5,a4,80001f48 <usertrap+0x14e>
    80001ec2:	143025f3          	csrr	a1,stval
    pte_t *my_pte = walk(my_pagetable, r_stval(), 0);
    80001ec6:	4601                	li	a2,0
    80001ec8:	854a                	mv	a0,s2
    80001eca:	ffffe097          	auipc	ra,0xffffe
    80001ece:	696080e7          	jalr	1686(ra) # 80000560 <walk>
    80001ed2:	89aa                	mv	s3,a0
    uint64 pa = PTE2PA(*my_pte);
    80001ed4:	00053903          	ld	s2,0(a0)
    if ((*my_pte&PTE_COW)){
    80001ed8:	10097793          	andi	a5,s2,256
    80001edc:	d3c9                	beqz	a5,80001e5e <usertrap+0x64>
      flags &= ~PTE_COW; 
    80001ede:	2ff97a93          	andi	s5,s2,767
    80001ee2:	004aea93          	ori	s5,s5,4
      if((mem = kalloc()) == 0){
    80001ee6:	ffffe097          	auipc	ra,0xffffe
    80001eea:	300080e7          	jalr	768(ra) # 800001e6 <kalloc>
    80001eee:	8a2a                	mv	s4,a0
    80001ef0:	c525                	beqz	a0,80001f58 <usertrap+0x15e>
    uint64 pa = PTE2PA(*my_pte);
    80001ef2:	00a95913          	srli	s2,s2,0xa
    80001ef6:	0932                	slli	s2,s2,0xc
      memmove(mem, (char*)pa, PGSIZE);
    80001ef8:	6605                	lui	a2,0x1
    80001efa:	85ca                	mv	a1,s2
    80001efc:	8552                	mv	a0,s4
    80001efe:	ffffe097          	auipc	ra,0xffffe
    80001f02:	3de080e7          	jalr	990(ra) # 800002dc <memmove>
      *my_pte = PA2PTE(mem) | flags;
    80001f06:	00ca5a13          	srli	s4,s4,0xc
    80001f0a:	0a2a                	slli	s4,s4,0xa
    80001f0c:	014aeab3          	or	s5,s5,s4
    80001f10:	0159b023          	sd	s5,0(s3)
      kfree((char*)pa); 
    80001f14:	854a                	mv	a0,s2
    80001f16:	ffffe097          	auipc	ra,0xffffe
    80001f1a:	106080e7          	jalr	262(ra) # 8000001c <kfree>
      if((*my_pte&PTE_COW)&&reference_counter[pa/PGSIZE]==1)
    80001f1e:	0009b783          	ld	a5,0(s3)
    80001f22:	1007f713          	andi	a4,a5,256
    80001f26:	cf01                	beqz	a4,80001f3e <usertrap+0x144>
    80001f28:	00a95913          	srli	s2,s2,0xa
    80001f2c:	00007717          	auipc	a4,0x7
    80001f30:	13c70713          	addi	a4,a4,316 # 80009068 <reference_counter>
    80001f34:	974a                	add	a4,a4,s2
    80001f36:	4314                	lw	a3,0(a4)
    80001f38:	4705                	li	a4,1
    80001f3a:	02e68763          	beq	a3,a4,80001f68 <usertrap+0x16e>
      p->trapframe->epc = r_sepc(); 
    80001f3e:	6cbc                	ld	a5,88(s1)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f40:	14102773          	csrr	a4,sepc
    80001f44:	ef98                	sd	a4,24(a5)
    80001f46:	bf21                	j	80001e5e <usertrap+0x64>
      p->killed = 1;
    80001f48:	4785                	li	a5,1
    80001f4a:	d49c                	sw	a5,40(s1)
      exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	9d8080e7          	jalr	-1576(ra) # 80001926 <exit>
    80001f56:	b7b5                	j	80001ec2 <usertrap+0xc8>
        p->killed=1;
    80001f58:	4785                	li	a5,1
    80001f5a:	d49c                	sw	a5,40(s1)
        exit(-1);
    80001f5c:	557d                	li	a0,-1
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	9c8080e7          	jalr	-1592(ra) # 80001926 <exit>
    80001f66:	b771                	j	80001ef2 <usertrap+0xf8>
      *my_pte &= ~PTE_COW; 
    80001f68:	eff7f793          	andi	a5,a5,-257
      *my_pte |= PTE_W;
    80001f6c:	0047e793          	ori	a5,a5,4
    80001f70:	00f9b023          	sd	a5,0(s3)
    80001f74:	b7e9                	j	80001f3e <usertrap+0x144>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f76:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f7a:	5890                	lw	a2,48(s1)
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	34c50513          	addi	a0,a0,844 # 800082c8 <states.0+0x78>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	e46080e7          	jalr	-442(ra) # 80005dca <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f90:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	36450513          	addi	a0,a0,868 # 800082f8 <states.0+0xa8>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	e2e080e7          	jalr	-466(ra) # 80005dca <printf>
    p->killed = 1;
    80001fa4:	4785                	li	a5,1
    80001fa6:	d49c                	sw	a5,40(s1)
  if(p->killed)
    80001fa8:	a029                	j	80001fb2 <usertrap+0x1b8>
    80001faa:	549c                	lw	a5,40(s1)
    80001fac:	cb81                	beqz	a5,80001fbc <usertrap+0x1c2>
    80001fae:	a011                	j	80001fb2 <usertrap+0x1b8>
    80001fb0:	4901                	li	s2,0
    exit(-1);
    80001fb2:	557d                	li	a0,-1
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	972080e7          	jalr	-1678(ra) # 80001926 <exit>
  if(which_dev == 2)
    80001fbc:	4789                	li	a5,2
    80001fbe:	eaf913e3          	bne	s2,a5,80001e64 <usertrap+0x6a>
    yield();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	6cc080e7          	jalr	1740(ra) # 8000168e <yield>
    80001fca:	bd69                	j	80001e64 <usertrap+0x6a>

0000000080001fcc <kerneltrap>:
{
    80001fcc:	7179                	addi	sp,sp,-48
    80001fce:	f406                	sd	ra,40(sp)
    80001fd0:	f022                	sd	s0,32(sp)
    80001fd2:	ec26                	sd	s1,24(sp)
    80001fd4:	e84a                	sd	s2,16(sp)
    80001fd6:	e44e                	sd	s3,8(sp)
    80001fd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fe2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fe6:	1004f793          	andi	a5,s1,256
    80001fea:	cb85                	beqz	a5,8000201a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ff0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ff2:	ef85                	bnez	a5,8000202a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	d64080e7          	jalr	-668(ra) # 80001d58 <devintr>
    80001ffc:	cd1d                	beqz	a0,8000203a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ffe:	4789                	li	a5,2
    80002000:	06f50a63          	beq	a0,a5,80002074 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002004:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002008:	10049073          	csrw	sstatus,s1
}
    8000200c:	70a2                	ld	ra,40(sp)
    8000200e:	7402                	ld	s0,32(sp)
    80002010:	64e2                	ld	s1,24(sp)
    80002012:	6942                	ld	s2,16(sp)
    80002014:	69a2                	ld	s3,8(sp)
    80002016:	6145                	addi	sp,sp,48
    80002018:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000201a:	00006517          	auipc	a0,0x6
    8000201e:	2fe50513          	addi	a0,a0,766 # 80008318 <states.0+0xc8>
    80002022:	00004097          	auipc	ra,0x4
    80002026:	d5e080e7          	jalr	-674(ra) # 80005d80 <panic>
    panic("kerneltrap: interrupts enabled");
    8000202a:	00006517          	auipc	a0,0x6
    8000202e:	31650513          	addi	a0,a0,790 # 80008340 <states.0+0xf0>
    80002032:	00004097          	auipc	ra,0x4
    80002036:	d4e080e7          	jalr	-690(ra) # 80005d80 <panic>
    printf("scause %p\n", scause);
    8000203a:	85ce                	mv	a1,s3
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	32450513          	addi	a0,a0,804 # 80008360 <states.0+0x110>
    80002044:	00004097          	auipc	ra,0x4
    80002048:	d86080e7          	jalr	-634(ra) # 80005dca <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000204c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002050:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002054:	00006517          	auipc	a0,0x6
    80002058:	31c50513          	addi	a0,a0,796 # 80008370 <states.0+0x120>
    8000205c:	00004097          	auipc	ra,0x4
    80002060:	d6e080e7          	jalr	-658(ra) # 80005dca <printf>
    panic("kerneltrap");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	32450513          	addi	a0,a0,804 # 80008388 <states.0+0x138>
    8000206c:	00004097          	auipc	ra,0x4
    80002070:	d14080e7          	jalr	-748(ra) # 80005d80 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	f92080e7          	jalr	-110(ra) # 80001006 <myproc>
    8000207c:	d541                	beqz	a0,80002004 <kerneltrap+0x38>
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	f88080e7          	jalr	-120(ra) # 80001006 <myproc>
    80002086:	4d18                	lw	a4,24(a0)
    80002088:	4791                	li	a5,4
    8000208a:	f6f71de3          	bne	a4,a5,80002004 <kerneltrap+0x38>
    yield();
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	600080e7          	jalr	1536(ra) # 8000168e <yield>
    80002096:	b7bd                	j	80002004 <kerneltrap+0x38>

0000000080002098 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	e426                	sd	s1,8(sp)
    800020a0:	1000                	addi	s0,sp,32
    800020a2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	f62080e7          	jalr	-158(ra) # 80001006 <myproc>
  switch (n) {
    800020ac:	4795                	li	a5,5
    800020ae:	0497e163          	bltu	a5,s1,800020f0 <argraw+0x58>
    800020b2:	048a                	slli	s1,s1,0x2
    800020b4:	00006717          	auipc	a4,0x6
    800020b8:	30c70713          	addi	a4,a4,780 # 800083c0 <states.0+0x170>
    800020bc:	94ba                	add	s1,s1,a4
    800020be:	409c                	lw	a5,0(s1)
    800020c0:	97ba                	add	a5,a5,a4
    800020c2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020c4:	6d3c                	ld	a5,88(a0)
    800020c6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret
    return p->trapframe->a1;
    800020d2:	6d3c                	ld	a5,88(a0)
    800020d4:	7fa8                	ld	a0,120(a5)
    800020d6:	bfcd                	j	800020c8 <argraw+0x30>
    return p->trapframe->a2;
    800020d8:	6d3c                	ld	a5,88(a0)
    800020da:	63c8                	ld	a0,128(a5)
    800020dc:	b7f5                	j	800020c8 <argraw+0x30>
    return p->trapframe->a3;
    800020de:	6d3c                	ld	a5,88(a0)
    800020e0:	67c8                	ld	a0,136(a5)
    800020e2:	b7dd                	j	800020c8 <argraw+0x30>
    return p->trapframe->a4;
    800020e4:	6d3c                	ld	a5,88(a0)
    800020e6:	6bc8                	ld	a0,144(a5)
    800020e8:	b7c5                	j	800020c8 <argraw+0x30>
    return p->trapframe->a5;
    800020ea:	6d3c                	ld	a5,88(a0)
    800020ec:	6fc8                	ld	a0,152(a5)
    800020ee:	bfe9                	j	800020c8 <argraw+0x30>
  panic("argraw");
    800020f0:	00006517          	auipc	a0,0x6
    800020f4:	2a850513          	addi	a0,a0,680 # 80008398 <states.0+0x148>
    800020f8:	00004097          	auipc	ra,0x4
    800020fc:	c88080e7          	jalr	-888(ra) # 80005d80 <panic>

0000000080002100 <fetchaddr>:
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	e04a                	sd	s2,0(sp)
    8000210a:	1000                	addi	s0,sp,32
    8000210c:	84aa                	mv	s1,a0
    8000210e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	ef6080e7          	jalr	-266(ra) # 80001006 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002118:	653c                	ld	a5,72(a0)
    8000211a:	02f4f863          	bgeu	s1,a5,8000214a <fetchaddr+0x4a>
    8000211e:	00848713          	addi	a4,s1,8
    80002122:	02e7e663          	bltu	a5,a4,8000214e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002126:	46a1                	li	a3,8
    80002128:	8626                	mv	a2,s1
    8000212a:	85ca                	mv	a1,s2
    8000212c:	6928                	ld	a0,80(a0)
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	c28080e7          	jalr	-984(ra) # 80000d56 <copyin>
    80002136:	00a03533          	snez	a0,a0
    8000213a:	40a00533          	neg	a0,a0
}
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	64a2                	ld	s1,8(sp)
    80002144:	6902                	ld	s2,0(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret
    return -1;
    8000214a:	557d                	li	a0,-1
    8000214c:	bfcd                	j	8000213e <fetchaddr+0x3e>
    8000214e:	557d                	li	a0,-1
    80002150:	b7fd                	j	8000213e <fetchaddr+0x3e>

0000000080002152 <fetchstr>:
{
    80002152:	7179                	addi	sp,sp,-48
    80002154:	f406                	sd	ra,40(sp)
    80002156:	f022                	sd	s0,32(sp)
    80002158:	ec26                	sd	s1,24(sp)
    8000215a:	e84a                	sd	s2,16(sp)
    8000215c:	e44e                	sd	s3,8(sp)
    8000215e:	1800                	addi	s0,sp,48
    80002160:	892a                	mv	s2,a0
    80002162:	84ae                	mv	s1,a1
    80002164:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	ea0080e7          	jalr	-352(ra) # 80001006 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000216e:	86ce                	mv	a3,s3
    80002170:	864a                	mv	a2,s2
    80002172:	85a6                	mv	a1,s1
    80002174:	6928                	ld	a0,80(a0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	c6e080e7          	jalr	-914(ra) # 80000de4 <copyinstr>
  if(err < 0)
    8000217e:	00054763          	bltz	a0,8000218c <fetchstr+0x3a>
  return strlen(buf);
    80002182:	8526                	mv	a0,s1
    80002184:	ffffe097          	auipc	ra,0xffffe
    80002188:	278080e7          	jalr	632(ra) # 800003fc <strlen>
}
    8000218c:	70a2                	ld	ra,40(sp)
    8000218e:	7402                	ld	s0,32(sp)
    80002190:	64e2                	ld	s1,24(sp)
    80002192:	6942                	ld	s2,16(sp)
    80002194:	69a2                	ld	s3,8(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret

000000008000219a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	1000                	addi	s0,sp,32
    800021a4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	ef2080e7          	jalr	-270(ra) # 80002098 <argraw>
    800021ae:	c088                	sw	a0,0(s1)
  return 0;
}
    800021b0:	4501                	li	a0,0
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	64a2                	ld	s1,8(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret

00000000800021bc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021bc:	1101                	addi	sp,sp,-32
    800021be:	ec06                	sd	ra,24(sp)
    800021c0:	e822                	sd	s0,16(sp)
    800021c2:	e426                	sd	s1,8(sp)
    800021c4:	1000                	addi	s0,sp,32
    800021c6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	ed0080e7          	jalr	-304(ra) # 80002098 <argraw>
    800021d0:	e088                	sd	a0,0(s1)
  return 0;
}
    800021d2:	4501                	li	a0,0
    800021d4:	60e2                	ld	ra,24(sp)
    800021d6:	6442                	ld	s0,16(sp)
    800021d8:	64a2                	ld	s1,8(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	e426                	sd	s1,8(sp)
    800021e6:	e04a                	sd	s2,0(sp)
    800021e8:	1000                	addi	s0,sp,32
    800021ea:	84ae                	mv	s1,a1
    800021ec:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	eaa080e7          	jalr	-342(ra) # 80002098 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021f6:	864a                	mv	a2,s2
    800021f8:	85a6                	mv	a1,s1
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	f58080e7          	jalr	-168(ra) # 80002152 <fetchstr>
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6902                	ld	s2,0(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret

000000008000220e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000220e:	1101                	addi	sp,sp,-32
    80002210:	ec06                	sd	ra,24(sp)
    80002212:	e822                	sd	s0,16(sp)
    80002214:	e426                	sd	s1,8(sp)
    80002216:	e04a                	sd	s2,0(sp)
    80002218:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	dec080e7          	jalr	-532(ra) # 80001006 <myproc>
    80002222:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002224:	05853903          	ld	s2,88(a0)
    80002228:	0a893783          	ld	a5,168(s2)
    8000222c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002230:	37fd                	addiw	a5,a5,-1
    80002232:	4751                	li	a4,20
    80002234:	00f76f63          	bltu	a4,a5,80002252 <syscall+0x44>
    80002238:	00369713          	slli	a4,a3,0x3
    8000223c:	00006797          	auipc	a5,0x6
    80002240:	19c78793          	addi	a5,a5,412 # 800083d8 <syscalls>
    80002244:	97ba                	add	a5,a5,a4
    80002246:	639c                	ld	a5,0(a5)
    80002248:	c789                	beqz	a5,80002252 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000224a:	9782                	jalr	a5
    8000224c:	06a93823          	sd	a0,112(s2)
    80002250:	a839                	j	8000226e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002252:	15848613          	addi	a2,s1,344
    80002256:	588c                	lw	a1,48(s1)
    80002258:	00006517          	auipc	a0,0x6
    8000225c:	14850513          	addi	a0,a0,328 # 800083a0 <states.0+0x150>
    80002260:	00004097          	auipc	ra,0x4
    80002264:	b6a080e7          	jalr	-1174(ra) # 80005dca <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002268:	6cbc                	ld	a5,88(s1)
    8000226a:	577d                	li	a4,-1
    8000226c:	fbb8                	sd	a4,112(a5)
  }
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	64a2                	ld	s1,8(sp)
    80002274:	6902                	ld	s2,0(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002282:	fec40593          	addi	a1,s0,-20
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	f12080e7          	jalr	-238(ra) # 8000219a <argint>
    return -1;
    80002290:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002292:	00054963          	bltz	a0,800022a4 <sys_exit+0x2a>
  exit(n);
    80002296:	fec42503          	lw	a0,-20(s0)
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	68c080e7          	jalr	1676(ra) # 80001926 <exit>
  return 0;  // not reached
    800022a2:	4781                	li	a5,0
}
    800022a4:	853e                	mv	a0,a5
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <sys_getpid>:

uint64
sys_getpid(void)
{
    800022ae:	1141                	addi	sp,sp,-16
    800022b0:	e406                	sd	ra,8(sp)
    800022b2:	e022                	sd	s0,0(sp)
    800022b4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	d50080e7          	jalr	-688(ra) # 80001006 <myproc>
}
    800022be:	5908                	lw	a0,48(a0)
    800022c0:	60a2                	ld	ra,8(sp)
    800022c2:	6402                	ld	s0,0(sp)
    800022c4:	0141                	addi	sp,sp,16
    800022c6:	8082                	ret

00000000800022c8 <sys_fork>:

uint64
sys_fork(void)
{
    800022c8:	1141                	addi	sp,sp,-16
    800022ca:	e406                	sd	ra,8(sp)
    800022cc:	e022                	sd	s0,0(sp)
    800022ce:	0800                	addi	s0,sp,16
  return fork();
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	108080e7          	jalr	264(ra) # 800013d8 <fork>
}
    800022d8:	60a2                	ld	ra,8(sp)
    800022da:	6402                	ld	s0,0(sp)
    800022dc:	0141                	addi	sp,sp,16
    800022de:	8082                	ret

00000000800022e0 <sys_wait>:

uint64
sys_wait(void)
{
    800022e0:	1101                	addi	sp,sp,-32
    800022e2:	ec06                	sd	ra,24(sp)
    800022e4:	e822                	sd	s0,16(sp)
    800022e6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022e8:	fe840593          	addi	a1,s0,-24
    800022ec:	4501                	li	a0,0
    800022ee:	00000097          	auipc	ra,0x0
    800022f2:	ece080e7          	jalr	-306(ra) # 800021bc <argaddr>
    800022f6:	87aa                	mv	a5,a0
    return -1;
    800022f8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022fa:	0007c863          	bltz	a5,8000230a <sys_wait+0x2a>
  return wait(p);
    800022fe:	fe843503          	ld	a0,-24(s0)
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	42c080e7          	jalr	1068(ra) # 8000172e <wait>
}
    8000230a:	60e2                	ld	ra,24(sp)
    8000230c:	6442                	ld	s0,16(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002312:	7179                	addi	sp,sp,-48
    80002314:	f406                	sd	ra,40(sp)
    80002316:	f022                	sd	s0,32(sp)
    80002318:	ec26                	sd	s1,24(sp)
    8000231a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000231c:	fdc40593          	addi	a1,s0,-36
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	e78080e7          	jalr	-392(ra) # 8000219a <argint>
    8000232a:	87aa                	mv	a5,a0
    return -1;
    8000232c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000232e:	0207c063          	bltz	a5,8000234e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	cd4080e7          	jalr	-812(ra) # 80001006 <myproc>
    8000233a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000233c:	fdc42503          	lw	a0,-36(s0)
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	020080e7          	jalr	32(ra) # 80001360 <growproc>
    80002348:	00054863          	bltz	a0,80002358 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000234c:	8526                	mv	a0,s1
}
    8000234e:	70a2                	ld	ra,40(sp)
    80002350:	7402                	ld	s0,32(sp)
    80002352:	64e2                	ld	s1,24(sp)
    80002354:	6145                	addi	sp,sp,48
    80002356:	8082                	ret
    return -1;
    80002358:	557d                	li	a0,-1
    8000235a:	bfd5                	j	8000234e <sys_sbrk+0x3c>

000000008000235c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000235c:	7139                	addi	sp,sp,-64
    8000235e:	fc06                	sd	ra,56(sp)
    80002360:	f822                	sd	s0,48(sp)
    80002362:	f426                	sd	s1,40(sp)
    80002364:	f04a                	sd	s2,32(sp)
    80002366:	ec4e                	sd	s3,24(sp)
    80002368:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000236a:	fcc40593          	addi	a1,s0,-52
    8000236e:	4501                	li	a0,0
    80002370:	00000097          	auipc	ra,0x0
    80002374:	e2a080e7          	jalr	-470(ra) # 8000219a <argint>
    return -1;
    80002378:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000237a:	06054563          	bltz	a0,800023e4 <sys_sleep+0x88>
  acquire(&tickslock);
    8000237e:	0022d517          	auipc	a0,0x22d
    80002382:	b1a50513          	addi	a0,a0,-1254 # 8022ee98 <tickslock>
    80002386:	00004097          	auipc	ra,0x4
    8000238a:	f32080e7          	jalr	-206(ra) # 800062b8 <acquire>
  ticks0 = ticks;
    8000238e:	00007917          	auipc	s2,0x7
    80002392:	c8a92903          	lw	s2,-886(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002396:	fcc42783          	lw	a5,-52(s0)
    8000239a:	cf85                	beqz	a5,800023d2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000239c:	0022d997          	auipc	s3,0x22d
    800023a0:	afc98993          	addi	s3,s3,-1284 # 8022ee98 <tickslock>
    800023a4:	00007497          	auipc	s1,0x7
    800023a8:	c7448493          	addi	s1,s1,-908 # 80009018 <ticks>
    if(myproc()->killed){
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	c5a080e7          	jalr	-934(ra) # 80001006 <myproc>
    800023b4:	551c                	lw	a5,40(a0)
    800023b6:	ef9d                	bnez	a5,800023f4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023b8:	85ce                	mv	a1,s3
    800023ba:	8526                	mv	a0,s1
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	30e080e7          	jalr	782(ra) # 800016ca <sleep>
  while(ticks - ticks0 < n){
    800023c4:	409c                	lw	a5,0(s1)
    800023c6:	412787bb          	subw	a5,a5,s2
    800023ca:	fcc42703          	lw	a4,-52(s0)
    800023ce:	fce7efe3          	bltu	a5,a4,800023ac <sys_sleep+0x50>
  }
  release(&tickslock);
    800023d2:	0022d517          	auipc	a0,0x22d
    800023d6:	ac650513          	addi	a0,a0,-1338 # 8022ee98 <tickslock>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	f92080e7          	jalr	-110(ra) # 8000636c <release>
  return 0;
    800023e2:	4781                	li	a5,0
}
    800023e4:	853e                	mv	a0,a5
    800023e6:	70e2                	ld	ra,56(sp)
    800023e8:	7442                	ld	s0,48(sp)
    800023ea:	74a2                	ld	s1,40(sp)
    800023ec:	7902                	ld	s2,32(sp)
    800023ee:	69e2                	ld	s3,24(sp)
    800023f0:	6121                	addi	sp,sp,64
    800023f2:	8082                	ret
      release(&tickslock);
    800023f4:	0022d517          	auipc	a0,0x22d
    800023f8:	aa450513          	addi	a0,a0,-1372 # 8022ee98 <tickslock>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	f70080e7          	jalr	-144(ra) # 8000636c <release>
      return -1;
    80002404:	57fd                	li	a5,-1
    80002406:	bff9                	j	800023e4 <sys_sleep+0x88>

0000000080002408 <sys_kill>:

uint64
sys_kill(void)
{
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002410:	fec40593          	addi	a1,s0,-20
    80002414:	4501                	li	a0,0
    80002416:	00000097          	auipc	ra,0x0
    8000241a:	d84080e7          	jalr	-636(ra) # 8000219a <argint>
    8000241e:	87aa                	mv	a5,a0
    return -1;
    80002420:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002422:	0007c863          	bltz	a5,80002432 <sys_kill+0x2a>
  return kill(pid);
    80002426:	fec42503          	lw	a0,-20(s0)
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	5d2080e7          	jalr	1490(ra) # 800019fc <kill>
}
    80002432:	60e2                	ld	ra,24(sp)
    80002434:	6442                	ld	s0,16(sp)
    80002436:	6105                	addi	sp,sp,32
    80002438:	8082                	ret

000000008000243a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000243a:	1101                	addi	sp,sp,-32
    8000243c:	ec06                	sd	ra,24(sp)
    8000243e:	e822                	sd	s0,16(sp)
    80002440:	e426                	sd	s1,8(sp)
    80002442:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002444:	0022d517          	auipc	a0,0x22d
    80002448:	a5450513          	addi	a0,a0,-1452 # 8022ee98 <tickslock>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	e6c080e7          	jalr	-404(ra) # 800062b8 <acquire>
  xticks = ticks;
    80002454:	00007497          	auipc	s1,0x7
    80002458:	bc44a483          	lw	s1,-1084(s1) # 80009018 <ticks>
  release(&tickslock);
    8000245c:	0022d517          	auipc	a0,0x22d
    80002460:	a3c50513          	addi	a0,a0,-1476 # 8022ee98 <tickslock>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	f08080e7          	jalr	-248(ra) # 8000636c <release>
  return xticks;
}
    8000246c:	02049513          	slli	a0,s1,0x20
    80002470:	9101                	srli	a0,a0,0x20
    80002472:	60e2                	ld	ra,24(sp)
    80002474:	6442                	ld	s0,16(sp)
    80002476:	64a2                	ld	s1,8(sp)
    80002478:	6105                	addi	sp,sp,32
    8000247a:	8082                	ret

000000008000247c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	e052                	sd	s4,0(sp)
    8000248a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000248c:	00006597          	auipc	a1,0x6
    80002490:	ffc58593          	addi	a1,a1,-4 # 80008488 <syscalls+0xb0>
    80002494:	0022d517          	auipc	a0,0x22d
    80002498:	a1c50513          	addi	a0,a0,-1508 # 8022eeb0 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	d8c080e7          	jalr	-628(ra) # 80006228 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024a4:	00235797          	auipc	a5,0x235
    800024a8:	a0c78793          	addi	a5,a5,-1524 # 80236eb0 <bcache+0x8000>
    800024ac:	00235717          	auipc	a4,0x235
    800024b0:	c6c70713          	addi	a4,a4,-916 # 80237118 <bcache+0x8268>
    800024b4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024b8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024bc:	0022d497          	auipc	s1,0x22d
    800024c0:	a0c48493          	addi	s1,s1,-1524 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    800024c4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024c6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024c8:	00006a17          	auipc	s4,0x6
    800024cc:	fc8a0a13          	addi	s4,s4,-56 # 80008490 <syscalls+0xb8>
    b->next = bcache.head.next;
    800024d0:	2b893783          	ld	a5,696(s2)
    800024d4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024d6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024da:	85d2                	mv	a1,s4
    800024dc:	01048513          	addi	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	4c2080e7          	jalr	1218(ra) # 800039a2 <initsleeplock>
    bcache.head.next->prev = b;
    800024e8:	2b893783          	ld	a5,696(s2)
    800024ec:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024ee:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f2:	45848493          	addi	s1,s1,1112
    800024f6:	fd349de3          	bne	s1,s3,800024d0 <binit+0x54>
  }
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6a02                	ld	s4,0(sp)
    80002506:	6145                	addi	sp,sp,48
    80002508:	8082                	ret

000000008000250a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000250a:	7179                	addi	sp,sp,-48
    8000250c:	f406                	sd	ra,40(sp)
    8000250e:	f022                	sd	s0,32(sp)
    80002510:	ec26                	sd	s1,24(sp)
    80002512:	e84a                	sd	s2,16(sp)
    80002514:	e44e                	sd	s3,8(sp)
    80002516:	1800                	addi	s0,sp,48
    80002518:	892a                	mv	s2,a0
    8000251a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000251c:	0022d517          	auipc	a0,0x22d
    80002520:	99450513          	addi	a0,a0,-1644 # 8022eeb0 <bcache>
    80002524:	00004097          	auipc	ra,0x4
    80002528:	d94080e7          	jalr	-620(ra) # 800062b8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000252c:	00235497          	auipc	s1,0x235
    80002530:	c3c4b483          	ld	s1,-964(s1) # 80237168 <bcache+0x82b8>
    80002534:	00235797          	auipc	a5,0x235
    80002538:	be478793          	addi	a5,a5,-1052 # 80237118 <bcache+0x8268>
    8000253c:	02f48f63          	beq	s1,a5,8000257a <bread+0x70>
    80002540:	873e                	mv	a4,a5
    80002542:	a021                	j	8000254a <bread+0x40>
    80002544:	68a4                	ld	s1,80(s1)
    80002546:	02e48a63          	beq	s1,a4,8000257a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000254a:	449c                	lw	a5,8(s1)
    8000254c:	ff279ce3          	bne	a5,s2,80002544 <bread+0x3a>
    80002550:	44dc                	lw	a5,12(s1)
    80002552:	ff3799e3          	bne	a5,s3,80002544 <bread+0x3a>
      b->refcnt++;
    80002556:	40bc                	lw	a5,64(s1)
    80002558:	2785                	addiw	a5,a5,1
    8000255a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255c:	0022d517          	auipc	a0,0x22d
    80002560:	95450513          	addi	a0,a0,-1708 # 8022eeb0 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	e08080e7          	jalr	-504(ra) # 8000636c <release>
      acquiresleep(&b->lock);
    8000256c:	01048513          	addi	a0,s1,16
    80002570:	00001097          	auipc	ra,0x1
    80002574:	46c080e7          	jalr	1132(ra) # 800039dc <acquiresleep>
      return b;
    80002578:	a8b9                	j	800025d6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257a:	00235497          	auipc	s1,0x235
    8000257e:	be64b483          	ld	s1,-1050(s1) # 80237160 <bcache+0x82b0>
    80002582:	00235797          	auipc	a5,0x235
    80002586:	b9678793          	addi	a5,a5,-1130 # 80237118 <bcache+0x8268>
    8000258a:	00f48863          	beq	s1,a5,8000259a <bread+0x90>
    8000258e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002590:	40bc                	lw	a5,64(s1)
    80002592:	cf81                	beqz	a5,800025aa <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002594:	64a4                	ld	s1,72(s1)
    80002596:	fee49de3          	bne	s1,a4,80002590 <bread+0x86>
  panic("bget: no buffers");
    8000259a:	00006517          	auipc	a0,0x6
    8000259e:	efe50513          	addi	a0,a0,-258 # 80008498 <syscalls+0xc0>
    800025a2:	00003097          	auipc	ra,0x3
    800025a6:	7de080e7          	jalr	2014(ra) # 80005d80 <panic>
      b->dev = dev;
    800025aa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ae:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025b2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025b6:	4785                	li	a5,1
    800025b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ba:	0022d517          	auipc	a0,0x22d
    800025be:	8f650513          	addi	a0,a0,-1802 # 8022eeb0 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	daa080e7          	jalr	-598(ra) # 8000636c <release>
      acquiresleep(&b->lock);
    800025ca:	01048513          	addi	a0,s1,16
    800025ce:	00001097          	auipc	ra,0x1
    800025d2:	40e080e7          	jalr	1038(ra) # 800039dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025d6:	409c                	lw	a5,0(s1)
    800025d8:	cb89                	beqz	a5,800025ea <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025da:	8526                	mv	a0,s1
    800025dc:	70a2                	ld	ra,40(sp)
    800025de:	7402                	ld	s0,32(sp)
    800025e0:	64e2                	ld	s1,24(sp)
    800025e2:	6942                	ld	s2,16(sp)
    800025e4:	69a2                	ld	s3,8(sp)
    800025e6:	6145                	addi	sp,sp,48
    800025e8:	8082                	ret
    virtio_disk_rw(b, 0);
    800025ea:	4581                	li	a1,0
    800025ec:	8526                	mv	a0,s1
    800025ee:	00003097          	auipc	ra,0x3
    800025f2:	f24080e7          	jalr	-220(ra) # 80005512 <virtio_disk_rw>
    b->valid = 1;
    800025f6:	4785                	li	a5,1
    800025f8:	c09c                	sw	a5,0(s1)
  return b;
    800025fa:	b7c5                	j	800025da <bread+0xd0>

00000000800025fc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025fc:	1101                	addi	sp,sp,-32
    800025fe:	ec06                	sd	ra,24(sp)
    80002600:	e822                	sd	s0,16(sp)
    80002602:	e426                	sd	s1,8(sp)
    80002604:	1000                	addi	s0,sp,32
    80002606:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002608:	0541                	addi	a0,a0,16
    8000260a:	00001097          	auipc	ra,0x1
    8000260e:	46c080e7          	jalr	1132(ra) # 80003a76 <holdingsleep>
    80002612:	cd01                	beqz	a0,8000262a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002614:	4585                	li	a1,1
    80002616:	8526                	mv	a0,s1
    80002618:	00003097          	auipc	ra,0x3
    8000261c:	efa080e7          	jalr	-262(ra) # 80005512 <virtio_disk_rw>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret
    panic("bwrite");
    8000262a:	00006517          	auipc	a0,0x6
    8000262e:	e8650513          	addi	a0,a0,-378 # 800084b0 <syscalls+0xd8>
    80002632:	00003097          	auipc	ra,0x3
    80002636:	74e080e7          	jalr	1870(ra) # 80005d80 <panic>

000000008000263a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000263a:	1101                	addi	sp,sp,-32
    8000263c:	ec06                	sd	ra,24(sp)
    8000263e:	e822                	sd	s0,16(sp)
    80002640:	e426                	sd	s1,8(sp)
    80002642:	e04a                	sd	s2,0(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002648:	01050913          	addi	s2,a0,16
    8000264c:	854a                	mv	a0,s2
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	428080e7          	jalr	1064(ra) # 80003a76 <holdingsleep>
    80002656:	c92d                	beqz	a0,800026c8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002658:	854a                	mv	a0,s2
    8000265a:	00001097          	auipc	ra,0x1
    8000265e:	3d8080e7          	jalr	984(ra) # 80003a32 <releasesleep>

  acquire(&bcache.lock);
    80002662:	0022d517          	auipc	a0,0x22d
    80002666:	84e50513          	addi	a0,a0,-1970 # 8022eeb0 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	c4e080e7          	jalr	-946(ra) # 800062b8 <acquire>
  b->refcnt--;
    80002672:	40bc                	lw	a5,64(s1)
    80002674:	37fd                	addiw	a5,a5,-1
    80002676:	0007871b          	sext.w	a4,a5
    8000267a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000267c:	eb05                	bnez	a4,800026ac <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000267e:	68bc                	ld	a5,80(s1)
    80002680:	64b8                	ld	a4,72(s1)
    80002682:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002684:	64bc                	ld	a5,72(s1)
    80002686:	68b8                	ld	a4,80(s1)
    80002688:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000268a:	00235797          	auipc	a5,0x235
    8000268e:	82678793          	addi	a5,a5,-2010 # 80236eb0 <bcache+0x8000>
    80002692:	2b87b703          	ld	a4,696(a5)
    80002696:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002698:	00235717          	auipc	a4,0x235
    8000269c:	a8070713          	addi	a4,a4,-1408 # 80237118 <bcache+0x8268>
    800026a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a2:	2b87b703          	ld	a4,696(a5)
    800026a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026a8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ac:	0022d517          	auipc	a0,0x22d
    800026b0:	80450513          	addi	a0,a0,-2044 # 8022eeb0 <bcache>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	cb8080e7          	jalr	-840(ra) # 8000636c <release>
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6902                	ld	s2,0(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("brelse");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	df050513          	addi	a0,a0,-528 # 800084b8 <syscalls+0xe0>
    800026d0:	00003097          	auipc	ra,0x3
    800026d4:	6b0080e7          	jalr	1712(ra) # 80005d80 <panic>

00000000800026d8 <bpin>:

void
bpin(struct buf *b) {
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e4:	0022c517          	auipc	a0,0x22c
    800026e8:	7cc50513          	addi	a0,a0,1996 # 8022eeb0 <bcache>
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	bcc080e7          	jalr	-1076(ra) # 800062b8 <acquire>
  b->refcnt++;
    800026f4:	40bc                	lw	a5,64(s1)
    800026f6:	2785                	addiw	a5,a5,1
    800026f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fa:	0022c517          	auipc	a0,0x22c
    800026fe:	7b650513          	addi	a0,a0,1974 # 8022eeb0 <bcache>
    80002702:	00004097          	auipc	ra,0x4
    80002706:	c6a080e7          	jalr	-918(ra) # 8000636c <release>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret

0000000080002714 <bunpin>:

void
bunpin(struct buf *b) {
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	1000                	addi	s0,sp,32
    8000271e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002720:	0022c517          	auipc	a0,0x22c
    80002724:	79050513          	addi	a0,a0,1936 # 8022eeb0 <bcache>
    80002728:	00004097          	auipc	ra,0x4
    8000272c:	b90080e7          	jalr	-1136(ra) # 800062b8 <acquire>
  b->refcnt--;
    80002730:	40bc                	lw	a5,64(s1)
    80002732:	37fd                	addiw	a5,a5,-1
    80002734:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002736:	0022c517          	auipc	a0,0x22c
    8000273a:	77a50513          	addi	a0,a0,1914 # 8022eeb0 <bcache>
    8000273e:	00004097          	auipc	ra,0x4
    80002742:	c2e080e7          	jalr	-978(ra) # 8000636c <release>
}
    80002746:	60e2                	ld	ra,24(sp)
    80002748:	6442                	ld	s0,16(sp)
    8000274a:	64a2                	ld	s1,8(sp)
    8000274c:	6105                	addi	sp,sp,32
    8000274e:	8082                	ret

0000000080002750 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000275e:	00d5d59b          	srliw	a1,a1,0xd
    80002762:	00235797          	auipc	a5,0x235
    80002766:	e2a7a783          	lw	a5,-470(a5) # 8023758c <sb+0x1c>
    8000276a:	9dbd                	addw	a1,a1,a5
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	d9e080e7          	jalr	-610(ra) # 8000250a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002774:	0074f713          	andi	a4,s1,7
    80002778:	4785                	li	a5,1
    8000277a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000277e:	14ce                	slli	s1,s1,0x33
    80002780:	90d9                	srli	s1,s1,0x36
    80002782:	00950733          	add	a4,a0,s1
    80002786:	05874703          	lbu	a4,88(a4)
    8000278a:	00e7f6b3          	and	a3,a5,a4
    8000278e:	c69d                	beqz	a3,800027bc <bfree+0x6c>
    80002790:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002792:	94aa                	add	s1,s1,a0
    80002794:	fff7c793          	not	a5,a5
    80002798:	8f7d                	and	a4,a4,a5
    8000279a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	120080e7          	jalr	288(ra) # 800038be <log_write>
  brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e92080e7          	jalr	-366(ra) # 8000263a <brelse>
}
    800027b0:	60e2                	ld	ra,24(sp)
    800027b2:	6442                	ld	s0,16(sp)
    800027b4:	64a2                	ld	s1,8(sp)
    800027b6:	6902                	ld	s2,0(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
    panic("freeing free block");
    800027bc:	00006517          	auipc	a0,0x6
    800027c0:	d0450513          	addi	a0,a0,-764 # 800084c0 <syscalls+0xe8>
    800027c4:	00003097          	auipc	ra,0x3
    800027c8:	5bc080e7          	jalr	1468(ra) # 80005d80 <panic>

00000000800027cc <balloc>:
{
    800027cc:	711d                	addi	sp,sp,-96
    800027ce:	ec86                	sd	ra,88(sp)
    800027d0:	e8a2                	sd	s0,80(sp)
    800027d2:	e4a6                	sd	s1,72(sp)
    800027d4:	e0ca                	sd	s2,64(sp)
    800027d6:	fc4e                	sd	s3,56(sp)
    800027d8:	f852                	sd	s4,48(sp)
    800027da:	f456                	sd	s5,40(sp)
    800027dc:	f05a                	sd	s6,32(sp)
    800027de:	ec5e                	sd	s7,24(sp)
    800027e0:	e862                	sd	s8,16(sp)
    800027e2:	e466                	sd	s9,8(sp)
    800027e4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e6:	00235797          	auipc	a5,0x235
    800027ea:	d8e7a783          	lw	a5,-626(a5) # 80237574 <sb+0x4>
    800027ee:	cbc1                	beqz	a5,8000287e <balloc+0xb2>
    800027f0:	8baa                	mv	s7,a0
    800027f2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f4:	00235b17          	auipc	s6,0x235
    800027f8:	d7cb0b13          	addi	s6,s6,-644 # 80237570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027fe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002800:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002802:	6c89                	lui	s9,0x2
    80002804:	a831                	j	80002820 <balloc+0x54>
    brelse(bp);
    80002806:	854a                	mv	a0,s2
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	e32080e7          	jalr	-462(ra) # 8000263a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002810:	015c87bb          	addw	a5,s9,s5
    80002814:	00078a9b          	sext.w	s5,a5
    80002818:	004b2703          	lw	a4,4(s6)
    8000281c:	06eaf163          	bgeu	s5,a4,8000287e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002820:	41fad79b          	sraiw	a5,s5,0x1f
    80002824:	0137d79b          	srliw	a5,a5,0x13
    80002828:	015787bb          	addw	a5,a5,s5
    8000282c:	40d7d79b          	sraiw	a5,a5,0xd
    80002830:	01cb2583          	lw	a1,28(s6)
    80002834:	9dbd                	addw	a1,a1,a5
    80002836:	855e                	mv	a0,s7
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	cd2080e7          	jalr	-814(ra) # 8000250a <bread>
    80002840:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002842:	004b2503          	lw	a0,4(s6)
    80002846:	000a849b          	sext.w	s1,s5
    8000284a:	8762                	mv	a4,s8
    8000284c:	faa4fde3          	bgeu	s1,a0,80002806 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002850:	00777693          	andi	a3,a4,7
    80002854:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002858:	41f7579b          	sraiw	a5,a4,0x1f
    8000285c:	01d7d79b          	srliw	a5,a5,0x1d
    80002860:	9fb9                	addw	a5,a5,a4
    80002862:	4037d79b          	sraiw	a5,a5,0x3
    80002866:	00f90633          	add	a2,s2,a5
    8000286a:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000286e:	00c6f5b3          	and	a1,a3,a2
    80002872:	cd91                	beqz	a1,8000288e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002874:	2705                	addiw	a4,a4,1
    80002876:	2485                	addiw	s1,s1,1
    80002878:	fd471ae3          	bne	a4,s4,8000284c <balloc+0x80>
    8000287c:	b769                	j	80002806 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	c5a50513          	addi	a0,a0,-934 # 800084d8 <syscalls+0x100>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	4fa080e7          	jalr	1274(ra) # 80005d80 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000288e:	97ca                	add	a5,a5,s2
    80002890:	8e55                	or	a2,a2,a3
    80002892:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002896:	854a                	mv	a0,s2
    80002898:	00001097          	auipc	ra,0x1
    8000289c:	026080e7          	jalr	38(ra) # 800038be <log_write>
        brelse(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	d98080e7          	jalr	-616(ra) # 8000263a <brelse>
  bp = bread(dev, bno);
    800028aa:	85a6                	mv	a1,s1
    800028ac:	855e                	mv	a0,s7
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	c5c080e7          	jalr	-932(ra) # 8000250a <bread>
    800028b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b8:	40000613          	li	a2,1024
    800028bc:	4581                	li	a1,0
    800028be:	05850513          	addi	a0,a0,88
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	9be080e7          	jalr	-1602(ra) # 80000280 <memset>
  log_write(bp);
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	ff2080e7          	jalr	-14(ra) # 800038be <log_write>
  brelse(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	d64080e7          	jalr	-668(ra) # 8000263a <brelse>
}
    800028de:	8526                	mv	a0,s1
    800028e0:	60e6                	ld	ra,88(sp)
    800028e2:	6446                	ld	s0,80(sp)
    800028e4:	64a6                	ld	s1,72(sp)
    800028e6:	6906                	ld	s2,64(sp)
    800028e8:	79e2                	ld	s3,56(sp)
    800028ea:	7a42                	ld	s4,48(sp)
    800028ec:	7aa2                	ld	s5,40(sp)
    800028ee:	7b02                	ld	s6,32(sp)
    800028f0:	6be2                	ld	s7,24(sp)
    800028f2:	6c42                	ld	s8,16(sp)
    800028f4:	6ca2                	ld	s9,8(sp)
    800028f6:	6125                	addi	sp,sp,96
    800028f8:	8082                	ret

00000000800028fa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	e44e                	sd	s3,8(sp)
    80002906:	e052                	sd	s4,0(sp)
    80002908:	1800                	addi	s0,sp,48
    8000290a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000290c:	47ad                	li	a5,11
    8000290e:	04b7fe63          	bgeu	a5,a1,8000296a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002912:	ff45849b          	addiw	s1,a1,-12
    80002916:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000291a:	0ff00793          	li	a5,255
    8000291e:	0ae7e463          	bltu	a5,a4,800029c6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002922:	08052583          	lw	a1,128(a0)
    80002926:	c5b5                	beqz	a1,80002992 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002928:	00092503          	lw	a0,0(s2)
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	bde080e7          	jalr	-1058(ra) # 8000250a <bread>
    80002934:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002936:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000293a:	02049713          	slli	a4,s1,0x20
    8000293e:	01e75593          	srli	a1,a4,0x1e
    80002942:	00b784b3          	add	s1,a5,a1
    80002946:	0004a983          	lw	s3,0(s1)
    8000294a:	04098e63          	beqz	s3,800029a6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000294e:	8552                	mv	a0,s4
    80002950:	00000097          	auipc	ra,0x0
    80002954:	cea080e7          	jalr	-790(ra) # 8000263a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002958:	854e                	mv	a0,s3
    8000295a:	70a2                	ld	ra,40(sp)
    8000295c:	7402                	ld	s0,32(sp)
    8000295e:	64e2                	ld	s1,24(sp)
    80002960:	6942                	ld	s2,16(sp)
    80002962:	69a2                	ld	s3,8(sp)
    80002964:	6a02                	ld	s4,0(sp)
    80002966:	6145                	addi	sp,sp,48
    80002968:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000296a:	02059793          	slli	a5,a1,0x20
    8000296e:	01e7d593          	srli	a1,a5,0x1e
    80002972:	00b504b3          	add	s1,a0,a1
    80002976:	0504a983          	lw	s3,80(s1)
    8000297a:	fc099fe3          	bnez	s3,80002958 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000297e:	4108                	lw	a0,0(a0)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	e4c080e7          	jalr	-436(ra) # 800027cc <balloc>
    80002988:	0005099b          	sext.w	s3,a0
    8000298c:	0534a823          	sw	s3,80(s1)
    80002990:	b7e1                	j	80002958 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e38080e7          	jalr	-456(ra) # 800027cc <balloc>
    8000299c:	0005059b          	sext.w	a1,a0
    800029a0:	08b92023          	sw	a1,128(s2)
    800029a4:	b751                	j	80002928 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029a6:	00092503          	lw	a0,0(s2)
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	e22080e7          	jalr	-478(ra) # 800027cc <balloc>
    800029b2:	0005099b          	sext.w	s3,a0
    800029b6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ba:	8552                	mv	a0,s4
    800029bc:	00001097          	auipc	ra,0x1
    800029c0:	f02080e7          	jalr	-254(ra) # 800038be <log_write>
    800029c4:	b769                	j	8000294e <bmap+0x54>
  panic("bmap: out of range");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	b2a50513          	addi	a0,a0,-1238 # 800084f0 <syscalls+0x118>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	3b2080e7          	jalr	946(ra) # 80005d80 <panic>

00000000800029d6 <iget>:
{
    800029d6:	7179                	addi	sp,sp,-48
    800029d8:	f406                	sd	ra,40(sp)
    800029da:	f022                	sd	s0,32(sp)
    800029dc:	ec26                	sd	s1,24(sp)
    800029de:	e84a                	sd	s2,16(sp)
    800029e0:	e44e                	sd	s3,8(sp)
    800029e2:	e052                	sd	s4,0(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	89aa                	mv	s3,a0
    800029e8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ea:	00235517          	auipc	a0,0x235
    800029ee:	ba650513          	addi	a0,a0,-1114 # 80237590 <itable>
    800029f2:	00004097          	auipc	ra,0x4
    800029f6:	8c6080e7          	jalr	-1850(ra) # 800062b8 <acquire>
  empty = 0;
    800029fa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fc:	00235497          	auipc	s1,0x235
    80002a00:	bac48493          	addi	s1,s1,-1108 # 802375a8 <itable+0x18>
    80002a04:	00236697          	auipc	a3,0x236
    80002a08:	63468693          	addi	a3,a3,1588 # 80239038 <log>
    80002a0c:	a039                	j	80002a1a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0e:	02090b63          	beqz	s2,80002a44 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a12:	08848493          	addi	s1,s1,136
    80002a16:	02d48a63          	beq	s1,a3,80002a4a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a1a:	449c                	lw	a5,8(s1)
    80002a1c:	fef059e3          	blez	a5,80002a0e <iget+0x38>
    80002a20:	4098                	lw	a4,0(s1)
    80002a22:	ff3716e3          	bne	a4,s3,80002a0e <iget+0x38>
    80002a26:	40d8                	lw	a4,4(s1)
    80002a28:	ff4713e3          	bne	a4,s4,80002a0e <iget+0x38>
      ip->ref++;
    80002a2c:	2785                	addiw	a5,a5,1
    80002a2e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a30:	00235517          	auipc	a0,0x235
    80002a34:	b6050513          	addi	a0,a0,-1184 # 80237590 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	934080e7          	jalr	-1740(ra) # 8000636c <release>
      return ip;
    80002a40:	8926                	mv	s2,s1
    80002a42:	a03d                	j	80002a70 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a44:	f7f9                	bnez	a5,80002a12 <iget+0x3c>
    80002a46:	8926                	mv	s2,s1
    80002a48:	b7e9                	j	80002a12 <iget+0x3c>
  if(empty == 0)
    80002a4a:	02090c63          	beqz	s2,80002a82 <iget+0xac>
  ip->dev = dev;
    80002a4e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a52:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a56:	4785                	li	a5,1
    80002a58:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a5c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a60:	00235517          	auipc	a0,0x235
    80002a64:	b3050513          	addi	a0,a0,-1232 # 80237590 <itable>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	904080e7          	jalr	-1788(ra) # 8000636c <release>
}
    80002a70:	854a                	mv	a0,s2
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6a02                	ld	s4,0(sp)
    80002a7e:	6145                	addi	sp,sp,48
    80002a80:	8082                	ret
    panic("iget: no inodes");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	a8650513          	addi	a0,a0,-1402 # 80008508 <syscalls+0x130>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	2f6080e7          	jalr	758(ra) # 80005d80 <panic>

0000000080002a92 <fsinit>:
fsinit(int dev) {
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
    80002aa0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa2:	4585                	li	a1,1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	a66080e7          	jalr	-1434(ra) # 8000250a <bread>
    80002aac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aae:	00235997          	auipc	s3,0x235
    80002ab2:	ac298993          	addi	s3,s3,-1342 # 80237570 <sb>
    80002ab6:	02000613          	li	a2,32
    80002aba:	05850593          	addi	a1,a0,88
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffe097          	auipc	ra,0xffffe
    80002ac4:	81c080e7          	jalr	-2020(ra) # 800002dc <memmove>
  brelse(bp);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	b70080e7          	jalr	-1168(ra) # 8000263a <brelse>
  if(sb.magic != FSMAGIC)
    80002ad2:	0009a703          	lw	a4,0(s3)
    80002ad6:	102037b7          	lui	a5,0x10203
    80002ada:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ade:	02f71263          	bne	a4,a5,80002b02 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae2:	00235597          	auipc	a1,0x235
    80002ae6:	a8e58593          	addi	a1,a1,-1394 # 80237570 <sb>
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	b56080e7          	jalr	-1194(ra) # 80003642 <initlog>
}
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6145                	addi	sp,sp,48
    80002b00:	8082                	ret
    panic("invalid file system");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	a1650513          	addi	a0,a0,-1514 # 80008518 <syscalls+0x140>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	276080e7          	jalr	630(ra) # 80005d80 <panic>

0000000080002b12 <iinit>:
{
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b20:	00006597          	auipc	a1,0x6
    80002b24:	a1058593          	addi	a1,a1,-1520 # 80008530 <syscalls+0x158>
    80002b28:	00235517          	auipc	a0,0x235
    80002b2c:	a6850513          	addi	a0,a0,-1432 # 80237590 <itable>
    80002b30:	00003097          	auipc	ra,0x3
    80002b34:	6f8080e7          	jalr	1784(ra) # 80006228 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b38:	00235497          	auipc	s1,0x235
    80002b3c:	a8048493          	addi	s1,s1,-1408 # 802375b8 <itable+0x28>
    80002b40:	00236997          	auipc	s3,0x236
    80002b44:	50898993          	addi	s3,s3,1288 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b48:	00006917          	auipc	s2,0x6
    80002b4c:	9f090913          	addi	s2,s2,-1552 # 80008538 <syscalls+0x160>
    80002b50:	85ca                	mv	a1,s2
    80002b52:	8526                	mv	a0,s1
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	e4e080e7          	jalr	-434(ra) # 800039a2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b5c:	08848493          	addi	s1,s1,136
    80002b60:	ff3498e3          	bne	s1,s3,80002b50 <iinit+0x3e>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret

0000000080002b72 <ialloc>:
{
    80002b72:	715d                	addi	sp,sp,-80
    80002b74:	e486                	sd	ra,72(sp)
    80002b76:	e0a2                	sd	s0,64(sp)
    80002b78:	fc26                	sd	s1,56(sp)
    80002b7a:	f84a                	sd	s2,48(sp)
    80002b7c:	f44e                	sd	s3,40(sp)
    80002b7e:	f052                	sd	s4,32(sp)
    80002b80:	ec56                	sd	s5,24(sp)
    80002b82:	e85a                	sd	s6,16(sp)
    80002b84:	e45e                	sd	s7,8(sp)
    80002b86:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b88:	00235717          	auipc	a4,0x235
    80002b8c:	9f472703          	lw	a4,-1548(a4) # 8023757c <sb+0xc>
    80002b90:	4785                	li	a5,1
    80002b92:	04e7fa63          	bgeu	a5,a4,80002be6 <ialloc+0x74>
    80002b96:	8aaa                	mv	s5,a0
    80002b98:	8bae                	mv	s7,a1
    80002b9a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b9c:	00235a17          	auipc	s4,0x235
    80002ba0:	9d4a0a13          	addi	s4,s4,-1580 # 80237570 <sb>
    80002ba4:	00048b1b          	sext.w	s6,s1
    80002ba8:	0044d593          	srli	a1,s1,0x4
    80002bac:	018a2783          	lw	a5,24(s4)
    80002bb0:	9dbd                	addw	a1,a1,a5
    80002bb2:	8556                	mv	a0,s5
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	956080e7          	jalr	-1706(ra) # 8000250a <bread>
    80002bbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bbe:	05850993          	addi	s3,a0,88
    80002bc2:	00f4f793          	andi	a5,s1,15
    80002bc6:	079a                	slli	a5,a5,0x6
    80002bc8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bca:	00099783          	lh	a5,0(s3)
    80002bce:	c785                	beqz	a5,80002bf6 <ialloc+0x84>
    brelse(bp);
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	a6a080e7          	jalr	-1430(ra) # 8000263a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd8:	0485                	addi	s1,s1,1
    80002bda:	00ca2703          	lw	a4,12(s4)
    80002bde:	0004879b          	sext.w	a5,s1
    80002be2:	fce7e1e3          	bltu	a5,a4,80002ba4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002be6:	00006517          	auipc	a0,0x6
    80002bea:	95a50513          	addi	a0,a0,-1702 # 80008540 <syscalls+0x168>
    80002bee:	00003097          	auipc	ra,0x3
    80002bf2:	192080e7          	jalr	402(ra) # 80005d80 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bf6:	04000613          	li	a2,64
    80002bfa:	4581                	li	a1,0
    80002bfc:	854e                	mv	a0,s3
    80002bfe:	ffffd097          	auipc	ra,0xffffd
    80002c02:	682080e7          	jalr	1666(ra) # 80000280 <memset>
      dip->type = type;
    80002c06:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	cb2080e7          	jalr	-846(ra) # 800038be <log_write>
      brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	a24080e7          	jalr	-1500(ra) # 8000263a <brelse>
      return iget(dev, inum);
    80002c1e:	85da                	mv	a1,s6
    80002c20:	8556                	mv	a0,s5
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	db4080e7          	jalr	-588(ra) # 800029d6 <iget>
}
    80002c2a:	60a6                	ld	ra,72(sp)
    80002c2c:	6406                	ld	s0,64(sp)
    80002c2e:	74e2                	ld	s1,56(sp)
    80002c30:	7942                	ld	s2,48(sp)
    80002c32:	79a2                	ld	s3,40(sp)
    80002c34:	7a02                	ld	s4,32(sp)
    80002c36:	6ae2                	ld	s5,24(sp)
    80002c38:	6b42                	ld	s6,16(sp)
    80002c3a:	6ba2                	ld	s7,8(sp)
    80002c3c:	6161                	addi	sp,sp,80
    80002c3e:	8082                	ret

0000000080002c40 <iupdate>:
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	e04a                	sd	s2,0(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c4e:	415c                	lw	a5,4(a0)
    80002c50:	0047d79b          	srliw	a5,a5,0x4
    80002c54:	00235597          	auipc	a1,0x235
    80002c58:	9345a583          	lw	a1,-1740(a1) # 80237588 <sb+0x18>
    80002c5c:	9dbd                	addw	a1,a1,a5
    80002c5e:	4108                	lw	a0,0(a0)
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	8aa080e7          	jalr	-1878(ra) # 8000250a <bread>
    80002c68:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c6a:	05850793          	addi	a5,a0,88
    80002c6e:	40d8                	lw	a4,4(s1)
    80002c70:	8b3d                	andi	a4,a4,15
    80002c72:	071a                	slli	a4,a4,0x6
    80002c74:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c76:	04449703          	lh	a4,68(s1)
    80002c7a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c7e:	04649703          	lh	a4,70(s1)
    80002c82:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c86:	04849703          	lh	a4,72(s1)
    80002c8a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c8e:	04a49703          	lh	a4,74(s1)
    80002c92:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c96:	44f8                	lw	a4,76(s1)
    80002c98:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c9a:	03400613          	li	a2,52
    80002c9e:	05048593          	addi	a1,s1,80
    80002ca2:	00c78513          	addi	a0,a5,12
    80002ca6:	ffffd097          	auipc	ra,0xffffd
    80002caa:	636080e7          	jalr	1590(ra) # 800002dc <memmove>
  log_write(bp);
    80002cae:	854a                	mv	a0,s2
    80002cb0:	00001097          	auipc	ra,0x1
    80002cb4:	c0e080e7          	jalr	-1010(ra) # 800038be <log_write>
  brelse(bp);
    80002cb8:	854a                	mv	a0,s2
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	980080e7          	jalr	-1664(ra) # 8000263a <brelse>
}
    80002cc2:	60e2                	ld	ra,24(sp)
    80002cc4:	6442                	ld	s0,16(sp)
    80002cc6:	64a2                	ld	s1,8(sp)
    80002cc8:	6902                	ld	s2,0(sp)
    80002cca:	6105                	addi	sp,sp,32
    80002ccc:	8082                	ret

0000000080002cce <idup>:
{
    80002cce:	1101                	addi	sp,sp,-32
    80002cd0:	ec06                	sd	ra,24(sp)
    80002cd2:	e822                	sd	s0,16(sp)
    80002cd4:	e426                	sd	s1,8(sp)
    80002cd6:	1000                	addi	s0,sp,32
    80002cd8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cda:	00235517          	auipc	a0,0x235
    80002cde:	8b650513          	addi	a0,a0,-1866 # 80237590 <itable>
    80002ce2:	00003097          	auipc	ra,0x3
    80002ce6:	5d6080e7          	jalr	1494(ra) # 800062b8 <acquire>
  ip->ref++;
    80002cea:	449c                	lw	a5,8(s1)
    80002cec:	2785                	addiw	a5,a5,1
    80002cee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cf0:	00235517          	auipc	a0,0x235
    80002cf4:	8a050513          	addi	a0,a0,-1888 # 80237590 <itable>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	674080e7          	jalr	1652(ra) # 8000636c <release>
}
    80002d00:	8526                	mv	a0,s1
    80002d02:	60e2                	ld	ra,24(sp)
    80002d04:	6442                	ld	s0,16(sp)
    80002d06:	64a2                	ld	s1,8(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <ilock>:
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	e04a                	sd	s2,0(sp)
    80002d16:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d18:	c115                	beqz	a0,80002d3c <ilock+0x30>
    80002d1a:	84aa                	mv	s1,a0
    80002d1c:	451c                	lw	a5,8(a0)
    80002d1e:	00f05f63          	blez	a5,80002d3c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d22:	0541                	addi	a0,a0,16
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	cb8080e7          	jalr	-840(ra) # 800039dc <acquiresleep>
  if(ip->valid == 0){
    80002d2c:	40bc                	lw	a5,64(s1)
    80002d2e:	cf99                	beqz	a5,80002d4c <ilock+0x40>
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret
    panic("ilock");
    80002d3c:	00006517          	auipc	a0,0x6
    80002d40:	81c50513          	addi	a0,a0,-2020 # 80008558 <syscalls+0x180>
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	03c080e7          	jalr	60(ra) # 80005d80 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d4c:	40dc                	lw	a5,4(s1)
    80002d4e:	0047d79b          	srliw	a5,a5,0x4
    80002d52:	00235597          	auipc	a1,0x235
    80002d56:	8365a583          	lw	a1,-1994(a1) # 80237588 <sb+0x18>
    80002d5a:	9dbd                	addw	a1,a1,a5
    80002d5c:	4088                	lw	a0,0(s1)
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	7ac080e7          	jalr	1964(ra) # 8000250a <bread>
    80002d66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d68:	05850593          	addi	a1,a0,88
    80002d6c:	40dc                	lw	a5,4(s1)
    80002d6e:	8bbd                	andi	a5,a5,15
    80002d70:	079a                	slli	a5,a5,0x6
    80002d72:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d74:	00059783          	lh	a5,0(a1)
    80002d78:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d7c:	00259783          	lh	a5,2(a1)
    80002d80:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d84:	00459783          	lh	a5,4(a1)
    80002d88:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d8c:	00659783          	lh	a5,6(a1)
    80002d90:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d94:	459c                	lw	a5,8(a1)
    80002d96:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d98:	03400613          	li	a2,52
    80002d9c:	05b1                	addi	a1,a1,12
    80002d9e:	05048513          	addi	a0,s1,80
    80002da2:	ffffd097          	auipc	ra,0xffffd
    80002da6:	53a080e7          	jalr	1338(ra) # 800002dc <memmove>
    brelse(bp);
    80002daa:	854a                	mv	a0,s2
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	88e080e7          	jalr	-1906(ra) # 8000263a <brelse>
    ip->valid = 1;
    80002db4:	4785                	li	a5,1
    80002db6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002db8:	04449783          	lh	a5,68(s1)
    80002dbc:	fbb5                	bnez	a5,80002d30 <ilock+0x24>
      panic("ilock: no type");
    80002dbe:	00005517          	auipc	a0,0x5
    80002dc2:	7a250513          	addi	a0,a0,1954 # 80008560 <syscalls+0x188>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	fba080e7          	jalr	-70(ra) # 80005d80 <panic>

0000000080002dce <iunlock>:
{
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	e04a                	sd	s2,0(sp)
    80002dd8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dda:	c905                	beqz	a0,80002e0a <iunlock+0x3c>
    80002ddc:	84aa                	mv	s1,a0
    80002dde:	01050913          	addi	s2,a0,16
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	c92080e7          	jalr	-878(ra) # 80003a76 <holdingsleep>
    80002dec:	cd19                	beqz	a0,80002e0a <iunlock+0x3c>
    80002dee:	449c                	lw	a5,8(s1)
    80002df0:	00f05d63          	blez	a5,80002e0a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df4:	854a                	mv	a0,s2
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	c3c080e7          	jalr	-964(ra) # 80003a32 <releasesleep>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    panic("iunlock");
    80002e0a:	00005517          	auipc	a0,0x5
    80002e0e:	76650513          	addi	a0,a0,1894 # 80008570 <syscalls+0x198>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	f6e080e7          	jalr	-146(ra) # 80005d80 <panic>

0000000080002e1a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e1a:	7179                	addi	sp,sp,-48
    80002e1c:	f406                	sd	ra,40(sp)
    80002e1e:	f022                	sd	s0,32(sp)
    80002e20:	ec26                	sd	s1,24(sp)
    80002e22:	e84a                	sd	s2,16(sp)
    80002e24:	e44e                	sd	s3,8(sp)
    80002e26:	e052                	sd	s4,0(sp)
    80002e28:	1800                	addi	s0,sp,48
    80002e2a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e2c:	05050493          	addi	s1,a0,80
    80002e30:	08050913          	addi	s2,a0,128
    80002e34:	a021                	j	80002e3c <itrunc+0x22>
    80002e36:	0491                	addi	s1,s1,4
    80002e38:	01248d63          	beq	s1,s2,80002e52 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e3c:	408c                	lw	a1,0(s1)
    80002e3e:	dde5                	beqz	a1,80002e36 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e40:	0009a503          	lw	a0,0(s3)
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	90c080e7          	jalr	-1780(ra) # 80002750 <bfree>
      ip->addrs[i] = 0;
    80002e4c:	0004a023          	sw	zero,0(s1)
    80002e50:	b7dd                	j	80002e36 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e52:	0809a583          	lw	a1,128(s3)
    80002e56:	e185                	bnez	a1,80002e76 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e58:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e5c:	854e                	mv	a0,s3
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	de2080e7          	jalr	-542(ra) # 80002c40 <iupdate>
}
    80002e66:	70a2                	ld	ra,40(sp)
    80002e68:	7402                	ld	s0,32(sp)
    80002e6a:	64e2                	ld	s1,24(sp)
    80002e6c:	6942                	ld	s2,16(sp)
    80002e6e:	69a2                	ld	s3,8(sp)
    80002e70:	6a02                	ld	s4,0(sp)
    80002e72:	6145                	addi	sp,sp,48
    80002e74:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e76:	0009a503          	lw	a0,0(s3)
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	690080e7          	jalr	1680(ra) # 8000250a <bread>
    80002e82:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e84:	05850493          	addi	s1,a0,88
    80002e88:	45850913          	addi	s2,a0,1112
    80002e8c:	a021                	j	80002e94 <itrunc+0x7a>
    80002e8e:	0491                	addi	s1,s1,4
    80002e90:	01248b63          	beq	s1,s2,80002ea6 <itrunc+0x8c>
      if(a[j])
    80002e94:	408c                	lw	a1,0(s1)
    80002e96:	dde5                	beqz	a1,80002e8e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e98:	0009a503          	lw	a0,0(s3)
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	8b4080e7          	jalr	-1868(ra) # 80002750 <bfree>
    80002ea4:	b7ed                	j	80002e8e <itrunc+0x74>
    brelse(bp);
    80002ea6:	8552                	mv	a0,s4
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	792080e7          	jalr	1938(ra) # 8000263a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eb0:	0809a583          	lw	a1,128(s3)
    80002eb4:	0009a503          	lw	a0,0(s3)
    80002eb8:	00000097          	auipc	ra,0x0
    80002ebc:	898080e7          	jalr	-1896(ra) # 80002750 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ec0:	0809a023          	sw	zero,128(s3)
    80002ec4:	bf51                	j	80002e58 <itrunc+0x3e>

0000000080002ec6 <iput>:
{
    80002ec6:	1101                	addi	sp,sp,-32
    80002ec8:	ec06                	sd	ra,24(sp)
    80002eca:	e822                	sd	s0,16(sp)
    80002ecc:	e426                	sd	s1,8(sp)
    80002ece:	e04a                	sd	s2,0(sp)
    80002ed0:	1000                	addi	s0,sp,32
    80002ed2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ed4:	00234517          	auipc	a0,0x234
    80002ed8:	6bc50513          	addi	a0,a0,1724 # 80237590 <itable>
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	3dc080e7          	jalr	988(ra) # 800062b8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ee4:	4498                	lw	a4,8(s1)
    80002ee6:	4785                	li	a5,1
    80002ee8:	02f70363          	beq	a4,a5,80002f0e <iput+0x48>
  ip->ref--;
    80002eec:	449c                	lw	a5,8(s1)
    80002eee:	37fd                	addiw	a5,a5,-1
    80002ef0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ef2:	00234517          	auipc	a0,0x234
    80002ef6:	69e50513          	addi	a0,a0,1694 # 80237590 <itable>
    80002efa:	00003097          	auipc	ra,0x3
    80002efe:	472080e7          	jalr	1138(ra) # 8000636c <release>
}
    80002f02:	60e2                	ld	ra,24(sp)
    80002f04:	6442                	ld	s0,16(sp)
    80002f06:	64a2                	ld	s1,8(sp)
    80002f08:	6902                	ld	s2,0(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f0e:	40bc                	lw	a5,64(s1)
    80002f10:	dff1                	beqz	a5,80002eec <iput+0x26>
    80002f12:	04a49783          	lh	a5,74(s1)
    80002f16:	fbf9                	bnez	a5,80002eec <iput+0x26>
    acquiresleep(&ip->lock);
    80002f18:	01048913          	addi	s2,s1,16
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	00001097          	auipc	ra,0x1
    80002f22:	abe080e7          	jalr	-1346(ra) # 800039dc <acquiresleep>
    release(&itable.lock);
    80002f26:	00234517          	auipc	a0,0x234
    80002f2a:	66a50513          	addi	a0,a0,1642 # 80237590 <itable>
    80002f2e:	00003097          	auipc	ra,0x3
    80002f32:	43e080e7          	jalr	1086(ra) # 8000636c <release>
    itrunc(ip);
    80002f36:	8526                	mv	a0,s1
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	ee2080e7          	jalr	-286(ra) # 80002e1a <itrunc>
    ip->type = 0;
    80002f40:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f44:	8526                	mv	a0,s1
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	cfa080e7          	jalr	-774(ra) # 80002c40 <iupdate>
    ip->valid = 0;
    80002f4e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f52:	854a                	mv	a0,s2
    80002f54:	00001097          	auipc	ra,0x1
    80002f58:	ade080e7          	jalr	-1314(ra) # 80003a32 <releasesleep>
    acquire(&itable.lock);
    80002f5c:	00234517          	auipc	a0,0x234
    80002f60:	63450513          	addi	a0,a0,1588 # 80237590 <itable>
    80002f64:	00003097          	auipc	ra,0x3
    80002f68:	354080e7          	jalr	852(ra) # 800062b8 <acquire>
    80002f6c:	b741                	j	80002eec <iput+0x26>

0000000080002f6e <iunlockput>:
{
    80002f6e:	1101                	addi	sp,sp,-32
    80002f70:	ec06                	sd	ra,24(sp)
    80002f72:	e822                	sd	s0,16(sp)
    80002f74:	e426                	sd	s1,8(sp)
    80002f76:	1000                	addi	s0,sp,32
    80002f78:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	e54080e7          	jalr	-428(ra) # 80002dce <iunlock>
  iput(ip);
    80002f82:	8526                	mv	a0,s1
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	f42080e7          	jalr	-190(ra) # 80002ec6 <iput>
}
    80002f8c:	60e2                	ld	ra,24(sp)
    80002f8e:	6442                	ld	s0,16(sp)
    80002f90:	64a2                	ld	s1,8(sp)
    80002f92:	6105                	addi	sp,sp,32
    80002f94:	8082                	ret

0000000080002f96 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f96:	1141                	addi	sp,sp,-16
    80002f98:	e422                	sd	s0,8(sp)
    80002f9a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f9c:	411c                	lw	a5,0(a0)
    80002f9e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fa0:	415c                	lw	a5,4(a0)
    80002fa2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa4:	04451783          	lh	a5,68(a0)
    80002fa8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fac:	04a51783          	lh	a5,74(a0)
    80002fb0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb4:	04c56783          	lwu	a5,76(a0)
    80002fb8:	e99c                	sd	a5,16(a1)
}
    80002fba:	6422                	ld	s0,8(sp)
    80002fbc:	0141                	addi	sp,sp,16
    80002fbe:	8082                	ret

0000000080002fc0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc0:	457c                	lw	a5,76(a0)
    80002fc2:	0ed7e963          	bltu	a5,a3,800030b4 <readi+0xf4>
{
    80002fc6:	7159                	addi	sp,sp,-112
    80002fc8:	f486                	sd	ra,104(sp)
    80002fca:	f0a2                	sd	s0,96(sp)
    80002fcc:	eca6                	sd	s1,88(sp)
    80002fce:	e8ca                	sd	s2,80(sp)
    80002fd0:	e4ce                	sd	s3,72(sp)
    80002fd2:	e0d2                	sd	s4,64(sp)
    80002fd4:	fc56                	sd	s5,56(sp)
    80002fd6:	f85a                	sd	s6,48(sp)
    80002fd8:	f45e                	sd	s7,40(sp)
    80002fda:	f062                	sd	s8,32(sp)
    80002fdc:	ec66                	sd	s9,24(sp)
    80002fde:	e86a                	sd	s10,16(sp)
    80002fe0:	e46e                	sd	s11,8(sp)
    80002fe2:	1880                	addi	s0,sp,112
    80002fe4:	8baa                	mv	s7,a0
    80002fe6:	8c2e                	mv	s8,a1
    80002fe8:	8ab2                	mv	s5,a2
    80002fea:	84b6                	mv	s1,a3
    80002fec:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fee:	9f35                	addw	a4,a4,a3
    return 0;
    80002ff0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ff2:	0ad76063          	bltu	a4,a3,80003092 <readi+0xd2>
  if(off + n > ip->size)
    80002ff6:	00e7f463          	bgeu	a5,a4,80002ffe <readi+0x3e>
    n = ip->size - off;
    80002ffa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffe:	0a0b0963          	beqz	s6,800030b0 <readi+0xf0>
    80003002:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003004:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003008:	5cfd                	li	s9,-1
    8000300a:	a82d                	j	80003044 <readi+0x84>
    8000300c:	020a1d93          	slli	s11,s4,0x20
    80003010:	020ddd93          	srli	s11,s11,0x20
    80003014:	05890613          	addi	a2,s2,88
    80003018:	86ee                	mv	a3,s11
    8000301a:	963a                	add	a2,a2,a4
    8000301c:	85d6                	mv	a1,s5
    8000301e:	8562                	mv	a0,s8
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	a4e080e7          	jalr	-1458(ra) # 80001a6e <either_copyout>
    80003028:	05950d63          	beq	a0,s9,80003082 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000302c:	854a                	mv	a0,s2
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	60c080e7          	jalr	1548(ra) # 8000263a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003036:	013a09bb          	addw	s3,s4,s3
    8000303a:	009a04bb          	addw	s1,s4,s1
    8000303e:	9aee                	add	s5,s5,s11
    80003040:	0569f763          	bgeu	s3,s6,8000308e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003044:	000ba903          	lw	s2,0(s7)
    80003048:	00a4d59b          	srliw	a1,s1,0xa
    8000304c:	855e                	mv	a0,s7
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	8ac080e7          	jalr	-1876(ra) # 800028fa <bmap>
    80003056:	0005059b          	sext.w	a1,a0
    8000305a:	854a                	mv	a0,s2
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	4ae080e7          	jalr	1198(ra) # 8000250a <bread>
    80003064:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003066:	3ff4f713          	andi	a4,s1,1023
    8000306a:	40ed07bb          	subw	a5,s10,a4
    8000306e:	413b06bb          	subw	a3,s6,s3
    80003072:	8a3e                	mv	s4,a5
    80003074:	2781                	sext.w	a5,a5
    80003076:	0006861b          	sext.w	a2,a3
    8000307a:	f8f679e3          	bgeu	a2,a5,8000300c <readi+0x4c>
    8000307e:	8a36                	mv	s4,a3
    80003080:	b771                	j	8000300c <readi+0x4c>
      brelse(bp);
    80003082:	854a                	mv	a0,s2
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	5b6080e7          	jalr	1462(ra) # 8000263a <brelse>
      tot = -1;
    8000308c:	59fd                	li	s3,-1
  }
  return tot;
    8000308e:	0009851b          	sext.w	a0,s3
}
    80003092:	70a6                	ld	ra,104(sp)
    80003094:	7406                	ld	s0,96(sp)
    80003096:	64e6                	ld	s1,88(sp)
    80003098:	6946                	ld	s2,80(sp)
    8000309a:	69a6                	ld	s3,72(sp)
    8000309c:	6a06                	ld	s4,64(sp)
    8000309e:	7ae2                	ld	s5,56(sp)
    800030a0:	7b42                	ld	s6,48(sp)
    800030a2:	7ba2                	ld	s7,40(sp)
    800030a4:	7c02                	ld	s8,32(sp)
    800030a6:	6ce2                	ld	s9,24(sp)
    800030a8:	6d42                	ld	s10,16(sp)
    800030aa:	6da2                	ld	s11,8(sp)
    800030ac:	6165                	addi	sp,sp,112
    800030ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b0:	89da                	mv	s3,s6
    800030b2:	bff1                	j	8000308e <readi+0xce>
    return 0;
    800030b4:	4501                	li	a0,0
}
    800030b6:	8082                	ret

00000000800030b8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030b8:	457c                	lw	a5,76(a0)
    800030ba:	10d7e863          	bltu	a5,a3,800031ca <writei+0x112>
{
    800030be:	7159                	addi	sp,sp,-112
    800030c0:	f486                	sd	ra,104(sp)
    800030c2:	f0a2                	sd	s0,96(sp)
    800030c4:	eca6                	sd	s1,88(sp)
    800030c6:	e8ca                	sd	s2,80(sp)
    800030c8:	e4ce                	sd	s3,72(sp)
    800030ca:	e0d2                	sd	s4,64(sp)
    800030cc:	fc56                	sd	s5,56(sp)
    800030ce:	f85a                	sd	s6,48(sp)
    800030d0:	f45e                	sd	s7,40(sp)
    800030d2:	f062                	sd	s8,32(sp)
    800030d4:	ec66                	sd	s9,24(sp)
    800030d6:	e86a                	sd	s10,16(sp)
    800030d8:	e46e                	sd	s11,8(sp)
    800030da:	1880                	addi	s0,sp,112
    800030dc:	8b2a                	mv	s6,a0
    800030de:	8c2e                	mv	s8,a1
    800030e0:	8ab2                	mv	s5,a2
    800030e2:	8936                	mv	s2,a3
    800030e4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e6:	00e687bb          	addw	a5,a3,a4
    800030ea:	0ed7e263          	bltu	a5,a3,800031ce <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ee:	00043737          	lui	a4,0x43
    800030f2:	0ef76063          	bltu	a4,a5,800031d2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f6:	0c0b8863          	beqz	s7,800031c6 <writei+0x10e>
    800030fa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003100:	5cfd                	li	s9,-1
    80003102:	a091                	j	80003146 <writei+0x8e>
    80003104:	02099d93          	slli	s11,s3,0x20
    80003108:	020ddd93          	srli	s11,s11,0x20
    8000310c:	05848513          	addi	a0,s1,88
    80003110:	86ee                	mv	a3,s11
    80003112:	8656                	mv	a2,s5
    80003114:	85e2                	mv	a1,s8
    80003116:	953a                	add	a0,a0,a4
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	9ac080e7          	jalr	-1620(ra) # 80001ac4 <either_copyin>
    80003120:	07950263          	beq	a0,s9,80003184 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003124:	8526                	mv	a0,s1
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	798080e7          	jalr	1944(ra) # 800038be <log_write>
    brelse(bp);
    8000312e:	8526                	mv	a0,s1
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	50a080e7          	jalr	1290(ra) # 8000263a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003138:	01498a3b          	addw	s4,s3,s4
    8000313c:	0129893b          	addw	s2,s3,s2
    80003140:	9aee                	add	s5,s5,s11
    80003142:	057a7663          	bgeu	s4,s7,8000318e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003146:	000b2483          	lw	s1,0(s6)
    8000314a:	00a9559b          	srliw	a1,s2,0xa
    8000314e:	855a                	mv	a0,s6
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	7aa080e7          	jalr	1962(ra) # 800028fa <bmap>
    80003158:	0005059b          	sext.w	a1,a0
    8000315c:	8526                	mv	a0,s1
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	3ac080e7          	jalr	940(ra) # 8000250a <bread>
    80003166:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003168:	3ff97713          	andi	a4,s2,1023
    8000316c:	40ed07bb          	subw	a5,s10,a4
    80003170:	414b86bb          	subw	a3,s7,s4
    80003174:	89be                	mv	s3,a5
    80003176:	2781                	sext.w	a5,a5
    80003178:	0006861b          	sext.w	a2,a3
    8000317c:	f8f674e3          	bgeu	a2,a5,80003104 <writei+0x4c>
    80003180:	89b6                	mv	s3,a3
    80003182:	b749                	j	80003104 <writei+0x4c>
      brelse(bp);
    80003184:	8526                	mv	a0,s1
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	4b4080e7          	jalr	1204(ra) # 8000263a <brelse>
  }

  if(off > ip->size)
    8000318e:	04cb2783          	lw	a5,76(s6)
    80003192:	0127f463          	bgeu	a5,s2,8000319a <writei+0xe2>
    ip->size = off;
    80003196:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000319a:	855a                	mv	a0,s6
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	aa4080e7          	jalr	-1372(ra) # 80002c40 <iupdate>

  return tot;
    800031a4:	000a051b          	sext.w	a0,s4
}
    800031a8:	70a6                	ld	ra,104(sp)
    800031aa:	7406                	ld	s0,96(sp)
    800031ac:	64e6                	ld	s1,88(sp)
    800031ae:	6946                	ld	s2,80(sp)
    800031b0:	69a6                	ld	s3,72(sp)
    800031b2:	6a06                	ld	s4,64(sp)
    800031b4:	7ae2                	ld	s5,56(sp)
    800031b6:	7b42                	ld	s6,48(sp)
    800031b8:	7ba2                	ld	s7,40(sp)
    800031ba:	7c02                	ld	s8,32(sp)
    800031bc:	6ce2                	ld	s9,24(sp)
    800031be:	6d42                	ld	s10,16(sp)
    800031c0:	6da2                	ld	s11,8(sp)
    800031c2:	6165                	addi	sp,sp,112
    800031c4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c6:	8a5e                	mv	s4,s7
    800031c8:	bfc9                	j	8000319a <writei+0xe2>
    return -1;
    800031ca:	557d                	li	a0,-1
}
    800031cc:	8082                	ret
    return -1;
    800031ce:	557d                	li	a0,-1
    800031d0:	bfe1                	j	800031a8 <writei+0xf0>
    return -1;
    800031d2:	557d                	li	a0,-1
    800031d4:	bfd1                	j	800031a8 <writei+0xf0>

00000000800031d6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031d6:	1141                	addi	sp,sp,-16
    800031d8:	e406                	sd	ra,8(sp)
    800031da:	e022                	sd	s0,0(sp)
    800031dc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031de:	4639                	li	a2,14
    800031e0:	ffffd097          	auipc	ra,0xffffd
    800031e4:	170080e7          	jalr	368(ra) # 80000350 <strncmp>
}
    800031e8:	60a2                	ld	ra,8(sp)
    800031ea:	6402                	ld	s0,0(sp)
    800031ec:	0141                	addi	sp,sp,16
    800031ee:	8082                	ret

00000000800031f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f0:	7139                	addi	sp,sp,-64
    800031f2:	fc06                	sd	ra,56(sp)
    800031f4:	f822                	sd	s0,48(sp)
    800031f6:	f426                	sd	s1,40(sp)
    800031f8:	f04a                	sd	s2,32(sp)
    800031fa:	ec4e                	sd	s3,24(sp)
    800031fc:	e852                	sd	s4,16(sp)
    800031fe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003200:	04451703          	lh	a4,68(a0)
    80003204:	4785                	li	a5,1
    80003206:	00f71a63          	bne	a4,a5,8000321a <dirlookup+0x2a>
    8000320a:	892a                	mv	s2,a0
    8000320c:	89ae                	mv	s3,a1
    8000320e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003210:	457c                	lw	a5,76(a0)
    80003212:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003214:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003216:	e79d                	bnez	a5,80003244 <dirlookup+0x54>
    80003218:	a8a5                	j	80003290 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000321a:	00005517          	auipc	a0,0x5
    8000321e:	35e50513          	addi	a0,a0,862 # 80008578 <syscalls+0x1a0>
    80003222:	00003097          	auipc	ra,0x3
    80003226:	b5e080e7          	jalr	-1186(ra) # 80005d80 <panic>
      panic("dirlookup read");
    8000322a:	00005517          	auipc	a0,0x5
    8000322e:	36650513          	addi	a0,a0,870 # 80008590 <syscalls+0x1b8>
    80003232:	00003097          	auipc	ra,0x3
    80003236:	b4e080e7          	jalr	-1202(ra) # 80005d80 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000323a:	24c1                	addiw	s1,s1,16
    8000323c:	04c92783          	lw	a5,76(s2)
    80003240:	04f4f763          	bgeu	s1,a5,8000328e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003244:	4741                	li	a4,16
    80003246:	86a6                	mv	a3,s1
    80003248:	fc040613          	addi	a2,s0,-64
    8000324c:	4581                	li	a1,0
    8000324e:	854a                	mv	a0,s2
    80003250:	00000097          	auipc	ra,0x0
    80003254:	d70080e7          	jalr	-656(ra) # 80002fc0 <readi>
    80003258:	47c1                	li	a5,16
    8000325a:	fcf518e3          	bne	a0,a5,8000322a <dirlookup+0x3a>
    if(de.inum == 0)
    8000325e:	fc045783          	lhu	a5,-64(s0)
    80003262:	dfe1                	beqz	a5,8000323a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003264:	fc240593          	addi	a1,s0,-62
    80003268:	854e                	mv	a0,s3
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	f6c080e7          	jalr	-148(ra) # 800031d6 <namecmp>
    80003272:	f561                	bnez	a0,8000323a <dirlookup+0x4a>
      if(poff)
    80003274:	000a0463          	beqz	s4,8000327c <dirlookup+0x8c>
        *poff = off;
    80003278:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000327c:	fc045583          	lhu	a1,-64(s0)
    80003280:	00092503          	lw	a0,0(s2)
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	752080e7          	jalr	1874(ra) # 800029d6 <iget>
    8000328c:	a011                	j	80003290 <dirlookup+0xa0>
  return 0;
    8000328e:	4501                	li	a0,0
}
    80003290:	70e2                	ld	ra,56(sp)
    80003292:	7442                	ld	s0,48(sp)
    80003294:	74a2                	ld	s1,40(sp)
    80003296:	7902                	ld	s2,32(sp)
    80003298:	69e2                	ld	s3,24(sp)
    8000329a:	6a42                	ld	s4,16(sp)
    8000329c:	6121                	addi	sp,sp,64
    8000329e:	8082                	ret

00000000800032a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a0:	711d                	addi	sp,sp,-96
    800032a2:	ec86                	sd	ra,88(sp)
    800032a4:	e8a2                	sd	s0,80(sp)
    800032a6:	e4a6                	sd	s1,72(sp)
    800032a8:	e0ca                	sd	s2,64(sp)
    800032aa:	fc4e                	sd	s3,56(sp)
    800032ac:	f852                	sd	s4,48(sp)
    800032ae:	f456                	sd	s5,40(sp)
    800032b0:	f05a                	sd	s6,32(sp)
    800032b2:	ec5e                	sd	s7,24(sp)
    800032b4:	e862                	sd	s8,16(sp)
    800032b6:	e466                	sd	s9,8(sp)
    800032b8:	e06a                	sd	s10,0(sp)
    800032ba:	1080                	addi	s0,sp,96
    800032bc:	84aa                	mv	s1,a0
    800032be:	8b2e                	mv	s6,a1
    800032c0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c2:	00054703          	lbu	a4,0(a0)
    800032c6:	02f00793          	li	a5,47
    800032ca:	02f70363          	beq	a4,a5,800032f0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ce:	ffffe097          	auipc	ra,0xffffe
    800032d2:	d38080e7          	jalr	-712(ra) # 80001006 <myproc>
    800032d6:	15053503          	ld	a0,336(a0)
    800032da:	00000097          	auipc	ra,0x0
    800032de:	9f4080e7          	jalr	-1548(ra) # 80002cce <idup>
    800032e2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032e4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032e8:	4cb5                	li	s9,13
  len = path - s;
    800032ea:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032ec:	4c05                	li	s8,1
    800032ee:	a87d                	j	800033ac <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032f0:	4585                	li	a1,1
    800032f2:	4505                	li	a0,1
    800032f4:	fffff097          	auipc	ra,0xfffff
    800032f8:	6e2080e7          	jalr	1762(ra) # 800029d6 <iget>
    800032fc:	8a2a                	mv	s4,a0
    800032fe:	b7dd                	j	800032e4 <namex+0x44>
      iunlockput(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	c6c080e7          	jalr	-916(ra) # 80002f6e <iunlockput>
      return 0;
    8000330a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000330c:	8552                	mv	a0,s4
    8000330e:	60e6                	ld	ra,88(sp)
    80003310:	6446                	ld	s0,80(sp)
    80003312:	64a6                	ld	s1,72(sp)
    80003314:	6906                	ld	s2,64(sp)
    80003316:	79e2                	ld	s3,56(sp)
    80003318:	7a42                	ld	s4,48(sp)
    8000331a:	7aa2                	ld	s5,40(sp)
    8000331c:	7b02                	ld	s6,32(sp)
    8000331e:	6be2                	ld	s7,24(sp)
    80003320:	6c42                	ld	s8,16(sp)
    80003322:	6ca2                	ld	s9,8(sp)
    80003324:	6d02                	ld	s10,0(sp)
    80003326:	6125                	addi	sp,sp,96
    80003328:	8082                	ret
      iunlock(ip);
    8000332a:	8552                	mv	a0,s4
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	aa2080e7          	jalr	-1374(ra) # 80002dce <iunlock>
      return ip;
    80003334:	bfe1                	j	8000330c <namex+0x6c>
      iunlockput(ip);
    80003336:	8552                	mv	a0,s4
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	c36080e7          	jalr	-970(ra) # 80002f6e <iunlockput>
      return 0;
    80003340:	8a4e                	mv	s4,s3
    80003342:	b7e9                	j	8000330c <namex+0x6c>
  len = path - s;
    80003344:	40998633          	sub	a2,s3,s1
    80003348:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000334c:	09acd863          	bge	s9,s10,800033dc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003350:	4639                	li	a2,14
    80003352:	85a6                	mv	a1,s1
    80003354:	8556                	mv	a0,s5
    80003356:	ffffd097          	auipc	ra,0xffffd
    8000335a:	f86080e7          	jalr	-122(ra) # 800002dc <memmove>
    8000335e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003360:	0004c783          	lbu	a5,0(s1)
    80003364:	01279763          	bne	a5,s2,80003372 <namex+0xd2>
    path++;
    80003368:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	ff278de3          	beq	a5,s2,80003368 <namex+0xc8>
    ilock(ip);
    80003372:	8552                	mv	a0,s4
    80003374:	00000097          	auipc	ra,0x0
    80003378:	998080e7          	jalr	-1640(ra) # 80002d0c <ilock>
    if(ip->type != T_DIR){
    8000337c:	044a1783          	lh	a5,68(s4)
    80003380:	f98790e3          	bne	a5,s8,80003300 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003384:	000b0563          	beqz	s6,8000338e <namex+0xee>
    80003388:	0004c783          	lbu	a5,0(s1)
    8000338c:	dfd9                	beqz	a5,8000332a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000338e:	865e                	mv	a2,s7
    80003390:	85d6                	mv	a1,s5
    80003392:	8552                	mv	a0,s4
    80003394:	00000097          	auipc	ra,0x0
    80003398:	e5c080e7          	jalr	-420(ra) # 800031f0 <dirlookup>
    8000339c:	89aa                	mv	s3,a0
    8000339e:	dd41                	beqz	a0,80003336 <namex+0x96>
    iunlockput(ip);
    800033a0:	8552                	mv	a0,s4
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	bcc080e7          	jalr	-1076(ra) # 80002f6e <iunlockput>
    ip = next;
    800033aa:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	01279763          	bne	a5,s2,800033be <namex+0x11e>
    path++;
    800033b4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	ff278de3          	beq	a5,s2,800033b4 <namex+0x114>
  if(*path == 0)
    800033be:	cb9d                	beqz	a5,800033f4 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	89a6                	mv	s3,s1
  len = path - s;
    800033c6:	8d5e                	mv	s10,s7
    800033c8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ca:	01278963          	beq	a5,s2,800033dc <namex+0x13c>
    800033ce:	dbbd                	beqz	a5,80003344 <namex+0xa4>
    path++;
    800033d0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033d2:	0009c783          	lbu	a5,0(s3)
    800033d6:	ff279ce3          	bne	a5,s2,800033ce <namex+0x12e>
    800033da:	b7ad                	j	80003344 <namex+0xa4>
    memmove(name, s, len);
    800033dc:	2601                	sext.w	a2,a2
    800033de:	85a6                	mv	a1,s1
    800033e0:	8556                	mv	a0,s5
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	efa080e7          	jalr	-262(ra) # 800002dc <memmove>
    name[len] = 0;
    800033ea:	9d56                	add	s10,s10,s5
    800033ec:	000d0023          	sb	zero,0(s10)
    800033f0:	84ce                	mv	s1,s3
    800033f2:	b7bd                	j	80003360 <namex+0xc0>
  if(nameiparent){
    800033f4:	f00b0ce3          	beqz	s6,8000330c <namex+0x6c>
    iput(ip);
    800033f8:	8552                	mv	a0,s4
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	acc080e7          	jalr	-1332(ra) # 80002ec6 <iput>
    return 0;
    80003402:	4a01                	li	s4,0
    80003404:	b721                	j	8000330c <namex+0x6c>

0000000080003406 <dirlink>:
{
    80003406:	7139                	addi	sp,sp,-64
    80003408:	fc06                	sd	ra,56(sp)
    8000340a:	f822                	sd	s0,48(sp)
    8000340c:	f426                	sd	s1,40(sp)
    8000340e:	f04a                	sd	s2,32(sp)
    80003410:	ec4e                	sd	s3,24(sp)
    80003412:	e852                	sd	s4,16(sp)
    80003414:	0080                	addi	s0,sp,64
    80003416:	892a                	mv	s2,a0
    80003418:	8a2e                	mv	s4,a1
    8000341a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000341c:	4601                	li	a2,0
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	dd2080e7          	jalr	-558(ra) # 800031f0 <dirlookup>
    80003426:	e93d                	bnez	a0,8000349c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003428:	04c92483          	lw	s1,76(s2)
    8000342c:	c49d                	beqz	s1,8000345a <dirlink+0x54>
    8000342e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003430:	4741                	li	a4,16
    80003432:	86a6                	mv	a3,s1
    80003434:	fc040613          	addi	a2,s0,-64
    80003438:	4581                	li	a1,0
    8000343a:	854a                	mv	a0,s2
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	b84080e7          	jalr	-1148(ra) # 80002fc0 <readi>
    80003444:	47c1                	li	a5,16
    80003446:	06f51163          	bne	a0,a5,800034a8 <dirlink+0xa2>
    if(de.inum == 0)
    8000344a:	fc045783          	lhu	a5,-64(s0)
    8000344e:	c791                	beqz	a5,8000345a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003450:	24c1                	addiw	s1,s1,16
    80003452:	04c92783          	lw	a5,76(s2)
    80003456:	fcf4ede3          	bltu	s1,a5,80003430 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000345a:	4639                	li	a2,14
    8000345c:	85d2                	mv	a1,s4
    8000345e:	fc240513          	addi	a0,s0,-62
    80003462:	ffffd097          	auipc	ra,0xffffd
    80003466:	f2a080e7          	jalr	-214(ra) # 8000038c <strncpy>
  de.inum = inum;
    8000346a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346e:	4741                	li	a4,16
    80003470:	86a6                	mv	a3,s1
    80003472:	fc040613          	addi	a2,s0,-64
    80003476:	4581                	li	a1,0
    80003478:	854a                	mv	a0,s2
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	c3e080e7          	jalr	-962(ra) # 800030b8 <writei>
    80003482:	872a                	mv	a4,a0
    80003484:	47c1                	li	a5,16
  return 0;
    80003486:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003488:	02f71863          	bne	a4,a5,800034b8 <dirlink+0xb2>
}
    8000348c:	70e2                	ld	ra,56(sp)
    8000348e:	7442                	ld	s0,48(sp)
    80003490:	74a2                	ld	s1,40(sp)
    80003492:	7902                	ld	s2,32(sp)
    80003494:	69e2                	ld	s3,24(sp)
    80003496:	6a42                	ld	s4,16(sp)
    80003498:	6121                	addi	sp,sp,64
    8000349a:	8082                	ret
    iput(ip);
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	a2a080e7          	jalr	-1494(ra) # 80002ec6 <iput>
    return -1;
    800034a4:	557d                	li	a0,-1
    800034a6:	b7dd                	j	8000348c <dirlink+0x86>
      panic("dirlink read");
    800034a8:	00005517          	auipc	a0,0x5
    800034ac:	0f850513          	addi	a0,a0,248 # 800085a0 <syscalls+0x1c8>
    800034b0:	00003097          	auipc	ra,0x3
    800034b4:	8d0080e7          	jalr	-1840(ra) # 80005d80 <panic>
    panic("dirlink");
    800034b8:	00005517          	auipc	a0,0x5
    800034bc:	1f850513          	addi	a0,a0,504 # 800086b0 <syscalls+0x2d8>
    800034c0:	00003097          	auipc	ra,0x3
    800034c4:	8c0080e7          	jalr	-1856(ra) # 80005d80 <panic>

00000000800034c8 <namei>:

struct inode*
namei(char *path)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034d0:	fe040613          	addi	a2,s0,-32
    800034d4:	4581                	li	a1,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	dca080e7          	jalr	-566(ra) # 800032a0 <namex>
}
    800034de:	60e2                	ld	ra,24(sp)
    800034e0:	6442                	ld	s0,16(sp)
    800034e2:	6105                	addi	sp,sp,32
    800034e4:	8082                	ret

00000000800034e6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e6:	1141                	addi	sp,sp,-16
    800034e8:	e406                	sd	ra,8(sp)
    800034ea:	e022                	sd	s0,0(sp)
    800034ec:	0800                	addi	s0,sp,16
    800034ee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034f0:	4585                	li	a1,1
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	dae080e7          	jalr	-594(ra) # 800032a0 <namex>
}
    800034fa:	60a2                	ld	ra,8(sp)
    800034fc:	6402                	ld	s0,0(sp)
    800034fe:	0141                	addi	sp,sp,16
    80003500:	8082                	ret

0000000080003502 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003502:	1101                	addi	sp,sp,-32
    80003504:	ec06                	sd	ra,24(sp)
    80003506:	e822                	sd	s0,16(sp)
    80003508:	e426                	sd	s1,8(sp)
    8000350a:	e04a                	sd	s2,0(sp)
    8000350c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000350e:	00236917          	auipc	s2,0x236
    80003512:	b2a90913          	addi	s2,s2,-1238 # 80239038 <log>
    80003516:	01892583          	lw	a1,24(s2)
    8000351a:	02892503          	lw	a0,40(s2)
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	fec080e7          	jalr	-20(ra) # 8000250a <bread>
    80003526:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003528:	02c92683          	lw	a3,44(s2)
    8000352c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000352e:	02d05863          	blez	a3,8000355e <write_head+0x5c>
    80003532:	00236797          	auipc	a5,0x236
    80003536:	b3678793          	addi	a5,a5,-1226 # 80239068 <log+0x30>
    8000353a:	05c50713          	addi	a4,a0,92
    8000353e:	36fd                	addiw	a3,a3,-1
    80003540:	02069613          	slli	a2,a3,0x20
    80003544:	01e65693          	srli	a3,a2,0x1e
    80003548:	00236617          	auipc	a2,0x236
    8000354c:	b2460613          	addi	a2,a2,-1244 # 8023906c <log+0x34>
    80003550:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003552:	4390                	lw	a2,0(a5)
    80003554:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003556:	0791                	addi	a5,a5,4
    80003558:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000355a:	fed79ce3          	bne	a5,a3,80003552 <write_head+0x50>
  }
  bwrite(buf);
    8000355e:	8526                	mv	a0,s1
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	09c080e7          	jalr	156(ra) # 800025fc <bwrite>
  brelse(buf);
    80003568:	8526                	mv	a0,s1
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	0d0080e7          	jalr	208(ra) # 8000263a <brelse>
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6902                	ld	s2,0(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357e:	00236797          	auipc	a5,0x236
    80003582:	ae67a783          	lw	a5,-1306(a5) # 80239064 <log+0x2c>
    80003586:	0af05d63          	blez	a5,80003640 <install_trans+0xc2>
{
    8000358a:	7139                	addi	sp,sp,-64
    8000358c:	fc06                	sd	ra,56(sp)
    8000358e:	f822                	sd	s0,48(sp)
    80003590:	f426                	sd	s1,40(sp)
    80003592:	f04a                	sd	s2,32(sp)
    80003594:	ec4e                	sd	s3,24(sp)
    80003596:	e852                	sd	s4,16(sp)
    80003598:	e456                	sd	s5,8(sp)
    8000359a:	e05a                	sd	s6,0(sp)
    8000359c:	0080                	addi	s0,sp,64
    8000359e:	8b2a                	mv	s6,a0
    800035a0:	00236a97          	auipc	s5,0x236
    800035a4:	ac8a8a93          	addi	s5,s5,-1336 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035aa:	00236997          	auipc	s3,0x236
    800035ae:	a8e98993          	addi	s3,s3,-1394 # 80239038 <log>
    800035b2:	a00d                	j	800035d4 <install_trans+0x56>
    brelse(lbuf);
    800035b4:	854a                	mv	a0,s2
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	084080e7          	jalr	132(ra) # 8000263a <brelse>
    brelse(dbuf);
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	07a080e7          	jalr	122(ra) # 8000263a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c8:	2a05                	addiw	s4,s4,1
    800035ca:	0a91                	addi	s5,s5,4
    800035cc:	02c9a783          	lw	a5,44(s3)
    800035d0:	04fa5e63          	bge	s4,a5,8000362c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d4:	0189a583          	lw	a1,24(s3)
    800035d8:	014585bb          	addw	a1,a1,s4
    800035dc:	2585                	addiw	a1,a1,1
    800035de:	0289a503          	lw	a0,40(s3)
    800035e2:	fffff097          	auipc	ra,0xfffff
    800035e6:	f28080e7          	jalr	-216(ra) # 8000250a <bread>
    800035ea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ec:	000aa583          	lw	a1,0(s5)
    800035f0:	0289a503          	lw	a0,40(s3)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	f16080e7          	jalr	-234(ra) # 8000250a <bread>
    800035fc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035fe:	40000613          	li	a2,1024
    80003602:	05890593          	addi	a1,s2,88
    80003606:	05850513          	addi	a0,a0,88
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	cd2080e7          	jalr	-814(ra) # 800002dc <memmove>
    bwrite(dbuf);  // write dst to disk
    80003612:	8526                	mv	a0,s1
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	fe8080e7          	jalr	-24(ra) # 800025fc <bwrite>
    if(recovering == 0)
    8000361c:	f80b1ce3          	bnez	s6,800035b4 <install_trans+0x36>
      bunpin(dbuf);
    80003620:	8526                	mv	a0,s1
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	0f2080e7          	jalr	242(ra) # 80002714 <bunpin>
    8000362a:	b769                	j	800035b4 <install_trans+0x36>
}
    8000362c:	70e2                	ld	ra,56(sp)
    8000362e:	7442                	ld	s0,48(sp)
    80003630:	74a2                	ld	s1,40(sp)
    80003632:	7902                	ld	s2,32(sp)
    80003634:	69e2                	ld	s3,24(sp)
    80003636:	6a42                	ld	s4,16(sp)
    80003638:	6aa2                	ld	s5,8(sp)
    8000363a:	6b02                	ld	s6,0(sp)
    8000363c:	6121                	addi	sp,sp,64
    8000363e:	8082                	ret
    80003640:	8082                	ret

0000000080003642 <initlog>:
{
    80003642:	7179                	addi	sp,sp,-48
    80003644:	f406                	sd	ra,40(sp)
    80003646:	f022                	sd	s0,32(sp)
    80003648:	ec26                	sd	s1,24(sp)
    8000364a:	e84a                	sd	s2,16(sp)
    8000364c:	e44e                	sd	s3,8(sp)
    8000364e:	1800                	addi	s0,sp,48
    80003650:	892a                	mv	s2,a0
    80003652:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003654:	00236497          	auipc	s1,0x236
    80003658:	9e448493          	addi	s1,s1,-1564 # 80239038 <log>
    8000365c:	00005597          	auipc	a1,0x5
    80003660:	f5458593          	addi	a1,a1,-172 # 800085b0 <syscalls+0x1d8>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	bc2080e7          	jalr	-1086(ra) # 80006228 <initlock>
  log.start = sb->logstart;
    8000366e:	0149a583          	lw	a1,20(s3)
    80003672:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003674:	0109a783          	lw	a5,16(s3)
    80003678:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000367a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367e:	854a                	mv	a0,s2
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	e8a080e7          	jalr	-374(ra) # 8000250a <bread>
  log.lh.n = lh->n;
    80003688:	4d34                	lw	a3,88(a0)
    8000368a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000368c:	02d05663          	blez	a3,800036b8 <initlog+0x76>
    80003690:	05c50793          	addi	a5,a0,92
    80003694:	00236717          	auipc	a4,0x236
    80003698:	9d470713          	addi	a4,a4,-1580 # 80239068 <log+0x30>
    8000369c:	36fd                	addiw	a3,a3,-1
    8000369e:	02069613          	slli	a2,a3,0x20
    800036a2:	01e65693          	srli	a3,a2,0x1e
    800036a6:	06050613          	addi	a2,a0,96
    800036aa:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036ac:	4390                	lw	a2,0(a5)
    800036ae:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036b0:	0791                	addi	a5,a5,4
    800036b2:	0711                	addi	a4,a4,4
    800036b4:	fed79ce3          	bne	a5,a3,800036ac <initlog+0x6a>
  brelse(buf);
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	f82080e7          	jalr	-126(ra) # 8000263a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036c0:	4505                	li	a0,1
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	ebc080e7          	jalr	-324(ra) # 8000357e <install_trans>
  log.lh.n = 0;
    800036ca:	00236797          	auipc	a5,0x236
    800036ce:	9807ad23          	sw	zero,-1638(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    800036d2:	00000097          	auipc	ra,0x0
    800036d6:	e30080e7          	jalr	-464(ra) # 80003502 <write_head>
}
    800036da:	70a2                	ld	ra,40(sp)
    800036dc:	7402                	ld	s0,32(sp)
    800036de:	64e2                	ld	s1,24(sp)
    800036e0:	6942                	ld	s2,16(sp)
    800036e2:	69a2                	ld	s3,8(sp)
    800036e4:	6145                	addi	sp,sp,48
    800036e6:	8082                	ret

00000000800036e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036e8:	1101                	addi	sp,sp,-32
    800036ea:	ec06                	sd	ra,24(sp)
    800036ec:	e822                	sd	s0,16(sp)
    800036ee:	e426                	sd	s1,8(sp)
    800036f0:	e04a                	sd	s2,0(sp)
    800036f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036f4:	00236517          	auipc	a0,0x236
    800036f8:	94450513          	addi	a0,a0,-1724 # 80239038 <log>
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	bbc080e7          	jalr	-1092(ra) # 800062b8 <acquire>
  while(1){
    if(log.committing){
    80003704:	00236497          	auipc	s1,0x236
    80003708:	93448493          	addi	s1,s1,-1740 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000370c:	4979                	li	s2,30
    8000370e:	a039                	j	8000371c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003710:	85a6                	mv	a1,s1
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	fb6080e7          	jalr	-74(ra) # 800016ca <sleep>
    if(log.committing){
    8000371c:	50dc                	lw	a5,36(s1)
    8000371e:	fbed                	bnez	a5,80003710 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003720:	5098                	lw	a4,32(s1)
    80003722:	2705                	addiw	a4,a4,1
    80003724:	0007069b          	sext.w	a3,a4
    80003728:	0027179b          	slliw	a5,a4,0x2
    8000372c:	9fb9                	addw	a5,a5,a4
    8000372e:	0017979b          	slliw	a5,a5,0x1
    80003732:	54d8                	lw	a4,44(s1)
    80003734:	9fb9                	addw	a5,a5,a4
    80003736:	00f95963          	bge	s2,a5,80003748 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000373a:	85a6                	mv	a1,s1
    8000373c:	8526                	mv	a0,s1
    8000373e:	ffffe097          	auipc	ra,0xffffe
    80003742:	f8c080e7          	jalr	-116(ra) # 800016ca <sleep>
    80003746:	bfd9                	j	8000371c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003748:	00236517          	auipc	a0,0x236
    8000374c:	8f050513          	addi	a0,a0,-1808 # 80239038 <log>
    80003750:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003752:	00003097          	auipc	ra,0x3
    80003756:	c1a080e7          	jalr	-998(ra) # 8000636c <release>
      break;
    }
  }
}
    8000375a:	60e2                	ld	ra,24(sp)
    8000375c:	6442                	ld	s0,16(sp)
    8000375e:	64a2                	ld	s1,8(sp)
    80003760:	6902                	ld	s2,0(sp)
    80003762:	6105                	addi	sp,sp,32
    80003764:	8082                	ret

0000000080003766 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003766:	7139                	addi	sp,sp,-64
    80003768:	fc06                	sd	ra,56(sp)
    8000376a:	f822                	sd	s0,48(sp)
    8000376c:	f426                	sd	s1,40(sp)
    8000376e:	f04a                	sd	s2,32(sp)
    80003770:	ec4e                	sd	s3,24(sp)
    80003772:	e852                	sd	s4,16(sp)
    80003774:	e456                	sd	s5,8(sp)
    80003776:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003778:	00236497          	auipc	s1,0x236
    8000377c:	8c048493          	addi	s1,s1,-1856 # 80239038 <log>
    80003780:	8526                	mv	a0,s1
    80003782:	00003097          	auipc	ra,0x3
    80003786:	b36080e7          	jalr	-1226(ra) # 800062b8 <acquire>
  log.outstanding -= 1;
    8000378a:	509c                	lw	a5,32(s1)
    8000378c:	37fd                	addiw	a5,a5,-1
    8000378e:	0007891b          	sext.w	s2,a5
    80003792:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003794:	50dc                	lw	a5,36(s1)
    80003796:	e7b9                	bnez	a5,800037e4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003798:	04091e63          	bnez	s2,800037f4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000379c:	00236497          	auipc	s1,0x236
    800037a0:	89c48493          	addi	s1,s1,-1892 # 80239038 <log>
    800037a4:	4785                	li	a5,1
    800037a6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	bc2080e7          	jalr	-1086(ra) # 8000636c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037b2:	54dc                	lw	a5,44(s1)
    800037b4:	06f04763          	bgtz	a5,80003822 <end_op+0xbc>
    acquire(&log.lock);
    800037b8:	00236497          	auipc	s1,0x236
    800037bc:	88048493          	addi	s1,s1,-1920 # 80239038 <log>
    800037c0:	8526                	mv	a0,s1
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	af6080e7          	jalr	-1290(ra) # 800062b8 <acquire>
    log.committing = 0;
    800037ca:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ce:	8526                	mv	a0,s1
    800037d0:	ffffe097          	auipc	ra,0xffffe
    800037d4:	086080e7          	jalr	134(ra) # 80001856 <wakeup>
    release(&log.lock);
    800037d8:	8526                	mv	a0,s1
    800037da:	00003097          	auipc	ra,0x3
    800037de:	b92080e7          	jalr	-1134(ra) # 8000636c <release>
}
    800037e2:	a03d                	j	80003810 <end_op+0xaa>
    panic("log.committing");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	dd450513          	addi	a0,a0,-556 # 800085b8 <syscalls+0x1e0>
    800037ec:	00002097          	auipc	ra,0x2
    800037f0:	594080e7          	jalr	1428(ra) # 80005d80 <panic>
    wakeup(&log);
    800037f4:	00236497          	auipc	s1,0x236
    800037f8:	84448493          	addi	s1,s1,-1980 # 80239038 <log>
    800037fc:	8526                	mv	a0,s1
    800037fe:	ffffe097          	auipc	ra,0xffffe
    80003802:	058080e7          	jalr	88(ra) # 80001856 <wakeup>
  release(&log.lock);
    80003806:	8526                	mv	a0,s1
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	b64080e7          	jalr	-1180(ra) # 8000636c <release>
}
    80003810:	70e2                	ld	ra,56(sp)
    80003812:	7442                	ld	s0,48(sp)
    80003814:	74a2                	ld	s1,40(sp)
    80003816:	7902                	ld	s2,32(sp)
    80003818:	69e2                	ld	s3,24(sp)
    8000381a:	6a42                	ld	s4,16(sp)
    8000381c:	6aa2                	ld	s5,8(sp)
    8000381e:	6121                	addi	sp,sp,64
    80003820:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003822:	00236a97          	auipc	s5,0x236
    80003826:	846a8a93          	addi	s5,s5,-1978 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000382a:	00236a17          	auipc	s4,0x236
    8000382e:	80ea0a13          	addi	s4,s4,-2034 # 80239038 <log>
    80003832:	018a2583          	lw	a1,24(s4)
    80003836:	012585bb          	addw	a1,a1,s2
    8000383a:	2585                	addiw	a1,a1,1
    8000383c:	028a2503          	lw	a0,40(s4)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	cca080e7          	jalr	-822(ra) # 8000250a <bread>
    80003848:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000384a:	000aa583          	lw	a1,0(s5)
    8000384e:	028a2503          	lw	a0,40(s4)
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	cb8080e7          	jalr	-840(ra) # 8000250a <bread>
    8000385a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000385c:	40000613          	li	a2,1024
    80003860:	05850593          	addi	a1,a0,88
    80003864:	05848513          	addi	a0,s1,88
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	a74080e7          	jalr	-1420(ra) # 800002dc <memmove>
    bwrite(to);  // write the log
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	d8a080e7          	jalr	-630(ra) # 800025fc <bwrite>
    brelse(from);
    8000387a:	854e                	mv	a0,s3
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	dbe080e7          	jalr	-578(ra) # 8000263a <brelse>
    brelse(to);
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	db4080e7          	jalr	-588(ra) # 8000263a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388e:	2905                	addiw	s2,s2,1
    80003890:	0a91                	addi	s5,s5,4
    80003892:	02ca2783          	lw	a5,44(s4)
    80003896:	f8f94ee3          	blt	s2,a5,80003832 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	c68080e7          	jalr	-920(ra) # 80003502 <write_head>
    install_trans(0); // Now install writes to home locations
    800038a2:	4501                	li	a0,0
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	cda080e7          	jalr	-806(ra) # 8000357e <install_trans>
    log.lh.n = 0;
    800038ac:	00235797          	auipc	a5,0x235
    800038b0:	7a07ac23          	sw	zero,1976(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	c4e080e7          	jalr	-946(ra) # 80003502 <write_head>
    800038bc:	bdf5                	j	800037b8 <end_op+0x52>

00000000800038be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	e04a                	sd	s2,0(sp)
    800038c8:	1000                	addi	s0,sp,32
    800038ca:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038cc:	00235917          	auipc	s2,0x235
    800038d0:	76c90913          	addi	s2,s2,1900 # 80239038 <log>
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	9e2080e7          	jalr	-1566(ra) # 800062b8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038de:	02c92603          	lw	a2,44(s2)
    800038e2:	47f5                	li	a5,29
    800038e4:	06c7c563          	blt	a5,a2,8000394e <log_write+0x90>
    800038e8:	00235797          	auipc	a5,0x235
    800038ec:	76c7a783          	lw	a5,1900(a5) # 80239054 <log+0x1c>
    800038f0:	37fd                	addiw	a5,a5,-1
    800038f2:	04f65e63          	bge	a2,a5,8000394e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038f6:	00235797          	auipc	a5,0x235
    800038fa:	7627a783          	lw	a5,1890(a5) # 80239058 <log+0x20>
    800038fe:	06f05063          	blez	a5,8000395e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003902:	4781                	li	a5,0
    80003904:	06c05563          	blez	a2,8000396e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003908:	44cc                	lw	a1,12(s1)
    8000390a:	00235717          	auipc	a4,0x235
    8000390e:	75e70713          	addi	a4,a4,1886 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003912:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003914:	4314                	lw	a3,0(a4)
    80003916:	04b68c63          	beq	a3,a1,8000396e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000391a:	2785                	addiw	a5,a5,1
    8000391c:	0711                	addi	a4,a4,4
    8000391e:	fef61be3          	bne	a2,a5,80003914 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003922:	0621                	addi	a2,a2,8
    80003924:	060a                	slli	a2,a2,0x2
    80003926:	00235797          	auipc	a5,0x235
    8000392a:	71278793          	addi	a5,a5,1810 # 80239038 <log>
    8000392e:	97b2                	add	a5,a5,a2
    80003930:	44d8                	lw	a4,12(s1)
    80003932:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003934:	8526                	mv	a0,s1
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	da2080e7          	jalr	-606(ra) # 800026d8 <bpin>
    log.lh.n++;
    8000393e:	00235717          	auipc	a4,0x235
    80003942:	6fa70713          	addi	a4,a4,1786 # 80239038 <log>
    80003946:	575c                	lw	a5,44(a4)
    80003948:	2785                	addiw	a5,a5,1
    8000394a:	d75c                	sw	a5,44(a4)
    8000394c:	a82d                	j	80003986 <log_write+0xc8>
    panic("too big a transaction");
    8000394e:	00005517          	auipc	a0,0x5
    80003952:	c7a50513          	addi	a0,a0,-902 # 800085c8 <syscalls+0x1f0>
    80003956:	00002097          	auipc	ra,0x2
    8000395a:	42a080e7          	jalr	1066(ra) # 80005d80 <panic>
    panic("log_write outside of trans");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	c8250513          	addi	a0,a0,-894 # 800085e0 <syscalls+0x208>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	41a080e7          	jalr	1050(ra) # 80005d80 <panic>
  log.lh.block[i] = b->blockno;
    8000396e:	00878693          	addi	a3,a5,8
    80003972:	068a                	slli	a3,a3,0x2
    80003974:	00235717          	auipc	a4,0x235
    80003978:	6c470713          	addi	a4,a4,1732 # 80239038 <log>
    8000397c:	9736                	add	a4,a4,a3
    8000397e:	44d4                	lw	a3,12(s1)
    80003980:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003982:	faf609e3          	beq	a2,a5,80003934 <log_write+0x76>
  }
  release(&log.lock);
    80003986:	00235517          	auipc	a0,0x235
    8000398a:	6b250513          	addi	a0,a0,1714 # 80239038 <log>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	9de080e7          	jalr	-1570(ra) # 8000636c <release>
}
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6902                	ld	s2,0(sp)
    8000399e:	6105                	addi	sp,sp,32
    800039a0:	8082                	ret

00000000800039a2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	e04a                	sd	s2,0(sp)
    800039ac:	1000                	addi	s0,sp,32
    800039ae:	84aa                	mv	s1,a0
    800039b0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039b2:	00005597          	auipc	a1,0x5
    800039b6:	c4e58593          	addi	a1,a1,-946 # 80008600 <syscalls+0x228>
    800039ba:	0521                	addi	a0,a0,8
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	86c080e7          	jalr	-1940(ra) # 80006228 <initlock>
  lk->name = name;
    800039c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039cc:	0204a423          	sw	zero,40(s1)
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039dc:	1101                	addi	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	e426                	sd	s1,8(sp)
    800039e4:	e04a                	sd	s2,0(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ea:	00850913          	addi	s2,a0,8
    800039ee:	854a                	mv	a0,s2
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	8c8080e7          	jalr	-1848(ra) # 800062b8 <acquire>
  while (lk->locked) {
    800039f8:	409c                	lw	a5,0(s1)
    800039fa:	cb89                	beqz	a5,80003a0c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039fc:	85ca                	mv	a1,s2
    800039fe:	8526                	mv	a0,s1
    80003a00:	ffffe097          	auipc	ra,0xffffe
    80003a04:	cca080e7          	jalr	-822(ra) # 800016ca <sleep>
  while (lk->locked) {
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	fbed                	bnez	a5,800039fc <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a0c:	4785                	li	a5,1
    80003a0e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	5f6080e7          	jalr	1526(ra) # 80001006 <myproc>
    80003a18:	591c                	lw	a5,48(a0)
    80003a1a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a1c:	854a                	mv	a0,s2
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	94e080e7          	jalr	-1714(ra) # 8000636c <release>
}
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6902                	ld	s2,0(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	e04a                	sd	s2,0(sp)
    80003a3c:	1000                	addi	s0,sp,32
    80003a3e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a40:	00850913          	addi	s2,a0,8
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	872080e7          	jalr	-1934(ra) # 800062b8 <acquire>
  lk->locked = 0;
    80003a4e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a52:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a56:	8526                	mv	a0,s1
    80003a58:	ffffe097          	auipc	ra,0xffffe
    80003a5c:	dfe080e7          	jalr	-514(ra) # 80001856 <wakeup>
  release(&lk->lk);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	90a080e7          	jalr	-1782(ra) # 8000636c <release>
}
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6902                	ld	s2,0(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a76:	7179                	addi	sp,sp,-48
    80003a78:	f406                	sd	ra,40(sp)
    80003a7a:	f022                	sd	s0,32(sp)
    80003a7c:	ec26                	sd	s1,24(sp)
    80003a7e:	e84a                	sd	s2,16(sp)
    80003a80:	e44e                	sd	s3,8(sp)
    80003a82:	1800                	addi	s0,sp,48
    80003a84:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a86:	00850913          	addi	s2,a0,8
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	82c080e7          	jalr	-2004(ra) # 800062b8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a94:	409c                	lw	a5,0(s1)
    80003a96:	ef99                	bnez	a5,80003ab4 <holdingsleep+0x3e>
    80003a98:	4481                	li	s1,0
  release(&lk->lk);
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	8d0080e7          	jalr	-1840(ra) # 8000636c <release>
  return r;
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	70a2                	ld	ra,40(sp)
    80003aa8:	7402                	ld	s0,32(sp)
    80003aaa:	64e2                	ld	s1,24(sp)
    80003aac:	6942                	ld	s2,16(sp)
    80003aae:	69a2                	ld	s3,8(sp)
    80003ab0:	6145                	addi	sp,sp,48
    80003ab2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab4:	0284a983          	lw	s3,40(s1)
    80003ab8:	ffffd097          	auipc	ra,0xffffd
    80003abc:	54e080e7          	jalr	1358(ra) # 80001006 <myproc>
    80003ac0:	5904                	lw	s1,48(a0)
    80003ac2:	413484b3          	sub	s1,s1,s3
    80003ac6:	0014b493          	seqz	s1,s1
    80003aca:	bfc1                	j	80003a9a <holdingsleep+0x24>

0000000080003acc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003acc:	1141                	addi	sp,sp,-16
    80003ace:	e406                	sd	ra,8(sp)
    80003ad0:	e022                	sd	s0,0(sp)
    80003ad2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ad4:	00005597          	auipc	a1,0x5
    80003ad8:	b3c58593          	addi	a1,a1,-1220 # 80008610 <syscalls+0x238>
    80003adc:	00235517          	auipc	a0,0x235
    80003ae0:	6a450513          	addi	a0,a0,1700 # 80239180 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	744080e7          	jalr	1860(ra) # 80006228 <initlock>
}
    80003aec:	60a2                	ld	ra,8(sp)
    80003aee:	6402                	ld	s0,0(sp)
    80003af0:	0141                	addi	sp,sp,16
    80003af2:	8082                	ret

0000000080003af4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003af4:	1101                	addi	sp,sp,-32
    80003af6:	ec06                	sd	ra,24(sp)
    80003af8:	e822                	sd	s0,16(sp)
    80003afa:	e426                	sd	s1,8(sp)
    80003afc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003afe:	00235517          	auipc	a0,0x235
    80003b02:	68250513          	addi	a0,a0,1666 # 80239180 <ftable>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	7b2080e7          	jalr	1970(ra) # 800062b8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0e:	00235497          	auipc	s1,0x235
    80003b12:	68a48493          	addi	s1,s1,1674 # 80239198 <ftable+0x18>
    80003b16:	00236717          	auipc	a4,0x236
    80003b1a:	62270713          	addi	a4,a4,1570 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	cf99                	beqz	a5,80003b3e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b22:	02848493          	addi	s1,s1,40
    80003b26:	fee49ce3          	bne	s1,a4,80003b1e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b2a:	00235517          	auipc	a0,0x235
    80003b2e:	65650513          	addi	a0,a0,1622 # 80239180 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	83a080e7          	jalr	-1990(ra) # 8000636c <release>
  return 0;
    80003b3a:	4481                	li	s1,0
    80003b3c:	a819                	j	80003b52 <filealloc+0x5e>
      f->ref = 1;
    80003b3e:	4785                	li	a5,1
    80003b40:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b42:	00235517          	auipc	a0,0x235
    80003b46:	63e50513          	addi	a0,a0,1598 # 80239180 <ftable>
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	822080e7          	jalr	-2014(ra) # 8000636c <release>
}
    80003b52:	8526                	mv	a0,s1
    80003b54:	60e2                	ld	ra,24(sp)
    80003b56:	6442                	ld	s0,16(sp)
    80003b58:	64a2                	ld	s1,8(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	1000                	addi	s0,sp,32
    80003b68:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b6a:	00235517          	auipc	a0,0x235
    80003b6e:	61650513          	addi	a0,a0,1558 # 80239180 <ftable>
    80003b72:	00002097          	auipc	ra,0x2
    80003b76:	746080e7          	jalr	1862(ra) # 800062b8 <acquire>
  if(f->ref < 1)
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	02f05263          	blez	a5,80003ba0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b80:	2785                	addiw	a5,a5,1
    80003b82:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b84:	00235517          	auipc	a0,0x235
    80003b88:	5fc50513          	addi	a0,a0,1532 # 80239180 <ftable>
    80003b8c:	00002097          	auipc	ra,0x2
    80003b90:	7e0080e7          	jalr	2016(ra) # 8000636c <release>
  return f;
}
    80003b94:	8526                	mv	a0,s1
    80003b96:	60e2                	ld	ra,24(sp)
    80003b98:	6442                	ld	s0,16(sp)
    80003b9a:	64a2                	ld	s1,8(sp)
    80003b9c:	6105                	addi	sp,sp,32
    80003b9e:	8082                	ret
    panic("filedup");
    80003ba0:	00005517          	auipc	a0,0x5
    80003ba4:	a7850513          	addi	a0,a0,-1416 # 80008618 <syscalls+0x240>
    80003ba8:	00002097          	auipc	ra,0x2
    80003bac:	1d8080e7          	jalr	472(ra) # 80005d80 <panic>

0000000080003bb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bb0:	7139                	addi	sp,sp,-64
    80003bb2:	fc06                	sd	ra,56(sp)
    80003bb4:	f822                	sd	s0,48(sp)
    80003bb6:	f426                	sd	s1,40(sp)
    80003bb8:	f04a                	sd	s2,32(sp)
    80003bba:	ec4e                	sd	s3,24(sp)
    80003bbc:	e852                	sd	s4,16(sp)
    80003bbe:	e456                	sd	s5,8(sp)
    80003bc0:	0080                	addi	s0,sp,64
    80003bc2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bc4:	00235517          	auipc	a0,0x235
    80003bc8:	5bc50513          	addi	a0,a0,1468 # 80239180 <ftable>
    80003bcc:	00002097          	auipc	ra,0x2
    80003bd0:	6ec080e7          	jalr	1772(ra) # 800062b8 <acquire>
  if(f->ref < 1)
    80003bd4:	40dc                	lw	a5,4(s1)
    80003bd6:	06f05163          	blez	a5,80003c38 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bda:	37fd                	addiw	a5,a5,-1
    80003bdc:	0007871b          	sext.w	a4,a5
    80003be0:	c0dc                	sw	a5,4(s1)
    80003be2:	06e04363          	bgtz	a4,80003c48 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be6:	0004a903          	lw	s2,0(s1)
    80003bea:	0094ca83          	lbu	s5,9(s1)
    80003bee:	0104ba03          	ld	s4,16(s1)
    80003bf2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bfa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bfe:	00235517          	auipc	a0,0x235
    80003c02:	58250513          	addi	a0,a0,1410 # 80239180 <ftable>
    80003c06:	00002097          	auipc	ra,0x2
    80003c0a:	766080e7          	jalr	1894(ra) # 8000636c <release>

  if(ff.type == FD_PIPE){
    80003c0e:	4785                	li	a5,1
    80003c10:	04f90d63          	beq	s2,a5,80003c6a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c14:	3979                	addiw	s2,s2,-2
    80003c16:	4785                	li	a5,1
    80003c18:	0527e063          	bltu	a5,s2,80003c58 <fileclose+0xa8>
    begin_op();
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	acc080e7          	jalr	-1332(ra) # 800036e8 <begin_op>
    iput(ff.ip);
    80003c24:	854e                	mv	a0,s3
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	2a0080e7          	jalr	672(ra) # 80002ec6 <iput>
    end_op();
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	b38080e7          	jalr	-1224(ra) # 80003766 <end_op>
    80003c36:	a00d                	j	80003c58 <fileclose+0xa8>
    panic("fileclose");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	9e850513          	addi	a0,a0,-1560 # 80008620 <syscalls+0x248>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	140080e7          	jalr	320(ra) # 80005d80 <panic>
    release(&ftable.lock);
    80003c48:	00235517          	auipc	a0,0x235
    80003c4c:	53850513          	addi	a0,a0,1336 # 80239180 <ftable>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	71c080e7          	jalr	1820(ra) # 8000636c <release>
  }
}
    80003c58:	70e2                	ld	ra,56(sp)
    80003c5a:	7442                	ld	s0,48(sp)
    80003c5c:	74a2                	ld	s1,40(sp)
    80003c5e:	7902                	ld	s2,32(sp)
    80003c60:	69e2                	ld	s3,24(sp)
    80003c62:	6a42                	ld	s4,16(sp)
    80003c64:	6aa2                	ld	s5,8(sp)
    80003c66:	6121                	addi	sp,sp,64
    80003c68:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c6a:	85d6                	mv	a1,s5
    80003c6c:	8552                	mv	a0,s4
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	34c080e7          	jalr	844(ra) # 80003fba <pipeclose>
    80003c76:	b7cd                	j	80003c58 <fileclose+0xa8>

0000000080003c78 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c78:	715d                	addi	sp,sp,-80
    80003c7a:	e486                	sd	ra,72(sp)
    80003c7c:	e0a2                	sd	s0,64(sp)
    80003c7e:	fc26                	sd	s1,56(sp)
    80003c80:	f84a                	sd	s2,48(sp)
    80003c82:	f44e                	sd	s3,40(sp)
    80003c84:	0880                	addi	s0,sp,80
    80003c86:	84aa                	mv	s1,a0
    80003c88:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c8a:	ffffd097          	auipc	ra,0xffffd
    80003c8e:	37c080e7          	jalr	892(ra) # 80001006 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c92:	409c                	lw	a5,0(s1)
    80003c94:	37f9                	addiw	a5,a5,-2
    80003c96:	4705                	li	a4,1
    80003c98:	04f76763          	bltu	a4,a5,80003ce6 <filestat+0x6e>
    80003c9c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c9e:	6c88                	ld	a0,24(s1)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	06c080e7          	jalr	108(ra) # 80002d0c <ilock>
    stati(f->ip, &st);
    80003ca8:	fb840593          	addi	a1,s0,-72
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	2e8080e7          	jalr	744(ra) # 80002f96 <stati>
    iunlock(f->ip);
    80003cb6:	6c88                	ld	a0,24(s1)
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	116080e7          	jalr	278(ra) # 80002dce <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cc0:	46e1                	li	a3,24
    80003cc2:	fb840613          	addi	a2,s0,-72
    80003cc6:	85ce                	mv	a1,s3
    80003cc8:	05093503          	ld	a0,80(s2)
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	f5e080e7          	jalr	-162(ra) # 80000c2a <copyout>
    80003cd4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd8:	60a6                	ld	ra,72(sp)
    80003cda:	6406                	ld	s0,64(sp)
    80003cdc:	74e2                	ld	s1,56(sp)
    80003cde:	7942                	ld	s2,48(sp)
    80003ce0:	79a2                	ld	s3,40(sp)
    80003ce2:	6161                	addi	sp,sp,80
    80003ce4:	8082                	ret
  return -1;
    80003ce6:	557d                	li	a0,-1
    80003ce8:	bfc5                	j	80003cd8 <filestat+0x60>

0000000080003cea <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e84a                	sd	s2,16(sp)
    80003cf4:	e44e                	sd	s3,8(sp)
    80003cf6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf8:	00854783          	lbu	a5,8(a0)
    80003cfc:	c3d5                	beqz	a5,80003da0 <fileread+0xb6>
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	89ae                	mv	s3,a1
    80003d02:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d04:	411c                	lw	a5,0(a0)
    80003d06:	4705                	li	a4,1
    80003d08:	04e78963          	beq	a5,a4,80003d5a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0c:	470d                	li	a4,3
    80003d0e:	04e78d63          	beq	a5,a4,80003d68 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d12:	4709                	li	a4,2
    80003d14:	06e79e63          	bne	a5,a4,80003d90 <fileread+0xa6>
    ilock(f->ip);
    80003d18:	6d08                	ld	a0,24(a0)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	ff2080e7          	jalr	-14(ra) # 80002d0c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d22:	874a                	mv	a4,s2
    80003d24:	5094                	lw	a3,32(s1)
    80003d26:	864e                	mv	a2,s3
    80003d28:	4585                	li	a1,1
    80003d2a:	6c88                	ld	a0,24(s1)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	294080e7          	jalr	660(ra) # 80002fc0 <readi>
    80003d34:	892a                	mv	s2,a0
    80003d36:	00a05563          	blez	a0,80003d40 <fileread+0x56>
      f->off += r;
    80003d3a:	509c                	lw	a5,32(s1)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	08c080e7          	jalr	140(ra) # 80002dce <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d4a:	854a                	mv	a0,s2
    80003d4c:	70a2                	ld	ra,40(sp)
    80003d4e:	7402                	ld	s0,32(sp)
    80003d50:	64e2                	ld	s1,24(sp)
    80003d52:	6942                	ld	s2,16(sp)
    80003d54:	69a2                	ld	s3,8(sp)
    80003d56:	6145                	addi	sp,sp,48
    80003d58:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d5a:	6908                	ld	a0,16(a0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	3c0080e7          	jalr	960(ra) # 8000411c <piperead>
    80003d64:	892a                	mv	s2,a0
    80003d66:	b7d5                	j	80003d4a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d68:	02451783          	lh	a5,36(a0)
    80003d6c:	03079693          	slli	a3,a5,0x30
    80003d70:	92c1                	srli	a3,a3,0x30
    80003d72:	4725                	li	a4,9
    80003d74:	02d76863          	bltu	a4,a3,80003da4 <fileread+0xba>
    80003d78:	0792                	slli	a5,a5,0x4
    80003d7a:	00235717          	auipc	a4,0x235
    80003d7e:	36670713          	addi	a4,a4,870 # 802390e0 <devsw>
    80003d82:	97ba                	add	a5,a5,a4
    80003d84:	639c                	ld	a5,0(a5)
    80003d86:	c38d                	beqz	a5,80003da8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d88:	4505                	li	a0,1
    80003d8a:	9782                	jalr	a5
    80003d8c:	892a                	mv	s2,a0
    80003d8e:	bf75                	j	80003d4a <fileread+0x60>
    panic("fileread");
    80003d90:	00005517          	auipc	a0,0x5
    80003d94:	8a050513          	addi	a0,a0,-1888 # 80008630 <syscalls+0x258>
    80003d98:	00002097          	auipc	ra,0x2
    80003d9c:	fe8080e7          	jalr	-24(ra) # 80005d80 <panic>
    return -1;
    80003da0:	597d                	li	s2,-1
    80003da2:	b765                	j	80003d4a <fileread+0x60>
      return -1;
    80003da4:	597d                	li	s2,-1
    80003da6:	b755                	j	80003d4a <fileread+0x60>
    80003da8:	597d                	li	s2,-1
    80003daa:	b745                	j	80003d4a <fileread+0x60>

0000000080003dac <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dac:	715d                	addi	sp,sp,-80
    80003dae:	e486                	sd	ra,72(sp)
    80003db0:	e0a2                	sd	s0,64(sp)
    80003db2:	fc26                	sd	s1,56(sp)
    80003db4:	f84a                	sd	s2,48(sp)
    80003db6:	f44e                	sd	s3,40(sp)
    80003db8:	f052                	sd	s4,32(sp)
    80003dba:	ec56                	sd	s5,24(sp)
    80003dbc:	e85a                	sd	s6,16(sp)
    80003dbe:	e45e                	sd	s7,8(sp)
    80003dc0:	e062                	sd	s8,0(sp)
    80003dc2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dc4:	00954783          	lbu	a5,9(a0)
    80003dc8:	10078663          	beqz	a5,80003ed4 <filewrite+0x128>
    80003dcc:	892a                	mv	s2,a0
    80003dce:	8b2e                	mv	s6,a1
    80003dd0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd2:	411c                	lw	a5,0(a0)
    80003dd4:	4705                	li	a4,1
    80003dd6:	02e78263          	beq	a5,a4,80003dfa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dda:	470d                	li	a4,3
    80003ddc:	02e78663          	beq	a5,a4,80003e08 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de0:	4709                	li	a4,2
    80003de2:	0ee79163          	bne	a5,a4,80003ec4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de6:	0ac05d63          	blez	a2,80003ea0 <filewrite+0xf4>
    int i = 0;
    80003dea:	4981                	li	s3,0
    80003dec:	6b85                	lui	s7,0x1
    80003dee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003df2:	6c05                	lui	s8,0x1
    80003df4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003df8:	a861                	j	80003e90 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dfa:	6908                	ld	a0,16(a0)
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	22e080e7          	jalr	558(ra) # 8000402a <pipewrite>
    80003e04:	8a2a                	mv	s4,a0
    80003e06:	a045                	j	80003ea6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e08:	02451783          	lh	a5,36(a0)
    80003e0c:	03079693          	slli	a3,a5,0x30
    80003e10:	92c1                	srli	a3,a3,0x30
    80003e12:	4725                	li	a4,9
    80003e14:	0cd76263          	bltu	a4,a3,80003ed8 <filewrite+0x12c>
    80003e18:	0792                	slli	a5,a5,0x4
    80003e1a:	00235717          	auipc	a4,0x235
    80003e1e:	2c670713          	addi	a4,a4,710 # 802390e0 <devsw>
    80003e22:	97ba                	add	a5,a5,a4
    80003e24:	679c                	ld	a5,8(a5)
    80003e26:	cbdd                	beqz	a5,80003edc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e28:	4505                	li	a0,1
    80003e2a:	9782                	jalr	a5
    80003e2c:	8a2a                	mv	s4,a0
    80003e2e:	a8a5                	j	80003ea6 <filewrite+0xfa>
    80003e30:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	8b4080e7          	jalr	-1868(ra) # 800036e8 <begin_op>
      ilock(f->ip);
    80003e3c:	01893503          	ld	a0,24(s2)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	ecc080e7          	jalr	-308(ra) # 80002d0c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e48:	8756                	mv	a4,s5
    80003e4a:	02092683          	lw	a3,32(s2)
    80003e4e:	01698633          	add	a2,s3,s6
    80003e52:	4585                	li	a1,1
    80003e54:	01893503          	ld	a0,24(s2)
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	260080e7          	jalr	608(ra) # 800030b8 <writei>
    80003e60:	84aa                	mv	s1,a0
    80003e62:	00a05763          	blez	a0,80003e70 <filewrite+0xc4>
        f->off += r;
    80003e66:	02092783          	lw	a5,32(s2)
    80003e6a:	9fa9                	addw	a5,a5,a0
    80003e6c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e70:	01893503          	ld	a0,24(s2)
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	f5a080e7          	jalr	-166(ra) # 80002dce <iunlock>
      end_op();
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	8ea080e7          	jalr	-1814(ra) # 80003766 <end_op>

      if(r != n1){
    80003e84:	009a9f63          	bne	s5,s1,80003ea2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e88:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e8c:	0149db63          	bge	s3,s4,80003ea2 <filewrite+0xf6>
      int n1 = n - i;
    80003e90:	413a04bb          	subw	s1,s4,s3
    80003e94:	0004879b          	sext.w	a5,s1
    80003e98:	f8fbdce3          	bge	s7,a5,80003e30 <filewrite+0x84>
    80003e9c:	84e2                	mv	s1,s8
    80003e9e:	bf49                	j	80003e30 <filewrite+0x84>
    int i = 0;
    80003ea0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ea2:	013a1f63          	bne	s4,s3,80003ec0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea6:	8552                	mv	a0,s4
    80003ea8:	60a6                	ld	ra,72(sp)
    80003eaa:	6406                	ld	s0,64(sp)
    80003eac:	74e2                	ld	s1,56(sp)
    80003eae:	7942                	ld	s2,48(sp)
    80003eb0:	79a2                	ld	s3,40(sp)
    80003eb2:	7a02                	ld	s4,32(sp)
    80003eb4:	6ae2                	ld	s5,24(sp)
    80003eb6:	6b42                	ld	s6,16(sp)
    80003eb8:	6ba2                	ld	s7,8(sp)
    80003eba:	6c02                	ld	s8,0(sp)
    80003ebc:	6161                	addi	sp,sp,80
    80003ebe:	8082                	ret
    ret = (i == n ? n : -1);
    80003ec0:	5a7d                	li	s4,-1
    80003ec2:	b7d5                	j	80003ea6 <filewrite+0xfa>
    panic("filewrite");
    80003ec4:	00004517          	auipc	a0,0x4
    80003ec8:	77c50513          	addi	a0,a0,1916 # 80008640 <syscalls+0x268>
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	eb4080e7          	jalr	-332(ra) # 80005d80 <panic>
    return -1;
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	bfc1                	j	80003ea6 <filewrite+0xfa>
      return -1;
    80003ed8:	5a7d                	li	s4,-1
    80003eda:	b7f1                	j	80003ea6 <filewrite+0xfa>
    80003edc:	5a7d                	li	s4,-1
    80003ede:	b7e1                	j	80003ea6 <filewrite+0xfa>

0000000080003ee0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ee0:	7179                	addi	sp,sp,-48
    80003ee2:	f406                	sd	ra,40(sp)
    80003ee4:	f022                	sd	s0,32(sp)
    80003ee6:	ec26                	sd	s1,24(sp)
    80003ee8:	e84a                	sd	s2,16(sp)
    80003eea:	e44e                	sd	s3,8(sp)
    80003eec:	e052                	sd	s4,0(sp)
    80003eee:	1800                	addi	s0,sp,48
    80003ef0:	84aa                	mv	s1,a0
    80003ef2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef4:	0005b023          	sd	zero,0(a1)
    80003ef8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	bf8080e7          	jalr	-1032(ra) # 80003af4 <filealloc>
    80003f04:	e088                	sd	a0,0(s1)
    80003f06:	c551                	beqz	a0,80003f92 <pipealloc+0xb2>
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	bec080e7          	jalr	-1044(ra) # 80003af4 <filealloc>
    80003f10:	00aa3023          	sd	a0,0(s4)
    80003f14:	c92d                	beqz	a0,80003f86 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	2d0080e7          	jalr	720(ra) # 800001e6 <kalloc>
    80003f1e:	892a                	mv	s2,a0
    80003f20:	c125                	beqz	a0,80003f80 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f22:	4985                	li	s3,1
    80003f24:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f28:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f2c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f30:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f34:	00004597          	auipc	a1,0x4
    80003f38:	71c58593          	addi	a1,a1,1820 # 80008650 <syscalls+0x278>
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	2ec080e7          	jalr	748(ra) # 80006228 <initlock>
  (*f0)->type = FD_PIPE;
    80003f44:	609c                	ld	a5,0(s1)
    80003f46:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f4a:	609c                	ld	a5,0(s1)
    80003f4c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f50:	609c                	ld	a5,0(s1)
    80003f52:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f56:	609c                	ld	a5,0(s1)
    80003f58:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f5c:	000a3783          	ld	a5,0(s4)
    80003f60:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f64:	000a3783          	ld	a5,0(s4)
    80003f68:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f6c:	000a3783          	ld	a5,0(s4)
    80003f70:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f74:	000a3783          	ld	a5,0(s4)
    80003f78:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f7c:	4501                	li	a0,0
    80003f7e:	a025                	j	80003fa6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f80:	6088                	ld	a0,0(s1)
    80003f82:	e501                	bnez	a0,80003f8a <pipealloc+0xaa>
    80003f84:	a039                	j	80003f92 <pipealloc+0xb2>
    80003f86:	6088                	ld	a0,0(s1)
    80003f88:	c51d                	beqz	a0,80003fb6 <pipealloc+0xd6>
    fileclose(*f0);
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	c26080e7          	jalr	-986(ra) # 80003bb0 <fileclose>
  if(*f1)
    80003f92:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f96:	557d                	li	a0,-1
  if(*f1)
    80003f98:	c799                	beqz	a5,80003fa6 <pipealloc+0xc6>
    fileclose(*f1);
    80003f9a:	853e                	mv	a0,a5
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	c14080e7          	jalr	-1004(ra) # 80003bb0 <fileclose>
  return -1;
    80003fa4:	557d                	li	a0,-1
}
    80003fa6:	70a2                	ld	ra,40(sp)
    80003fa8:	7402                	ld	s0,32(sp)
    80003faa:	64e2                	ld	s1,24(sp)
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	69a2                	ld	s3,8(sp)
    80003fb0:	6a02                	ld	s4,0(sp)
    80003fb2:	6145                	addi	sp,sp,48
    80003fb4:	8082                	ret
  return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	b7fd                	j	80003fa6 <pipealloc+0xc6>

0000000080003fba <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fba:	1101                	addi	sp,sp,-32
    80003fbc:	ec06                	sd	ra,24(sp)
    80003fbe:	e822                	sd	s0,16(sp)
    80003fc0:	e426                	sd	s1,8(sp)
    80003fc2:	e04a                	sd	s2,0(sp)
    80003fc4:	1000                	addi	s0,sp,32
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	2ee080e7          	jalr	750(ra) # 800062b8 <acquire>
  if(writable){
    80003fd2:	02090d63          	beqz	s2,8000400c <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fda:	21848513          	addi	a0,s1,536
    80003fde:	ffffe097          	auipc	ra,0xffffe
    80003fe2:	878080e7          	jalr	-1928(ra) # 80001856 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe6:	2204b783          	ld	a5,544(s1)
    80003fea:	eb95                	bnez	a5,8000401e <pipeclose+0x64>
    release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	37e080e7          	jalr	894(ra) # 8000636c <release>
    kfree((char*)pi);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	ffffc097          	auipc	ra,0xffffc
    80003ffc:	024080e7          	jalr	36(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004000:	60e2                	ld	ra,24(sp)
    80004002:	6442                	ld	s0,16(sp)
    80004004:	64a2                	ld	s1,8(sp)
    80004006:	6902                	ld	s2,0(sp)
    80004008:	6105                	addi	sp,sp,32
    8000400a:	8082                	ret
    pi->readopen = 0;
    8000400c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004010:	21c48513          	addi	a0,s1,540
    80004014:	ffffe097          	auipc	ra,0xffffe
    80004018:	842080e7          	jalr	-1982(ra) # 80001856 <wakeup>
    8000401c:	b7e9                	j	80003fe6 <pipeclose+0x2c>
    release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	34c080e7          	jalr	844(ra) # 8000636c <release>
}
    80004028:	bfe1                	j	80004000 <pipeclose+0x46>

000000008000402a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000402a:	711d                	addi	sp,sp,-96
    8000402c:	ec86                	sd	ra,88(sp)
    8000402e:	e8a2                	sd	s0,80(sp)
    80004030:	e4a6                	sd	s1,72(sp)
    80004032:	e0ca                	sd	s2,64(sp)
    80004034:	fc4e                	sd	s3,56(sp)
    80004036:	f852                	sd	s4,48(sp)
    80004038:	f456                	sd	s5,40(sp)
    8000403a:	f05a                	sd	s6,32(sp)
    8000403c:	ec5e                	sd	s7,24(sp)
    8000403e:	e862                	sd	s8,16(sp)
    80004040:	1080                	addi	s0,sp,96
    80004042:	84aa                	mv	s1,a0
    80004044:	8aae                	mv	s5,a1
    80004046:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	fbe080e7          	jalr	-66(ra) # 80001006 <myproc>
    80004050:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004052:	8526                	mv	a0,s1
    80004054:	00002097          	auipc	ra,0x2
    80004058:	264080e7          	jalr	612(ra) # 800062b8 <acquire>
  while(i < n){
    8000405c:	0b405363          	blez	s4,80004102 <pipewrite+0xd8>
  int i = 0;
    80004060:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004062:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004064:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004068:	21c48b93          	addi	s7,s1,540
    8000406c:	a089                	j	800040ae <pipewrite+0x84>
      release(&pi->lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	2fc080e7          	jalr	764(ra) # 8000636c <release>
      return -1;
    80004078:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000407a:	854a                	mv	a0,s2
    8000407c:	60e6                	ld	ra,88(sp)
    8000407e:	6446                	ld	s0,80(sp)
    80004080:	64a6                	ld	s1,72(sp)
    80004082:	6906                	ld	s2,64(sp)
    80004084:	79e2                	ld	s3,56(sp)
    80004086:	7a42                	ld	s4,48(sp)
    80004088:	7aa2                	ld	s5,40(sp)
    8000408a:	7b02                	ld	s6,32(sp)
    8000408c:	6be2                	ld	s7,24(sp)
    8000408e:	6c42                	ld	s8,16(sp)
    80004090:	6125                	addi	sp,sp,96
    80004092:	8082                	ret
      wakeup(&pi->nread);
    80004094:	8562                	mv	a0,s8
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	7c0080e7          	jalr	1984(ra) # 80001856 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000409e:	85a6                	mv	a1,s1
    800040a0:	855e                	mv	a0,s7
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	628080e7          	jalr	1576(ra) # 800016ca <sleep>
  while(i < n){
    800040aa:	05495d63          	bge	s2,s4,80004104 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040ae:	2204a783          	lw	a5,544(s1)
    800040b2:	dfd5                	beqz	a5,8000406e <pipewrite+0x44>
    800040b4:	0289a783          	lw	a5,40(s3)
    800040b8:	fbdd                	bnez	a5,8000406e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040ba:	2184a783          	lw	a5,536(s1)
    800040be:	21c4a703          	lw	a4,540(s1)
    800040c2:	2007879b          	addiw	a5,a5,512
    800040c6:	fcf707e3          	beq	a4,a5,80004094 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ca:	4685                	li	a3,1
    800040cc:	01590633          	add	a2,s2,s5
    800040d0:	faf40593          	addi	a1,s0,-81
    800040d4:	0509b503          	ld	a0,80(s3)
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	c7e080e7          	jalr	-898(ra) # 80000d56 <copyin>
    800040e0:	03650263          	beq	a0,s6,80004104 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040e4:	21c4a783          	lw	a5,540(s1)
    800040e8:	0017871b          	addiw	a4,a5,1
    800040ec:	20e4ae23          	sw	a4,540(s1)
    800040f0:	1ff7f793          	andi	a5,a5,511
    800040f4:	97a6                	add	a5,a5,s1
    800040f6:	faf44703          	lbu	a4,-81(s0)
    800040fa:	00e78c23          	sb	a4,24(a5)
      i++;
    800040fe:	2905                	addiw	s2,s2,1
    80004100:	b76d                	j	800040aa <pipewrite+0x80>
  int i = 0;
    80004102:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004104:	21848513          	addi	a0,s1,536
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	74e080e7          	jalr	1870(ra) # 80001856 <wakeup>
  release(&pi->lock);
    80004110:	8526                	mv	a0,s1
    80004112:	00002097          	auipc	ra,0x2
    80004116:	25a080e7          	jalr	602(ra) # 8000636c <release>
  return i;
    8000411a:	b785                	j	8000407a <pipewrite+0x50>

000000008000411c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000411c:	715d                	addi	sp,sp,-80
    8000411e:	e486                	sd	ra,72(sp)
    80004120:	e0a2                	sd	s0,64(sp)
    80004122:	fc26                	sd	s1,56(sp)
    80004124:	f84a                	sd	s2,48(sp)
    80004126:	f44e                	sd	s3,40(sp)
    80004128:	f052                	sd	s4,32(sp)
    8000412a:	ec56                	sd	s5,24(sp)
    8000412c:	e85a                	sd	s6,16(sp)
    8000412e:	0880                	addi	s0,sp,80
    80004130:	84aa                	mv	s1,a0
    80004132:	892e                	mv	s2,a1
    80004134:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	ed0080e7          	jalr	-304(ra) # 80001006 <myproc>
    8000413e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	176080e7          	jalr	374(ra) # 800062b8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414a:	2184a703          	lw	a4,536(s1)
    8000414e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004152:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004156:	02f71463          	bne	a4,a5,8000417e <piperead+0x62>
    8000415a:	2244a783          	lw	a5,548(s1)
    8000415e:	c385                	beqz	a5,8000417e <piperead+0x62>
    if(pr->killed){
    80004160:	028a2783          	lw	a5,40(s4)
    80004164:	ebc9                	bnez	a5,800041f6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004166:	85a6                	mv	a1,s1
    80004168:	854e                	mv	a0,s3
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	560080e7          	jalr	1376(ra) # 800016ca <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004172:	2184a703          	lw	a4,536(s1)
    80004176:	21c4a783          	lw	a5,540(s1)
    8000417a:	fef700e3          	beq	a4,a5,8000415a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004180:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004182:	05505463          	blez	s5,800041ca <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004186:	2184a783          	lw	a5,536(s1)
    8000418a:	21c4a703          	lw	a4,540(s1)
    8000418e:	02f70e63          	beq	a4,a5,800041ca <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004192:	0017871b          	addiw	a4,a5,1
    80004196:	20e4ac23          	sw	a4,536(s1)
    8000419a:	1ff7f793          	andi	a5,a5,511
    8000419e:	97a6                	add	a5,a5,s1
    800041a0:	0187c783          	lbu	a5,24(a5)
    800041a4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a8:	4685                	li	a3,1
    800041aa:	fbf40613          	addi	a2,s0,-65
    800041ae:	85ca                	mv	a1,s2
    800041b0:	050a3503          	ld	a0,80(s4)
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	a76080e7          	jalr	-1418(ra) # 80000c2a <copyout>
    800041bc:	01650763          	beq	a0,s6,800041ca <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c0:	2985                	addiw	s3,s3,1
    800041c2:	0905                	addi	s2,s2,1
    800041c4:	fd3a91e3          	bne	s5,s3,80004186 <piperead+0x6a>
    800041c8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ca:	21c48513          	addi	a0,s1,540
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	688080e7          	jalr	1672(ra) # 80001856 <wakeup>
  release(&pi->lock);
    800041d6:	8526                	mv	a0,s1
    800041d8:	00002097          	auipc	ra,0x2
    800041dc:	194080e7          	jalr	404(ra) # 8000636c <release>
  return i;
}
    800041e0:	854e                	mv	a0,s3
    800041e2:	60a6                	ld	ra,72(sp)
    800041e4:	6406                	ld	s0,64(sp)
    800041e6:	74e2                	ld	s1,56(sp)
    800041e8:	7942                	ld	s2,48(sp)
    800041ea:	79a2                	ld	s3,40(sp)
    800041ec:	7a02                	ld	s4,32(sp)
    800041ee:	6ae2                	ld	s5,24(sp)
    800041f0:	6b42                	ld	s6,16(sp)
    800041f2:	6161                	addi	sp,sp,80
    800041f4:	8082                	ret
      release(&pi->lock);
    800041f6:	8526                	mv	a0,s1
    800041f8:	00002097          	auipc	ra,0x2
    800041fc:	174080e7          	jalr	372(ra) # 8000636c <release>
      return -1;
    80004200:	59fd                	li	s3,-1
    80004202:	bff9                	j	800041e0 <piperead+0xc4>

0000000080004204 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004204:	de010113          	addi	sp,sp,-544
    80004208:	20113c23          	sd	ra,536(sp)
    8000420c:	20813823          	sd	s0,528(sp)
    80004210:	20913423          	sd	s1,520(sp)
    80004214:	21213023          	sd	s2,512(sp)
    80004218:	ffce                	sd	s3,504(sp)
    8000421a:	fbd2                	sd	s4,496(sp)
    8000421c:	f7d6                	sd	s5,488(sp)
    8000421e:	f3da                	sd	s6,480(sp)
    80004220:	efde                	sd	s7,472(sp)
    80004222:	ebe2                	sd	s8,464(sp)
    80004224:	e7e6                	sd	s9,456(sp)
    80004226:	e3ea                	sd	s10,448(sp)
    80004228:	ff6e                	sd	s11,440(sp)
    8000422a:	1400                	addi	s0,sp,544
    8000422c:	892a                	mv	s2,a0
    8000422e:	dea43423          	sd	a0,-536(s0)
    80004232:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	dd0080e7          	jalr	-560(ra) # 80001006 <myproc>
    8000423e:	84aa                	mv	s1,a0

  begin_op();
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	4a8080e7          	jalr	1192(ra) # 800036e8 <begin_op>

  if((ip = namei(path)) == 0){
    80004248:	854a                	mv	a0,s2
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	27e080e7          	jalr	638(ra) # 800034c8 <namei>
    80004252:	c93d                	beqz	a0,800042c8 <exec+0xc4>
    80004254:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	ab6080e7          	jalr	-1354(ra) # 80002d0c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000425e:	04000713          	li	a4,64
    80004262:	4681                	li	a3,0
    80004264:	e5040613          	addi	a2,s0,-432
    80004268:	4581                	li	a1,0
    8000426a:	8556                	mv	a0,s5
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	d54080e7          	jalr	-684(ra) # 80002fc0 <readi>
    80004274:	04000793          	li	a5,64
    80004278:	00f51a63          	bne	a0,a5,8000428c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000427c:	e5042703          	lw	a4,-432(s0)
    80004280:	464c47b7          	lui	a5,0x464c4
    80004284:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004288:	04f70663          	beq	a4,a5,800042d4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000428c:	8556                	mv	a0,s5
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	ce0080e7          	jalr	-800(ra) # 80002f6e <iunlockput>
    end_op();
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	4d0080e7          	jalr	1232(ra) # 80003766 <end_op>
  }
  return -1;
    8000429e:	557d                	li	a0,-1
}
    800042a0:	21813083          	ld	ra,536(sp)
    800042a4:	21013403          	ld	s0,528(sp)
    800042a8:	20813483          	ld	s1,520(sp)
    800042ac:	20013903          	ld	s2,512(sp)
    800042b0:	79fe                	ld	s3,504(sp)
    800042b2:	7a5e                	ld	s4,496(sp)
    800042b4:	7abe                	ld	s5,488(sp)
    800042b6:	7b1e                	ld	s6,480(sp)
    800042b8:	6bfe                	ld	s7,472(sp)
    800042ba:	6c5e                	ld	s8,464(sp)
    800042bc:	6cbe                	ld	s9,456(sp)
    800042be:	6d1e                	ld	s10,448(sp)
    800042c0:	7dfa                	ld	s11,440(sp)
    800042c2:	22010113          	addi	sp,sp,544
    800042c6:	8082                	ret
    end_op();
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	49e080e7          	jalr	1182(ra) # 80003766 <end_op>
    return -1;
    800042d0:	557d                	li	a0,-1
    800042d2:	b7f9                	j	800042a0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042d4:	8526                	mv	a0,s1
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	df4080e7          	jalr	-524(ra) # 800010ca <proc_pagetable>
    800042de:	8b2a                	mv	s6,a0
    800042e0:	d555                	beqz	a0,8000428c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e2:	e7042783          	lw	a5,-400(s0)
    800042e6:	e8845703          	lhu	a4,-376(s0)
    800042ea:	c735                	beqz	a4,80004356 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ec:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ee:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800042f2:	6a05                	lui	s4,0x1
    800042f4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042f8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042fc:	6d85                	lui	s11,0x1
    800042fe:	7d7d                	lui	s10,0xfffff
    80004300:	ac1d                	j	80004536 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004302:	00004517          	auipc	a0,0x4
    80004306:	35650513          	addi	a0,a0,854 # 80008658 <syscalls+0x280>
    8000430a:	00002097          	auipc	ra,0x2
    8000430e:	a76080e7          	jalr	-1418(ra) # 80005d80 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004312:	874a                	mv	a4,s2
    80004314:	009c86bb          	addw	a3,s9,s1
    80004318:	4581                	li	a1,0
    8000431a:	8556                	mv	a0,s5
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	ca4080e7          	jalr	-860(ra) # 80002fc0 <readi>
    80004324:	2501                	sext.w	a0,a0
    80004326:	1aa91863          	bne	s2,a0,800044d6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000432a:	009d84bb          	addw	s1,s11,s1
    8000432e:	013d09bb          	addw	s3,s10,s3
    80004332:	1f74f263          	bgeu	s1,s7,80004516 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004336:	02049593          	slli	a1,s1,0x20
    8000433a:	9181                	srli	a1,a1,0x20
    8000433c:	95e2                	add	a1,a1,s8
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	2c6080e7          	jalr	710(ra) # 80000606 <walkaddr>
    80004348:	862a                	mv	a2,a0
    if(pa == 0)
    8000434a:	dd45                	beqz	a0,80004302 <exec+0xfe>
      n = PGSIZE;
    8000434c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000434e:	fd49f2e3          	bgeu	s3,s4,80004312 <exec+0x10e>
      n = sz - i;
    80004352:	894e                	mv	s2,s3
    80004354:	bf7d                	j	80004312 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004356:	4481                	li	s1,0
  iunlockput(ip);
    80004358:	8556                	mv	a0,s5
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	c14080e7          	jalr	-1004(ra) # 80002f6e <iunlockput>
  end_op();
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	404080e7          	jalr	1028(ra) # 80003766 <end_op>
  p = myproc();
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	c9c080e7          	jalr	-868(ra) # 80001006 <myproc>
    80004372:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004374:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004378:	6785                	lui	a5,0x1
    8000437a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000437c:	97a6                	add	a5,a5,s1
    8000437e:	777d                	lui	a4,0xfffff
    80004380:	8ff9                	and	a5,a5,a4
    80004382:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004386:	6609                	lui	a2,0x2
    80004388:	963e                	add	a2,a2,a5
    8000438a:	85be                	mv	a1,a5
    8000438c:	855a                	mv	a0,s6
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	62c080e7          	jalr	1580(ra) # 800009ba <uvmalloc>
    80004396:	8c2a                	mv	s8,a0
  ip = 0;
    80004398:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000439a:	12050e63          	beqz	a0,800044d6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000439e:	75f9                	lui	a1,0xffffe
    800043a0:	95aa                	add	a1,a1,a0
    800043a2:	855a                	mv	a0,s6
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	854080e7          	jalr	-1964(ra) # 80000bf8 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ac:	7afd                	lui	s5,0xfffff
    800043ae:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b0:	df043783          	ld	a5,-528(s0)
    800043b4:	6388                	ld	a0,0(a5)
    800043b6:	c925                	beqz	a0,80004426 <exec+0x222>
    800043b8:	e9040993          	addi	s3,s0,-368
    800043bc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043c0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043c2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	038080e7          	jalr	56(ra) # 800003fc <strlen>
    800043cc:	0015079b          	addiw	a5,a0,1
    800043d0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043d8:	13596363          	bltu	s2,s5,800044fe <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043dc:	df043d83          	ld	s11,-528(s0)
    800043e0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043e4:	8552                	mv	a0,s4
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	016080e7          	jalr	22(ra) # 800003fc <strlen>
    800043ee:	0015069b          	addiw	a3,a0,1
    800043f2:	8652                	mv	a2,s4
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855a                	mv	a0,s6
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	832080e7          	jalr	-1998(ra) # 80000c2a <copyout>
    80004400:	10054363          	bltz	a0,80004506 <exec+0x302>
    ustack[argc] = sp;
    80004404:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004408:	0485                	addi	s1,s1,1
    8000440a:	008d8793          	addi	a5,s11,8
    8000440e:	def43823          	sd	a5,-528(s0)
    80004412:	008db503          	ld	a0,8(s11)
    80004416:	c911                	beqz	a0,8000442a <exec+0x226>
    if(argc >= MAXARG)
    80004418:	09a1                	addi	s3,s3,8
    8000441a:	fb3c95e3          	bne	s9,s3,800043c4 <exec+0x1c0>
  sz = sz1;
    8000441e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004422:	4a81                	li	s5,0
    80004424:	a84d                	j	800044d6 <exec+0x2d2>
  sp = sz;
    80004426:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004428:	4481                	li	s1,0
  ustack[argc] = 0;
    8000442a:	00349793          	slli	a5,s1,0x3
    8000442e:	f9078793          	addi	a5,a5,-112
    80004432:	97a2                	add	a5,a5,s0
    80004434:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004438:	00148693          	addi	a3,s1,1
    8000443c:	068e                	slli	a3,a3,0x3
    8000443e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004442:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004446:	01597663          	bgeu	s2,s5,80004452 <exec+0x24e>
  sz = sz1;
    8000444a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000444e:	4a81                	li	s5,0
    80004450:	a059                	j	800044d6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004452:	e9040613          	addi	a2,s0,-368
    80004456:	85ca                	mv	a1,s2
    80004458:	855a                	mv	a0,s6
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	7d0080e7          	jalr	2000(ra) # 80000c2a <copyout>
    80004462:	0a054663          	bltz	a0,8000450e <exec+0x30a>
  p->trapframe->a1 = sp;
    80004466:	058bb783          	ld	a5,88(s7)
    8000446a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000446e:	de843783          	ld	a5,-536(s0)
    80004472:	0007c703          	lbu	a4,0(a5)
    80004476:	cf11                	beqz	a4,80004492 <exec+0x28e>
    80004478:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000447a:	02f00693          	li	a3,47
    8000447e:	a039                	j	8000448c <exec+0x288>
      last = s+1;
    80004480:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004484:	0785                	addi	a5,a5,1
    80004486:	fff7c703          	lbu	a4,-1(a5)
    8000448a:	c701                	beqz	a4,80004492 <exec+0x28e>
    if(*s == '/')
    8000448c:	fed71ce3          	bne	a4,a3,80004484 <exec+0x280>
    80004490:	bfc5                	j	80004480 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004492:	4641                	li	a2,16
    80004494:	de843583          	ld	a1,-536(s0)
    80004498:	158b8513          	addi	a0,s7,344
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	f2e080e7          	jalr	-210(ra) # 800003ca <safestrcpy>
  oldpagetable = p->pagetable;
    800044a4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800044a8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044ac:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044b0:	058bb783          	ld	a5,88(s7)
    800044b4:	e6843703          	ld	a4,-408(s0)
    800044b8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ba:	058bb783          	ld	a5,88(s7)
    800044be:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c2:	85ea                	mv	a1,s10
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	ca2080e7          	jalr	-862(ra) # 80001166 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044cc:	0004851b          	sext.w	a0,s1
    800044d0:	bbc1                	j	800042a0 <exec+0x9c>
    800044d2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044d6:	df843583          	ld	a1,-520(s0)
    800044da:	855a                	mv	a0,s6
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	c8a080e7          	jalr	-886(ra) # 80001166 <proc_freepagetable>
  if(ip){
    800044e4:	da0a94e3          	bnez	s5,8000428c <exec+0x88>
  return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	bb5d                	j	800042a0 <exec+0x9c>
    800044ec:	de943c23          	sd	s1,-520(s0)
    800044f0:	b7dd                	j	800044d6 <exec+0x2d2>
    800044f2:	de943c23          	sd	s1,-520(s0)
    800044f6:	b7c5                	j	800044d6 <exec+0x2d2>
    800044f8:	de943c23          	sd	s1,-520(s0)
    800044fc:	bfe9                	j	800044d6 <exec+0x2d2>
  sz = sz1;
    800044fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004502:	4a81                	li	s5,0
    80004504:	bfc9                	j	800044d6 <exec+0x2d2>
  sz = sz1;
    80004506:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000450a:	4a81                	li	s5,0
    8000450c:	b7e9                	j	800044d6 <exec+0x2d2>
  sz = sz1;
    8000450e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004512:	4a81                	li	s5,0
    80004514:	b7c9                	j	800044d6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004516:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451a:	e0843783          	ld	a5,-504(s0)
    8000451e:	0017869b          	addiw	a3,a5,1
    80004522:	e0d43423          	sd	a3,-504(s0)
    80004526:	e0043783          	ld	a5,-512(s0)
    8000452a:	0387879b          	addiw	a5,a5,56
    8000452e:	e8845703          	lhu	a4,-376(s0)
    80004532:	e2e6d3e3          	bge	a3,a4,80004358 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004536:	2781                	sext.w	a5,a5
    80004538:	e0f43023          	sd	a5,-512(s0)
    8000453c:	03800713          	li	a4,56
    80004540:	86be                	mv	a3,a5
    80004542:	e1840613          	addi	a2,s0,-488
    80004546:	4581                	li	a1,0
    80004548:	8556                	mv	a0,s5
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	a76080e7          	jalr	-1418(ra) # 80002fc0 <readi>
    80004552:	03800793          	li	a5,56
    80004556:	f6f51ee3          	bne	a0,a5,800044d2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000455a:	e1842783          	lw	a5,-488(s0)
    8000455e:	4705                	li	a4,1
    80004560:	fae79de3          	bne	a5,a4,8000451a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004564:	e4043603          	ld	a2,-448(s0)
    80004568:	e3843783          	ld	a5,-456(s0)
    8000456c:	f8f660e3          	bltu	a2,a5,800044ec <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004570:	e2843783          	ld	a5,-472(s0)
    80004574:	963e                	add	a2,a2,a5
    80004576:	f6f66ee3          	bltu	a2,a5,800044f2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000457a:	85a6                	mv	a1,s1
    8000457c:	855a                	mv	a0,s6
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	43c080e7          	jalr	1084(ra) # 800009ba <uvmalloc>
    80004586:	dea43c23          	sd	a0,-520(s0)
    8000458a:	d53d                	beqz	a0,800044f8 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000458c:	e2843c03          	ld	s8,-472(s0)
    80004590:	de043783          	ld	a5,-544(s0)
    80004594:	00fc77b3          	and	a5,s8,a5
    80004598:	ff9d                	bnez	a5,800044d6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000459a:	e2042c83          	lw	s9,-480(s0)
    8000459e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045a2:	f60b8ae3          	beqz	s7,80004516 <exec+0x312>
    800045a6:	89de                	mv	s3,s7
    800045a8:	4481                	li	s1,0
    800045aa:	b371                	j	80004336 <exec+0x132>

00000000800045ac <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045ac:	7179                	addi	sp,sp,-48
    800045ae:	f406                	sd	ra,40(sp)
    800045b0:	f022                	sd	s0,32(sp)
    800045b2:	ec26                	sd	s1,24(sp)
    800045b4:	e84a                	sd	s2,16(sp)
    800045b6:	1800                	addi	s0,sp,48
    800045b8:	892e                	mv	s2,a1
    800045ba:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045bc:	fdc40593          	addi	a1,s0,-36
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	bda080e7          	jalr	-1062(ra) # 8000219a <argint>
    800045c8:	04054063          	bltz	a0,80004608 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045cc:	fdc42703          	lw	a4,-36(s0)
    800045d0:	47bd                	li	a5,15
    800045d2:	02e7ed63          	bltu	a5,a4,8000460c <argfd+0x60>
    800045d6:	ffffd097          	auipc	ra,0xffffd
    800045da:	a30080e7          	jalr	-1488(ra) # 80001006 <myproc>
    800045de:	fdc42703          	lw	a4,-36(s0)
    800045e2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdb8dda>
    800045e6:	078e                	slli	a5,a5,0x3
    800045e8:	953e                	add	a0,a0,a5
    800045ea:	611c                	ld	a5,0(a0)
    800045ec:	c395                	beqz	a5,80004610 <argfd+0x64>
    return -1;
  if(pfd)
    800045ee:	00090463          	beqz	s2,800045f6 <argfd+0x4a>
    *pfd = fd;
    800045f2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045f6:	4501                	li	a0,0
  if(pf)
    800045f8:	c091                	beqz	s1,800045fc <argfd+0x50>
    *pf = f;
    800045fa:	e09c                	sd	a5,0(s1)
}
    800045fc:	70a2                	ld	ra,40(sp)
    800045fe:	7402                	ld	s0,32(sp)
    80004600:	64e2                	ld	s1,24(sp)
    80004602:	6942                	ld	s2,16(sp)
    80004604:	6145                	addi	sp,sp,48
    80004606:	8082                	ret
    return -1;
    80004608:	557d                	li	a0,-1
    8000460a:	bfcd                	j	800045fc <argfd+0x50>
    return -1;
    8000460c:	557d                	li	a0,-1
    8000460e:	b7fd                	j	800045fc <argfd+0x50>
    80004610:	557d                	li	a0,-1
    80004612:	b7ed                	j	800045fc <argfd+0x50>

0000000080004614 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004614:	1101                	addi	sp,sp,-32
    80004616:	ec06                	sd	ra,24(sp)
    80004618:	e822                	sd	s0,16(sp)
    8000461a:	e426                	sd	s1,8(sp)
    8000461c:	1000                	addi	s0,sp,32
    8000461e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004620:	ffffd097          	auipc	ra,0xffffd
    80004624:	9e6080e7          	jalr	-1562(ra) # 80001006 <myproc>
    80004628:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000462a:	0d050793          	addi	a5,a0,208
    8000462e:	4501                	li	a0,0
    80004630:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004632:	6398                	ld	a4,0(a5)
    80004634:	cb19                	beqz	a4,8000464a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004636:	2505                	addiw	a0,a0,1
    80004638:	07a1                	addi	a5,a5,8
    8000463a:	fed51ce3          	bne	a0,a3,80004632 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000463e:	557d                	li	a0,-1
}
    80004640:	60e2                	ld	ra,24(sp)
    80004642:	6442                	ld	s0,16(sp)
    80004644:	64a2                	ld	s1,8(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret
      p->ofile[fd] = f;
    8000464a:	01a50793          	addi	a5,a0,26
    8000464e:	078e                	slli	a5,a5,0x3
    80004650:	963e                	add	a2,a2,a5
    80004652:	e204                	sd	s1,0(a2)
      return fd;
    80004654:	b7f5                	j	80004640 <fdalloc+0x2c>

0000000080004656 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004656:	715d                	addi	sp,sp,-80
    80004658:	e486                	sd	ra,72(sp)
    8000465a:	e0a2                	sd	s0,64(sp)
    8000465c:	fc26                	sd	s1,56(sp)
    8000465e:	f84a                	sd	s2,48(sp)
    80004660:	f44e                	sd	s3,40(sp)
    80004662:	f052                	sd	s4,32(sp)
    80004664:	ec56                	sd	s5,24(sp)
    80004666:	0880                	addi	s0,sp,80
    80004668:	89ae                	mv	s3,a1
    8000466a:	8ab2                	mv	s5,a2
    8000466c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000466e:	fb040593          	addi	a1,s0,-80
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	e74080e7          	jalr	-396(ra) # 800034e6 <nameiparent>
    8000467a:	892a                	mv	s2,a0
    8000467c:	12050e63          	beqz	a0,800047b8 <create+0x162>
    return 0;

  ilock(dp);
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	68c080e7          	jalr	1676(ra) # 80002d0c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004688:	4601                	li	a2,0
    8000468a:	fb040593          	addi	a1,s0,-80
    8000468e:	854a                	mv	a0,s2
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	b60080e7          	jalr	-1184(ra) # 800031f0 <dirlookup>
    80004698:	84aa                	mv	s1,a0
    8000469a:	c921                	beqz	a0,800046ea <create+0x94>
    iunlockput(dp);
    8000469c:	854a                	mv	a0,s2
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	8d0080e7          	jalr	-1840(ra) # 80002f6e <iunlockput>
    ilock(ip);
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	664080e7          	jalr	1636(ra) # 80002d0c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b0:	2981                	sext.w	s3,s3
    800046b2:	4789                	li	a5,2
    800046b4:	02f99463          	bne	s3,a5,800046dc <create+0x86>
    800046b8:	0444d783          	lhu	a5,68(s1)
    800046bc:	37f9                	addiw	a5,a5,-2
    800046be:	17c2                	slli	a5,a5,0x30
    800046c0:	93c1                	srli	a5,a5,0x30
    800046c2:	4705                	li	a4,1
    800046c4:	00f76c63          	bltu	a4,a5,800046dc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046c8:	8526                	mv	a0,s1
    800046ca:	60a6                	ld	ra,72(sp)
    800046cc:	6406                	ld	s0,64(sp)
    800046ce:	74e2                	ld	s1,56(sp)
    800046d0:	7942                	ld	s2,48(sp)
    800046d2:	79a2                	ld	s3,40(sp)
    800046d4:	7a02                	ld	s4,32(sp)
    800046d6:	6ae2                	ld	s5,24(sp)
    800046d8:	6161                	addi	sp,sp,80
    800046da:	8082                	ret
    iunlockput(ip);
    800046dc:	8526                	mv	a0,s1
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	890080e7          	jalr	-1904(ra) # 80002f6e <iunlockput>
    return 0;
    800046e6:	4481                	li	s1,0
    800046e8:	b7c5                	j	800046c8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046ea:	85ce                	mv	a1,s3
    800046ec:	00092503          	lw	a0,0(s2)
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	482080e7          	jalr	1154(ra) # 80002b72 <ialloc>
    800046f8:	84aa                	mv	s1,a0
    800046fa:	c521                	beqz	a0,80004742 <create+0xec>
  ilock(ip);
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	610080e7          	jalr	1552(ra) # 80002d0c <ilock>
  ip->major = major;
    80004704:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004708:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000470c:	4a05                	li	s4,1
    8000470e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004712:	8526                	mv	a0,s1
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	52c080e7          	jalr	1324(ra) # 80002c40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000471c:	2981                	sext.w	s3,s3
    8000471e:	03498a63          	beq	s3,s4,80004752 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004722:	40d0                	lw	a2,4(s1)
    80004724:	fb040593          	addi	a1,s0,-80
    80004728:	854a                	mv	a0,s2
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	cdc080e7          	jalr	-804(ra) # 80003406 <dirlink>
    80004732:	06054b63          	bltz	a0,800047a8 <create+0x152>
  iunlockput(dp);
    80004736:	854a                	mv	a0,s2
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	836080e7          	jalr	-1994(ra) # 80002f6e <iunlockput>
  return ip;
    80004740:	b761                	j	800046c8 <create+0x72>
    panic("create: ialloc");
    80004742:	00004517          	auipc	a0,0x4
    80004746:	f3650513          	addi	a0,a0,-202 # 80008678 <syscalls+0x2a0>
    8000474a:	00001097          	auipc	ra,0x1
    8000474e:	636080e7          	jalr	1590(ra) # 80005d80 <panic>
    dp->nlink++;  // for ".."
    80004752:	04a95783          	lhu	a5,74(s2)
    80004756:	2785                	addiw	a5,a5,1
    80004758:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000475c:	854a                	mv	a0,s2
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	4e2080e7          	jalr	1250(ra) # 80002c40 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004766:	40d0                	lw	a2,4(s1)
    80004768:	00004597          	auipc	a1,0x4
    8000476c:	f2058593          	addi	a1,a1,-224 # 80008688 <syscalls+0x2b0>
    80004770:	8526                	mv	a0,s1
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	c94080e7          	jalr	-876(ra) # 80003406 <dirlink>
    8000477a:	00054f63          	bltz	a0,80004798 <create+0x142>
    8000477e:	00492603          	lw	a2,4(s2)
    80004782:	00004597          	auipc	a1,0x4
    80004786:	f0e58593          	addi	a1,a1,-242 # 80008690 <syscalls+0x2b8>
    8000478a:	8526                	mv	a0,s1
    8000478c:	fffff097          	auipc	ra,0xfffff
    80004790:	c7a080e7          	jalr	-902(ra) # 80003406 <dirlink>
    80004794:	f80557e3          	bgez	a0,80004722 <create+0xcc>
      panic("create dots");
    80004798:	00004517          	auipc	a0,0x4
    8000479c:	f0050513          	addi	a0,a0,-256 # 80008698 <syscalls+0x2c0>
    800047a0:	00001097          	auipc	ra,0x1
    800047a4:	5e0080e7          	jalr	1504(ra) # 80005d80 <panic>
    panic("create: dirlink");
    800047a8:	00004517          	auipc	a0,0x4
    800047ac:	f0050513          	addi	a0,a0,-256 # 800086a8 <syscalls+0x2d0>
    800047b0:	00001097          	auipc	ra,0x1
    800047b4:	5d0080e7          	jalr	1488(ra) # 80005d80 <panic>
    return 0;
    800047b8:	84aa                	mv	s1,a0
    800047ba:	b739                	j	800046c8 <create+0x72>

00000000800047bc <sys_dup>:
{
    800047bc:	7179                	addi	sp,sp,-48
    800047be:	f406                	sd	ra,40(sp)
    800047c0:	f022                	sd	s0,32(sp)
    800047c2:	ec26                	sd	s1,24(sp)
    800047c4:	e84a                	sd	s2,16(sp)
    800047c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047c8:	fd840613          	addi	a2,s0,-40
    800047cc:	4581                	li	a1,0
    800047ce:	4501                	li	a0,0
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	ddc080e7          	jalr	-548(ra) # 800045ac <argfd>
    return -1;
    800047d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047da:	02054363          	bltz	a0,80004800 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047de:	fd843903          	ld	s2,-40(s0)
    800047e2:	854a                	mv	a0,s2
    800047e4:	00000097          	auipc	ra,0x0
    800047e8:	e30080e7          	jalr	-464(ra) # 80004614 <fdalloc>
    800047ec:	84aa                	mv	s1,a0
    return -1;
    800047ee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047f0:	00054863          	bltz	a0,80004800 <sys_dup+0x44>
  filedup(f);
    800047f4:	854a                	mv	a0,s2
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	368080e7          	jalr	872(ra) # 80003b5e <filedup>
  return fd;
    800047fe:	87a6                	mv	a5,s1
}
    80004800:	853e                	mv	a0,a5
    80004802:	70a2                	ld	ra,40(sp)
    80004804:	7402                	ld	s0,32(sp)
    80004806:	64e2                	ld	s1,24(sp)
    80004808:	6942                	ld	s2,16(sp)
    8000480a:	6145                	addi	sp,sp,48
    8000480c:	8082                	ret

000000008000480e <sys_read>:
{
    8000480e:	7179                	addi	sp,sp,-48
    80004810:	f406                	sd	ra,40(sp)
    80004812:	f022                	sd	s0,32(sp)
    80004814:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	fe840613          	addi	a2,s0,-24
    8000481a:	4581                	li	a1,0
    8000481c:	4501                	li	a0,0
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	d8e080e7          	jalr	-626(ra) # 800045ac <argfd>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	04054163          	bltz	a0,8000486a <sys_read+0x5c>
    8000482c:	fe440593          	addi	a1,s0,-28
    80004830:	4509                	li	a0,2
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	968080e7          	jalr	-1688(ra) # 8000219a <argint>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	02054763          	bltz	a0,8000486a <sys_read+0x5c>
    80004840:	fd840593          	addi	a1,s0,-40
    80004844:	4505                	li	a0,1
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	976080e7          	jalr	-1674(ra) # 800021bc <argaddr>
    return -1;
    8000484e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	00054d63          	bltz	a0,8000486a <sys_read+0x5c>
  return fileread(f, p, n);
    80004854:	fe442603          	lw	a2,-28(s0)
    80004858:	fd843583          	ld	a1,-40(s0)
    8000485c:	fe843503          	ld	a0,-24(s0)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	48a080e7          	jalr	1162(ra) # 80003cea <fileread>
    80004868:	87aa                	mv	a5,a0
}
    8000486a:	853e                	mv	a0,a5
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	6145                	addi	sp,sp,48
    80004872:	8082                	ret

0000000080004874 <sys_write>:
{
    80004874:	7179                	addi	sp,sp,-48
    80004876:	f406                	sd	ra,40(sp)
    80004878:	f022                	sd	s0,32(sp)
    8000487a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	fe840613          	addi	a2,s0,-24
    80004880:	4581                	li	a1,0
    80004882:	4501                	li	a0,0
    80004884:	00000097          	auipc	ra,0x0
    80004888:	d28080e7          	jalr	-728(ra) # 800045ac <argfd>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	04054163          	bltz	a0,800048d0 <sys_write+0x5c>
    80004892:	fe440593          	addi	a1,s0,-28
    80004896:	4509                	li	a0,2
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	902080e7          	jalr	-1790(ra) # 8000219a <argint>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	02054763          	bltz	a0,800048d0 <sys_write+0x5c>
    800048a6:	fd840593          	addi	a1,s0,-40
    800048aa:	4505                	li	a0,1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	910080e7          	jalr	-1776(ra) # 800021bc <argaddr>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b6:	00054d63          	bltz	a0,800048d0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048ba:	fe442603          	lw	a2,-28(s0)
    800048be:	fd843583          	ld	a1,-40(s0)
    800048c2:	fe843503          	ld	a0,-24(s0)
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	4e6080e7          	jalr	1254(ra) # 80003dac <filewrite>
    800048ce:	87aa                	mv	a5,a0
}
    800048d0:	853e                	mv	a0,a5
    800048d2:	70a2                	ld	ra,40(sp)
    800048d4:	7402                	ld	s0,32(sp)
    800048d6:	6145                	addi	sp,sp,48
    800048d8:	8082                	ret

00000000800048da <sys_close>:
{
    800048da:	1101                	addi	sp,sp,-32
    800048dc:	ec06                	sd	ra,24(sp)
    800048de:	e822                	sd	s0,16(sp)
    800048e0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048e2:	fe040613          	addi	a2,s0,-32
    800048e6:	fec40593          	addi	a1,s0,-20
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	cc0080e7          	jalr	-832(ra) # 800045ac <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048f6:	02054463          	bltz	a0,8000491e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	70c080e7          	jalr	1804(ra) # 80001006 <myproc>
    80004902:	fec42783          	lw	a5,-20(s0)
    80004906:	07e9                	addi	a5,a5,26
    80004908:	078e                	slli	a5,a5,0x3
    8000490a:	953e                	add	a0,a0,a5
    8000490c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004910:	fe043503          	ld	a0,-32(s0)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	29c080e7          	jalr	668(ra) # 80003bb0 <fileclose>
  return 0;
    8000491c:	4781                	li	a5,0
}
    8000491e:	853e                	mv	a0,a5
    80004920:	60e2                	ld	ra,24(sp)
    80004922:	6442                	ld	s0,16(sp)
    80004924:	6105                	addi	sp,sp,32
    80004926:	8082                	ret

0000000080004928 <sys_fstat>:
{
    80004928:	1101                	addi	sp,sp,-32
    8000492a:	ec06                	sd	ra,24(sp)
    8000492c:	e822                	sd	s0,16(sp)
    8000492e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004930:	fe840613          	addi	a2,s0,-24
    80004934:	4581                	li	a1,0
    80004936:	4501                	li	a0,0
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	c74080e7          	jalr	-908(ra) # 800045ac <argfd>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004942:	02054563          	bltz	a0,8000496c <sys_fstat+0x44>
    80004946:	fe040593          	addi	a1,s0,-32
    8000494a:	4505                	li	a0,1
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	870080e7          	jalr	-1936(ra) # 800021bc <argaddr>
    return -1;
    80004954:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004956:	00054b63          	bltz	a0,8000496c <sys_fstat+0x44>
  return filestat(f, st);
    8000495a:	fe043583          	ld	a1,-32(s0)
    8000495e:	fe843503          	ld	a0,-24(s0)
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	316080e7          	jalr	790(ra) # 80003c78 <filestat>
    8000496a:	87aa                	mv	a5,a0
}
    8000496c:	853e                	mv	a0,a5
    8000496e:	60e2                	ld	ra,24(sp)
    80004970:	6442                	ld	s0,16(sp)
    80004972:	6105                	addi	sp,sp,32
    80004974:	8082                	ret

0000000080004976 <sys_link>:
{
    80004976:	7169                	addi	sp,sp,-304
    80004978:	f606                	sd	ra,296(sp)
    8000497a:	f222                	sd	s0,288(sp)
    8000497c:	ee26                	sd	s1,280(sp)
    8000497e:	ea4a                	sd	s2,272(sp)
    80004980:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	08000613          	li	a2,128
    80004986:	ed040593          	addi	a1,s0,-304
    8000498a:	4501                	li	a0,0
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	852080e7          	jalr	-1966(ra) # 800021de <argstr>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004996:	10054e63          	bltz	a0,80004ab2 <sys_link+0x13c>
    8000499a:	08000613          	li	a2,128
    8000499e:	f5040593          	addi	a1,s0,-176
    800049a2:	4505                	li	a0,1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	83a080e7          	jalr	-1990(ra) # 800021de <argstr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ae:	10054263          	bltz	a0,80004ab2 <sys_link+0x13c>
  begin_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	d36080e7          	jalr	-714(ra) # 800036e8 <begin_op>
  if((ip = namei(old)) == 0){
    800049ba:	ed040513          	addi	a0,s0,-304
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	b0a080e7          	jalr	-1270(ra) # 800034c8 <namei>
    800049c6:	84aa                	mv	s1,a0
    800049c8:	c551                	beqz	a0,80004a54 <sys_link+0xde>
  ilock(ip);
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	342080e7          	jalr	834(ra) # 80002d0c <ilock>
  if(ip->type == T_DIR){
    800049d2:	04449703          	lh	a4,68(s1)
    800049d6:	4785                	li	a5,1
    800049d8:	08f70463          	beq	a4,a5,80004a60 <sys_link+0xea>
  ip->nlink++;
    800049dc:	04a4d783          	lhu	a5,74(s1)
    800049e0:	2785                	addiw	a5,a5,1
    800049e2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	258080e7          	jalr	600(ra) # 80002c40 <iupdate>
  iunlock(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	3dc080e7          	jalr	988(ra) # 80002dce <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fa:	fd040593          	addi	a1,s0,-48
    800049fe:	f5040513          	addi	a0,s0,-176
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	ae4080e7          	jalr	-1308(ra) # 800034e6 <nameiparent>
    80004a0a:	892a                	mv	s2,a0
    80004a0c:	c935                	beqz	a0,80004a80 <sys_link+0x10a>
  ilock(dp);
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	2fe080e7          	jalr	766(ra) # 80002d0c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a16:	00092703          	lw	a4,0(s2)
    80004a1a:	409c                	lw	a5,0(s1)
    80004a1c:	04f71d63          	bne	a4,a5,80004a76 <sys_link+0x100>
    80004a20:	40d0                	lw	a2,4(s1)
    80004a22:	fd040593          	addi	a1,s0,-48
    80004a26:	854a                	mv	a0,s2
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	9de080e7          	jalr	-1570(ra) # 80003406 <dirlink>
    80004a30:	04054363          	bltz	a0,80004a76 <sys_link+0x100>
  iunlockput(dp);
    80004a34:	854a                	mv	a0,s2
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	538080e7          	jalr	1336(ra) # 80002f6e <iunlockput>
  iput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	486080e7          	jalr	1158(ra) # 80002ec6 <iput>
  end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	d1e080e7          	jalr	-738(ra) # 80003766 <end_op>
  return 0;
    80004a50:	4781                	li	a5,0
    80004a52:	a085                	j	80004ab2 <sys_link+0x13c>
    end_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	d12080e7          	jalr	-750(ra) # 80003766 <end_op>
    return -1;
    80004a5c:	57fd                	li	a5,-1
    80004a5e:	a891                	j	80004ab2 <sys_link+0x13c>
    iunlockput(ip);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	50c080e7          	jalr	1292(ra) # 80002f6e <iunlockput>
    end_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	cfc080e7          	jalr	-772(ra) # 80003766 <end_op>
    return -1;
    80004a72:	57fd                	li	a5,-1
    80004a74:	a83d                	j	80004ab2 <sys_link+0x13c>
    iunlockput(dp);
    80004a76:	854a                	mv	a0,s2
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	4f6080e7          	jalr	1270(ra) # 80002f6e <iunlockput>
  ilock(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	28a080e7          	jalr	650(ra) # 80002d0c <ilock>
  ip->nlink--;
    80004a8a:	04a4d783          	lhu	a5,74(s1)
    80004a8e:	37fd                	addiw	a5,a5,-1
    80004a90:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	1aa080e7          	jalr	426(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	4ce080e7          	jalr	1230(ra) # 80002f6e <iunlockput>
  end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	cbe080e7          	jalr	-834(ra) # 80003766 <end_op>
  return -1;
    80004ab0:	57fd                	li	a5,-1
}
    80004ab2:	853e                	mv	a0,a5
    80004ab4:	70b2                	ld	ra,296(sp)
    80004ab6:	7412                	ld	s0,288(sp)
    80004ab8:	64f2                	ld	s1,280(sp)
    80004aba:	6952                	ld	s2,272(sp)
    80004abc:	6155                	addi	sp,sp,304
    80004abe:	8082                	ret

0000000080004ac0 <sys_unlink>:
{
    80004ac0:	7151                	addi	sp,sp,-240
    80004ac2:	f586                	sd	ra,232(sp)
    80004ac4:	f1a2                	sd	s0,224(sp)
    80004ac6:	eda6                	sd	s1,216(sp)
    80004ac8:	e9ca                	sd	s2,208(sp)
    80004aca:	e5ce                	sd	s3,200(sp)
    80004acc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ace:	08000613          	li	a2,128
    80004ad2:	f3040593          	addi	a1,s0,-208
    80004ad6:	4501                	li	a0,0
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	706080e7          	jalr	1798(ra) # 800021de <argstr>
    80004ae0:	18054163          	bltz	a0,80004c62 <sys_unlink+0x1a2>
  begin_op();
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	c04080e7          	jalr	-1020(ra) # 800036e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aec:	fb040593          	addi	a1,s0,-80
    80004af0:	f3040513          	addi	a0,s0,-208
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	9f2080e7          	jalr	-1550(ra) # 800034e6 <nameiparent>
    80004afc:	84aa                	mv	s1,a0
    80004afe:	c979                	beqz	a0,80004bd4 <sys_unlink+0x114>
  ilock(dp);
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	20c080e7          	jalr	524(ra) # 80002d0c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b08:	00004597          	auipc	a1,0x4
    80004b0c:	b8058593          	addi	a1,a1,-1152 # 80008688 <syscalls+0x2b0>
    80004b10:	fb040513          	addi	a0,s0,-80
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	6c2080e7          	jalr	1730(ra) # 800031d6 <namecmp>
    80004b1c:	14050a63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
    80004b20:	00004597          	auipc	a1,0x4
    80004b24:	b7058593          	addi	a1,a1,-1168 # 80008690 <syscalls+0x2b8>
    80004b28:	fb040513          	addi	a0,s0,-80
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	6aa080e7          	jalr	1706(ra) # 800031d6 <namecmp>
    80004b34:	12050e63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b38:	f2c40613          	addi	a2,s0,-212
    80004b3c:	fb040593          	addi	a1,s0,-80
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	6ae080e7          	jalr	1710(ra) # 800031f0 <dirlookup>
    80004b4a:	892a                	mv	s2,a0
    80004b4c:	12050263          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  ilock(ip);
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	1bc080e7          	jalr	444(ra) # 80002d0c <ilock>
  if(ip->nlink < 1)
    80004b58:	04a91783          	lh	a5,74(s2)
    80004b5c:	08f05263          	blez	a5,80004be0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b60:	04491703          	lh	a4,68(s2)
    80004b64:	4785                	li	a5,1
    80004b66:	08f70563          	beq	a4,a5,80004bf0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b6a:	4641                	li	a2,16
    80004b6c:	4581                	li	a1,0
    80004b6e:	fc040513          	addi	a0,s0,-64
    80004b72:	ffffb097          	auipc	ra,0xffffb
    80004b76:	70e080e7          	jalr	1806(ra) # 80000280 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	f2c42683          	lw	a3,-212(s0)
    80004b80:	fc040613          	addi	a2,s0,-64
    80004b84:	4581                	li	a1,0
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	530080e7          	jalr	1328(ra) # 800030b8 <writei>
    80004b90:	47c1                	li	a5,16
    80004b92:	0af51563          	bne	a0,a5,80004c3c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b96:	04491703          	lh	a4,68(s2)
    80004b9a:	4785                	li	a5,1
    80004b9c:	0af70863          	beq	a4,a5,80004c4c <sys_unlink+0x18c>
  iunlockput(dp);
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	3cc080e7          	jalr	972(ra) # 80002f6e <iunlockput>
  ip->nlink--;
    80004baa:	04a95783          	lhu	a5,74(s2)
    80004bae:	37fd                	addiw	a5,a5,-1
    80004bb0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	08a080e7          	jalr	138(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	3ae080e7          	jalr	942(ra) # 80002f6e <iunlockput>
  end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	b9e080e7          	jalr	-1122(ra) # 80003766 <end_op>
  return 0;
    80004bd0:	4501                	li	a0,0
    80004bd2:	a84d                	j	80004c84 <sys_unlink+0x1c4>
    end_op();
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	b92080e7          	jalr	-1134(ra) # 80003766 <end_op>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a05d                	j	80004c84 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	ad850513          	addi	a0,a0,-1320 # 800086b8 <syscalls+0x2e0>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	198080e7          	jalr	408(ra) # 80005d80 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf0:	04c92703          	lw	a4,76(s2)
    80004bf4:	02000793          	li	a5,32
    80004bf8:	f6e7f9e3          	bgeu	a5,a4,80004b6a <sys_unlink+0xaa>
    80004bfc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86ce                	mv	a3,s3
    80004c04:	f1840613          	addi	a2,s0,-232
    80004c08:	4581                	li	a1,0
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	3b4080e7          	jalr	948(ra) # 80002fc0 <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	00f51b63          	bne	a0,a5,80004c2c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c1a:	f1845783          	lhu	a5,-232(s0)
    80004c1e:	e7a1                	bnez	a5,80004c66 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c20:	29c1                	addiw	s3,s3,16
    80004c22:	04c92783          	lw	a5,76(s2)
    80004c26:	fcf9ede3          	bltu	s3,a5,80004c00 <sys_unlink+0x140>
    80004c2a:	b781                	j	80004b6a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c2c:	00004517          	auipc	a0,0x4
    80004c30:	aa450513          	addi	a0,a0,-1372 # 800086d0 <syscalls+0x2f8>
    80004c34:	00001097          	auipc	ra,0x1
    80004c38:	14c080e7          	jalr	332(ra) # 80005d80 <panic>
    panic("unlink: writei");
    80004c3c:	00004517          	auipc	a0,0x4
    80004c40:	aac50513          	addi	a0,a0,-1364 # 800086e8 <syscalls+0x310>
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	13c080e7          	jalr	316(ra) # 80005d80 <panic>
    dp->nlink--;
    80004c4c:	04a4d783          	lhu	a5,74(s1)
    80004c50:	37fd                	addiw	a5,a5,-1
    80004c52:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	fe8080e7          	jalr	-24(ra) # 80002c40 <iupdate>
    80004c60:	b781                	j	80004ba0 <sys_unlink+0xe0>
    return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	a005                	j	80004c84 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	306080e7          	jalr	774(ra) # 80002f6e <iunlockput>
  iunlockput(dp);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	2fc080e7          	jalr	764(ra) # 80002f6e <iunlockput>
  end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	aec080e7          	jalr	-1300(ra) # 80003766 <end_op>
  return -1;
    80004c82:	557d                	li	a0,-1
}
    80004c84:	70ae                	ld	ra,232(sp)
    80004c86:	740e                	ld	s0,224(sp)
    80004c88:	64ee                	ld	s1,216(sp)
    80004c8a:	694e                	ld	s2,208(sp)
    80004c8c:	69ae                	ld	s3,200(sp)
    80004c8e:	616d                	addi	sp,sp,240
    80004c90:	8082                	ret

0000000080004c92 <sys_open>:

uint64
sys_open(void)
{
    80004c92:	7131                	addi	sp,sp,-192
    80004c94:	fd06                	sd	ra,184(sp)
    80004c96:	f922                	sd	s0,176(sp)
    80004c98:	f526                	sd	s1,168(sp)
    80004c9a:	f14a                	sd	s2,160(sp)
    80004c9c:	ed4e                	sd	s3,152(sp)
    80004c9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca0:	08000613          	li	a2,128
    80004ca4:	f5040593          	addi	a1,s0,-176
    80004ca8:	4501                	li	a0,0
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	534080e7          	jalr	1332(ra) # 800021de <argstr>
    return -1;
    80004cb2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb4:	0c054163          	bltz	a0,80004d76 <sys_open+0xe4>
    80004cb8:	f4c40593          	addi	a1,s0,-180
    80004cbc:	4505                	li	a0,1
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	4dc080e7          	jalr	1244(ra) # 8000219a <argint>
    80004cc6:	0a054863          	bltz	a0,80004d76 <sys_open+0xe4>

  begin_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	a1e080e7          	jalr	-1506(ra) # 800036e8 <begin_op>

  if(omode & O_CREATE){
    80004cd2:	f4c42783          	lw	a5,-180(s0)
    80004cd6:	2007f793          	andi	a5,a5,512
    80004cda:	cbdd                	beqz	a5,80004d90 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cdc:	4681                	li	a3,0
    80004cde:	4601                	li	a2,0
    80004ce0:	4589                	li	a1,2
    80004ce2:	f5040513          	addi	a0,s0,-176
    80004ce6:	00000097          	auipc	ra,0x0
    80004cea:	970080e7          	jalr	-1680(ra) # 80004656 <create>
    80004cee:	892a                	mv	s2,a0
    if(ip == 0){
    80004cf0:	c959                	beqz	a0,80004d86 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf2:	04491703          	lh	a4,68(s2)
    80004cf6:	478d                	li	a5,3
    80004cf8:	00f71763          	bne	a4,a5,80004d06 <sys_open+0x74>
    80004cfc:	04695703          	lhu	a4,70(s2)
    80004d00:	47a5                	li	a5,9
    80004d02:	0ce7ec63          	bltu	a5,a4,80004dda <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	dee080e7          	jalr	-530(ra) # 80003af4 <filealloc>
    80004d0e:	89aa                	mv	s3,a0
    80004d10:	10050263          	beqz	a0,80004e14 <sys_open+0x182>
    80004d14:	00000097          	auipc	ra,0x0
    80004d18:	900080e7          	jalr	-1792(ra) # 80004614 <fdalloc>
    80004d1c:	84aa                	mv	s1,a0
    80004d1e:	0e054663          	bltz	a0,80004e0a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d22:	04491703          	lh	a4,68(s2)
    80004d26:	478d                	li	a5,3
    80004d28:	0cf70463          	beq	a4,a5,80004df0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d2c:	4789                	li	a5,2
    80004d2e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d32:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d36:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d3a:	f4c42783          	lw	a5,-180(s0)
    80004d3e:	0017c713          	xori	a4,a5,1
    80004d42:	8b05                	andi	a4,a4,1
    80004d44:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d48:	0037f713          	andi	a4,a5,3
    80004d4c:	00e03733          	snez	a4,a4
    80004d50:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d54:	4007f793          	andi	a5,a5,1024
    80004d58:	c791                	beqz	a5,80004d64 <sys_open+0xd2>
    80004d5a:	04491703          	lh	a4,68(s2)
    80004d5e:	4789                	li	a5,2
    80004d60:	08f70f63          	beq	a4,a5,80004dfe <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d64:	854a                	mv	a0,s2
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	068080e7          	jalr	104(ra) # 80002dce <iunlock>
  end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	9f8080e7          	jalr	-1544(ra) # 80003766 <end_op>

  return fd;
}
    80004d76:	8526                	mv	a0,s1
    80004d78:	70ea                	ld	ra,184(sp)
    80004d7a:	744a                	ld	s0,176(sp)
    80004d7c:	74aa                	ld	s1,168(sp)
    80004d7e:	790a                	ld	s2,160(sp)
    80004d80:	69ea                	ld	s3,152(sp)
    80004d82:	6129                	addi	sp,sp,192
    80004d84:	8082                	ret
      end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	9e0080e7          	jalr	-1568(ra) # 80003766 <end_op>
      return -1;
    80004d8e:	b7e5                	j	80004d76 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d90:	f5040513          	addi	a0,s0,-176
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	734080e7          	jalr	1844(ra) # 800034c8 <namei>
    80004d9c:	892a                	mv	s2,a0
    80004d9e:	c905                	beqz	a0,80004dce <sys_open+0x13c>
    ilock(ip);
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	f6c080e7          	jalr	-148(ra) # 80002d0c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da8:	04491703          	lh	a4,68(s2)
    80004dac:	4785                	li	a5,1
    80004dae:	f4f712e3          	bne	a4,a5,80004cf2 <sys_open+0x60>
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	dba1                	beqz	a5,80004d06 <sys_open+0x74>
      iunlockput(ip);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	1b4080e7          	jalr	436(ra) # 80002f6e <iunlockput>
      end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	9a4080e7          	jalr	-1628(ra) # 80003766 <end_op>
      return -1;
    80004dca:	54fd                	li	s1,-1
    80004dcc:	b76d                	j	80004d76 <sys_open+0xe4>
      end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	998080e7          	jalr	-1640(ra) # 80003766 <end_op>
      return -1;
    80004dd6:	54fd                	li	s1,-1
    80004dd8:	bf79                	j	80004d76 <sys_open+0xe4>
    iunlockput(ip);
    80004dda:	854a                	mv	a0,s2
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	192080e7          	jalr	402(ra) # 80002f6e <iunlockput>
    end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	982080e7          	jalr	-1662(ra) # 80003766 <end_op>
    return -1;
    80004dec:	54fd                	li	s1,-1
    80004dee:	b761                	j	80004d76 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004df0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004df4:	04691783          	lh	a5,70(s2)
    80004df8:	02f99223          	sh	a5,36(s3)
    80004dfc:	bf2d                	j	80004d36 <sys_open+0xa4>
    itrunc(ip);
    80004dfe:	854a                	mv	a0,s2
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	01a080e7          	jalr	26(ra) # 80002e1a <itrunc>
    80004e08:	bfb1                	j	80004d64 <sys_open+0xd2>
      fileclose(f);
    80004e0a:	854e                	mv	a0,s3
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	da4080e7          	jalr	-604(ra) # 80003bb0 <fileclose>
    iunlockput(ip);
    80004e14:	854a                	mv	a0,s2
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	158080e7          	jalr	344(ra) # 80002f6e <iunlockput>
    end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	948080e7          	jalr	-1720(ra) # 80003766 <end_op>
    return -1;
    80004e26:	54fd                	li	s1,-1
    80004e28:	b7b9                	j	80004d76 <sys_open+0xe4>

0000000080004e2a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e2a:	7175                	addi	sp,sp,-144
    80004e2c:	e506                	sd	ra,136(sp)
    80004e2e:	e122                	sd	s0,128(sp)
    80004e30:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	8b6080e7          	jalr	-1866(ra) # 800036e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e3a:	08000613          	li	a2,128
    80004e3e:	f7040593          	addi	a1,s0,-144
    80004e42:	4501                	li	a0,0
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	39a080e7          	jalr	922(ra) # 800021de <argstr>
    80004e4c:	02054963          	bltz	a0,80004e7e <sys_mkdir+0x54>
    80004e50:	4681                	li	a3,0
    80004e52:	4601                	li	a2,0
    80004e54:	4585                	li	a1,1
    80004e56:	f7040513          	addi	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	7fc080e7          	jalr	2044(ra) # 80004656 <create>
    80004e62:	cd11                	beqz	a0,80004e7e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	10a080e7          	jalr	266(ra) # 80002f6e <iunlockput>
  end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8fa080e7          	jalr	-1798(ra) # 80003766 <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
}
    80004e76:	60aa                	ld	ra,136(sp)
    80004e78:	640a                	ld	s0,128(sp)
    80004e7a:	6149                	addi	sp,sp,144
    80004e7c:	8082                	ret
    end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	8e8080e7          	jalr	-1816(ra) # 80003766 <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7fd                	j	80004e76 <sys_mkdir+0x4c>

0000000080004e8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e8a:	7135                	addi	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	856080e7          	jalr	-1962(ra) # 800036e8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f7040593          	addi	a1,s0,-144
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	33a080e7          	jalr	826(ra) # 800021de <argstr>
    80004eac:	04054a63          	bltz	a0,80004f00 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eb0:	f6c40593          	addi	a1,s0,-148
    80004eb4:	4505                	li	a0,1
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	2e4080e7          	jalr	740(ra) # 8000219a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ebe:	04054163          	bltz	a0,80004f00 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ec2:	f6840593          	addi	a1,s0,-152
    80004ec6:	4509                	li	a0,2
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	2d2080e7          	jalr	722(ra) # 8000219a <argint>
     argint(1, &major) < 0 ||
    80004ed0:	02054863          	bltz	a0,80004f00 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ed4:	f6841683          	lh	a3,-152(s0)
    80004ed8:	f6c41603          	lh	a2,-148(s0)
    80004edc:	458d                	li	a1,3
    80004ede:	f7040513          	addi	a0,s0,-144
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	774080e7          	jalr	1908(ra) # 80004656 <create>
     argint(2, &minor) < 0 ||
    80004eea:	c919                	beqz	a0,80004f00 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	082080e7          	jalr	130(ra) # 80002f6e <iunlockput>
  end_op();
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	872080e7          	jalr	-1934(ra) # 80003766 <end_op>
  return 0;
    80004efc:	4501                	li	a0,0
    80004efe:	a031                	j	80004f0a <sys_mknod+0x80>
    end_op();
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	866080e7          	jalr	-1946(ra) # 80003766 <end_op>
    return -1;
    80004f08:	557d                	li	a0,-1
}
    80004f0a:	60ea                	ld	ra,152(sp)
    80004f0c:	644a                	ld	s0,144(sp)
    80004f0e:	610d                	addi	sp,sp,160
    80004f10:	8082                	ret

0000000080004f12 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f12:	7135                	addi	sp,sp,-160
    80004f14:	ed06                	sd	ra,152(sp)
    80004f16:	e922                	sd	s0,144(sp)
    80004f18:	e526                	sd	s1,136(sp)
    80004f1a:	e14a                	sd	s2,128(sp)
    80004f1c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	0e8080e7          	jalr	232(ra) # 80001006 <myproc>
    80004f26:	892a                	mv	s2,a0
  
  begin_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	7c0080e7          	jalr	1984(ra) # 800036e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f30:	08000613          	li	a2,128
    80004f34:	f6040593          	addi	a1,s0,-160
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	2a4080e7          	jalr	676(ra) # 800021de <argstr>
    80004f42:	04054b63          	bltz	a0,80004f98 <sys_chdir+0x86>
    80004f46:	f6040513          	addi	a0,s0,-160
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	57e080e7          	jalr	1406(ra) # 800034c8 <namei>
    80004f52:	84aa                	mv	s1,a0
    80004f54:	c131                	beqz	a0,80004f98 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	db6080e7          	jalr	-586(ra) # 80002d0c <ilock>
  if(ip->type != T_DIR){
    80004f5e:	04449703          	lh	a4,68(s1)
    80004f62:	4785                	li	a5,1
    80004f64:	04f71063          	bne	a4,a5,80004fa4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	e64080e7          	jalr	-412(ra) # 80002dce <iunlock>
  iput(p->cwd);
    80004f72:	15093503          	ld	a0,336(s2)
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	f50080e7          	jalr	-176(ra) # 80002ec6 <iput>
  end_op();
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	7e8080e7          	jalr	2024(ra) # 80003766 <end_op>
  p->cwd = ip;
    80004f86:	14993823          	sd	s1,336(s2)
  return 0;
    80004f8a:	4501                	li	a0,0
}
    80004f8c:	60ea                	ld	ra,152(sp)
    80004f8e:	644a                	ld	s0,144(sp)
    80004f90:	64aa                	ld	s1,136(sp)
    80004f92:	690a                	ld	s2,128(sp)
    80004f94:	610d                	addi	sp,sp,160
    80004f96:	8082                	ret
    end_op();
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	7ce080e7          	jalr	1998(ra) # 80003766 <end_op>
    return -1;
    80004fa0:	557d                	li	a0,-1
    80004fa2:	b7ed                	j	80004f8c <sys_chdir+0x7a>
    iunlockput(ip);
    80004fa4:	8526                	mv	a0,s1
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	fc8080e7          	jalr	-56(ra) # 80002f6e <iunlockput>
    end_op();
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	7b8080e7          	jalr	1976(ra) # 80003766 <end_op>
    return -1;
    80004fb6:	557d                	li	a0,-1
    80004fb8:	bfd1                	j	80004f8c <sys_chdir+0x7a>

0000000080004fba <sys_exec>:

uint64
sys_exec(void)
{
    80004fba:	7145                	addi	sp,sp,-464
    80004fbc:	e786                	sd	ra,456(sp)
    80004fbe:	e3a2                	sd	s0,448(sp)
    80004fc0:	ff26                	sd	s1,440(sp)
    80004fc2:	fb4a                	sd	s2,432(sp)
    80004fc4:	f74e                	sd	s3,424(sp)
    80004fc6:	f352                	sd	s4,416(sp)
    80004fc8:	ef56                	sd	s5,408(sp)
    80004fca:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fcc:	08000613          	li	a2,128
    80004fd0:	f4040593          	addi	a1,s0,-192
    80004fd4:	4501                	li	a0,0
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	208080e7          	jalr	520(ra) # 800021de <argstr>
    return -1;
    80004fde:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fe0:	0c054b63          	bltz	a0,800050b6 <sys_exec+0xfc>
    80004fe4:	e3840593          	addi	a1,s0,-456
    80004fe8:	4505                	li	a0,1
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	1d2080e7          	jalr	466(ra) # 800021bc <argaddr>
    80004ff2:	0c054263          	bltz	a0,800050b6 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ff6:	10000613          	li	a2,256
    80004ffa:	4581                	li	a1,0
    80004ffc:	e4040513          	addi	a0,s0,-448
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	280080e7          	jalr	640(ra) # 80000280 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005008:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000500c:	89a6                	mv	s3,s1
    8000500e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005010:	02000a13          	li	s4,32
    80005014:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005018:	00391513          	slli	a0,s2,0x3
    8000501c:	e3040593          	addi	a1,s0,-464
    80005020:	e3843783          	ld	a5,-456(s0)
    80005024:	953e                	add	a0,a0,a5
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	0da080e7          	jalr	218(ra) # 80002100 <fetchaddr>
    8000502e:	02054a63          	bltz	a0,80005062 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005032:	e3043783          	ld	a5,-464(s0)
    80005036:	c3b9                	beqz	a5,8000507c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	1ae080e7          	jalr	430(ra) # 800001e6 <kalloc>
    80005040:	85aa                	mv	a1,a0
    80005042:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005046:	cd11                	beqz	a0,80005062 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005048:	6605                	lui	a2,0x1
    8000504a:	e3043503          	ld	a0,-464(s0)
    8000504e:	ffffd097          	auipc	ra,0xffffd
    80005052:	104080e7          	jalr	260(ra) # 80002152 <fetchstr>
    80005056:	00054663          	bltz	a0,80005062 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000505a:	0905                	addi	s2,s2,1
    8000505c:	09a1                	addi	s3,s3,8
    8000505e:	fb491be3          	bne	s2,s4,80005014 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005062:	f4040913          	addi	s2,s0,-192
    80005066:	6088                	ld	a0,0(s1)
    80005068:	c531                	beqz	a0,800050b4 <sys_exec+0xfa>
    kfree(argv[i]);
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	fb2080e7          	jalr	-78(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005072:	04a1                	addi	s1,s1,8
    80005074:	ff2499e3          	bne	s1,s2,80005066 <sys_exec+0xac>
  return -1;
    80005078:	597d                	li	s2,-1
    8000507a:	a835                	j	800050b6 <sys_exec+0xfc>
      argv[i] = 0;
    8000507c:	0a8e                	slli	s5,s5,0x3
    8000507e:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7fdb8d80>
    80005082:	00878ab3          	add	s5,a5,s0
    80005086:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000508a:	e4040593          	addi	a1,s0,-448
    8000508e:	f4040513          	addi	a0,s0,-192
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	172080e7          	jalr	370(ra) # 80004204 <exec>
    8000509a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509c:	f4040993          	addi	s3,s0,-192
    800050a0:	6088                	ld	a0,0(s1)
    800050a2:	c911                	beqz	a0,800050b6 <sys_exec+0xfc>
    kfree(argv[i]);
    800050a4:	ffffb097          	auipc	ra,0xffffb
    800050a8:	f78080e7          	jalr	-136(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ac:	04a1                	addi	s1,s1,8
    800050ae:	ff3499e3          	bne	s1,s3,800050a0 <sys_exec+0xe6>
    800050b2:	a011                	j	800050b6 <sys_exec+0xfc>
  return -1;
    800050b4:	597d                	li	s2,-1
}
    800050b6:	854a                	mv	a0,s2
    800050b8:	60be                	ld	ra,456(sp)
    800050ba:	641e                	ld	s0,448(sp)
    800050bc:	74fa                	ld	s1,440(sp)
    800050be:	795a                	ld	s2,432(sp)
    800050c0:	79ba                	ld	s3,424(sp)
    800050c2:	7a1a                	ld	s4,416(sp)
    800050c4:	6afa                	ld	s5,408(sp)
    800050c6:	6179                	addi	sp,sp,464
    800050c8:	8082                	ret

00000000800050ca <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ca:	7139                	addi	sp,sp,-64
    800050cc:	fc06                	sd	ra,56(sp)
    800050ce:	f822                	sd	s0,48(sp)
    800050d0:	f426                	sd	s1,40(sp)
    800050d2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050d4:	ffffc097          	auipc	ra,0xffffc
    800050d8:	f32080e7          	jalr	-206(ra) # 80001006 <myproc>
    800050dc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050de:	fd840593          	addi	a1,s0,-40
    800050e2:	4501                	li	a0,0
    800050e4:	ffffd097          	auipc	ra,0xffffd
    800050e8:	0d8080e7          	jalr	216(ra) # 800021bc <argaddr>
    return -1;
    800050ec:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050ee:	0e054063          	bltz	a0,800051ce <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050f2:	fc840593          	addi	a1,s0,-56
    800050f6:	fd040513          	addi	a0,s0,-48
    800050fa:	fffff097          	auipc	ra,0xfffff
    800050fe:	de6080e7          	jalr	-538(ra) # 80003ee0 <pipealloc>
    return -1;
    80005102:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005104:	0c054563          	bltz	a0,800051ce <sys_pipe+0x104>
  fd0 = -1;
    80005108:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000510c:	fd043503          	ld	a0,-48(s0)
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	504080e7          	jalr	1284(ra) # 80004614 <fdalloc>
    80005118:	fca42223          	sw	a0,-60(s0)
    8000511c:	08054c63          	bltz	a0,800051b4 <sys_pipe+0xea>
    80005120:	fc843503          	ld	a0,-56(s0)
    80005124:	fffff097          	auipc	ra,0xfffff
    80005128:	4f0080e7          	jalr	1264(ra) # 80004614 <fdalloc>
    8000512c:	fca42023          	sw	a0,-64(s0)
    80005130:	06054963          	bltz	a0,800051a2 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005134:	4691                	li	a3,4
    80005136:	fc440613          	addi	a2,s0,-60
    8000513a:	fd843583          	ld	a1,-40(s0)
    8000513e:	68a8                	ld	a0,80(s1)
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	aea080e7          	jalr	-1302(ra) # 80000c2a <copyout>
    80005148:	02054063          	bltz	a0,80005168 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000514c:	4691                	li	a3,4
    8000514e:	fc040613          	addi	a2,s0,-64
    80005152:	fd843583          	ld	a1,-40(s0)
    80005156:	0591                	addi	a1,a1,4
    80005158:	68a8                	ld	a0,80(s1)
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	ad0080e7          	jalr	-1328(ra) # 80000c2a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005162:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005164:	06055563          	bgez	a0,800051ce <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005168:	fc442783          	lw	a5,-60(s0)
    8000516c:	07e9                	addi	a5,a5,26
    8000516e:	078e                	slli	a5,a5,0x3
    80005170:	97a6                	add	a5,a5,s1
    80005172:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005176:	fc042783          	lw	a5,-64(s0)
    8000517a:	07e9                	addi	a5,a5,26
    8000517c:	078e                	slli	a5,a5,0x3
    8000517e:	00f48533          	add	a0,s1,a5
    80005182:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005186:	fd043503          	ld	a0,-48(s0)
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	a26080e7          	jalr	-1498(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    80005192:	fc843503          	ld	a0,-56(s0)
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	a1a080e7          	jalr	-1510(ra) # 80003bb0 <fileclose>
    return -1;
    8000519e:	57fd                	li	a5,-1
    800051a0:	a03d                	j	800051ce <sys_pipe+0x104>
    if(fd0 >= 0)
    800051a2:	fc442783          	lw	a5,-60(s0)
    800051a6:	0007c763          	bltz	a5,800051b4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051aa:	07e9                	addi	a5,a5,26
    800051ac:	078e                	slli	a5,a5,0x3
    800051ae:	97a6                	add	a5,a5,s1
    800051b0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051b4:	fd043503          	ld	a0,-48(s0)
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	9f8080e7          	jalr	-1544(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    800051c0:	fc843503          	ld	a0,-56(s0)
    800051c4:	fffff097          	auipc	ra,0xfffff
    800051c8:	9ec080e7          	jalr	-1556(ra) # 80003bb0 <fileclose>
    return -1;
    800051cc:	57fd                	li	a5,-1
}
    800051ce:	853e                	mv	a0,a5
    800051d0:	70e2                	ld	ra,56(sp)
    800051d2:	7442                	ld	s0,48(sp)
    800051d4:	74a2                	ld	s1,40(sp)
    800051d6:	6121                	addi	sp,sp,64
    800051d8:	8082                	ret
    800051da:	0000                	unimp
    800051dc:	0000                	unimp
	...

00000000800051e0 <kernelvec>:
    800051e0:	7111                	addi	sp,sp,-256
    800051e2:	e006                	sd	ra,0(sp)
    800051e4:	e40a                	sd	sp,8(sp)
    800051e6:	e80e                	sd	gp,16(sp)
    800051e8:	ec12                	sd	tp,24(sp)
    800051ea:	f016                	sd	t0,32(sp)
    800051ec:	f41a                	sd	t1,40(sp)
    800051ee:	f81e                	sd	t2,48(sp)
    800051f0:	fc22                	sd	s0,56(sp)
    800051f2:	e0a6                	sd	s1,64(sp)
    800051f4:	e4aa                	sd	a0,72(sp)
    800051f6:	e8ae                	sd	a1,80(sp)
    800051f8:	ecb2                	sd	a2,88(sp)
    800051fa:	f0b6                	sd	a3,96(sp)
    800051fc:	f4ba                	sd	a4,104(sp)
    800051fe:	f8be                	sd	a5,112(sp)
    80005200:	fcc2                	sd	a6,120(sp)
    80005202:	e146                	sd	a7,128(sp)
    80005204:	e54a                	sd	s2,136(sp)
    80005206:	e94e                	sd	s3,144(sp)
    80005208:	ed52                	sd	s4,152(sp)
    8000520a:	f156                	sd	s5,160(sp)
    8000520c:	f55a                	sd	s6,168(sp)
    8000520e:	f95e                	sd	s7,176(sp)
    80005210:	fd62                	sd	s8,184(sp)
    80005212:	e1e6                	sd	s9,192(sp)
    80005214:	e5ea                	sd	s10,200(sp)
    80005216:	e9ee                	sd	s11,208(sp)
    80005218:	edf2                	sd	t3,216(sp)
    8000521a:	f1f6                	sd	t4,224(sp)
    8000521c:	f5fa                	sd	t5,232(sp)
    8000521e:	f9fe                	sd	t6,240(sp)
    80005220:	dadfc0ef          	jal	ra,80001fcc <kerneltrap>
    80005224:	6082                	ld	ra,0(sp)
    80005226:	6122                	ld	sp,8(sp)
    80005228:	61c2                	ld	gp,16(sp)
    8000522a:	7282                	ld	t0,32(sp)
    8000522c:	7322                	ld	t1,40(sp)
    8000522e:	73c2                	ld	t2,48(sp)
    80005230:	7462                	ld	s0,56(sp)
    80005232:	6486                	ld	s1,64(sp)
    80005234:	6526                	ld	a0,72(sp)
    80005236:	65c6                	ld	a1,80(sp)
    80005238:	6666                	ld	a2,88(sp)
    8000523a:	7686                	ld	a3,96(sp)
    8000523c:	7726                	ld	a4,104(sp)
    8000523e:	77c6                	ld	a5,112(sp)
    80005240:	7866                	ld	a6,120(sp)
    80005242:	688a                	ld	a7,128(sp)
    80005244:	692a                	ld	s2,136(sp)
    80005246:	69ca                	ld	s3,144(sp)
    80005248:	6a6a                	ld	s4,152(sp)
    8000524a:	7a8a                	ld	s5,160(sp)
    8000524c:	7b2a                	ld	s6,168(sp)
    8000524e:	7bca                	ld	s7,176(sp)
    80005250:	7c6a                	ld	s8,184(sp)
    80005252:	6c8e                	ld	s9,192(sp)
    80005254:	6d2e                	ld	s10,200(sp)
    80005256:	6dce                	ld	s11,208(sp)
    80005258:	6e6e                	ld	t3,216(sp)
    8000525a:	7e8e                	ld	t4,224(sp)
    8000525c:	7f2e                	ld	t5,232(sp)
    8000525e:	7fce                	ld	t6,240(sp)
    80005260:	6111                	addi	sp,sp,256
    80005262:	10200073          	sret
    80005266:	00000013          	nop
    8000526a:	00000013          	nop
    8000526e:	0001                	nop

0000000080005270 <timervec>:
    80005270:	34051573          	csrrw	a0,mscratch,a0
    80005274:	e10c                	sd	a1,0(a0)
    80005276:	e510                	sd	a2,8(a0)
    80005278:	e914                	sd	a3,16(a0)
    8000527a:	6d0c                	ld	a1,24(a0)
    8000527c:	7110                	ld	a2,32(a0)
    8000527e:	6194                	ld	a3,0(a1)
    80005280:	96b2                	add	a3,a3,a2
    80005282:	e194                	sd	a3,0(a1)
    80005284:	4589                	li	a1,2
    80005286:	14459073          	csrw	sip,a1
    8000528a:	6914                	ld	a3,16(a0)
    8000528c:	6510                	ld	a2,8(a0)
    8000528e:	610c                	ld	a1,0(a0)
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	30200073          	mret
	...

000000008000529a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000529a:	1141                	addi	sp,sp,-16
    8000529c:	e422                	sd	s0,8(sp)
    8000529e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052a0:	0c0007b7          	lui	a5,0xc000
    800052a4:	4705                	li	a4,1
    800052a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052a8:	c3d8                	sw	a4,4(a5)
}
    800052aa:	6422                	ld	s0,8(sp)
    800052ac:	0141                	addi	sp,sp,16
    800052ae:	8082                	ret

00000000800052b0 <plicinithart>:

void
plicinithart(void)
{
    800052b0:	1141                	addi	sp,sp,-16
    800052b2:	e406                	sd	ra,8(sp)
    800052b4:	e022                	sd	s0,0(sp)
    800052b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	d22080e7          	jalr	-734(ra) # 80000fda <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052c0:	0085171b          	slliw	a4,a0,0x8
    800052c4:	0c0027b7          	lui	a5,0xc002
    800052c8:	97ba                	add	a5,a5,a4
    800052ca:	40200713          	li	a4,1026
    800052ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052d2:	00d5151b          	slliw	a0,a0,0xd
    800052d6:	0c2017b7          	lui	a5,0xc201
    800052da:	97aa                	add	a5,a5,a0
    800052dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret

00000000800052e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052e8:	1141                	addi	sp,sp,-16
    800052ea:	e406                	sd	ra,8(sp)
    800052ec:	e022                	sd	s0,0(sp)
    800052ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f0:	ffffc097          	auipc	ra,0xffffc
    800052f4:	cea080e7          	jalr	-790(ra) # 80000fda <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052f8:	00d5151b          	slliw	a0,a0,0xd
    800052fc:	0c2017b7          	lui	a5,0xc201
    80005300:	97aa                	add	a5,a5,a0
  return irq;
}
    80005302:	43c8                	lw	a0,4(a5)
    80005304:	60a2                	ld	ra,8(sp)
    80005306:	6402                	ld	s0,0(sp)
    80005308:	0141                	addi	sp,sp,16
    8000530a:	8082                	ret

000000008000530c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000530c:	1101                	addi	sp,sp,-32
    8000530e:	ec06                	sd	ra,24(sp)
    80005310:	e822                	sd	s0,16(sp)
    80005312:	e426                	sd	s1,8(sp)
    80005314:	1000                	addi	s0,sp,32
    80005316:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	cc2080e7          	jalr	-830(ra) # 80000fda <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005320:	00d5151b          	slliw	a0,a0,0xd
    80005324:	0c2017b7          	lui	a5,0xc201
    80005328:	97aa                	add	a5,a5,a0
    8000532a:	c3c4                	sw	s1,4(a5)
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6105                	addi	sp,sp,32
    80005334:	8082                	ret

0000000080005336 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005336:	1141                	addi	sp,sp,-16
    80005338:	e406                	sd	ra,8(sp)
    8000533a:	e022                	sd	s0,0(sp)
    8000533c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000533e:	479d                	li	a5,7
    80005340:	06a7c863          	blt	a5,a0,800053b0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005344:	00236717          	auipc	a4,0x236
    80005348:	cbc70713          	addi	a4,a4,-836 # 8023b000 <disk>
    8000534c:	972a                	add	a4,a4,a0
    8000534e:	6789                	lui	a5,0x2
    80005350:	97ba                	add	a5,a5,a4
    80005352:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005356:	e7ad                	bnez	a5,800053c0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005358:	00451793          	slli	a5,a0,0x4
    8000535c:	00238717          	auipc	a4,0x238
    80005360:	ca470713          	addi	a4,a4,-860 # 8023d000 <disk+0x2000>
    80005364:	6314                	ld	a3,0(a4)
    80005366:	96be                	add	a3,a3,a5
    80005368:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000536c:	6314                	ld	a3,0(a4)
    8000536e:	96be                	add	a3,a3,a5
    80005370:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005374:	6314                	ld	a3,0(a4)
    80005376:	96be                	add	a3,a3,a5
    80005378:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000537c:	6318                	ld	a4,0(a4)
    8000537e:	97ba                	add	a5,a5,a4
    80005380:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005384:	00236717          	auipc	a4,0x236
    80005388:	c7c70713          	addi	a4,a4,-900 # 8023b000 <disk>
    8000538c:	972a                	add	a4,a4,a0
    8000538e:	6789                	lui	a5,0x2
    80005390:	97ba                	add	a5,a5,a4
    80005392:	4705                	li	a4,1
    80005394:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005398:	00238517          	auipc	a0,0x238
    8000539c:	c8050513          	addi	a0,a0,-896 # 8023d018 <disk+0x2018>
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	4b6080e7          	jalr	1206(ra) # 80001856 <wakeup>
}
    800053a8:	60a2                	ld	ra,8(sp)
    800053aa:	6402                	ld	s0,0(sp)
    800053ac:	0141                	addi	sp,sp,16
    800053ae:	8082                	ret
    panic("free_desc 1");
    800053b0:	00003517          	auipc	a0,0x3
    800053b4:	34850513          	addi	a0,a0,840 # 800086f8 <syscalls+0x320>
    800053b8:	00001097          	auipc	ra,0x1
    800053bc:	9c8080e7          	jalr	-1592(ra) # 80005d80 <panic>
    panic("free_desc 2");
    800053c0:	00003517          	auipc	a0,0x3
    800053c4:	34850513          	addi	a0,a0,840 # 80008708 <syscalls+0x330>
    800053c8:	00001097          	auipc	ra,0x1
    800053cc:	9b8080e7          	jalr	-1608(ra) # 80005d80 <panic>

00000000800053d0 <virtio_disk_init>:
{
    800053d0:	1101                	addi	sp,sp,-32
    800053d2:	ec06                	sd	ra,24(sp)
    800053d4:	e822                	sd	s0,16(sp)
    800053d6:	e426                	sd	s1,8(sp)
    800053d8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053da:	00003597          	auipc	a1,0x3
    800053de:	33e58593          	addi	a1,a1,830 # 80008718 <syscalls+0x340>
    800053e2:	00238517          	auipc	a0,0x238
    800053e6:	d4650513          	addi	a0,a0,-698 # 8023d128 <disk+0x2128>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	e3e080e7          	jalr	-450(ra) # 80006228 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053f2:	100017b7          	lui	a5,0x10001
    800053f6:	4398                	lw	a4,0(a5)
    800053f8:	2701                	sext.w	a4,a4
    800053fa:	747277b7          	lui	a5,0x74727
    800053fe:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005402:	0ef71063          	bne	a4,a5,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	43dc                	lw	a5,4(a5)
    8000540c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000540e:	4705                	li	a4,1
    80005410:	0ce79963          	bne	a5,a4,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	479c                	lw	a5,8(a5)
    8000541a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000541c:	4709                	li	a4,2
    8000541e:	0ce79263          	bne	a5,a4,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005422:	100017b7          	lui	a5,0x10001
    80005426:	47d8                	lw	a4,12(a5)
    80005428:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000542a:	554d47b7          	lui	a5,0x554d4
    8000542e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005432:	0af71863          	bne	a4,a5,800054e2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	4705                	li	a4,1
    8000543c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543e:	470d                	li	a4,3
    80005440:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005442:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005444:	c7ffe6b7          	lui	a3,0xc7ffe
    80005448:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    8000544c:	8f75                	and	a4,a4,a3
    8000544e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005450:	472d                	li	a4,11
    80005452:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005454:	473d                	li	a4,15
    80005456:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005458:	6705                	lui	a4,0x1
    8000545a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000545c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005460:	5bdc                	lw	a5,52(a5)
    80005462:	2781                	sext.w	a5,a5
  if(max == 0)
    80005464:	c7d9                	beqz	a5,800054f2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005466:	471d                	li	a4,7
    80005468:	08f77d63          	bgeu	a4,a5,80005502 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000546c:	100014b7          	lui	s1,0x10001
    80005470:	47a1                	li	a5,8
    80005472:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005474:	6609                	lui	a2,0x2
    80005476:	4581                	li	a1,0
    80005478:	00236517          	auipc	a0,0x236
    8000547c:	b8850513          	addi	a0,a0,-1144 # 8023b000 <disk>
    80005480:	ffffb097          	auipc	ra,0xffffb
    80005484:	e00080e7          	jalr	-512(ra) # 80000280 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005488:	00236717          	auipc	a4,0x236
    8000548c:	b7870713          	addi	a4,a4,-1160 # 8023b000 <disk>
    80005490:	00c75793          	srli	a5,a4,0xc
    80005494:	2781                	sext.w	a5,a5
    80005496:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005498:	00238797          	auipc	a5,0x238
    8000549c:	b6878793          	addi	a5,a5,-1176 # 8023d000 <disk+0x2000>
    800054a0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054a2:	00236717          	auipc	a4,0x236
    800054a6:	bde70713          	addi	a4,a4,-1058 # 8023b080 <disk+0x80>
    800054aa:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054ac:	00237717          	auipc	a4,0x237
    800054b0:	b5470713          	addi	a4,a4,-1196 # 8023c000 <disk+0x1000>
    800054b4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054b6:	4705                	li	a4,1
    800054b8:	00e78c23          	sb	a4,24(a5)
    800054bc:	00e78ca3          	sb	a4,25(a5)
    800054c0:	00e78d23          	sb	a4,26(a5)
    800054c4:	00e78da3          	sb	a4,27(a5)
    800054c8:	00e78e23          	sb	a4,28(a5)
    800054cc:	00e78ea3          	sb	a4,29(a5)
    800054d0:	00e78f23          	sb	a4,30(a5)
    800054d4:	00e78fa3          	sb	a4,31(a5)
}
    800054d8:	60e2                	ld	ra,24(sp)
    800054da:	6442                	ld	s0,16(sp)
    800054dc:	64a2                	ld	s1,8(sp)
    800054de:	6105                	addi	sp,sp,32
    800054e0:	8082                	ret
    panic("could not find virtio disk");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	24650513          	addi	a0,a0,582 # 80008728 <syscalls+0x350>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	896080e7          	jalr	-1898(ra) # 80005d80 <panic>
    panic("virtio disk has no queue 0");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	25650513          	addi	a0,a0,598 # 80008748 <syscalls+0x370>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	886080e7          	jalr	-1914(ra) # 80005d80 <panic>
    panic("virtio disk max queue too short");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	26650513          	addi	a0,a0,614 # 80008768 <syscalls+0x390>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	876080e7          	jalr	-1930(ra) # 80005d80 <panic>

0000000080005512 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005512:	7119                	addi	sp,sp,-128
    80005514:	fc86                	sd	ra,120(sp)
    80005516:	f8a2                	sd	s0,112(sp)
    80005518:	f4a6                	sd	s1,104(sp)
    8000551a:	f0ca                	sd	s2,96(sp)
    8000551c:	ecce                	sd	s3,88(sp)
    8000551e:	e8d2                	sd	s4,80(sp)
    80005520:	e4d6                	sd	s5,72(sp)
    80005522:	e0da                	sd	s6,64(sp)
    80005524:	fc5e                	sd	s7,56(sp)
    80005526:	f862                	sd	s8,48(sp)
    80005528:	f466                	sd	s9,40(sp)
    8000552a:	f06a                	sd	s10,32(sp)
    8000552c:	ec6e                	sd	s11,24(sp)
    8000552e:	0100                	addi	s0,sp,128
    80005530:	8aaa                	mv	s5,a0
    80005532:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005534:	00c52c83          	lw	s9,12(a0)
    80005538:	001c9c9b          	slliw	s9,s9,0x1
    8000553c:	1c82                	slli	s9,s9,0x20
    8000553e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005542:	00238517          	auipc	a0,0x238
    80005546:	be650513          	addi	a0,a0,-1050 # 8023d128 <disk+0x2128>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	d6e080e7          	jalr	-658(ra) # 800062b8 <acquire>
  for(int i = 0; i < 3; i++){
    80005552:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005554:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005556:	00236c17          	auipc	s8,0x236
    8000555a:	aaac0c13          	addi	s8,s8,-1366 # 8023b000 <disk>
    8000555e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005560:	4b0d                	li	s6,3
    80005562:	a0ad                	j	800055cc <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005564:	00fc0733          	add	a4,s8,a5
    80005568:	975e                	add	a4,a4,s7
    8000556a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000556e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005570:	0207c563          	bltz	a5,8000559a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005574:	2905                	addiw	s2,s2,1
    80005576:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005578:	19690c63          	beq	s2,s6,80005710 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000557c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000557e:	00238717          	auipc	a4,0x238
    80005582:	a9a70713          	addi	a4,a4,-1382 # 8023d018 <disk+0x2018>
    80005586:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005588:	00074683          	lbu	a3,0(a4)
    8000558c:	fee1                	bnez	a3,80005564 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000558e:	2785                	addiw	a5,a5,1
    80005590:	0705                	addi	a4,a4,1
    80005592:	fe979be3          	bne	a5,s1,80005588 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005596:	57fd                	li	a5,-1
    80005598:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000559a:	01205d63          	blez	s2,800055b4 <virtio_disk_rw+0xa2>
    8000559e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055a0:	000a2503          	lw	a0,0(s4)
    800055a4:	00000097          	auipc	ra,0x0
    800055a8:	d92080e7          	jalr	-622(ra) # 80005336 <free_desc>
      for(int j = 0; j < i; j++)
    800055ac:	2d85                	addiw	s11,s11,1
    800055ae:	0a11                	addi	s4,s4,4
    800055b0:	ff2d98e3          	bne	s11,s2,800055a0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b4:	00238597          	auipc	a1,0x238
    800055b8:	b7458593          	addi	a1,a1,-1164 # 8023d128 <disk+0x2128>
    800055bc:	00238517          	auipc	a0,0x238
    800055c0:	a5c50513          	addi	a0,a0,-1444 # 8023d018 <disk+0x2018>
    800055c4:	ffffc097          	auipc	ra,0xffffc
    800055c8:	106080e7          	jalr	262(ra) # 800016ca <sleep>
  for(int i = 0; i < 3; i++){
    800055cc:	f8040a13          	addi	s4,s0,-128
{
    800055d0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055d2:	894e                	mv	s2,s3
    800055d4:	b765                	j	8000557c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055d6:	00238697          	auipc	a3,0x238
    800055da:	a2a6b683          	ld	a3,-1494(a3) # 8023d000 <disk+0x2000>
    800055de:	96ba                	add	a3,a3,a4
    800055e0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055e4:	00236817          	auipc	a6,0x236
    800055e8:	a1c80813          	addi	a6,a6,-1508 # 8023b000 <disk>
    800055ec:	00238697          	auipc	a3,0x238
    800055f0:	a1468693          	addi	a3,a3,-1516 # 8023d000 <disk+0x2000>
    800055f4:	6290                	ld	a2,0(a3)
    800055f6:	963a                	add	a2,a2,a4
    800055f8:	00c65583          	lhu	a1,12(a2)
    800055fc:	0015e593          	ori	a1,a1,1
    80005600:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005604:	f8842603          	lw	a2,-120(s0)
    80005608:	628c                	ld	a1,0(a3)
    8000560a:	972e                	add	a4,a4,a1
    8000560c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005610:	20050593          	addi	a1,a0,512
    80005614:	0592                	slli	a1,a1,0x4
    80005616:	95c2                	add	a1,a1,a6
    80005618:	577d                	li	a4,-1
    8000561a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000561e:	00461713          	slli	a4,a2,0x4
    80005622:	6290                	ld	a2,0(a3)
    80005624:	963a                	add	a2,a2,a4
    80005626:	03078793          	addi	a5,a5,48
    8000562a:	97c2                	add	a5,a5,a6
    8000562c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000562e:	629c                	ld	a5,0(a3)
    80005630:	97ba                	add	a5,a5,a4
    80005632:	4605                	li	a2,1
    80005634:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005636:	629c                	ld	a5,0(a3)
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	4809                	li	a6,2
    8000563c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005640:	629c                	ld	a5,0(a3)
    80005642:	97ba                	add	a5,a5,a4
    80005644:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005648:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000564c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005650:	6698                	ld	a4,8(a3)
    80005652:	00275783          	lhu	a5,2(a4)
    80005656:	8b9d                	andi	a5,a5,7
    80005658:	0786                	slli	a5,a5,0x1
    8000565a:	973e                	add	a4,a4,a5
    8000565c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005660:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005664:	6698                	ld	a4,8(a3)
    80005666:	00275783          	lhu	a5,2(a4)
    8000566a:	2785                	addiw	a5,a5,1
    8000566c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005670:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005674:	100017b7          	lui	a5,0x10001
    80005678:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000567c:	004aa783          	lw	a5,4(s5)
    80005680:	02c79163          	bne	a5,a2,800056a2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005684:	00238917          	auipc	s2,0x238
    80005688:	aa490913          	addi	s2,s2,-1372 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    8000568c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000568e:	85ca                	mv	a1,s2
    80005690:	8556                	mv	a0,s5
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	038080e7          	jalr	56(ra) # 800016ca <sleep>
  while(b->disk == 1) {
    8000569a:	004aa783          	lw	a5,4(s5)
    8000569e:	fe9788e3          	beq	a5,s1,8000568e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056a2:	f8042903          	lw	s2,-128(s0)
    800056a6:	20090713          	addi	a4,s2,512
    800056aa:	0712                	slli	a4,a4,0x4
    800056ac:	00236797          	auipc	a5,0x236
    800056b0:	95478793          	addi	a5,a5,-1708 # 8023b000 <disk>
    800056b4:	97ba                	add	a5,a5,a4
    800056b6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056ba:	00238997          	auipc	s3,0x238
    800056be:	94698993          	addi	s3,s3,-1722 # 8023d000 <disk+0x2000>
    800056c2:	00491713          	slli	a4,s2,0x4
    800056c6:	0009b783          	ld	a5,0(s3)
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056d0:	854a                	mv	a0,s2
    800056d2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056d6:	00000097          	auipc	ra,0x0
    800056da:	c60080e7          	jalr	-928(ra) # 80005336 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056de:	8885                	andi	s1,s1,1
    800056e0:	f0ed                	bnez	s1,800056c2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056e2:	00238517          	auipc	a0,0x238
    800056e6:	a4650513          	addi	a0,a0,-1466 # 8023d128 <disk+0x2128>
    800056ea:	00001097          	auipc	ra,0x1
    800056ee:	c82080e7          	jalr	-894(ra) # 8000636c <release>
}
    800056f2:	70e6                	ld	ra,120(sp)
    800056f4:	7446                	ld	s0,112(sp)
    800056f6:	74a6                	ld	s1,104(sp)
    800056f8:	7906                	ld	s2,96(sp)
    800056fa:	69e6                	ld	s3,88(sp)
    800056fc:	6a46                	ld	s4,80(sp)
    800056fe:	6aa6                	ld	s5,72(sp)
    80005700:	6b06                	ld	s6,64(sp)
    80005702:	7be2                	ld	s7,56(sp)
    80005704:	7c42                	ld	s8,48(sp)
    80005706:	7ca2                	ld	s9,40(sp)
    80005708:	7d02                	ld	s10,32(sp)
    8000570a:	6de2                	ld	s11,24(sp)
    8000570c:	6109                	addi	sp,sp,128
    8000570e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005710:	f8042503          	lw	a0,-128(s0)
    80005714:	20050793          	addi	a5,a0,512
    80005718:	0792                	slli	a5,a5,0x4
  if(write)
    8000571a:	00236817          	auipc	a6,0x236
    8000571e:	8e680813          	addi	a6,a6,-1818 # 8023b000 <disk>
    80005722:	00f80733          	add	a4,a6,a5
    80005726:	01a036b3          	snez	a3,s10
    8000572a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000572e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005732:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005736:	7679                	lui	a2,0xffffe
    80005738:	963e                	add	a2,a2,a5
    8000573a:	00238697          	auipc	a3,0x238
    8000573e:	8c668693          	addi	a3,a3,-1850 # 8023d000 <disk+0x2000>
    80005742:	6298                	ld	a4,0(a3)
    80005744:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005746:	0a878593          	addi	a1,a5,168
    8000574a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000574c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000574e:	6298                	ld	a4,0(a3)
    80005750:	9732                	add	a4,a4,a2
    80005752:	45c1                	li	a1,16
    80005754:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005756:	6298                	ld	a4,0(a3)
    80005758:	9732                	add	a4,a4,a2
    8000575a:	4585                	li	a1,1
    8000575c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005760:	f8442703          	lw	a4,-124(s0)
    80005764:	628c                	ld	a1,0(a3)
    80005766:	962e                	add	a2,a2,a1
    80005768:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000576c:	0712                	slli	a4,a4,0x4
    8000576e:	6290                	ld	a2,0(a3)
    80005770:	963a                	add	a2,a2,a4
    80005772:	058a8593          	addi	a1,s5,88
    80005776:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005778:	6294                	ld	a3,0(a3)
    8000577a:	96ba                	add	a3,a3,a4
    8000577c:	40000613          	li	a2,1024
    80005780:	c690                	sw	a2,8(a3)
  if(write)
    80005782:	e40d1ae3          	bnez	s10,800055d6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005786:	00238697          	auipc	a3,0x238
    8000578a:	87a6b683          	ld	a3,-1926(a3) # 8023d000 <disk+0x2000>
    8000578e:	96ba                	add	a3,a3,a4
    80005790:	4609                	li	a2,2
    80005792:	00c69623          	sh	a2,12(a3)
    80005796:	b5b9                	j	800055e4 <virtio_disk_rw+0xd2>

0000000080005798 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005798:	1101                	addi	sp,sp,-32
    8000579a:	ec06                	sd	ra,24(sp)
    8000579c:	e822                	sd	s0,16(sp)
    8000579e:	e426                	sd	s1,8(sp)
    800057a0:	e04a                	sd	s2,0(sp)
    800057a2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a4:	00238517          	auipc	a0,0x238
    800057a8:	98450513          	addi	a0,a0,-1660 # 8023d128 <disk+0x2128>
    800057ac:	00001097          	auipc	ra,0x1
    800057b0:	b0c080e7          	jalr	-1268(ra) # 800062b8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b4:	10001737          	lui	a4,0x10001
    800057b8:	533c                	lw	a5,96(a4)
    800057ba:	8b8d                	andi	a5,a5,3
    800057bc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c2:	00238797          	auipc	a5,0x238
    800057c6:	83e78793          	addi	a5,a5,-1986 # 8023d000 <disk+0x2000>
    800057ca:	6b94                	ld	a3,16(a5)
    800057cc:	0207d703          	lhu	a4,32(a5)
    800057d0:	0026d783          	lhu	a5,2(a3)
    800057d4:	06f70163          	beq	a4,a5,80005836 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d8:	00236917          	auipc	s2,0x236
    800057dc:	82890913          	addi	s2,s2,-2008 # 8023b000 <disk>
    800057e0:	00238497          	auipc	s1,0x238
    800057e4:	82048493          	addi	s1,s1,-2016 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    800057e8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ec:	6898                	ld	a4,16(s1)
    800057ee:	0204d783          	lhu	a5,32(s1)
    800057f2:	8b9d                	andi	a5,a5,7
    800057f4:	078e                	slli	a5,a5,0x3
    800057f6:	97ba                	add	a5,a5,a4
    800057f8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057fa:	20078713          	addi	a4,a5,512
    800057fe:	0712                	slli	a4,a4,0x4
    80005800:	974a                	add	a4,a4,s2
    80005802:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005806:	e731                	bnez	a4,80005852 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005808:	20078793          	addi	a5,a5,512
    8000580c:	0792                	slli	a5,a5,0x4
    8000580e:	97ca                	add	a5,a5,s2
    80005810:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005812:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005816:	ffffc097          	auipc	ra,0xffffc
    8000581a:	040080e7          	jalr	64(ra) # 80001856 <wakeup>

    disk.used_idx += 1;
    8000581e:	0204d783          	lhu	a5,32(s1)
    80005822:	2785                	addiw	a5,a5,1
    80005824:	17c2                	slli	a5,a5,0x30
    80005826:	93c1                	srli	a5,a5,0x30
    80005828:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000582c:	6898                	ld	a4,16(s1)
    8000582e:	00275703          	lhu	a4,2(a4)
    80005832:	faf71be3          	bne	a4,a5,800057e8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005836:	00238517          	auipc	a0,0x238
    8000583a:	8f250513          	addi	a0,a0,-1806 # 8023d128 <disk+0x2128>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	b2e080e7          	jalr	-1234(ra) # 8000636c <release>
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	64a2                	ld	s1,8(sp)
    8000584c:	6902                	ld	s2,0(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret
      panic("virtio_disk_intr status");
    80005852:	00003517          	auipc	a0,0x3
    80005856:	f3650513          	addi	a0,a0,-202 # 80008788 <syscalls+0x3b0>
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	526080e7          	jalr	1318(ra) # 80005d80 <panic>

0000000080005862 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005862:	1141                	addi	sp,sp,-16
    80005864:	e422                	sd	s0,8(sp)
    80005866:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005868:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000586c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005870:	0037979b          	slliw	a5,a5,0x3
    80005874:	02004737          	lui	a4,0x2004
    80005878:	97ba                	add	a5,a5,a4
    8000587a:	0200c737          	lui	a4,0x200c
    8000587e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005882:	000f4637          	lui	a2,0xf4
    80005886:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000588a:	9732                	add	a4,a4,a2
    8000588c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000588e:	00259693          	slli	a3,a1,0x2
    80005892:	96ae                	add	a3,a3,a1
    80005894:	068e                	slli	a3,a3,0x3
    80005896:	00238717          	auipc	a4,0x238
    8000589a:	76a70713          	addi	a4,a4,1898 # 8023e000 <timer_scratch>
    8000589e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058a0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058a2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058a4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058a8:	00000797          	auipc	a5,0x0
    800058ac:	9c878793          	addi	a5,a5,-1592 # 80005270 <timervec>
    800058b0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058b8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058bc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058c0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058c4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058c8:	30479073          	csrw	mie,a5
}
    800058cc:	6422                	ld	s0,8(sp)
    800058ce:	0141                	addi	sp,sp,16
    800058d0:	8082                	ret

00000000800058d2 <start>:
{
    800058d2:	1141                	addi	sp,sp,-16
    800058d4:	e406                	sd	ra,8(sp)
    800058d6:	e022                	sd	s0,0(sp)
    800058d8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058da:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058de:	7779                	lui	a4,0xffffe
    800058e0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    800058e4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058e6:	6705                	lui	a4,0x1
    800058e8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058ec:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ee:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058f2:	ffffb797          	auipc	a5,0xffffb
    800058f6:	b3478793          	addi	a5,a5,-1228 # 80000426 <main>
    800058fa:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058fe:	4781                	li	a5,0
    80005900:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005904:	67c1                	lui	a5,0x10
    80005906:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005908:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000590c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005910:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005914:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005918:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000591c:	57fd                	li	a5,-1
    8000591e:	83a9                	srli	a5,a5,0xa
    80005920:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005924:	47bd                	li	a5,15
    80005926:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	f38080e7          	jalr	-200(ra) # 80005862 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005932:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005936:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005938:	823e                	mv	tp,a5
  asm volatile("mret");
    8000593a:	30200073          	mret
}
    8000593e:	60a2                	ld	ra,8(sp)
    80005940:	6402                	ld	s0,0(sp)
    80005942:	0141                	addi	sp,sp,16
    80005944:	8082                	ret

0000000080005946 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005946:	715d                	addi	sp,sp,-80
    80005948:	e486                	sd	ra,72(sp)
    8000594a:	e0a2                	sd	s0,64(sp)
    8000594c:	fc26                	sd	s1,56(sp)
    8000594e:	f84a                	sd	s2,48(sp)
    80005950:	f44e                	sd	s3,40(sp)
    80005952:	f052                	sd	s4,32(sp)
    80005954:	ec56                	sd	s5,24(sp)
    80005956:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005958:	04c05763          	blez	a2,800059a6 <consolewrite+0x60>
    8000595c:	8a2a                	mv	s4,a0
    8000595e:	84ae                	mv	s1,a1
    80005960:	89b2                	mv	s3,a2
    80005962:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005964:	5afd                	li	s5,-1
    80005966:	4685                	li	a3,1
    80005968:	8626                	mv	a2,s1
    8000596a:	85d2                	mv	a1,s4
    8000596c:	fbf40513          	addi	a0,s0,-65
    80005970:	ffffc097          	auipc	ra,0xffffc
    80005974:	154080e7          	jalr	340(ra) # 80001ac4 <either_copyin>
    80005978:	01550d63          	beq	a0,s5,80005992 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000597c:	fbf44503          	lbu	a0,-65(s0)
    80005980:	00000097          	auipc	ra,0x0
    80005984:	77e080e7          	jalr	1918(ra) # 800060fe <uartputc>
  for(i = 0; i < n; i++){
    80005988:	2905                	addiw	s2,s2,1
    8000598a:	0485                	addi	s1,s1,1
    8000598c:	fd299de3          	bne	s3,s2,80005966 <consolewrite+0x20>
    80005990:	894e                	mv	s2,s3
  }

  return i;
}
    80005992:	854a                	mv	a0,s2
    80005994:	60a6                	ld	ra,72(sp)
    80005996:	6406                	ld	s0,64(sp)
    80005998:	74e2                	ld	s1,56(sp)
    8000599a:	7942                	ld	s2,48(sp)
    8000599c:	79a2                	ld	s3,40(sp)
    8000599e:	7a02                	ld	s4,32(sp)
    800059a0:	6ae2                	ld	s5,24(sp)
    800059a2:	6161                	addi	sp,sp,80
    800059a4:	8082                	ret
  for(i = 0; i < n; i++){
    800059a6:	4901                	li	s2,0
    800059a8:	b7ed                	j	80005992 <consolewrite+0x4c>

00000000800059aa <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059aa:	7159                	addi	sp,sp,-112
    800059ac:	f486                	sd	ra,104(sp)
    800059ae:	f0a2                	sd	s0,96(sp)
    800059b0:	eca6                	sd	s1,88(sp)
    800059b2:	e8ca                	sd	s2,80(sp)
    800059b4:	e4ce                	sd	s3,72(sp)
    800059b6:	e0d2                	sd	s4,64(sp)
    800059b8:	fc56                	sd	s5,56(sp)
    800059ba:	f85a                	sd	s6,48(sp)
    800059bc:	f45e                	sd	s7,40(sp)
    800059be:	f062                	sd	s8,32(sp)
    800059c0:	ec66                	sd	s9,24(sp)
    800059c2:	e86a                	sd	s10,16(sp)
    800059c4:	1880                	addi	s0,sp,112
    800059c6:	8aaa                	mv	s5,a0
    800059c8:	8a2e                	mv	s4,a1
    800059ca:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059cc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059d0:	00240517          	auipc	a0,0x240
    800059d4:	77050513          	addi	a0,a0,1904 # 80246140 <cons>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	8e0080e7          	jalr	-1824(ra) # 800062b8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059e0:	00240497          	auipc	s1,0x240
    800059e4:	76048493          	addi	s1,s1,1888 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059e8:	00240917          	auipc	s2,0x240
    800059ec:	7f090913          	addi	s2,s2,2032 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059f0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059f2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059f4:	4ca9                	li	s9,10
  while(n > 0){
    800059f6:	07305863          	blez	s3,80005a66 <consoleread+0xbc>
    while(cons.r == cons.w){
    800059fa:	0984a783          	lw	a5,152(s1)
    800059fe:	09c4a703          	lw	a4,156(s1)
    80005a02:	02f71463          	bne	a4,a5,80005a2a <consoleread+0x80>
      if(myproc()->killed){
    80005a06:	ffffb097          	auipc	ra,0xffffb
    80005a0a:	600080e7          	jalr	1536(ra) # 80001006 <myproc>
    80005a0e:	551c                	lw	a5,40(a0)
    80005a10:	e7b5                	bnez	a5,80005a7c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a12:	85a6                	mv	a1,s1
    80005a14:	854a                	mv	a0,s2
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	cb4080e7          	jalr	-844(ra) # 800016ca <sleep>
    while(cons.r == cons.w){
    80005a1e:	0984a783          	lw	a5,152(s1)
    80005a22:	09c4a703          	lw	a4,156(s1)
    80005a26:	fef700e3          	beq	a4,a5,80005a06 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a2a:	0017871b          	addiw	a4,a5,1
    80005a2e:	08e4ac23          	sw	a4,152(s1)
    80005a32:	07f7f713          	andi	a4,a5,127
    80005a36:	9726                	add	a4,a4,s1
    80005a38:	01874703          	lbu	a4,24(a4)
    80005a3c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a40:	077d0563          	beq	s10,s7,80005aaa <consoleread+0x100>
    cbuf = c;
    80005a44:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a48:	4685                	li	a3,1
    80005a4a:	f9f40613          	addi	a2,s0,-97
    80005a4e:	85d2                	mv	a1,s4
    80005a50:	8556                	mv	a0,s5
    80005a52:	ffffc097          	auipc	ra,0xffffc
    80005a56:	01c080e7          	jalr	28(ra) # 80001a6e <either_copyout>
    80005a5a:	01850663          	beq	a0,s8,80005a66 <consoleread+0xbc>
    dst++;
    80005a5e:	0a05                	addi	s4,s4,1
    --n;
    80005a60:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a62:	f99d1ae3          	bne	s10,s9,800059f6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a66:	00240517          	auipc	a0,0x240
    80005a6a:	6da50513          	addi	a0,a0,1754 # 80246140 <cons>
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	8fe080e7          	jalr	-1794(ra) # 8000636c <release>

  return target - n;
    80005a76:	413b053b          	subw	a0,s6,s3
    80005a7a:	a811                	j	80005a8e <consoleread+0xe4>
        release(&cons.lock);
    80005a7c:	00240517          	auipc	a0,0x240
    80005a80:	6c450513          	addi	a0,a0,1732 # 80246140 <cons>
    80005a84:	00001097          	auipc	ra,0x1
    80005a88:	8e8080e7          	jalr	-1816(ra) # 8000636c <release>
        return -1;
    80005a8c:	557d                	li	a0,-1
}
    80005a8e:	70a6                	ld	ra,104(sp)
    80005a90:	7406                	ld	s0,96(sp)
    80005a92:	64e6                	ld	s1,88(sp)
    80005a94:	6946                	ld	s2,80(sp)
    80005a96:	69a6                	ld	s3,72(sp)
    80005a98:	6a06                	ld	s4,64(sp)
    80005a9a:	7ae2                	ld	s5,56(sp)
    80005a9c:	7b42                	ld	s6,48(sp)
    80005a9e:	7ba2                	ld	s7,40(sp)
    80005aa0:	7c02                	ld	s8,32(sp)
    80005aa2:	6ce2                	ld	s9,24(sp)
    80005aa4:	6d42                	ld	s10,16(sp)
    80005aa6:	6165                	addi	sp,sp,112
    80005aa8:	8082                	ret
      if(n < target){
    80005aaa:	0009871b          	sext.w	a4,s3
    80005aae:	fb677ce3          	bgeu	a4,s6,80005a66 <consoleread+0xbc>
        cons.r--;
    80005ab2:	00240717          	auipc	a4,0x240
    80005ab6:	72f72323          	sw	a5,1830(a4) # 802461d8 <cons+0x98>
    80005aba:	b775                	j	80005a66 <consoleread+0xbc>

0000000080005abc <consputc>:
{
    80005abc:	1141                	addi	sp,sp,-16
    80005abe:	e406                	sd	ra,8(sp)
    80005ac0:	e022                	sd	s0,0(sp)
    80005ac2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ac4:	10000793          	li	a5,256
    80005ac8:	00f50a63          	beq	a0,a5,80005adc <consputc+0x20>
    uartputc_sync(c);
    80005acc:	00000097          	auipc	ra,0x0
    80005ad0:	560080e7          	jalr	1376(ra) # 8000602c <uartputc_sync>
}
    80005ad4:	60a2                	ld	ra,8(sp)
    80005ad6:	6402                	ld	s0,0(sp)
    80005ad8:	0141                	addi	sp,sp,16
    80005ada:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005adc:	4521                	li	a0,8
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	54e080e7          	jalr	1358(ra) # 8000602c <uartputc_sync>
    80005ae6:	02000513          	li	a0,32
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	542080e7          	jalr	1346(ra) # 8000602c <uartputc_sync>
    80005af2:	4521                	li	a0,8
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	538080e7          	jalr	1336(ra) # 8000602c <uartputc_sync>
    80005afc:	bfe1                	j	80005ad4 <consputc+0x18>

0000000080005afe <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005afe:	1101                	addi	sp,sp,-32
    80005b00:	ec06                	sd	ra,24(sp)
    80005b02:	e822                	sd	s0,16(sp)
    80005b04:	e426                	sd	s1,8(sp)
    80005b06:	e04a                	sd	s2,0(sp)
    80005b08:	1000                	addi	s0,sp,32
    80005b0a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b0c:	00240517          	auipc	a0,0x240
    80005b10:	63450513          	addi	a0,a0,1588 # 80246140 <cons>
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	7a4080e7          	jalr	1956(ra) # 800062b8 <acquire>

  switch(c){
    80005b1c:	47d5                	li	a5,21
    80005b1e:	0af48663          	beq	s1,a5,80005bca <consoleintr+0xcc>
    80005b22:	0297ca63          	blt	a5,s1,80005b56 <consoleintr+0x58>
    80005b26:	47a1                	li	a5,8
    80005b28:	0ef48763          	beq	s1,a5,80005c16 <consoleintr+0x118>
    80005b2c:	47c1                	li	a5,16
    80005b2e:	10f49a63          	bne	s1,a5,80005c42 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b32:	ffffc097          	auipc	ra,0xffffc
    80005b36:	fe8080e7          	jalr	-24(ra) # 80001b1a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3a:	00240517          	auipc	a0,0x240
    80005b3e:	60650513          	addi	a0,a0,1542 # 80246140 <cons>
    80005b42:	00001097          	auipc	ra,0x1
    80005b46:	82a080e7          	jalr	-2006(ra) # 8000636c <release>
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	64a2                	ld	s1,8(sp)
    80005b50:	6902                	ld	s2,0(sp)
    80005b52:	6105                	addi	sp,sp,32
    80005b54:	8082                	ret
  switch(c){
    80005b56:	07f00793          	li	a5,127
    80005b5a:	0af48e63          	beq	s1,a5,80005c16 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5e:	00240717          	auipc	a4,0x240
    80005b62:	5e270713          	addi	a4,a4,1506 # 80246140 <cons>
    80005b66:	0a072783          	lw	a5,160(a4)
    80005b6a:	09872703          	lw	a4,152(a4)
    80005b6e:	9f99                	subw	a5,a5,a4
    80005b70:	07f00713          	li	a4,127
    80005b74:	fcf763e3          	bltu	a4,a5,80005b3a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b78:	47b5                	li	a5,13
    80005b7a:	0cf48763          	beq	s1,a5,80005c48 <consoleintr+0x14a>
      consputc(c);
    80005b7e:	8526                	mv	a0,s1
    80005b80:	00000097          	auipc	ra,0x0
    80005b84:	f3c080e7          	jalr	-196(ra) # 80005abc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b88:	00240797          	auipc	a5,0x240
    80005b8c:	5b878793          	addi	a5,a5,1464 # 80246140 <cons>
    80005b90:	0a07a703          	lw	a4,160(a5)
    80005b94:	0017069b          	addiw	a3,a4,1
    80005b98:	0006861b          	sext.w	a2,a3
    80005b9c:	0ad7a023          	sw	a3,160(a5)
    80005ba0:	07f77713          	andi	a4,a4,127
    80005ba4:	97ba                	add	a5,a5,a4
    80005ba6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005baa:	47a9                	li	a5,10
    80005bac:	0cf48563          	beq	s1,a5,80005c76 <consoleintr+0x178>
    80005bb0:	4791                	li	a5,4
    80005bb2:	0cf48263          	beq	s1,a5,80005c76 <consoleintr+0x178>
    80005bb6:	00240797          	auipc	a5,0x240
    80005bba:	6227a783          	lw	a5,1570(a5) # 802461d8 <cons+0x98>
    80005bbe:	0807879b          	addiw	a5,a5,128
    80005bc2:	f6f61ce3          	bne	a2,a5,80005b3a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc6:	863e                	mv	a2,a5
    80005bc8:	a07d                	j	80005c76 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bca:	00240717          	auipc	a4,0x240
    80005bce:	57670713          	addi	a4,a4,1398 # 80246140 <cons>
    80005bd2:	0a072783          	lw	a5,160(a4)
    80005bd6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bda:	00240497          	auipc	s1,0x240
    80005bde:	56648493          	addi	s1,s1,1382 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005be2:	4929                	li	s2,10
    80005be4:	f4f70be3          	beq	a4,a5,80005b3a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005be8:	37fd                	addiw	a5,a5,-1
    80005bea:	07f7f713          	andi	a4,a5,127
    80005bee:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf0:	01874703          	lbu	a4,24(a4)
    80005bf4:	f52703e3          	beq	a4,s2,80005b3a <consoleintr+0x3c>
      cons.e--;
    80005bf8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bfc:	10000513          	li	a0,256
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	ebc080e7          	jalr	-324(ra) # 80005abc <consputc>
    while(cons.e != cons.w &&
    80005c08:	0a04a783          	lw	a5,160(s1)
    80005c0c:	09c4a703          	lw	a4,156(s1)
    80005c10:	fcf71ce3          	bne	a4,a5,80005be8 <consoleintr+0xea>
    80005c14:	b71d                	j	80005b3a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c16:	00240717          	auipc	a4,0x240
    80005c1a:	52a70713          	addi	a4,a4,1322 # 80246140 <cons>
    80005c1e:	0a072783          	lw	a5,160(a4)
    80005c22:	09c72703          	lw	a4,156(a4)
    80005c26:	f0f70ae3          	beq	a4,a5,80005b3a <consoleintr+0x3c>
      cons.e--;
    80005c2a:	37fd                	addiw	a5,a5,-1
    80005c2c:	00240717          	auipc	a4,0x240
    80005c30:	5af72a23          	sw	a5,1460(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c34:	10000513          	li	a0,256
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	e84080e7          	jalr	-380(ra) # 80005abc <consputc>
    80005c40:	bded                	j	80005b3a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c42:	ee048ce3          	beqz	s1,80005b3a <consoleintr+0x3c>
    80005c46:	bf21                	j	80005b5e <consoleintr+0x60>
      consputc(c);
    80005c48:	4529                	li	a0,10
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	e72080e7          	jalr	-398(ra) # 80005abc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c52:	00240797          	auipc	a5,0x240
    80005c56:	4ee78793          	addi	a5,a5,1262 # 80246140 <cons>
    80005c5a:	0a07a703          	lw	a4,160(a5)
    80005c5e:	0017069b          	addiw	a3,a4,1
    80005c62:	0006861b          	sext.w	a2,a3
    80005c66:	0ad7a023          	sw	a3,160(a5)
    80005c6a:	07f77713          	andi	a4,a4,127
    80005c6e:	97ba                	add	a5,a5,a4
    80005c70:	4729                	li	a4,10
    80005c72:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c76:	00240797          	auipc	a5,0x240
    80005c7a:	56c7a323          	sw	a2,1382(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c7e:	00240517          	auipc	a0,0x240
    80005c82:	55a50513          	addi	a0,a0,1370 # 802461d8 <cons+0x98>
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	bd0080e7          	jalr	-1072(ra) # 80001856 <wakeup>
    80005c8e:	b575                	j	80005b3a <consoleintr+0x3c>

0000000080005c90 <consoleinit>:

void
consoleinit(void)
{
    80005c90:	1141                	addi	sp,sp,-16
    80005c92:	e406                	sd	ra,8(sp)
    80005c94:	e022                	sd	s0,0(sp)
    80005c96:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c98:	00003597          	auipc	a1,0x3
    80005c9c:	b0858593          	addi	a1,a1,-1272 # 800087a0 <syscalls+0x3c8>
    80005ca0:	00240517          	auipc	a0,0x240
    80005ca4:	4a050513          	addi	a0,a0,1184 # 80246140 <cons>
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	580080e7          	jalr	1408(ra) # 80006228 <initlock>

  uartinit();
    80005cb0:	00000097          	auipc	ra,0x0
    80005cb4:	32c080e7          	jalr	812(ra) # 80005fdc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cb8:	00233797          	auipc	a5,0x233
    80005cbc:	42878793          	addi	a5,a5,1064 # 802390e0 <devsw>
    80005cc0:	00000717          	auipc	a4,0x0
    80005cc4:	cea70713          	addi	a4,a4,-790 # 800059aa <consoleread>
    80005cc8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cca:	00000717          	auipc	a4,0x0
    80005cce:	c7c70713          	addi	a4,a4,-900 # 80005946 <consolewrite>
    80005cd2:	ef98                	sd	a4,24(a5)
}
    80005cd4:	60a2                	ld	ra,8(sp)
    80005cd6:	6402                	ld	s0,0(sp)
    80005cd8:	0141                	addi	sp,sp,16
    80005cda:	8082                	ret

0000000080005cdc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cdc:	7179                	addi	sp,sp,-48
    80005cde:	f406                	sd	ra,40(sp)
    80005ce0:	f022                	sd	s0,32(sp)
    80005ce2:	ec26                	sd	s1,24(sp)
    80005ce4:	e84a                	sd	s2,16(sp)
    80005ce6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ce8:	c219                	beqz	a2,80005cee <printint+0x12>
    80005cea:	08054763          	bltz	a0,80005d78 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cee:	2501                	sext.w	a0,a0
    80005cf0:	4881                	li	a7,0
    80005cf2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cf6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cf8:	2581                	sext.w	a1,a1
    80005cfa:	00003617          	auipc	a2,0x3
    80005cfe:	ad660613          	addi	a2,a2,-1322 # 800087d0 <digits>
    80005d02:	883a                	mv	a6,a4
    80005d04:	2705                	addiw	a4,a4,1
    80005d06:	02b577bb          	remuw	a5,a0,a1
    80005d0a:	1782                	slli	a5,a5,0x20
    80005d0c:	9381                	srli	a5,a5,0x20
    80005d0e:	97b2                	add	a5,a5,a2
    80005d10:	0007c783          	lbu	a5,0(a5)
    80005d14:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d18:	0005079b          	sext.w	a5,a0
    80005d1c:	02b5553b          	divuw	a0,a0,a1
    80005d20:	0685                	addi	a3,a3,1
    80005d22:	feb7f0e3          	bgeu	a5,a1,80005d02 <printint+0x26>

  if(sign)
    80005d26:	00088c63          	beqz	a7,80005d3e <printint+0x62>
    buf[i++] = '-';
    80005d2a:	fe070793          	addi	a5,a4,-32
    80005d2e:	00878733          	add	a4,a5,s0
    80005d32:	02d00793          	li	a5,45
    80005d36:	fef70823          	sb	a5,-16(a4)
    80005d3a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d3e:	02e05763          	blez	a4,80005d6c <printint+0x90>
    80005d42:	fd040793          	addi	a5,s0,-48
    80005d46:	00e784b3          	add	s1,a5,a4
    80005d4a:	fff78913          	addi	s2,a5,-1
    80005d4e:	993a                	add	s2,s2,a4
    80005d50:	377d                	addiw	a4,a4,-1
    80005d52:	1702                	slli	a4,a4,0x20
    80005d54:	9301                	srli	a4,a4,0x20
    80005d56:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d5a:	fff4c503          	lbu	a0,-1(s1)
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	d5e080e7          	jalr	-674(ra) # 80005abc <consputc>
  while(--i >= 0)
    80005d66:	14fd                	addi	s1,s1,-1
    80005d68:	ff2499e3          	bne	s1,s2,80005d5a <printint+0x7e>
}
    80005d6c:	70a2                	ld	ra,40(sp)
    80005d6e:	7402                	ld	s0,32(sp)
    80005d70:	64e2                	ld	s1,24(sp)
    80005d72:	6942                	ld	s2,16(sp)
    80005d74:	6145                	addi	sp,sp,48
    80005d76:	8082                	ret
    x = -xx;
    80005d78:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d7c:	4885                	li	a7,1
    x = -xx;
    80005d7e:	bf95                	j	80005cf2 <printint+0x16>

0000000080005d80 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d80:	1101                	addi	sp,sp,-32
    80005d82:	ec06                	sd	ra,24(sp)
    80005d84:	e822                	sd	s0,16(sp)
    80005d86:	e426                	sd	s1,8(sp)
    80005d88:	1000                	addi	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d8c:	00240797          	auipc	a5,0x240
    80005d90:	4607aa23          	sw	zero,1140(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005d94:	00003517          	auipc	a0,0x3
    80005d98:	a1450513          	addi	a0,a0,-1516 # 800087a8 <syscalls+0x3d0>
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	02e080e7          	jalr	46(ra) # 80005dca <printf>
  printf(s);
    80005da4:	8526                	mv	a0,s1
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	024080e7          	jalr	36(ra) # 80005dca <printf>
  printf("\n");
    80005dae:	00002517          	auipc	a0,0x2
    80005db2:	2aa50513          	addi	a0,a0,682 # 80008058 <etext+0x58>
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	014080e7          	jalr	20(ra) # 80005dca <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dbe:	4785                	li	a5,1
    80005dc0:	00003717          	auipc	a4,0x3
    80005dc4:	24f72e23          	sw	a5,604(a4) # 8000901c <panicked>
  for(;;)
    80005dc8:	a001                	j	80005dc8 <panic+0x48>

0000000080005dca <printf>:
{
    80005dca:	7131                	addi	sp,sp,-192
    80005dcc:	fc86                	sd	ra,120(sp)
    80005dce:	f8a2                	sd	s0,112(sp)
    80005dd0:	f4a6                	sd	s1,104(sp)
    80005dd2:	f0ca                	sd	s2,96(sp)
    80005dd4:	ecce                	sd	s3,88(sp)
    80005dd6:	e8d2                	sd	s4,80(sp)
    80005dd8:	e4d6                	sd	s5,72(sp)
    80005dda:	e0da                	sd	s6,64(sp)
    80005ddc:	fc5e                	sd	s7,56(sp)
    80005dde:	f862                	sd	s8,48(sp)
    80005de0:	f466                	sd	s9,40(sp)
    80005de2:	f06a                	sd	s10,32(sp)
    80005de4:	ec6e                	sd	s11,24(sp)
    80005de6:	0100                	addi	s0,sp,128
    80005de8:	8a2a                	mv	s4,a0
    80005dea:	e40c                	sd	a1,8(s0)
    80005dec:	e810                	sd	a2,16(s0)
    80005dee:	ec14                	sd	a3,24(s0)
    80005df0:	f018                	sd	a4,32(s0)
    80005df2:	f41c                	sd	a5,40(s0)
    80005df4:	03043823          	sd	a6,48(s0)
    80005df8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dfc:	00240d97          	auipc	s11,0x240
    80005e00:	404dad83          	lw	s11,1028(s11) # 80246200 <pr+0x18>
  if(locking)
    80005e04:	020d9b63          	bnez	s11,80005e3a <printf+0x70>
  if (fmt == 0)
    80005e08:	040a0263          	beqz	s4,80005e4c <printf+0x82>
  va_start(ap, fmt);
    80005e0c:	00840793          	addi	a5,s0,8
    80005e10:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e14:	000a4503          	lbu	a0,0(s4)
    80005e18:	14050f63          	beqz	a0,80005f76 <printf+0x1ac>
    80005e1c:	4981                	li	s3,0
    if(c != '%'){
    80005e1e:	02500a93          	li	s5,37
    switch(c){
    80005e22:	07000b93          	li	s7,112
  consputc('x');
    80005e26:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e28:	00003b17          	auipc	s6,0x3
    80005e2c:	9a8b0b13          	addi	s6,s6,-1624 # 800087d0 <digits>
    switch(c){
    80005e30:	07300c93          	li	s9,115
    80005e34:	06400c13          	li	s8,100
    80005e38:	a82d                	j	80005e72 <printf+0xa8>
    acquire(&pr.lock);
    80005e3a:	00240517          	auipc	a0,0x240
    80005e3e:	3ae50513          	addi	a0,a0,942 # 802461e8 <pr>
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	476080e7          	jalr	1142(ra) # 800062b8 <acquire>
    80005e4a:	bf7d                	j	80005e08 <printf+0x3e>
    panic("null fmt");
    80005e4c:	00003517          	auipc	a0,0x3
    80005e50:	96c50513          	addi	a0,a0,-1684 # 800087b8 <syscalls+0x3e0>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	f2c080e7          	jalr	-212(ra) # 80005d80 <panic>
      consputc(c);
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	c60080e7          	jalr	-928(ra) # 80005abc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e64:	2985                	addiw	s3,s3,1
    80005e66:	013a07b3          	add	a5,s4,s3
    80005e6a:	0007c503          	lbu	a0,0(a5)
    80005e6e:	10050463          	beqz	a0,80005f76 <printf+0x1ac>
    if(c != '%'){
    80005e72:	ff5515e3          	bne	a0,s5,80005e5c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e76:	2985                	addiw	s3,s3,1
    80005e78:	013a07b3          	add	a5,s4,s3
    80005e7c:	0007c783          	lbu	a5,0(a5)
    80005e80:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e84:	cbed                	beqz	a5,80005f76 <printf+0x1ac>
    switch(c){
    80005e86:	05778a63          	beq	a5,s7,80005eda <printf+0x110>
    80005e8a:	02fbf663          	bgeu	s7,a5,80005eb6 <printf+0xec>
    80005e8e:	09978863          	beq	a5,s9,80005f1e <printf+0x154>
    80005e92:	07800713          	li	a4,120
    80005e96:	0ce79563          	bne	a5,a4,80005f60 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	4605                	li	a2,1
    80005ea8:	85ea                	mv	a1,s10
    80005eaa:	4388                	lw	a0,0(a5)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	e30080e7          	jalr	-464(ra) # 80005cdc <printint>
      break;
    80005eb4:	bf45                	j	80005e64 <printf+0x9a>
    switch(c){
    80005eb6:	09578f63          	beq	a5,s5,80005f54 <printf+0x18a>
    80005eba:	0b879363          	bne	a5,s8,80005f60 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ebe:	f8843783          	ld	a5,-120(s0)
    80005ec2:	00878713          	addi	a4,a5,8
    80005ec6:	f8e43423          	sd	a4,-120(s0)
    80005eca:	4605                	li	a2,1
    80005ecc:	45a9                	li	a1,10
    80005ece:	4388                	lw	a0,0(a5)
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	e0c080e7          	jalr	-500(ra) # 80005cdc <printint>
      break;
    80005ed8:	b771                	j	80005e64 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005eea:	03000513          	li	a0,48
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	bce080e7          	jalr	-1074(ra) # 80005abc <consputc>
  consputc('x');
    80005ef6:	07800513          	li	a0,120
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	bc2080e7          	jalr	-1086(ra) # 80005abc <consputc>
    80005f02:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	03c95793          	srli	a5,s2,0x3c
    80005f08:	97da                	add	a5,a5,s6
    80005f0a:	0007c503          	lbu	a0,0(a5)
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bae080e7          	jalr	-1106(ra) # 80005abc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f16:	0912                	slli	s2,s2,0x4
    80005f18:	34fd                	addiw	s1,s1,-1
    80005f1a:	f4ed                	bnez	s1,80005f04 <printf+0x13a>
    80005f1c:	b7a1                	j	80005e64 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f1e:	f8843783          	ld	a5,-120(s0)
    80005f22:	00878713          	addi	a4,a5,8
    80005f26:	f8e43423          	sd	a4,-120(s0)
    80005f2a:	6384                	ld	s1,0(a5)
    80005f2c:	cc89                	beqz	s1,80005f46 <printf+0x17c>
      for(; *s; s++)
    80005f2e:	0004c503          	lbu	a0,0(s1)
    80005f32:	d90d                	beqz	a0,80005e64 <printf+0x9a>
        consputc(*s);
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b88080e7          	jalr	-1144(ra) # 80005abc <consputc>
      for(; *s; s++)
    80005f3c:	0485                	addi	s1,s1,1
    80005f3e:	0004c503          	lbu	a0,0(s1)
    80005f42:	f96d                	bnez	a0,80005f34 <printf+0x16a>
    80005f44:	b705                	j	80005e64 <printf+0x9a>
        s = "(null)";
    80005f46:	00003497          	auipc	s1,0x3
    80005f4a:	86a48493          	addi	s1,s1,-1942 # 800087b0 <syscalls+0x3d8>
      for(; *s; s++)
    80005f4e:	02800513          	li	a0,40
    80005f52:	b7cd                	j	80005f34 <printf+0x16a>
      consputc('%');
    80005f54:	8556                	mv	a0,s5
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	b66080e7          	jalr	-1178(ra) # 80005abc <consputc>
      break;
    80005f5e:	b719                	j	80005e64 <printf+0x9a>
      consputc('%');
    80005f60:	8556                	mv	a0,s5
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b5a080e7          	jalr	-1190(ra) # 80005abc <consputc>
      consputc(c);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	b50080e7          	jalr	-1200(ra) # 80005abc <consputc>
      break;
    80005f74:	bdc5                	j	80005e64 <printf+0x9a>
  if(locking)
    80005f76:	020d9163          	bnez	s11,80005f98 <printf+0x1ce>
}
    80005f7a:	70e6                	ld	ra,120(sp)
    80005f7c:	7446                	ld	s0,112(sp)
    80005f7e:	74a6                	ld	s1,104(sp)
    80005f80:	7906                	ld	s2,96(sp)
    80005f82:	69e6                	ld	s3,88(sp)
    80005f84:	6a46                	ld	s4,80(sp)
    80005f86:	6aa6                	ld	s5,72(sp)
    80005f88:	6b06                	ld	s6,64(sp)
    80005f8a:	7be2                	ld	s7,56(sp)
    80005f8c:	7c42                	ld	s8,48(sp)
    80005f8e:	7ca2                	ld	s9,40(sp)
    80005f90:	7d02                	ld	s10,32(sp)
    80005f92:	6de2                	ld	s11,24(sp)
    80005f94:	6129                	addi	sp,sp,192
    80005f96:	8082                	ret
    release(&pr.lock);
    80005f98:	00240517          	auipc	a0,0x240
    80005f9c:	25050513          	addi	a0,a0,592 # 802461e8 <pr>
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	3cc080e7          	jalr	972(ra) # 8000636c <release>
}
    80005fa8:	bfc9                	j	80005f7a <printf+0x1b0>

0000000080005faa <printfinit>:
    ;
}

void
printfinit(void)
{
    80005faa:	1101                	addi	sp,sp,-32
    80005fac:	ec06                	sd	ra,24(sp)
    80005fae:	e822                	sd	s0,16(sp)
    80005fb0:	e426                	sd	s1,8(sp)
    80005fb2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fb4:	00240497          	auipc	s1,0x240
    80005fb8:	23448493          	addi	s1,s1,564 # 802461e8 <pr>
    80005fbc:	00003597          	auipc	a1,0x3
    80005fc0:	80c58593          	addi	a1,a1,-2036 # 800087c8 <syscalls+0x3f0>
    80005fc4:	8526                	mv	a0,s1
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	262080e7          	jalr	610(ra) # 80006228 <initlock>
  pr.locking = 1;
    80005fce:	4785                	li	a5,1
    80005fd0:	cc9c                	sw	a5,24(s1)
}
    80005fd2:	60e2                	ld	ra,24(sp)
    80005fd4:	6442                	ld	s0,16(sp)
    80005fd6:	64a2                	ld	s1,8(sp)
    80005fd8:	6105                	addi	sp,sp,32
    80005fda:	8082                	ret

0000000080005fdc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fdc:	1141                	addi	sp,sp,-16
    80005fde:	e406                	sd	ra,8(sp)
    80005fe0:	e022                	sd	s0,0(sp)
    80005fe2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fe4:	100007b7          	lui	a5,0x10000
    80005fe8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fec:	f8000713          	li	a4,-128
    80005ff0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ff4:	470d                	li	a4,3
    80005ff6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ffa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ffe:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006002:	469d                	li	a3,7
    80006004:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006008:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000600c:	00002597          	auipc	a1,0x2
    80006010:	7dc58593          	addi	a1,a1,2012 # 800087e8 <digits+0x18>
    80006014:	00240517          	auipc	a0,0x240
    80006018:	1f450513          	addi	a0,a0,500 # 80246208 <uart_tx_lock>
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	20c080e7          	jalr	524(ra) # 80006228 <initlock>
}
    80006024:	60a2                	ld	ra,8(sp)
    80006026:	6402                	ld	s0,0(sp)
    80006028:	0141                	addi	sp,sp,16
    8000602a:	8082                	ret

000000008000602c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000602c:	1101                	addi	sp,sp,-32
    8000602e:	ec06                	sd	ra,24(sp)
    80006030:	e822                	sd	s0,16(sp)
    80006032:	e426                	sd	s1,8(sp)
    80006034:	1000                	addi	s0,sp,32
    80006036:	84aa                	mv	s1,a0
  push_off();
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	234080e7          	jalr	564(ra) # 8000626c <push_off>

  if(panicked){
    80006040:	00003797          	auipc	a5,0x3
    80006044:	fdc7a783          	lw	a5,-36(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006048:	10000737          	lui	a4,0x10000
  if(panicked){
    8000604c:	c391                	beqz	a5,80006050 <uartputc_sync+0x24>
    for(;;)
    8000604e:	a001                	j	8000604e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006050:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006054:	0207f793          	andi	a5,a5,32
    80006058:	dfe5                	beqz	a5,80006050 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000605a:	0ff4f513          	zext.b	a0,s1
    8000605e:	100007b7          	lui	a5,0x10000
    80006062:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	2a6080e7          	jalr	678(ra) # 8000630c <pop_off>
}
    8000606e:	60e2                	ld	ra,24(sp)
    80006070:	6442                	ld	s0,16(sp)
    80006072:	64a2                	ld	s1,8(sp)
    80006074:	6105                	addi	sp,sp,32
    80006076:	8082                	ret

0000000080006078 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006078:	00003797          	auipc	a5,0x3
    8000607c:	fa87b783          	ld	a5,-88(a5) # 80009020 <uart_tx_r>
    80006080:	00003717          	auipc	a4,0x3
    80006084:	fa873703          	ld	a4,-88(a4) # 80009028 <uart_tx_w>
    80006088:	06f70a63          	beq	a4,a5,800060fc <uartstart+0x84>
{
    8000608c:	7139                	addi	sp,sp,-64
    8000608e:	fc06                	sd	ra,56(sp)
    80006090:	f822                	sd	s0,48(sp)
    80006092:	f426                	sd	s1,40(sp)
    80006094:	f04a                	sd	s2,32(sp)
    80006096:	ec4e                	sd	s3,24(sp)
    80006098:	e852                	sd	s4,16(sp)
    8000609a:	e456                	sd	s5,8(sp)
    8000609c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000609e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060a2:	00240a17          	auipc	s4,0x240
    800060a6:	166a0a13          	addi	s4,s4,358 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    800060aa:	00003497          	auipc	s1,0x3
    800060ae:	f7648493          	addi	s1,s1,-138 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060b2:	00003997          	auipc	s3,0x3
    800060b6:	f7698993          	addi	s3,s3,-138 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ba:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060be:	02077713          	andi	a4,a4,32
    800060c2:	c705                	beqz	a4,800060ea <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c4:	01f7f713          	andi	a4,a5,31
    800060c8:	9752                	add	a4,a4,s4
    800060ca:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ce:	0785                	addi	a5,a5,1
    800060d0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060d2:	8526                	mv	a0,s1
    800060d4:	ffffb097          	auipc	ra,0xffffb
    800060d8:	782080e7          	jalr	1922(ra) # 80001856 <wakeup>
    
    WriteReg(THR, c);
    800060dc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060e0:	609c                	ld	a5,0(s1)
    800060e2:	0009b703          	ld	a4,0(s3)
    800060e6:	fcf71ae3          	bne	a4,a5,800060ba <uartstart+0x42>
  }
}
    800060ea:	70e2                	ld	ra,56(sp)
    800060ec:	7442                	ld	s0,48(sp)
    800060ee:	74a2                	ld	s1,40(sp)
    800060f0:	7902                	ld	s2,32(sp)
    800060f2:	69e2                	ld	s3,24(sp)
    800060f4:	6a42                	ld	s4,16(sp)
    800060f6:	6aa2                	ld	s5,8(sp)
    800060f8:	6121                	addi	sp,sp,64
    800060fa:	8082                	ret
    800060fc:	8082                	ret

00000000800060fe <uartputc>:
{
    800060fe:	7179                	addi	sp,sp,-48
    80006100:	f406                	sd	ra,40(sp)
    80006102:	f022                	sd	s0,32(sp)
    80006104:	ec26                	sd	s1,24(sp)
    80006106:	e84a                	sd	s2,16(sp)
    80006108:	e44e                	sd	s3,8(sp)
    8000610a:	e052                	sd	s4,0(sp)
    8000610c:	1800                	addi	s0,sp,48
    8000610e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006110:	00240517          	auipc	a0,0x240
    80006114:	0f850513          	addi	a0,a0,248 # 80246208 <uart_tx_lock>
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	1a0080e7          	jalr	416(ra) # 800062b8 <acquire>
  if(panicked){
    80006120:	00003797          	auipc	a5,0x3
    80006124:	efc7a783          	lw	a5,-260(a5) # 8000901c <panicked>
    80006128:	c391                	beqz	a5,8000612c <uartputc+0x2e>
    for(;;)
    8000612a:	a001                	j	8000612a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612c:	00003717          	auipc	a4,0x3
    80006130:	efc73703          	ld	a4,-260(a4) # 80009028 <uart_tx_w>
    80006134:	00003797          	auipc	a5,0x3
    80006138:	eec7b783          	ld	a5,-276(a5) # 80009020 <uart_tx_r>
    8000613c:	02078793          	addi	a5,a5,32
    80006140:	02e79b63          	bne	a5,a4,80006176 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006144:	00240997          	auipc	s3,0x240
    80006148:	0c498993          	addi	s3,s3,196 # 80246208 <uart_tx_lock>
    8000614c:	00003497          	auipc	s1,0x3
    80006150:	ed448493          	addi	s1,s1,-300 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006154:	00003917          	auipc	s2,0x3
    80006158:	ed490913          	addi	s2,s2,-300 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000615c:	85ce                	mv	a1,s3
    8000615e:	8526                	mv	a0,s1
    80006160:	ffffb097          	auipc	ra,0xffffb
    80006164:	56a080e7          	jalr	1386(ra) # 800016ca <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006168:	00093703          	ld	a4,0(s2)
    8000616c:	609c                	ld	a5,0(s1)
    8000616e:	02078793          	addi	a5,a5,32
    80006172:	fee785e3          	beq	a5,a4,8000615c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006176:	00240497          	auipc	s1,0x240
    8000617a:	09248493          	addi	s1,s1,146 # 80246208 <uart_tx_lock>
    8000617e:	01f77793          	andi	a5,a4,31
    80006182:	97a6                	add	a5,a5,s1
    80006184:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006188:	0705                	addi	a4,a4,1
    8000618a:	00003797          	auipc	a5,0x3
    8000618e:	e8e7bf23          	sd	a4,-354(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006192:	00000097          	auipc	ra,0x0
    80006196:	ee6080e7          	jalr	-282(ra) # 80006078 <uartstart>
      release(&uart_tx_lock);
    8000619a:	8526                	mv	a0,s1
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	1d0080e7          	jalr	464(ra) # 8000636c <release>
}
    800061a4:	70a2                	ld	ra,40(sp)
    800061a6:	7402                	ld	s0,32(sp)
    800061a8:	64e2                	ld	s1,24(sp)
    800061aa:	6942                	ld	s2,16(sp)
    800061ac:	69a2                	ld	s3,8(sp)
    800061ae:	6a02                	ld	s4,0(sp)
    800061b0:	6145                	addi	sp,sp,48
    800061b2:	8082                	ret

00000000800061b4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061b4:	1141                	addi	sp,sp,-16
    800061b6:	e422                	sd	s0,8(sp)
    800061b8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ba:	100007b7          	lui	a5,0x10000
    800061be:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061c2:	8b85                	andi	a5,a5,1
    800061c4:	cb81                	beqz	a5,800061d4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061c6:	100007b7          	lui	a5,0x10000
    800061ca:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ce:	6422                	ld	s0,8(sp)
    800061d0:	0141                	addi	sp,sp,16
    800061d2:	8082                	ret
    return -1;
    800061d4:	557d                	li	a0,-1
    800061d6:	bfe5                	j	800061ce <uartgetc+0x1a>

00000000800061d8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061d8:	1101                	addi	sp,sp,-32
    800061da:	ec06                	sd	ra,24(sp)
    800061dc:	e822                	sd	s0,16(sp)
    800061de:	e426                	sd	s1,8(sp)
    800061e0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061e2:	54fd                	li	s1,-1
    800061e4:	a029                	j	800061ee <uartintr+0x16>
      break;
    consoleintr(c);
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	918080e7          	jalr	-1768(ra) # 80005afe <consoleintr>
    int c = uartgetc();
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	fc6080e7          	jalr	-58(ra) # 800061b4 <uartgetc>
    if(c == -1)
    800061f6:	fe9518e3          	bne	a0,s1,800061e6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061fa:	00240497          	auipc	s1,0x240
    800061fe:	00e48493          	addi	s1,s1,14 # 80246208 <uart_tx_lock>
    80006202:	8526                	mv	a0,s1
    80006204:	00000097          	auipc	ra,0x0
    80006208:	0b4080e7          	jalr	180(ra) # 800062b8 <acquire>
  uartstart();
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	e6c080e7          	jalr	-404(ra) # 80006078 <uartstart>
  release(&uart_tx_lock);
    80006214:	8526                	mv	a0,s1
    80006216:	00000097          	auipc	ra,0x0
    8000621a:	156080e7          	jalr	342(ra) # 8000636c <release>
}
    8000621e:	60e2                	ld	ra,24(sp)
    80006220:	6442                	ld	s0,16(sp)
    80006222:	64a2                	ld	s1,8(sp)
    80006224:	6105                	addi	sp,sp,32
    80006226:	8082                	ret

0000000080006228 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006228:	1141                	addi	sp,sp,-16
    8000622a:	e422                	sd	s0,8(sp)
    8000622c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000622e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006230:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006234:	00053823          	sd	zero,16(a0)
}
    80006238:	6422                	ld	s0,8(sp)
    8000623a:	0141                	addi	sp,sp,16
    8000623c:	8082                	ret

000000008000623e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000623e:	411c                	lw	a5,0(a0)
    80006240:	e399                	bnez	a5,80006246 <holding+0x8>
    80006242:	4501                	li	a0,0
  return r;
}
    80006244:	8082                	ret
{
    80006246:	1101                	addi	sp,sp,-32
    80006248:	ec06                	sd	ra,24(sp)
    8000624a:	e822                	sd	s0,16(sp)
    8000624c:	e426                	sd	s1,8(sp)
    8000624e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006250:	6904                	ld	s1,16(a0)
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	d98080e7          	jalr	-616(ra) # 80000fea <mycpu>
    8000625a:	40a48533          	sub	a0,s1,a0
    8000625e:	00153513          	seqz	a0,a0
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret

000000008000626c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000626c:	1101                	addi	sp,sp,-32
    8000626e:	ec06                	sd	ra,24(sp)
    80006270:	e822                	sd	s0,16(sp)
    80006272:	e426                	sd	s1,8(sp)
    80006274:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006276:	100024f3          	csrr	s1,sstatus
    8000627a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000627e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006280:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	d66080e7          	jalr	-666(ra) # 80000fea <mycpu>
    8000628c:	5d3c                	lw	a5,120(a0)
    8000628e:	cf89                	beqz	a5,800062a8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006290:	ffffb097          	auipc	ra,0xffffb
    80006294:	d5a080e7          	jalr	-678(ra) # 80000fea <mycpu>
    80006298:	5d3c                	lw	a5,120(a0)
    8000629a:	2785                	addiw	a5,a5,1
    8000629c:	dd3c                	sw	a5,120(a0)
}
    8000629e:	60e2                	ld	ra,24(sp)
    800062a0:	6442                	ld	s0,16(sp)
    800062a2:	64a2                	ld	s1,8(sp)
    800062a4:	6105                	addi	sp,sp,32
    800062a6:	8082                	ret
    mycpu()->intena = old;
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	d42080e7          	jalr	-702(ra) # 80000fea <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062b0:	8085                	srli	s1,s1,0x1
    800062b2:	8885                	andi	s1,s1,1
    800062b4:	dd64                	sw	s1,124(a0)
    800062b6:	bfe9                	j	80006290 <push_off+0x24>

00000000800062b8 <acquire>:
{
    800062b8:	1101                	addi	sp,sp,-32
    800062ba:	ec06                	sd	ra,24(sp)
    800062bc:	e822                	sd	s0,16(sp)
    800062be:	e426                	sd	s1,8(sp)
    800062c0:	1000                	addi	s0,sp,32
    800062c2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	fa8080e7          	jalr	-88(ra) # 8000626c <push_off>
  if(holding(lk))
    800062cc:	8526                	mv	a0,s1
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	f70080e7          	jalr	-144(ra) # 8000623e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d6:	4705                	li	a4,1
  if(holding(lk))
    800062d8:	e115                	bnez	a0,800062fc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062da:	87ba                	mv	a5,a4
    800062dc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062e0:	2781                	sext.w	a5,a5
    800062e2:	ffe5                	bnez	a5,800062da <acquire+0x22>
  __sync_synchronize();
    800062e4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	d02080e7          	jalr	-766(ra) # 80000fea <mycpu>
    800062f0:	e888                	sd	a0,16(s1)
}
    800062f2:	60e2                	ld	ra,24(sp)
    800062f4:	6442                	ld	s0,16(sp)
    800062f6:	64a2                	ld	s1,8(sp)
    800062f8:	6105                	addi	sp,sp,32
    800062fa:	8082                	ret
    panic("acquire");
    800062fc:	00002517          	auipc	a0,0x2
    80006300:	4f450513          	addi	a0,a0,1268 # 800087f0 <digits+0x20>
    80006304:	00000097          	auipc	ra,0x0
    80006308:	a7c080e7          	jalr	-1412(ra) # 80005d80 <panic>

000000008000630c <pop_off>:

void
pop_off(void)
{
    8000630c:	1141                	addi	sp,sp,-16
    8000630e:	e406                	sd	ra,8(sp)
    80006310:	e022                	sd	s0,0(sp)
    80006312:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	cd6080e7          	jalr	-810(ra) # 80000fea <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000631c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006320:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006322:	e78d                	bnez	a5,8000634c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006324:	5d3c                	lw	a5,120(a0)
    80006326:	02f05b63          	blez	a5,8000635c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000632a:	37fd                	addiw	a5,a5,-1
    8000632c:	0007871b          	sext.w	a4,a5
    80006330:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006332:	eb09                	bnez	a4,80006344 <pop_off+0x38>
    80006334:	5d7c                	lw	a5,124(a0)
    80006336:	c799                	beqz	a5,80006344 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006338:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000633c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006340:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006344:	60a2                	ld	ra,8(sp)
    80006346:	6402                	ld	s0,0(sp)
    80006348:	0141                	addi	sp,sp,16
    8000634a:	8082                	ret
    panic("pop_off - interruptible");
    8000634c:	00002517          	auipc	a0,0x2
    80006350:	4ac50513          	addi	a0,a0,1196 # 800087f8 <digits+0x28>
    80006354:	00000097          	auipc	ra,0x0
    80006358:	a2c080e7          	jalr	-1492(ra) # 80005d80 <panic>
    panic("pop_off");
    8000635c:	00002517          	auipc	a0,0x2
    80006360:	4b450513          	addi	a0,a0,1204 # 80008810 <digits+0x40>
    80006364:	00000097          	auipc	ra,0x0
    80006368:	a1c080e7          	jalr	-1508(ra) # 80005d80 <panic>

000000008000636c <release>:
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
    80006376:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	ec6080e7          	jalr	-314(ra) # 8000623e <holding>
    80006380:	c115                	beqz	a0,800063a4 <release+0x38>
  lk->cpu = 0;
    80006382:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006386:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000638a:	0f50000f          	fence	iorw,ow
    8000638e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006392:	00000097          	auipc	ra,0x0
    80006396:	f7a080e7          	jalr	-134(ra) # 8000630c <pop_off>
}
    8000639a:	60e2                	ld	ra,24(sp)
    8000639c:	6442                	ld	s0,16(sp)
    8000639e:	64a2                	ld	s1,8(sp)
    800063a0:	6105                	addi	sp,sp,32
    800063a2:	8082                	ret
    panic("release");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	47450513          	addi	a0,a0,1140 # 80008818 <digits+0x48>
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	9d4080e7          	jalr	-1580(ra) # 80005d80 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
