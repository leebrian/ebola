use EbolaQC

/*
check for confirmed cases that have multiple negative lab results. There may be certain conditions where this fits, but generally this should not occur.
note: comparing values to null will always be false, so escape values with isnull
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (1)
  and (sampleinterpret1 in ('3','5') and isnull(sampleinterpret2,'-1') in ('3','5','-1'))
  and not (isnull(sampleinterpret1,-1) = '1' or
	isnull(sampleinterpret2,-1) = '1' or
	isnull(sampleinterpret3,-1) = '1' or
	isnull(sampleinterpret4,-1) = '1' or
	isnull(sampleinterpret5,-1) = '1' or
	isnull(sampleinterpret6,-1) = '1' or
	isnull(sampleinterpret7,-1) = '1')
  and isnull(finallabclass,-1) = 1
 order by DateReport desc

/*
Confirmed cases with no lab results whatsoever. This should not occur.
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (1)
  and isnull(sampleinterpret1,-1) = -1 and
	isnull(sampleinterpret2,-1) = -1 and
	isnull(sampleinterpret3,-1) = -1 and
	isnull(sampleinterpret4,-1) = -1 and
	isnull(sampleinterpret5,-1) = -1 and
	isnull(sampleinterpret6,-1) = -1 and
	isnull(sampleinterpret7,-1) = -1
 order by DateReport desc

/*
I also want to look at all of the records where the first lab is null. This should ever happen
*/
select ID, DateReport, epicasedef, sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (1)
  and isnull(sampleinterpret1,-1) = -1 
 order by DateReport desc

/*
I also want to look at all confirmed that lack a confirmed lab result. This should never happen.
*/
select ID, convert(varchar(10),DateReport,103) as "DateReportF", epicasedef, surname, othernames, age, gender, FinalLabClass,sampleinterpret1, sampleinterpret2, sampleinterpret3, sampleinterpret4, sampleinterpret5, sampleinterpret6, sampleinterpret7
 from DBExtractView
 where epicasedef in (1)
  and not (isnull(sampleinterpret1,-1) = '1' or
	isnull(sampleinterpret2,-1) = '1' or
	isnull(sampleinterpret3,-1) = '1' or
	isnull(sampleinterpret4,-1) = '1' or
	isnull(sampleinterpret5,-1) = '1' or
	isnull(sampleinterpret6,-1) = '1' or
	isnull(sampleinterpret7,-1) = '1')
 order by DateReport desc