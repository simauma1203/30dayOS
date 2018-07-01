;haribote-ipl

CYLS    EQU 10 ;どこまで読むか

        ORG 0x7c00

;FAT12 floppy disk
        JMP entry
        DB 0x90
        DB "HARIBOTE" ;boot sector name
        DW 512
        DB 1
        DW 1
        DB 2
        DW 224
        DW 2880
        DB 0xf0
        DW 9
        DW 18
        DW 2
        DD 0
        DD 2880
        DB 0,0,0x29
        DD 0xffffffff
        DB "HARIBOTEOS " ;disk name
        DB "FAT12   " ;format
        RESB 18


entry:
        MOV AX,0 ;init
        MOV SS,AX
        MOV SP,0x7c00
        MOV DS,AX

;read disk

        MOV AX,0x0820
        MOV ES,AX
        MOV CH,0 ;cylinder0
        MOV DH,0 ;head0
        MOV CL,2 ;sector2

readloop:
    MOV SI,0 ;失敗回数を数えるレジスタ

retry:
    MOV AH,0x02 ;AH=0x02 : read disk
    MOV AL,1 ;1sector
    MOV BX,0
    MOV DL,0x00 ;A drive
    INT 0x13 ;call disk BIOS
    JNC next ;エラーがおきなけれればfin
    ADD SI,1
    CMP SI,5
    JAE error ;SI>=5ならerror
    MOV AH,0x00
    MOV DL,0x00 ;A drive
    INT 0x13 ;reset drive
    JMP retry 
next:
    MOV AX,ES ;
    ADD AX,0x0020 ;
    MOV ES,AX ;ADD ES 0x20  0x20=512/16
    ADD CL,1
    CMP CL,18
    JBE readloop ;CL<=18ならreadloop
    MOV CL,1
    ADD DH,1
    CMP DH,2
    JB readloop ;DH<2なら
    MOV DH,0
    ADD CH,1
    CMP CH,CYLS
    JB readloop

; haribote.sysを実行
    
    MOV [0x0ff0],CH ;iplがどこまで読んだか
    JMP 0xc200

error:
    MOV SI,msg
    
putloop:
    MOV AL,[SI]
    ADD SI,1
    CMP AL,0
    JE fin
    MOV AH,0x0e ;print 1character
    MOV BX,15 ;color code
    INT 0x10 ;call video BIOS
    JMP putloop

;よみおわり
fin:
    HLT
    JMP fin

msg:
    DB 0x0a,0x0a ;LF*2
    DB "load error"
    DB 0x0a
    DB 0

    RESB 0x7dfe-$ ;0x7dfeまで0x00で埋める

    DB 0x55,0xaa



