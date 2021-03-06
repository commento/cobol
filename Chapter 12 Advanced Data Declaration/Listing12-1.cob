IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING12-1.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT BASEOILSALESFILE ASSIGN TO "Listing12-1.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT SUMMARYREPORT ASSIGN TO "Listing12-1.rpt"
           ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD     BASEOILSALESFILE.
01     SALESREC.
       88  ENDOFSALESFILE      VALUE HIGH-VALUES.
       02  CUSTOMERID          PIC X(5).
       02  CUSTOMERNAME        PIC X(20).
       02  OILDID.
           03 FILLER           PIC X.
           03 OILNUM           PIC 99.
       02  UNITSIZE            PIC 9.
       02  UNITSOLD            PIC 999.

FD     SUMMARYREPORT.
01     PRINTLINE               PIC X(45).

WORKING-STORAGE SECTION.
01     OILSTABLE.
       02  OILTABLEVALUES.
           03 FILLER PIC X(28)  VALUE "ALMOND          020003500650".
           03 FILLER PIC X(28)  VALUE "ALOE VERA       047508501625".
           03 FILLER PIC X(28)  VALUE "APRICOT KERNEL  025004250775".
           03 FILLER PIC X(28)  VALUE "AVOCADO         027504750875".
           03 FILLER PIC X(28)  VALUE "COCONUT         027504750895".
           03 FILLER PIC X(28)  VALUE "EVENING PRIMROSE037506551225".
           03 FILLER PIC X(28)  VALUE "GRAPE SEED      018503250600".
           03 FILLER PIC X(28)  VALUE "PEANUT          027504250795".
           03 FILLER PIC X(28)  VALUE "JOJOBA          072513252500".
           03 FILLER PIC X(28)  VALUE "MACADAMIA       032505751095".
           03 FILLER PIC X(28)  VALUE "ROSEHIP         052509951850".
           03 FILLER PIC X(28)  VALUE "SESAME          029504250750".
           03 FILLER PIC X(28)  VALUE "WALNUT          025045550825".
           03 FILLER PIC X(28)  VALUE "WHEATGERM       045007751427".
       02  FILLER REDEFINES OILTABLEVALUES.
           03 BASEOIL OCCURS 14 TIMES.
              04 OILNAME        PIC X(16).
              04 UNITCOST       PIC 99V99 OCCURS 3 TIMES.

01     REPORTHEADINGLINE        PIC X(41)
               VALUE  "AROMAMORA BASE OILDS SUMMARY SALES REPORT".

01     TOPICHEADINGLINE.
       02  FILLER               PIC X(9)   VALUE "CUST ID".
       02  FILLER               PIC X(15)  VALUE "CUSTOMER NAME".
       02  FILLER               PIC X(7)   VALUE SPACES.
       02  FILLER               PIC X(12)  VALUE "VALUEOFSALES".

01     REPORTFOOTERLINE         PIC X(43)
               VALUE "*************END OF REPORT ****************".

01     CUSTSALESLINE.
       02  PRNCUSTID            PIC B9(5).
       02  PRNCUSTNAME          PIC BBBX(20).
       02  PRNCUSTTOTALSALES    PIC BBB$$$$,$$9.99.

01     CUSTTOTALSALES           PIC 9(6)V99.
01     PREVCUSTID               PIC X(5).
01     VALUEOFSALES             PIC 9(5)V99.

PROCEDURE DIVISION.
PRINT-SUMMARY-REPORT.
       OPEN OUTPUT SUMMARYREPORT
       OPEN INPUT BASEOILSALESFILE

       WRITE PRINTLINE FROM REPORTHEADINGLINE AFTER ADVANCING 1 LINE
       WRITE PRINTLINE FROM TOPICHEADINGLINE  AFTER ADVANCING 2 LINES

       READ BASEOILSALESFILE
           AT END SET ENDOFSALESFILE TO TRUE
       END-READ

       PERFORM PRINTCUSTOMERLINES UNTIL ENDOFSALESFILE

       WRITE PRINTLINE FROM REPORTFOOTERLINE AFTER ADVANCING 3 LINES

       CLOSE SUMMARYREPORT, BASEOILSALESFILE
       STOP RUN.

PRINTCUSTOMERLINES.
       MOVE ZEROS TO CUSTTOTALSALES
       MOVE CUSTOMERID TO PRNCUSTID, PREVCUSTID
       MOVE CUSTOMERNAME TO PRNCUSTNAME

       PERFORM UNTIL CUSTOMERID NOT = PREVCUSTID
           COMPUTE VALUEOFSALES = UNITSOLD * UNITCOST(OILNUM, UNITSIZE)
           ADD VALUEOFSALES TO CUSTTOTALSALES
           READ BASEOILSALESFILE
               AT END SET ENDOFSALESFILE TO TRUE
           END-READ
       END-PERFORM

       MOVE CUSTTOTALSALES TO PRNCUSTTOTALSALES
       WRITE PRINTLINE FROM CUSTSALESLINE AFTER ADVANCING 2 LINES.
