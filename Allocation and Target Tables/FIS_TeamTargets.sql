CREATE TABLE FIS_TeamTargets (
	AcademicYear nvarchar(50) NOT NULL,
	ProviderNumber int NOT NULL,
	TeamCode nvarchar(50) NOT NULL,
	Measure nvarchar(50) NOT NULL,
	Target decimal(18, 2) NOT NULL,
	CONSTRAINT FIS_TeamTargets_PK PRIMARY KEY (AcademicYear, ProviderNumber, TeamCode, Measure)
)