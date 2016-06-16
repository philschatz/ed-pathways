# Programming to Progress Analysis Explanation

## Glossary

### Performance
The percent of students at a school that met or exceeded standards in one of
three subjects: English, Math, or Science.  When we say we modelled performance,
we usually mean that we made three separate models with the same methodology,
one for each subject.


### Poverty (or FRLE)

Throughout the course of the analysis, we use free or reduced cost lunch
eligibility (FRLE) as a measure of poverty.  The poverty level of a school is
just the percentage of the students enrolled that are eligible.


## Discussion of Analyses


### [Performance_v_Programs.*](./Performance_v_programs.ipynb)

This was our first foray into the data, and the first attempt we took to
try to quantify the effect programs in general had on performance. We first
modelled performance with a linear regression on poverty.  By subtracting the
predicted amount of poverty from the actual poverty of each school, we computed
a *residual performance*--that is, a measure of how much a particular school
exceeded or failed to live up to the level of performance predicted by the
poverty level of the students at that school.

We then looked to see to what degree programs might account for this variance
by comparing the means of residual performace of the groups of schools with or
without a program.


### [poverty_by_school_type.*](./poverty_by_school_type_R.ipynb)

In these analyses, we attempt to demonstrate that poverty is worse on average
in elementary schools and better in high schools.  In order to attempt to
compare apples to apples, we aggregate eligibility and enrollment by school type
within districts, then look at the distribution of poverty differences
between high school and elementary school students within districts.  The
results show that the distribution is normal, with a mean difference of
approximately 10%.  A one sample t-test shows that this mean is significantly
different from zero.


### [elementary_poverty_performance.R](./elementary_poverty_performance.R)

Having established that elementary schools are generally more impoverished, we
attempted to see if the existence of a program alone might correlate to improved
performance after controlling for poverty.  Unfortunately, the vast majority of
the schools in our data set have at least one program, so significance was
elusive.


### [food_breakdown.R](./food_breakdown.R)

Having found it difficult to differentiate between schools with and without
general programming and not having access to student-level data on program
usage/attendance, we began to shift our focus to food programs.  This file is
the first attempt at discovering which programs serve meals, how often per
week and which months of the year.


### [Performance_v_meals.R](./Performance_v_meals.R)

Here we atempted to find a relationship between the number of meals served by
"At Risk" food programs and the residual performance of a school with an
above average rate of poverty.  We approximated meals offered in a year to a
student by counting the meals served in a week, multiplying by 4, and 
multiplying by the number of months in operation.  Unfortunately, at the school
or program level, the effect is simply too small to be significant.  It is
possible that if we had student-level data (i.e. which students use the
programs, which are eligible for assistance, and which are meeting standards)
a significant relationship would reveal itself.


### [Attendance_v_programs.ipynb](./Attendance_v_programs.ipynb)

Another angle we pursued was whether or not chronic absense was significantly
affected by the presence of programming.  Again, as so many schools have at
least one general program, and without knowing which students are chronically
absent and which attend programming, a significant relationship was not found.
