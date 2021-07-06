/*****************************************************/
/* BOX Game in 12h VGA Mode(640*480*16)              */
/* copyright (c) Black White, May 22, 2021.          */
/* email: iceman@zju.edu.cn                          */
/* This program is for teaching purpose only, and    */
/* it can only be shared within Zhejiang University. */
/* Everyone at ZJU who has downloaded this program   */
/* is NOT allowed to upload it to internet.          */
/* Here I want to thank my Turing class students.    */
/* It's your maniac enthusiasm for learning ASM that */
/* motivates me to start reverse-engineering this    */
/* program's blueprint, a game released in 90s, and  */
/* finally make this program a reality after 7 days  */
/* and nights of hard working.                       */
/*****************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <mem.h>
#include <dos.h>
#include <bios.h>
/* 在汇编语言中可以用equ实现#define一样的效果, 如:
   UP equ 4800h相当于#define UP 0x4800
 */
#define UP       0x4800 /* 汇编语言可以调用int 16h/AH=00h      */
#define LEFT     0x4B00 /* 读取上下左右4个方向键及Esc、退格键: */
#define DOWN     0x5000 /* mov ah, 0                           */
#define RIGHT    0x4D00 /* int 16h; AX=键盘编码                */
#define BKSPACE  0x0E08 /* 退格键                              */
#define ESC      0x011B /* ----------------------------------- */
#define ROCK     0x0000 /* 仓库外面的石块 */
#define BRICK    0x0001 /* 包围仓库的红色砖块 */
#define BOX      0x0002 /* 箱子 */
#define FLOOR    0x0003 /* 仓库里面的绿色地砖 */
#define BALL     0x0004 /* 球, 用来标注箱子需要存放的位置 */
#define MAN      0x0005 /* 推箱子的人, 图像与WALK_UP相同 */
#define BOB      0x0006 /* box on ball, 箱子与球重叠 */
#define PUSH_UP    0x0000 /* 往上推箱子的人 */
#define PUSH_LEFT  0x0001 /* 往左推箱子的人 */
#define PUSH_DOWN  0x0002 /* 往下推箱子的人 */
#define PUSH_RIGHT 0x0003 /* 往右推箱子的人 */
#define WALK_UP    0x0004 /* 往上走的人 */
#define WALK_LEFT  0x0005 /* 往左走的人 */
#define WALK_DOWN  0x0006 /* 往下走的人 */
#define WALK_RIGHT 0x0007 /* 往右走的人 */
#define MAX_LEVEL  30

typedef unsigned char byte;
typedef unsigned short int word;
typedef unsigned long int dword;

/* 地图由BLK构成, 如BRICK, BOX, FLOOR, BALL, MAN都是BLK */
/* blk_ptr指向存放BLK图像的内存块, blk_size表示该内存块的长度 */
typedef struct 
{
   word blk_size;
   byte far *blk_ptr;
} BLK_INFO;

word blk_size_level;
/* blk_size_level一共有5级: 0, 1, 2, 3, 4
   其中0级不用; 各个blk_size_level对应的物体或人的图像宽、高为:
   obj_width[blk_size_level]
   obj_height[blk_size_level]
   以下二维数组的第1维就是blk_size_level;
   第2维是指物体或人的BLK ID, 如BRICK, BOX,
   FLOOR, PUSH_UP, WALK_UP均为BLK ID.
 */
BLK_INFO obj_blk[5][7]; /* 存放物体的图像信息 */
BLK_INFO man_blk[5][8]; /* 存放人的图像信息 */
BLK_INFO txt_blk[11];   /* 存放文本的图像信息: "0"~"9", "目前关数:000 已走步数:0000" */

byte palette[] =
{
   0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
   0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
};

/* 以下数组的下标均为blk_size_level */
word obj_width[] = {0x00, 0x30, 0x20, 0x18, 0x10};
word obj_height[] = {0x00, 0x24, 0x18, 0x12, 0x0C};
word map_columns[] = {0x00, 0x0D, 0x14, 0x1A, 0x28};
word map_rows[] = {0x00, 0x09, 0x0E, 0x13, 0x1C};
word box_count, ball_count, bob_count; /* 箱子个数, 球的个数, 箱子叠球的个数 */

int level, steps; /* 第几关(base 1), 已走步数 */
int level_in_map; /* 当前地图中是第几关(base 1), 一个地图文件里面总共10关 */
int man_x, man_y, box_x, box_y; /* 人的当前坐标, 刚推好的箱子坐标, base 1 */
int back_available = 0; /* 是否允许回退一步 */
word back_man_flag = WALK_UP, man_flag = WALK_UP; /* 人的上一步flag及当前flag */
int ox, oy, nx, ny, fx, fy; /* 当前坐标(ox,oy), 前一格坐标(nx, ny), 前二格坐标(fx, fy), base 1 */
int opx, opy, npx, npy, fpx, fpy; /* 当前,前一格,前二格的像素坐标, base 0 */
int back_man_x, back_man_y, back_box_x, back_box_y; /* 上一步的人坐标及箱子坐标, base 1 */
word nflag, fflag; /* 地图中某个物体的id称为flag; nflag=前一格的flag, fflag=前二格的flag */
int bar_px, bar_py; /* 状态条(用于显示当前关数及步数)的像素坐标 */
byte str_level[6], str_steps[6]; /* 当前关数及步数转化成十进制字符串保存在此数组中 */

