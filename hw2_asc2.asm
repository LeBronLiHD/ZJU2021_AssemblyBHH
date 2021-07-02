; LI Haodonh
; asm Homework2

data segment
asc db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,07Eh,081h,0A5h,081h,081h,0BDh
    db 099h,081h,081h,07Eh,000h,000h,000h,000h
    db 000h,000h,07Ch,0FEh,0FEh,0D6h,0FEh,0FEh
    db 0BAh,0C6h,0FEh,07Ch,000h,000h,000h,000h
    db 000h,000h,000h,06Ch,0EEh,0FEh,0FEh,0FEh
    db 0FEh,07Ch,038h,010h,000h,000h,000h,000h
    db 000h,000h,000h,010h,038h,07Ch,0FEh,07Ch
    db 038h,010h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,010h,038h,038h,010h,06Ch
    db 0EEh,06Ch,010h,038h,000h,000h,000h,000h
    db 000h,000h,010h,038h,07Ch,07Ch,0FEh,0FEh
    db 0FEh,06Ch,010h,038h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,018h,03Ch,03Ch
    db 03Ch,018h,000h,000h,000h,000h,000h,000h
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0E7h,0C3h,0C3h
    db 0C3h,0E7h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 000h,000h,000h,000h,018h,03Ch,066h,066h
    db 066h,03Ch,018h,000h,000h,000h,000h,000h
    db 0FFh,0FFh,0FFh,0FFh,0E7h,0C3h,099h,099h
    db 099h,0C3h,0E7h,0FFh,0FFh,0FFh,0FFh,0FFh
    db 000h,000h,01Eh,00Eh,01Eh,036h,078h,0CCh
    db 0CCh,0CCh,0CCh,078h,000h,000h,000h,000h
    db 000h,000h,03Ch,066h,066h,066h,03Ch,018h
    db 07Eh,018h,018h,018h,000h,000h,000h,000h
    db 000h,000h,01Eh,01Ah,01Eh,018h,018h,018h
    db 018h,078h,0F8h,070h,000h,000h,000h,000h
    db 000h,000h,03Eh,036h,03Eh,036h,036h,076h
    db 0F6h,066h,00Eh,01Eh,00Ch,000h,000h,000h
    db 000h,000h,018h,0DBh,07Eh,03Ch,066h,066h
    db 03Ch,07Eh,0DBh,018h,000h,000h,000h,000h
    db 000h,000h,000h,080h,0E0h,0F0h,0FCh,0FEh
    db 0FCh,0F0h,0E0h,080h,000h,000h,000h,000h
    db 000h,000h,000h,002h,00Eh,03Eh,07Eh,0FEh
    db 07Eh,03Eh,00Eh,002h,000h,000h,000h,000h
    db 000h,000h,018h,03Ch,07Eh,018h,018h,018h
    db 018h,07Eh,03Ch,018h,000h,000h,000h,000h
    db 000h,000h,066h,066h,066h,066h,066h,066h
    db 066h,000h,066h,066h,000h,000h,000h,000h
    db 000h,000h,07Fh,0DBh,0DBh,0DBh,0DBh,07Bh
    db 01Bh,01Bh,01Bh,01Bh,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,060h,07Ch,0F6h
    db 0DEh,07Ch,00Ch,0C6h,0C6h,07Ch,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 0FEh,0FEh,0FEh,0FEh,000h,000h,000h,000h
    db 000h,000h,018h,03Ch,07Eh,018h,018h,018h
    db 07Eh,03Ch,018h,07Eh,000h,000h,000h,000h
    db 000h,000h,018h,03Ch,07Eh,018h,018h,018h
    db 018h,018h,018h,018h,000h,000h,000h,000h
    db 000h,000h,018h,018h,018h,018h,018h,018h
    db 018h,07Eh,03Ch,018h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,00Ch,00Eh,0FFh
    db 00Eh,00Ch,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,030h,070h,0FEh
    db 070h,030h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,0C0h,0C0h
    db 0C0h,0FEh,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,024h,066h,0FFh
    db 066h,024h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,010h,038h,038h,038h,07Ch
    db 07Ch,0FEh,0FEh,000h,000h,000h,000h,000h
    db 000h,000h,000h,0FEh,0FEh,07Ch,07Ch,07Ch
    db 038h,038h,010h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,018h,03Ch,03Ch,03Ch,03Ch,018h
    db 018h,000h,018h,018h,000h,000h,000h,000h
    db 000h,036h,036h,036h,036h,014h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,06Ch,06Ch,06Ch,0FEh,06Ch,06Ch
    db 0FEh,06Ch,06Ch,06Ch,000h,000h,000h,000h
    db 000h,000h,018h,018h,07Ch,0C6h,0C0h,078h
    db 03Ch,006h,0C6h,07Ch,018h,018h,000h,000h
    db 000h,000h,000h,000h,000h,062h,066h,00Ch
    db 018h,030h,066h,0C6h,000h,000h,000h,000h
    db 000h,000h,038h,06Ch,038h,030h,076h,07Eh
    db 0CCh,0CCh,0CCh,076h,000h,000h,000h,000h
    db 000h,00Ch,00Ch,00Ch,018h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,00Ch,018h,030h,030h,030h,030h
    db 030h,030h,018h,00Ch,000h,000h,000h,000h
    db 000h,000h,030h,018h,00Ch,00Ch,00Ch,00Ch
    db 00Ch,00Ch,018h,030h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,06Ch,038h,0FEh
    db 038h,06Ch,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,018h,018h,07Eh
    db 018h,018h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,00Ch,00Ch,00Ch,018h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,0FEh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,018h,018h,000h,000h,000h,000h
    db 000h,000h,000h,000h,002h,006h,00Ch,018h
    db 030h,060h,0C0h,080h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0CEh,0DEh,0F6h
    db 0E6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,018h,078h,018h,018h,018h,018h
    db 018h,018h,018h,07Eh,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,006h,00Ch,018h
    db 030h,060h,0C6h,0FEh,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,006h,006h,03Ch,006h
    db 006h,006h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,00Ch,01Ch,03Ch,06Ch,0CCh,0CCh
    db 0FEh,00Ch,00Ch,01Eh,000h,000h,000h,000h
    db 000h,000h,0FEh,0C0h,0C0h,0C0h,0FCh,006h
    db 006h,006h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C0h,0C0h,0FCh,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0FEh,0C6h,006h,00Ch,018h,030h
    db 030h,030h,030h,030h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,07Ch,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,0C6h,07Eh
    db 006h,006h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,00Ch,00Ch,000h
    db 000h,00Ch,00Ch,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,00Ch,00Ch,000h
    db 000h,00Ch,00Ch,00Ch,018h,000h,000h,000h
    db 000h,000h,000h,00Ch,018h,030h,060h,0C0h
    db 060h,030h,018h,00Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,0FEh,000h
    db 0FEh,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,060h,030h,018h,00Ch,006h
    db 00Ch,018h,030h,060h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,00Ch,018h,018h
    db 018h,000h,018h,018h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,0DEh,0DEh
    db 0DEh,0DCh,0C0h,07Eh,000h,000h,000h,000h
    db 000h,000h,038h,06Ch,0C6h,0C6h,0C6h,0FEh
    db 0C6h,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,0FCh,066h,066h,066h,07Ch,066h
    db 066h,066h,066h,0FCh,000h,000h,000h,000h
    db 000h,000h,03Ch,066h,0C2h,0C0h,0C0h,0C0h
    db 0C0h,0C2h,066h,03Ch,000h,000h,000h,000h
    db 000h,000h,0F8h,06Ch,066h,066h,066h,066h
    db 066h,066h,06Ch,0F8h,000h,000h,000h,000h
    db 000h,000h,0FEh,066h,060h,064h,07Ch,064h
    db 060h,060h,066h,0FEh,000h,000h,000h,000h
    db 000h,000h,0FEh,066h,060h,064h,07Ch,064h
    db 060h,060h,060h,0F0h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C0h,0C0h,0C0h
    db 0CEh,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0C6h,0C6h,0FEh,0C6h
    db 0C6h,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,03Ch,018h,018h,018h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,000h,03Ch,018h,018h,018h,018h,018h
    db 018h,0D8h,0D8h,070h,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0CCh,0D8h,0F0h,0F0h
    db 0D8h,0CCh,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,0F0h,060h,060h,060h,060h,060h
    db 060h,062h,066h,0FEh,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0EEh,0EEh,0FEh,0D6h
    db 0D6h,0D6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0E6h,0E6h,0F6h,0DEh
    db 0CEh,0CEh,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0FCh,066h,066h,066h,066h,07Ch
    db 060h,060h,060h,0F0h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0D6h,0D6h,07Ch,006h,000h,000h,000h
    db 000h,000h,0FCh,066h,066h,066h,07Ch,078h
    db 06Ch,066h,066h,0E6h,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C0h,0C0h,070h,01Ch
    db 006h,006h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,07Eh,05Ah,018h,018h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,06Ch,038h,010h,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0C6h,0D6h,0D6h,0D6h
    db 0FEh,0EEh,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,0C6h,0C6h,0C6h,06Ch,038h,038h
    db 06Ch,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,066h,066h,066h,066h,066h,03Ch
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,000h,0FEh,0C6h,086h,00Ch,018h,030h
    db 060h,0C2h,0C6h,0FEh,000h,000h,000h,000h
    db 000h,000h,07Ch,060h,060h,060h,060h,060h
    db 060h,060h,060h,07Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,080h,0C0h,060h,030h
    db 018h,00Ch,006h,002h,000h,000h,000h,000h
    db 000h,000h,07Ch,00Ch,00Ch,00Ch,00Ch,00Ch
    db 00Ch,00Ch,00Ch,07Ch,000h,000h,000h,000h
    db 000h,010h,038h,06Ch,0C6h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0FFh,000h,000h
    db 000h,018h,018h,018h,00Ch,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,000h,0E0h,060h,060h,07Ch,066h,066h
    db 066h,066h,066h,0FCh,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Ch,0C6h,0C0h
    db 0C0h,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,01Ch,00Ch,00Ch,07Ch,0CCh,0CCh
    db 0CCh,0CCh,0CCh,07Eh,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Ch,0C6h,0C6h
    db 0FEh,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,01Ch,036h,030h,030h,0FCh,030h
    db 030h,030h,030h,078h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,076h,0CEh,0C6h
    db 0C6h,0CEh,076h,006h,0C6h,07Ch,000h,000h
    db 000h,000h,0E0h,060h,060h,07Ch,066h,066h
    db 066h,066h,066h,0E6h,000h,000h,000h,000h
    db 000h,000h,018h,018h,000h,038h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,000h,00Ch,00Ch,000h,01Ch,00Ch,00Ch
    db 00Ch,00Ch,00Ch,0CCh,0CCh,078h,000h,000h
    db 000h,000h,0E0h,060h,060h,066h,066h,06Ch
    db 078h,06Ch,066h,0E6h,000h,000h,000h,000h
    db 000h,000h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,01Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,06Ch,0FEh,0D6h
    db 0D6h,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0DCh,066h,066h
    db 066h,066h,066h,066h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Ch,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0DCh,066h,066h
    db 066h,066h,07Ch,060h,060h,0F0h,000h,000h
    db 000h,000h,000h,000h,000h,076h,0CCh,0CCh
    db 0CCh,0CCh,07Ch,00Ch,00Ch,01Eh,000h,000h
    db 000h,000h,000h,000h,000h,0DCh,066h,060h
    db 060h,060h,060h,0F0h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Ch,0C6h,0C0h
    db 07Ch,006h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,030h,030h,030h,0FCh,030h,030h
    db 030h,030h,036h,01Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0CCh,0CCh,0CCh
    db 0CCh,0CCh,0CCh,076h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0C6h,0C6h,0C6h
    db 0C6h,06Ch,038h,010h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0C6h,0C6h,0D6h
    db 0D6h,0D6h,0FEh,06Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0C6h,0C6h,06Ch
    db 038h,06Ch,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0C6h,0C6h,0C6h
    db 0C6h,0CEh,076h,006h,0C6h,07Ch,000h,000h
    db 000h,000h,000h,000h,000h,0FEh,086h,00Ch
    db 018h,030h,062h,0FEh,000h,000h,000h,000h
    db 000h,000h,00Eh,018h,018h,018h,070h,018h
    db 018h,018h,018h,00Eh,000h,000h,000h,000h
    db 000h,000h,018h,018h,018h,018h,000h,018h
    db 018h,018h,018h,018h,000h,000h,000h,000h
    db 000h,000h,070h,018h,018h,018h,00Eh,018h
    db 018h,018h,018h,070h,000h,000h,000h,000h
    db 000h,000h,076h,0DCh,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,010h,038h,038h
    db 06Ch,06Ch,0FEh,000h,000h,000h,000h,000h
    db 000h,000h,03Ch,066h,0C0h,0C0h,0C0h,0C6h
    db 066h,03Ch,018h,00Ch,0CCh,038h,000h,000h
    db 000h,000h,0C6h,000h,000h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0CEh,076h,000h,000h,000h,000h
    db 000h,00Ch,018h,030h,000h,07Ch,0C6h,0C6h
    db 0FEh,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,030h,078h,0CCh,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,000h,0CCh,000h,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,060h,030h,018h,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,038h,06Ch,038h,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,000h,000h,000h,07Ch,0C6h,0C0h,0C0h
    db 0C6h,07Ch,018h,00Ch,06Ch,038h,000h,000h
    db 000h,030h,078h,0CCh,000h,07Ch,0C6h,0C6h
    db 0FEh,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0CCh,000h,000h,07Ch,0C6h,0C6h
    db 0FEh,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,030h,018h,00Ch,000h,07Ch,0C6h,0C6h
    db 0FEh,0C0h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,066h,000h,000h,038h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,018h,03Ch,066h,000h,038h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,038h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,0C6h,000h,038h,06Ch,0C6h,0C6h,0C6h
    db 0FEh,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 038h,06Ch,038h,000h,038h,06Ch,0C6h,0C6h
    db 0FEh,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 00Ch,018h,030h,000h,0FEh,060h,060h,07Ch
    db 060h,060h,060h,0FEh,000h,000h,000h,000h
    db 000h,000h,000h,000h,066h,0DBh,01Bh,07Fh
    db 0D8h,0D8h,0DFh,076h,000h,000h,000h,000h
    db 000h,000h,07Eh,0D8h,0D8h,0D8h,0D8h,0FEh
    db 0D8h,0D8h,0D8h,0DEh,000h,000h,000h,000h
    db 000h,030h,078h,0CCh,000h,07Ch,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,0C6h,000h,000h,07Ch,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,030h,018h,00Ch,000h,07Ch,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,030h,078h,0CCh,000h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0CEh,076h,000h,000h,000h,000h
    db 000h,060h,030h,018h,000h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0CEh,076h,000h,000h,000h,000h
    db 000h,018h,000h,03Ch,018h,018h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,0C6h,000h,07Ch,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,0C6h,000h,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,018h,018h,07Ch,0C6h,0C0h,0C0h
    db 0C6h,07Ch,018h,018h,000h,000h,000h,000h
    db 000h,038h,06Ch,060h,060h,0F0h,060h,060h
    db 060h,066h,0F6h,06Ch,000h,000h,000h,000h
    db 000h,066h,066h,066h,066h,03Ch,018h,07Eh
    db 018h,03Ch,018h,018h,000h,000h,000h,000h
    db 000h,000h,03Eh,063h,063h,030h,01Ch,006h
    db 063h,063h,03Eh,000h,01Ch,000h,000h,000h
    db 000h,000h,000h,000h,000h,03Eh,063h,038h
    db 00Eh,063h,03Eh,000h,01Ch,000h,000h,000h
    db 000h,00Ch,018h,030h,000h,078h,00Ch,07Ch
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,00Ch,018h,030h,000h,038h,018h,018h
    db 018h,018h,018h,03Ch,000h,000h,000h,000h
    db 000h,00Ch,018h,030h,000h,07Ch,0C6h,0C6h
    db 0C6h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,018h,030h,060h,000h,0CCh,0CCh,0CCh
    db 0CCh,0CCh,0DCh,076h,000h,000h,000h,000h
    db 000h,000h,076h,0DCh,000h,0BCh,066h,066h
    db 066h,066h,066h,0E6h,000h,000h,000h,000h
    db 000h,076h,0DCh,000h,0C6h,0C6h,0E6h,0F6h
    db 0DEh,0CEh,0C6h,0C6h,000h,000h,000h,000h
    db 000h,021h,01Eh,000h,01Eh,033h,060h,060h
    db 067h,063h,033h,01Dh,000h,000h,000h,000h
    db 000h,042h,03Ch,000h,03Bh,066h,066h,066h
    db 03Eh,006h,066h,03Ch,000h,000h,000h,000h
    db 000h,000h,030h,030h,000h,030h,030h,030h
    db 060h,0C6h,0C6h,07Ch,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,07Eh
    db 060h,060h,060h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,07Eh
    db 006h,006h,006h,000h,000h,000h,000h,000h
    db 000h,060h,060h,062h,066h,06Ch,018h,030h
    db 060h,0DCh,036h,00Ch,018h,03Eh,000h,000h
    db 000h,060h,060h,062h,066h,06Ch,018h,036h
    db 06Eh,0DEh,036h,07Eh,006h,006h,000h,000h
    db 000h,000h,018h,018h,000h,018h,018h,03Ch
    db 03Ch,03Ch,03Ch,018h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,036h,06Ch,0D8h
    db 06Ch,036h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0D8h,06Ch,036h
    db 06Ch,0D8h,000h,000h,000h,000h,000h,000h
    db 011h,044h,011h,044h,011h,044h,011h,044h
    db 011h,044h,011h,044h,011h,044h,011h,044h
    db 0AAh,055h,0AAh,055h,0AAh,055h,0AAh,055h
    db 0AAh,055h,0AAh,055h,0AAh,055h,0AAh,055h
    db 0DDh,077h,0DDh,077h,0DDh,077h,0DDh,077h
    db 0DDh,077h,0DDh,077h,0DDh,077h,0DDh,077h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,0F8h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,0F8h,018h,0F8h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 036h,036h,036h,036h,036h,036h,036h,0F6h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 000h,000h,000h,000h,000h,000h,000h,0FEh
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 000h,000h,000h,000h,000h,0F8h,018h,0F8h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 036h,036h,036h,036h,036h,0F6h,006h,0F6h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 000h,000h,000h,000h,000h,0FEh,006h,0F6h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,0F6h,006h,0FEh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 036h,036h,036h,036h,036h,036h,036h,0FEh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 018h,018h,018h,018h,018h,0F8h,018h,0F8h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,0F8h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,01Fh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 018h,018h,018h,018h,018h,018h,018h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,0FFh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,01Fh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 000h,000h,000h,000h,000h,000h,000h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 018h,018h,018h,018h,018h,018h,018h,0FFh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,01Fh,018h,01Fh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 036h,036h,036h,036h,036h,036h,036h,037h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,037h,030h,03Fh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,03Fh,030h,037h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,0F7h,000h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0FFh,000h,0F7h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,037h,030h,037h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 000h,000h,000h,000h,000h,0FFh,000h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 036h,036h,036h,036h,036h,0F7h,000h,0F7h
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 018h,018h,018h,018h,018h,0FFh,000h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 036h,036h,036h,036h,036h,036h,036h,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0FFh,000h,0FFh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 000h,000h,000h,000h,000h,000h,000h,0FFh
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,036h,036h,03Fh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 018h,018h,018h,018h,018h,01Fh,018h,01Fh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,01Fh,018h,01Fh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 000h,000h,000h,000h,000h,000h,000h,03Fh
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 036h,036h,036h,036h,036h,036h,036h,0FFh
    db 036h,036h,036h,036h,036h,036h,036h,036h
    db 018h,018h,018h,018h,018h,0FFh,018h,0FFh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,0F8h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,01Fh
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h
    db 0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h,0F0h
    db 00Fh,00Fh,00Fh,00Fh,00Fh,00Fh,00Fh,00Fh
    db 00Fh,00Fh,00Fh,00Fh,00Fh,00Fh,00Fh,00Fh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,076h,0DCh,0D8h,0D8h
    db 0D8h,0D8h,0DCh,076h,000h,000h,000h,000h
    db 000h,000h,078h,0CCh,0CCh,0D8h,0FCh,0C6h
    db 0C6h,0C6h,0C6h,0CCh,000h,000h,000h,000h
    db 000h,000h,0FEh,066h,062h,060h,060h,060h
    db 060h,060h,060h,060h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,0FEh,06Ch,06Ch
    db 06Ch,06Ch,06Ch,06Ch,000h,000h,000h,000h
    db 000h,000h,0FEh,0C6h,062h,030h,018h,018h
    db 030h,062h,0C6h,0FEh,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Eh,0D8h,0CCh
    db 0CCh,0CCh,0D8h,070h,000h,000h,000h,000h
    db 000h,000h,000h,000h,066h,066h,066h,066h
    db 066h,07Ch,060h,0C0h,080h,000h,000h,000h
    db 000h,000h,000h,000h,000h,076h,0DCh,018h
    db 018h,018h,018h,018h,000h,000h,000h,000h
    db 000h,000h,0FEh,038h,038h,06Ch,0C6h,0C6h
    db 06Ch,038h,038h,0FEh,000h,000h,000h,000h
    db 000h,000h,000h,038h,06Ch,0C6h,0C6h,0FEh
    db 0C6h,0C6h,06Ch,038h,000h,000h,000h,000h
    db 000h,000h,038h,06Ch,0C6h,0C6h,0C6h,0C6h
    db 06Ch,06Ch,06Ch,0EEh,000h,000h,000h,000h
    db 000h,000h,03Eh,060h,060h,03Ch,066h,0C6h
    db 0C6h,0C6h,0CCh,078h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Eh,0DBh,0DBh
    db 0DBh,07Eh,000h,000h,000h,000h,000h,000h
    db 000h,000h,002h,006h,07Ch,0CEh,0DEh,0F6h
    db 0F6h,07Ch,060h,0C0h,000h,000h,000h,000h
    db 000h,000h,000h,01Ch,030h,060h,060h,07Ch
    db 060h,060h,030h,01Ch,000h,000h,000h,000h
    db 000h,000h,07Ch,0C6h,0C6h,0C6h,0C6h,0C6h
    db 0C6h,0C6h,0C6h,0C6h,000h,000h,000h,000h
    db 000h,000h,000h,000h,0FEh,000h,000h,0FEh
    db 000h,000h,0FEh,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,018h,018h,07Eh,018h
    db 018h,000h,000h,07Eh,000h,000h,000h,000h
    db 000h,000h,030h,018h,00Ch,006h,00Ch,018h
    db 030h,000h,000h,07Eh,000h,000h,000h,000h
    db 000h,000h,00Ch,018h,030h,060h,030h,018h
    db 00Ch,000h,000h,07Eh,000h,000h,000h,000h
    db 000h,000h,000h,000h,00Ch,01Eh,01Ah,018h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,018h,018h,018h,018h,018h,018h
    db 018h,018h,058h,078h,030h,000h,000h,000h
    db 000h,000h,000h,000h,018h,018h,000h,07Eh
    db 000h,018h,018h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,076h,0DCh
    db 000h,076h,0DCh,000h,000h,000h,000h,000h
    db 000h,000h,078h,0CCh,0CCh,078h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,018h
    db 018h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 018h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,01Fh,018h,018h,018h,018h,018h
    db 0D8h,0D8h,078h,038h,018h,000h,000h,000h
    db 000h,000h,0D8h,06Ch,06Ch,06Ch,06Ch,06Ch
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,070h,0D8h,018h,030h,060h,0F8h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,07Eh,07Eh,07Eh
    db 07Eh,07Eh,07Eh,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
    db 000h,000h,000h,000h,000h,000h,000h,000h
