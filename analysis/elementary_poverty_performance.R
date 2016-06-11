# import packages for additional functionality
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
programs <- read.csv("../data/OASK_DB.csv")
# Since the only thing we need for this analysis is a count of how many
# programs exist at each school, we simply count how many times each
# SchoolID appears in this list.
# This line grabs the SchoolID column in every row where SchoolID isn't NA.
programs <- programs[!is.na(programs$SchoolID), 1]
# The table function is a quick way to count what's in a vector.
programs <- as.data.frame(table(programs))
# Rename the columns
names(programs) <- c("SchoolID", "Programs")
# Add the counts to the data set we've collected
overall <- merge(overall, programs, all.x = TRUE)
# If a school didn't have a program in the file, we change the NA to a 0
overall$Programs[is.na(overall$Programs)] <- 0
# To keep things simple, we collapse all non-zero counts down to '1+'
overall$Programs[overall$Programs >= 1] <- "1+"
overall$Programs <- as.factor(overall$Programs)

# Compute the mean performance in each wealth category, grouped by
# whether or not the school hosts a program
agg_eng <- aggregate(Eng_Met ~ Impoverished + Programs, data = overall, FUN = median)
agg_math <- aggregate(Math_Met ~ Impoverished + Programs, data = overall, FUN = median)
agg_sci <- aggregate(Sci_Met ~ Impoverished + Programs, data = overall, FUN = median)
# Put all the means back into one data frame
agg <- merge(agg_eng, agg_math)
agg <- merge(agg, agg_sci)
# Instead of one row for each subject, we collect the means
# into separate columns so that each school is a row
agg <- melt(agg, id.vars = 1:2, variable.name = "Subject")
# Human-readable levels
levels(agg$Subject) <- c("English", "Math", "Science")

# These commands generate a plot.  As they're all basically the same,
# we'll just go through this one and update when new methods are used.
# We first define the data set and assign variables to columns
g <- ggplot(data = agg, aes(x = Programs, y = value, group = 1))
# Next we plot a point for each class of school, colored by SchoolType
g <- g + geom_point(aes(color = Impoverished))
# We break the figure into three, one for each Subject
g <- g + facet_grid(. ~ Subject)
# Force symmetric axes
# g <- g + ylim(-10, 10)
# Add x- and y-axis labels and a title
g <- g + ylab("Median Meeting or Exceeding Standards (%)")
g <- g + xlab("Number of Programs")
g <- g + ggtitle("Performance by FRLE and Subject, 2014-15")
g

