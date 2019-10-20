# rt-kits-api2
Roland's Kitsune API scripts version 2

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
