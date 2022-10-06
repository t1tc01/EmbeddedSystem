/*
 * bena.c
 *
 * Created: 10/2/2022 8:32:03 AM
 * Author: Hoang
 */

#include <io.h>
#include <delay.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define LEFT 4
#define DOWN 5
#define RIGHT 6
#define UP 2
#define MAX_WIDTH 84 
#define MAX_HEIGHT 48

// global var
int keypad[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};  
bool dl = false, dr = false, du = false, dd = false, isOff = false;
int x[500], y[500], i, slength, tempx = 0, tempy = 0, xx, yy, speed = 75;
int  score;
int xegg[2][2], yegg[2][2];
//



//


//matrix button processing
int BUTTON() {
    int result = -1; 
    char a;
    int i,j;
    for (j = 0; j < 3; j++) {  //Xet cot
        if (j == 0) PORTF = 0b11111101; //1111 1101, 
        if (j == 1) PORTF = 0b11110111; //1111 0111,
        if (j == 2) PORTF = 0b11011111; //1101 1111, 
        for (i = 0; i < 3; i++) { // Xet hang
            if (i == 0) {
                a = PINF&0x04;
                if (a != 0x04) {
                   result = keypad[i][j];
                }
            } 
            if (i == 1) {
               a = PINF&0x10;
               if (a != 0x10) {
                  result = keypad[i][j]; 
               }
            }
            
            if (i == 2) {
                a = PINF&0x01;
                if (a != 0x01) {
                   result = keypad[i][j];
                }
            }
        }
    }
    return result;
}

bool draw_egg() {
        glcd_clrpixel(xegg[0][0], yegg[0][0]);   
        glcd_clrpixel(xegg[0][1], yegg[0][1]);
        glcd_clrpixel(xegg[1][0], yegg[1][0]);
        glcd_clrpixel(xegg[1][1], yegg[1][1]);

        xegg[0][0] = rand() % 74 + 1;
        xegg[1][0] = xegg[0][0];
        xegg[0][1] = xegg[0][0] + 1; 
        xegg[1][1] = xegg[0][1];
        
        yegg[0][0] =  rand() % 40 + 1;
        yegg[0][1] =  yegg[0][0];
        yegg[1][0] =  yegg[0][0] + 1;
        yegg[1][1] =  yegg[1][0];
        
        glcd_setpixel(xegg[0][0], yegg[0][0]); 
        glcd_setpixel(xegg[0][1], yegg[0][1]);
        glcd_setpixel(xegg[1][0], yegg[1][0]);
        glcd_setpixel(xegg[1][1], yegg[1][1]);
        
        return true;
}

//
void check_egg() {
    
    //Xoa moi be neu ran an
    if (x[0] == xegg[0][0] && y[0] == yegg[0][0] || x[0] == xegg[0][1] && y[0] == yegg[0][1] || x[0] == xegg[1][0] && y[0] == yegg[1][0] || x[0] == xegg[1][1] && y[0] == yegg[1][1]){
        score += 1; 
        slength += 5; 
        draw_egg();   
    }             
}

//
void draw_snake()
{
   for (i = 0; i < slength; i++) {
      glcd_setpixel(x[i], y[i]);    
      glcd_clrpixel(tempx, tempy); 
   } 
}

//setup begin
void setup() {
    glcd_clear();
    slength = 5;
    score = 0;
   
    dr = true;
    dl = false;
    du = false;
    dd = false; 
    tempx = 0, tempy = 0;    
    
    for (i = 0; i < slength; i++)
    {
        x[i] = 10 + slength - i;
        y[i] = 10;
    }
   
    draw_egg();
         
}

