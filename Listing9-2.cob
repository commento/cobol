IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING9-2.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
       CURRENCY SIGN IS "€".

DATA DIVISION.
WORKING-STORAGE SECTION.
01     EDIT1   PIC €€€,€€9.99.

PROCEDURE DIVISION.
BEGIN.
       MOVE 12345.95 TO EDIT1
       DISPLAY "EDIT1 = " EDIT1
       STOP RUN.
