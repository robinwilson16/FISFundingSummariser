DECLARE @AcademicYear NVARCHAR(5) = '25/26'
DECLARE @ILRReturn NVARCHAR(3) = 'R05'
DECLARE @IsFinalReturn BIT = 1


SELECT
	FD.CollegeLevel1Code,
	FD.CollegeLevel1Name,
	[16-19 Funding] = COALESCE ( FD.[16-19 Funding], 0 ),
	[Adult Skills Fund] = COALESCE ( FD.[Adult Skills Fund], 0 ),
	[Advanced Learner Loan] = COALESCE ( FD.[Advanced Learner Loan], 0 ),
	Apprenticeships = COALESCE ( FD.Apprenticeships, 0 ),
	[Higher Education] = COALESCE ( FD.[Higher Education], 0 ),
	[Full Cost] = COALESCE ( FD.[Full Cost], 0 ),
	TotalCashEarned = 
		COALESCE ( FD.[16-19 Funding], 0 )
		+ COALESCE ( FD.[Adult Skills Fund], 0 )
		+ COALESCE ( FD.[Advanced Learner Loan], 0 )
		+ COALESCE ( FD.Apprenticeships, 0 )
		+ COALESCE ( FD.[Higher Education], 0 )
		+ COALESCE ( FD.[Full Cost], 0 )
FROM (
	SELECT
		FD.CollegeLevel1Code,
		FD.CollegeLevel1Name,
		FD.FundLineCategory,
		TotalEarnedCash = SUM ( FD.TotalEarnedCashYearEnd )
	FROM FIS_FundingData FD
	WHERE
		FD.AcademicYear = @AcademicYear
		AND FD.ILRReturn = @ILRReturn
		AND FD.IsFinalReturn = @IsFinalReturn
		--AND FD.IsFundedStart = 1
	GROUP BY
		FD.CollegeLevel1Code,
		FD.CollegeLevel1Name,
		FD.FundLineCategoryOrder,
		FD.FundLineCategory
) FD
PIVOT (
	MAX ( FD.TotalEarnedCash )
	FOR
		FD.FundLineCategory IN (
			[16-19 Funding],
			[Adult Skills Fund],
			[Advanced Learner Loan],
			[Apprenticeships],
			[Higher Education],
			[Full Cost]
		)
) FD
ORDER BY
	FD.CollegeLevel1Code