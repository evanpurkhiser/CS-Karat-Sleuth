# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


# How It Works


## Bayesian Statistics

 * Content based filtering - weighted words or phrases
   * "Canadian pharmacy"
   * "viagra"
   * "hair transplant"


## Available Training Data

* [CSDMC2010 SPAM corpus](http://csmining.org/index.php/spam-email-datasets-.html) (4327 included emails)
  * 2949 HAM
  * 1378 SPAM
* [SPAM Assassin](http://spamassassin.apache.org/publiccorpus/) (6047 included emails)
  * ~4000 HAM
  * ~1900 SPAM


## Other Heuristics and Checks

 * Reverse DNS lookup on message sender
 * Domain Key Identified Mail verification
 * Email client integration allowing it to learn what is and isn't spam based on
   user feedback
 * Any other viable methods we can find



## Program Details
* Written in Ruby
* Command line user interface
* Parses directories or files
* Sorts messages into SPAM/HAM categories
