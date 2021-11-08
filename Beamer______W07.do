*review

	*ATTEND: N=680, cross-sectional individual data on classes attended
	use "Data/ATTEND.dta", clear

	*correlation coefficient matrix
	corr

	*"GPA for term" and "cumulative GPA prior to term"
	hist termgpa     //check if numerical
	hist priGPA		 //check if numerical
	graph twoway (scatter termgpa priGPA) ///
				 (lfit termgpa priGPA)
	graph export "fig1.png", width(1000) replace
	pwcorr termgpa priGPA, sig star(0.05)

	*simple regression analysis
	hist final 		 //check if numerical
	hist skipped 	 //check if numerical
	regress final skipped
	
	
	
*bivariate regression

	*ATTEND: N=680, cross-sectional individual data on classes attended
	use "Data/ATTEND.dta", clear

	*fit a regression model
	reg termgpa skipped

	*prediction
	predict yhat
	gen error=termgpa-yhat
	hist error
	
	*post-estimation
	test skipped=0
	test skipped=-.5
	test skipped=-.05
	
	*F statistics and t score
	test skipped=0
	di sqrt(309.40)     //sqrt(r(F))
	
	
	
	
*multivariate regression

	*National Longitudinal Survey of Young Women, 14-24 years old in 1968
	use "data/nlsyw", clear
	
	*examine the variables
	su       ln_wage age ttl_exp grade
	codebook ln_wage age ttl_exp grade
	hist ln_wage
	hist age
	graph twoway (scatter ln_wage age)
	hist ttl_exp
	graph twoway (scatter ln_wage ttl_exp)
	hist grade
	graph twoway (scatter ln_wage grade)
	sort age
	edit
	drop if missing(ln_wage, ttl_exp, grade, age)  //drop if missing any
	
	*fit regression models
	reg ln_wage age          //fit a bivariate model
	reg ln_wage age ttl_exp  //fit another model

	*prediction at means (I)
	egen age_mu=mean(age)
	egen ttl_exp_mu=mean(ttl_exp)
	display (age_mu*.0051805) + (ttl_exp_mu*.0535435) + 1.235991
	margins, atmeans
	
	*prediction at means (II)
	su ln_wage ttl_exp
	margins, at(ttl_exp=(0(1)20)) atmeans
	marginsplot
	
	
		
	*hierarchical models
	est clear
	eststo: reg ln_wage age
	eststo: reg ln_wage age ttl_exp
	eststo: reg ln_wage age ttl_exp grade
	
	*table export
	esttab
	esttab, wide nogap se r2 ar2 label
	esttab using "results.csv", star(* 0.05 ** 0.01 *** 0.001) b(%4.3f) ///
		nonotes addnotes("standard errors in parentheses. * p<.05; ** p<.01; *** p<.001.") ///
		nogap se r2 ar2 label csv replace

	*standardized beta coefficients
	reg ln_wage age ttl_exp grade
	reg ln_wage age ttl_exp grade, beta
	su ln_wage grade	  //check the standard deviations of variables

	*the identity of beta and correlation coefficients
	reg  ln_wage ttl_exp, beta
	corr ln_wage ttl_exp

	
	
	
*multivariate regression: goodness of fit

	*ANOVA F statistics
	test age=ttl_exp=grade=0

	*generate random variables following the uniform distribution
	gen r1=runiform()
	gen r2=runiform()
	gen r3=runiform()
	hist r1
	corr r1 r2 r3
		
	*check out R-squared and adj R-squared
	reg ln_wage age 
	reg ln_wage age r1 r2 r3
	
	
	
	
	
*check if collinear
	
	*correlation coefficient matrix
	corr   ln_wage tenure age ttl_exp grade
	pwcorr ln_wage tenure age ttl_exp grade, star(0.01)
