use EbolaQC
/*
these checks are not very important as a cleaning script is run by OMS
*/
select ID,HospitalCurrent from DBExtractView where HospitalCurrent = 'CTE Guekedou'

/* find incorrect Gueckedou hospitals by volume */
select HospitalCurrent, count(*) as Count
 from DBExtractView
  where HospitalCurrent like '%Gue%'
	and HospitalCurrent != 'CTE Gueckedou'
  group by rollup(HospitalCurrent)
  order by Count desc

/* get a list for QC spreadsheet */
select ID, HospitalCurrent
 from DBExtractView
 where HospitalCurrent like '%Gue%'
	and HospitalCurrent != 'CTE Gueckedou'
 order by HospitalCurrent asc
