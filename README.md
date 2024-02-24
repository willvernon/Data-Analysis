---
title: "NYPD_Shooting_Incident_Data_Report"
date: "2024-02-24"
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



### Cleaning Data to remove any unneeded columns



I removed most of the data that was not necessary like the coordinates, Lat, and Long also other codes/numbers that were not needed.

### Cleaning Age Group Data

Lots of unknown numbers and mixture of null and unknown. Moved them all into the unknown column.

# Data Analysis

## Summary Statistics

## Data Visualization

Now creating a simple visualization to see the distribution of data.


### Layer Bar Graph


### Finding Demographic

Location of the incidents along with the proper age range. I already cleaned the age range there was lots of unknown.

# Model

Creating the Model using date of incident, incident resulting in deaths, and incidents.

# Analysis

### Bias: 

can come from the reports and also people not reporting any incidents. I do not find myself having much of a bias other than i do not like gang violence.

## Daily Counts of incidents

This shows a very high correlation with more incidents in the warmer seasons of the year and a drop off in the colder seasons of the year. This is to expected with more activity outside and mixing with other people during the warm seasons and less activity in the colder seasons.

## Boros

Based on the information provided by the State of New York we can see some distinct trends. Two of the five Boros make up the majority of the shooting incidents (Bronx and Brooklyn) with the next Boro Queens coming in third with half the amount of shootings as Bronx and nearly a 1/3 of the incidents of Brooklyn. It's hard to justify exactly why that is base on the limited information and only having the shooting reports. Also to keep in mind these are only the reported incidents and there should be some acknowledgment for those incidents that did not go reported. From this information alone one could guess this would have to do with either gang activity or lack of police in these areas compared to other Boros of NYC.

## Age Range

Taking a look at the Perpetrator and Victim age groupings is very interesting these can tell a good amount of stories on their own. From what you can see i combined null NA and unknown into one unknown column. Having such a significant Perpetrator column as "Unknown" most likely means they were never caught. These Perpetrators not being caught could also support the suspicion that there is lower policing in these areas leading to more Perpetrators going uncaught. This could also be related to gang activity as well if they go uncaught and continue to commit shooting incidents which would lead to more incidents in specific areas compared to others. The age groups also so a very large number of people in the military fighting age which is to be expected with gang activity mixed with the facts of having a firearm in NYC being illegal for most also would correlate these with gang activity as well.
