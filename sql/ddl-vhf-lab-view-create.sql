/*
Create a consolidated view from all the labs joined to their case
*/
USE [EbolaCopy]
GO

/****** Object:  View [dbo].[DBExtractView]    Script Date: 3/2/2015 10:13:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create VIEW [dbo].[VHFLabView]
AS
select 
	cif1.DateOnset as CaseDateOnset,
	cif1.DateOnsetEstimated as CaseDateOnsetEstimated,
	lrf7.SurnameLab as LabSurname,
	lrf7.OtherNameLab as LabOtherName,
	lrf7.AgeLab,
	lrf7.DaysAcute,
	lrf7.ID as CaseID,
	lrf7.SampleType,
	lrf7.DateSampleCollected,
	lrf7.DateSampleTested,
	lrf7.SampleInterpret,
	lrf7.FieldLabSpecID,
	case when lrf7.EBOVPCR1 = 1 then 'POS' when lrf7.EBOVPCR1 = 2 then 'NEG' when EBOVPCR1 = 3 then 'IND' else EBOVPCR1 end as EBOVPCR1

 from CaseInformationForm2 cif1, CaseInformationForm2 cif2, LaboratoryResultsForm lrf, LaboratoryResultsForm7 lrf7
	where cif1.GlobalRecordId = cif2.GlobalRecordId
		and lrf.GlobalRecordId = lrf7.GlobalRecordId
		and lrf.FKEY = cif1.GlobalRecordId

GO


select *
 from CaseInformationForm2 cif1, CaseInformationForm2 cif2, LaboratoryResultsForm lrf, LaboratoryResultsForm7 lrf7
	where cif1.GlobalRecordId = cif2.GlobalRecordId
		and lrf.GlobalRecordId = lrf7.GlobalRecordId
		and lrf.FKEY = cif1.GlobalRecordId

select 
	cif1.DateOnset as CaseDateOnset,
	cif1.DateOnsetEstimated as CaseDateOnsetEstimated,
	lrf7.SurnameLab as LabSurname,
	lrf7.OtherNameLab as LabOtherName,
	lrf7.AgeLab,
	lrf7.DaysAcute,
	lrf7.ID as CaseID,
	lrf7.SampleType,
	lrf7.DateSampleCollected,
	lrf7.DateSampleTested,
	lrf7.SampleInterpret,
	lrf7.FieldLabSpecID,
	case when lrf7.EBOVPCR1 = 1 then 'POS' when lrf7.EBOVPCR1 = 2 then 'NEG' when EBOVPCR1 = 3 then 'IND' else EBOVPCR1 end as EBOVPCR1

 from CaseInformationForm2 cif1, CaseInformationForm2 cif2, LaboratoryResultsForm lrf, LaboratoryResultsForm7 lrf7
	where cif1.GlobalRecordId = cif2.GlobalRecordId
		and lrf.GlobalRecordId = lrf7.GlobalRecordId
		and lrf.FKEY = cif1.GlobalRecordId
