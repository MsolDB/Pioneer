@ECHO OFF

CD "S:\DATABASES\PIONEER CREDIT\DAILY LETTERS WORKFLOW\2 Processing"
s:

REM Only continue if files have finished processing
IF NOT EXIST "*.PROCESS_COMPLETE" EXIT 1

copy "*.PROCESS_COMPLETE" "*.PROCESS_COMPLETE_1"

REM Copy log files to RTS Log File directory then delete the originals
copy "*_LOG.txt" "..\..\DAILY RETURN MAIL\LOG FILES"
DEL /Q "*_LOG.txt"

REM Change to the RTS Log File directory for the rest of the processing
cd "..\..\DAILY RETURN MAIL\LOG FILES"

REM Make a backup of the ALL RECORDS file
ren "Pioneer Daily - ALL RECORDS LOG FILE.txt" "Pioneer Daily - ALL RECORDS LOG FILE_BACKUP.txt"

REM Append the log files to the end of the ALL RECORDS file
copy /b "Pioneer Daily - ALL RECORDS LOG FILE_BACKUP.txt"+"*_LOG.txt" "Pioneer Daily - ALL RECORDS LOG FILE.txt"

REM Move the ALL RECORDS backup file to the backup directory
move "Pioneer Daily - ALL RECORDS LOG FILE_BACKUP.txt" BACKUP

REM Delete the 2 daily log files once they have finished being appended
DEL /Q "*_LOG.txt"

REM keep cmd window open until user is ready 
REM PAUSE

REM all done!
EXIT 0
