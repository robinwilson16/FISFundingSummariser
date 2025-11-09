CREATE TABLE FIS_FundingTargets (
	ProviderNumber int NOT NULL,
	AcademicYear nvarchar(50) NOT NULL,
	Measure nvarchar(50) NOT NULL,
	Target decimal(18, 2) NOT NULL,
	CONSTRAINT FIS_FundingTargets_PK PRIMARY KEY (ProviderNumber, AcademicYear, Measure)
)