typedef struct 
{
   byte magic[2]; /* "BW" */
   int level, steps; /* 第几关, 已走步数 */
   int man_x, man_y; /* 人的当前坐标, base 1 */
   word man_flag; /* 人的当前flag */
   word flag[0x1D][0x29]; /* 用来保存当前这关的地图信息, 行数=0x1D, 列数=0x29 */
} SAVE;

/* 地图文件的结构 */
/* 一个地图文件里面包含11关数据, 其中第1至10关是flag数据(BLK ID), 
   第0关则用来定义11关blk_size_level数据, 同样, blk_size_level[1]
   至blk_size_level[10]对应1至10关, blk_size_level[0]则空置不用;
   地图中每个BLK(即各个flag的图像)的宽度、高度以及地图的行数(纵向
   BLK数量)、列数(横向BLK数量)都用blk_size_level[i]索引:                          
      obj_width[blk_size_level[i]]                    
      obj_height[blk_size_level[i]]                   
      map_rows[blk_size_level[i]]                     
      map_columns[blk_size_level[i]]
   其中i表示当前地图内的第几关(base 1), i = (level-1) % 10 + 1;
   flag[row][col][level_in_map]表示当前地图第level_in_map关中
   第row行(base 1)第col列(base 1)的BLK ID, 如flag[3][4][5]=BOX
   表示当前地图第5关(4,3)坐标处是一个箱子.
  */                                                
typedef union
{                              
   word blk_size_level[0x0B];  
   word flag[0x1D][0x29][0x0B];
} MAP;

byte far *blk_buf; /* 用来保存人当前踩住的物体的图像, 如FLOOR, BALL */
MAP *pmap = NULL;  /* 指向地图 */

void text(void)    /* 切换到文本模式 */
{
   _AX=0x0003;
   geninterrupt(0x10);
   /* asm:
      mov ax, 0003h
      int 10h
    */
}

void vga(void)    /* 切换到640*480*16color图形模式 */
{
   /* ref. Bochs!vgacore.cc!1860 */
   _AX=0x0012;
   geninterrupt(0x10);    /* set video mode to 640*480*16colors mode */
   /* asm:
      mov ax, 0012h
      int 10h
    */
   outportb(0x3CE, 5);    /* mode register */
   /* asm:
      mov al, 5
      mov dx, 3CEh
      out dx, al
    */
   outportb(0x3CF, 0x00); /* Bit1Bit0=00 for vga write mode 0 */
                          /* Bit3=0 for vga read mode 0 */
   outportb(0x3CE, 8);    /* bit mask register */
   outportb(0x3CF, 0xFF); /* write all 8 bits, no bit is masked off */
   outportb(0x3CE, 3);    /* 3=data rotate/function select register */
   outportb(0x3CF, 0);    /* Bit4Bit3=00 replace, Bit4Bit3=01 AND */
                          /* Bit4Bit3=10 OR, Bit4Bit3=11 XOR */
                          /* Bit2Bit1Bit0 = ror count */
}

void select_plane(int n)
{
   outportb(0x3CE, 4);
   outportb(0x3CF, n);    /* select plane n for reading */
   outportb(0x3C4, 2);
   outportb(0x3C5, 1<<n); /* select plane n for writing */
}

void set_palette(byte far *p_palette)
{
   struct REGPACK r;
   memset(&r, 0, sizeof(r));
   r.r_ax = 0x1002;
   r.r_bx = 0;
   r.r_dx = *(word *)&p_palette;       /* r.r_bx = FP_OFF(p_palette) */
   r.r_es = *((word *)&p_palette + 1); /* r.es = FP_SEG(p_palette) */
   r.r_flags |= 0x200; /* IF=1, interrupt flag is on */
   intr(0x10, &r);
   /* asm:
      AX=1002h
      ES:DX->palette
      BH=0
      int 10h
     */
}

void memset_far_memory_block(byte far *p, byte c, int n)
{  /* asm: rep stosb */
   int i;
   for(i=0; i<n; i++)
   {
      p[i] = c;
   }
}

/* 读文件, 返回存放文件内容的内存块指针, n=文件大小 */
byte *read_file(char *filename, dword *n)
{
   FILE *fp;
   byte *p;
   dword size;
   fp = fopen(filename, "rb");
   /* asm: 
      mov ax, 3D00h
      mov dx, seg filename
      mov ds, dx
      mov dx, offset filename
      int 21h; AX=fp
    */
   if(fp == NULL)
   {
      *n = 0;
      return NULL;
   }
   fseek(fp, 0, SEEK_END);
   /* asm:
      mov ax, 4202h; AL=02h for SEEK_END
      mov bx, fp
      xor cx, cx; \ cx:dx=seek distance
      xor dx, dx; /
      int 21h; DX:AX=size
    */
   size = ftell(fp);
   fseek(fp, 0, SEEK_SET);
   /* asm:
      mov ax, 4200h; AL=00h for SEEK_SET
      mov bx, fp
      xor cx, cx; \ cx:dx=seek distance
      xor dx, dx; /
      int 21h; DX:AX=0
    */
   p = malloc(size);
   /* asm:
      mov ah, 48h
      mov bx, (size+0Fh)/10h
      int 21h; AX=segment for allocated memory
    */
   if(p == NULL)
   {
      fclose(fp);
      /* asm:
         mov ah, 3Eh
         mov bx, fp
         int 21h
       */
      *n = 0;
      return NULL;
   }
   fread(p, 1, size, fp);
   /* asm:
      mov ah, 3Fh
      mov bx, fp
      mov cx, size
      mov dx, word ptr p[0]
      mov ds, word ptr p[2]
      int 21h
    */
   fclose(fp);
   *n = size;
   return p;
}

