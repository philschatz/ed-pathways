# import packages for additional functionality
library(Hmisc)
library(reshape2)
library(ggplot2)

# Read into a variable from csv, keeping only columns we care about
poverty <- read.csv("../data/FreeReducedLunch.csv", stringsAsFactors = FALSE)
poverty <- poverty[, c(1, 5, 8, 11, 14, 17)]
# Eliminate incomplete cases
poverty <- poverty[complete.cases(poverty), ]

# Read into a variable from csv, keeping only columns we care about
performance <- read.csv("../data/Performance.csv", stringsAsFactors = FALSE)
performance <- performance[, c(3, 6, 7, 9, 10)]
# Shorten terms, column names
performance$Subject[performance$Subject == "English Language Arts"] <- "Eng"
performance$Subject[performance$Subject == "Mathematics"] <- "Math"
performance$Subject[performance$Subject == "Science"] <- "Sci"
performance$Subgroup[performance$Subgroup == "American Indian/Alaskan Native"] <- "NaAmer"
performance$Subgroup[performance$Subgroup == "Black/African American"] <- "Black"
performance$Subgroup[performance$Subgroup == "Econo. Disadvantaged"] <- "EcoDis"
performance$Subgroup[performance$Subgroup == "Extended Assessment"] <- "ExAsmt"
performance$Subgroup[performance$Subgroup == "Hispanic/Latino"] <- "HisLat"
performance$Subgroup[performance$Subgroup == "Indian Education"] <- "IndEd"
performance$Subgroup[performance$Subgroup == "Limited English Proficient (LEP)"] <- "LimEng"
performance$Subgroup[performance$Subgroup == "Migrant Education"] <- "MigEdu"
performance$Subgroup[performance$Subgroup == "Multi-Racial"] <- "Multi"
performance$Subgroup[performance$Subgroup == "Pacific Islander"] <- "PacIsl"
performance$Subgroup[performance$Subgroup == "Students with Disabilities (SWD)"] <- "SWD" 
performance$Subgroup[performance$Subgroup == "SWD with Accommodations"] <- "SWDAcc" 
performance$Subgroup[performance$Subgroup == "Talented and Gifted (TAG)"] <- "TAG"
performance$Subgroup[performance$Subgroup == "Total Population"] <- "Total"
names(performance)[4:5] <- c("Part", "Met")
# Find instances of '> 95.0%' or '< 5.0%' and replace them with '95.0' and '5.0'
performance$Part <- sub("[<>] ([0-9]{1,2}.[0-9])%", "\\1", performance$Part)
performance$Met <- sub("[<>] ([0-9]{1,2}.[0-9])%", "\\1", performance$Met)
# Replace '*' and '-' with NA
performance$Part[performance$Part %in% c("*", "-")] <- NA
performance$Met[performance$Met %in% c("*", "-")] <- NA
# Cast proportions as numeric, so that we can do math on them (they are read in as strings)
performance$Part <- as.numeric(performance$Part)
performance$Met <- as.numeric(performance$Met)
# Reshape into one row per school, one column per Group_Subject_Metric combo (reshape2)
performance <- recast(performance, SchoolID ~ Subgroup + Subject + variable, id.var = 1:3)
# Subset to overall data, schools that have compete data
overall <- performance[, c(1, 100:105)]
overall <- overall[complete.cases(overall), ]
# Merge in poverty data via percent eligible for free/reduced lunches
overall <- merge(poverty[, c(1:2, 6)], overall)
# Remove the 'Total_' before the metrics in the column names
names(overall) <- sub("Total_", "", names(overall))
# Read in and add school type
types <- read.csv("../data/RCmediaSchoolsAggregate.csv")[, c(4,8)]
overall <- merge(types, overall)
# Reorder the SchoolType factor so that they appear in a natural order
overall$SchoolType <- factor(overall$SchoolType, c("E", "M", "H"))
# Remove non-elementary schools
overall <- overall[overall$SchoolType == 'E', -2]

summary(overall$PercentEligible)

# Add an Impoverished column to say whether or not a school is above
# the median level of poverty
overall$Impoverished <- overall$PercentEligible >= median(overall$PercentEligible)

