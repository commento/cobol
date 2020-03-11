IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING7-5.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT GADGETSTOCKFILE ASSIGN TO "GadgetStock.dat"
           ORGANIZATION IS SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD     GADGETSTOCKFILE.
01     STOCKREC.
       88  ENDOFSTOCKFILE VALUE HIGH-VALUES.
       02  GADGETID    PIC 9(6).
       02  GADGETNAME  PIC X(30).
       02  QTYINSTOCK  PIC 9(4).
       02  PRICE       PIC 9(4)V99.

WORKING-STORAGE SECTION.
01     PRNSTOCKVALUE.
       02 PRNGADGETNAME    PIC X(30).
       02 FILLER           PIC XX VALUE SPACES.
       02 PRNVALUE         PIC $$$,$$9.99.

01     PRNFINALSTOCKTOTAL.
       02 FILLER           PIC X(16) VALUE SPACES.
       02 FILLER           PIC X(16) VALUE "STOCK TOTAL:".
       02 PRNFINALTOTAL    PIC $$$,$$9.99.

01     FINALSTOCKTOTAL     PIC 9(6)V99 VALUE ZEROS.
01     STOCKVALUE          PIC 9(6)V99 VALUE ZEROS.
PROCEDURE DIVISION.

BEGIN.
       OPEN EXTEND GADGETSTOCKFILE
       MOVE "313245Spy Pen - HD Video Camera     0125003099" TO STOCKREC
       WRITE STOCKREC
       MOVE "593486Scout Cash Capsule - Red      1234000745" TO STOCKREC
       WRITE STOCKREC
       CLOSE GADGETSTOCKFILE

       OPEN INPUT GADGETSTOCKFILE.
       READ GADGETSTOCKFILE AT END SET ENDOFSTOCKFILE TO TRUE
       END-READ

       PERFORM DISPLAYGADGETVALUES UNTIL ENDOFSTOCKFILE
       MOVE FINALSTOCKTOTAL TO PRNFINALTOTAL
       DISPLAY PRNFINALSTOCKTOTAL
       CLOSE GADGETSTOCKFILE.
       STOP RUN.

DISPLAYGADGETVALUES.
       COMPUTE STOCKVALUE = PRICE * QTYINSTOCK
       ADD STOCKVALUE TO FINALSTOCKTOTAL
       MOVE GADGETNAME TO PRNGADGETNAME
       MOVE STOCKVALUE TO PRNVALUE
       DISPLAY PRNSTOCKVALUE
       READ GADGETSTOCKFILE
           AT END SET ENDOFSTOCKFILE TO TRUE
       END-READ.
