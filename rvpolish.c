#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef unsigned long int dword;
typedef unsigned char byte;
typedef dword PF(dword a, dword b);

dword out_item[0x100]; /* �������(output queue), ��������������
                          + - * /���������; ������������λ=1, ��
                          '+'��0x80000000��ʾ, '-'��0x80000001��ʾ,
                          '*'��0x80000002��ʾ, '/'��0x80000003��ʾ,
                          �������λ=0, ���������ֵΪ0x7FFFFFFF.
                        */
byte op_item[0x100];   /* ���������(operator queue), ��������+ - * /
                          �����������( */
int nout=0, nop=0;     /* nout=��������е�Ԫ�ظ���, nop=����������е�Ԫ�ظ��� */

/* ��pָ������ִ�ת����long�����浽*pnum�� */
byte * fetch_a_num(byte *p, dword *pnum)
{
   byte old, *q;
   q = p;
   while(*q >= '0' && *q <= '9')
      q++;
   old = *q;        /* �������ִ������ַ� */
   *q = '\0';       /* �����ִ������ַ��滻��'\0' */
   *pnum = atol(p); /* �����ִ�ת����long */
   *q = old;        /* �ָ����ִ������ַ� */
   return q;        /* �������ִ������ַ��ĵ�ַ */
}

/* �жϵ�ǰ�����c�����ȼ��Ƿ����ǰһ�������b�����ȼ� */
int is_lower_privilege(byte c, byte b)
{
   int ic, ib, i, n;
   byte p[3][2] = {{'(', '('}, {'+', '-'}, {'*', '/'}};
   /* ����������ŵ����ȼ�������, �����������������
      �����ź�������+ - * /������Ͳ����ܳ������ǵ���
      �ȼ����������ŵ����δӶ����������ű�Ų�����������.
    */
   n = sizeof(p) / sizeof(p[0]); /* n = 3 */
   for(i=0; i<n; i++)
   {
      if(c == p[i][0] || c == p[i][1])
         ic = i; /* ic��c�����ȼ� */
      if(b == p[i][0] || b == p[i][1])
         ib = i; /* ib��b�����ȼ� */
   }
   return ic <= ib; /* ���ȼ���ͬʱ��+��-, ��Ϊ���ϵ�ԭ��, 
                       �ȳ��ֵ������b�����ȼ����ڵ�ǰ�����c, 
                       ��ic==ibʱҲ������ */
}

/* ��+ - * /�����ת����0 1 2 3 */
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

/* ����׺���ʽ��1+2*3ת�����沨�����ʽ
   ��1 2 3 * +�����浽out_item�� */
void reverse_polish_notation(byte *p)
{

   dword num;
   while(*p != '\0')
   {
      if(*p == ' ') /* ���˵��ո� */
      {
         p++;
         continue;
      }
      if(*p >= '0' && *p <= '9')
      {
         p = fetch_a_num(p, &num); /* ����ֵpָ�����ִ������ַ� */
         out_item[nout++] = num;   /* ���������浽������� */
         continue;
      }
      if(*p == '(') /* ���������Ų����ܶ�������������, ����������֮��ı��ʽ���� */
      {             /* �����һ������, ���()Ӧ������һ����, �����Ų�Ӧ������ǰ
                       ��������+ - * /��ǰ��������űȽ����ȼ�, ����ᵼ����ǰ��
                       ���������������Ų�����������. */
         op_item[nop++] = *p; /* ���������ŵ������������ */
         p++;
         continue;
      }
      if(*p == ')') /* ��׺���ʽ������������ʱ�����������������Ѱ��ƥ��������� */
      {             /* ����()֮�������������ҵ���˳��ȡ�������浽��������� */
         while(op_item[--nop] != '(')
         {
            out_item[nout++] = get_op_order(op_item[nop]) | 0x80000000; 
            /* Ϊ��������������е������������, ��������λ��1, �������λ���� */                
         }
         p++;
         continue;
      }
      /* *pһ����+ - * /����������� */
      while(nop > 0 && is_lower_privilege(*p, op_item[nop-1]))
      { /* ����ǰ����������ȼ���������������е�ǰһ�������, ���
           ǰһ�����Ų�����������, ��ȡǰһ������Ƚ����ȼ�ֱ����
           �������Ϊ�ջ�ǰһ����������ȼ����ڵ�ǰ�����. */
         out_item[nout++] = get_op_order(op_item[--nop]) | 0x80000000;
      }
      op_item[nop++] = *p; /* ��ǰ��������浽����������� */
      p++;
   }
   while(nop > 0) /* ������������л���ʣ��������, �򰴴��ҵ���˳��ȡ�� */
   {              /* �����浽���������. */
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
   PF *pf[4] = {_add, _sub, _mul, _div}; /* pf�Ǻ���ָ������ */
   int i;
   i = 0;
   while(nout > 1) /* ֻҪ���������ʣ���Ԫ�ز�ֻһ���������� */
   {
      while((out_item[i] & 0x80000000) == 0) /* ��������������������, ���λΪ0������ */
         i++;
      op = out_item[i] & 0x7FFFFFFF; /* ������λ, op=0����+, 1����-, 2����*, 3����/ */
      num1 = out_item[i-2];      /* ��1�������� */
      num2 = out_item[i-1];      /* ��2�������� */
      y = (*pf[op])(num1, num2); /* ��ֵ. ��������п���ʹ��call pf[bx]����ʽ���ú��� */
      out_item[i-2] = y;         /* �����������浽ԭ�ȵ�1����������λ�� */
      memcpy(&out_item[i-1], &out_item[i+1], sizeof(out_item[0])*(nout-i-1));
                                 /* ������������еĵ�i+1����nout-1��Ԫ�ص���i-1��Ԫ�ش�
                                    �Ӷ�ɾ��ԭ��i-1����i��Ԫ��
                                  */
      nout -= 2;                 /* ������������е�Ԫ�ظ��� */
      i--;                       /* i������ԭi-1λ�� */
   }
   return out_item[0];           /* ����������н�ʣһ��Ԫ��ʱ, ��Ԫ�ؾ��������� */
}

/* �����Ƹ�ʽ���32λ */
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
   gets(buf); /* ��������п��Ե���int 21h/AH=0Ahʵ��gets()��Ч��, �����ʽ
                 ��ο��̲�p.215���жϴ�ȫ */
   reverse_polish_notation(buf); /* ����׺���ʽת�����沨�����ʽ */
   result = compute();           /* ������ʽ��ֵ */
   printf("%lu\n%08lXh\n", result, result); /* ʮ���Ƹ�ʽ��ʮ�����Ƹ�ʽ���result */
   binary_output(result);        /* �����Ƹ�ʽ���result */
}
