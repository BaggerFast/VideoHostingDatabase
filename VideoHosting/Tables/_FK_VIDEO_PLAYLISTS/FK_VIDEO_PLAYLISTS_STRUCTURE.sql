-----------------------------------------------------------------------------------------------
-- FK_VIDEO_PLAYLISTS_STRUCTURE
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

IF EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = N'FK_VIDEO_PLAYLISTS') BEGIN
	PRINT N'❌ TABLE [FK_VIDEO_PLAYLISTS] IS ALREADY EXISTS';
END ELSE BEGIN
	PRINT N'➕ TABLE [FK_VIDEO_PLAYLISTS] IS NOT EXISTS AND WILL BE CREATED';
    CREATE TABLE [FK_VIDEO_PLAYLISTS] (
		[UID] UNIQUEIDENTIFIER NOT NULL,
        [VIDEO_UID] UNIQUEIDENTIFIER NOT NULL,
        [PLAYLIST_UID] UNIQUEIDENTIFIER NOT NULL, 
	);
    PRINT N'➕ TABLE [FK_VIDEO_PLAYLISTS] WAS CREATED';
END;

-- PRIMARY KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_TYPE] = 'PRIMARY KEY' AND [TABLE_NAME] = N'FK_VIDEO_PLAYLISTS') BEGIN
    ALTER TABLE [FK_VIDEO_PLAYLISTS] ADD CONSTRAINT [PK_FK_VIDEO_PLAYLISTS_UID] PRIMARY KEY CLUSTERED ([UID] ASC)
        PRINT N'➕ PRIMARY KEY [PK_FK_VIDEO_PLAYLISTS_UID] WAS CREATED';
END;

-- FOREIGN KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_VIDEO_PLAYLISTS_VIDEO_UID') BEGIN
	ALTER TABLE [FK_VIDEO_PLAYLISTS] ADD CONSTRAINT [FK_VIDEO_PLAYLISTS_VIDEO_UID] 
        FOREIGN KEY([VIDEO_UID]) REFERENCES [VIDEOS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_VIDEO_PLAYLISTS_VIDEO_UID] WAS CREATED';
END;
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_VIDEO_PLAYLISTS_PLAYLIST_UID') BEGIN
	ALTER TABLE [FK_VIDEO_PLAYLISTS] ADD CONSTRAINT [FK_VIDEO_PLAYLISTS_PLAYLIST_UID] 
		FOREIGN KEY([PLAYLIST_UID]) REFERENCES [PLAYLISTS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_VIDEO_PLAYLISTS_PLAYLIST_UID] WAS CREATED';
END;

-- UNIQUE
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'UQ_VIDEO_PLAYLISTS_VIDEO_PLAYLIST_UID' AND [TABLE_NAME] = N'FK_VIDEO_PLAYLISTS') BEGIN
    ALTER TABLE [FK_VIDEO_PLAYLISTS] ADD CONSTRAINT [UQ_VIDEO_PLAYLISTS_VIDEO_PLAYLIST_UID] UNIQUE([VIDEO_UID], [PLAYLIST_UID])
    PRINT N'➕ UNIQUE KEY [UQ_VIDEO_PLAYLISTS_VIDEO_PLAYLIST_UID] WAS CREATED';
END;

--DEFAULT
IF NOT EXISTS (SELECT 1 FROM [SYS].[DEFAULT_CONSTRAINTS] WHERE [NAME] = 'DF_FK_VIDEO_PLAYLISTS_UID') BEGIN
	ALTER TABLE [FK_VIDEO_PLAYLISTS] ADD CONSTRAINT [DF_FK_VIDEO_PLAYLISTS_UID] DEFAULT (NEWID()) FOR [UID];
	PRINT N'➕ DEFAULT KEY [DF_FK_VIDEO_PLAYLISTS_UID] WAS CREATED';
END;

IF (@IS_COMMIT = 1) BEGIN
	COMMIT TRAN
	PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
	PRINT N'❌ INSERT IS ROLL-BACKED'
END;
