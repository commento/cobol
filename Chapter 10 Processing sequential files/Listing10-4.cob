IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING10-4.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT MASTERSTOCKFILE ASSIGN TO "Listing10-3Master.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT NEWSTOCKFILE ASSIGN TO "Listing10-4NewMast.dat"
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
        88 ADDTOSTOCK          VALUE 4.
        88 SUBTRACTFROMSTOCK   VALUE 5.
       02 RECORDBODY-IR.
        03 GADGETID-TF         PIC 9(6).
        03 GADGETNAME-IR       PIC X(30).
        03 QTYINSTOCK-IR       PIC 9(4).
        03 PRICE-IR            PIC 9(4)V99.

01     DELETIONREC.
       02 FILLER               PIC 9(7).

01     PRICECHANGEREC.
       02 FILLER               PIC 9(7).
       02 PRICE-PCR            PIC 9(4)V99.

01     ADDTOSTOCKREC.
       02 FILLER               PIC 9(7).
       02 QTYTOADD             PIC 9(4).

01     SUBTRACTFROMSTOCKREC.
       02 FILLER               PIC 9(7).
       02 QTYTOSUBTRACT        PIC 9(4).

WORKING-STORAGE SECTION.
01     ERRORMESSAGE.
       02 PRNGADGETID          PIC 9(6).
       02 FILLER               PIC XXX VALUE " - ".
       02 FILLER               PIC X(45).
        88 INSERTERROR         VALUE "INSERT ERROR - RECORD ALREADY EXISTS".
        88 DELETEERROR         VALUE "DELETE ERROR - NO SUCH RECORD IN MASTER".
        88 PRICEUPDATEERROR    VALUE "PRICE UPDATE ERROR - NO SUCH RECORD IN MASTER".
        88 ADDTOSTOCKERROR     VALUE "ADD TO STOCK ERROR - NO SUCH RECORD IN MASTER".
        88 SUBFROMSTOCKERROR   VALUE "SUB FROM STOCK ERROR - NO SUCH RECORD IN MASTER".

01     FILLER                  PIC X VALUE "n".
       88 RECORDINMASTER       VALUE "y".
       88 RECORDNOTINMASTER    VALUE "n".

01     CURRENTKEY              PIC 9(6).

PROCEDURE DIVISION.
BEGIN.
       OPEN INPUT MASTERSTOCKFILE
       OPEN INPUT TRANSACTIONFILE
       OPEN OUTPUT NEWSTOCKFILE
       PERFORM READMASTERFILE
       PERFORM READTRANSFILE
       PERFORM CHOOSENEXTKEY
       PERFORM UNTIL ENDOFMASTERFILE AND ENDOFTRANSFILE
           PERFORM SETINITIALSTATUS
           PERFORM PROCESSONETRANSACTION UNTIL GADGETID-TF NOT = CURRENTKEY
           IF RECORDINMASTER
               WRITE NEWSTOCKREC
           END-IF
           PERFORM CHOOSENEXTKEY
       END-PERFORM

       CLOSE MASTERSTOCKFILE, TRANSACTIONFILE, NEWSTOCKFILE
       STOP RUN.

CHOOSENEXTKEY.
       IF GADGETID-TF > GADGETID-MF
           MOVE GADGETID-TF TO CURRENTKEY
       ELSE
           MOVE GADGETID-MF TO CURRENTKEY
       END-IF.

SETINITIALSTATUS.
       IF GADGETID-MF = CURRENTKEY
           MOVE MASTERSTOCKREC TO NEWSTOCKREC
           SET RECORDINMASTER TO TRUE
           PERFORM READMASTERFILE
       ELSE
           SET RECORDNOTINMASTER TO TRUE
       END-IF.

PROCESSONETRANSACTION.
       EVALUATE TRUE
           WHEN UPDATEPRICE       PERFORM APPLYINSERTION
           WHEN DELETION          PERFORM APPLYPRICECHANGE
           WHEN INSERTION         PERFORM APPLYDELETION
           WHEN ADDTOSTOCK        PERFORM APPLYADDTOSTOCK
           WHEN SUBTRACTFROMSTOCK PERFORM APPLYSUBTRACTFROMSTOCK
       END-EVALUATE
       PERFORM READTRANSFILE.

APPLYINSERTION.
       IF RECORDINMASTER
           SET INSERTERROR TO TRUE
           DISPLAY ERRORMESSAGE
       ELSE
           SET RECORDINMASTER TO TRUE
           MOVE RECORDBODY-IR TO NEWSTOCKREC
       END-IF.

APPLYDELETION.
       IF RECORDNOTINMASTER
           SET DELETEERROR TO TRUE
           DISPLAY ERRORMESSAGE
       ELSE SET RECORDNOTINMASTER TO TRUE
       END-IF.

APPLYPRICECHANGE.
       IF RECORDNOTINMASTER
           SET PRICEUPDATEERROR TO TRUE
           DISPLAY ERRORMESSAGE
       ELSE
           MOVE PRICE-PCR TO PRICE-NSF
       END-IF.

APPLYADDTOSTOCK.
       IF RECORDNOTINMASTER
           SET ADDTOSTOCKERROR TO TRUE
           DISPLAY ERRORMESSAGE
       ELSE
           ADD QTYTOADD TO QTYINSTOCK-NSF
       END-IF.

APPLYSUBTRACTFROMSTOCK.
       IF RECORDNOTINMASTER
           SET SUBFROMSTOCKERROR TO TRUE
           DISPLAY ERRORMESSAGE
       ELSE
           SUBTRACT QTYTOSUBTRACT FROM QTYINSTOCK-NSF
       END-IF.


READTRANSFILE.
       READ TRANSACTIONFILE
           AT END SET ENDOFTRANSFILE TO TRUE
       END-READ
       MOVE GADGETID-TF TO PRNGADGETID.

READMASTERFILE.
       READ MASTERSTOCKFILE
           AT END SET ENDOFMASTERFILE TO TRUE
       END-READ.