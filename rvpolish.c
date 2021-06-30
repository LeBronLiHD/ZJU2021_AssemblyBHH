#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef unsigned long int dword;
typedef unsigned char byte;
typedef dword PF(dword a, dword b);

dword out_item[0x100]; /* 输出队列(output queue), 用来保存整数和
                          + - * /四种运算符; 其中运算符最高位=1, 如
                          '+'用0x80000000表示, '-'用0x80000001表示,
                          '*'用0x80000002表示, '/'用0x80000003表示,
                          整数最高位=0, 即整数最大值为0x7FFFFFFF.
                        */
byte op_item[0x100];   /* 运算符队列(operator queue), 用来保存+ - * /
                          四种运算符及( */
int nout=0, nop=0;     /* nout=输出队列中的元素个数, nop=运算符队列中的元素个数 */

/* 把p指向的数字串转化成long并保存到*pnum中 */
byte * fetch_a_num(byte *p, dword *pnum)
{
   byte old, *q;
   q = p;
   while(*q >= '0' && *q <= '9')
      q++;
   old = *q;        /* 保存数字串后续字符 */
   *q = '\0';       /* 把数字串后续字符替换成'\0' */
   *pnum = atol(p); /* 把数字串转化成long */
   *q = old;        /* 恢复数字串后续字符 */
   return q;        /* 返回数字串后续字符的地址 */
}

/* 判断当前运算符c的优先级是否低于前一个运算符b的优先级 */
int is_lower_privilege(byte c, byte b)
{
   int ic, ib, i, n;
   byte p[3][2] = {{'(', '('}, {'+', '-'}, {'*', '/'}};
   /* 特意把左括号的优先级设成最低, 这样在运算符队列中
      左括号后面跟随的+ - * /运算符就不可能出现它们的优
      先级低于左括号的情形从而导致左括号被挪到输出队列中.
    */
   n = sizeof(p) / sizeof(p[0]); /* n = 3 */
   for(i=0; i<n; i++)
   {
      if(c == p[i][0] || c == p[i][1])
         ic = i; /* ic是c的优先级 */
      if(b == p[i][0] || b == p[i][1])
         ib = i; /* ib是b的优先级 */
   }
   return ic <= ib; /* 优先级相同时如+和-, 因为左结合的原因, 
                       先出现的运算符b的优先级高于当前运算符c, 
                       故ic==ib时也返回真 */
}

/* 把+ - * /运算符转化成0 1 2 3 */
int get_op_order(byte op)
{
   int i;
   byte order[4] = {'+', '-', '*', '/'};
   for(i=0; i<sizeof(order); i++) 
   {
      if(op == order[i])
         break;
   }
   return i;
}

/* 把中缀表达式如1+2*3转化成逆波兰表达式
   如1 2 3 * +并保存到out_item中 */
void reverse_polish_notation(byte *p)
{

   dword num;
   while(*p != '\0')
   {
      if(*p == ' ') /* 过滤掉空格 */
      {
         p++;
         continue;
      }
      if(*p >= '0' && *p <= '9')
      {
         p = fetch_a_num(p, &num); /* 返回值p指向数字串后续字符 */
         out_item[nout++] = num;   /* 把整数保存到输出队列 */
         continue;
      }
      if(*p == '(') /* 由于左括号并不能对两个数做运算, 它与右括号之间的表达式最终 */
      {             /* 将算出一个整数, 因此()应该理解成一个数, 左括号不应该与它前
                       面的运算符+ - * /或前面的左括号比较优先级, 否则会导致它前面
                       的运算符或左括号挪到输出队列中. */
         op_item[nop++] = *p; /* 保存左括号到运算符队列中 */
         p++;
         continue;
      }
      if(*p == ')') /* 中缀表达式中遇到右括号时必须在运算符队列中寻找匹配的左括号 */
      {             /* 并把()之间的运算符按从右到左顺序取出并保存到输出队列中 */
         while(op_item[--nop] != '(')
         {
            out_item[nout++] = get_op_order(op_item[nop]) | 0x80000000; 
            /* 为了区分输出队列中的整数和运算符, 运算符最高位置1, 整数最高位清零 */                
         }
         p++;
         continue;
      }
      /* *p一定是+ - * /这四种运算符 */
      while(nop > 0 && is_lower_privilege(*p, op_item[nop-1]))
      { /* 若当前运算符的优先级低于运算符队列中的前一个运算符, 则把
           前一运算符挪到输出队列中, 再取前一运算符比较优先级直到运
           算符队列为空或前一运算符的优先级低于当前运算符. */
         out_item[nout++] = get_op_order(op_item[--nop]) | 0x80000000;
      }
      op_item[nop++] = *p; /* 当前运算符保存到运算符队列中 */
      p++;
   }
   while(nop > 0) /* 若运算符队列中还有剩余的运算符, 则按从右到左顺序取出 */
   {              /* 并保存到输出队列中. */
      out_item[nout++] = get_op_order(op_item[--nop]) | 0x80000000;
   }
}

dword _add(dword a, dword b)
{
   return a+b;
}

dword _sub(dword a, dword b)
{
   return a-b;
}

dword _mul(dword a, dword b)
{
   return a*b;
}

dword _div(dword a, dword b)
{
   return a/b;
}

dword compute(void)
{
   dword y, num1, num2;
   byte op;
   PF *pf[4] = {_add, _sub, _mul, _div}; /* pf是函数指针数组 */
   int i;
   i = 0;
   while(nout > 1) /* 只要输出队列中剩余的元素不只一个就做计算 */
   {
      while((out_item[i] & 0x80000000) == 0) /* 在输出队列中搜索运算符, 最高位为0是整数 */
         i++;
      op = out_item[i] & 0x7FFFFFFF; /* 清除最高位, op=0代表+, 1代表-, 2代表*, 3代表/ */
      num1 = out_item[i-2];      /* 第1个操作数 */
      num2 = out_item[i-1];      /* 第2个操作数 */
      y = (*pf[op])(num1, num2); /* 求值. 汇编语言中可以使用call pf[bx]的形式调用函数 */
      out_item[i-2] = y;         /* 把运算结果保存到原先第1个操作数的位置 */
      memcpy(&out_item[i-1], &out_item[i+1], sizeof(out_item[0])*(nout-i-1));
                                 /* 复制输出队列中的第i+1至第nout-1个元素到第i-1个元素处
                                    从而删除原第i-1及第i个元素
                                  */
      nout -= 2;                 /* 更新输出队列中的元素个数 */
      i--;                       /* i调整到原i-1位置 */
   }
   return out_item[0];           /* 当输出队列中仅剩一个元素时, 该元素就是运算结果 */
}

/* 二进制格式输出32位 */
void binary_output(long x)
{
   int i, j;
   for(i=0; i<8; i++)
   {
      for(j=0; j<4; j++)
      {
         printf("%d", x<0 ? 1 : 0);
         x <<= 1;
      }
      printf(i != 7 ? " ":"B\n");
   }
}

main()
{
   char buf[0x100];
   dword result;
   gets(buf); /* 汇编语言中可以调用int 21h/AH=0Ah实现gets()的效果, 具体格式
                 请参考教材p.215或中断大全 */
   reverse_polish_notation(buf); /* 把中缀表达式转化成逆波兰表达式 */
   result = compute();           /* 计算表达式的值 */
   printf("%lu\n%08lXh\n", result, result); /* 十进制格式及十六进制格式输出result */
   binary_output(result);        /* 二进制格式输出result */
}
