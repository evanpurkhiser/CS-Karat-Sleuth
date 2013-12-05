require 'classifier/bayes'
require 'classifier/extensions/string'

module KaratSleuth::Classifier

	# Return the current instance of the Bayesian classifier
	def self.bayes
		unless @bayes
			@bayes = ::Classifier::Bayes.new *KaratSleuth::CLASSIFICATIONS.map(&:to_s)
			@bayes.reload!
		end

		@bayes
	end

	# Train the classifier using the Bayesian classifier
	def self.train(message, classification)
		subject = message.subject
		body    = message.body.decoded

		bayes.train classification.to_s, subject if subject
		bayes.train classification.to_s, body    if body
	end

	# Classify a message using the classifier pipeline
	def self.classify(message)
		text  = ""
		text += message.body.decode if message.body
		text += message.subject     if message.subject

		bayes.classify text
	end

end
