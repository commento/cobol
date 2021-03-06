IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING13-4.

DATA DIVISION.
WORKING-STORAGE SECTION.
01     JEANSSALESTABLE.
       02  SHOP OCCURS 150 TIMES INDEXED BY SHOPIDX.
           03  SHOPNAME            PIC X(15)   VALUE SPACES.
           03  JEANSCOLOR OCCURS 3 TIMES INDEXED BY COLORIDX.
               04  TOTALSOLD       PIC 9(5)    VALUE ZEROS.

01     SHOPQUERY                   PIC X(15).

01     PRNWHITEJEANS.
       02  PRNWHITETOTAL           PIC ZZ,ZZ9.
       02  FILLER                  PIC X(12)   VALUE " WHITE JEANS".

01     PRNBLUEJEANS.
       02  PRNBLUETOTAL           PIC ZZ,ZZ9.
       02  FILLER                  PIC X(12)   VALUE " BLUE JEANS".

01     PRNBLACKJEANS.
       02  PRNBLACKTOTAL           PIC ZZ,ZZ9.
       02  FILLER                  PIC X(12)   VALUE " BLACK JEANS".

PROCEDURE DIVISION.
BEGIN.
       MOVE "JEAN THERAPY" TO SHOPNAME(3), SHOPQUERY
       MOVE 00734 TO TOTALSOLD(3,1)
       MOVE 04075 TO TOTALSOLD(3,2)
       MOVE 01187 TO TOTALSOLD(3,3)

       SET SHOPIDX TO 1
       SEARCH SHOP AT END DISPLAY "SHOP NOT FOUND"
           WHEN SHOPNAME(SHOPIDX) = SHOPQUERY
               MOVE TOTALSOLD(SHOPIDX,1) TO PRNWHITETOTAL
               MOVE TOTALSOLD(SHOPIDX,2) TO PRNBLUETOTAL
               MOVE TOTALSOLD(SHOPIDX,3) TO PRNBLACKTOTAL
               DISPLAY "SOLD BY " SHOPQUERY
               DISPLAY PRNWHITETOTAL
               DISPLAY PRNBLUETOTAL
               DISPLAY PRNBLACKTOTAL
       END-SEARCH
       STOP RUN.
