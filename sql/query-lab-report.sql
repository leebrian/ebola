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
	and isnull(cif1.EpiCaseDef,-1) not in (-1,1)
 order by lrf7.DateSampleCollected desc

 /*
 look for any labs that are linked by ID (not GlobalRecordId) to cases that exist
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
	and cif1.ID is not null
 order by lrf7.DateSampleCollected desc
 