initmsg	db 0Dh, 0Ah, '-*-*-*- ASM Hw2 3190104890 -*-*-*-', 0Dh, 0Ah, '$'
msg_1	db 'Input your string -> $'
buffer	db 100, 0, 100 dup(0)
data ends

code segment
	assume	cs:code, ds:data
main:
	mov	ax, data
	mov	ds, ax
	call	input_string
	mov	ax, 0A000h
	mov	es, ax
	mov	ax, 13h; switch to 320*200*256 graphic mode
	int	10h
	mov	ax, 0; x
	mov	bx, 0; y
	mov	si, 0
	push	bx
	push	ax
	push	si
again:
	pop	si
	mov	dl, buffer[si + 2]
	inc	si
	push	si
	cmp	dl, 0Dh; if its the end of string
	jz	done
	mov	dh, dl
	mov	cl, 04h
	shr	dh, cl
	shl	dl, cl
	mov	cx, 0
	add	cx, dx
	call	draw_a_char
	pop	si
	pop	ax
	add	ax, 08h
	push	ax
	cmp	ax, 0140h; 320
	jae	add_line	
	push	si
	jmp	again
add_line:
	pop	ax
	mov	ax, 0
	pop	bx
	add	bx, 10h
	push	bx
	push	ax
	push	si
	jmp	again