word copy_near_to_far(byte *p, byte far *bp, word n)
{
   if(bp == NULL)
      return 0;
   movedata(FP_SEG((byte far *)p), 
            FP_OFF((byte far *)p), 
            FP_SEG(bp), 
            FP_OFF(bp), 
            n);
   /* 把p指向的文件内容复制到bp指向的内存空间中 */
   /* asm:
      ds=word ptr p[2];
      si=word ptr p[0];
      es=word ptr bp[2];
      di=word ptr bp[0];
      cx=n;
      cld
      rep movsb
     */
   return n;
}

int build_blk_info_from_file(void)
{
   #if 0
   static char *obj_file[] =
   {
      "boxdata\\obj\\size1\\flag0.dat", /* rock */
      "boxdata\\obj\\size1\\flag1.dat", /* brick */
      "boxdata\\obj\\size1\\flag2.dat", /* box */
      "boxdata\\obj\\size1\\flag3.dat", /* floor */
      "boxdata\\obj\\size1\\flag4.dat", /* ball */
      "boxdata\\obj\\size1\\flag5.dat", /* man_walk_up */
      "boxdata\\obj\\size1\\flag6.dat", /* box_on_ball */
   };
   static char *man_file[] =
   {
      "boxdata\\man\\size1\\man0.dat", /* push_up */
      "boxdata\\man\\size1\\man1.dat", /* push_left */
      "boxdata\\man\\size1\\man2.dat", /* push_down */
      "boxdata\\man\\size1\\man3.dat", /* push_right */
      "boxdata\\man\\size1\\man4.dat", /* walk_up */
      "boxdata\\man\\size1\\man5.dat", /* walk_left */
      "boxdata\\man\\size1\\man6.dat", /* walk_down */
      "boxdata\\man\\size1\\man7.dat"  /* walk_right */
   };
   #endif
   int i, j;
   byte *p;
   dword n;
   word copy_bytes;
   char filename[0x100];
   for(i=1; i<=4; i++) /* 共4个blk_size_level */
   {
      for(j=0; j<=6; j++) /* 共7种物体 */
      {
         sprintf(filename, "boxdata\\obj\\size%d\\flag%d.dat", i, j);
         p = read_file(filename, &n);
         if(p == NULL)
            return 0;
         obj_blk[i][j].blk_size = n;
         obj_blk[i][j].blk_ptr = farmalloc(n);
         /* TC中的malloc()是在近堆中分配内存, 返回内存块的近指针,
            farmalloc()是在远堆中分配内存, 返回内存块的远指针;
            汇编语言中分配内存并无远近之分, 一律都用int 21h/AH=48h调用:
            mov ah, 48h
            mov bx, (n+0Fh)/10h; bx=内存块的节长度, 1节=10h字节
            int 21h; AX=内存块的段地址, 内存块的偏移地址一定为0
          */
         copy_bytes = copy_near_to_far(p, obj_blk[i][j].blk_ptr, obj_blk[i][j].blk_size);
         /* 把p指向的文件内容复制到obj_blk[i][j].blk_ptr指向的内存块中 */
         free(p);
         if(copy_bytes == 0)
            return 0;      
      }
   }

   for(i=1; i<=4; i++) /* 共4个blk_size_level */
   {
      for(j=0; j<=7; j++) /* 共8种人 */
      {
         sprintf(filename, "boxdata\\man\\size%d\\man%d.dat", i, j);
         p = read_file(filename, &n);
         if(p == NULL)
            return 0;
         man_blk[i][j].blk_size = n;
         man_blk[i][j].blk_ptr = farmalloc(n);
         if(man_blk[i][j].blk_ptr == NULL)
            return 0;
         copy_bytes = copy_near_to_far(p, man_blk[i][j].blk_ptr, man_blk[i][j].blk_size);
         /* 把p指向的文件内容复制到man_blk[i][j].blk_ptr指向的内存空间中 */
         free(p);
         if(copy_bytes == 0)
            return 0;
      }
   }

   for(i=0; i<=10; i++) /* 共11种文本: "0"~"9", "目前关数:000 已走步数:0000" */
   {
      sprintf(filename, "boxdata\\txt\\txt%d.dat", i);
      p = read_file(filename, &n);
      if(p == NULL)
         return 0;
      txt_blk[i].blk_size = n;
      txt_blk[i].blk_ptr = farmalloc(n);
      if(txt_blk[i].blk_ptr == NULL)
         return 0;
      copy_bytes = copy_near_to_far(p, txt_blk[i].blk_ptr, txt_blk[i].blk_size);
      /* 把p指向的文件内容复制到txt_blk[i].blk_ptr指向的内存空间中 */
      free(p);
      if(copy_bytes == 0)
         return 0;
   }
   return 1; /* success */
}

