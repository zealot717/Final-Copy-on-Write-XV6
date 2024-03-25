
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cwtest>:



void
cwtest()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  int sz = phys_size / 4;
  int pid1, pid2;


  
  char *p = sbrk(sz);
   8:	02000537          	lui	a0,0x2000
   c:	00000097          	auipc	ra,0x0
  10:	3c6080e7          	jalr	966(ra) # 3d2 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  14:	57fd                	li	a5,-1
  16:	02f50563          	beq	a0,a5,40 <cwtest+0x40>
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  1a:	00000097          	auipc	ra,0x0
  1e:	328080e7          	jalr	808(ra) # 342 <fork>
  if(pid1 < 0){
  22:	02054e63          	bltz	a0,5e <cwtest+0x5e>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
  26:	e93d                	bnez	a0,9c <cwtest+0x9c>
    pid2 = fork();
  28:	00000097          	auipc	ra,0x0
  2c:	31a080e7          	jalr	794(ra) # 342 <fork>
    if(pid2 < 0){
  30:	04054463          	bltz	a0,78 <cwtest+0x78>
      printf("fork failed");
      exit(-1);
    }
    if(pid2 == 0){
  34:	ed39                	bnez	a0,92 <cwtest+0x92>
      
      exit(-1);
  36:	557d                	li	a0,-1
  38:	00000097          	auipc	ra,0x0
  3c:	312080e7          	jalr	786(ra) # 34a <exit>
    printf("sbrk(%d) failed\n", sz);
  40:	020005b7          	lui	a1,0x2000
  44:	00001517          	auipc	a0,0x1
  48:	82450513          	addi	a0,a0,-2012 # 868 <malloc+0xec>
  4c:	00000097          	auipc	ra,0x0
  50:	678080e7          	jalr	1656(ra) # 6c4 <printf>
    exit(-1);
  54:	557d                	li	a0,-1
  56:	00000097          	auipc	ra,0x0
  5a:	2f4080e7          	jalr	756(ra) # 34a <exit>
    printf("fork failed\n");
  5e:	00001517          	auipc	a0,0x1
  62:	82250513          	addi	a0,a0,-2014 # 880 <malloc+0x104>
  66:	00000097          	auipc	ra,0x0
  6a:	65e080e7          	jalr	1630(ra) # 6c4 <printf>
    exit(-1);
  6e:	557d                	li	a0,-1
  70:	00000097          	auipc	ra,0x0
  74:	2da080e7          	jalr	730(ra) # 34a <exit>
      printf("fork failed");
  78:	00001517          	auipc	a0,0x1
  7c:	81850513          	addi	a0,a0,-2024 # 890 <malloc+0x114>
  80:	00000097          	auipc	ra,0x0
  84:	644080e7          	jalr	1604(ra) # 6c4 <printf>
      exit(-1);
  88:	557d                	li	a0,-1
  8a:	00000097          	auipc	ra,0x0
  8e:	2c0080e7          	jalr	704(ra) # 34a <exit>
    }
   
    exit(0);
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	2b6080e7          	jalr	694(ra) # 34a <exit>
  }

  
  printf("ok\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	80450513          	addi	a0,a0,-2044 # 8a0 <malloc+0x124>
  a4:	00000097          	auipc	ra,0x0
  a8:	620080e7          	jalr	1568(ra) # 6c4 <printf>
}
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <main>:


int
main(int argc, char *argv[])
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16

  cwtest();
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <cwtest>
 

  printf(" COW TEST PASSED\n");
  c4:	00000517          	auipc	a0,0x0
  c8:	7e450513          	addi	a0,a0,2020 # 8a8 <malloc+0x12c>
  cc:	00000097          	auipc	ra,0x0
  d0:	5f8080e7          	jalr	1528(ra) # 6c4 <printf>

  exit(0);
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	274080e7          	jalr	628(ra) # 34a <exit>

