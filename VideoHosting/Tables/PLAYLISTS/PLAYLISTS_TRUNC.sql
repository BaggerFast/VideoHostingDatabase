-------------------------------------------------------------------------------------------------
-- PLAYLISTS_TRUNC
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'PLAYLISTS') BEGIN
	PRINT N'❌ TABLE [PLAYLISTS] WAS NOT FOUND';
END ELSE BEGIN
	TRUNCATE TABLE [PLAYLISTS];
	PRINT N'➕ TRUNC TABLE [PLAYLISTS] IS COMPLETED';
END;

IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ TRUNC IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ TRUNC IS ROLL-BACKED'
END;
