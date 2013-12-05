# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Kick off Demo ...


## Implementation

 * Written as a ruby gem with an intuitive command line interface and library
 * Rake tasks to download and normalize training/testing data
 * Bayesian filtering/training performed on email subject and body
 * Bayesian category-word-tally triplets are stored in SQLite


### Useful Libraries

We use some other ruby gems (packages)

 * [`mail`](https://github.com/mikel/mail)

   Provides simple and efficient parsing and querying of raw email message
   information.

 * [`classifier`](https://github.com/cardmagic/classifier)

   Base-bone implementation of a Bayesian Classifier. We build on-top of this to
   improve classification results.

 * [`sequel`](https://github.com/jeremyevans/sequel)

   Provides an extremely flexible and ruby-centric API to different database
   backends - Used for SQLite manipulation.

 * [`colorize`](https://github.com/fazibear/colorize)

   Allows for terminal colors to accentuate accuracy and view classification
   statistics aesthetically


### Data Normalization

`rake training:normalize`

 * Downloads 10 different archives of spam / ham training data
 * Ensures all messages are in the same raw message format
 * Organizes spam/ham into 'difficulty' categories: Hard, Easy, Unknown -
   Based on original data set organization
 * Renames all email messages to {md5checksum}.eml
 * `training_sets/{hard,easy,unknown}/{spam,ham}/*.eml`


## CLI Usage

 * `karat-sleuth train [data-set|path] [ham|spam]`
   - If a data-set name is passed (`easy`, `hard`, `unknown`) then the messages
    will be loaded from the default training directory
   - If a file / directory path is specified it will learn from all messages
    specified in the path
   - Persists the classifier data

 * `karat-sleuth reclassify [data-set|path]`
   - Can classify one or more messages from a specified path
   - Prints out statistics regarding testing data
   - Accuracy per message, total accuracy, and confusion matrix


## ... Demo Results