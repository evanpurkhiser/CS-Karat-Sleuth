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


## Results
 * Ran karaatsleuth on training and testing data of size ~6300
   * Spam: ~5200
   * Ham:  ~1100
 * True positive accuracy:
   * Ham:  74%
   * Spam: 93%


## Evaluation
 * High accuracy for spam could be due to a higher amount of training data for
 spam mail.
 * Results could be improved with more data
 * Results could be biased in ham messages beause ham content varies by user
