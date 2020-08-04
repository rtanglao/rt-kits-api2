# rt-kits-api2
Roland's Kitsune API scripts version 2

## 03august2020 looking for CCleaner reports for july 31-august 3, 2020

```bash
cd /home/roland/GIT/rt-kits-api2/202008
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 7 31 2020 8 3
../get-answers-from-questions-csv.rb 2020-07-31-2020-08-03-firefox-creator-answers-desktop-all-locales.csv
grep -iE "(ccleaner|sqlite\-)" with-flattened-answers-2020-07-31-2020-08-03-firefox-creator-answers-desktop-all-locales.csv |\
> ccleaner-mentions-with-flattened-answers-2020-07-31-2020-08-03-firefox-creator-answers-desktop-all-locales.csv
head -1 with-flattened-answers-2020-07-31-2020-08-03-firefox-creator-answers-desktop-all-locales.csv >\
header.csv
% cat header.csv
id,created,updated,title,content,tags,product,topic,locale,answers,creator,synthetic_answers
# add the header
sed -i '1s/^/id,created,updated,title,content,tags,product,topic,locale,answers,creator,synthetic_answers\n/' \
ccleaner-mentions-with-flattened-answers-2020-07-31-2020-08-03-firefox-creator-answers-desktop-all-locales.csv
```

## 13july2020 preparing week 2 report of firefox 78 July 7-13, 2020

```bash
./get-creator-answers-questions-for-arbitrary-time-period.rb 2020 7 7 2020 7 13
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-07-07-2020-07-13-firefox-creator-answers-desktop-all-locales.csv markdown
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-07-07-2020-07-13-firefox-creator-answers-desktop-all-locales.csv csv
../get-aaq-topic-counts.sh sorted-all-desktop-en-us-2020-07-07-2020-07-13-firefox-creator-answers-desktop-all-locales.csv
27
50
60
112
11
31
4
12
60
20
113
```

