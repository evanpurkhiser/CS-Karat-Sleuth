# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


# How It Works


## Bayesian Filtering

 * Content based filtering - weighted words or phrases
   * "Canadian pharmacy"
   * "viagra"
   * "hair transplant"
 * Derivation of Bayes' theorem

![Probability that message is spam, given that it contains a particular word W](http://upload.wikimedia.org/math/a/6/e/a6e7f8c521dcf018b6480a8967773ac3.png)


## Available Training Data

* [CSDMC2010 SPAM corpus](http://csmining.org/index.php/spam-email-datasets-.html) (4327 included emails)
  * ~3000 HAM
  * ~1400 SPAM
* [SPAM Assassin](http://spamassassin.apache.org/publiccorpus/) (6047 included emails)
  * ~4000 HAM
  * ~1900 SPAM


## Other Heuristics and Checks

 * Reverse DNS lookup on message sender
 * Domain Key Identified Mail verification
 * Email client integration allowing it to learn what is and isn't spam based on
   user feedback
 * Any other viable methods we can find


# Program Details


## Usage

 * Able to parse entire directories or single email messages
 * Can sort a set of messages into SPAM/HAM categories
 * Can test against known set of SPAM/HAM and return accuracy statistics
 * Can test against a single email and provide detailed overview of the message


## Implementation

 * Written in the Ruby language
   * Take advantage of ruby's expansive standard library
   * Make use of Ruby's bountiful Open Source libraries
 * Simple command line interface for usage
 * Possible implementation into a simple web interface


## Karat Sleuth
Anything implemented in Ruby must have a silly name  
