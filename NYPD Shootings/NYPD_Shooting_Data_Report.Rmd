---
title: "NYPD_Shooting_Incident_Data_Report"
date: "2024-02-24"
output:
  pdf_document: default
  html_document: default
---

# Introduction

This report is to provide a data analysis of NYPD Shooting Incidents. The data was collected by the city of New York.

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(dplyr)
library(ggplot2)
```

## Data Import and Cleaning

```{r loading data}

nypd_data <- read_csv("https://data.cityofnewyork.us/api/views/833y-fsy8/rows.csv?accessType=DOWNLOAD")

head(nypd_data)
summary(nypd_data)

```

### Cleaning Data to remove any unneeded columns

```{r data cleaning}

# Removing Columns that are not needed for this analysis 
ny_shootings <- select(nypd_data, 
                       -INCIDENT_KEY, 
                       -PRECINCT,
                       -LOCATION_DESC,
                       -LOC_OF_OCCUR_DESC, 
                       -JURISDICTION_CODE,
                       -LOC_CLASSFCTN_DESC,
                       -X_COORD_CD,
                       -Y_COORD_CD,
                       -Latitude,
                       -Longitude,
                       -Lon_Lat,
                       )

```

I removed most of the data that was not necessary like the coordinates, Lat, and Long also other codes/numbers that were not needed.

### Cleaning Age Group Data

Lots of unknown numbers and mixture of null and unknown. Moved them all into the unknown column.

```{r Age Group Cleanign}
ny_shootings <- ny_shootings %>%
    mutate(PERP_AGE_GROUP = ifelse(PERP_AGE_GROUP %in% c("UNKNOWN","unknown", NA, NULL, "(null)", "940", "1020", "224"), "unknown", PERP_AGE_GROUP))

ny_shootings <- ny_shootings %>%
    mutate(VIC_AGE_GROUP = ifelse(VIC_AGE_GROUP %in% c("UNKNOWN","unknown", "1022"), "unknown", VIC_AGE_GROUP))
```

# Data Analysis

## Summary Statistics

```{r summary}
summary(ny_shootings)
```

## Data Visualization

Now creating a simple visualization to see the distribution of data.

```{r setup for visualization}

# Ensure 'OCCUR_DATE' is in Date format
Dates <- as.Date(ny_shootings$OCCUR_DATE, format = "%m/%d/%y")
ny_shootings$OCCUR_DATE <- Dates

# Summarize the data to get the count of events for each date
daily_counts <- ny_shootings %>%
  group_by(OCCUR_DATE) %>%
  summarise(count = n(), 
            deaths = sum(STATISTICAL_MURDER_FLAG == "TRUE", na.rm = TRUE))
```

### Layer Bar Graph

```{r Layer Bar Graph}
ggplot(daily_counts, aes(x = OCCUR_DATE)) +
  geom_col(aes(y = count), fill = "blue", alpha = 0.5) +  # Layer for total count
  geom_col(aes(y = deaths), fill = "red", alpha = 0.5) +  # Layer for deaths
  theme_minimal() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  labs(title = "Daily Shooting Incidents in NYC", x = "Date", y = "Number of Incidents")
```

### Finding Demographic

Location of the incidents along with the proper age range. I already cleaned the age range there was lots of unknown.

```{r Boro}
# Summarize the data to get the count of events for each Boro
boro_counts <- ny_shootings %>%
  group_by(BORO) %>%
  summarise(count = n(), 
            deaths = sum(STATISTICAL_MURDER_FLAG == "TRUE", na.rm = TRUE))
```

```{r Visualization of Boro Count}
ggplot(boro_counts, aes(x = BORO, y = count)) +
    geom_col(aes(y = count), fill = "blue", alpha = 0.5) +
    geom_col(aes(y = deaths), fill = "red", alpha = 0.5) +
    theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 90, vjust = 0.5))+
    labs(title = "Shooting Incidients Per Boro NYC", x = "Boro", y = "Number of Incidents")
