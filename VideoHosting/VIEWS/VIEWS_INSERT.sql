-------------------------------------------------------------------------------------------------
-- VIEWS_INSERT
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'VIEWS') BEGIN
	PRINT N'❌ TABLE [VIEWS] WAS NOT FOUND';
END ELSE BEGIN
    -- CREATE VARIABLES
    DECLARE @USERNAME NVARCHAR(32);
    DECLARE @VIDEO NVARCHAR(100);
    
    DECLARE @USER_UID UNIQUEIDENTIFIER;
    DECLARE @VIDEO_UID UNIQUEIDENTIFIER;

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [USERNAME] NVARCHAR(32) NOT NULL,
            [VIDEO] NVARCHAR(100) NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/views.csv'
        WITH (
	        FIRSTROW = 2,
	        FIELDTERMINATOR = ';',
	        ROWTERMINATOR = '\n',
            DATAFILETYPE = 'WideChar'
        );
        PRINT N'➕ CREATE TEMP TABLES IS SUCCESS'
    END;

    -- INSERT TABLE
    BEGIN
        DECLARE CUR CURSOR FOR SELECT [USERNAME], [VIDEO] FROM #CSV;
        OPEN CUR;
        FETCH NEXT FROM CUR INTO @USERNAME, @VIDEO;
        WHILE @@FETCH_STATUS = 0 BEGIN
            SET @USER_UID = (SELECT [UID] FROM [USERS] WHERE [USERNAME] = @USERNAME);
            SET @VIDEO_UID = (SELECT [UID] FROM [VIDEOS] WHERE [TITLE] = @VIDEO);
            MERGE INTO [VIEWS] AS [VIEW] 
                USING (VALUES (@USER_UID, @VIDEO_UID)) AS [NEW_VIEW] ([USER_UID], [VIDEO_UID])
                ON [VIEW].[USER_UID] = [NEW_VIEW].[USER_UID] AND [VIEW].[VIDEO_UID] = [NEW_VIEW].[VIDEO_UID]
                WHEN NOT MATCHED THEN
                    INSERT ([VIDEO_UID], [USER_UID]) VALUES (@VIDEO_UID, @USER_UID);
            FETCH NEXT FROM CUR INTO @USERNAME, @VIDEO;
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