done:
	mov	ah, 1
	int	21h; AL=getchar()
	mov	ax, 03h; switch to text mode
	int	10h
	call	terminate

draw_a_char:
; parameter: ax(x, in stack), bx(y, in stack), cx(not in stack)
	mov	dx, 0
	add	dx, ax
	mov	ax, 0140h
	push	dx
	mul	bx
	pop	dx
	add	dx, ax
	mov	di, dx
	mov	ax, 11h; loop 16 times
	push	ax
draw_again:
	pop	ax
	dec	ax
	cmp	ax, 0
	jz	draw_done
	push	ax
	push	bx; protect bx
	mov	si, 0
	push	si
	push	di
	mov	di, cx
	mov	bl, asc[di]
	pop	di
point_again:
	rol	bl, 1
	mov	bh, 0
	push	bx
	and	bl, 01h
	cmp	bl, 0
	jz	blue
	jmp	red
blue:
	pop	bx
	push	di
	mov	di, dx
	mov	byte ptr es:[di], 01h
	pop	di
	jmp	no_red
red:		
	pop	bx
	push	di
	mov	di, dx
	mov	byte ptr es:[di], 0Ch
	pop	di
no_red:
	inc	dx
	inc	si
	cmp	si, 08h
	jb	point_again
	pop	si
	pop	bx; protect bx
	inc	cx
	add	dx, 0140h
	sub	dx, 08h
	jmp	draw_again
draw_done:
	ret

input_string:		; ============== Function: input_string
	mov	dx, offset initmsg
	mov	ah, 09h
	int	21h
	mov	dx, offset msg_1
	mov	ah, 09h
	int	21h
	mov	ah, 0Ah
	mov	dx, offset buffer
	int	21h
	ret

terminate:		; ============== Function: terminate
	mov	ah, 4Ch
	mov	al, 09h
	int	21h

code ends
	end main