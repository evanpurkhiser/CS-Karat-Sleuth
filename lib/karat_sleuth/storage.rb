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
		# Add methods to persist bayes data
	end

	# Patch in the persistance methods to the Bayes Classifier
	Classifier::Bayes.send(:include, Bayes)
end
