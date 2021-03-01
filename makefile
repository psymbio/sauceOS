main.bin:main.asm read_disk.asm printf.asm printh.asm testa20.asm gdt.asm print_string_pm.asm switch_to_pm.asm
	nasm -fbin main.asm -o main.bin
clean:
	rm main.bin
run:
	qemu-system-x86_64 main.bin
