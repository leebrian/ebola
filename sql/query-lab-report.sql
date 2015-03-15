--don't check in real dbname
Use EbolaCopy

/*
sanity checks:
how many lab results total
how many case records total
*/
select count(*) from LaboratoryResultsForm
select count(*) from CaseInformationForm

/*
create an extract of lab records joined to their cases
*/
select * from LaboratoryResultsForm7

select count(*), LastSaveLogonName from CaseInformationForm
 group by LastSaveLogonName
 order by count(*) desc

select *
 from CaseInformationForm2 cif1, CaseInformationForm2 cif2, LaboratoryResultsForm lrf, LaboratoryResultsForm7 lrf7
	where cif1.GlobalRecordId = cif2.GlobalRecordId
		and lrf.GlobalRecordId = lrf7.GlobalRecordId
		and lrf.FKEY = cif1.GlobalRecordId

/*
find labs that do not have a case record
*/
select *
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 where cif.GlobalRecordId is null

select *
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 where cif.GlobalRecordId is null
 order by lrf7.DateSampleCollected desc

/*
find labs that don't have another lab record in db
*/
select lrf7a.FieldLabSpecID, lrf7b.FieldLabSpecID, lrf7a.GlobalRecordId, lrf7b.GlobalRecordId,*
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7a
	on lrf.GlobalRecordId  = lrf7a.GlobalRecordId
 left outer join LaboratoryResultsForm7 lrf7b
	on lrf7a.FieldLabSpecID = lrf7b.FieldLabSpecID
 where cif.GlobalRecordId is null
	and isnull(lrf7a.GlobalRecordId,-1) != isnull(lrf7b.GlobalRecordId, -2)
 order by lrf7a.DateSampleCollected desc

/*
Find lab results that were not reentered with the same FieldLabSpecID (i.e., deleted but never reentered)
*/
select 
	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 where cif.GlobalRecordId is null
	and (select count(*) from LaboratoryResultsForm7 lrf7b where lrf7b.FieldLabSpecID = lrf7.FieldLabSpecID) < 2
 order by lrf7.DateSampleCollected desc

/*
Only display relevant fields to assist with QC review
All lab records that do not link to a case.
*/
select 
	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 where cif.GlobalRecordId is null
 order by convert(varchar,lrf7.DateSampleCollected,112) desc


 /*
 look at only confirmed labs that are missing cases
 */
 select *
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 where cif.GlobalRecordId is null
	and lrf7.SampleInterpret = 1
 order by lrf7.DateSampleCollected desc

 /*
 look at only confirmed labs that are missing cases
 Only useful fields in select clause
 */
 select 
 	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 where cif.GlobalRecordId is null
	and lrf7.SampleInterpret = 1
 order by convert(varchar,lrf7.DateSampleCollected,112) desc

 /*
 look for confirmed labs that are not confirmed cases
 */
 select *
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 left outer join CaseInformationForm1 cif1
	on lrf7.ID = cif1.ID
 where cif.GlobalRecordId is null
	and lrf7.SampleInterpret = 1
	and isnull(cif1.EpiCaseDef,-1) not in (1)
 order by lrf7.SurnameLab desc

 /*
 look for confirmed labs that are linked by ID (not GlobalRecordId) to cases that exist, but are not 1
 */
 select 
 	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 left outer join CaseInformationForm1 cif1
	on lrf7.ID = cif1.ID
 where cif.GlobalRecordId is null
	and lrf7.SampleInterpret = 1
	and isnull(cif1.EpiCaseDef,-1) not in (-1,1)
 order by convert(varchar,lrf7.DateSampleCollected,112) desc

 /*
 look for confirmed labs that are linked by ID (not GlobalRecordId) to cases that exist, but are not 1
 with shorter set of fields in select
 */
 select 
 	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 left outer join CaseInformationForm1 cif1
	on lrf7.ID = cif1.ID
 where cif.GlobalRecordId is null
	and lrf7.SampleInterpret = 1
	and isnull(cif1.EpiCaseDef,-1) not in (-1,1)
 order by convert(varchar,lrf7.DateSampleCollected,112) desc

 /*
 look for any labs that are linked by ID (not GlobalRecordId) to cases that exist
 */
 select
  	convert(varchar,lrf7.DateSampleCollected,3) as DateSampleCollected, 
	convert(varchar,lrf7.DateSampleTested,3) as DateSampleTested, 
	lrf7.SurnameLab, 
	lrf7.OtherNameLab, 
	lrf7.AgeLab, 
	lrf7.SampleType, 
	lrf7.SampleInterpret, 
	lrf7.FieldLabSpecID, 
	lrf7.ID,
	convert(varchar,lrf.LastSaveTime,113) as LastSaveTime,
	lrf.LastSaveLogonName
 from LaboratoryResultsForm lrf
 left outer join CaseInformationForm cif
	on lrf.FKEY = cif.GlobalRecordId
 inner join LaboratoryResultsForm7 lrf7
	on lrf.GlobalRecordId  = lrf7.GlobalRecordId
 left outer join CaseInformationForm1 cif1
	on lrf7.ID = cif1.ID
 where cif.GlobalRecordId is null
	and cif1.ID is not null
 order by convert(varchar,lrf7.DateSampleCollected,112) desc
 