00000000000000de <strcpy>:
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  e4:	87aa                	mv	a5,a0
  e6:	0585                	addi	a1,a1,1 # 2000001 <__global_pointer$+0x1ffeed0>
  e8:	0785                	addi	a5,a5,1
  ea:	fff5c703          	lbu	a4,-1(a1)
  ee:	fee78fa3          	sb	a4,-1(a5)
  f2:	fb75                	bnez	a4,e6 <strcpy+0x8>
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strcmp>:
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
 100:	00054783          	lbu	a5,0(a0)
 104:	cb91                	beqz	a5,118 <strcmp+0x1e>
 106:	0005c703          	lbu	a4,0(a1)
 10a:	00f71763          	bne	a4,a5,118 <strcmp+0x1e>
 10e:	0505                	addi	a0,a0,1
 110:	0585                	addi	a1,a1,1
 112:	00054783          	lbu	a5,0(a0)
 116:	fbe5                	bnez	a5,106 <strcmp+0xc>
 118:	0005c503          	lbu	a0,0(a1)
 11c:	40a7853b          	subw	a0,a5,a0
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
 12c:	00054783          	lbu	a5,0(a0)
 130:	cf91                	beqz	a5,14c <strlen+0x26>
 132:	0505                	addi	a0,a0,1
 134:	87aa                	mv	a5,a0
 136:	4685                	li	a3,1
 138:	9e89                	subw	a3,a3,a0
 13a:	00f6853b          	addw	a0,a3,a5
 13e:	0785                	addi	a5,a5,1
 140:	fff7c703          	lbu	a4,-1(a5)
 144:	fb7d                	bnez	a4,13a <strlen+0x14>
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
 14c:	4501                	li	a0,0
 14e:	bfe5                	j	146 <strlen+0x20>

0000000000000150 <memset>:
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
 156:	ca19                	beqz	a2,16c <memset+0x1c>
 158:	87aa                	mv	a5,a0
 15a:	1602                	slli	a2,a2,0x20
 15c:	9201                	srli	a2,a2,0x20
 15e:	00a60733          	add	a4,a2,a0
 162:	00b78023          	sb	a1,0(a5)
 166:	0785                	addi	a5,a5,1
 168:	fee79de3          	bne	a5,a4,162 <memset+0x12>
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strchr>:
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
 178:	00054783          	lbu	a5,0(a0)
 17c:	cb99                	beqz	a5,192 <strchr+0x20>
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1a>
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xc>
 18a:	4501                	li	a0,0
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
 192:	4501                	li	a0,0
 194:	bfe5                	j	18c <strchr+0x1a>

0000000000000196 <gets>:
 196:	711d                	addi	sp,sp,-96
 198:	ec86                	sd	ra,88(sp)
 19a:	e8a2                	sd	s0,80(sp)
 19c:	e4a6                	sd	s1,72(sp)
 19e:	e0ca                	sd	s2,64(sp)
 1a0:	fc4e                	sd	s3,56(sp)
 1a2:	f852                	sd	s4,48(sp)
 1a4:	f456                	sd	s5,40(sp)
 1a6:	f05a                	sd	s6,32(sp)
 1a8:	ec5e                	sd	s7,24(sp)
 1aa:	1080                	addi	s0,sp,96
 1ac:	8baa                	mv	s7,a0
 1ae:	8a2e                	mv	s4,a1
 1b0:	892a                	mv	s2,a0
 1b2:	4481                	li	s1,0
 1b4:	4aa9                	li	s5,10
 1b6:	4b35                	li	s6,13
 1b8:	89a6                	mv	s3,s1
 1ba:	2485                	addiw	s1,s1,1
 1bc:	0344d863          	bge	s1,s4,1ec <gets+0x56>
 1c0:	4605                	li	a2,1
 1c2:	faf40593          	addi	a1,s0,-81
 1c6:	4501                	li	a0,0
 1c8:	00000097          	auipc	ra,0x0
 1cc:	19a080e7          	jalr	410(ra) # 362 <read>
 1d0:	00a05e63          	blez	a0,1ec <gets+0x56>
 1d4:	faf44783          	lbu	a5,-81(s0)
 1d8:	00f90023          	sb	a5,0(s2)
 1dc:	01578763          	beq	a5,s5,1ea <gets+0x54>
 1e0:	0905                	addi	s2,s2,1
 1e2:	fd679be3          	bne	a5,s6,1b8 <gets+0x22>
 1e6:	89a6                	mv	s3,s1
 1e8:	a011                	j	1ec <gets+0x56>
 1ea:	89a6                	mv	s3,s1
 1ec:	99de                	add	s3,s3,s7
 1ee:	00098023          	sb	zero,0(s3)
 1f2:	855e                	mv	a0,s7
 1f4:	60e6                	ld	ra,88(sp)
 1f6:	6446                	ld	s0,80(sp)
 1f8:	64a6                	ld	s1,72(sp)
 1fa:	6906                	ld	s2,64(sp)
 1fc:	79e2                	ld	s3,56(sp)
 1fe:	7a42                	ld	s4,48(sp)
 200:	7aa2                	ld	s5,40(sp)
 202:	7b02                	ld	s6,32(sp)
 204:	6be2                	ld	s7,24(sp)
 206:	6125                	addi	sp,sp,96
 208:	8082                	ret

