-------------------------------------------------------------------------------------------------
-- ACCESS_LEVELS_TRUNC
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'ACCESS_LEVELS') BEGIN
	PRINT N'❌ TABLE [ACCESS_LEVELS] WAS NOT FOUND';
END ELSE BEGIN
	TRUNCATE TABLE [ACCESS_LEVELS];
	PRINT N'➕ TRUNCATE TABLE [ACCESS_LEVELS] IS COMPLETED';
END;

IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ INSERT IS ROLL-BACKED'
END;
