setwd("~/OneDrive - Cuny GradCenter/Mobility/replicate_psid")
library(tidyverse)
library(stringr)

sink("out79.txt")

data <- readRDS("./data/nlsy_data")
#str(data)

data <- data %>%gather(var, val, -c(CASEID_1979, SAMPLE_RACE_78SCRN, SAMPLE_SEX_1979, SAMPLE_ID_1979))

data$job_num_1 <- str_sub(data$var, -7, -8)
data$year_1 <- str_sub(data$var, -4, -1)
data$year_2 <- str_sub(data$var, -12, -9)
data$new_var1 <- str_sub(data$var, 1, -6)
data$new_var2 <- str_sub(data$var, 1, -15)

data$year <- with(data, ifelse(year_1=="XRND", year_2, year_1))
data$new_var <- with(data, ifelse(year_1=="XRND", new_var2, new_var1))
data$job_num <- with(data, ifelse(year_1 == "XRND", job_num_1, ""))

data$new_var_num <- with(data, paste0(new_var, job_num))
data <- data %>% select(CASEID_1979,SAMPLE_ID_1979, SAMPLE_RACE_78SCRN, SAMPLE_SEX_1979, val, new_var_num) %>% mutate(indid=row_number()) %>% spread(new_var_num, val)

saveRDS(data, "./data/nsly79_data_1")
sink()
