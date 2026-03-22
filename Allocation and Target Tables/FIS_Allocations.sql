CREATE TABLE FIS_Allocations (
	ProviderNumber int NOT NULL,
	AcademicYear nvarchar(50) NOT NULL,
	Measure nvarchar(50) NOT NULL,
	Allocation decimal(18, 2) NOT NULL,
	CONSTRAINT FIS_Allocations_PK PRIMARY KEY (ProviderNumber, AcademicYear, Measure)
)