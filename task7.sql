CREATE PROCEDURE GetTopCoachesAndWinners
AS
BEGIN
    -- Запрос для определения пловцов-победителей (1, 2 и 3 место) по двум параметрам
    WITH RankedResults AS (
        SELECT
            R.ResultId,
            R.CompetitionId,
            R.JudgeId,
            R.SwimmerId,
            R.DeclaredTime,
            R.PoolId,
            R.Style,
            R.StartDate AS ResultStartDate,
            R.Distanse,
            S.CoachId,
            C.FirstName AS CoachFirstName,
            C.LastName AS CoachLastName,
            DENSE_RANK() OVER (PARTITION BY R.CompetitionId ORDER BY R.DeclaredTime) AS Rank
        FROM
            dbo.Result R
        INNER JOIN
            dbo.Swimmer S ON R.SwimmerId = S.SwimmerId
        INNER JOIN
            dbo.Coach C ON S.CoachId = C.CoachId
    )

    -- Вывод результатов для пловцов-победителей
    SELECT
        RR.ResultId,
        RR.CompetitionId,
        CO.CompetitionName,
        CO.StartDate AS CompetitionStartDate,
        CO.EndDate AS CompetitionEndDate,
        RR.JudgeId,
        RR.SwimmerId,
        RR.DeclaredTime,
        RR.PoolId,
        RR.Style,
        RR.ResultStartDate,
        RR.Distanse,
        RR.CoachId,
        RR.CoachFirstName AS CoachFirstName,
        RR.CoachLastName AS CoachLastName,
        RR.Rank
    INTO
        #TopSwimmers
    FROM
        RankedResults RR
    INNER JOIN
        dbo.Competition CO ON RR.CompetitionId = CO.CompetitionId
    WHERE
        RR.Rank <= 3;

    -- Запрос для определения общего рейтинга топ 10 тренеров
    WITH CoachPoints AS (
        SELECT
            S.CoachId,
            C.FirstName AS CoachFirstName,
            C.LastName AS CoachLastName,
            SUM(
                CASE
                    WHEN RR.Rank = 1 THEN 3
                    WHEN RR.Rank = 2 THEN 2
                    WHEN RR.Rank = 3 THEN 1
                    ELSE 0
                END
            ) AS TotalPoints
        FROM
            RankedResults RR
        INNER JOIN
            dbo.Swimmer S ON RR.SwimmerId = S.SwimmerId
        INNER JOIN
            dbo.Coach C ON S.CoachId = C.CoachId
        GROUP BY
            S.CoachId, C.FirstName, C.LastName
    )

    -- Вывод результатов для топ 10 тренеров
    SELECT TOP 10
        CP.CoachId,
        CP.CoachFirstName,
        CP.CoachLastName,
        CP.TotalPoints
    INTO
        #TopCoaches
    FROM
        CoachPoints CP
    ORDER BY
        CP.TotalPoints DESC;

    -- Вывод общих результатов
    SELECT
        TS.*,
        TC.TotalPoints
    FROM
        #TopSwimmers TS
    INNER JOIN
        #TopCoaches TC ON TS.CoachId = TC.CoachId;

    -- Очистка временных таблиц
    DROP TABLE #TopSwimmers;
    DROP TABLE #TopCoaches;
END;


EXEC GetTopCoachesAndWinners