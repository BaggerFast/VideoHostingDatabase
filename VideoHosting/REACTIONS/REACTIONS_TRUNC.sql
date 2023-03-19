-------------------------------------------------------------------------------------------------
-- REACTIONS_TRUNC
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'REACTIONS') BEGIN
	PRINT N'❌ TABLE [REACTIONS] WAS NOT FOUND';
END ELSE BEGIN
	TRUNCATE TABLE [REACTIONS];
	PRINT N'➕ TRUNCATE TABLE [REACTIONS] IS COMPLETED';
END;

IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ INSERT IS ROLL-BACKED'
END;
