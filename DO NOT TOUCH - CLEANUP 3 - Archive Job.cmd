@ECHO OFF

REM Setup variables, paths, etc...

REM Update 16/02/2018
REM                     - DO NOT ARCHIVE Temp folders - they are for temporary storage only so no point archiving them
REM                     - DO NOT ARCHIVE RTC files - they are now moved to the SFTP folder for direct collection by the client
REM                     - DO ARCHIVE spool files - The size of spool files has been dramatically reduced so we may as well keep them for emergency use

CD "S:\DATABASES\PIONEER CREDIT\DAILY LETTERS WORKFLOW\"
s:

REM Only continue if files have finished processing
IF NOT EXIST "2 Processing\*.PROCESS_COMPLETE_2" EXIT 1

REM Copy report to spool files directory as a backup in case it gets cleaned up before printing
REM copy "2 Processing\Pioneer Daily Letter Report.csv" "3 Spool Files\"

date /t > tmpFile
set /p mydate= < tmpFile 
del tmpFile
echo %mydate%

SET tmp=%mydate:/=-%
SET tmp=%tmp:Mon= %
SET tmp=%tmp:Tue= %
SET tmp=%tmp:Wed= %
SET tmp=%tmp:Thu= %
SET tmp=%tmp:Fri= %
SET tmp=%tmp:Sat= %
SET tmp=%tmp:Sun= %
SET newdate=%tmp: =%

set arch_file= "5 Archive\%newdate% DAILY LETTERS.zip"

echo %arch_file%

REM Specify which directories to archive

ECHO "1 Input Files" >tempfilelist.txt
ECHO "2 Processing" >>tempfilelist.txt
ECHO "3 Spool Files" >>tempfilelist.txt
REM No longer archiving RTC files - They are MUCH too big since individual pdfs were introduced - Move to SFTP instead
REM ECHO "4 Return to client" >>tempfilelist.txt

REM Zip up the files using 7-zip command line archiver

"C:\Program Files\7-Zip\7z.exe" a -tzip %arch_file% @tempfilelist.txt

REM Cleanup folders after archive has been created

DEL tempfilelist.txt
CD "1 Input Files"
DEL /Q DEBTOR*.txt
CD ..
CD "3 Spool Files"
CD ..
REM ** DEL /Q *.ps
CD "2 Processing"
DEL /Q *_LOG.txt
DEL /Q *_RTC.txt
DEL /Q *_sorted.txt
DEL /Q *_unsorted.txt
DEL /Q *.pdf
DEL /Q *.lpf
DEL /Q *.csv
DEL /Q DEBTOR*.txt
DEL /Q *.PROCESS_COMPLETE*
DEL /Q TRIGGER
CD TEMP
DEL /Q *_orig.txt
CD ..
CD ..

REM Don't delete return to client files until they've been emailed
REM CD "4 Return to client"
REM DEL /Q *.*
REM CD..



REM keep cmd window open until user is ready 
REM PAUSE

REM all done!
EXIT 0
