-------------------------------------------------------------------------------------------------
-- AGE_RESTRICTIONS_DROP
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

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'AGE_RESTRICTIONS') BEGIN
	PRINT N'❌ TABLE [AGE_RESTRICTIONS] WAS NOT FOUND';
END ELSE BEGIN
	DROP TABLE IF EXISTS [AGE_RESTRICTIONS];
	PRINT N'➕ DROP TABLE [AGE_RESTRICTIONS] IS COMPLETED';
END;

IF (@IS_COMMIT = 1) BEGIN
	COMMIT TRAN
	PRINT N'➕ DROP IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
	PRINT N'❌ DROP IS ROLL-BACKED'
END;
