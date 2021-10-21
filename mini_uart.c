#include "mini_uart.h"

void writew(unsigned long reg, unsigned int val)
{
	*(volatile unsigned int *)reg = val;
}

unsigned int readw(unsigned long reg)
{
	return *(volatile unsigned int *) reg;
}

void mini_uart_init()
{
	unsigned int val;

	val = readw(GPFSEL1);
	val &= ~(7 << 12);
	val |= (2 << 12);
	val &= ~(7 << 15);
	val |= (2 << 15);
	writew(GPFSEL1, val);

	val = readw(GPIO_PUP_PDN_CNTRL_REG0);
	val &= ~(15 << 28);
	writew(GPIO_PUP_PDN_CNTRL_REG0, val);

	writew(AUX_ENABLES, 1);
	writew(AUX_MU_CNTL_REG, 0);
	writew(AUX_MU_IER_REG, 0);
	writew(AUX_MU_LCR_REG, 3);
	writew(AUX_MU_IIR_REG, 0xC6);
	writew(AUX_MU_MCR_REG, 0);
	writew(AUX_MU_BAUD_REG, CONVERT_BAUD(115200));

	writew(AUX_MU_CNTL_REG, 3);
}

void mini_uart_write_one_blocking(char c)
{
	while(!(readw(AUX_MU_LSR_REG) & 0x20))
		;
	writew(AUX_MU_IO_REG, (unsigned int) c);
}

char mini_uart_read_one_blocking()
{
	while(!(readw(AUX_MU_LSR_REG) & 0x01))
		;
	return (char)(readw(AUX_MU_IO_REG) & 0xff);
}

void mini_uart_write_string(char *str)
{
	for (int i = 0; str[i] != '\0'; i ++) {
		mini_uart_write_one_blocking((char)str[i]);
	}
}

void kernel_main()
{
	mini_uart_init();
	mini_uart_write_string("hello this is a line of text that you can hopefully see\r\n");
}
