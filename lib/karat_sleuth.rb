require "karat_sleuth/version"
require "karat_sleuth/storage"

require 'mail'

module KaratSleuth

	# These are the two valid classifications for email
	CLASSIFICATIONS = [:ham, :spam]

	# Convert a email file into a message object
	def path_to_message(path)
		Mail.read(path)
	end

	# Convert a string to a message object
	def string_to_message(string)
		Mail.read_from_string(string)
	end

	# Learn from a message
	def train_from_message(message, classification)
		raise "Invalid message classification" unless CLASSIFICATIONS.include? classification

		# Do 'something' to train the classifier from this message
	end

	# Classify a message
	def classify_message(message)
		message.classify
	end

	# Extend the Mail class to support various classification methods
	module MailClassifiers

		# Determine the classification of this message
		def classify
			:ham
		end

		# Test if a given message is classified has ham
		def is_ham?
			true
		end

		# Test if a given message is classified as spam
		def is_spam?
			false
		end
	end

	Mail.send(:include, MailClassifiers)
end