//
void move_snake() {
    if (true) {
        bool isEnd = false;
        delay_ms(speed); 
        // auto move
        if (dr == true) {
            tempx = x[0] + 1;
            tempy = y[0];
        } 
        if (dl == true){
            tempx = x[0] - 1;
            tempy = y[0];
        }
        if (du == true){
            tempx = x[0];
            tempy = y[0] - 1;
        }
        if (dd == true){
            tempx = x[0];
            tempy = y[0] + 1;
        }
          
       
        for (i = 1; i < slength; i++) {
            if (x[i] == x[0] && y[i] == y[0]) {
                char score_c[1];
            
                score_c[0] = score + '0';
                glcd_clear();
                glcd_outtextxy(25,10,"END GAME!");
                glcd_outtextxy(1,20,"Score: "); 
                glcd_outtextxy(50,20,score_c);
    
                delay_ms(2000);
                isEnd = true;
                setup();               
            }  
        }
        check_egg();
        
        //
        if (tempx <= 0)
        {
            tempx = 84 + tempx;
        }
        if (tempx >= 84)
        {
            tempx = tempx - 84;
        }
        if (tempy <= 0)
        {
            tempy = 48 + tempy;
        }
        if (tempy >= 48)
        {
            tempy = tempy - 48;
        }     
        
        if (!isEnd) {
            for (i = 0; i < slength; i++)
                {
                    xx = x[i];
                    yy = y[i];
                    x[i] = tempx;
                    y[i] = tempy;
                    tempx = xx;
                    tempy = yy;
                }   
        }
        
        
        draw_snake();
        
    }
}



//
void direct(int phim) {
    if (phim == DOWN && (dr == true || dl == true)) 
    {   
        dr = false;
        dl = false;
        du = false;
        dd = true;
        tempx = x[0];
        tempy = y[0] + 1;
    }
    if (phim == UP && (dr == true || dl == true)) {   
        dr = false;
        dl = false;
        du = true;
        dd = false;
        tempx = x[0]; 
        tempy = y[0] - 1;
    }
    if (phim == LEFT && (dd == true || du == true)) {   
        dr = false;
        dl = true;
        du = false;
        dd = false;
        tempx = x[0]-1; 
        tempy = y[0];
    } 
    if (phim == RIGHT && (dd == true || du == true)) 
    {   
        dr = true;
        dl = false;
        du = false;
        dd = false;
        tempx = x[0] + 1; 
        tempy = y[0];
    }
}

void menu()
{   

    glcd_moveto(10,5);
    glcd_outtext("1.start game");
    glcd_moveto(10,15);
    glcd_outtext("2.option"); 
    glcd_moveto(10,25);
    glcd_outtext("3.quit");
    
    if(PINB.2 == 0){
        delay_ms(250);
        setup();
        while(1){
            int phim = BUTTON();   
            direct(phim);
            move_snake();
            if (PINB.0 == 0) {
              setup();
            }
            if (PINB.2 == 0) {
                delay_ms(250);  
                glcd_clear();
                break;
            }   
        }
    }
    
    if (PINB.3 == 0) {
        glcd_clear();
        delay_ms(250);
        while (true) {
            glcd_moveto(10,5);
            glcd_outtext("1.Easy");
            glcd_moveto(10,15);
            glcd_outtext("2.Hard"); 
            glcd_moveto(10,25);
            glcd_outtext("3.Asian");
            
            if (PINB.2 == 0) {
             delay_ms(250);
             speed = 75;
             break;
            } else if (PINB.3 == 0) {
                delay_ms(250);
                speed = 50;
                break;
            } else if (PINB.0 == 0) {
                delay_ms(250);
                speed = 25;
                break;
            } 
        }  
    }
    
    if(PINB.0 == 0) {
        delay_ms(250);
        glcd_display(isOff);
        isOff = ~isOff;
   } 
     
}


//main
void main(void)
{
GLCDINIT_t glcd_init_data;
glcd_init_data.font = font5x7;
glcd_init_data.readxmem=NULL;
glcd_init_data.writexmem=NULL;
glcd_init_data.temp_coef=120;
glcd_init_data.bias=4;
glcd_init_data.vlcd=40;
glcd_init(&glcd_init_data);

DDRD = 0xFF;
PORTD = 0xB6;
DDRF = 0b11101010;
PORTF = 0b00010101;

DDRB = 0x00;
PORTB=0x0D;
while (1)  
    {
       menu();
    }
}
