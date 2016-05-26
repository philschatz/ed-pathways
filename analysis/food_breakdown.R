# Read in program data
programs <- read.csv('../data/CACFP.csv')

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
food <- food[, c(5, 2, 3, 78:88)]
