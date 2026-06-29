DECLARE @AcademicYear NVARCHAR(5) = '25/26'
DECLARE @ILRReturn NVARCHAR(3) = 'R10'

SELECT
	FD.LearnRefNumber,
	FD.TotalEarnedCashYearEnd,
	FD.ProviderPaymentYearEnd,
	FD.OnProgPaymentYearEnd,
	FD.AchCompPaymentYearEnd,
	FD.ProgFundIndMinCoInvestYearEnd
FROM FIS_FundingDataNew FD
INNER JOIN FIS_FundingDataNewExtra FDE
	ON FDE.ILRReturnDate = FD.ILRReturnDate
	AND FDE.ProviderNumber = FD.ProviderNumber
	AND FDE.LearnRefNumber = FD.LearnRefNumber
	AND FDE.AimSeqNumber = FD.AimSeqNumber
WHERE
	FD.AcademicYear = @AcademicYear
	AND FD.ILRReturn = @ILRReturn
	AND FD.IsFinalReturn = 1
	AND FD.FundLineCategory = 'Apprenticeships'
	AND FD.IsFundedStart = 1
	AND FD.IsCarryIn = 0
	--AND FD.LearnRefNumber = '020101170251'