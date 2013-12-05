# Karat Sleuth
## Project By Evan, Tim, Heather


A SPAM Email detection tool that uses various heuristics and continually learns
what is and is not SPAM


## Kick off Demo ...


## Design & Implementation

 * Written as a ruby gem with an intuitive command line interface and library
 * Download and normalize various training/testing data
 * Bayesian filtering/training performed on email subject and body
 * Bayesian category-word-tally triplets are stored in SQLite
 * Stop words are removed and words are converted to their stem form


### Useful Libraries

We use some other ruby gems (packages)

 * [`mail`](https://github.com/mikel/mail)

   Provides straightforward and efficient parsing and querying of raw email message
   information.

 * [`classifier`](https://github.com/cardmagic/classifier)

   Bare-bone implementation of a Bayesian Classifier. We extended the functionality
   to improve classification results.


 * [`sequel`](https://github.com/jeremyevans/sequel)

   Provides an extremely flexible and ruby-centric API to different database
   backends - Used for SQLite manipulation.

 * [`colorize`](https://github.com/fazibear/colorize)

   Allows for terminal colors to accentuate results and aesthetically view
   classification statistics


# CLI Tool


## Data Normalization

 * `karat-sleuth get-examples`
   - Downloads 10 different archives of spam / ham training data
   - Ensures all messages are in the same raw message format
   - Organizes spam/ham into 'difficulty' categories: 
      * Hard, Easy, Unknown
      * Based on original data set organization
   - Renames all email messages to {md5checksum}.eml
   - `training_sets/{hard,easy,unknown}/{spam,ham}/*.eml`


## Training

 * `karat-sleuth train [data-set|path] [ham|spam]`
   - If a data-set name is passed (`easy`, `hard`, `unknown`) then the messages
    will be loaded from the default training directory
   - If a file / directory path is specified it will learn from all messages
    specified in the path
   - Persists the classifier data


## Testing

 * `karat-sleuth stats [data-set|path]`
   - If a file / directory path is specified it will classify  all messages
    specified in the path or default to data directory
   - Prints out statistics regarding testing data
   - Accuracy per message, total accuracy, and confusion matrix


## Instrumentation Output

 * Progress bar to indicate advancement through groups of categorized messages
 * Classified correctly → Message marked in green
 * Classified inncorrectly → Message marked in red
 * Confusion matrix compares actual vs. predicted types


## Obtained Results

 * 50/50 data set (10,000 messages)
   - 5,000 Spam
   - 5,000 Ham
 * 80/20 data set (6,666 messages)
   - 5,333 Spam
   - 1,333 Ham
 * 90/10 data set (6,666 messages)
   - 5,333 Spam
   - 468 Ham


### 50/50 Spam-Ham set

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 4496 (99.9%) | 4 (0.1%)     |
| Spam | 1988 (39.8%) | 3012 (60.2%) |


### 80/20 Spam-Ham set

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 4996 (99.9%) | 1 (0.1%)     |
| Spam | 2489 (46.7%) | 2844 (53.3%) |


### 90/10 Spam-Ham set

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 370 (79.1%)  | 98 (20.9%    |
| Spam | 95 (1.8%)    | 5238 (98.2%) |


## Result Evaluation

 * Varying levels of accuracy depending on distribution of training data
 * Tool designed to be non-interfering
   - Greater accuracy for ham → less false positives 
 * Threats to validity
   - inconsistent ham messages from corpus
   - improved results from user-specific data


## ... Demo Results
