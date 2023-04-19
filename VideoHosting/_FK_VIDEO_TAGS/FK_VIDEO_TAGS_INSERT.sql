-------------------------------------------------------------------------------------------------
-- FK_VIDEO_TAGS_INSERT
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'FK_VIDEO_TAGS') BEGIN
	PRINT N'❌ TABLE [FK_VIDEO_TAGS] WAS NOT FOUND';
END ELSE BEGIN
    -- CREATE VARIABLES
    DECLARE @TAG NVARCHAR(32);
    DECLARE @VIDEO NVARCHAR(100);

    DECLARE @TAG_UID UNIQUEIDENTIFIER;
    DECLARE @VIDEO_UID UNIQUEIDENTIFIER;

    -- CREATE TMP TABLES
    BEGIN 
        DROP TABLE IF EXISTS #CSV;
        CREATE TABLE #CSV (
            [TAG] NVARCHAR(32) NOT NULL,
            [VIDEO] NVARCHAR(100) NOT NULL,
        );
        BULK INSERT #CSV FROM '/DataCsv/fk_video_tags.csv'
        WITH (
	        FIRSTROW = 2,
            ROWTERMINATOR = '\n',
	        FIELDTERMINATOR = ';',
            DATAFILETYPE = 'WideChar'
        );
        PRINT N'➕ CREATE TEMP TABLES IS SUCCESS';
    END;

    -- INSERT TABLE
    BEGIN
        DECLARE CUR CURSOR FOR SELECT [TAG], [VIDEO] FROM #CSV;
        OPEN CUR;
        FETCH NEXT FROM CUR INTO @TAG, @VIDEO;
        WHILE @@FETCH_STATUS = 0 BEGIN
            SET @TAG_UID = (SELECT [UID] FROM [TAGS] WHERE [TITLE] = @TAG);
            SET @VIDEO_UID = (SELECT [UID] FROM [VIDEOS] WHERE [TITLE] = @VIDEO);
            IF NOT EXISTS (SELECT 1 FROM [FK_VIDEO_TAGS] WHERE [TAG_UID] = @TAG_UID AND [VIDEO_UID] = @VIDEO_UID)
                INSERT INTO [FK_VIDEO_TAGS] ([TAG_UID], [VIDEO_UID]) VALUES (@TAG_UID, @VIDEO_UID);
            FETCH NEXT FROM CUR INTO @TAG, @VIDEO;
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
