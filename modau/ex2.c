/*
 * ex2.c
 *
 * Created: 9/16/2022 9:36:53 AM
 * Author: Hoang
 */

#include <io.h>

void main(void)
{
DDRB = 0x00;
DDRD = 0x20;
PORTB=0x04;
while (1)
    {
    // Please write your application code here
           if (PINB.2 == 0) {
            PORTD = 0x20;
           } else {
            PORTD = 0x00;
           }
    }
}
