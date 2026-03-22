SELECT
	FD.FundLineSubCategory,
	FD.FundLine,
	FD.StandardCode,
	FD.StandardName,
	FD.LearningAimCode,
	FD.LearnRefNumber,
	FD.Surname,
	FD.Forename,
	FD.StartDate,
	FD.PlannedEndDate,
	FD.ActualEndDate,
	FD.AchievementDate,
	OverdueAmount = 
		CASE
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 180, FD.PlannedEndDate ) AS DATE ) THEN 'Overdue 180+'
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 90, FD.PlannedEndDate ) AS DATE ) THEN 'Overdue 90-179'
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 60, FD.PlannedEndDate ) AS DATE ) THEN 'Overdue 60-89'
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 30, FD.PlannedEndDate ) AS DATE ) THEN 'Overdue 30-59'
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) > CAST ( DATEADD ( DAY, 0, FD.PlannedEndDate ) AS DATE ) THEN 'Overdue 1-29'
			ELSE 'Not Overdue'
		END,
	OverdueAmountOrder = 
		CASE
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 180, FD.PlannedEndDate ) AS DATE ) THEN 6
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 90, FD.PlannedEndDate ) AS DATE ) THEN 5
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 60, FD.PlannedEndDate ) AS DATE ) THEN 4
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 30, FD.PlannedEndDate ) AS DATE ) THEN 3
			WHEN CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) > CAST ( DATEADD ( DAY, 0, FD.PlannedEndDate ) AS DATE ) THEN 2
			ELSE 1
		END
FROM FIS_FundingData FD
LEFT JOIN (
	SELECT DISTINCT
		FD.LearnRefNumber,
		FD.StandardCode,
		StartDate = COALESCE ( FD.OriginalStartDate, FD.StartDate )
	FROM FIS_FundingData FD
	WHERE
		FD.AcademicYear = '25/26'
		AND FD.ILRReturn = 'R05'
		AND FD.IsFinalReturn = 1
		AND FD.FundLineCategory = 'Apprenticeships'
		AND FD.CompletionStatusCode <> '6'
) ACT
	ON ACT.LearnRefNumber = FD.LearnRefNumber
	AND ACT.StandardCode = FD.StandardCode
	AND ACT.StartDate = COALESCE ( FD.OriginalStartDate, FD.StartDate )
	AND FD.CompletionStatusCode = '6'
WHERE
	FD.AcademicYear = '25/26'
	AND FD.ILRReturn = 'R06'
	AND FD.IsFinalReturn = 1
	AND FD.FundLineCategory = 'Apprenticeships'
	--AND FD.IsFundedStart = 1
	--AND FD.IsMainAimInFundModel = 1
	AND FD.LearningAimCode = 'ZPROG001'
	--AND DATEDIFF ( DAY, COALESCE ( FD.OriginalStartDate, FD.StartDate ), COALESCE ( FD.ActualEndDate, FD.PlannedEndDate ) ) >= 42
	--AND FD.IsFundedStart = 1
	AND 
		CASE
			WHEN FD.CompletionStatusCode = '6' THEN
				CASE
					WHEN ACT.LearnRefNumber IS NULL THEN 1
					ELSE 0
				END
			ELSE 1
		END = 1
	AND NOT (
		--Entered Gateway
		FD.CompletionStatusCode = '1'
		AND COALESCE ( FD.OutcomeCode, '9' ) = '8'
	)
		--Withdrawn
	AND FD.CompletionStatusCode <> '3'
	--AND NOT CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) >= CAST ( DATEADD ( DAY, 90, FD.PlannedEndDate ) AS DATE ) -- Existing Methodology
	AND CAST ( COALESCE ( FD.ActualEndDate, GETDATE() ) AS DATE ) > CAST ( DATEADD ( DAY, 0, FD.PlannedEndDate ) AS DATE )
	--AND FD.LearnRefNumber = ''253 vs 1883 - 14%
ORDER BY
	FD.StandardCode,
	FD.Surname,
	FD.Forename,
	FD.LearnRefNumber
	--141