/* 保存左上角为(x, y), 右下角为(x+width-1, y+height-1)的矩形图像到p指向的内存块中 */
int get_obj(byte far *p, int x, int y, word width, word height)
{
   byte far *q, far *v, far *pv, far *buf;
   byte ror, latch; /* ror是显卡中每个字节需要循环右移的次数 */
                    /* latch用来保存显卡中某个字节的值 */
   byte mask, final_byte_mask, tail_mask, and_mask;
   int bytes_per_line_per_plane, tail_bits_per_line_per_plane, r, plane;
   int len, i, k, n;
   *(word far *)p = width;
   *(word far *)(p+2) = height;
   len = 4;
   bytes_per_line_per_plane = width / 8;
   tail_bits_per_line_per_plane = width % 8;
   buf = farmalloc((width+7) / 8 + 1); /* add one byte for bit alignment processing */
   if(buf == NULL)
   {
      return 0;      
   }
   v = (byte far *)0xA0000000 + (y * 640L + x) / 8; /* one bit per pixel */
   ror = x % 8;
   mask = 0xFF >> ror; 
   q = p+4; /* q->data */
   pv = v;  /* pv->(0,0) */
   for(r=0; r<height; r++)
   {
      for(plane=0; plane<4; plane++) /* draw a horizontal line */
      {
         select_plane(plane);
         if(ror != 0) /* x coordinate is not aligned on the MSB of video byte */
         {            /* must copy one more byte */
            n = bytes_per_line_per_plane + 1;
            final_byte_mask = mask;
         }
         else /* x coordinate is aligned on the MSB of video byte */
         {
            n = bytes_per_line_per_plane;
            final_byte_mask = 0;
         }
         movedata(FP_SEG(pv), FP_OFF(pv), FP_SEG(buf), FP_OFF(buf), n);
         if(tail_bits_per_line_per_plane != 0)
         {
            tail_mask = (1 << tail_bits_per_line_per_plane) - 1;
            /* e.g. (1 << 3) - 1 = 1000 - 1 = 0111 */
            tail_mask = tail_mask << (8-tail_bits_per_line_per_plane);
            /* e.g. 0000 0111 << 5 = 1110 0000 */
            tail_mask = tail_mask >> ror | tail_mask << (8-ror);
            /* e.g. ror(1110 0000, 7) = 1100 0001 */
            and_mask = final_byte_mask & tail_mask;
            /* e.g. 0000 0001 & 1100 0001 = 0000 0001 */
            tail_mask ^= and_mask; /* calculate the remaining bits */
            /* e.g. 1100 0001 & 0000 0001 = 1100 0000 */
            if(tail_mask != 0)
            {
               buf[n] = pv[n]; /* copy one more byte */
               buf[n] &= tail_mask; /* mask off useless trailing bits */
               n++;
            }
            else
            {
               buf[n-1] &= ~final_byte_mask | and_mask;
               /* e.g. 0000 0011   1111 1111   1111 1100 
                              ------------============1x
                  final_byte_mask = 0000 0011
                  tail_mask       = 0000 0010 // tail_mask = ror(1000 0000, 6)
                  and_mask        = 0000 0010
                  tail_mask       = 0000 0000
                */
            }
         } /* if(tail_bits_per_line_per_plane != 0) */
         else /* tail_bits_per_line_per_plane == 0 */
         {
            buf[n-1] &= ~final_byte_mask;
            /* e.g. 0000 0011   1111 1111   1111 1100 
                           ------------============xx
               final_byte_mask = 0000 0011
              ~final_byte_mask = 1111 1100
             */
         }
         for(k=0; k<ror; k++) /* The count of tail bits may be less than ror, */
         {                    /* so we RCL one bit per loop */
            byte old_cf = 0, new_cf = 0;
            for(i=n-1; i>=0; i--)
            {
               new_cf = buf[i] >> 7; /* new_cf = MSB of buf[n-1] */
               buf[i] = buf[i] << 1 | old_cf;
               old_cf = new_cf;
            }
         }
         n = (width+7) / 8;
         movedata(FP_SEG(buf), FP_OFF(buf), FP_SEG(q), FP_OFF(q), n);
         q += n;
         len += n;
      } /* for(plane=0; plane<4; plane++) */
      pv += 640/8; /* adjust pv such that it will point to next line's 1st pixel */
   }
   farfree(buf);
   return len;
}

/* 在(x,y)处显示p所指向的BLK图像 */
/* BLK图像结构如下:
   +00 width ; word
   +02 height; word
   +04 line0 data for plane0; 0101 0101 \  构成了一条8个点的水平线
       line0 data for plane1; 0011 0011  \ 每个点对应一个bit
       line0 data for plane2; 0000 1111  / 从左到右8个点的颜色为:
       line0 data for plane3; 0000 0000 /  0, 1, 2, 3, 4, 5, 6, 7
       line1 data for plane0; |||     |
       line1 data for plane1; |||     |
       line1 data for plane2; |||     +----第7个点的二进制颜色从下往上=0111=7 
       line1 data for plane3; ||+----------第2个点的二进制颜色从下往上=0010=2
       line2 data for plane0; |+-----------第1个点的二进制颜色从下往上=0001=1
       line2 data for plane1; +------------第0个点的二进制颜色从下往上=0000=0
       line2 data for plane2;
       line2 data for plane3;
 */
