MEMORY
	{
	reset	: ORIGIN = 0x00000000,  LENGTH = 0x00000200
	vectors : ORIGIN = 0x00000200,  LENGTH = 0x00001E00
        ram     : ORIGIN = 0x000002000, LENGTH = 0x0000E000
	}

PROVIDE(_stack = 0x10000 - 4);

SECTIONS
{
	.reset :
        {
        *(.reset)
        } > reset

	.vectors :
        {
        _vec_start = .;
        *(.vectors)
        _vec_end = .;
        } > vectors

	.init :
	{
	*(.init)
	*(.fini)
	*(.ctors)
	*(.dtors)
	} > ram
 
        .text :
        {
        *(.text)
        } > ram

      .rodata :
        {
        *(.rodata)
        *(.rodata.*)
        } > ram
 
     .icm :
        {
        _icm_start = .;
        *(.icm)
        _icm_end = .;
        } > ram

     .data :
        {
        _dst_beg = .;
        *(.data)
        _dst_end = .;
        } > ram
 
      .bss :
        {
        *(.bss)
        } > ram
	_end = .;
}
