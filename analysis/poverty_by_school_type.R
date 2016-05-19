library(reshape2)
# Read in poverty data, select columns of interest
poverty <- read.csv("../data/FreeReducedLunch.csv", stringsAsFactors = FALSE)
poverty <- poverty[, c(1, 5, 8, 11, 14, 17)]
# Eliminate incomplete cases
poverty <- poverty[complete.cases(poverty), ]

# Read in school data, remove duplicated row (Chief Joseph)
schools <- read.csv("../data/schools.csv")
schools <- schools[-613,]

# Read in SchoolType data
types <- read.csv("../data/RCmediaSchoolsAggregate.csv")[, c(4,8)]

# Merge the collected data into one data frame
poverty_by_type <- merge(poverty[, c(1,2,5)], schools)
poverty_by_type <- merge(poverty_by_type, types)

# Add together the Enrollment and EligibleStudents data for all rows
# that have the same District and SchoolType, thus giving poverty
# totals for each District across SchoolTypes (ain't R great?)
poverty_by_type <- aggregate(
  cbind(Enrollment, EligibleStudents) ~ District + SchoolType,
  poverty_by_type,
  FUN = sum
  )
# Compute a percentage in poverty for each District + SchoolType
poverty_by_type$poverty <- poverty_by_type$EligibleStudents / poverty_by_type$Enrollment
# Subset the columns to what we still care about
poverty_by_type <- poverty_by_type[, c(1,2,5)]
# Instead of three rows for each District (one for each SchoolType),
# get one row for each District and three poverty columns
poverty_by_type <- dcast(poverty_by_type, District ~ SchoolType)
# Drop Districts for which we don't have at least one of each SchoolType,
# and reorder columns
poverty_by_type <- poverty_by_type[complete.cases(poverty_by_type), c(1,2,4,3)]
