/*
Epi curve for Forecariah for 15/2 forward. Asked for my Christine.
By DateReport because recent cases don't have DateOnset yet
Only confirmed, probable and suspect
convert 103 code means dd/mm/yyyy, but still sort by date proper for ordering
*/	
select convert(varchar(10),DateReport, 103) as FormattedDate,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateReport > '02/15/2015'
		and DistrictRes = 'Forecariah'
	group by DateReport
	order by DateReport asc

/*
Epi curve for Forecariah for 15/2 forward. Asked for my Christine.
By DateOnset for comparison
Only confirmed, probable and suspect
convert 103 code means dd/mm/yyyy, but still sort by date proper for ordering
*/	
select convert(varchar(10),DateOnset, 103) as FormattedDate,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateOnset > '02/15/2015'
		and DistrictRes = 'Forecariah'
	group by DateOnset
	order by DateOnset asc

/*
check other districts in the period after 2/15 to see if forecariah misspelled or something
*/
select convert(varchar(10),DateReport, 103) as FormattedDate,
		DistrictRes,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateReport > '02/15/2015'
	group by rollup (DateReport,
		DistrictRes)
	order by DistrictRes asc, 
		DateReport asc