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

		# Save the current Bayesian categories into the KaratSleuth sequel
		# database
		def persist
			db = KaratSleuth::Storage.db

			# Ensure the classifications table exists. This will only create the
			# table if it doesn't already exist
			db.create_table? :classifications do
				primary_key :id

				String  :category
				String  :word
				Integer :tally
			end

			classes = db[:classifications]

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
	Classifier::Bayes.send(:include, Bayes)
end
