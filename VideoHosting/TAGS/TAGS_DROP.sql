-------------------------------------------------------------------------------------------------
-- TAGS_DROP
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @DB_NAME VARCHAR(128) = 'VideoHosting';
DECLARE @DB_NAME_CURRENT VARCHAR(128) = NULL;
DECLARE @IS_COMMIT BIT = 0;
-------------------------------------------------------------------------------------------------
BEGIN TRAN
SET @DB_NAME_CURRENT = (SELECT DB_NAME());
IF NOT (@DB_NAME_CURRENT = @DB_NAME) BEGIN
	PRINT N'➕ CURRENT DB IS NOT CORRECT: ' + @DB_NAME_CURRENT;
END ELSE BEGIN
    PRINT N'➕ CURRENT DB IS CORRECT: ' + @DB_NAME_CURRENT;
    IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'TAGS') BEGIN
		PRINT N'❌ TABLE [TAGS] WAS NOT FOUND';
	END ELSE BEGIN
		DROP TABLE [dbo].[TAGS];
		PRINT N'➕ DROP TABLE [TAGS] IS COMPLETED';
	END;
END;
IF (@IS_COMMIT = 1) BEGIN
	COMMIT TRAN
	PRINT N'➕ INSERT IS COMMITTED'
END ELSE BEGIN
    ROLLBACK TRAN
	PRINT N'❌ INSERT IS ROLL-BACKED'
END;
-------------------------------------------------------------------------------------------------