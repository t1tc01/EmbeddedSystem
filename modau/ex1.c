/*
 * ex1.c
 *
 * Created: 9/9/2022 11:10:29 AM
 * Author: Hoang      
 
 Viet chuong trinh bat den led g- chan 30
 chan 30 -> D5 -> PORTD.5
 */

#include <io.h>
#include <delay.h>


void main(void)
{
//DDRD.6 = 1; // Tac dong thanh ghi DDR vao PORT D bit 5 gia tri (N=1) de quy uoc no la loi ra

//DDRD = 0x70;

while (1)
    {
    // Please write your application code here 
    /*
    PORTD.6 = 1;  //Bat den
    PORTD.5 = 1;    
    PORTD.4 = 1;
    */             
    DDRD = 0x70;
    PORTD = 0x70;                
    delay_ms(500);        
    PORTD = 0x20;
    delay_ms(100); 
    PORTD=0x40;
    delay_ms(500);         
    /*
    PORTD=0x00;
    delay_ms(500);
    */   
    }
}
