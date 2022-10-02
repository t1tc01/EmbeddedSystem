/*
 * ex3.c
 *
 * Created: 9/16/2022 10:10:04 AM
 * Author: Hoang
 */

/*Viet chuong trinh bam BTN_1 = PB2 thi den sang (PD4) tha BTN_1 thi den tat 
Phan tich: de MCU hieu duoc dong tac bam nut, ban dau chung ta phai Pull_up len logic = 1
MCU thu dong doc trang thai cua PB2  -> no phai la INPUT -> DDR (PB2) = 0

voi LED chung ta phai gan cho no gia tri ban dau = 0 de den TAT ( se so sanh lai voi bai toan dung den NOKIA)
De dieu khien duoc LED -> DDR tac dong vao LED = 1(DDRD.4 = 1)
*/

#include <io.h>
#include <alcd.h>
#include <delay.h>

#define den PORTD.4
#define button PINB.2
#define sang 1
#define toi 0
#define bam 0
#define nha 1
void main(void)
{
//DDR (PB2) = 0
DDRB = 0x00; //DDRB = 0b00000000;   vi tat ca cac bit nhan gia tri 0 nen B2 chac chan bang 0
//PORTB=0xFF; //pull up ca PORTB -> B2 kieu gi cung duoc Pull_up
PORTB=0x04; // PORTB = 0b 0000 0100;
DDRD=0x10;  // DDRD=0b 0001 0000; ?
PORTD=0x00; //De cho toan bo cac bit trong PORTD = 0 -> den o PORTD bit 2 cung = 0 -> tat 

while (1)
    {       
        //     
        if (button == bam) {
            delay_ms(250);
            den = ~den;
        }       
        
    }
}
