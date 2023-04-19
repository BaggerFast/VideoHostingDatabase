-------------------------------------------------------------------------------------------------
-- COMMENTS_TRUNC
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'COMMENTS') BEGIN
	PRINT N'❌ TABLE [COMMENTS] WAS NOT FOUND';
END ELSE BEGIN
	TRUNCATE TABLE [COMMENTS];
	PRINT N'➕ TRUNC TABLE [COMMENTS] IS COMPLETED';
END;

IF (@IS_COMMIT = 1) BEGIN
    COMMIT TRAN
    PRINT N'➕ TRUNC IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
    PRINT N'❌ TRUNC IS ROLL-BACKED'
END;
