IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING8-2.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT SHOPRECEIPTSFILE ASSIGN TO "Listing8-2-ShopSales.dat"
            ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD     SHOPRECEIPTSFILE.
01     SHOPDETAILS.
       88 ENDOFSHOPRECEIPTSFILE    VALUE HIGH-VALUES.
       02 RECTYPECODE      PIC X.
           88  SHOPHEADER  VALUE "H".
           88  SHOPSALE    VALUE "S".
           88  SHOPFOOTER  VALUE "F".
       02 SHOPID           PIC X(5).
       02 SHOPLOCATION     PIC X(30).
01     SALERECEIPT.
       02 RECTYPECODE      PIC X.
       02 ITEMID           PIC X(8).
       02 QTYSOLD          PIC 9(3).
       02 ITEMCOST         PIC 999V99.

01     SHOPSALESCOUNT.
       02 RECTYPECODE      PIC X.
       02 RECCOUNT          PIC 9(5).

WORKING-STORAGE SECTION.
01     PRNSHOPSALESTOTAL.
       02 FILLER           PIC X(21) VALUE "TOTAL SALES FOR SHOP ".
       02 PRNSHOPID        PIC X(5).
       02 PRNSHOPTOTAL     PIC $$$$,$$9.99.

01     PRNERRORMESSAGE.
       02 FILLER           PIC X(15) VALUE "ERROR ON SHOP: ".
       02 PRNERRORSHOPID   PIC X(5).
       02 FILLER           PIC X(10) VALUE " RCOUNT = ".
       02 PRNRECCOUNT      PIC 9(5).
       02 FILLER           PIC X(10) VALUE " ACOUNT = ".
       02 PRNACTUALCOUNT   PIC 9(5).

01     SHOPTOTAL       PIC 9(5)V99.
01     ACTUALCOUNT     PIC 9(5).

PROCEDURE DIVISION.
SHOPSALESSUMMARY.
       OPEN INPUT SHOPRECEIPTSFILE
       PERFORM GETHEADERREC
       PERFORM SUMMARIZECONTRYSALES
           UNTIL ENDOFSHOPRECEIPTSFILE
       CLOSE SHOPRECEIPTSFILE
       STOP RUN.

SUMMARIZECONTRYSALES.
       MOVE SHOPID TO PRNSHOPID, PRNERRORSHOPID
       MOVE ZEROS TO SHOPTOTAL
       READ SHOPRECEIPTSFILE
           AT END SET ENDOFSHOPRECEIPTSFILE TO TRUE
       END-READ
       PERFORM SUMMARIZESHOPSALES
           VARYING ACTUALCOUNT FROM 0 BY 1 UNTIL SHOPFOOTER
       IF RECCOUNT = ACTUALCOUNT
           MOVE SHOPTOTAL TO PRNSHOPTOTAL
           DISPLAY PRNSHOPSALESTOTAL
       ELSE
           MOVE RECCOUNT TO PRNRECCOUNT
           MOVE ACTUALCOUNT TO PRNACTUALCOUNT
           DISPLAY PRNERRORMESSAGE
       END-IF
       PERFORM GETHEADERREC.

SUMMARIZESHOPSALES.
       COMPUTE SHOPTOTAL = SHOPTOTAL + (QTYSOLD * ITEMCOST)
       READ SHOPRECEIPTSFILE
           AT END SET ENDOFSHOPRECEIPTSFILE TO TRUE
       END-READ.

GETHEADERREC.
       READ SHOPRECEIPTSFILE
           AT END SET ENDOFSHOPRECEIPTSFILE TO TRUE
       END-READ.