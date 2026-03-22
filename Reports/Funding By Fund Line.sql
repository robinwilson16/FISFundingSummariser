/*
DECLARE @AcademicYear NVARCHAR(5) = '25/26'
DECLARE @ILRReturn NVARCHAR(3) = 'R05'
*/


DECLARE @IsFinalReturn BIT = 1
DECLARE @TwoYearsAgo VARCHAR(5) = CAST ( CAST ( LEFT ( @AcademicYear, 2 ) AS INT ) - 2 AS VARCHAR(2) ) + '/' + CAST ( CAST ( RIGHT ( @AcademicYear, 2 ) AS INT ) - 2 AS VARCHAR(2) )

SELECT
	AcademicYear = @AcademicYear,
	FundLineCategoryOrder = CASE WHEN FD.FundLineCategory = 'Adult Education Budget' THEN 2 ELSE FD.FundLineCategoryOrder END,
	FundLineCategory = CASE WHEN FD.FundLineCategory = 'Adult Education Budget' THEN 'Adult Skills Fund' ELSE FD.FundLineCategory END,
	ILRYear = FD.AcademicYear,
	--FD.FundLineSubCategoryOrder,
	--FundLineSubCategory,
	--FD.FundLine,
	AllLearners = SUM ( FD.IsMainAimInFundModel ),
	FundedLearners = SUM ( CASE WHEN FD.IsMainAimInFundModel = 1 AND FD.IsFundedStart = 1 THEN 1 ELSE 0 END ),
	LearnersLostPre42 = SUM ( CASE WHEN FD.IsMainAimInFundModel = 1 AND FD.IsOverallWithdrawnPreEligibility = 1 THEN 1 ELSE 0 END ),
	LearnersLostPost42 = SUM ( CASE WHEN FD.IsMainAimInFundModel = 1 AND FD.IsOverallWithdrawnPostEligibility = 1 THEN 1 ELSE 0 END ),
	Enrols = COUNT ( FD.LearnRefNumber ),
	WdrPre42 = SUM ( FD.IsOverallWithdrawnPreEligibility ),
	Starts = SUM ( FD.IsOverallStart ),
	Leavers = SUM ( FD.IsOverallLeaver ),
	BestCaseLeavers = SUM ( FD.IsOverallLeaverBestCase ),
	AttendPlanned = SUM ( ATT.Planned ),
	AttendActual = SUM ( ATT.Actual ),
	AttendPer = 
		ROUND (
			CASE
				WHEN SUM ( ATT.Planned ) = 0 THEN 0
				ELSE
					CAST ( SUM ( ATT.Actual ) AS FLOAT )
					/
					CAST ( SUM ( ATT.Planned ) AS FLOAT )
			END,
			3
		),
	Retained = SUM ( FD.IsOverallRetainedFunded ),
	RetInYrPer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallStart ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallRetainedFunded ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallStart ) AS FLOAT )
			END,
			3
		),
	RetPer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallLeaver ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallCompletedFunded ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallLeaver ) AS FLOAT )
			END,
			3
		),
	RetBestCasePer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallLeaverBestCase ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallCompletedBestCase ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallLeaverBestCase ) AS FLOAT )
			END,
			3
		),
	WdrPost42 = SUM ( FD.IsOverallWithdrawnFunded ),
	BreakInLrn = SUM ( FD.IsOverallBreakInLearningFunded ),
	Completed = SUM ( FD.IsOverallCompletedFunded ),
	BestCaseCompleted = SUM ( FD.IsOverallCompletedBestCase ),
	Achiever = SUM ( FD.IsOverallAchieverFunded ),
	Failed = SUM ( FD.IsOverallFailedFunded ),
	UnknownOutcome = SUM ( FD.IsOverallUnknownOutcomeFunded ),
	AchPer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallLeaver ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallAchieverFunded ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallLeaver ) AS FLOAT )
			END,
			3
		),
	AchBestCasePer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallLeaverBestCase ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallAchieverBestCase ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallLeaverBestCase ) AS FLOAT )
			END,
			3
		),
	PassPer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallCompletedFunded ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallAchieverFunded ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallCompletedFunded ) AS FLOAT )
			END,
			3
		),
	PassBestCasePer = 
		ROUND (
			CASE
				WHEN SUM ( FD.IsOverallCompletedBestCase ) = 0 THEN 0
				ELSE
					CAST ( SUM ( FD.IsOverallAchieverBestCase ) AS FLOAT )
					/
					CAST ( SUM ( FD.IsOverallCompletedBestCase ) AS FLOAT )
			END,
			3
		),
	BestCaseAchiever = SUM ( FD.IsOverallAchieverBestCase ),
	TotalFunding = SUM ( FD.TotalEarnedCashYearEnd )
FROM FIS_FundingData FD
LEFT JOIN [ebs-db\EBS].FISFundingSummariser.dbo.FIS_Attendance ATT
	ON ATT.AcademicYear = FD.AcademicYear
	AND ATT.ILRReturn = FD.ILRReturn
	AND ATT.SoftwareSupplierAimID = FD.SoftwareSupplierAimID
WHERE
	FD.AcademicYear <= @AcademicYear
	AND FD.AcademicYear >= @TwoYearsAgo
	AND FD.ILRReturn = @ILRReturn
	AND FD.IsFinalReturn = @IsFinalReturn
	--AND FD.IsFundedStart = 1
GROUP BY
	CASE WHEN FD.FundLineCategory = 'Adult Education Budget' THEN 2 ELSE FD.FundLineCategoryOrder END,
	CASE WHEN FD.FundLineCategory = 'Adult Education Budget' THEN 'Adult Skills Fund' ELSE FD.FundLineCategory END,
	FD.AcademicYear
	--FD.FundLineSubCategoryOrder,
	--FD.FundLineSubCategory,
	--FD.FundLine
ORDER BY
	CASE WHEN FD.FundLineCategory = 'Adult Education Budget' THEN 2 ELSE FD.FundLineCategoryOrder END,
	FD.AcademicYear DESC
	--FD.FundLineSubCategoryOrder,
	--FD.FundLineSubCategory,
	--FD.FundLine