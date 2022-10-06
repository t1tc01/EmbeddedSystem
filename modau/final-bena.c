/*
 * final-bena.c
 *
 * Created: 10/5/2022 3:11:33 PM
 * Author: Hoang
 */

#include <io.h>

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
#define MAX_WIDTH 84 
#define MAX_HEIGHT 48

int keypad[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};  
bool dl = false, dr = false, du = false, dd = false;
int x[2][200], y[2][200], slength,i;
int tempx0i = 0, tempy0i = 0, tempx0i2 = 0, tempy0i2 = 0, tempx1i = 0, tempy1i = 0, tempx1i2 = 0, tempy1i2 = 0;
int xx0i, yy0i, xx1i, yy1i;
unsigned int  score, high;
int xegg[2][2], yegg[2][2];

//
void draw_snake()
{
  for (i = 0; i < slength; i++) { 
    if (dl | dr) {
        glcd_setpixel(x[0][i],y[0][i]);
        glcd_setpixel(x[1][i],y[1][i]);
          
        glcd_clrpixel(tempx0i, tempy0i);
        glcd_clrpixel(tempx1i, tempy1i);     
    } else if (dd) {
        glcd_setpixel(x[0][i],y[0][i]);
        glcd_setpixel(x[1][i],y[1][i]);
          
        glcd_clrpixel(tempx0i, tempy0i);
        glcd_clrpixel(tempx1i2, tempy1i2);
    }
      
  } 
}

//
void setup() {
    glcd_clear();
    slength = 9;
    score = 0;
    dr = false;
    dl = false;
    du = false;
    dd = true; 
    tempx0i = 0, tempy0i = 0, tempx1i = 0, tempy1i = 0, tempx0i2 = 0, tempy0i2 = 0, tempx1i2 = 0, tempy1i2 = 0; 
    
    xegg[0][0] = rand() % 84 + 1;
    xegg[1][0] = xegg[0][0];
    xegg[0][1] = xegg[0][0] + 1; 
    xegg[1][1] = xegg[0][1];
    
    yegg[0][0] =  rand() % 36 + 1;
    yegg[0][1] =  yegg[0][0];
    yegg[1][0] =  yegg[0][0] + 1;
    yegg[1][1] =  yegg[1][0];
    
    //
    for (i = 0; i < slength; i++)
    {   
        x[0][i] = 20 + slength - i;
        y[0][i] = 10;
        
        x[1][i] = 20 + slength - i;
        y[1][i] = 11;
    }
    
    // 
    glcd_setpixel(xegg[0][0], yegg[0][0]); 
    glcd_setpixel(xegg[0][1], yegg[0][1]);
    glcd_setpixel(xegg[1][0], yegg[1][0]);
    glcd_setpixel(xegg[1][1], yegg[1][1]);   
    
    for (i = 0; i < slength; i++) {
      //glcd_setpixel(x[i], y[i]);    
      //glcd_clrpixel(tempx, tempy); 
      glcd_setpixel(x[0][i],y[0][i]);
      glcd_setpixel(x[1][i],y[1][i]);     
   } 
        
}

//
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

void move_snake() {
    if (!PAUSE) {
        bool isEnd = false;
        delay_ms(75); 
        // auto move
        if (dr == true) {
            tempx0i = x[0][0] + 1;
            tempy0i = y[0][0];
            
            tempx1i = x[1][0] + 1;
            tempy1i = y[1][0];
        } 
        if (dl == true){
            tempx0i = x[0][0] - 1;
            tempy0i = y[0][0];
            
            tempx1i = x[1][0] - 1;
            tempy1i = y[1][0];
        }
        if (du == true){
            tempx0i = x[0][0];
            tempy0i = y[0][0]-1;
            
            tempx0i2 = x[0][1];
            tempy0i2 = y[0][1]-1;
        }
        if (dd == true){
            tempx1i = x[1][1];
            tempy1i = y[1][1]+1;
            
            tempx1i2 = x[1][0];
            tempy1i2 = y[1][0]+1;
        }
        
        //
        if (tempx0i <= 0 && tempx1i <= 0 )
        {
            tempx0i = 84 + tempx0i;
            tempx1i = tempx0i;
        }
        if (tempx0i >= 84 && tempx1i >= 84)
        {
            tempx0i = tempx0i - 84;
            tempx1i = tempx0i;
        }
        if (tempy0i <= 0 && tempy1i <=0)
        {
            tempy0i = tempy0i + 48;
            tempy1i = tempy0i;
        }
        if (tempy0i >= 48 && tempy1i >= 48)
        {
            tempy0i = tempy0i - 48;
            tempy1i = tempy0i;
        }     
        
        if (!isEnd) {
            for (i = 0; i < slength; i++)
                {  
                    if (dr | dl) {
                        xx0i = x[0][i];
                        yy0i = y[0][i];
                        x[0][i] = tempx0i;
                        y[0][i] = tempy0i;
                        tempx0i = xx0i;
                        tempy0i = yy0i; 
                        
                        xx1i = x[1][i];
                        yy1i = y[1][i];
                        x[1][i] = tempx1i;
                        y[1][i] = tempy1i;
                        tempx1i = xx1i;
                        tempy1i = yy1i; 
                    } else if (dd) {
                        xx0i = x[0][i];
                        yy0i = y[0][i];
                        x[0][i] = tempx0i;
                        y[0][i] = tempy0i;
                        tempx0i = xx0i;
                        tempy0i = yy0i; 
                        
                        xx1i = x[1][i];
                        yy1i = y[1][i];
                        x[1][i] = tempx1i2;
                        y[1][i] = tempy1i2;
                        tempx1i2 = xx1i;
                        tempy1i2 = yy1i; 
                    }     
                }   
        }
        
        
        draw_snake();
        
    }
}


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

setup();
while (1)
    {
        // Please write your application code here
        int phim = BUTTON();  //
        move_snake();  
    }
}
