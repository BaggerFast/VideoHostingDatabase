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

-- CREATE VARIABLES
DECLARE @AGE TINYINT;

-- CREATE TMP TABLES
BEGIN 
    DROP TABLE IF EXISTS #CSV;
    CREATE TABLE #CSV (
        [AGE] TINYINT NOT NULL,
    );
    BULK INSERT #CSV FROM 'age_restrictions.csv'
    WITH (
	    FIRSTROW = 2,
	    FIELDTERMINATOR = ';',
	    ROWTERMINATOR = '0x0A'
    );
    PRINT N'➕ CREATE TEMP TABLES IS SUCCESS'
END;

-- INSERT TABLE
BEGIN
    DECLARE CUR CURSOR FOR SELECT [AGE] FROM #CSV;
    OPEN CUR;
    FETCH NEXT FROM CUR INTO @AGE;
    WHILE @@FETCH_STATUS = 0 BEGIN
        MERGE INTO [AGE_RESTRICTIONS] AS [AGES] 
            USING (VALUES (@AGE)) AS [NEW_AGES] ([AGE])
            ON [AGES].[AGE] = [NEW_AGES].[AGE]
            WHEN NOT MATCHED THEN
                INSERT ([UID], [AGE]) VALUES (NEWID(), [NEW_AGES].[AGE]);
        FETCH NEXT FROM CUR INTO @AGE;
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
