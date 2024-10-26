# Process data sets

# Packages
library("readxl")
library("here")
library("dplyr")
library("tidyr")
library("fs")
library("readr")
library("stringr")

# folder for processed data
if (!dir_exists(here("data/processed"))) {
  dir_create(
    here("data/processed")
  )
}

# Data set 1
ds1 <- read_excel(here("data/raw/01/01-spp-data.xlsx")) |>
  rename(
    sample = "Station No." # rename a variable
  ) |>
  select(
    !c("...54", "TOTAL")
  ) |>
  mutate(
    sample = str_replace_all(sample, "\\.0$", "")
  ) |>
  mutate(dataset = rep("1", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  group_by(sample) |>
  mutate(percentage = (count / sum(count)) * 100) |>
  ungroup() |>
  filter(
    count != 0
  )

# write this to data/processed/01
if (!dir_exists(here("data/processed/01"))) {
  dir_create(
    here("data/processed/01")
  )
}

write_csv(
  ds1,
  file = here("data/processed/01/01-spp-data.csv")
)

# Data set 2

## No data

# Data set 3
ds3 <- read_excel(here("data/raw/03/03-spp-data.xlsx")) |>
  rename(
    sample = "Station" # rename a variable
  ) |>
  mutate(dataset = rep("3", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

# write this to data/processed/03
if (!dir_exists(here("data/processed/03"))) {
  dir_create(
    here("data/processed/03")
  )
}

write_csv(
  ds3,
  file = here("data/processed/03/03-spp-data.csv")
)

# Data set 4
# ds4a is mimmi's circum greenland oksman
# I stored this as 04c-spp-data.xlsx in ./data/raw
ds4a <- read_excel(here("data/raw/04/04c-spp-data.xlsx")) |>
  rename(
    sample = "Sample" # rename a variable
  ) |>
  mutate(dataset = rep("4a", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  group_by(sample) |>
  mutate(percentage = (count / sum(count)) * 100) |>
  ungroup() |>
  filter(
    count != 0
  )

# write this to data/processed/04
if (!dir_exists(here("data/processed/04"))) {
  dir_create(
    here("data/processed/04")
  )
}

write_csv(
  ds4a,
  file = here("data/processed/04/04a-spp-data.csv")
)

# ds4b are Kaarina's data
# I stored this as 04b, 04d, and 04e -spp-data.xlsx in ./data/raw
# will need to keep only two samples from Station N data
# Young Sound == 04e
ds4b_young <- read_excel(here("data/raw/04/04e-spp-data.xlsx")) |>
  rename(
    sample = "CODE Ribeiro et al. 2017"
  ) |>
  rename(
    name = NAME # this is what is siteID in the metadata
  ) |>
  select(
    !name
  ) |>
  mutate(dataset = rep("4b", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

# Qaannaq data is 04b
ds4b_qaannaq <- read_excel(here("data/raw/04/04b-spp-data.xlsx")) |>
  rename(
    sample = "...1"
  ) |>
  mutate(dataset = rep("4a", n())) |> # this is 4a in metadata!!!
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

# Station North is 4d
ds4b_station_n <- read_excel(here("data/raw/04/04d-spp-data.xlsx")) |>
  rename(
    sample = "...1"
  ) |>
  select(
    !Sum
  ) |>
  filter(
    sample %in% c("1A - K33", "1K - K11")
  ) |>
  #mutate(
  #  sample = str_replace(sample, " - ", "_")
  #) |>
  mutate(dataset = rep("4b", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  group_by(sample) |>
  mutate(percentage = (count / sum(count)) * 100) |>
  ungroup() |>
  filter(
    count != 0
  )

ds4b <- ds4b_qaannaq |>
  bind_rows(
    ds4b_young,
    ds4b_station_n
  )

# write this to data/processed/04
if (!dir_exists(here("data/processed/04"))) {
  dir_create(
    here("data/processed/04")
  )
}

write_csv(
  ds4b,
  file = here("data/processed/04/04b-spp-data.csv")
)

# Data set 5

## Data set 5 is actually 3 data sets
# * 5a sheet Sancetta
# * 5b sheet Caissie
# * 5c sheet Nesterovich
ds5a <-
  read_excel(
    here("data/raw/05/05-spp-data.xlsx"),
    sheet = "Sancetta Data"
  ) |>
  rename(
    sample = "Sample" # rename a variable
  ) |>
  select(
    !c("Lat", "Long", "...34", "Total") # drop the row totals?
  ) |>
  mutate(dataset = rep("5a", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

# write this to data/processed/05
if (!dir_exists(here("data/processed/05"))) {
  dir_create(
    here("data/processed/05")
  )
}

write_csv(
  ds5a,
  file = here("data/processed/05/05a-spp-data.csv")
)

ds5b <- read_excel(
  here("data/raw/05/05-spp-data.xlsx"),
  sheet = "Caissie Data"
) |>
  select(
    !c("Lat", "Lon", "Cruise", "worker", "Number", "Station",
      "Grand Total", "Frag SUM", "Chaetoceros SUM", "DAR") # drop these
  ) |>
  rename(
    sample = Sample
  ) |>
  relocate(sample, .before = 1) |>
  mutate(dataset = rep("5b", n())) |> # add a dataset column 
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

write_csv(
  ds5b,
  file = here("data/processed/05/05b-spp-data.csv")
)

ds5c <- read_excel(
  here("data/raw/05/05-spp-data.xlsx"),
  sheet = "Nesterovich Data",
  skip = 1L
) |>
  filter(
    !is.na(SAMPLE)
  ) |>
  mutate(
    number = case_when(
      is.na(number) ~ "",
      .default = as.character(number)
    ),
    number = str_remove(number, "\\.0$") # was stored as number
  ) |>
  rename(
    sample = SAMPLE
  ) |>
  select(
    !c(cruise, number, lat, long, Species, Total, station)
  ) |>
  relocate(
    sample, .before = 1
  ) |>
  mutate(dataset = rep("5c", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  filter(
    percentage != 0
  )

write_csv(
  ds5c,
  file = here("data/processed/05/05c-spp-data.csv")
)

# Data set 6
ds6 <- read_excel(here("data/raw/06/06-spp-data.xlsx")) |>
  rename(
    sample = "Sample" # rename a variable
  ) |>
  select(
    !c(lat, long, Reworked, Other, Total, "...50", "...52")
  ) |>
  mutate(dataset = rep("6", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  mutate(
    percentage = percentage * 100 # data are proportions
  ) |>
  filter(
    percentage != 0
  )

# write this to data/processed/03
if (!dir_exists(here("data/processed/06"))) {
  dir_create(
    here("data/processed/06")
  )
}

write_csv(
  ds6,
  file = here("data/processed/06/06-spp-data.csv")
)

# Data set 7
ds7 <- read_excel(here("data/raw/07/07-spp-data.xlsx")) |>
  rename(
    sample = "Sample/ Lab nr" # rename a variable
  ) |>
  select(
    !c(Latitude, Longitude, "Cruise and site nr", "Water depth (m)",
      "...6", "Total nb of counted diatoms",
      "Nb frustules/g dry sediment",
      "Nb valves /g dry sediment"
    )
  ) |>
  mutate(dataset = rep("7", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  filter(!is.na(sample)) |> # remove the total row
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  group_by(sample) |>
  mutate(percentage = (count / sum(count)) * 100) |>
  ungroup() |>
  filter(
    count != 0
  )

# write this to data/processed/03
if (!dir_exists(here("data/processed/07"))) {
  dir_create(
    here("data/processed/07")
  )
}

write_csv(
  ds7,
  file = here("data/processed/07/07-spp-data.csv")
)

# Data set 8
ds8 <- read_excel(here("data/raw/08/08-spp-data.xlsx")) |>
  rename(
    sample = "Sample" # rename a variable
  ) |>
  select(
    !c(Lat, Long)
  ) |>
  mutate(dataset = rep("8", n())) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "percentage",
    values_drop_na = TRUE
  ) |>
  mutate(
    percentage = percentage * 100 # original data are proportions
  ) |>
  filter(
    percentage != 0
  )

# write this to data/processed/03
if (!dir_exists(here("data/processed/08"))) {
  dir_create(
    here("data/processed/08")
  )
}

write_csv(
  ds8,
  file = here("data/processed/08/08-spp-data.csv")
)

## DS9
ds9 <- read_excel(here("data/raw/09/09-spp-data.xlsx"),
  sheet = "diatom counts") |>
  rename(
    sample = Site
  ) |>
  mutate(
    dataset = rep("9", n()),
    sample = as.character(sample)
  ) |> # add a dataset column
  relocate(dataset, .before = 1) |>
  pivot_longer(
    -c(dataset, sample),
    names_to = "taxon_code",
    values_to = "count",
    values_drop_na = TRUE
  ) |>
  group_by(sample) |>
  mutate(percentage = (count / sum(count)) * 100) |>
  ungroup() |>
  mutate(
    taxon_code = str_replace_all(taxon_code, "[\r\n]", "")
  ) |>
  filter(
    count != 0
  )

# write this to data/processed/03
if (!dir_exists(here("data/processed/09"))) {
  dir_create(
    here("data/processed/09")
  )
}

write_csv(
  ds9,
  file = here("data/processed/09/09-spp-data.csv")
)

## DS10
ds10 <- read_excel(here("data/raw/10/10-spp-data.xlsx"))
ds10 <- ds10[-c(2, 3, 4), ]
ds10 <- ds10 |>
  mutate(
    across(
      .cols = where(
        ~ is.character(.x)
      ) & !matches("Sample"),
      .fns = ~ as.numeric(.x)
    )
  ) |>
  pivot_longer(
    cols = !Sample,
    names_to = "sample",
    values_to = "value"
  ) |>
  filter(
    Sample != "Total Counted"
  ) |>
  pivot_wider(
    names_from = "Sample",
    values_from = "value"
  ) |>
  pivot_longer(
    cols = !sample,
    names_to = "taxon_code",
    values_to = "percentage"
  ) |>
  mutate(
    dataset = rep("10", n()),
    sample = as.character(sample)
  ) |>
  relocate(dataset, .before = 1) |>
  filter(
    percentage != 0
  )

# write this to data/processed/10
if (!dir_exists(here("data/processed/10"))) {
  dir_create(
    here("data/processed/10")
  )
}

write_csv(
  ds10,
  file = here("data/processed/10/10-spp-data.csv")
)

## join all data sets
ds_all <- ds1 |>
  bind_rows(
    ds3,
    ds4a,
    ds4b,
    ds5a, ds5b, ds5c,
    ds6,
    ds7,
    ds8,
    ds9,
    ds10
  )

write_csv(
  ds_all,
  file = here("data/processed/combined-diatom-data-long.csv")
)
