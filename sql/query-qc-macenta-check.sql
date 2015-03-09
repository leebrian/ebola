use EbolaQC

/* 
find incorrect Macenta hospitals by volume
This is not very important as a separate, OMS built cleaning script checks for these and maintains
 */
select HospitalCurrent, count(*) as Count
 from DBExtractView
  where HospitalCurrent like '%Mac%'
	and HospitalCurrent != 'CTE Macenta'
  group by rollup(HospitalCurrent)
  order by Count desc

/* get a list for QC spreadsheet */
select ID, HospitalCurrent
 from DBExtractView
 where HospitalCurrent like '%Mac%'
	and HospitalCurrent != 'CTE Macenta'
 order by HospitalCurrent asc
