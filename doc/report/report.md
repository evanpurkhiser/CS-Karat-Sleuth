# Karat-Seluth: A Ruby Spam Classifier

Evan Purkhiser, Heather Michaud, Tim Mott

<!-- Motivation and objects of the project -->
## Introduction

Spam has no clear definition, though an email message is considered suspicious if it is from 
an unknown sender, sent in bulk, or simply unwanted. Spam messages are the junk mail and
Jehovah Witness door-hangups of the internet world. On the contrary, ham messages are emails
that are simply not spam.

<!-- Basic idea of methods or structures proposed to develop the project -->
## Approach

Karat Sleuth was developed to combat the problems of spam categorization in a clear and robust
ruby library which may also be accessed as a command line tool. It is a spam email detection
tool which uses various heuristics and can continually learn what is and what is not spam.

<!-- What's been tried and implemented -->
## Design and Implementation

Karat Sleuth is written as a ruby gem with an intuitive command line interface and library. It
performs bayesian filtering on the email subject and body content. 

<!-- What's been accomplished -->
## Results



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

<!-- What's been learned and what's the next step -->
## Conclusion & Future Work

<!-- Team members and their contribution to the project -->
## Remarks
