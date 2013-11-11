# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Implementation

* Written in ruby as a gem
* Uses rake to pull and normalize training and testing data
* Takes advantage of the mail gem to parse messages
* Uses bayesian filtering on subject and email contents
* Allows for persisting data storage


## Example
 * ./karatsleuth
 * ./karatsleuth ../training/unknown
 * ./karatsleuth ../training/known ham
