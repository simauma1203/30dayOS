;naskfunc

[FORMAT "WCOFF"] ;オブジェクトファイル作成モード
[INSTRSET "i486p"] ;486の命令も使いたい
[BITS 32] ;32bitモードの機械語
[FILE "naskfunc.nas] ;ソースファイル名

    GLOBAL _io_hlt,_write_mem8 ;このプログラムに含まれる関数名

[SECTION .text] ;

_io_hlt: ; void io_hlt(void);
    HLT
    RET

_write_mem8: ;void write_mem8(int addr,int data);
    MOV ECX,[ESP+4] ;[ESP+4にaddrがあるのでecxによみこむ
    MOV AL,[ESP+8] ;[ESP+8]にdataがあるのでALに読み込む
    MOV [ECX],AL
    RET
