library(tidyverse)
library(lubridate)
library(directlabels)
library(RColorBrewer)
add_release_day_number <-
  function(df_release,
           yyyy,
           mm,
           dd)
  {
    START_DATE <-
      make_datetime(yyyy, mm, dd, 0, 0, 0,
                    tz = "UTC")
    
    return (df_release %>%
              mutate(release_day_number =
                       (floor(interval(
                         START_DATE, created
                       ) / days(1))) + 1))
  }

create_desktop_df_release_week_num_questions <-
  function(df, release, yyyy, mm, dd)
  {
    # df is CSV with date time, release is "65"
    # yyyy, mm, dd are integers e.g. 2019, 1, 29
    # remove all questions before january 29, 2019
    ymd_str <- sprintf("%d-%d-%d", yyyy, mm, dd)
    release_start <- ymd(ymd_str, tz = "UTC")
    release_end <- release_start + weeks(4)
    release_questions <-
      df %>% 
      filter(created >= release_start & created < release_end)
    # add day of release week i.e, 1, 2, 3, 4, 5,6, 7..28
    release_questions <-
      add_release_day_number(release_questions, yyyy, mm, dd)
    release_questions <- release_questions %>% 
      group_by(release_day_number) %>% 
      count()
    release_questions <- add_column(release_questions, release = release)
    return (
      release_questions %>% 
      ungroup() %>% 
      dplyr::mutate(cumulutive_sum = cumsum(n)))
  }
jan2019_06june2020_questions <- 
  read_csv("https://raw.githubusercontent.com/rtanglao/rt-kits-api2/master/ARBITRARY_TIME_PERIOD/sorted-all-desktop-en-us-2019-01-01-2020-06-06-firefox-creator-answers-desktop-all-locales.csv")
# change created unix time to r time UTC using as_datetime()
jan2019_06june2020_questions <- 
  jan2019_06june2020_questions %>%
  mutate(
    created = as_datetime(created, tz = "UTC")
    )

ff65_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "65", 2019, 1, 29)
ff66_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "66", 2019, 3, 19)
ff67_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "67", 2019, 5, 21)
ff68_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "68", 2019, 7, 9)
ff69_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "69", 2019, 9, 3)
ff70_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "70", 2019, 10, 22)
ff71_questions <- create_desktop_df_release_week_num_questions(
jan2019_06june2020_questions, "71", 2019, 12, 3)
ff72_questions <- create_desktop_df_release_week_num_questions(
  jan2019_06june2020_questions, "72", 2020, 1, 7)
ff73_questions <- create_desktop_df_release_week_num_questions(
    jan2019_06june2020_questions, "73", 2020, 2, 11)
ff74_questions <- create_desktop_df_release_week_num_questions(
    jan2019_06june2020_questions, "74", 2020, 3, 10)
ff75_questions <- create_desktop_df_release_week_num_questions(
    jan2019_06june2020_questions, "75", 2020, 4, 7)
jan2019_06june2020_questions_by_release_week <- 
ff76_questions <- create_desktop_df_release_week_num_questions(
    jan2019_06june2020_questions, "76", 2020, 5, 5)
ff77_questions <- create_desktop_df_release_week_num_questions(
    jan2019_06june2020_questions, "77", 2020, 6, 2)

jan2019_06june2020_questions_by_release_week <- 
  bind_rows(ff65_questions, ff66_questions, ff67_questions, 
            ff68_questions, ff69_questions, ff70_questions,
            ff71_questions, ff72_questions, ff73_questions,
            ff74_questions, ff75_questions, ff76_questions,
            ff77_questions)

jan2019_06june2020_plot <- 
  ggplot(data=jan2019_06june2020_questions_by_release_week, 
         aes(x=release_day_number, y=cumulutive_sum, group=release, 
             colour = factor(release)))
x_axis = sprintf("%d", seq(1:28))

jan2019_06june2020_plot = jan2019_06june2020_plot +
  geom_line(stat="identity") + 
  labs(color = 'Release Week 1-4') +
  scale_x_discrete(limits = x_axis) +
  coord_cartesian(clip="off") +
  labs(color = 'DesktopAAQ65-77') +
  geom_dl(aes(label = release), method = list(dl.trans(x = x + 0.2), "last.points", cex = 0.8)) +
  geom_dl(aes(label = release), method = list(dl.trans(x = x - 0.2), "first.points", cex = 0.8)) #+
  #scale_color_brewer(palette = "Dark2")
