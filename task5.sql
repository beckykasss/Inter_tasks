WITH RankedResults AS (
    SELECT
        R.ResultId,
        R.CompetitionId,
        R.JudgeId,
        R.SwimmerId,
        R.DeclaredTime,
        R.PoolId,
        R.Style,
        R.StartDate,
        R.Distanse,
        S.CoachId,
        C.FirstName AS CoachFirstName,
        C.LastName AS CoachLastName,
        ROW_NUMBER() OVER (PARTITION BY S.CoachId, R.Distanse ORDER BY R.DeclaredTime) AS Rank
    FROM
        dbo.Result R
    INNER JOIN
        dbo.Swimmer S ON R.SwimmerId = S.SwimmerId
    INNER JOIN
        dbo.Coach C ON S.CoachId = C.CoachId
)
SELECT
    DeclaredTime,
    Distanse,
    Style,
    SwimmerId,
    CompetitionId,
    CoachId,
    --CoachFirstName AS FirstName,
    --CoachLastName AS LastName,
    Rank AS Result,
    CoachLastName AS Coach
FROM
    RankedResults;
	