void put_obj(byte far *p, int x, int y)
{
   byte far *q, far *v, far *pv;
   byte ror;
   byte latch;
   byte mask, final_byte_mask, tail_mask, and_mask;
   word width, height;
   int bytes_per_line_per_plane, tail_bits_per_line_per_plane, r, plane;
   int i, n;
   width = *(word far *)p;
   height = *(word far *)(p+2);
   bytes_per_line_per_plane = width / 8;
   tail_bits_per_line_per_plane = width % 8;
   v = (byte far *)0xA0000000 + (y * 640L + x) / 8; /* one bit per pixel */
   ror = x % 8;
   mask = 0xFF >> ror;
   q = p+4; /* q->data */
   pv = v;  /* pv->(0,0) */
   for(r=0; r<height; r++)
   {
      for(plane=0; plane<4; plane++) /* draw a horizontal line */
      {
         select_plane(plane);
         if(ror != 0) /* x coordinate is not aligned on the MSB of video byte */
         {            /* mask & ror are needed to shift bits on writing */
            outportb(0x3CE, 8); /* mask register */
            outportb(0x3CF, mask);
            outportb(0x3CE, 3); /* ror register */
            outportb(0x3CF, ror);
            for(i=0; i<bytes_per_line_per_plane; i++)
            {
               latch = pv[i]; /* There is only one latch for all bytes on one plane, */
               pv[i] = q[i];  /* so we have to latch & write bytes one by one */
            }
            outportb(0x3CE, 8); /* mask register */
            outportb(0x3CF, ~mask);
            for(i=0; i<bytes_per_line_per_plane; i++)
            {
               latch = pv[i+1];
               pv[i+1] = q[i];
            }
            n = bytes_per_line_per_plane + 1; /* video bytes written */
            final_byte_mask = mask;  /* 1 = bit to be filled; 0 = bit already filled */
         }
         else /* x coordinate is aligned on the MSB of video byte */
         {    /* direct copy is the way */
            outportb(0x3CE, 8); /* mask register */
            outportb(0x3CF, 0xFF); /* write all 8 bits of one byte without masking */
            outportb(0x3CE, 3); /* ror register */
            outportb(0x3CF, 0); /* no rotating right */
            movedata(FP_SEG(q), FP_OFF(q), FP_SEG(pv), FP_OFF(pv), bytes_per_line_per_plane);
            /* copy bytes_per_line_per_plane data from q to pv */
            n = bytes_per_line_per_plane; /* video bytes written */
            final_byte_mask = 0x00; /* Since there are no bits left unfilled
                                       in the final byte, the mask for it must
                                       be set to 0.
                                     */
         }
         q += bytes_per_line_per_plane;
         if(tail_bits_per_line_per_plane != 0)
         {
            tail_mask = (1 << tail_bits_per_line_per_plane) - 1;
            /* e.g. (1 << 3) - 1 = 1000 - 1 = 0111 */
            tail_mask = tail_mask << (8-tail_bits_per_line_per_plane);
            /* e.g. 0000 0111 << 5 = 1110 0000 */
            tail_mask = tail_mask >> ror | tail_mask << (8-ror);
            /* e.g. ror(1110 0000, 7) = 1100 0001 */
            and_mask = final_byte_mask & tail_mask;
            /* e.g. 0000 0001 & 1100 0001 = 0000 0001 */
            outportb(0x3CE, 8); /* mask register */
            outportb(0x3CF, and_mask);
            outportb(0x3CE, 3); /* ror register */
            outportb(0x3CF, ror);
            latch = pv[n-1];
            pv[n-1] = *q;
            tail_mask ^= and_mask; /* calculate the remaining bits */
            if(tail_mask != 0) /* some bits left in *q should be copied to next video byte */
            {
               outportb(0x3CE, 8); /* mask register */
               outportb(0x3CF, tail_mask);
               latch = pv[n];
               pv[n] = *q;
            }
            q++; /* skip this used byte */
         }
      }
      pv += 640/8; /* adjust pv such that it will point to next line's 1st pixel */
   }
   outportb(0x3CE, 8); /* mask register */
   outportb(0x3CF, 0xFF);
   outportb(0x3CE, 3); /* ror register */
   outportb(0x3CF, 0);
   /* Please ignore the warning message:
      "'latch' is assigned a value which is never used"
      because it's just a copy of video byte used in
      masked video writing.
    */
}

byte * load_map(int level)
{
   char *map_file[] =
   {
      "boxdata\\map\\lnk1x.map",
      "boxdata\\map\\lnk2x.map",
      "boxdata\\map\\lnk3x.map"
   };
   dword n;
   byte *pmap;
   int map_file_idx;
   if(level > MAX_LEVEL)
      level = 1; /* play from level 1 again */
   map_file_idx = (level-1) / 10; /* 10 levels per map, level is base 1 */
   pmap = read_file(map_file[map_file_idx], &n);
   return pmap;
}

