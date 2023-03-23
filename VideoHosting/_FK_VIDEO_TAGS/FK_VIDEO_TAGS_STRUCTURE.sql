-----------------------------------------------------------------------------------------------
-- FK_VIDEO_TAGS_STRUCTURE
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

IF EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = N'FK_VIDEO_TAGS') BEGIN
	PRINT N'❌ TABLE [FK_VIDEO_TAGS] IS ALREADY EXISTS';
END ELSE BEGIN
	PRINT N'➕ TABLE [FK_VIDEO_TAGS] IS NOT EXISTS AND WILL BE CREATED';
    CREATE TABLE [FK_VIDEO_TAGS] (
		[UID] UNIQUEIDENTIFIER NOT NULL,
        [TAG_UID] UNIQUEIDENTIFIER NOT NULL, 
        [VIDEO_UID] UNIQUEIDENTIFIER NOT NULL,
	);
    PRINT N'➕ TABLE [FK_VIDEO_TAGS] WAS CREATED';
END;

-- PRIMARY KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_TYPE] = 'PRIMARY KEY' AND [TABLE_NAME] = N'FK_VIDEO_TAGS') BEGIN
    ALTER TABLE [FK_VIDEO_TAGS] ADD CONSTRAINT [PK_FK_VIDEO_TAGS_UID] PRIMARY KEY CLUSTERED ([UID] ASC)
        PRINT N'➕ PRIMARY KEY [PK_FK_VIDEO_TAGS_UID] WAS CREATED';
END;

-- FOREIGN KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_VIDEO_TAGS_VIDEO_UID') BEGIN
	ALTER TABLE [FK_VIDEO_TAGS] ADD CONSTRAINT [FK_VIDEO_TAGS_VIDEO_UID] 
        FOREIGN KEY([VIDEO_UID]) REFERENCES [VIDEOS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_VIDEO_TAGS_VIDEO_UID] WAS CREATED';
END;
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_VIDEO_TAGS_TAG_UID') BEGIN
	ALTER TABLE [FK_VIDEO_TAGS] ADD CONSTRAINT [FK_VIDEO_TAGS_TAG_UID] 
		FOREIGN KEY([TAG_UID]) REFERENCES [TAGS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_VIDEO_TAGS_TAG_UID] WAS CREATED';
END;

-- UNIQUE
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'UQ_VIDEO_TAGS_VIDEO_TAG_UID' AND [TABLE_NAME] = N'FK_VIDEO_TAGS') BEGIN
    ALTER TABLE [FK_VIDEO_TAGS] ADD CONSTRAINT [UQ_VIDEO_TAGS_VIDEO_TAG_UID] UNIQUE([VIDEO_UID], [TAG_UID])
    PRINT N'➕ UNIQUE KEY [UQ_VIDEO_TAGS_VIDEO_TAG_UID] WAS CREATED';
END;

-- DEFAULT
IF NOT EXISTS (SELECT 1 FROM [SYS].[DEFAULT_CONSTRAINTS] WHERE [NAME] = 'DF_FK_VIDEO_TAGS_UID') BEGIN
	ALTER TABLE [FK_VIDEO_TAGS] ADD CONSTRAINT [DF_FK_VIDEO_TAGS_UID] DEFAULT (NEWID()) FOR [UID];
	PRINT N'➕ DEFAULT KEY [DF_FK_VIDEO_TAGS_UID] WAS CREATED';
END;

IF (@IS_COMMIT = 1) BEGIN
	COMMIT TRAN
	PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
	PRINT N'❌ INSERT IS ROLL-BACKED'
END;
