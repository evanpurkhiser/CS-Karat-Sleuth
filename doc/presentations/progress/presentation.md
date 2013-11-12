# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Implementation

 * Written as a ruby gem with a intuitive command line interface
 * Rake tasks to download and normalize training / testing data
 * Bayesian filtering / training performed on subject / body
 * Baysian category-word-tally triplets are stored in a SQLite
 * A "classifying pipeline" is used to classify as spam or ham


### Useful Libraries

We use some other ruby gems (packages)

 * [`mail`](https://github.com/mikel/mail)

   Provides simple and efficent parsing and querying of raw email message
   information

 * [`classifier`](https://github.com/cardmagic/classifier)

   Base-bone implementation of a Bayseian Classifier. We build on-top of this to
   improve classification results

 * [`sequel`](https://github.com/jeremyevans/sequel)

   Provides a extreamly flexible and ruby-centric API to different database
   backends - Used for SQLite manipulation


### Data Normalization

`rake training:normalize`

 * Downloads 10 different archives of spam / ham training data
 * Ensures all messages are in the same raw message format
 * Organizes spam/ham into 'difficulty' categories: Hard, Easy, Unknown -
   Based on original data set organization
 * Renames all email messages to {md5checksum}.eml
 * `training_sets/{hard,easy,unknown}/{spam,ham}/*.eml`


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
