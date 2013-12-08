# Karat-Seluth: A Ruby Spam Classifier

Evan Purkhiser, Heather Michaud, Tim Mott

<!-- Motivation and objects of the project -->
## Introduction

Spam has no clear definition, an email message may be considered suspicious if
it is from an unknown sender, sent in bulk, or simply unwanted. These messages
are the junk mail and Jehovah Witness door-hangups of the internet world.
Because of this fuzzy definition of what spam is it can be difficult to
accurately classify a message as spam. Depending on the email client and how well
it is able to classify spam you may not even notice it as a problem. To add to
the problem of spam classification, it's also important to not incorrectly mark
emails that are important to the user as spam. These messages are known as ham
messages, emails that are simply not spam. Ham messages are emails that the user
would find important, desired, or personal.

There are many different ways to classify email messages as spam. Our objective
of the Karat-Sleuth project was to create a library that would allow anyone to
easily classify one or many email messages as either ham or spam. We would do
this using various spam heuristics. The primary heuristic we planned to use was
Bayesian filtering, but we also planned to investigate other heuristics such as
DKIM signature lookup, reverse DNS lookup, and some more trivial boolean
classifications.

<!-- Basic idea of methods or structures proposed to develop the project -->
## Approach

Karat Sleuth was developed to combat the problems of spam categorization in a
clear and robust ruby library which may also be accessed as a command line
tool. It is a spam email detection tool which uses various heuristics and can
continually learn what is and what is not spam.

<!-- What's been tried and implemented -->
## Design and Implementation

Karat Sleuth is written as a ruby gem with an intuitive command line interface
and library. It performs bayesian filtering on the email subject and body
content. Commands for the tool include downloading and normalizing testing and
training data (`get-examples`), training with a given data set or updating the
classifier with a specified path (`train`), or providing statistics regarding
accuracy of the tool given testing data (`stats`).

<!-- What's been accomplished -->
## Results

Mail data sets were acquired from the Spam Assassin set and the CSDMC2010 SPAM
corpus. The messages were organized into three categories of varying ham and
spam distribution in order to compare the accuracy of the spam filter tool
based on the spread of messages.

The first data set contained a total of 10,000 messages with 50% (5,000) spam
and 50% (5,000) ham.  The next set included a total of 6,333 messages with 80%
(5,333) spam and 20% (1,333) ham. The final data set incorporated a sum of
5,801 messages with 90% (5,333) spam and 10% (468) ham. The resulting confusion
matrices displaying the actual classification versus the predicted
classification are shown in figures 1-3.

The predictive classifications are the columns while the actual classifications
are the rows.  For example, in Figure 1, 99.9% of the ham messages provided in
the testing set were correctly identified as ham, where as 39.8% of the spam
messages provided were false positives of spam.  Only 4 of the 5,000 ham
messages were incorrectly identified as spam, where 60.2% of the spam messages
provided in the data set were correctly identified as spam.

### Figure. 1. 50/50 Spam-Ham Confusion Matrix

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 4496 (99.9%) | 4 (0.1%)     |
| Spam | 1988 (39.8%) | 3012 (60.2%) |

### Figure. 2. 80/20 Spam-Ham Confusion Matrix

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 4996 (99.9%) | 1 (0.1%)     |
| Spam | 2489 (46.7%) | 2844 (53.3%) |


### Figure. 3. 90/10 Spam-Ham Confusion Matrix

|      | Ham          | Spam         |
| ---- | ------------ | ------------ |
| Ham  | 370 (79.1%)  | 98 (20.9%    |
| Spam | 95 (1.8%)    | 5238 (98.2%) |

<!-- What's been learned and what's the next step -->
## Conclusion & Future Work

<!-- Team members and their contribution to the project -->
## Remarks
