-----------------------------------------------------------------------------------------------
-- REACTIONS_STRUCTURE
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

IF EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = N'REACTIONS') BEGIN
	PRINT N'❌ TABLE [REACTIONS] IS ALREADY EXISTS';
END ELSE BEGIN
	PRINT N'➕ TABLE [REACTIONS] IS NOT EXISTS AND WILL BE CREATED';
    CREATE TABLE [REACTIONS] (
		[UID] UNIQUEIDENTIFIER NOT NULL,
        [IS_LIKED] BIT NOT NULL,
        [USER_UID] UNIQUEIDENTIFIER NOT NULL, 
        [VIDEO_UID] UNIQUEIDENTIFIER NOT NULL,
        [CREATED_DT] DATETIME NOT NULL,
	);
    PRINT N'➕ TABLE [REACTIONS] WAS CREATED';
END;

-- PRIMARY KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_TYPE] = 'PRIMARY KEY' AND [TABLE_NAME] = N'REACTIONS') BEGIN
    ALTER TABLE [REACTIONS] ADD CONSTRAINT [PK_REACTIONS_UID] PRIMARY KEY CLUSTERED ([UID] ASC)
        PRINT N'➕ PRIMARY KEY [PK_REACTIONS_UID] WAS CREATED';
END;

-- FOREIGN KEY
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_REACTIONS_USER_UID') BEGIN
	ALTER TABLE [REACTIONS] ADD CONSTRAINT [FK_REACTIONS_USER_UID] 
        FOREIGN KEY([USER_UID]) REFERENCES [USERS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_REACTIONS_USER_UID] WAS CREATED';
END;
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'FK_REACTIONS_VIDEO_UID') BEGIN
	ALTER TABLE [REACTIONS] ADD CONSTRAINT [FK_REACTIONS_VIDEO_UID] 
		FOREIGN KEY([VIDEO_UID]) REFERENCES [VIDEOS] ([UID]);
	PRINT N'➕ FOREIGN KEY [FK_REACTIONS_VIDEO_UID] WAS CREATED';
END;

-- UNIQUE
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [CONSTRAINT_NAME] = 'UQ_REACTIONS_VIDEO_USER_UID' AND [TABLE_NAME] = N'REACTIONS') BEGIN
    ALTER TABLE [REACTIONS] ADD CONSTRAINT [UQ_REACTIONS_VIDEO_USER_UID] UNIQUE([VIDEO_UID], [USER_UID])
    PRINT N'➕ UNIQUE KEY [UQ_REACTIONS_VIDEO_USER_UID] WAS CREATED';
END;

-- DEFAULT
IF NOT EXISTS (SELECT 1 FROM [SYS].[DEFAULT_CONSTRAINTS] WHERE [NAME] = 'DF_REACTIONS_UID') BEGIN
	ALTER TABLE [REACTIONS] ADD CONSTRAINT [DF_REACTIONS_UID] DEFAULT (NEWID()) FOR [UID];
	PRINT N'➕ DEFAULT KEY [DF_REACTIONS_UID] WAS CREATED';
END;
IF NOT EXISTS (SELECT 1 FROM [SYS].[DEFAULT_CONSTRAINTS] WHERE [NAME] = 'DF_REACTIONS_CREATED_DT') BEGIN
    ALTER TABLE [REACTIONS] ADD CONSTRAINT [DF_REACTIONS_CREATED_DT] DEFAULT (GETDATE()) FOR [CREATED_DT];
    PRINT N'➕ DEFAULT KEY [DF_REACTIONS_CREATED_DT] WAS CREATED';
END;

IF (@IS_COMMIT = 1) BEGIN
	COMMIT TRAN
	PRINT N'➕ STRUCTURE IS COMMITTED';
END ELSE BEGIN
    ROLLBACK TRAN
	PRINT N'❌ STRUCTURE IS ROLL-BACKED';
END;
