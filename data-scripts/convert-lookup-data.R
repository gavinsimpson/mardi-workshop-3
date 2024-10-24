# process the species code dictionary file

# packages
library("googledrive")
library("readxl")
library("readr")
library("tidyr")
library("dplyr")
library("here")

if (!file.exists("data/mardi-names-synonyms.xlsx")) {
  drive_download("MARDI Species names and synonyms.xlsx",
    path = "data/mardi-names-synonyms.xlsx")
}

lkup <- read_xlsx(here("data/mardi-names-synonyms.xlsx"))

mardi_names <- lkup |>
  janitor::clean_names() |>
  rename(
    mardi_code = mardi_species_code
  ) |>
  select(
    mardi_code, species_name, original_name, species_syn1, species_syn2,
    description_ref
  )

spp_dict <- lkup |>
  janitor::clean_names() |>
  rename(
    mardi_code = mardi_species_code
  ) |>
  select(
    mardi_code,
    starts_with(
      "name_in_number_"
    )
  )

spp_dict_long <- spp_dict |>
  pivot_longer(
    cols = !mardi_code,
    names_prefix = "^name_in_number_",
    names_to = "dataset_id",
    values_to = "dataset_code"
  )

write_csv(
    spp_dict_long,
    file = here("data/species-dictionary-long.csv")
  )

write_csv(
    mardi_names,
    file = here("data/mardi-names.csv")
  )