000000000000020a <stat>:
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	e426                	sd	s1,8(sp)
 212:	e04a                	sd	s2,0(sp)
 214:	1000                	addi	s0,sp,32
 216:	892e                	mv	s2,a1
 218:	4581                	li	a1,0
 21a:	00000097          	auipc	ra,0x0
 21e:	170080e7          	jalr	368(ra) # 38a <open>
 222:	02054563          	bltz	a0,24c <stat+0x42>
 226:	84aa                	mv	s1,a0
 228:	85ca                	mv	a1,s2
 22a:	00000097          	auipc	ra,0x0
 22e:	178080e7          	jalr	376(ra) # 3a2 <fstat>
 232:	892a                	mv	s2,a0
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	13c080e7          	jalr	316(ra) # 372 <close>
 23e:	854a                	mv	a0,s2
 240:	60e2                	ld	ra,24(sp)
 242:	6442                	ld	s0,16(sp)
 244:	64a2                	ld	s1,8(sp)
 246:	6902                	ld	s2,0(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret
 24c:	597d                	li	s2,-1
 24e:	bfc5                	j	23e <stat+0x34>

0000000000000250 <atoi>:
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
 256:	00054683          	lbu	a3,0(a0)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	4625                	li	a2,9
 264:	02f66863          	bltu	a2,a5,294 <atoi+0x44>
 268:	872a                	mv	a4,a0
 26a:	4501                	li	a0,0
 26c:	0705                	addi	a4,a4,1
 26e:	0025179b          	slliw	a5,a0,0x2
 272:	9fa9                	addw	a5,a5,a0
 274:	0017979b          	slliw	a5,a5,0x1
 278:	9fb5                	addw	a5,a5,a3
 27a:	fd07851b          	addiw	a0,a5,-48
 27e:	00074683          	lbu	a3,0(a4)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	fef671e3          	bgeu	a2,a5,26c <atoi+0x1c>
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <atoi+0x3e>

0000000000000298 <memmove>:
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
 29e:	02b57463          	bgeu	a0,a1,2c6 <memmove+0x2e>
 2a2:	00c05f63          	blez	a2,2c0 <memmove+0x28>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c507b3          	add	a5,a0,a2
 2ae:	872a                	mv	a4,a0
 2b0:	0585                	addi	a1,a1,1
 2b2:	0705                	addi	a4,a4,1
 2b4:	fff5c683          	lbu	a3,-1(a1)
 2b8:	fed70fa3          	sb	a3,-1(a4)
 2bc:	fee79ae3          	bne	a5,a4,2b0 <memmove+0x18>
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
 2c6:	00c50733          	add	a4,a0,a2
 2ca:	95b2                	add	a1,a1,a2
 2cc:	fec05ae3          	blez	a2,2c0 <memmove+0x28>
 2d0:	fff6079b          	addiw	a5,a2,-1
 2d4:	1782                	slli	a5,a5,0x20
 2d6:	9381                	srli	a5,a5,0x20
 2d8:	fff7c793          	not	a5,a5
 2dc:	97ba                	add	a5,a5,a4
 2de:	15fd                	addi	a1,a1,-1
 2e0:	177d                	addi	a4,a4,-1
 2e2:	0005c683          	lbu	a3,0(a1)
 2e6:	00d70023          	sb	a3,0(a4)
 2ea:	fee79ae3          	bne	a5,a4,2de <memmove+0x46>
 2ee:	bfc9                	j	2c0 <memmove+0x28>

00000000000002f0 <memcmp>:
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
 2f6:	ca05                	beqz	a2,326 <memcmp+0x36>
 2f8:	fff6069b          	addiw	a3,a2,-1
 2fc:	1682                	slli	a3,a3,0x20
 2fe:	9281                	srli	a3,a3,0x20
 300:	0685                	addi	a3,a3,1
 302:	96aa                	add	a3,a3,a0
 304:	00054783          	lbu	a5,0(a0)
 308:	0005c703          	lbu	a4,0(a1)
 30c:	00e79863          	bne	a5,a4,31c <memcmp+0x2c>
 310:	0505                	addi	a0,a0,1
 312:	0585                	addi	a1,a1,1
 314:	fed518e3          	bne	a0,a3,304 <memcmp+0x14>
 318:	4501                	li	a0,0
 31a:	a019                	j	320 <memcmp+0x30>
 31c:	40e7853b          	subw	a0,a5,a4
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <memcmp+0x30>

000000000000032a <memcpy>:
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
 332:	00000097          	auipc	ra,0x0
 336:	f66080e7          	jalr	-154(ra) # 298 <memmove>
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <fork>:
 342:	4885                	li	a7,1
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <exit>:
 34a:	4889                	li	a7,2
 34c:	00000073          	ecall
 350:	8082                	ret

0000000000000352 <wait>:
 352:	488d                	li	a7,3
 354:	00000073          	ecall
 358:	8082                	ret

000000000000035a <pipe>:
 35a:	4891                	li	a7,4
 35c:	00000073          	ecall
 360:	8082                	ret

0000000000000362 <read>:
 362:	4895                	li	a7,5
 364:	00000073          	ecall
 368:	8082                	ret

000000000000036a <write>:
 36a:	48c1                	li	a7,16
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <close>:
 372:	48d5                	li	a7,21
 374:	00000073          	ecall
 378:	8082                	ret

000000000000037a <kill>:
 37a:	4899                	li	a7,6
 37c:	00000073          	ecall
 380:	8082                	ret

0000000000000382 <exec>:
 382:	489d                	li	a7,7
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <open>:
 38a:	48bd                	li	a7,15
 38c:	00000073          	ecall
 390:	8082                	ret

0000000000000392 <mknod>:
 392:	48c5                	li	a7,17
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <unlink>:
 39a:	48c9                	li	a7,18
 39c:	00000073          	ecall
 3a0:	8082                	ret

00000000000003a2 <fstat>:
 3a2:	48a1                	li	a7,8
 3a4:	00000073          	ecall
 3a8:	8082                	ret

00000000000003aa <link>:
 3aa:	48cd                	li	a7,19
 3ac:	00000073          	ecall
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
 3b2:	48d1                	li	a7,20
 3b4:	00000073          	ecall
 3b8:	8082                	ret

00000000000003ba <chdir>:
 3ba:	48a5                	li	a7,9
 3bc:	00000073          	ecall
 3c0:	8082                	ret

00000000000003c2 <dup>:
 3c2:	48a9                	li	a7,10
 3c4:	00000073          	ecall
 3c8:	8082                	ret

00000000000003ca <getpid>:
 3ca:	48ad                	li	a7,11
 3cc:	00000073          	ecall
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
 3d2:	48b1                	li	a7,12
 3d4:	00000073          	ecall
 3d8:	8082                	ret

00000000000003da <sleep>:
 3da:	48b5                	li	a7,13
 3dc:	00000073          	ecall
 3e0:	8082                	ret

00000000000003e2 <uptime>:
 3e2:	48b9                	li	a7,14
 3e4:	00000073          	ecall
 3e8:	8082                	ret

00000000000003ea <putc>:
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	f6e080e7          	jalr	-146(ra) # 36a <write>
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	f04a                	sd	s2,32(sp)
 416:	ec4e                	sd	s3,24(sp)
 418:	0080                	addi	s0,sp,64
 41a:	84aa                	mv	s1,a0
 41c:	c299                	beqz	a3,422 <printint+0x16>
 41e:	0805c963          	bltz	a1,4b0 <printint+0xa4>
 422:	2581                	sext.w	a1,a1
 424:	4881                	li	a7,0
 426:	fc040693          	addi	a3,s0,-64
 42a:	4701                	li	a4,0
 42c:	2601                	sext.w	a2,a2
 42e:	00000517          	auipc	a0,0x0
 432:	4f250513          	addi	a0,a0,1266 # 920 <digits>
 436:	883a                	mv	a6,a4
 438:	2705                	addiw	a4,a4,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f68023          	sb	a5,0(a3)
 44c:	0005879b          	sext.w	a5,a1
 450:	02c5d5bb          	divuw	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f0e3          	bgeu	a5,a2,436 <printint+0x2a>
 45a:	00088c63          	beqz	a7,472 <printint+0x66>
 45e:	fd070793          	addi	a5,a4,-48
 462:	00878733          	add	a4,a5,s0
 466:	02d00793          	li	a5,45
 46a:	fef70823          	sb	a5,-16(a4)
 46e:	0028071b          	addiw	a4,a6,2
 472:	02e05863          	blez	a4,4a2 <printint+0x96>
 476:	fc040793          	addi	a5,s0,-64
 47a:	00e78933          	add	s2,a5,a4
 47e:	fff78993          	addi	s3,a5,-1
 482:	99ba                	add	s3,s3,a4
 484:	377d                	addiw	a4,a4,-1
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
 48e:	fff94583          	lbu	a1,-1(s2)
 492:	8526                	mv	a0,s1
 494:	00000097          	auipc	ra,0x0
 498:	f56080e7          	jalr	-170(ra) # 3ea <putc>
 49c:	197d                	addi	s2,s2,-1
 49e:	ff3918e3          	bne	s2,s3,48e <printint+0x82>
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	7902                	ld	s2,32(sp)
 4aa:	69e2                	ld	s3,24(sp)
 4ac:	6121                	addi	sp,sp,64
 4ae:	8082                	ret
 4b0:	40b005bb          	negw	a1,a1
 4b4:	4885                	li	a7,1
 4b6:	bf85                	j	426 <printint+0x1a>

00000000000004b8 <vprintf>:
 4b8:	7119                	addi	sp,sp,-128
 4ba:	fc86                	sd	ra,120(sp)
 4bc:	f8a2                	sd	s0,112(sp)
 4be:	f4a6                	sd	s1,104(sp)
 4c0:	f0ca                	sd	s2,96(sp)
 4c2:	ecce                	sd	s3,88(sp)
 4c4:	e8d2                	sd	s4,80(sp)
 4c6:	e4d6                	sd	s5,72(sp)
 4c8:	e0da                	sd	s6,64(sp)
 4ca:	fc5e                	sd	s7,56(sp)
 4cc:	f862                	sd	s8,48(sp)
 4ce:	f466                	sd	s9,40(sp)
 4d0:	f06a                	sd	s10,32(sp)
 4d2:	ec6e                	sd	s11,24(sp)
 4d4:	0100                	addi	s0,sp,128
 4d6:	0005c903          	lbu	s2,0(a1)
 4da:	18090f63          	beqz	s2,678 <vprintf+0x1c0>
 4de:	8aaa                	mv	s5,a0
 4e0:	8b32                	mv	s6,a2
 4e2:	00158493          	addi	s1,a1,1
 4e6:	4981                	li	s3,0
 4e8:	02500a13          	li	s4,37
 4ec:	4c55                	li	s8,21
 4ee:	00000c97          	auipc	s9,0x0
 4f2:	3dac8c93          	addi	s9,s9,986 # 8c8 <malloc+0x14c>
 4f6:	02800d93          	li	s11,40
 4fa:	4d41                	li	s10,16
 4fc:	00000b97          	auipc	s7,0x0
 500:	424b8b93          	addi	s7,s7,1060 # 920 <digits>
 504:	a839                	j	522 <vprintf+0x6a>
 506:	85ca                	mv	a1,s2
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ee0080e7          	jalr	-288(ra) # 3ea <putc>
 512:	a019                	j	518 <vprintf+0x60>
 514:	01498d63          	beq	s3,s4,52e <vprintf+0x76>
 518:	0485                	addi	s1,s1,1
 51a:	fff4c903          	lbu	s2,-1(s1)
 51e:	14090d63          	beqz	s2,678 <vprintf+0x1c0>
 522:	fe0999e3          	bnez	s3,514 <vprintf+0x5c>
 526:	ff4910e3          	bne	s2,s4,506 <vprintf+0x4e>
 52a:	89d2                	mv	s3,s4
 52c:	b7f5                	j	518 <vprintf+0x60>
 52e:	11490c63          	beq	s2,s4,646 <vprintf+0x18e>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f793          	zext.b	a5,a5
 53a:	10fc6e63          	bltu	s8,a5,656 <vprintf+0x19e>
 53e:	f9d9079b          	addiw	a5,s2,-99
 542:	0ff7f713          	zext.b	a4,a5
 546:	10ec6863          	bltu	s8,a4,656 <vprintf+0x19e>
 54a:	00271793          	slli	a5,a4,0x2
 54e:	97e6                	add	a5,a5,s9
 550:	439c                	lw	a5,0(a5)
 552:	97e6                	add	a5,a5,s9
 554:	8782                	jr	a5
 556:	008b0913          	addi	s2,s6,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000b2583          	lw	a1,0(s6)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	ea8080e7          	jalr	-344(ra) # 40c <printint>
 56c:	8b4a                	mv	s6,s2
 56e:	4981                	li	s3,0
 570:	b765                	j	518 <vprintf+0x60>
 572:	008b0913          	addi	s2,s6,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000b2583          	lw	a1,0(s6)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e8c080e7          	jalr	-372(ra) # 40c <printint>
 588:	8b4a                	mv	s6,s2
 58a:	4981                	li	s3,0
 58c:	b771                	j	518 <vprintf+0x60>
 58e:	008b0913          	addi	s2,s6,8
 592:	4681                	li	a3,0
 594:	866a                	mv	a2,s10
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e70080e7          	jalr	-400(ra) # 40c <printint>
 5a4:	8b4a                	mv	s6,s2
 5a6:	4981                	li	s3,0
 5a8:	bf85                	j	518 <vprintf+0x60>
 5aa:	008b0793          	addi	a5,s6,8
 5ae:	f8f43423          	sd	a5,-120(s0)
 5b2:	000b3983          	ld	s3,0(s6)
 5b6:	03000593          	li	a1,48
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e2e080e7          	jalr	-466(ra) # 3ea <putc>
 5c4:	07800593          	li	a1,120
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e20080e7          	jalr	-480(ra) # 3ea <putc>
 5d2:	896a                	mv	s2,s10
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e0a080e7          	jalr	-502(ra) # 3ea <putc>
 5e8:	0992                	slli	s3,s3,0x4
 5ea:	397d                	addiw	s2,s2,-1
 5ec:	fe0914e3          	bnez	s2,5d4 <vprintf+0x11c>
 5f0:	f8843b03          	ld	s6,-120(s0)
 5f4:	4981                	li	s3,0
 5f6:	b70d                	j	518 <vprintf+0x60>
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	000b3983          	ld	s3,0(s6)
 600:	02098163          	beqz	s3,622 <vprintf+0x16a>
 604:	0009c583          	lbu	a1,0(s3)
 608:	c5ad                	beqz	a1,672 <vprintf+0x1ba>
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dde080e7          	jalr	-546(ra) # 3ea <putc>
 614:	0985                	addi	s3,s3,1
 616:	0009c583          	lbu	a1,0(s3)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x152>
 61c:	8b4a                	mv	s6,s2
 61e:	4981                	li	s3,0
 620:	bde5                	j	518 <vprintf+0x60>
 622:	00000997          	auipc	s3,0x0
 626:	29e98993          	addi	s3,s3,670 # 8c0 <malloc+0x144>
 62a:	85ee                	mv	a1,s11
 62c:	bff9                	j	60a <vprintf+0x152>
 62e:	008b0913          	addi	s2,s6,8
 632:	000b4583          	lbu	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	db2080e7          	jalr	-590(ra) # 3ea <putc>
 640:	8b4a                	mv	s6,s2
 642:	4981                	li	s3,0
 644:	bdd1                	j	518 <vprintf+0x60>
 646:	85d2                	mv	a1,s4
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	da0080e7          	jalr	-608(ra) # 3ea <putc>
 652:	4981                	li	s3,0
 654:	b5d1                	j	518 <vprintf+0x60>
 656:	85d2                	mv	a1,s4
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d90080e7          	jalr	-624(ra) # 3ea <putc>
 662:	85ca                	mv	a1,s2
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	d84080e7          	jalr	-636(ra) # 3ea <putc>
 66e:	4981                	li	s3,0
 670:	b565                	j	518 <vprintf+0x60>
 672:	8b4a                	mv	s6,s2
 674:	4981                	li	s3,0
 676:	b54d                	j	518 <vprintf+0x60>
 678:	70e6                	ld	ra,120(sp)
 67a:	7446                	ld	s0,112(sp)
 67c:	74a6                	ld	s1,104(sp)
 67e:	7906                	ld	s2,96(sp)
 680:	69e6                	ld	s3,88(sp)
 682:	6a46                	ld	s4,80(sp)
 684:	6aa6                	ld	s5,72(sp)
 686:	6b06                	ld	s6,64(sp)
 688:	7be2                	ld	s7,56(sp)
 68a:	7c42                	ld	s8,48(sp)
 68c:	7ca2                	ld	s9,40(sp)
 68e:	7d02                	ld	s10,32(sp)
 690:	6de2                	ld	s11,24(sp)
 692:	6109                	addi	sp,sp,128
 694:	8082                	ret

0000000000000696 <fprintf>:
 696:	715d                	addi	sp,sp,-80
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e010                	sd	a2,0(s0)
 6a0:	e414                	sd	a3,8(s0)
 6a2:	e818                	sd	a4,16(s0)
 6a4:	ec1c                	sd	a5,24(s0)
 6a6:	03043023          	sd	a6,32(s0)
 6aa:	03143423          	sd	a7,40(s0)
 6ae:	fe843423          	sd	s0,-24(s0)
 6b2:	8622                	mv	a2,s0
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e04080e7          	jalr	-508(ra) # 4b8 <vprintf>
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6161                	addi	sp,sp,80
 6c2:	8082                	ret

00000000000006c4 <printf>:
 6c4:	711d                	addi	sp,sp,-96
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e40c                	sd	a1,8(s0)
 6ce:	e810                	sd	a2,16(s0)
 6d0:	ec14                	sd	a3,24(s0)
 6d2:	f018                	sd	a4,32(s0)
 6d4:	f41c                	sd	a5,40(s0)
 6d6:	03043823          	sd	a6,48(s0)
 6da:	03143c23          	sd	a7,56(s0)
 6de:	00840613          	addi	a2,s0,8
 6e2:	fec43423          	sd	a2,-24(s0)
 6e6:	85aa                	mv	a1,a0
 6e8:	4505                	li	a0,1
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dce080e7          	jalr	-562(ra) # 4b8 <vprintf>
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret

00000000000006fa <free>:
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e422                	sd	s0,8(sp)
 6fe:	0800                	addi	s0,sp,16
 700:	ff050693          	addi	a3,a0,-16
 704:	00000797          	auipc	a5,0x0
 708:	2347b783          	ld	a5,564(a5) # 938 <freep>
 70c:	a02d                	j	736 <free+0x3c>
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x5e>
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x72>
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3a>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4a>
 734:	87ba                	mv	a5,a4
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x30>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4a>
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3a>
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x14>
 758:	fec53823          	sd	a2,-16(a0)
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x22>
 76c:	e394                	sd	a3,0(a5)
 76e:	00000717          	auipc	a4,0x0
 772:	1cf73523          	sd	a5,458(a4) # 938 <freep>
 776:	6422                	ld	s0,8(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <malloc>:
 77c:	7139                	addi	sp,sp,-64
 77e:	fc06                	sd	ra,56(sp)
 780:	f822                	sd	s0,48(sp)
 782:	f426                	sd	s1,40(sp)
 784:	f04a                	sd	s2,32(sp)
 786:	ec4e                	sd	s3,24(sp)
 788:	e852                	sd	s4,16(sp)
 78a:	e456                	sd	s5,8(sp)
 78c:	e05a                	sd	s6,0(sp)
 78e:	0080                	addi	s0,sp,64
 790:	02051493          	slli	s1,a0,0x20
 794:	9081                	srli	s1,s1,0x20
 796:	04bd                	addi	s1,s1,15
 798:	8091                	srli	s1,s1,0x4
 79a:	0014899b          	addiw	s3,s1,1
 79e:	0485                	addi	s1,s1,1
 7a0:	00000517          	auipc	a0,0x0
 7a4:	19853503          	ld	a0,408(a0) # 938 <freep>
 7a8:	c515                	beqz	a0,7d4 <malloc+0x58>
 7aa:	611c                	ld	a5,0(a0)
 7ac:	4798                	lw	a4,8(a5)
 7ae:	02977f63          	bgeu	a4,s1,7ec <malloc+0x70>
 7b2:	8a4e                	mv	s4,s3
 7b4:	0009871b          	sext.w	a4,s3
 7b8:	6685                	lui	a3,0x1
 7ba:	00d77363          	bgeu	a4,a3,7c0 <malloc+0x44>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
 7c4:	004a1a1b          	slliw	s4,s4,0x4
 7c8:	00000917          	auipc	s2,0x0
 7cc:	17090913          	addi	s2,s2,368 # 938 <freep>
 7d0:	5afd                	li	s5,-1
 7d2:	a895                	j	846 <malloc+0xca>
 7d4:	00000797          	auipc	a5,0x0
 7d8:	16c78793          	addi	a5,a5,364 # 940 <base>
 7dc:	00000717          	auipc	a4,0x0
 7e0:	14f73e23          	sd	a5,348(a4) # 938 <freep>
 7e4:	e39c                	sd	a5,0(a5)
 7e6:	0007a423          	sw	zero,8(a5)
 7ea:	b7e1                	j	7b2 <malloc+0x36>
 7ec:	02e48c63          	beq	s1,a4,824 <malloc+0xa8>
 7f0:	4137073b          	subw	a4,a4,s3
 7f4:	c798                	sw	a4,8(a5)
 7f6:	02071693          	slli	a3,a4,0x20
 7fa:	01c6d713          	srli	a4,a3,0x1c
 7fe:	97ba                	add	a5,a5,a4
 800:	0137a423          	sw	s3,8(a5)
 804:	00000717          	auipc	a4,0x0
 808:	12a73a23          	sd	a0,308(a4) # 938 <freep>
 80c:	01078513          	addi	a0,a5,16
 810:	70e2                	ld	ra,56(sp)
 812:	7442                	ld	s0,48(sp)
 814:	74a2                	ld	s1,40(sp)
 816:	7902                	ld	s2,32(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
 820:	6121                	addi	sp,sp,64
 822:	8082                	ret
 824:	6398                	ld	a4,0(a5)
 826:	e118                	sd	a4,0(a0)
 828:	bff1                	j	804 <malloc+0x88>
 82a:	01652423          	sw	s6,8(a0)
 82e:	0541                	addi	a0,a0,16
 830:	00000097          	auipc	ra,0x0
 834:	eca080e7          	jalr	-310(ra) # 6fa <free>
 838:	00093503          	ld	a0,0(s2)
 83c:	d971                	beqz	a0,810 <malloc+0x94>
 83e:	611c                	ld	a5,0(a0)
 840:	4798                	lw	a4,8(a5)
 842:	fa9775e3          	bgeu	a4,s1,7ec <malloc+0x70>
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0xc2>
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	b80080e7          	jalr	-1152(ra) # 3d2 <sbrk>
 85a:	fd5518e3          	bne	a0,s5,82a <malloc+0xae>
 85e:	4501                	li	a0,0
 860:	bf45                	j	810 <malloc+0x94>
