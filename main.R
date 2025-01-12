library(lubridate)
library(dplyr)

# Read in (sample) data from the Python project's files.
# This is reaching outside of the project's directory, so that needs fixing.
df <- read.csv("../QuickAttendDev/class_data/record.csv", header=FALSE)
colnames(df) <- c("ID", "Date", "Section", "Status")

# Don't hardcode this going forward--have it pull from a file
# And careful, this is using actual production data here
timespan <- interval(start=lubridate::as_date("2025-01-14"),
                     end=lubridate::as_date("2025-05-01"))

classdays <- data.frame(seq(timespan$start, by="day", length.out=as.numeric(lubridate::as.period(timespan, unit="day"), "days")))
colnames(classdays) <- "Date"
# Filter down to Tuesdays and Thursdays
# This is hardcoded--find a way to NOT hardcode it in the future
classdays <- classdays %>% mutate(dow = lubridate::wday(classdays$Date)) %>%
            filter(dow==3 | dow==5)

df <- df %>% group_by(df$Name) %>% summarize(count=n(), percentage=(count/num.days)*100)