library(reshape2)
poverty <- read.csv("../data/FreeReducedLunch.csv", stringsAsFactors = FALSE)
poverty <- poverty[, c(1, 5, 8, 11, 14, 17)]
# Eliminate incomplete cases
poverty <- poverty[complete.cases(poverty), ]

schools <- read.csv("../data/schools.csv")
schools <- schools[-613,]

types <- read.csv("../data/RCmediaSchoolsAggregate.csv")[, c(4,8)]

poverty_by_type <- merge(poverty[, c(1,2,5)], schools)
poverty_by_type <- merge(poverty_by_type, types)

poverty_by_type <- aggregate(
  cbind(Enrollment, EligibleStudents) ~ District + SchoolType,
  poverty_by_type,
  FUN = sum
  )
poverty_by_type$poverty <- poverty_by_type$EligibleStudents / poverty_by_type$Enrollment
poverty_by_type <- poverty_by_type[, c(1,2,5)]
poverty_by_type <- dcast(poverty_by_type, District ~ SchoolType)
poverty_by_type <- poverty_by_type[complete.cases(poverty_by_type), c(1,2,4,3)]
