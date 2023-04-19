USE VideoHosting;

PRINT N'➕ TRIGGER JOB IS STARTED';

GO
CREATE or ALTER TRIGGER [VIDEO_INSTEAD_INSERT] ON [VIDEOS]
INSTEAD OF INSERT AS
BEGIN
    IF EXISTS (
        SELECT
            [USER].[USERNAME] [USER],
            [AGE_REST].[AGE] [AGE_RESTRICTIONS]
	    FROM [VIDEOS] [VIDEO]
        INNER JOIN [USERS] [USER] ON [VIDEO].[USER_UID]=[USER].[UID]
	    INNER JOIN [AGE_RESTRICTIONS] [AGE_REST] ON [VIDEO].[AGE_RESTRICTIONS_UID]=[AGE_REST].[UID]
        WHERE [AGE_REST].[AGE] > DATEDIFF(YEAR, [USER].[BIRTHDAY_DT], GETDATE())
    ) BEGIN
        RAISERROR('The user is not old enough to create this video.', 16, 1);
        RETURN;
    END;
    INSERT INTO [VIDEOS] ([UID], [TITLE], [DESCRIPTION], [PATH], [CREATED_DT], [USER_UID], [ACCESS_UID], [AGE_RESTRICTIONS_UID])
        SELECT [UID], [TITLE], [DESCRIPTION], [PATH], [CREATED_DT], [USER_UID], [ACCESS_UID], [AGE_RESTRICTIONS_UID]
    FROM INSERTED;
END
GO
PRINT N'➕ VIDEO [ INSTEAD INSERT ] CREATED';


GO
CREATE or ALTER TRIGGER [VIDEO_INSTEAD_UPDATE] ON [VIDEOS]
INSTEAD OF UPDATE AS 
BEGIN
    IF EXISTS (
        SELECT
            [USER].[USERNAME] [USER],
            [AGE_REST].[AGE] [AGE_RESTRICTIONS]
	    FROM [VIDEOS] [VIDEO]
        INNER JOIN [USERS] [USER] ON [VIDEO].[USER_UID]=[USER].[UID]
	    INNER JOIN [AGE_RESTRICTIONS] [AGE_REST] ON [VIDEO].[AGE_RESTRICTIONS_UID]=[AGE_REST].[UID]
        WHERE [AGE_REST].[AGE] > DATEDIFF(YEAR, [USER].[BIRTHDAY_DT], GETDATE())
    )
    BEGIN
        RAISERROR('The user is not old enough to create a video.', 16, 1);   
        RETURN;
    END
    UPDATE [VIDEOS]
    SET 
        [TITLE] = [NEW].[TITLE], 
        [DESCRIPTION] = [NEW].[DESCRIPTION], 
        [PATH] = [NEW].[PATH], 
        [CREATED_DT] = [NEW].[CREATED_DT],
        [USER_UID] = [NEW].[USER_UID], 
        [ACCESS_UID] = [NEW].[ACCESS_UID],
        [AGE_RESTRICTIONS_UID] = [NEW].[AGE_RESTRICTIONS_UID]
    FROM [VIDEOS] [VIDEO]
    INNER JOIN INSERTED [NEW] ON [VIDEO].[UID] = [NEW].[UID];
END;
GO
PRINT N'➕ VIDEO [ INSTEAD UPDATE] CREATED';