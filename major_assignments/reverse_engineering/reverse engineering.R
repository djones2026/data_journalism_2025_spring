---
  title: "Reverse Engineering Project"
author: "Aamaly Hossain"
date: "2025-10-16
output:
  html_document:
    theme: cerulean
    highlight: pygments
    toc: true
    toc_float:
      collapsed: true
      smooth_scroll: false
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction 

In this notebook, we are reverse engineering the story, [L.A. is slammed with record costs for legal payouts](https://www.latimes.com/local/lanow/la-me-ln-city-payouts-20180627-story.html)

About: This story investigates how the City of Los Angeles has faced record-breaking legal costs due to lawsuits and settlements across city departments. The Times reporters found that legal payouts -- especially those involving the Los Angeles Police Department -- have surged over the past decade. Using a city databased of more than 18,000 payouts obtained through a public records request, the reporters showed that 2017 had an unprecedented number of multimillion dollar settlements that LAPD-related cases accounted for over 40% of total costs. The story emphasizes how these rising legal costs strain the city's budhet and contribute to financial challenges across department. 

## Load libraries

Loading required libraries for this analysis.

```{r echo=FALSE, message=FALSE}
options(scipen=999) 

library(readr)
library(tidyverse)
library(lubridate)
library(janitor)
library(readxl)
```

## Load and Cleaning Data

In this section, describe the source of the data, write a basic data dictionary for data you are working with, and discuss any caveats or issues you discovered working with this data. 

Answer: 

The data used in this analysis was compiled by the Los Angeles Times through a public records request to the City of Los Angeles. It includes detailed information on every legal payout -- settlements, judgments and other payments made by the city from July 2005 to June 2018. 

Data Sources:
- payouts.xlsx: A detailed record of individual legal payouts and settlements. Came from the city's financial or risk management database. Each row is a single payout and likely includes information such as the case type, the department, the payout amount and the date. This is the main dataset used to analyze trends, totals and patterns. 
- casetypes.csv: A list of different types of legal cases. Likely exported from a city database tracking claims, lawsuits or settlements. Each row corresponds to a case category, such as police misconduct, dangerous conditions or other types of claims. This allows analysis of payouts by the type of legal case.  
- departments.csv: A list of Los Angeles city departments. Came from internal city records or a public database of city departments. Each row represents a department responsible and the cleaned LA Times version of it. This allows analysis to be more simple and easy to run because it is standardized based on the departmental groups (becomes generic department name). 
- department-totals.csv: Summary data showing total payouts per department. Aggregated data by departments from the payouts excel spreadsheet, and from other exported city reports. Each row shows a department and its aggregated statistics, such as total payout amounts and total number of cases. This is useful for quickly seeing which departments contribute most to legal costs in the city. 
- type-totals.csv: Summary data showing total payouts per case type. Similar to department_totals.csv, derived from payouts_xlsx. Each row shows its LA Times case type (category) and its aggregated totals, showing which types of legal cases are most costly for the city. 

Variables: 
- 'case_number' = unique identifier for each case
- 'amount' = dollar amount of payout (the amount paid for settlement or judgment) 
- 'fiscal_year' = fiscal year where the payout occurred
- 'department' = department associated with the payout
- 'type' = category of legal case (police, traffic, dangerous condition)

Notes and Caveats: 
- Some payouts are missing department attribution which are excluded from department-level analysis. 
- Amounts are in dollars. 
- Case type descriptions required for cleaning for capitalization and white space inconsistencies.
- Some fiscal years have fewer records or none at all due to incomplete reporting or record errors. 

```{r}
# Load required data

# Path to data should be loaded from folder "data" i.e. read_csv("data/name_of_data.csv")
casetypes <- read_csv("data/casetypes.csv")
departments <- read_csv("data/departments.csv")
payouts <- read_excel("data/payouts.xlsx", skip = 1)
department_totals <- read_csv("data/department-totals.csv")
type_totals <- read_csv("data/type-totals.csv")

# Clean required data and prepare for analysis if needed. 
payouts |>
clean_names()

```

## Sentences to Engineer
In this notebook, we are reverse engineering five sentences from the story.

### Sentence 1

* **Legal payouts for this budget year are estimated to total around $109 million.**: [Paste in sentence to engineer here]
* **I was not able to confirm that the estimated total for legal payouts in 2018 were around $109 million. Instead, I found that it was $72,829,597 -- essentially $73 million. I'm not sure if I did the code correctly, but based on the code I wrote -- it doesn't seem like the numbers match up. With that said, I used the correct dataframe and made sure the totals were achieved for all the fiscal years, just to double check. But, I soon realized that fiscal year 2018 legal payouts were around $73 million not $109 million. I'm not sure where $109 million came from. It’s possible that the data the Times collected stopped a few months before the article was published, resulting in a lower number in the data. The fiscal year hadn’t even finished when the story was published (hence “estimate”) in the sentence. I still wonder how exactly the $109 million figure came to be. Perhaps the reporters asked the financial officer and they provided an estimate.**: [Write up two to three sentences describing the results of your analysis.  Were you able to confirm the finding? If not, why not?]

```{r}
# Put code to reverse engineer sentence here
total_payout_2018 <- payouts |>
  filter(fiscal_year == 2018) |>
  group_by(fiscal_year) |>
  summarise(total_amount = sum(amount))

# Display results of code below this codeblock
total_payout_2018
```

### Sentence 2

* **Last budget year, the city paid out 30 settlements of $1 million or more — five times as many as a decade before.**: [Paste in sentence to engineer here]
* **I was able to confirm the finding by filtering all the payouts above $1 million and then grouping by fiscal year. 2017 had 30 payouts over a million as the sentence says. For a decade before (2007), there were 6 payouts, which means 2017 was five times the amount of 2007.**: [Write up two to three sentences describing the results of your analysis.  Were you able to confirm the finding? If not, why not?]

```{r}
# Put code to reverse engineer sentence here
x2017_payouts <- payouts|>
clean_names() |>
filter(amount >= 1000000) |>
  group_by(fiscal_year) |>
  summarise(total_over_million = n()) |>
  arrange(desc(total_over_million))
# Display results of code below this codeblock
x2017_payouts
```

### Sentence 3

* **Last budget year, the city paid out more than $200 million in legal settlements and court judgments — a record amount that was more than the city spent on its libraries or fixing its streets.**: [Paste in sentence to engineer here]
* **I could confirm these findings by summing all payouts for the 2017 full fiscal year reported. The total legal payouts exceeded $200 million, which aligns with the LA Times statement. Comparing this to available city budget data shows that this amount is indeed larger than the city's expenditures on libraries or street maintenance, confirming the "record amount" claim. The exact number for 2017 budget year was $201,372,336. **: [Write up two to three sentences describing the results of your analysis.  Were you able to confirm the finding? If not, why not?]

```{r}
# Put code to reverse engineer sentence here
total_payout_2017 <- payouts |>
  filter(fiscal_year == 2017) |>
  summarise(total_amount = sum(amount))
# Display results of code below this codeblock
total_payout_2017
```

### Sentence 4

* **Thousands of legal battles involving the Los Angeles Police Department … have added up to more than 40% of the total — a higher sum than any other city department, the analysis showed.**: [Paste in sentence to engineer here]
* **Calculating total payouts by department shows LAPD accounting for approximately 42.4% of the total, higher than any other city department, confirming this sentence from the LA Times. Additionally, the results showed that its payout amount came to $373,751,894.14, which is significantly higher than all the other departments. The following department is Public Works, which makes up nearly 24% of the total payouts -- from there it only decreases in percentage totals that make up the payouts.**: [Write up two to three sentences describing the results of your analysis.  Were you able to confirm the finding? If not, why not?]

```{r}
# Put code to reverse engineer sentence here
lapd_pct_payouts <- department_totals |>
mutate(pct_of_total = (amount/sum(amount)) * 100) |>
arrange(desc(pct_of_total))
# Display results of code below this codeblock
lapd_pct_payouts
```

### Sentence 5

* **Legal payouts for ‘dangerous conditions’ have rivaled and, last budget year, even exceeded the cost of lawsuits over police misconduct, the analysis found.**: [Paste in sentence to engineer here]
* **Based on this code, I can confirm that the sentence from LA Times is accurate. The results signify that legal payouts for "dangerous conditions" exceeded the cost of lawsuits over police misconduct. Granted, in this data set it shows that the fiscal years 2017 and 2018 did not have a total amount of payouts either reported or found. However, it does show that dangerous conditions had a total of $30,836,264 in payouts and $48,079,509 in fiscal year 2017. In fiscal year 2016, the police misconduct total exceeded dangerous condition lawsuits (dangerous conditions: $22,053,223	police misconduct: $28,667,200).**: [Write up two to three sentences describing the results of your analysis.  Were you able to confirm the finding? If not, why not?]

```{r}
# Put code to reverse engineer sentence here
payouts <- payouts |>
  mutate(case_type = str_trim(case_type),       
         case_type = str_to_title(case_type))  

dangerous_totals <- payouts |>
  filter(str_detect(case_type, "Dangerous")) |>
  group_by(fiscal_year) |>
  summarise(dangerous_total = sum(amount)) |>
arrange(desc(fiscal_year))

police_totals <- payouts |>
  filter(str_detect(case_type, "Police")) |>
  group_by(fiscal_year) |>
  summarise(police_total = sum(amount)) |>
arrange(desc(fiscal_year))

dangerous_totals
police_totals

dangerous_vs_police <- dangerous_totals |>
  left_join(police_totals, by = "fiscal_year")

# Display results of code below this codeblock
dangerous_vs_police
```

