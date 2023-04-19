-------------------------------------------------------------------------------------------------
-- VIDEOS_INSERT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @IS_COMMIT BIT = 0;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

BEGIN TRAN
PRINT N'➕ JOB IS STARTED';

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'VIDEOS') BEGIN
	PRINT N'❌ TABLE [VIDEOS] WAS NOT FOUND';
END ELSE BEGIN
    -- CREATE VARIABLES
    DECLARE @TITLE NVARCHAR(100);
    DECLARE @DESCRIPTION NVARCHAR(250);
    DECLARE @CREATED_DT DATETIME;

    DECLARE @USER_UID UNIQUEIDENTIFIER;
    DECLARE @ACCESS_UID UNIQUEIDENTIFIER;
    DECLARE @AGE_UID UNIQUEIDENTIFIER;

    DECLARE @USERNAME NVARCHAR(32);
    DECLARE @ACCESS NVARCHAR(50);
    DECLARE @AGE TINYINT;
    DECLARE @PATH NVARCHAR(100);
    DECLARE @RAND_GUID UNIQUEIDENTIFIER;

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [USERNAME] NVARCHAR(50) NOT NULL, 
		    [TITLE] NVARCHAR(100) NOT NULL,
            [DESCRIPTION] NVARCHAR(250) NULL,
            [ACCESS] NVARCHAR(25) NOT NULL,
            [AGE] TINYINT NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/videos.csv'
        WITH (
	        FIRSTROW = 2,
	        FIELDTERMINATOR = ';',
	        ROWTERMINATOR = '\n',
            DATAFILETYPE = 'WideChar'
        );
        PRINT N'➕ CREATE TEMP TABLES IS SUCCESS';
    END;

    -- INSERT TABLE
    BEGIN
        DECLARE CUR CURSOR FOR SELECT [USERNAME], [TITLE], [DESCRIPTION], [ACCESS], [AGE] FROM #CSV;
        OPEN CUR;
        FETCH NEXT FROM CUR INTO @USERNAME, @TITLE, @DESCRIPTION, @ACCESS, @AGE;
        WHILE @@FETCH_STATUS = 0 BEGIN
        
            SET @CREATED_DT = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '2003-01-01');
            SET @ACCESS_UID = (SELECT [UID] FROM [ACCESS_LEVELS] WHERE [TITLE] = @ACCESS);
            SET @USER_UID = (SELECT [UID] FROM [USERS] WHERE [USERNAME] = @USERNAME);
            SET @AGE_UID = (SELECT [UID] FROM [AGE_RESTRICTIONS] WHERE [AGE] = @AGE);
            SET @RAND_GUID = NEWID();
            SET @PATH = N'opt/mnt/videos/' + CAST(@RAND_GUID AS NVARCHAR(255)) + N'.mp4';
            IF NOT EXISTS (SELECT 1 FROM [VIDEOS] WHERE [TITLE] = @TITLE AND [USER_UID] = @USER_UID)
            BEGIN
                INSERT INTO [VIDEOS] ([USER_UID], [ACCESS_UID], [AGE_RESTRICTIONS_UID], [CREATED_DT], [PATH], [TITLE], [DESCRIPTION])
                    VALUES (@USER_UID, @ACCESS_UID, @AGE_UID, @CREATED_DT, @PATH, @TITLE, @DESCRIPTION);
            END;
            FETCH NEXT FROM CUR INTO @USERNAME, @TITLE, @DESCRIPTION, @ACCESS, @AGE;
        END;
        CLOSE CUR;
        DEALLOCATE CUR;
        PRINT N'➕ INSERT IS SUCCESS';
    END;
    DROP TABLE IF EXISTS #CSV;
    PRINT N'➕ DROP TEMP TABLES IS SUCCESS';
END;


IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ INSERT IS COMMITTED';
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ JOB IS ROLL-BACKED';
END;