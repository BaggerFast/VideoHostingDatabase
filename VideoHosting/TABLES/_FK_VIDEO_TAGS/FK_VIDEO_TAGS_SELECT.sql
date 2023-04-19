-------------------------------------------------------------------------------------------------
-- FK_VIDEO_TAGS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'FK_VIDEO_TAGS') BEGIN
	PRINT N'❌ TABLE [FK_VIDEO_TAGS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[VIDEO_TAG].[UID],
        [TAG].[TITLE] [TAG TITLE],
        [VIDEO].[TITLE] [VIDEO TITLE]
	FROM [FK_VIDEO_TAGS] [VIDEO_TAG]
    LEFT JOIN [TAGS] [TAG] ON [VIDEO_TAG].[TAG_UID]=[TAG].[UID]
    LEFT JOIN [VIDEOS] [VIDEO] ON [VIDEO_TAG].[VIDEO_UID]=[VIDEO].[UID]
	ORDER BY [TAG].[TITLE];
END;
