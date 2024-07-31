; 화면에 "I Love macOS"를 출력하는 어셈블리 프로그램
; - write(1, msg, msg_length) 시스템 호출 화면 출력
; - 64-bit ARM 에서 실행
; - The `.cfi_*` directives are used for debugging and exception handling to provide information about the stack frame layout.
;
; 프로그램 시작
  .section	__TEXT,__text,regular,pure_instructions
    ; "specifies" a new section in the binary.
    ; `__TEXT` is the segment usually contains executable code.
    ; `__text` is the main section within the `__TEXT` segment.
    ; `regular` indicates a standard section
    ; `pure_instructions` indicates that this section contains only executable instructions.
    ; typically used in Mach-O binaries (the format used on macOS)

  .build_version macos, 14, 0	sdk_version 14, 5
    ; "provides" build version information for the current binary.
    ; `macos, 14, 0` specifies that the binary is intended to run on macOS 14.0
    ; `sdk_version 14, 5` specifies taht the binary was built using the Software Development Kit version 14.5
  .globl _main                    ; "declare" the `_main` symbol as global.
                                  ; these are can be acceccssed from any other source file
	.p2align	2                     ; power-of-2 alignment
_main:
  ; ================================================
  ; Function Prologue
  ; ================================================
	.cfi_startproc                  ; start procedure for Call Frame Info.

	sub	sp, sp, #32                 ; "subtracts" 32bytes from stack pointer.
	                                ; (to allocate 32bytes on the stack)

	.cfi_def_cfa_offset 32          ; "defines" the Canonical Frame Address.
	                                ; (the new stack frame starts 32bytes below the current stack pointer)

	stp	x29, x30, [sp, #16]         ; "stores" the frame pointer (`x29`) and the link register (`x30` which holds the return address) at the memory address `sp + 16`.
	                                ; 16-byte Folded Spill

	add	x29, sp, #16                ; "sets up" the new frame pointer ('x29') to be 'sp + 16'.

	.cfi_def_cfa w29, 16            ; "updates" the CFA to use `w29` (the lower 32 bits of `x29`) with an offset of 16 bytes.
	.cfi_offset w30, -8             ; "specifies" that the saved link register is at offset -8 from the CFA.
	.cfi_offset w29, -16            ; "specifies" that the saved frame pointer is at offset -16 from the CFA.

  ; ================================================
  ; Function Body
  ; ================================================
	mov	w8, #0                      ; "move" value 0 into w8.
	str	w8, [sp, #8]                ; "stores" the value of `w8` (which is `0`) into the memory address `sp + 8`.
	                                ; 4-byte Folded Spill

	stur	wzr, [x29, #-4]           ; "stores" the zero register `wzr` (which is always `0`) into the memory address `x29 - 4`.

  mov   w0,   #1                  ; 1 = stdout
  adrp  x1,         msg@PAGE      ; "loads" the page address of the `msg` string into register `x1`.
  add   x1,   x1,   msg@PAGEOFF   ; "adds" the page offset of the string `msg` to `x1, resulting in full address of the string being stored in `x1`.
  mov   x2,   #13                 ; 13 = str_length 
  ; ===[SYSCALL]===
  bl    _write                    ; "branches" to the _write function, effectively calling it with `w0`, `x1` and `x2` as arguments
  ; ===[  END  ]===
  ; ================================================
  ; Function Epilogue
  ; ================================================
  ldr   w0,  [sp, #8]             ; "loads" the value from `sp + 8` back into `w0`. This is a "Folded Reload".
  ldp   x29, x30, [sp, #16]       ; "restores" the frame pointer (`x29`) and link register (`x30`) from the stack.
  add sp, sp, #32                 ; "adds" 32bytes to the stack pointer.
                                  ; (to deallocate the stack frame)

  ret                             ; "returns" from the function, using the address in the link register (`x30`).
	.cfi_endproc                    ; start procedure for Call Frame Info
	.section	__TEXT,__cstring,cstring_literals

msg:
  .ascii "I Love macOS\n"

.subsections_via_symbols
  ; "allows" for finer granularity in code and data sections within a binary.
  ; This mean that linker can create subsections based on symbols, 
  ; which are typically function names or variable names.
  ; if some sections are not needed, linker can remove them from the binary.
