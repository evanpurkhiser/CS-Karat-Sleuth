# Karat Seluth: A Ruby Spam Classifier

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
of the Karat Sleuth project was to create a library that would allow anyone to
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

\pagebreak

<!-- What's been tried and implemented -->
## Design and Implementation

### Library Design

During our initial design concepts for Karat Sleuth we wanted to provide a
straight forward interface to anyone using the library in their application. This
means defining what task the library should be responsible for:

 1. Allow the library to be continuously trained based on messages of a known
    classification. This would be useful for example when implementing the
    library into a online email client: When the client user marked something as
    spam the library could be trained from that particular message.

 2. Allow the library to take a single raw email message, either read from a
    file or passed in as a string, and classify that message as either ham or as
    spam. It should also be possible to extract the probabilities that the
    message is either ham or spam using a similar API call.

 3. Provide a interface to add additional modules to the pipeline for
    classification and for training of the classifier.

Since we have numerous ways to aggregate classification probabilities for a
email message we decided the best way to design the library would be to take a
modular 'pipelined' approach to the classification process. The library would be
designed to have two pipelines, one for training the library and one for
classifying the library.

Currently, the only module that we have implemented in the classifier and
training pipeline is the 'Bayesian classifier'. This uses the ruby classifier
gem (as mentioned earlier) as a bare bone implementation of the classifier.
We've also extended this to persist the classification information into a SQLite
database file that will be stored on disk. We can then reload this file on
subsequent reloads of the library into memory.

### Command Line Tool Design

Since we were developing a library, it's important that we also designed a
application that would use our library for a reference implementation. We
decided that the best way to do this would be to develop a command line tool and
to bundle it with the gem itself. The goal of this tool was to expose all of the
libraries functionality through a CLI interface.

The primary commands the tool supports are as follows

 * `get-examples` - Allows the user to download example training data used to
   test the library.

 * `train` - Allows the user to train the tool from one or many email messages.

 * `classify` - Classifies a given email message as either ham or spam.

 * `stats` - Classifies a set of messages and outputs statistics about the
   classifications. This can only be used when the types of each message is known.

For the purpose of our project we primarily focused on the ability of the CLI
tool to train from messages and to classify messages and print out statistics
about the classifications (using the `stats` command).

<!-- What's been accomplished -->
## Results

Mail data sets were acquired from the Spam Assassin set and the CSDMC2010 SPAM
corpus. The messages were organized into three categories of varying ham and
spam distribution in order to compare the accuracy of the spam filter tool
based on the spread of messages.

The first data set contained a total of 10,000 messages with 50% (5,000) spam
and 50% (5,000) ham. The next set included a total of 6,333 messages with 80%
(5,333) spam and 20% (1,333) ham. The final data set incorporated a sum of
5,801 messages with 90% (5,333) spam and 10% (468) ham. The resulting confusion
matrices displaying the actual classification versus the predicted
classification are shown in figures 1-3.

The predictive classifications are the columns while the actual classifications
are the rows.  For example, in Figure 1, 99.9% of the ham messages provided in
the testing set were correctly identified as ham, where as 39.8% of the spam
messages provided were false positives of spam. Only 4 of the 5,000 ham messages
were incorrectly identified as spam, where 60.2% of the spam messages provided
in the data set were correctly identified as spam.

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

Ultimately, we learned how to implement an incrementally learning system that
can continuously improve its classification results. During our implementation,
we were educated on the specifics of the ruby language as well as Bayesian
filtering calculations. A naive Bayes classifier takes a bags of words that have
been classified into a specific category, then separates and organizes the
unique words into a database containing the frequency that each word has
appeared in each category. From this collection, any new bag of words can be
queried by word to perform a classification of the entire text. Spam filtering
is possible in this way.

Future work includes adding classifiers to the pipeline so that emails can be
classified using DKIM signature verification, reverse DNS lookup (PTR records),
plain text and HTML combination, and location based classification. Once these
modifications have been made, we believe that the accuracy of Karat Sleuth's
spam classification can be improved to such an extent that application
deployment will be possible.

<!-- Team members and their contribution to the project -->
## Remarks

All team members contributed in some way to the makings of Karat Sleuth.

Evan contributed to writing the report, preparing presentations, printing a
progress indicator of classified messages, implementing the library API,
normalizing training and testing data, creating the command to automatically
download data sets, and parsing command line arguments. He was also responsible
for implementing the command line interface, implementing the command to train
the tool with a specified data set or path, made it possible to persist the
classifier and reload it, and kept the necessary ruby-isms in check.

Heather contributed to writing the report, preparing presentations, outputting
running statistics on mail sets, calculating and displaying the confusion
matrix, printing a progress indicator of classified messages, implementing the
first round of the tool's command line interface, and reading in mail. She also
implemented the command to statistically classify a set of messages or path to a
message.

Tim contributed to the set-up for the first presentation and collaborated with
teammates to discuss potential work. He also contributed ideas and notions for
working together on design documentation methods.
