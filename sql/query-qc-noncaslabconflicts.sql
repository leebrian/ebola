use EbolaQC

/*
Check for any non case (0), probable (2) or suspect (3) records where they have a matching confirmed lab result. This should never occur as a confirmed lab result would change them to confirmed case (1).
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (0,2,3)
  and (sampleinterpret1 = '1' or
	sampleinterpret2 = '1' or
	sampleinterpret3 = '1' or
	sampleinterpret4 = '1' or
	sampleinterpret5 = '1' or
	sampleinterpret6 = '1' or
	sampleinterpret7 = '1')
order by DateReport desc

/*
Check for any non case but FinalLabClass of 1. This should never happen. 
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7, DateReport
 from DBExtractView
 where epicasedef in (0,2,3)
  and isnull(finallabclass,-1) in (1)
 order by DateReport desc

/*
be smarter, combine the two above as there is overlap
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (0,2,3)
  and ( 
	(sampleinterpret1 = '1' or
		sampleinterpret2 = '1' or
		sampleinterpret3 = '1' or
		sampleinterpret4 = '1' or
		sampleinterpret5 = '1' or
		sampleinterpret6 = '1' or
		sampleinterpret7 = '1')
	or isnull(finallabclass,-1) in (1)
  )
order by DateReport desc

