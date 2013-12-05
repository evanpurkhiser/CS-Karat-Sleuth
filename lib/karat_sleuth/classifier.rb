require 'classifier/bayes'
require 'classifier/extensions/string'

module KaratSleuth::Classifier

		# Return the current instance of the Bayesian classifier
		def self.bayes
			@bayes ||= Classifier::Bayes.new *KaratSleuth::CLASSIFICATIONS.map(&:to_s)
		end

		# Train the classifier using the Bayesian classifier
		def self.train(message, classification)
			subject = message.subject
			body    = message.body.decoded

			bayes.train classification.to_s, subject if subject
			bayes.train classification.to_s, body    if body
		end

end
