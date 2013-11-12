# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Implementation

* Written in ruby as a gem with a simple command line interface
* Uses rake to pull and normalize training and testing data
* Takes advantage of the mail gem to parse messages
* Uses bayesian filtering on subject and email contents
* Allows for persisting data storage


## Example

 * `./karat-sleuth`
 * `./karat-sleuth ../training/unknown`
 * `./karat-sleuth ../training/known {ham,spam}`


## Results

 * Ran Karat Sleuth on training and testing data of size ~6300
   * Spam: ~5200
   * Ham:  ~1100
 * Accuracy:
   * Spam: 93%
   * Ham:  74%


## Evaluation

 * High accuracy for spam could be due to a higher amount of training data for
 spam mail
 * This also accounts for lower ham true positives (26% false negatives categorized as spam)
 * Results could be improved with more data
 * Results could be biased with ham messages beause ham content varies by user


## Possible Future Work

 * To improve results:
   * Reverse DNS lookup on message sender
   * Domain Key Identified Mail verification
 * To improve usability:
   * Implementation into a simple web interface
   * Email client integration
