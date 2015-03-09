/*
Modeling the query used by Excel to assist pivot tables and within Excel calculations.
*/
SELECT 
	*,
	substring(DBExtractView.ID,5,3) as DistrictCalculatedFromID,
	case when substring(DBExtractView.FieldLabSpecID1,1,2) = 'EM' then substring(DBExtractView.FieldLabSpecID1,4,3) else substring(DBExtractView.FieldLabSpecID1,1,3) end as CalculatedLabRegion1,
	case when substring(DBExtractView.FieldLabSpecID2,1,2) = 'EM' then substring(DBExtractView.FieldLabSpecID2,4,3) else substring(DBExtractView.FieldLabSpecID2,1,3) end as CalculatedLabRegion2,
	case when isnull(sampleinterpret1,-1) in (3,5) and isnull(sampleinterpret2,-1) in (3,5,-1) then 'True' else 'False' end as FirstLabNegativeAndSecondLabNegativeOrNull, 
	case when sampleinterpret1 = '1' then 'True' when sampleinterpret2 = '1' then 'True' when sampleinterpret3 = '1' then 'True' when sampleinterpret4 = '1' then 'True' when sampleinterpret5 = '1' then 'True' when sampleinterpret6 = '1' then 'True' when sampleinterpret7 = '1' then 'True' else 'False' end as HasPositiveLab 
FROM EbolaQC.dbo.DBExtractView DBExtractView