void draw_level_and_steps(void)
{
   int i, n, d, digit_width;
   digit_width = 0x0C; /* *(word far *)txt_obj[0].blk_ptr == 0x0C */
   sprintf(str_level, "%03d", level);
   sprintf(str_steps, "%04d", steps);
   n = strlen(str_level); /* n = 3 */
   for(i=0; i<n; i++)
   {
      d = str_level[i] - '0';
      put_obj(txt_blk[d].blk_ptr, bar_px+(8+i)*digit_width, bar_py+4);
   }
   n = strlen(str_steps); /* n = 4 */
   for(i=0; i<n; i++)
   {
      d = str_steps[i] - '0';
      put_obj(txt_blk[d].blk_ptr, bar_px+6+(19+i)*digit_width, bar_py+4);
   }
}

void DrawMap_CountObj_SetManXyFlag(int mx, int my, word mflag)
{
   int x, y, man_px, man_py;
   word flag;
   ball_count = 0;
   box_count = 0;
   bob_count = 0;
   vga(); /* 切换到640*480*16color图形模式 */
   set_palette(&palette[0]); /* 设置调色板 */
   for(y=1; y<=map_rows[blk_size_level]; y++)
   {
      for(x=1; x<=map_columns[blk_size_level]; x++)
      {
         flag = pmap->flag[y][x][level_in_map];
         /* flag = *(word *)((byte *)pmap+((0x29*y+x)*0x0B+level)*2); */
         if(flag == MAN) /* the original map contains MAN flag, the saved map does not */
         {
            man_x = x; /* base 1 */
            man_y = y; /* base 1 */
            man_flag = WALK_UP; /* 原始地图里的人的flag一定是WALK_UP */
            flag = FLOOR; /* 把人换成FLOOR并显示在地图上 */
            pmap->flag[y][x][level_in_map] = FLOOR; 
            /* 原始地图里的人踩住的物体一定是FLOOR, 不可能是BALL. */
         }
         else if(flag == BALL)
         {
            ball_count++;
         }
         else if(flag == BOX)
         {
            box_count++;
         }
         else if(flag == BOB)
         {
            ball_count++;
            box_count++;
            bob_count++;
         }
         put_obj(obj_blk[blk_size_level][flag].blk_ptr,
         /*=*/ (x-1) * obj_width[blk_size_level],
         /*=*/ (y-1) * obj_height[blk_size_level]); /* 画flag对应的BLK */
      }
   }
   if(mx != 0 && my != 0) /* when map info is from "box.sav", not from original map */
   {
      man_x = mx;         /* 把box.sav中获取的人的坐标及flag保存到全局变量中 */
      man_y = my;
      man_flag = mflag;
   }
   man_px = (man_x-1) * obj_width[blk_size_level];
   man_py = (man_y-1) * obj_height[blk_size_level];
   get_obj(blk_buf, man_px, man_py, obj_width[blk_size_level], obj_height[blk_size_level]);
   /* 保存人当前踩住的物体图像到blk_buf指向的内存块中 */
   put_obj(man_blk[blk_size_level][man_flag].blk_ptr, man_px, man_py);
   /* 在(man_x, man_y)处画人 */
   bar_py = map_rows[blk_size_level] * obj_height[blk_size_level] + 4;
   bar_px = (map_columns[blk_size_level] * obj_width[blk_size_level]
	    - *(word far *)txt_blk[10].blk_ptr) / 2;
   /* ---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--- bar's width */
   put_obj(txt_blk[10].blk_ptr, bar_px, bar_py);
   draw_level_and_steps(); /* 显示当前关数及步数 */
}

int do_walk_or_push(word walk_flag, word push_flag)
{
   nflag = pmap->flag[ny][nx][level_in_map], fflag = pmap->flag[fy][fx][level_in_map];
   /* nflag = 前面一格的flag; fflag = 前面二格的flag; */
   if(nflag == ROCK || nflag == BRICK)
      return 0; /* cannot go */
   opx = (ox-1) * obj_width[blk_size_level]; /* 当前(x,y)转化成像素坐标 */
   opy = (oy-1) * obj_height[blk_size_level];
   npx = (nx-1) * obj_width[blk_size_level]; /* 前面一格(x,y)转化成像素坐标 */
   npy = (ny-1) * obj_height[blk_size_level];
   fpx = (fx-1) * obj_width[blk_size_level]; /* 前面二格(x,y)转化成像素坐标 */
   fpy = (fy-1) * obj_height[blk_size_level];

   if(nflag == FLOOR || nflag == BALL) /* walk */
   {
      put_obj(blk_buf, opx, opy); /* hide man */
      get_obj(blk_buf, npx, npy, obj_width[blk_size_level], obj_height[blk_size_level]);
      put_obj(man_blk[blk_size_level][walk_flag].blk_ptr, npx, npy); /* [%] */
      back_available = 0;
      man_flag = walk_flag;
      man_x = nx;
      man_y = ny;
      steps++;
      draw_level_and_steps();
      return 1; /* success */
   }

   if(nflag == BOX || nflag == BOB) /* push */
   {
      if(fflag != FLOOR && fflag != BALL)
         return 0; /* cannot push */
      put_obj(blk_buf, opx, opy); /* hide man */
      if(nflag == BOB)
      {
         put_obj(obj_blk[blk_size_level][BALL].blk_ptr, npx, npy); /* recover ball */
         pmap->flag[ny][nx][level_in_map] = BALL;
         bob_count--;
      }
      else
      {
         put_obj(obj_blk[blk_size_level][FLOOR].blk_ptr, npx, npy); /* recover floor */
         pmap->flag[ny][nx][level_in_map] = FLOOR;
      }
      get_obj(blk_buf, npx, npy, obj_width[blk_size_level], obj_height[blk_size_level]);
      if(fflag == BALL)
      {
         put_obj(obj_blk[blk_size_level][BOB].blk_ptr, fpx, fpy); /* draw bob */
         pmap->flag[fy][fx][level_in_map] = BOB;
         bob_count++;
      }
      else
      {
         put_obj(obj_blk[blk_size_level][BOX].blk_ptr, fpx, fpy); /* draw box */
         pmap->flag[fy][fx][level_in_map] = BOX;
      }
      put_obj(man_blk[blk_size_level][push_flag].blk_ptr, npx, npy); /* draw man */
      back_man_flag = man_flag;
      back_man_x = ox;
      back_man_y = oy;
      back_box_x = nx;
      back_box_y = ny;
      man_flag = push_flag;
      man_x = nx;
      man_y = ny;
      box_x = fx;
      box_y = fy;
      back_available = 1;
      steps++;
      draw_level_and_steps();
      if(bob_count == ball_count)
         return 2; /* level done */
      else
         return 1; /* success */    
   } /* if(nflag == FLOOR || nflag == BALL) */
}

