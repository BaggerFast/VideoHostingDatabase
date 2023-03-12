-------------------------------------------------------------------------------------------------
-- TAGS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @DB_NAME VARCHAR(128) = 'VideoHosting';
DECLARE @DB_NAME_CURRENT VARCHAR(128) = NULL;
-------------------------------------------------------------------------------------------------
SET @DB_NAME_CURRENT = (SELECT DB_NAME());
IF NOT (@DB_NAME_CURRENT = @DB_NAME) BEGIN
	PRINT N'➕ CURRENT DB IS NOT CORRECT: ' + @DB_NAME_CURRENT;
END ELSE BEGIN
    PRINT N'➕ CURRENT DB IS CORRECT: ' + @DB_NAME_CURRENT;
    IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'TAGS') BEGIN
		PRINT N'❌ TABLE [TAGS] WAS NOT FOUND';
	END ELSE BEGIN
		SELECT
			 [T].[UID]
			,[T].[TITLE]
		FROM [dbo].[TAGS] [T]
		ORDER BY [T].[TITLE];
	END;
END;