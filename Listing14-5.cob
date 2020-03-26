IDENTIFICATION DIVISION.
PROGRAM-ID. LISTING14-5.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT WORKFILE ASSIGN TO "WORK.TMP"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT BILLABLESERVICEFILE ASSIGN TO "Listing14-1.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

       SELECT SORTEDSUMMARYFILE ASSIGN TO "Listing14-5.srt"
           ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD     BILLABLESERVICEFILE.
01     SUBSCRIBERREC-BSF           PIC X(17).

SD     WORKFILE.
01     WORKREC.
       88  ENDOFWORKFILE           VALUE HIGH-VALUES.
       02  SUBSCRIBERID-WF         PIC X(10).
       02  FILLER                  PIC 9.
           88  TEXTCALL            VALUE 1.
           88  VOICECALL           VALUE 2.
       02  SERVICECOST-WF          PIC 9(4)V99.

FD     SORTEDSUMMARYFILE.
01     SUMMARYREC.
       02  SUBSCRIBERID            PIC 9(10).
       02  COSTOFTEXTS             PIC 9(4)V99.
       02  COSTOFCALLS             PIC 9(6)V99.

PROCEDURE DIVISION.
BEGIN.
       SORT WORKFILE ON ASCENDING KEY SUBSCRIBERID-WF
           USING BILLABLESERVICEFILE
           OUTPUT PROCEDURE IS CREATESUMMARYFILE
       STOP RUN.

CREATESUMMARYFILE.
       OPEN OUTPUT SORTEDSUMMARYFILE
       RETURN WORKFILE AT END SET ENDOFWORKFILE TO TRUE
       END-RETURN
       PERFORM UNTIL ENDOFWORKFILE
           MOVE ZEROS TO COSTOFTEXTS, COSTOFCALLS
           MOVE SUBSCRIBERID-WF TO SUBSCRIBERID
           PERFORM UNTIL SUBSCRIBERID-WF NOT EQUAL TO SUBSCRIBERID
               IF VOICECALL
                   ADD SERVICECOST-WF TO COSTOFCALLS
               ELSE
                   ADD SERVICECOST-WF TO COSTOFTEXTS
               END-IF
               RETURN WORKFILE AT END SET ENDOFWORKFILE TO TRUE
               END-RETURN
           END-PERFORM
           WRITE SUMMARYREC
       END-PERFORM
       CLOSE SORTEDSUMMARYFILE.