* 2\. Manually copy them to a spreadsheet: [Firefox 78 Desktop AAQ Question Counts by Week](https://docs.google.com/spreadsheets/d/125SBrCuSo0KScZ0VGvnakYYdmqubeoV_2MJsZfvYiak/edit#gid=0)

* 3\. Opened the fix problems, all 112 questions, in 112 tabs

```bash
grep "fix-problems;" \\nsorted-all-desktop-en-us-2020-07-07-2020-07-13-firefox-creator-answers-desktop-all-locales.csv |\
grep -o '^[0-9]*' | xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
```

* 4\. Saved the 112 questions into a spreadsheet

```bash
printf '%s\n%s\n' \
`head -1 sorted-all-desktop-en-us-2020-07-07-2020-07-13-firefox-creator-answers-desktop-all-locales.csv` \
"$(cat ff78-week2-fix-problems-7-13july2020.csv)" >ff78-week2-fix-problems-7-13july2020.csv
```

* 5\. Upload the spreadsheet into google drive and delete product and locale and add category and sub-category: 
    * [ff78-week2-fix-slowness-crashes-error-messages-other-problems-7-13july2020](https://docs.google.com/spreadsheets/d/1zrj_ldzhEiU5fdJHzPbab1mPIVJHCex3C8u8ZogGMKs/edit#gid=221906619)


## 06july2020 preparing week 1 report of firefox 78 june 30 - july 6, 2020

* 1\. get the questions

```bash
 ../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 6 30 2020 7 6
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv markdown
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv csv
roland@DESKTOP-KT6DGHC ~/GIT/rt-kits-api2/202007
 % ../get-aaq-topic-counts.sh sorted-all-desktop-en-us-2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv
15
45
76
89
12
24
4
21
59
31
118
```

* 2\. Manually copy them to a spreadsheet: [Firefox 78 Desktop AAQ Question Counts by Week](https://docs.google.com/spreadsheets/d/125SBrCuSo0KScZ0VGvnakYYdmqubeoV_2MJsZfvYiak/edit#gid=0)

* 3\. open the biggest category with 89 questions "Fix slowness, crashing, error messages and other problems" links in a browser and save the links to a spreadsheet for notes

```bash
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv |\
grep -o '^[0-9]*' | xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv \
> ff78-week1-fix-problems-30june-06july2020.csv
printf '%s\n%s\n' \
`head -1 sorted-all-desktop-en-us-2020-06-30-2020-07-06-firefox-creator-answers-desktop-all-locales.csv` \
"$(cat ff78-week1-fix-problems-30june-06july2020.csv)" >f78-week1-fix-problems-30june-06july2020.csv
```

   * spreadsheet is [ff78-week1-fix-slowness-crashes-error-messages-other-problems-30june-6july2020](https://docs.google.com/spreadsheets/d/1YC-vWL-bOYhripdxoZU2Y0CnL6Xo2lOpSE-UmMh03AU/edit#gid=798079733)

## 28june2020 get first two weeks questions for desktop and get their answers

```bash
cd /home/roland/GIT/rt-kits-api2/FIRST_TWO_WEEKS_DESKTOP
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 2 11  2020 2 24 &
mv 2020-02-11-2020-02-24-firefox-creator-answers-desktop-all-locales.csv \
ff73-1st-2weeks-2020-02-11-2020-02-24-firefox-creator-answers-desktop-all-locales.csv
../get-answers-from-questions-csv.rb ff75-1st-2weeks-2020-04-07-2020-04-20-firefox-creator-answers-desktop-all-locales.csv
```

## 25june2020 add titles to email escalation report

```bash
cd 202006
../get-by-updated-time-question-url-answers-for-arbitrary-time-period.rb \
2020 6 22 2020 6 25
cd ..
grep "escalate;" \
202006/updated-2020-06-22-2020-06-25-ff-desktop-creator-answers-desktop-all-locales.csv\
| ./with-title-email-escalations.rb
../get-answers-from-questions-csv.rb \
ff73-1st-2weeks-2020-02-11-2020-02-24-firefox-creator-answers-desktop-all-locales.csv 
```

## 16june200 support report week 2 of ff 77 june 9-15, 2020

* 1\. get the questions
```bash
cd 202006
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 6 9 2020 6 15 &
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv markdown
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv csv
../get-aaq-topic-counts.sh \
sorted-all-desktop-en-us-2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv
42
40
78
99
10
27
6
11
53
20
128
```

* 2\. and manually copy them to a spreadsheet: [Firefox 77 Desktop AAQ Question Counts by Week](https://docs.google.com/spreadsheets/d/1hnse8GoMBuipiYrLSqj4x0OW0kMrAxskIU1S06Yj8u0/edit#gid=0)

* 3\. open the "Fix slowness, crashing, error messages and other problems" links in a browser and save the links to a spreadsheet for notes

```bash
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv |\
grep -o '^[0-9]*' | xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv \
> ff77-week2-fix-problems-09-15june2020.csv
printf '%s\n%s\n' \
`head -1 sorted-all-desktop-en-us-2020-06-09-2020-06-15-firefox-creator-answers-desktop-all-locales.csv` \
"$(cat ff77-week2-fix-problems-09-15june2020.csv)" >ff77-week2-fix-problems-09-15june2020.csv
```

* 4\. upload CSV file to Google Sheets and add notes column and remove product and locale column which are always going to be firefox and en-us
    * [ff77-week2-fix-problems-09-15june2020](https://docs.google.com/spreadsheets/d/18bJhloFEUsm6S4smJVZ0fJM-OQuG9rHAo_rtpq3SuMw/edit#gid=690198459)
    
## 11june2020 email escalation report

```bash
cd 202006
../get-by-updated-time-question-url-answers-for-arbitrary-time-period.rb \
2020 6 8 2020 6 10
cd ..
grep "escalate;" \
202006/updated-2020-06-08-2020-06-10-ff-desktop-creator-answers-desktop-all-locales.csv\
| grep -o '^[0-9]*' | ./email-escalations.rb
```
## 09june2020 preparing weekly report for week 1 of firefox 77 june 2-8, 2020

* 1\. get the questions
```bash
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 6 2 2020 6 8 &
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv markdown
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv csv
```
* 2\. get the question counts
```bash
../get-aaq-topic-counts.sh sorted-all-desktop-en-us-2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv
# 120 is "Fix slowness, crashing, error messages and other problems", 166 is "other"
34
59
87
120
16
28
5
22
74
27
166
```
* and manually copy them to a spreadsheet: [Firefox 77 Desktop AAQ Question Counts by Week](https://docs.google.com/spreadsheets/d/1hnse8GoMBuipiYrLSqj4x0OW0kMrAxskIU1S06Yj8u0/edit#gid=0)

* 3\. open the "Fix slowness, crashing, error messages and other problems" links in a browser and save the links to a spreadsheet for notes

```bash
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv |\
grep -o '^[0-9]*' | xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
grep "fix-problems;" \
sorted-all-desktop-en-us-2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv \
> ff77-week1-fix-problems-02-08june2020.csv
printf '%s\n%s\n' \
`head -1 sorted-all-desktop-en-us-2020-06-02-2020-06-08-firefox-creator-answers-desktop-all-locales.csv` \
"$(cat ff77-week1-fix-problems-02-08june2020.csv)" >ff77-week1-fix-problems-02-08june2020.csv
```

* 4\. upload CSV file to Google Sheets and add notes column and remove product and locale column which are always going to be firefox and en-us
    * [ff77-week1-fix-problems-02-08june2020](https://docs.google.com/spreadsheets/d/1MMg8gz1gt6s4fsyu6OjoTBVuN1fK7ualSOEr0gbBdTQ/edit#gid=1678725887)
## 07June2020 graphing cumulative sum of Firefox Desktop Messages
```bash
cd ARBITRARY_TIME_PERIOD
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 1 1 2020 6 6 &
./print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb 2019-01-01-2020-06-06-firefox-creator-answers-desktop-all-locales.csv csv
# load cumulative-sum-unfaceted-january2019-06june2020-plot-num-questions-release-day-1-28.R into R Studio, run it and save plot
```

## 02june2020 open questions with id > 1289343

```bash
 grep -o '^[^0-9]*[0-9]*' \
 sorted-all-desktop-en-us-2020-06-02-2020-06-02-firefox-creator-answers-desktop-all-locales.md |\
 grep -o '[0-9]*' | awk '$1 > 1289343' |\
 xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
```

## 28may2020 open questions with the escalate tag

* first get the questions by updated time i.e. updated may 28, 2020 and then open them in wsl

```bash
../get-by-updated-time-question-url-answers-for-arbitrary-time-period.rb 2020 5 28 2020 5 28 
grep "escalate;" \
updated-2020-05-28-2020-05-28-ff-desktop-creator-answers-desktop-all-locales.csv\
| grep -o '^[0-9]*' |\
xargs -I {} -n 1 wsl-open "https://support.mozilla.org/questions/"{}
```

## 26may2020 wsl-open every fourth i.e 25% randomly shuffled question

```bash
grep -o 'https*://support.mozilla.org/questions/[^)]*' \
sorted-all-desktop-en-us-2020-05-06-2020-05-06-firefox-creator-answers-desktop-all-locales.md\
| shuf | awk 'NR % 4 == 0' |xargs -n 1 wsl-open
```

## 26may2020 wsl-open all questions in a markdown questions file

```bash
grep -o 'https*://support.mozilla.org/questions/[^)]*' \
sorted-all-desktop-en-us-2020-05-06-2020-05-06-firefox-creator-answers-desktop-all-locales.md\
| xargs -n 1 wsl-open
```
## 11april2020 get count by aaq topic

* based on the stuff below, created this script:

```bash
roland@DESKTOP-KT6DGHC ~/GIT/rt-kits-api2/2020BYMONTH
 % ../get-aaq-topic-counts.sh sorted-all-desktop-en-us-2020-04-01-2020-04-30-firefox-creator-answers-desktop-all-locales.csv
70
120
235
306
21
54
12
77
105
48
377
```
```bash
 grep download-and-install_1 sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep privacy-and- sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep customize; sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "customize;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "fix-problems" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "tips;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "bookmarks;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "cookies;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "tabs;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "websites;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "sync;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l
grep "other;" sorted-all-desktop-en-us-2020-01-01-2020-01-31-firefox-creator-answers-desktop-all-locales.csv | wc -l

```
## 02April2020 sketch for B&E

GOAL: in python (with tests) get Firefox Desktop answers created for a certain period when Firefox questions were updated (not created) from B&E.

* 1\. The following two ruby scripts does what you want but for `created` (see https://github.com/rtanglao/rt-kits-api2/blob/master/get-creator-answers-questions-for-arbitrary-time-period.rb#L61 ) time not `updated` and it's in ruby not python and there are no tests
```bash
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 3 22 2020 3 22
# which creates 2020-03-22-2020-03-22-firefox-creator-answers-desktop-all-locales.csv
../print-question-url-answer-id-answer-creator.rb \
2020-03-22-2020-03-22-firefox-creator-answers-desktop-all-locales.csv
> [questions-answers-with-times.csv] 
```
* 2\. I am not sure `updated__gt` and `updated__lt` works
* 3\. Relevant lines from [get-creator-answers-questions-for-arbitrary-time-period.rb](https://github.com/rtanglao/rt-kits-api2/blob/master/get-creator-answers-questions-for-arbitrary-time-period.rb)
```ruby

url_params = {
  :format => "json",
  :product => "firefox", 
  :created__gt => greater_than_time,
  :created__lt => less_than_time,
  :ordering => "+created",
} 

url = "https://support.mozilla.org/api/2/question/"
```
* 4\. Relevant lines from [print-question-url-answer-id-answer-creator.rb](https://github.com/rtanglao/rt-kits-api2/blob/master/print-question-url-answer-id-answer-creator.rb)
```ruby
  url = "https://support.mozilla.org/api/2/answer/"

  url_params = {
    :format => "json",
    :question => id 
  } 
 ```
* 5\. You should be able to combine the two ruby scripts into one script.I'm just lazy and minimized new work by using an old script, `get-creator-answers-questions-for-arbitrary-time-period.rb`
* 6\. For initial testing to make sure the Kitsune questions API works with `updated`, just use `wget` or `curl` instead of writing a python script.
* 7\. Beware [issue:3686-timezone issue with time always being Pacific](https://github.com/mozilla/kitsune/issues/3686)
My workaround in ruby:
```ruby
# the following hack has to be done for all times returned by the Kitsune API until 3686 is fixed
answer_created = Time.parse(answer["created"].gsub("Z", "PST")) #issue 3686 time is in PST not UTC
```
* 8\. delay 1 second between API calls

## 23march2020 getting random 50 support questions from 20-22march for JR

```bash
../get-creator-answers-questions-for-arbitrary-time-period.rb 2020 3 20 2020 3 22
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2020-03-20-2020-03-22-firefox-creator-answers-desktop-all-locales.csv csv # get it from the last 3 days
# remove first line and shuffle
sed '1d' sorted-all-desktop-en-us-2020-03-20-2020-03-22-firefox-creator-answers-desktop-all-locales.csv\
| shuf > shuffled-sorted-all-desktop-en-us-2020-03-20-2020-03-22-firefox-creator-answers-desktop-all-locales.csv
```


## 05march2020 BUG in printing 4 questions for mechanical turk

* 1\. What is the bug? The bug is we don't remove carriage returns!
* 2\. fix by using:
```ruby
tr("\n"," ") # replace with space to ensure words are separated!
```

### 05march2020 Command Line fun to get title,content

```bash
mkdir FOUR_FF73_QUESTIONS_FOR_CANOSP_MTURK
cd FOUR_FF73_QUESTIONS_FOR_CANOSP_MTURK
#create four-ids-for-canosp-mturk.txt (just a text file with 1 integer id per line
# https://github.com/rtanglao/rt-kits-api2/blob/master/FOUR_FF73_QUESTIONS_FOR_CANOSP_MTURK/four-ids-for-canosp-mturk.txt 
../get-by-id-creator-answers-questions.rb four-ids-for-canosp-mturk.txt 
# the above script creates:
#https://github.com/rtanglao/rt-kits-api2/blob/master/FOUR_FF73_QUESTIONS_FOR_CANOSP_MTURK/id-1281304-unixtime-1583475446-by-id-firefox-creator-answers-desktop-all-locales.csv
../print-all-questions-just-title-content.rb id-1281304-unixtime-1583475446-by-id-firefox-creator-answers-desktop-all-locales.csv
# the above script creates:
# https://github.com/rtanglao/rt-kits-api2/blob/master/FOUR_FF73_QUESTIONS_FOR_CANOSP_MTURK/title-parsed-content-id-1281304-unixtime-1583475446-by-id-firefox-creator-answers-desktop-all-locales.csv
```

## 02march2020 counting the number of support questions sunday-saturday by week:

* output is here: [2018-11-01-2020-03-02-num-ff-desktop-aaq-questions-created-2020-03-02.csv](https://github.com/rtanglao/rt-kits-api2/blob/master/PRODUCT_INTEGRITY_4WEEK_RELEASE_CYCLE/2018-11-01-2020-03-02-num-ff-desktop-aaq-questions-created-2020-03-02.csv)

```bash
cd /home/rtanglao/GIT/rt-kits-api2/PRODUCT_INTEGRITY_4WEEK_RELEASE_CYCLE
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 11 26 \
2020 3 2
mv 2019-11-26-2020-03-02-firefox-creator-answers-desktop-all-locales.csv part-1-2019-11-26-2020-03-02-firefox-creator-answers-desktop-all-locales.csv 
mv part-1-2019-11-26-2020-03-02-firefox-creator-answers-desktop-all-locales.csv part-2-2019-11-26-2020-03-02-firefox-creator-answers-desktop-all-locales.csv 
mv 2018-11-01-2019-11-25-firefox-creator-answers-desktop-all-locales.csv part-1-2018-11-01-2019-11-25-firefox-creator-answers-desktop-all-locales.csv 
head -1 part-1-2018-11-01-2019-11-25-firefox-creator-answers-desktop-all-locales.csv > concat-2019-11-01-2020-03-02-firefox-creator-answers-desktop-all-locales.csv
for filename in $(ls part-*.csv); do sed 1d $filename >> concat-2019-11-01-2020-03-02-firefox-creator-answers-desktop-all-locales.csv ; done
../print-csv-num-en-us-questions-by-product-integrity-week.rb concat-2019-11-01-2020-03-02-firefox-creator-answers-desktop-all-locales.csv 2018-2021-12-19-product_integrity_dates.txt >2018-11-01-2020-03-02-num-ff-destop-aaq-questions-created-2020-03-02.csv
mv 2018-11-01-2020-03-02-num-ff-destop-aaq-questions-created-2020-03-02.csv 2018-11-01-2020-03-02-num-ff-desktop-aaq-questions-created-2020-03-02.csv
```

## 01march2020 from the csv file of questions by id: for mturk,  cut out title and content and parse out the HTML

```bash
./print-all-questions-just-title-content.rb \
id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv 
```

which outputs a parsed csv file of form `title-parsed-content-<csv-filename>` 

[title-parsed-content-id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv](https://github.com/rtanglao/rt-kits-api2/blob/master/title-parsed-content-id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv)
:

```csv
title,content
Restore session doesn't work after update,"I have a very high tab count, and when restoring Firefox I usually get the ""warning:unresponsive script"" pop up. I press continue, it pops up again, I press continue again, and my tabs are restored. All is well.
However, when I restarted Firefox today, it updated, and rather than the unresponsive script box, I get a blank pop up. I cannot do anything, and my tabs cannot be restored.
I tried a refresh and a clean install, but that does nothing.
"
```

## 01march2020 get a csv file of questions by id 

```bash
echo '1279731' | ./get-by-id-creator-answers-questions.rb
```

which outputs sample file of the form `id-<first-id>-unixtime-<unixtime i.e. int-when-created>.csv`: 

e.g. [id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv](https://github.com/rtanglao/rt-kits-api2/blob/master/id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv) 

and if you only want title and text (but with html; html has to be parsed out):

```bash
mlr --csv cut -f title,content id-1279731-unixtime-1583100833-by-id-firefox-creator-answers-desktop-all-locales.csv 
title,content
Restore session doesn't work after update,"<p>I have a very high tab count, and when restoring Firefox I usually get the ""warning:unresponsive script"" pop up. I press continue, it pops up again, I press continue again, and my tabs are restored. All is well.
However, when I restarted Firefox today, it updated, and rather than the unresponsive script box, I get a blank pop up. I cannot do anything, and my tabs cannot be restored.
I tried a refresh and a clean install, but that does nothing.
</p>"
````

## 23february2020 getting the people who answered the question (don't include answers from the question creator i.e. the original post)

```bash
../print-question-url-answer-id-answer-creator.rb \
[csv file created by get-creator-answers-questions-for-arbitrary-time-period.r]\
> [questions-answers-with-times.csv] 
```

e.g.

```bash
cd 202002
../print-question-url-answer-id-answer-creator.rb 2020-02-20-2020-02-20-firefox-creator-answers-desktop-all-locales.csv > /tmp/answers-scratch.txt 
```

## 25november2019 going back to december 2018 for product integrity

```baah
../print-product-integrity-week-start-dates.rb > 2018-2021-12-19-product_integrity_dates.txt
../print-csv-num-en-us-questions-by-product-integrity-week.rb 2018-11-01-2019-11-25-firefox-creator-answers-desktop-all-locales.csv 2018-2021-12-19-product_integrity_dates.txt >2018-11-26-num-ff-desktop-aaq-questions-01nov2018-25nov2019.csv
 mv 2018-11-26-num-ff-desktop-aaq-questions-01nov2018-25nov2019.csv 2018-11-26-num-ff-desktop-en-us-aaq-questions-01nov2018-25nov2019.csv
```

## 11november2019 how to run these scripts for product integrity

* on Windows with WSL1 or WSL2, Linux or OS X install python 2.6 or newer
* clone the repo: ```git clone https://github.com/rtanglao/rt-kits-api2.git```
* and then run the scripts (change the dates appropriately e.g. change ```11 3``` and ```11 9``` to the start and end of the week) and get the number of questions:

```bash
cd PRODUCT_INTEGRITY_4WEEK_RELEASE_CYCLE
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 11 3 2019 11 9
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2019-11-03-2019-11-09-firefox-creator-answers-desktop-all-locales.csv markdown
wc -l sorted-all-desktop-en-us-2019-11-03-2019-11-09-firefox-creator-answers-desktop-all-locales.md 
295 sorted-all-desktop-en-us-2019-11-03-2019-11-09-firefox-creator-answers-desktop-all-locales.md
# actual number of question is 295 - 4 = 291 questions the week of November 3-9, 2019
```

## 11november2019 product integrity Sunday-Saturday e.g. November 3-9, 2019

```bash
cd /home/rtanglao/GIT/rt-kits-api2/PRODUCT_INTEGRITY_4WEEK_RELEASE_CYCLE
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 11 3 2019 11 9
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb \
2019-11-03-2019-11-09-firefox-creator-answers-desktop-all-locales.csv markdown
```


## 11november2019 FIXED: "1st sumo question of the day in utc time has the wrong time in the UI"

* All times returned by the API are now PST (even though they say 'Z') and all URL parameters are now PST (see https://github.com/mozilla/kitsune/issues/3946 and https://github.com/mozilla/kitsune/issues/3961 )

```bash
cd /home/rtanglao/GIT/rt-kits-api2/201911
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 11 10 2019 11 10
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb 2019-11-10-2019-11-10-firefox-creator-answers-desktop-all-locales.csv markdown
```

## 28october2019 1st sumo question of the day in utc time has the wrong time in the UI

```bash
./test-time-question-1271141.rb >./test-time-question-1271141-stdout.txt
```
* [created time in the API](https://github.com/rtanglao/rt-kits-api2/blob/master/test-time-question-1271141-stdout.txt) is: `
  * `"created" => "2019-10-23T00:02:46Z`
  * but the web page shows `Posted 10/22/19, 5:02 PM`: ![wrong-time-question-1271141](https://github.com/rtanglao/rt-kits-api2/blob/master/wrong-website-time-question-1271141.png)
  * If the API time is in UTC and correct,  shouldn't the web page show `Posted 10/22/19, 7:46 PM` if [the web page is in Pacific](https://www.worldtimebuddy.com/utc-to-pst-converter?qm=1&lid=100,8,6174041&h=100&date=2019-10-29&sln=2.5-3)?

## 22october2019 get questions for day 1, firefox 70

```bash
cd /home/rtanglao/GIT/rt-kits-api2/201910
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 10 22 2019 10 22
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb 2019-10-22-2019-10-22-firefox-creator-answers-desktop-all-locales.csv markdown 
```

## 20October2019 get all contributors January 29, 2019 - October 19, 2019

* where `contribution` = a reply by somebody other than the original poster of the support question

```bash
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 1 1 2019 10 19 
../print-desktop-contributors.rb 2019-01-01-2019-10-19-firefox-creator-answers-desktop-all-locales.csv >01january-19october2019-contributors.txt &
cat 01january-19october2019-contributors.txt | sort | uniq -c | sort -nr > 29january-19october2019-sorted-contributors.txt
```

## 20October2019 get all the questions for an arbitary time period including answerids and question creator

```bash
cd /home/rtanglao/GIT/rt-kits-api2/ARBITRARY_TIME_PERIOD
../get-creator-answers-questions-for-arbitrary-time-period.rb 2019 1 1 2019 10 19
# output is:
# 2019-01-01-2019-10-19-firefox-creator-answers-desktop-all-locales.csv
```


## 19October2019 get all the questions for an arbitary time period

* fixed get-questions-for-bitrary-time-period.rb to work with issue 3686 and new issue https://github.com/mozilla/kitsune/issues/3946, all other ruby scripts haven't been updated for 3686 and 3946

e.g. january 1, 2019 - october 18, 2019 

```bash
./get-questions-for-bitrary-time-period.rb 2019 1 1 2019 10 18 
./print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb\
2019-01-01-2019-10-18-firefox-desktop-all-locales.csv csv  
```

* output is here:
  * https://github.com/rtanglao/rt-kits-api2/blob/master/sorted-all-desktop-en-us-2019-01-01-2019-10-18-firefox-desktop-all-locales.csv

## 06october2019 get all os questions

```bash
cd 201910
../get-questions-for-1-day.rb 2019 10 6  
../print-desktop-en-us-all-oses-increasing-ids-time-url-title-content.rb  \
2019-10-06-firefox-desktop-all-locales.csv markdown
```

### 06october2019 Output is here:

https://github.com/rtanglao/rt-kits-api2/blob/master/201910/sorted-all-desktop-en-us-2019-10-06-firefox-desktop-all-locales.md

## 04october2019 get os x questions

```bash
cd 201907
../get-questions-for-1-month.rb 2019 7
../print-desktop-en-us-osx-increasing-ids-time-url-title-content.rb  \
2019-07-firefox-desktop-all-locales.csv  2>/tmp/foo.txt
 ```
 
 output:
 
 https://github.com/rtanglao/rt-kits-api2/blob/master/201907/sorted-osx-desktop-en-us-2019-07-firefox-desktop-all-locales.csv 
 
## 09july2019 revised workflow

```bash
cd 201907
../get-questions-for-1-day.rb 2019 7 9 
../print-all-ids-increasing-order-desktop-english-sumo-questions.rb\
2019-07-09-firefox-desktop-all-locales.csv ids >2019-07-09-en-us-desktop-ids.txt
cat 2019-07-09-en-us-desktop-ids.txt | ../open-ids-in-browser.rb
```

## 09july2019 how to set up launchy

```bash
export BROWSER='/mnt/c/Program\ Files/Firefox\ Nightly/firefox.exe'
echo 1262479 | ./open-ids-in-browser.rb
```

## 04june2019 randomized :-)

```bash
../print-random-order-desktop-english-sumo-questions.rb \
2019-05-29-firefox-desktop-all-locales.csv 2019-05-29-firefox-desktop-all-locales.csv\
>randomized-2019-05-29-firefox-desktop-all-locales.csv
```

## 03june2019 inception :-)

```bash
cd /home/rtanglao/GIT/rt-kits-api2/201905
../get-questions-for-1-day.rb  2019 5 29
```
