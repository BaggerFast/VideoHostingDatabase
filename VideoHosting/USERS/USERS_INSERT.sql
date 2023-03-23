-------------------------------------------------------------------------------------------------
-- USERS_INSERT
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'USERS') BEGIN
	PRINT N'❌ TABLE [USERS] WAS NOT FOUND';
END ELSE BEGIN
    -- CREATE VARIABLES
    DECLARE @USERNAME NVARCHAR(32);
    DECLARE @EMAIL NVARCHAR(50);
    DECLARE @BIRTHDAY_DT DATE;

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [USERNAME] NVARCHAR(32) NOT NULL,
            [EMAIL] NVARCHAR(50) NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/users.csv'
        WITH (
	        FIRSTROW = 2,
	        FIELDTERMINATOR = ';',
	        ROWTERMINATOR = '\n'
        );
        PRINT N'➕ CREATE TEMP TABLES IS SUCCESS'
    END;

    -- INSERT TABLE
    BEGIN
        DECLARE CUR CURSOR FOR SELECT [USERNAME], [EMAIL] FROM #CSV;
        OPEN CUR;
        FETCH NEXT FROM CUR INTO @USERNAME, @EMAIL;
        WHILE @@FETCH_STATUS = 0 BEGIN
            SET @BIRTHDAY_DT = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '2000-01-01');
            MERGE INTO [USERS] AS [USER] 
                USING (VALUES (@USERNAME, @EMAIL)) AS [NEW_USER] ([USERNAME], [EMAIL])
                ON [USER].[USERNAME] = [NEW_USER].[USERNAME]
                WHEN NOT MATCHED THEN
                    INSERT ([USERNAME], [EMAIL], [BIRTHDAY_DT]) VALUES (@USERNAME, @EMAIL, @BIRTHDAY_DT);
            FETCH NEXT FROM CUR INTO @USERNAME, @EMAIL;
        END;
        CLOSE CUR;
        DEALLOCATE CUR;

        PRINT N'➕ INSERT IS SUCCESS'
    END;
    DROP TABLE IF EXISTS #CSV;
    PRINT N'➕ DROP TEMP TABLES IS SUCCESS'
END;


IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ INSERT IS ROLL-BACKED'
END;
