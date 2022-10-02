/*
 * ex5.c
 *
 * Created: 9/23/2022 11:31:02 AM
 * Author: Hoang
 */

#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdlib.h>

#define BT1 PINB.2
#define BT2 PINB.3
#define BT3 PINB.0
#define BL PORTD.7
#define bam 0

int dem = 0;
char buf[6]; 

void main(void)
{
    DDRB = 0x00;
    PORTB = 0x0D;
    DDRD = 0x80;
    PORTD = 0x80;
    
    lcd_init(16);
    lcd_clear();
    lcd_gotoxy(1, 0);
    lcd_putsf("hello world");

    while (1)
        {
        // Please write your application code here
         
        }
}
