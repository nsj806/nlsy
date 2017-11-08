# setwd("~/OneDrive - Cuny GradCenter/Mobility/replicate_psid")
library(dplyr)
library(tidyr)
library(stringr)

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
print(head(data))

data$indid <- rownames(data)

data <- data %>% select(CASEID_1979,SAMPLE_ID_1979, SAMPLE_RACE_78SCRN, SAMPLE_SEX_1979, val,year, indid, new_var_num)

saveRDS(data, "./data/nsly79_data_1")
data <- readRDS("./data/nsly79_data_1")
print(table(data$new_var_num))
print(head(table(data$indid)[order(-table(data$indid))]))
data_wide <- reshape2::dcast(data, CASEID_1979+SAMPLE_RACE_78SCRN+SAMPLE_SEX_1979+year+SAMPLE_ID_1079~new_var_num, value.var=c("val"))
print("done")
saveRDS(data_wide, "./data/nsly79_data_w")
