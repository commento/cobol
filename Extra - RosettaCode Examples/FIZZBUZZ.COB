IDENTIFICATION DIVISION.
PROGRAM-ID. FIZZBUZZ.

DATA DIVISION.
WORKING-STORAGE SECTION.

01     NUM     PIC 999.

PROCEDURE DIVISION.
MAIN SECTION.
       PERFORM VARYING NUM FROM 1 BY 1 UNTIL NUM > 100
       IF FUNCTION MOD(NUM, 15) = 0 DISPLAY "FIZZBUZZ"
       ELSE IF FUNCTION MOD(NUM, 3) = 0 DISPLAY "FIZZ"
       ELSE IF FUNCTION MOD(NUM, 5) = 0 DISPLAY "BUZZ"
       ELSE DISPLAY NUM
       END-IF
       END-PERFORM
       STOP RUN.
