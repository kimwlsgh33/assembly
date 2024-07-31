# 화면에 "I Love OS"를 출력하는 어셈블리 프로그램
# 64-bit Linux에서 실행
#
# 프로그램 시작

  .global _start
  .text
_start:
  # write(1, msg, 12) 시스템 호출 화면 출력
  mov   $1,   %rax    # 1: write 시스템 호출 번호, rax 레지스터에 저장
  mov   $1,   %rdi    # 1: 표준입력장치 file descriptor, rdi 레지스터에 저장
  mov   $msg, %rsi    # msg: 출력할 문자열 주소, rsi 레지스터에 저장
  mov   $12,  %rdx    # 12: 출력할 바이트 수, rdx 레지스터에 저장
  syscall             # 시스템 호출 기계명령
                      # 화면에 Hello world를 출력하는 write 시스템 호출 실행

  # exit(0) 시스템 호출 프로그램 종료
  mov   $60,  %rax    # 60: exit 시스템 호출 번호, rax 레지스터에 저장
  xor   %rdi, %rdi    # xor 명령후 rdi 레지스터 값을 0
  syscall             # 시스템 호출 기계명령
                      # 프로그램을 종료시키는 exit 시스템 호출 실행, 프로그램 종료

msg:
  .ascii "I Love OS\n"
