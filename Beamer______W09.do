*dummy variable practice 1

	*highschool and beyond (200 cases)
	use "../Data/hsb2.dta", clear

	*regression with a dummy variable
	histogram write
	reg write female
	bysort female: su write    //the means of writing score, by gender

	*regression with two dummy variable
	tab ses
	tab ses, nolabel
	bysort ses: su write    //the means of writing score, by ses
	tab ses, gen(status)
	reg write status1 status3

	*use of factor variables
	reg write i.ses

	*specify the base category
	reg write b2.ses
	
	
	
*dummy variable practice 2

	*National Longitudinal Survey, Young Women 14-26 years of age in 1968
	use "../Data/nlswork", clear
	drop if missing(ln_wage, union, race, grade, ttl_exp, c_city, south)

	*examine dependent and independent variables
	hist ln_wage
	tab union
	tab race
	tab race, gen(racecat)
	tab grade
	hist ttl_exp

	*is it correct?
	reg ln_wage union race grade ttl_exp

	*use of dummy variables
	reg ln_wage union racecat2 racecat3 grade ttl_exp

	*use of factor variables
	reg ln_wage i.union i.race grade ttl_exp

	*specify the base category
	reg ln_wage i.union b1.race grade ttl_exp

	*hierarchical regression models
	est clear
	eststo: reg ln_wage grade ttl_exp
	eststo: reg ln_wage grade ttl_exp i.union
	eststo: reg ln_wage grade ttl_exp i.union b1.race
	esttab
	esttab, r2 nogap nobaselevel    //if not want to see the base category

	*exception handling
	gen disadv=c_city==0 & south==1 & race==2
	est clear
	eststo: reg ln_wage i.union i.race grade ttl_exp
	eststo: reg ln_wage i.union i.race grade ttl_exp disadv 
	esttab, r2 label wide

	*threshold effect
	tab grade
	tab grade collgrad
	
	est clear
	eststo: reg ln_wage grade
	eststo: reg ln_wage collgrad
	eststo: reg ln_wage i.grade
	esttab, r2 label wide

	reg ln_wage i.grade
	test 12.grade=16.grade



	
	
*interaction terms practice 1
		
	*National Longitudinal Survey, Young Women 14-26 years of age in 1968
	use "../Data/nlswork", clear
	drop if missing(ln_wage, union, south, tenure)

	*regression with an interaction term (dummy x numerical)
	gen unionXtenure=union*tenure
	reg ln_wage union tenure unionXtenure
	reg ln_wage i.union c.tenure i.union#c.tenure
	reg ln_wage i.union##c.tenure

	*margins
	margins, at(tenure=(0(1)29)) by(union)
	marginsplot

	
	
	
	
*interaction terms practice 2

	*regression with an interaction term (numerical x numerical)
	gen ttl_expXage=ttl_exp*age
	reg ln_wage ttl_exp age ttl_expXage
	reg ln_wage ttl_exp age c.ttl_exp#c.age
	reg ln_wage c.ttl_exp##c.age
	
	*margins
	su ttl_exp age
	margins, at(ttl_exp=(0(1)29) age=(30 40 50))
	marginsplot

	*hierarchical regression models
	est clear
	eststo: reg ln_wage c.ttl_exp c.age
	eststo: reg ln_wage c.ttl_exp c.age c.ttl_exp#c.age
	esttab
	
	
	
	
	
	
	
*interaction terms practice 3

	*regression with an interaction term (dummy x dummy)
	gen unionXsouth=union*south
	reg ln_wage union south unionXsouth
	reg ln_wage union south i.union#i.south
	reg ln_wage i.union##i.south
	
	*margins
	margins, by(union south)
	marginsplot, xdim(union south) recast(bar)

	
	
	
	
	
	
*interaction terms practice 4

	*
	use "../data/2003-2018_KGSS_public_v3.dta", clear
	ren *, lower
	
	*examine the variables
	ta sex
	ta sex, nolabel
	keep if sex==2
	ta hapinss1
	drop if hapinss1<0
	ta age
	ta marital
	ta marital, nolabel
	recode marital (1=1) (2 3 4 5 6=0), gen(married)
	
	*
	reg hapinss1 c.age##i.married
	margins, at(age=(20(1)80)) by(married)
	marginsplot







