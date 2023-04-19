-------------------------------------------------------------------------------------------------
-- FK_VIDEO_PLAYLISTS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'FK_VIDEO_PLAYLISTS') BEGIN
	PRINT N'❌ TABLE [FK_VIDEO_PLAYLISTS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[VIDEO_PLAYLIST].[UID],
        [PLAYLIST].[TITLE] [PLAYLIST TITLE],
        [VIDEO].[TITLE] [VIDEO TITLE]
	FROM [FK_VIDEO_PLAYLISTS] [VIDEO_PLAYLIST]
    LEFT JOIN [PLAYLISTS] [PLAYLIST] ON [VIDEO_PLAYLIST].[PLAYLIST_UID]=[PLAYLIST].[UID]
    LEFT JOIN [VIDEOS] [VIDEO] ON [VIDEO_PLAYLIST].[VIDEO_UID]=[VIDEO].[UID]
	ORDER BY [PLAYLIST].[TITLE];
END;
