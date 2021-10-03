*my first crosstab

	*kgss data
	use "Data\KGSS_under35.dta", clear
	rename *, lower
	
	*feeling healthy
	lookfor 건강
	tabulate healthy
	tabulate healthy, nolabel mis
	
	*happiness
	lookfor 행복
	tabulate happy
	tabulate happy, nolabel mis
	
	*reverse coding
	recode healthy (1=5) (2=4) (3=3) (4=2) (5=1), gen(healthy_rev)
	generate happy_rev=5-happy
	
	*user-written commands
	revrs healthy
	revrs happy
	
	*crosstab
	tabulate healthy_rev happy_rev
	tabulate revhealthy revhappy

	
	
	
	
	
	
	
*standardization

	*standardized crosstab
	tabulate revhealthy revhappy, row
	tabulate revhealthy revhappy, col
	tabulate revhealthy revhappy, cell
	
	*row only, no frequency
	tabulate revhealthy revhappy, row nofreq
	
	
	
	
	
	
	
	
*immigration hate

	*wvs data
	use "Data\WVS_Cross-National_Wave_7_stata_v2_0.dta" , clear
	ren *, lower
	
	*immigrant questions (as the dependent variable)
	lookfor migrat
	tabulate q124, mis
	replace q124=. if q124<0
    rename q124 criminal

	*job scarce (as the independent variable)
	replace q34_3=. if q34_3<0
	recode q34_3 (1=3) (2=1) (3=2), gen(priority)  //3=agree; 1=disagree 

	*crosstabs
	tabulate priority criminal, row nofreq

	
	
	
*three-way table

	*fear of job lose
	lookfor job
	tabulate q142, mis
	tabulate q142, nolabel
	replace q142=. if q142<0
	recode q142 (1 2=1) (3 4=0), gen(fear)

	*crosstabs, conditional on q33_3
	bysort fear: tabulate priority criminal, row nofreq
	
	
	
	
	
	
	
	
*table command

	*one-way
	tabulate criminal
	table criminal, statistic(frequency)
	table criminal, statistic(percent)	
	
	*two-way
	tabulate priority criminal
	table    priority criminal
	
	tabulate priority criminal, row nofreq
	table priority criminal, statistic(percent, across(criminal))
	
	tabulate priority criminal, column nofreq
	table priority criminal, statistic(percent, across(priority))
	
	tabulate priority criminal, cell nofreq
	table priority criminal, statistic(percent)

	*three-way
	bysort fear: tabulate priority criminal, row nofreq
	table (priority) (criminal) (fear), statistic(percent, across(criminal))

	
	
	
	
*chi-square analysis

	*observed and expected frequencies
	tab priority criminal
	tab priority criminal, expected nofreq
	
	*Pearson's chi-square and significance test
	tab priority criminal, chi
	
	
	

	
	
*selected issues (1)
	
	*kgss data
	use "data/2003-2018_KGSS_public_v3.dta", clear
	
	*homogamy hypothesis
	keep RINCOM0 SPINCOM0               //respondent's and spouse's incomes
	replace RINCOM0=. if RINCOM0<0      //recode if missing
	replace SPINCOM0=. if SPINCOM0<0    //recode if missing
	drop if RINCOM0==. | SPINCOM0==.    //drop if missing any
	recode RINCOM0  (0/100=1) (100/200=2) (200/300=3) (300/max=4), gen(income1)
	recode SPINCOM0 (0/100=1) (100/200=2) (200/300=3) (300/max=4), gen(income2)
	
	*crosstab
	tabulate income1 income2
	tabulate income1 income2, row nofreq
	tabulate income1 income2, cell nofreq
	tabulate income1 income2, expected chi
	
	
	
	
	
	
*selected issues (2)
	
	*religion data
	use "data/religious", clear

	*observed frequency
	tab sex religious

	*expected frequency
	tab sex religious, expected nofreq

	*chi-square statistics
	display (((97  - 69.99)^2)/ 69.99)    + ///
			(((124 - 151.01)^2) / 151.01) + ///
			(((68  - 95.01)^2) / 95.01)   + ///
			(((232 - 204.99)^2) / 204.99)

	*canned command
	tab sex religious, expected chi

	*instant chi-square analysis
	tabi 97 124 \ 68 232, expected chi
	
	
	
	
	
	
*selected issues (2)
	
	webuse census, clear
	gen urbanrate=popurban/pop
	su urbanrate, detail
	recode urbanrate (0/`r(p25)'=1) (`r(p25)'/`r(p50)'=2) (`r(p50)'/`r(p75)'=3) ///
					 (`r(p75)'/1=4)
	replace divorce=divorce/1000     //No. of divorce per 1,000 couples
	table region urbanrate, statistic(mean divorce) nformat(%6.2f)
		