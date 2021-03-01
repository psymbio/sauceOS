checklm:
	pusha
	pushfd ; push EFLAGS to the stack
	pop eax ; pop EFLAGS from stack to EAX
	mov ecx, eax ; back up EAX in ECX



