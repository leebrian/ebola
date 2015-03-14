use EbolaQC

/*
check the total number of confirmed HCW cases, this shows in the sitrep and is a nice quick sanity check
*/
select count(*)
 from DBExtractView
 where HCW = 'True'
 and EpiCaseDef in (1)

/*
quick query to check recent healthcare workers as confirmed or probable
The alias for datereport in the select clause is because I still want to sort by datereport and don't know how to do that.
*/
select convert(varchar,DateOnset,3) as DateOnset, convert(varchar,DateReport,3) as ReportedDate, ID, EpiCaseDef, Age, case when gender = 1 then 'H' when gender = 2 then 'F' end as Gender, Surname, OtherNames, HCWposition, HCWFacility, DistrictRes from DBExtractView
 where HCW = 'True'
 and EpiCaseDef in (1,2,3)
 order by DateReport desc