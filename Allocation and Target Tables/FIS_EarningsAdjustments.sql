CREATE TABLE FIS_EarningsAdjustments (
	AcademicYear VARCHAR(5) NOT NULL,
	ProviderNumber INT NOT NULL,
	ILRReturn VARCHAR(3) NOT NULL,
	FundLineSubCategory VARCHAR(50) NOT NULL,
	ALSClaimed DECIMAL(18, 2) NOT NULL,
	CONSTRAINT FIS_EarningsAdjustments_PK PRIMARY KEY (ProviderNumber, AcademicYear, ILRReturn, FundLineSubCategory)
)