CREATE VIEW VW_FIS_DestinationProgressionOutcomes
AS
	SELECT
		OutcomeCode = DES.CODE,
		OutcomeType = 
			CASE
				WHEN DES.CODE IN ( '54', '55', '75', '95' ) THEN 'EDU'
				WHEN DES.CODE IN ( '10', '4', '53' ) THEN 'EMP'
				WHEN DES.CODE IN ( '' ) THEN 'GAP'
				WHEN DES.CODE IN ( '11', '76', '77' ) THEN 'NPE'
				WHEN DES.CODE IN ( '97', '98' ) THEN 'OTH'
				WHEN DES.CODE IN ( '' ) THEN 'SDE'
				WHEN DES.CODE IN ( '59' ) THEN 'VOL'
				ELSE 'OTH'
			END,
		Code = 
			CASE
				WHEN DES.CODE IN ( '54', '55', '75', '95' ) THEN 'EDU'
				WHEN DES.CODE IN ( '10', '4', '53' ) THEN 'EMP'
				WHEN DES.CODE IN ( '' ) THEN 'GAP'
				WHEN DES.CODE IN ( '11', '76', '77' ) THEN 'NPE'
				WHEN DES.CODE IN ( '97', '98' ) THEN 'OTH'
				WHEN DES.CODE IN ( '' ) THEN 'SDE'
				WHEN DES.CODE IN ( '59' ) THEN 'VOL'
				ELSE 'OTH'
			END,
		Description = DES.DESCRIPTION
	FROM [EBS-DB\EBS].ebs.dbo.LSC_VERIFIERS DES
	WHERE
		DES.RV_DOMAIN LIKE '%DESTINATION%'
		AND DES.FES_ACTIVE = 'Y'
		AND DES.FUNDING_YEAR = '32'