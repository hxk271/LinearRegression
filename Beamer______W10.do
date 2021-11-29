*Data on 109 countries
use "nations_12.dta", clear



*practice of squared terms 1

	de death life food
	inspect death life food
	drop if missing(death, life, food)
	
	*fit a linear regression model to data
	reg death food life
	
	*draw a straight fitting line with graph command
	graph twoway (scatter death life) ///
				 (lfit death life)
	
	*draw a quadratic fitting line with graph command
	graph twoway (scatter death life) ///
				 (qfit death life)

	*generate the squared term of life
	gen life2=life^2

	*regression model with a squared term
	reg death food life life2
	reg death food life c.life#c.life
	reg death food c.life##c.life

	*hierarchical regression models
	est clear
	eststo: reg death food life
	eststo: reg death food life life2
	esttab, r2 ar2 order(life life2)
	
	
	
	
*interpretation

	*regression with a squared term
	reg death food c.life##c.life

	*predicted y
	su life  //40 to 78
	margins, at(life=(40(1)78))
	marginsplot
	graph export "fig1.png", replace width(1000)
	

	
	


*practice of squared terms 2

	*strong collinearity and mean centering
	pwcorr life life2
	su life
	gen life_mc=life-61.63303
	gen life_mc2=life_mc^2
	pwcorr life_mc life_mc2
	
	*hierarchical regression models
	est clear
	eststo: reg death life life2
	eststo: reg death life_mc life_mc2
	esttab, r2 ar2

	
	
	
	
	
	
	
*polynomial
				 
	*plot a fractional polynomial function
	graph twoway (scatter death life) ///
				 (fpfit death life, estopts(degree(3)))
			 
	*
	gen life3=life^3
	reg death food life life2 life3
	reg death food c.life##c.life##c.life
	
	*plot the predicted y
	margins, at(life=(40(1)78))
	marginsplot
	
	est clear
	eststo: reg death food c.life
	eststo: reg death food c.life##c.life
	eststo: reg death food c.life##c.life##c.life
	esttab, r2 ar2

	*anova testing if c.life#c.life#c.life=0
	reg death food c.life##c.life##c.life
	test c.life#c.life#c.life=0

	*nested regression
	nestreg: reg death food c.life##c.life##c.life








*
use "kielmc.dta", clear


	*scatterplot
	graph twoway (scatter price age) (lfit price age)
	graph twoway (scatter price age) (qfit price age)
	graph twoway (scatter price age) ///
				 (fpfit   price age, estopts(degree(3)))

	*regression with three power terms
	reg price cbd i.year age
	reg price cbd i.year c.age##c.age
	reg price cbd i.year c.age##c.age##c.age

	*age as step function
	su age
	xtile age_step=age, nquantiles(10)
	reg price cbd area land bath wind i.year i.age_step
	margins, by(age_step)
	marginsplot






	
*interaction effects in combination of a squared term

	*interaction term only
	reg price i.y81 c.cbd i.y81#c.cbd
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot

	*squared term only
	reg price c.cbd c.cbd#c.cbd
	margins, at(cbd=(1000(1000)35000))
	marginsplot

	*combined
	reg price i.y81 c.cbd##c.cbd c.cbd#i.y81
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot

	*hierarchical regression analysis
	est clear
	eststo: reg price i.y81 c.cbd i.y81#c.cbd
	eststo: reg price       c.cbd             c.cbd#c.cbd
	eststo: reg price i.y81 c.cbd i.y81#c.cbd c.cbd#c.cbd
	esttab, r2 ar2
	
	


*log transformation

	*log transform the price
	hist price
	gen ln_price=ln(price)
	
	*scatterplot
	graph twoway (scatter ln_price age) (lfit ln_price age)
	graph twoway (scatter ln_price age) (qfit ln_price age)

	*regression with three power terms
	est clear
	eststo: reg ln_price i.y81 cbd age
	eststo: reg ln_price i.y81 cbd c.age##c.age
	esttab, r2 ar2
	
	*combined
	reg ln_price i.y81 c.cbd##c.cbd c.cbd#i.y81
	margins, at(cbd=(1000(1000)35000)) by(y81)
	marginsplot

	*
	gen ln_age=ln(age+1)
	reg ln_price i.y81 age
	reg ln_price i.y81 ln_age

	*zero-skewness log transformation
	lnskew0 lnage=age
	pwcorr ln_age lnage
	

	
	
	
	

	*log-log model
	reg ln_price i.y81 cbd age larea

	*log-linear model
	reg ln_price i.y81 cbd age area
	
	*linear-log model
	reg price i.y81 cbd age larea
	
	
	
	
	
	
	