# Read in the programs list
programs <- read.csv("../data/CACFP.csv")
# Filter out non-food programs
food <- programs[programs$Program.Type == 'After School At Risk Meals and Snacks Center',]

# Compute the number of days per week meals are served
food$Breakfast_days <- rowSums(food[, 28:34])
food$Lunch_days <- rowSums(food[, 44:50])
food$Supper_days <- rowSums(food[, 60:66])

# Compute meals per week
food$Weekly_meals <- rowSums(food[, 78:80])

# Compute the number of days per week meals are served
food$AMS_days <- rowSums(food[, 36:42])
food$PMS_days <- rowSums(food[, 52:58])
food$EveS_days <- rowSums(food[, 68:74])

# Compute snacks per week
food$Weekly_snacks <- rowSums(food[, 82:84])

# Compute number of school/summer months the program runs
# (School := Oct - Jun, Summer := Jul - Sep)
food$School_months <- rowSums(food[, 15:23])
food$Summer_months <- rowSums(food[, 24:26])
food$Total_months <- rowSums(food[, 86:87])
# cast SchoolID as NOT a factor
food$SchoolID <- as.character(food$SchoolID)
food <- food[!is.na(as.numeric(food$SchoolID)), c(5, 81, 88)]
# drop schools with no meals
food <- food[food$Weekly_meals > 0, ]
food <- food[order(food$SchoolID), ]
food <- unique(food)

overall <- merge(overall, food, all.x = TRUE)
overall$Weekly_meals[is.na(overall$Weekly_meals)] <- 0
overall$Total_months[is.na(overall$Total_months)] <- 0
overall$Annual_meals <- overall$Weekly_meals * 4 * overall$Total_months
impoverished <- overall[overall$Impoverished,]

# Fit linear models, dependent on school type
fit_eng <- lm(Eng_Met ~ PercentEligible * Annual_meals, data = impoverished, weights = Enrollment)
fit_math <- lm(Math_Met ~ PercentEligible * Annual_meals, data = impoverished, weights = Enrollment)
fit_sci <- lm(Sci_Met ~ PercentEligible * Annual_meals, data = impoverished, weights = Enrollment)

# Unfortunately, Annual_meals is not a significant variable for any subject.
summary(fit_eng)
summary(fit_math)
summary(fit_sci)

# Compute how far removed each school's performances are relative to
# the expectations of the above models (residual performance)
impoverished$ResEng <- impoverished$Eng_Met - predict(fit_eng, impoverished)
impoverished$ResMath <- impoverished$Math_Met - predict(fit_math, impoverished)
impoverished$ResSci <- impoverished$Sci_Met - predict(fit_sci, impoverished)

# Even though it is not significant, we view the size of the effect with a few plots.
# We explain only for the first plot.
p <- ggplot(impoverished, aes(x = Annual_meals, y = ResEng))
# Alpha affects the points' opacity; we also size each dot by Enrollment
p <- p + geom_point(alpha = 0.5, aes(size = Enrollment))
# We want size to scale with area, so that a school twice as big looks so
p <- p + scale_size_area()
# We add a line of best fit
p <- p + geom_smooth(method = lm, se = FALSE)
p <- p + xlab("Annual Meals Available to In Need Students")
p <- p + ylab("Residual English Proficiency (%)")
p <- p + ggtitle("Residual English Proficiency v Meals Provided, 2014-15")
p

p <- ggplot(impoverished, aes(x = Annual_meals, y = ResMath))
p <- p + geom_point(alpha = 0.5, aes(size = Enrollment))
p <- p + scale_size_area()
p <- p + geom_smooth(method = lm, se = FALSE)
p <- p + xlab("Annual Meals Available to In Need Students")
p <- p + ylab("Residual Math Proficiency (%)")
p <- p + ggtitle("Residual Math Proficiency v Meals Provided, 2014-15")
p

p <- ggplot(impoverished, aes(x = Annual_meals, y = ResSci))
p <- p + geom_point(alpha = 0.5, aes(size = Enrollment))
p <- p + scale_size_area()
p <- p + geom_smooth(method = lm, se = FALSE)
p <- p + xlab("Annual Meals Available to In Need Students")
p <- p + ylab("Residual Science Proficiency (%)")
p <- p + ggtitle("Residual Science Proficiency v Meals Provided, 2014-15")
p
