CREATE OR ALTER VIEW VW_FIS_Attendance
AS

	SELECT
		SoftwareSupplierAimID,
		Planned,
		Actual,
		Late
	FROM OPENQUERY([LSRPT-SVR], '
	SET FMTONLY OFF; 
	EXEC InformationServices.dbo.SPR_FIS_Attendance
		WITH RESULT SETS
		(
			(
				SoftwareSupplierAimID VARCHAR(36),
				Planned INT,
				Actual INT,
				Late INT
			)
		);
	') X