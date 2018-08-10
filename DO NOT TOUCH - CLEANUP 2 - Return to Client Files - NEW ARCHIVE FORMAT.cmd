@ECHO OFF

CD "S:\DATABASES\PIONEER CREDIT\DAILY LETTERS WORKFLOW\"
s:

REM Only continue if files have finished processing
IF NOT EXIST "2 Processing\*.PROCESS_COMPLETE_1" EXIT 1

copy "2 Processing\*.PROCESS_COMPLETE_1" "2 Processing\*.PROCESS_COMPLETE_2"

copy "2 Processing\*_RTC.*" "4 Return to client\*_RTC.csv"

REM change to input files directory
CD "4 Return to client"
REM CD test

REM Changed from copying individual pdfs to copy just the zipped up files
REM REM Copy pdf files to Remakes folder
REM copy *.pdf "..\6 Remakes\*.pdf"

rem set the file name for the zip file
REM ** set file=DEBTOR*
set file=*.csv

FOR %%i IN ("%file%") DO (
echo %%~ni
set zipfile=%%~ni_ARCHIVE.zip
)

REM ** DEL DEBTOR*

dir /b *.pdf >tempfilelist.txt
dir /b *.csv >>tempfilelist.txt

REM Zip up pdf & csv files ready for encrypting
"C:\Program Files\7-Zip\7z.exe" a -tzip "%zipfile%" @tempfilelist.txt

del tempfilelist.txt

REM Changed from copying individual pdfs to copy just the zipped up files
REM Copy zip file to Remakes folder
REM copy *.zip "..\6 Remakes\*.zip"

rem encrypt the zip file ready for sending to Pioneer
for %%f in (*.zip) do GPG --recipient "Pioneer" --recipient "David Bell" --local-user "David Bell" --encrypt --cipher-algo AES256 --output "%%f.pgp" "%%f"

REM Using gpg command line to encrypt and sign the return to client zip file using both our & Pioneer's keys with AES256 encryption
REM --recipient   (These are the people to encrypt the file for)
REM --local-user  (This is who is signing the file)
REM --encrypt     (Tell gpg to encrypt the file)
REM --cipher-algo (This is the encryption method - we use AES256 as this is how the client supplies files to us)
REM --output      (This is the output file name)
REM The final argument is the name of the file you want to encrypt



REM Cleanup up the directory so only the pgp file is left
DEL *.pdf
DEL *.xls
DEL *.csv
DEL *.zip


REM Update 16/02/2018 - We have created an SFTP drop folder for Pioneer Credit so we can move the pgp files there ready for collection by Pioneer
move *.pgp S:\SFTP\PioneerCredit

REM all done!
EXIT 0
