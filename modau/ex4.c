/*
 * ex4.c
 *
 * Created: 9/23/2022 10:51:26 AM
 * Author: Hoang
 */

#include <io.h>
#include <delay.h>

#define den0 PORTC.0
#define den2 PORTC.2
#define button PINB.2
#define sang 1
#define toi 0
#define bam 0
#define nha 1

void main(void)
{
DDRB = 0x04;
PORTB=0x04; // 0000 0100

DDRC=0x05;
PORTC=0x00;     

while (1)
    {
    // Please write your application code here
        if (button == bam) {
            delay_ms(250);
            den0 = ~den0;
            den2 = ~den2;
        }    
    }
}
