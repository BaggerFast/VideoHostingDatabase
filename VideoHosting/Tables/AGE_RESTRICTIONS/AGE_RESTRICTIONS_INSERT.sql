-------------------------------------------------------------------------------------------------
-- AGE_RESTRICTIONS_INSERT
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'AGE_RESTRICTIONS') BEGIN
	PRINT N'❌ TABLE [AGE_RESTRICTIONS] WAS NOT FOUND';
END ELSE BEGIN
    -- CREATE VARIABLES
    DECLARE @AGE TINYINT;

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [AGE] TINYINT NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/age_restrictions.csv'
        WITH (
	        FIRSTROW = 2,
	        FIELDTERMINATOR = ';',
	        ROWTERMINATOR = '\n'
        );
        PRINT N'➕ CREATE TEMP TABLES IS SUCCESS';
    END;

    -- INSERT TABLE
    BEGIN
        DECLARE CUR CURSOR FOR SELECT [AGE] FROM #CSV;
        OPEN CUR;
        FETCH NEXT FROM CUR INTO @AGE;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF NOT EXISTS (SELECT 1 FROM [AGE_RESTRICTIONS] WHERE [AGE] = @AGE)
                INSERT INTO [AGE_RESTRICTIONS] ([AGE]) VALUES (@AGE);
            FETCH NEXT FROM CUR INTO @AGE;
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
    PRINT N'❌ INSERT IS ROLL-BACKED';
END;
