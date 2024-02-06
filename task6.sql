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
FROM
    RankedResults RR
INNER JOIN
    dbo.Competition CO ON RR.CompetitionId = CO.CompetitionId
WHERE
    RR.Rank <= 3;
