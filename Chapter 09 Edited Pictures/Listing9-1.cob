IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING9-1.

DATA DIVISION.
WORKING-STORAGE SECTION.
01     NUMERICVALUE    PIC S9(8)V99 VALUE 00014584.95.
01     EDIT1           PIC 99,999,999.99.
01     EDIT2           PIC ZZ,ZZZ,ZZ9.99.
01     EDIT3           PIC $*,***,**9.99.
01     EDIT4           PIC ++,+++,++9.99.
01     EDIT5           PIC $$,$$$,$$9.99.
01     EDIT6           PIC $$,$$$,$$9.00.
01     EDIT7           PIC 99/999/999/99.
01     EDIT8           PIC 99999000999.99.
01     EDIT9           PIC 99999BBB999.99.

PROCEDURE DIVISION.
BEGIN.
       DISPLAY "NUMERICVALUE = " NUMERICVALUE

       MOVE NUMERICVALUE TO EDIT1
       DISPLAY "EDIT1 = " EDIT1

       MOVE NUMERICVALUE TO EDIT2
       DISPLAY "EDIT2 = " EDIT2

       MOVE NUMERICVALUE TO EDIT3
       DISPLAY "EDIT3 = " EDIT3

       MOVE NUMERICVALUE TO EDIT4
       DISPLAY "EDIT4 = " EDIT4

       MOVE NUMERICVALUE TO EDIT5
       DISPLAY "EDIT5 = " EDIT5

       MOVE NUMERICVALUE TO EDIT6
       DISPLAY "EDIT6 = " EDIT6

       MOVE NUMERICVALUE TO EDIT7
       DISPLAY "EDIT7 = " EDIT7

       MOVE NUMERICVALUE TO EDIT8
       DISPLAY "EDIT8 = " EDIT8

       MOVE NUMERICVALUE TO EDIT9
       DISPLAY "EDIT9 = " EDIT9

       STOP RUN.
