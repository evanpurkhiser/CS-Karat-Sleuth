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
			# Keep track of entries not on the database already to mass-insert
			new_entries = []

			# Insert and update entities for category/word tallies
			@categories.each do |category, words|
				words.each do |word, tally|
					key = { :category => category.to_s, :word => word.to_s }
					tally = tally.to_i

					if @db_table.where(key).empty?
						# Insert a new entry if not already entered into the database
						new_entries << key.merge(:tally => tally)
					else
						# Increment the tally if the entry exists
						@db_table.where(key).update(:tally => Sequel.expr(tally) + :tally)
					end
				end
			end

			# Insert all new entires into persistant storage
			@db_table.multi_insert new_entries

			true
		end

		# Persist the current Bayesian categories into a clean database. This
		# will clear all previous classifications from the persistant storage
		# and save the current state of the classifier. This is different from
		# the normal Bayes::persist method in that previous tallies are not
		# preserved
		def persist_fresh
			@db_table.delete
			persist

			true
		end

		# Load the classifications back in from the KaratSleuth sequel database
		def reload!
			# Reinitalize the categories for this classifier instance
			categories = @db_table.all.map { |entry| entry[:category] }.uniq
			initialize *categories

			# Collect all words and tallies
			@db_table.each do |entry|
				@categories[entry[:category]][entry[:word]] = entry[:tally]
			end

			true
		end
	end

	# Patch in the persistence methods to the Bayes Classifier
	Classifier::Bayes.send(:prepend, Bayes)
end