int go_up(void)
{
   ox=man_x, oy=man_y, nx=man_x, ny=man_y-1, fx=man_x, fy=man_y-2;
   return do_walk_or_push(WALK_UP, PUSH_UP);
}

int go_left(void)
{
   ox=man_x, oy=man_y, nx=man_x-1, ny=man_y, fx=man_x-2, fy=man_y;
   return do_walk_or_push(WALK_LEFT, PUSH_LEFT);
}

int go_down(void)
{
   ox=man_x, oy=man_y, nx=man_x, ny=man_y+1, fx=man_x, fy=man_y+2;
   return do_walk_or_push(WALK_DOWN, PUSH_DOWN);
}

int go_right(void)
{
   ox=man_x, oy=man_y, nx=man_x+1, ny=man_y, fx=man_x+2, fy=man_y;
   return do_walk_or_push(WALK_RIGHT, PUSH_RIGHT);
}

int go_back(void)
{
   int bx, by, bpx, bpy;
   if(!back_available)
      return 0;
   ox=man_x, oy=man_y;
   bx=box_x, by=box_y;
   opx = (ox-1) * obj_width[blk_size_level]; /* 当前人的(x,y)转化成像素坐标 */
   opy = (oy-1) * obj_height[blk_size_level];
   bpx = (bx-1) * obj_width[blk_size_level]; /* 当前箱子的(x,y)转化成像素坐标 */
   bpy = (by-1) * obj_height[blk_size_level];
   put_obj(blk_buf, opx, opy); /* hide man */
   if(pmap->flag[by][bx][level_in_map] == BOB) /* recover ball */
   {
      put_obj(obj_blk[blk_size_level][BALL].blk_ptr, bpx, bpy);
      pmap->flag[by][bx][level_in_map] = BALL;
      bob_count--;
   }
   else                                       /* recover floor */
   {    
      put_obj(obj_blk[blk_size_level][FLOOR].blk_ptr, bpx, bpy);
      pmap->flag[by][bx][level_in_map] = FLOOR;
   }
   ox=back_man_x, oy=back_man_y;
   bx=back_box_x, by=back_box_y;
   opx = (ox-1) * obj_width[blk_size_level]; /* 当前人的(x,y)转化成像素坐标 */
   opy = (oy-1) * obj_height[blk_size_level];
   bpx = (bx-1) * obj_width[blk_size_level]; /* 当前箱子的(x,y)转化成像素坐标 */
   bpy = (by-1) * obj_height[blk_size_level];
   get_obj(blk_buf, opx, opy, obj_width[blk_size_level], obj_height[blk_size_level]);
   put_obj(man_blk[blk_size_level][back_man_flag].blk_ptr, opx, opy); /* draw man */
   if(pmap->flag[by][bx][level_in_map] == BALL) /* draw bob on ball */
   {
      put_obj(obj_blk[blk_size_level][BOB].blk_ptr, bpx, bpy);
      pmap->flag[by][bx][level_in_map] = BOB;
      bob_count++;
   }
   else                                  /* draw box on floor */
   {    
      put_obj(obj_blk[blk_size_level][BOX].blk_ptr, bpx, bpy);
      pmap->flag[by][bx][level_in_map] = BOX;
   }
   man_x = ox;
   man_y = oy;
   man_flag = back_man_flag;
   box_x = bx;
   box_y = by;
   steps--;
   draw_level_and_steps();
   back_available = 0; /* only take back once */
   return 1;
}

