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
clear and robust ruby library. We also intend to expose the functionality of
this library through a straight forward and intuitive command line interface
allowing the user to access all of the functionality of the library.

We decided to use the ruby scripting language due to it's extremely expansive
standard library and it's intuitive ye powerful syntax. This would allow us to
rapidly prototype the tool and leave room for performance improvements after we
had a working implementation, the ruby language allows for just this. Although
only one of the three team members had any extensive experience with ruby, it
was decided that it would be fun and interesting for the lest of the team to
pick up.

Because we are using the Ruby scripting language, the most obvious choice for
creating a library that other developers may use is to create a "Ruby gem". Gems
are a collection of ruby scripts that include meta-data about the library and
logic to load scripts into other applications. Creating a ruby gem gives us the
added bonus that it becomes quite straight forward to add dependencies on other
libraries to our own. This gives us the option to leverage other well supported
open source libraries and stop re-inventing the wheel.

After some instal considerations on how we would like to classify messages we
defined heuristics we hoped to use to classify messages:

 * **Bayesian Classifier**\
   This will be the primary means of message classification which will be used
   to calculate the base probability that something is a _spam_ or _ham_
   message. Bayesian classification essential allows us to, given a large set of
   data with a known classification, 'learn' from this data and then use that
   information to probabilistically determine the classification of a message.
   We will be using the message subject and body to learn from the words in the
   message and use them to classify the message.

 * **DKIM Signature Verification**\
   When a email message is sent from a server, one of the things that can be
   done to the message to prove it's authenticity is to 'digitally sign' the
   email which can verify the contents of the message and who the message was
   sent by. This is done by using a public / private key. Where the private key
   is used to sign the message and the public key is stored in a domains DNS
   records and can be used to verify the signature. We can use this to determine
   if a message has a valid signature, or if it has no signature at all and
   aggregate this into the classification probability.

 * **Reverse DNS Lookup (PTR Records)**\
   Another technical way to verify the identity of the message sender is by
   ensuring that the message was sent by the same server that is linked to the
   domain in the `From:` field of the message. Using a reverse DNS lookup to
   determine the host name assigned to an IP we can determine this. Again, we
   can use this information to aggregate the classification probability.

 * **Plain Text and HTML Combinations**\
   Spam emails are commonly sent as HTML emails due to various techniques for
   bypassing the spam filters (such as embedding invisible HTML tags), many
   times when they are sent as HTML emails no Plain Text version of the message
   will be included. We can use this knowledge to give a negative impact to the
   classification probability of messages which only have a HTML message body.

 * **Location based classifications**\
   Doing a geoIP lookup of a given messages sender could be an efficient way to
   gain some probabilistic information about a message. For example, if a
   message was sent from a IP located in a territory that is known to relay many
   messages classified as spam, then we could use this information in our
   aggregate probability of a message's classification.

If possible, we will be looking for established libraries to help us with these
tasks. For example, before initial implementation we found that we could use the
ruby [classifier gem](https://github.com/cardmagic/classifier) that gives us a
very bare bones implementation of a Bayesian classifier to build upon.

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
