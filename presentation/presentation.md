# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Training Data
* [CSDMC2010 SPAM corpus](http://csmining.org/index.php/spam-email-datasets-.html)
* 4327 messages
  * 2949 HAM
  * 1378 SPAM


## Heuristics
* Content based filtering - weighted words or phrases
  * "canadian pharmacy"
  * "viagra"
  * "hair transplant"
* Deleted, unread messages
* Examine header


## Program Details
* Written in Ruby
* Command line user interface
* Parses directories or files
* Sorts messages into SPAM/HAM categories  