int go_esc(void)
{
   /* save info to file */
   SAVE *ps;
   FILE *fp;
   int n, x, y;
   fp = fopen("box.sav", "wb");
   if(fp == NULL)
      return -1;
   ps = malloc(sizeof(SAVE));
   if(ps == NULL)
      return -1;
   ps->magic[0] = 'B';
   ps->magic[1] = 'W';
   ps->level = level;
   ps->steps = steps;
   ps->man_x = man_x;
   ps->man_y = man_y;
   ps->man_flag = man_flag;
   for(y=1; y<=map_rows[blk_size_level]; y++)
   {
      for(x=1; x<=map_columns[blk_size_level]; x++)
      {
         ps->flag[y][x] = pmap->flag[y][x][level_in_map];
         /* save map info */
      }
   }
   fwrite(ps, 1, sizeof(SAVE), fp);
   fclose(fp);
   free(ps);
   return -1; /* always return -1 to stop playing */
}


int play(void)
{
   typedef int GO(void);
   GO *go[6] = {go_up, go_left, go_down, go_right, go_back, go_esc};
   word key_map[6] = {UP, LEFT, DOWN, RIGHT, BKSPACE, ESC};
   word key;
   int i, n, result = 0;
   n = sizeof(key_map)/sizeof(key_map[0]);
   do
   {
      key = bioskey(0);
      for(i=0; i<n; i++)
      {
         if(key == key_map[i])
            break;
      }
      if(i < n)
         result = (*go[i])();
   } while(result != -1 && result != 2); /* -1 = Esc, 2 = level accomplished */
   return result;
}

int load_previous_play_info_from_file(char *filename)
{
   SAVE *ps;
   FILE *fp;
   int n, x, y;
   fp = fopen(filename, "rb");
   if(fp == NULL)
      return 0;
   ps = malloc(sizeof(SAVE));
   if(ps == NULL)
      return 0;
   n = fread(ps, 1, sizeof(SAVE), fp);
   fclose(fp);
   if(n < sizeof(SAVE))
   {
      free(ps);
      return 0;
   }
   if(*(word *)ps->magic != 0x5742) /* check "BW" */
   {
      free(ps);
      return 0;
   }
   level = ps->level;
   level_in_map = (level - 1) % 10 + 1;
   steps = ps->steps;
   pmap = (MAP *)load_map(level); /* first load original map associated with the level */
   if(pmap == NULL)
   {
      free(ps);
      return 0;
   }
   blk_size_level = pmap->blk_size_level[level_in_map];
   for(y=1; y<=map_rows[blk_size_level]; y++)
   {
      for(x=1; x<=map_columns[blk_size_level]; x++)
      {
         pmap->flag[y][x][level_in_map] = ps->flag[y][x];
         /* copy map info from saved map to original map */
      }
   }
   man_x = ps->man_x;
   man_y = ps->man_y;
   man_flag = ps->man_flag;
   free(ps);
   return 1;
}

main()
{
   int play_status;
   blk_buf = farmalloc(4 + (0x30/8+1)*4 * 0x24); /* allocate enough memory to hold
                                                    a 0x30 * 0x24 BLK(largest size)
                                                    add 4 bytes for width & height
                                                    用来保存人当前踩住的物体图像
                                                  */
   if(blk_buf == NULL)
   {
      puts("Not enough memory for blk_buf.");
      exit(0);
   }

   if(build_blk_info_from_file() == 0)
   {
      puts("build_blk_info_from_file() failed!");
      exit(0);
   }

   man_x = man_y = man_flag = 0; /* default value for original map */
   /* load_previous_play_info_from_file() will set the following global vars on
      success in opening "box.sav":
      level, level_in_map, steps, blk_size_level, man_x, man_y, man_flag
    */
   if(load_previous_play_info_from_file("box.sav") == 0) /* no saved play info */
   {          
      level = 1;
      level_in_map = (level-1) % 10 + 1;
      steps = 0;
      pmap = (MAP *)load_map(level);
      if(pmap == NULL)
      {
         puts("load_map(level) failed!");
         exit(0);
      }
      blk_size_level = pmap->blk_size_level[level_in_map];
   }
   do
   {
      DrawMap_CountObj_SetManXyFlag(man_x, man_y, man_flag);
      /* If man_x & man_y are not zero, then the above function will draw man 
         on the specified coordinates (man_x, man_y);
         If man_x & man_y are zero, then the above function will search man's 
         coordinates according to the man flag located at original map and 
         finally sets man_x, man_y and man_flag.
       */
      back_available = 0; /* 刚开始玩的时候不可以回退 */
      play_status = play(); /* -1 = Esc, 2 = current level is accomplished */
      free(pmap);
      pmap = NULL;
      if(play_status == -1) /* Esc pressed */
         continue;
      level++;
      level_in_map = (level-1) % 10 + 1;
      steps = 0;
      man_x = man_y = man_flag = 0;
      pmap = (MAP *)load_map(level);
      if(pmap == NULL)
      {
         puts("load_map(level) failed!");
         exit(0);
      }
      blk_size_level = pmap->blk_size_level[level_in_map];
   } while(play_status != -1);
   /* When the program exits, the memory allocated by malloc() or by farmalloc()
      will be automatically freed by DOS, so there is no need to call free() or 
      farfree() here. And a lot of memory kept for obj_blk, man_blk, txt_blk 
      will also be freed on exit.
   farfree(blk_buf);
   free(pmap);
   */
   text(); /* 切换到文本模式 */
   return;
}
