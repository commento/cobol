IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING13-8.

DATA DIVISION.
WORKING-STORAGE SECTION.
01     NUMBERARRAY.
       02  NUM             PIC 99 OCCURS 10 TIMES INDEXED BY NIDX.

01     FIRSTZEROPOS        PIC 99 VALUE ZERO.
       88 NOZEROS          VALUE 0.

01     SECONDZEROPOS       PIC 99 VALUE ZERO.
       88 ONEZERO          VALUE 0.

01     VALUESBETWEENZEROS   PIC 9 VALUE ZERO.
       88 NONEBETWEENZEROS VALUE 0.

PROCEDURE DIVISION.
BEGIN.
       DISPLAY "ENTER 10 TWO DIGITS NUMBERS "
       PERFORM VARYING NIDX FROM 1 BY 1 UNTIL NIDX > 10
           DISPLAY "ENTER NUMBER - " SPACE WITH NO ADVANCING
           ACCEPT NUM(NIDX)
       END-PERFORM

       SET NIDX TO 1
       SEARCH NUM AT END SET NOZEROS TO TRUE
           WHEN NUM(NIDX) = ZERO
               SET FIRSTZEROPOS TO NIDX
               SET NIDX UP BY 1
               SEARCH NUM AT END SET ONEZERO TO TRUE
                   WHEN NUM(NIDX) = ZERO
                       SET SECONDZEROPOS TO NIDX
                       COMPUTE VALUESBETWEENZEROS = (SECONDZEROPOS - 1) - FIRSTZEROPOS
               END-SEARCH
       END-SEARCH

       EVALUATE TRUE
           WHEN NOZEROS            DISPLAY "NO ZERO FOUND"
           WHEN ONEZERO            DISPLAY "ONLY ONE ZERO FOUND"
           WHEN NONEBETWEENZEROS   DISPLAY "NO NUMBER BETWEEN TWO ZEROS"
           WHEN FUNCTION REM(VALUESBETWEENZEROS, 2) = ZERO
                                   DISPLAY "EVEN NUMBER OF NON-ZEROS BETWEEN ZEROS"
           WHEN OTHER              DISPLAY "ODD NUMBER OF NON-ZEROS BETWEEN ZEROS" 
       END-EVALUATE
       STOP RUN.