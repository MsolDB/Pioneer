@ECHO OFF

REM make temp copy of passphrase in data folder
REM Backup pgp file to TEMP folder
REM Decrypt pgp file(s)
REM Remove temp files

CD "S:\DATABASES\PIONEER CREDIT\DAILY LETTERS WORKFLOW\LIVE - CURRENT PRODUCTION JOB FILES\"
s:

@ECHO OFF

REM Example file
IF NOT EXIST "..\1 Input Files\*.pgp" EXIT 1

COPY "DO NOT TOUCH - blur.txt" "..\1 Input Files\blur.txt"
CD "..\1 Input Files"
COPY *.pgp TEMP

REM Added 01/03/2018 to copy input file to RTC folder so we can get the filename to use when archiving
REM COPY *.pgp "..\4 Return to client"
REM End

for %%f in (*.pgp) do GPG --batch --passphrase-file blur.txt --output "%%~nf" -d "%%f"

DEL blur.txt
DEL *.pgp

REM Added 01/03/2018 to copy input file to RTC folder so we can get the filename to use when archiving
REM CD "..\4 Return to client"
REM Remove file extensions
REM RENAME *.txt.pgp *.
REM RENAME *.txt *.
REM End

EXIT 0
