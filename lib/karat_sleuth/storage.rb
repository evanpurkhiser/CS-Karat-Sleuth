require 'sequel'
require 'classifier/bayes'

module KaratSleuth::Storage
	
	# Get an instance of the SQLite sequel object
	def self.db
		@db ||= Sequel.connect 'sqlite://karat-sleuth.db'
	end

	# Module to add support to the Bayes classifier for persisting the
	# classifications.
	#
	# This will store classifications into the sequel database
	module Bayes

		# Setup the database table on initalization
		def initialize(*categories)
			db = KaratSleuth::Storage.db

			# Ensure the classifications table exists. This will only create the
			# table if it doesn't already exist
			db.create_table? :classifications do
				String  :category
				String  :word
				Integer :tally

				primary_key [:category, :word]
			end

			@db_table = db[:classifications]

			super
		end

		# Save the current Bayesian categories into the KaratSleuth sequel
		# database. This will increment the tally for words that already exist
		# in the persistant storage
		def persist
			# Insert and update entities for category/word tallies
			@categories.each do |category, words|
				words.each do |word, tally|
					classes.insert :category => category.to_s, :word => word.to_s, :tally => tally
				end
			end

			true
		end

		# Load the classifications back in from the KaratSleuth sequel database
		def reload!

		end
	end

	# Patch in the persistence methods to the Bayes Classifier
	Classifier::Bayes.send(:prepend, Bayes)
end
