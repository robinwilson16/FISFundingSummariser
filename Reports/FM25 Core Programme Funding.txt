SELECT
	FD.NationalFundingRate,
	PrvRetentFactHist = FD.PrvRetentFactHist,
    ProgWeightHist = FD.ProgWeightHist,
    ProgWeightNew = FD.ProgWeightNew,
    LearnerEnglishMathsFundingRate = FD.LearnerEnglishMathsFundingRate,
    LearnerEnglishMathsInstances = FD.LearnerEnglishMathsInstances,
    EnglishAndMathsFunding = FD.LearnerEnglishMathsFundingRate * FD.LearnerEnglishMathsInstances,
    Block1DisadvUpliftRate = FD.Block1DisadvUpliftRate, --Post Codes
	Block1DisadvUpliftCash = FD.Block1DisadvUpliftCash, --Post Codes
    Block2DisadvUpliftRate = FD.Block2DisadvUpliftRate,
    Block2DisadvElementsNew = FD.Block2DisadvElementsNew,
    Block2DisadvUpliftCash = FD.Block2DisadvUpliftCash, --English and Maths Low Ach
    LargeProgrammeUplift = FD.LargeProgrammeUplift,
    AreaCostFact1618Hist = FD.AreaCostFact1618Hist,
    ConditionOfFundingAdjustment = FD.ConditionOfFundingAdjustment,
    AdvancedMathsPremium = FD.AdvancedMathsPremium,
    CoreMathsPremium = FD.CoreMathsPremium,
    HighValueCoursePremium = FD.HighValueCoursePremium,
    TLevelIndustryPlacementFunding = FD.TLevelIndustryPlacementFunding,
	CoreProgrammeFunding = 
		( FD.NationalFundingRate * FD.PrvRetentFactHist * FD.ProgWeightNew ) 
		* FD.AreaCostFact1618Hist,
	TotalProgrammeFunding = 
		(
			( FD.NationalFundingRate * FD.PrvRetentFactHist * FD.ProgWeightNew ) 
			* FD.AreaCostFact1618Hist
		)
		- FD.ConditionOfFundingAdjustment
		+ (
			FD.LearnerEnglishMathsFundingRate
			*
			FD.LearnerEnglishMathsInstances
		)
		+ FD.CoreMathsPremium
		+ FD.Block1DisadvUpliftCash,
		+ FD.Block2DisadvUpliftCash,
		+ FD.HighValueCoursePremium
		+ FD.TLevelIndustryPlacementFunding,
	FD.TotalEarnedCashYearEnd
FROM FIS_FundingData FD
WHERE
	FD.FundLineCategory = '16-19 Funding'
	AND FD.IsFundedStart = 1