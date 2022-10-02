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
#define PAUSE false
#define BACKLIGHT A0
#define MAX_WIDTH 84 
#define MAX_HEIGHT 48
#define speakerPin A5

// global var
int keypad[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};  
bool dl = false, dr = false, du = false, dd = false;
int x[200], y[200], i, slength, tempx = 0, tempy = 0, xx, yy;
unsigned int  score, high;
int xegg , yegg;

//setup begin
void setup() {
    glcd_clear();
    slength = 5;
    score = 0;
    xegg = MAX_WIDTH / 2;
    yegg = MAX_HEIGHT / 2;
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
   
    glcd_setpixel(xegg, yegg); 
    
    
}

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


//
void check_egg() {
     if (x[0] == xegg && y[0] == yegg){
        score += 1; 
        slength += 3; 
        glcd_clrpixel(tempx, tempy);
        xegg = rand() % 85 + 1;
        yegg = rand() % 47 + 1;
        glcd_setpixel(xegg, yegg);
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

//
void move_snake() {
    if (!PAUSE) {
        bool isEnd = false;
        delay_ms(75); 
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
                delay_ms(500);
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
        tempx = x[0]; //Save the new coordinates of head in tempx,tempy
        tempy = y[0] + 1;
    }
    if (phim == UP && (dr == true || dl == true)) {   
        dr = false;
        dl = false;
        du = true;
        dd = false;
        tempx = x[0]; //Save the new coordinates of head in tempx,tempy
        tempy = y[0] - 1;
    }
    if (phim == LEFT && (dd == true || du == true)) {   
        dr = false;
        dl = true;
        du = false;
        dd = false;
        tempx = x[0]-1; //Save the new coordinates of head in tempx,tempy
        tempy = y[0];
    } 
    if (phim == RIGHT && (dd == true || du == true)) 
    {   
        dr = true;
        dl = false;
        du = false;
        dd = false;
        tempx = x[0] + 1; //Save the new coordinates of head in tempx,tempy
        tempy = y[0];
    }
}
//main
void main(void)
{
GLCDINIT_t glcd_init_data;
glcd_init_data.font = font5x7;
glcd_init_data.readxmem=NULL;
glcd_init_data.writexmem=NULL;
glcd_init_data.temp_coef=160;
glcd_init_data.bias=6;
glcd_init_data.vlcd=46;
glcd_init(&glcd_init_data);

DDRD = 0xFF;
PORTD = 0xB6;
DDRF = 0b11101010;
PORTF = 0b00010101;

setup();
while (1)
    {
        // Please write your application code here
        int phim = BUTTON();   
        direct(phim);
        move_snake();   
    }
}