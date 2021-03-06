IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING10-3.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT MASTERSTOCKFILE ASSIGN TO "Listing10-3Master.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT NEWSTOCKFILE ASSIGN TO "Listing10-3NewMast.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT TRANSACTIONFILE ASSIGN TO "Listing10-3Trans.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD     MASTERSTOCKFILE.
01     MASTERSTOCKREC.
       88 ENDOFMASTERFILE      VALUE HIGH-VALUES.
       02 GADGETID-MF          PIC 9(6).
       02 GADGETNAME-MF        PIC X(30).
       02 QTYINSTOCK-MF        PIC 9(4).
       02 PRICE-MF             PIC 9(4)V99.

FD     NEWSTOCKFILE.
01     NEWSTOCKREC.
       02 GADGETID-NSF         PIC 9(6).
       02 GADGETNAME-NSF       PIC X(30).
       02 QTYINSTOCK-NSF       PIC 9(4).
       02 PRICE-NSF            PIC 9(4)V99.

FD     TRANSACTIONFILE.
01     INSERTIONREC.
       88 ENDOFTRANSFILE       VALUE HIGH-VALUES.
       02 TYPECODE-TF          PIC 9.
        88 INSERTION           VALUE 1.
        88 DELETION            VALUE 2.
        88 UPDATEPRICE         VALUE 3.
       02 GADGETID-TF          PIC 9(6).
       02 GADGETNAME-IR        PIC X(30).
       02 QTYINSTOCK-IR        PIC 9(4).
       02 PRICE-IR             PIC 9(4)V99.

01     DELETIONREC.
       02 FILLER               PIC 9(7).

01     PRICECHANGEREC.
       02 FILLER               PIC 9(7).
       02 PRICE-PCR            PIC 9(4)V99.

WORKING-STORAGE SECTION.
01     ERRORMESSAGE.
       02 PRNGADGETID          PIC 9(6).
       02 FILLER               PIC XXX VALUE " - ".
       02 FILLER               PIC X(45).
        88 INSERTERROR         VALUE "INSERT ERROR - RECORD ALREADY EXISTS".
        88 DELETEERROR         VALUE "DELETE ERROR - NO SUCH RECORD IN MASTER".
        88 PRICEUPDATEERROR    VALUE "PRICE UPDATE ERROR - NO SUCH RECORD IN MASTER".

PROCEDURE DIVISION.
BEGIN.
       OPEN INPUT MASTERSTOCKFILE
       OPEN INPUT TRANSACTIONFILE
       OPEN OUTPUT NEWSTOCKFILE
       PERFORM READMASTERFILE
       PERFORM READTRANSFILE
       PERFORM UNTIL ENDOFMASTERFILE AND ENDOFTRANSFILE
           EVALUATE TRUE
               WHEN GADGETID-TF > GADGETID-MF PERFORM COPYTONEWMASTER
               WHEN GADGETID-TF = GADGETID-MF PERFORM TRYTOAPPLYTOMASTER
               WHEN GADGETID-TF < GADGETID-MF PERFORM TRYTOINSERT
           END-EVALUATE
       END-PERFORM

       CLOSE MASTERSTOCKFILE, TRANSACTIONFILE, NEWSTOCKFILE
       STOP RUN.

COPYTONEWMASTER.
       WRITE NEWSTOCKREC FROM MASTERSTOCKREC
       PERFORM READMASTERFILE.
 
TRYTOAPPLYTOMASTER.
       EVALUATE TRUE
           WHEN UPDATEPRICE MOVE PRICE-PCR TO PRICE-MF
           WHEN DELETION    PERFORM READMASTERFILE
           WHEN INSERTION   SET INSERTERROR TO TRUE DISPLAY ERRORMESSAGE
       END-EVALUATE
       PERFORM READTRANSFILE.

TRYTOINSERT.
       IF INSERTION    MOVE GADGETID-TF TO GADGETID-NSF
                       MOVE GADGETNAME-IR TO GADGETNAME-NSF
                       MOVE QTYINSTOCK-IR TO QTYINSTOCK-NSF
                       MOVE PRICE-IR TO PRICE-NSF
                       WRITE NEWSTOCKREC
       ELSE
           IF UPDATEPRICE
               SET PRICEUPDATEERROR TO TRUE
           END-IF
           IF DELETION
               SET DELETEERROR TO TRUE
           END-IF
           DISPLAY ERRORMESSAGE
       END-IF
       PERFORM READTRANSFILE.

READTRANSFILE.
       READ TRANSACTIONFILE
           AT END SET ENDOFTRANSFILE TO TRUE
       END-READ
       MOVE GADGETID-TF TO PRNGADGETID.

READMASTERFILE.
       READ MASTERSTOCKFILE
           AT END SET ENDOFMASTERFILE TO TRUE
       END-READ.