```

```{r Perp Age Range}
# Summarize the data to get the count of events for each Age Group
perp_age_group_counts <- ny_shootings %>%
  group_by(PERP_AGE_GROUP) %>%
  summarise(count = n(), 
            deaths = sum(STATISTICAL_MURDER_FLAG == "TRUE", na.rm = TRUE))
```

```{r Visualization of Perp Age Group}

ggplot(perp_age_group_counts, aes(x = PERP_AGE_GROUP, y = count)) +
    geom_col(aes(y = count), fill = "blue", alpha = 0.5) +
    geom_col(aes(y = deaths), fill = "red", alpha = 0.5) +
    theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 90, vjust = 0.5))+
    labs(title = "Shooting Incidients Per Perp Age Group NYC", x = "Perp Age Group", y = "Number of Incidents  (red = deaths)")
```

```{r Vic Age Range}
# Summarize the data to get the count of events for each Age Group
vic_age_group_counts <- ny_shootings %>%
  group_by(VIC_AGE_GROUP) %>%
  summarise(count = n(), 
            deaths = sum(STATISTICAL_MURDER_FLAG == "TRUE", na.rm = FALSE))
```

```{r Visualization of Vic Age Group}

ggplot(vic_age_group_counts, aes(x = VIC_AGE_GROUP, y = count)) +
    geom_col(aes(y = count), fill = "blue", alpha = 0.5) +
    geom_col(aes(y = deaths), fill = "red", alpha = 0.5) +
    theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 90, vjust = 0.5))+
    labs(title = "Shooting Incidients Per Victim Age Group NYC", x = "Victim Age Group", y = "Number of Incidents  (red = deaths)")
```

# Model

Creating the Model using date of incident, incident resulting in deaths, and incidents.

```{r Model}

# Aggregate data by date to get daily counts of incidents and deaths
daily_summary <- ny_shootings %>%
  group_by(OCCUR_DATE) %>%
  summarise(incidents = n(),
            deaths = sum(STATISTICAL_MURDER_FLAG == "TRUE", na.rm = TRUE))

# Fit a GLM (e.g., Poisson regression for count data)
mod <- glm(deaths ~ incidents, data = daily_summary)
summary(mod)

daily_pred <- daily_summary %>% mutate(pred = predict(mod))

daily_pred %>% ggplot() + 
    geom_point(aes(x = incidents, y = deaths), color = "blue")+
    geom_point(aes(x = incidents, y = pred), color = "red")


```

# Analysis

### Bias: 

can come from the reports and also people not reporting any incidents. I do not find myself having much of a bias other than i do not like gang violence.

## Daily Counts of incidents

This shows a very high correlation with more incidents in the warmer seasons of the year and a drop off in the colder seasons of the year. This is to expected with more activity outside and mixing with other people during the warm seasons and less activity in the colder seasons.

## Boros

Based on the information provided by the State of New York we can see some distinct trends. Two of the five Boros make up the majority of the shooting incidents (Bronx and Brooklyn) with the next Boro Queens coming in third with half the amount of shootings as Bronx and nearly a 1/3 of the incidents of Brooklyn. It's hard to justify exactly why that is base on the limited information and only having the shooting reports. Also to keep in mind these are only the reported incidents and there should be some acknowledgment for those incidents that did not go reported. From this information alone one could guess this would have to do with either gang activity or lack of police in these areas compared to other Boros of NYC.

## Age Range

Taking a look at the Perpetrator and Victim age groupings is very interesting these can tell a good amount of stories on their own. From what you can see i combined null NA and unknown into one unknown column. Having such a significant Perpetrator column as "Unknown" most likely means they were never caught. These Perpetrators not being caught could also support the suspicion that there is lower policing in these areas leading to more Perpetrators going uncaught. This could also be related to gang activity as well if they go uncaught and continue to commit shooting incidents which would lead to more incidents in specific areas compared to others. The age groups also so a very large number of people in the military fighting age which is to be expected with gang activity mixed with the facts of having a firearm in NYC being illegal for most also would correlate these with gang activity as well.
