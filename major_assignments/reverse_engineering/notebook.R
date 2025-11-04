```{r}
# Load required data

# Path to data should be loaded from folder "data" i.e. read_csv("data/name_of_data.csv")
casetypes <- read_csv("/Users/aamalyhossain/Documents/GitHub/data_journalism_2025_spring/major_assignments/reverse_engineering/data/casetypes.csv")
View(casetypes)

department_totals <- read_csv("/Users/aamalyhossain/Documents/GitHub/data_journalism_2025_spring/major_assignments/reverse_engineering/data/department-totals.csv")
View(department_totals)

departments <- read_csv("/Users/aamalyhossain/Documents/GitHub/data_journalism_2025_spring/major_assignments/reverse_engineering/data/departments.csv")
View(departments)

payouts <- read_excel("/Users/aamalyhossain/Documents/GitHub/data_journalism_2025_spring/major_assignments/reverse_engineering/data/payouts.xlsx")
View(payouts)

type_totals <- read_csv("/Users/aamalyhossain/Documents/GitHub/data_journalism_2025_spring/major_assignments/reverse_engineering/data/type-totals.csv")
View(type_totals)

# Clean required data and prepare for analysis if needed. 


```

```{r}
# Load required data
# Path to data should be loaded from folder "data" i.e. read_csv("data/name_of_data.csv")
casetypes <- read_csv("data/casetypes.csv")
departments <- read_csv("data/departments.csv")
payouts <- read_excel("data/payouts.xlsx", skip = 1)
department_totals <- read_csv("data/department-totals.csv")
type_totals <- read_csv("data/type-totals.csv")
# Clean required data and prepare for analysis if needed. 

```

Razak: I was confused about sentence 1 so I did the second one. Here is the what I have for that

### Sentence 1

* **Sentence text**: Last budget year, the city paid out 30 settlements of $1 million or more — five times as many as a decade before.

* **Analysis summary**: I was able to confirm the finding by filtering all the payouts above $1 million and then grouping by fiscal year. 2017 had 30 payouts over a million as the sentence says. For a decade before (2007), there were 6 payouts, which means 2017 was five times the amount of 2007.

```{r}
# Put code to reverse engineer sentence here
payouts |> 
  filter(amount >= 1000000) |> 
  group_by(fiscal_year) |> 
  summarise(
    total_over_million = n()
  ) |> 
  arrange(desc(total_over_million))
# Display results of code below this codeblock
30/6
```



