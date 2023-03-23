-------------------------------------------------------------------------------------------------
-- ACCESS_LEVELS_INSERT
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] =  N'ACCESS_LEVELS') BEGIN
	PRINT N'❌ TABLE [ACCESS_LEVELS] IS NOT EXISTS';
END ELSE BEGIN
	-- CREATE VARIABLES 
    DECLARE @TITLE NVARCHAR(30);

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [TITLE] NVARCHAR(30) NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/access_levels.csv'
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
            MERGE INTO [ACCESS_LEVELS] AS [AL] 
                USING (VALUES (@TITLE)) AS [NEW_AL] ([TITLE])
                ON [AL].[TITLE] = [NEW_AL].[TITLE]
                WHEN NOT MATCHED THEN
                    INSERT ([TITLE]) VALUES (@TITLE);
            FETCH NEXT FROM CUR INTO @TITLE;
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