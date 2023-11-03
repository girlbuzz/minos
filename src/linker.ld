ENTRY(start)

SECTIONS {
	. = 1M;

	.boot :
	{
		. = ALIGN(8);
		KEEP(*(.multiboot_header))
	}

	.text :
	{
		*(.text)
	}

	.data :
	{
		*(.data*)
	}

	.rodata :
	{
		*(.rodata*)
	}

	.bss :
	{
		*(.bss)
	}
}
