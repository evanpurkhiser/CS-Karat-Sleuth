require "karat_sleuth/version"
require "karat_sleuth/storage"
require "karat_sleuth/classifier"

require 'mail'

module KaratSleuth

	# These are the two valid classifications for email
	CLASSIFICATIONS = [:ham, :spam]

	# Convert a email file into a message object
	def self.path_to_message(path)
#		$stderr.reopen '/dev/null', 'w'
		message = Mail.read(path)
#		$stderr = STDERR

		message
	end

	# Convert a string to a message object
	def self.string_to_message(string)
		$stderr.reopen '/dev/null', 'w'
		message = Mail.read_from_string(string)
		$stderr = STDERR

		message
	end

	# Learn from a message
	def self.train_from_message(message, classification)
		raise "Invalid message classification" unless CLASSIFICATIONS.include? classification
		Classifier.train message, classification
	end

	# Classify a message
	def self.classify_message(message)
		message.classify
	end

	# Extend the Mail class to support various classification methods
	module MailClassifiers

		# Determine the classification of this message
		def classify
			Classifier.classify self
		end

		# Test if a given message is classified has ham
		def is_ham?
			classify == :ham
		end

		# Test if a given message is classified as spam
		def is_spam?
			classify == :spam
		end
	end

	Mail::Message.send(:include, MailClassifiers)
end
