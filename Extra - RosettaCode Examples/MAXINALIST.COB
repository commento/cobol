IDENTIFICATION DIVISION.
PROGRAM-ID. MAXINALIST.

DATA DIVISION.
WORKING-STORAGE SECTION.
01     NUMSTABLE.
       02  NUMVALUES.
           03  FILLER PIC X(60)
               VALUE "020103040506070809970203040506070809121314151655667788332435".
       02 FILLER REDEFINES NUMVALUES.
           03  NUMS OCCURS 30 TIMES INDEXED BY IDX.
               04  NUM       PIC 99.

01     MAX      PIC 99.

PROCEDURE DIVISION.
MAIN SECTION.
       MOVE NUM(1) TO MAX
       PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 30
           IF NUM(IDX) IS GREATER THAN MAX
               MOVE NUM(IDX) TO MAX
           END-IF
       END-PERFORM

       DISPLAY MAX
       STOP RUN.
