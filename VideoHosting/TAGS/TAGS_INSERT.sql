-------------------------------------------------------------------------------------------------
-- TAGS_INSERT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @IS_COMMIT BIT = 1;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

BEGIN TRAN
PRINT N'➕ JOB IS STARTED';

-- CREATE VARIABLES 
DECLARE @TITLE NVARCHAR(10);

-- CREATE TMP TABLES
BEGIN 
    DROP TABLE IF EXISTS #CSV;
    CREATE TABLE #CSV (
        [TITLE] NVARCHAR(10) NOT NULL,
    );
    BULK INSERT #CSV FROM '/DataCsv/tags.csv'
    WITH (
	    FIRSTROW = 2,
	    FIELDTERMINATOR = ';',
	    ROWTERMINATOR = '\n'
    );
    PRINT N'➕ CREATE TEMP TABLES IS SUCCESS'
END;

-- INSERT TABLE
BEGIN
    DECLARE CUR CURSOR FOR SELECT [TITLE] FROM #CSV;
    OPEN CUR;
    FETCH NEXT FROM CUR INTO @TITLE;
    WHILE @@FETCH_STATUS = 0 BEGIN
        MERGE INTO [TAGS] AS [TG] 
            USING (VALUES (@TITLE)) AS [NEW_TG] ([TITLE])
            ON [TG].[TITLE] = [NEW_TG].[TITLE]
            WHEN NOT MATCHED THEN
                INSERT ([TITLE]) VALUES ([NEW_TG].[TITLE]);
        FETCH NEXT FROM CUR INTO @TITLE;
    END;
    CLOSE CUR;
    DEALLOCATE CUR;

    PRINT N'➕ INSERT IS SUCCESS'
END;

DROP TABLE IF EXISTS #CSV;
PRINT N'➕ DROP TEMP TABLES IS SUCCESS'

IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ JOB IS ROLL-BACKED'
END;
