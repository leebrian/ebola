use EbolaCopy

/*
how many meta links for chains of transmission?
*/
select *
 from metaLinks ml
 where fromViewId = 1 and ToViewId = 1

/*
select all meta links to find cases that have source cases, 1,2,3,5,9
*/
select *
 from metaLinks ml
 left outer join CaseInformationForm1 cis1From
	on ml.FromRecordGuid = cis1From.GlobalRecordId
 left outer join CaseInformationForm1 cis1To
	on ml.ToRecordGuid = cis1To.GlobalRecordId
 left outer join CaseInformationForm2 cis2From
	on ml.ToRecordGuid = cis2From.GlobalRecordId
 left outer join CaseInformationForm2 cis2To
	on ml.ToRecordGuid = cis2To.GlobalRecordId
 left outer join CaseInformationForm3 cis3From
	on ml.ToRecordGuid = cis3From.GlobalRecordId
 left outer join CaseInformationForm3 cis3To
	on ml.ToRecordGuid = cis3To.GlobalRecordId
 left outer join CaseInformationForm5 cis5From
	on ml.ToRecordGuid = cis5From.GlobalRecordId
 left outer join CaseInformationForm5 cis5To
	on ml.ToRecordGuid = cis5To.GlobalRecordId
 left outer join CaseInformationForm9 cis9From
	on ml.ToRecordGuid = cis9From.GlobalRecordId
 left outer join CaseInformationForm9 cis9To
	on ml.ToRecordGuid = cis9To.GlobalRecordId
 where ml.fromViewId = 1 and ml.ToViewId = 1


 select *
 from metaLinks ml
 order by FromRecordGuid
  where FromRecordGuid = 'Also on CRF, for prefecture of the hospital where the patient died, "Dixinn" was written and the medical center was recorded as something illegible, possibly "SMIT".'