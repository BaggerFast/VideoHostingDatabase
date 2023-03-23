-------------------------------------------------------------------------------------------------
-- TAGS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'TAGS') BEGIN
	PRINT N'❌ TABLE [TAGS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[TAG].[UID],
        [TAG].[TITLE]
	FROM [TAGS] [TAG] WHERE [TITLE] = 'Python'
	ORDER BY [TAG].[TITLE];
END;
