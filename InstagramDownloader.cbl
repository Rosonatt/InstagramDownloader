       IDENTIFICATION DIVISION.
       PROGRAM-ID. InstagramDownloader.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 OUTPUT-DIR PIC X(20) VALUE "downloads".
       77 CONTENT-TYPE PIC X(10).
       77 URL PIC X(100).
       77 COMMAND PIC X(200).
       77 RESULT PIC X(100).
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "Instagram Downloader".
           
           PERFORM UNTIL 1 = 0
               DISPLAY "Tipo (reel/video/photo): " WITH NO ADVANCING
               ACCEPT CONTENT-TYPE
               MOVE FUNCTION LOWER-CASE(CONTENT-TYPE) TO CONTENT-TYPE
               
               IF CONTENT-TYPE NOT = "reel" AND 
                  CONTENT-TYPE NOT = "video" AND
                  CONTENT-TYPE NOT = "photo" THEN
                  DISPLAY "Tipo inválido!"
                  GO TO NEXT-ITERATION
               END-IF
               
               DISPLAY "URL: " WITH NO ADVANCING
               ACCEPT URL
               MOVE FUNCTION LOWER-CASE(URL) TO URL
               
               IF URL = "sair" OR URL = "exit" THEN
                  EXIT PERFORM
               END-IF
               
               PERFORM DOWNLOAD-CONTENT
               
               DISPLAY RESULT
           END-PERFORM.
           STOP RUN.
           
       DOWNLOAD-CONTENT.
           IF CONTENT-TYPE = "reel" THEN
              IF URL(1:26) NOT = "https://www.instagram.com/reel/" AND
                 URL(1:25) NOT = "http://www.instagram.com/reel/" THEN
                 MOVE "URL inválida para reel" TO RESULT
                 EXIT PARAGRAPH
              END-IF
           ELSE IF CONTENT-TYPE = "video" THEN
              IF URL(1:24) NOT = "https://www.instagram.com/p/" AND
                 URL(1:23) NOT = "http://www.instagram.com/p/" THEN
                 MOVE "URL inválida para video" TO RESULT
                 EXIT PARAGRAPH
              END-IF
           ELSE
              IF URL(1:24) NOT = "https://www.instagram.com/p/" AND
                 URL(1:23) NOT = "http://www.instagram.com/p/" THEN
                 MOVE "URL inválida para photo" TO RESULT
                 EXIT PARAGRAPH
              END-IF
           END-IF.
           
           STRING "yt-dlp -o " DELIMITED BY SIZE
                  OUTPUT-DIR DELIMITED BY SPACE
                  "/%(title)s.%(ext)s " DELIMITED BY SIZE
                  URL DELIMITED BY SIZE
                  INTO COMMAND.
           
           CALL "SYSTEM" USING COMMAND.
           MOVE "Download completo" TO RESULT.
           
       NEXT-ITERATION.
           CONTINUE.