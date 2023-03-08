#include <mini_uart.h>

/* required for printf implementation */

void _putchar(char character)
{
	mini_uart_write_one_blocking(character);
}
