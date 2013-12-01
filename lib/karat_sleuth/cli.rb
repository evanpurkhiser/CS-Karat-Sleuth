require 'karat_sleuth'

require 'mail'
require 'classifier'

class KaratSleuth::CLI

	def self.start(argv)
		# Expected input for error messages
		expectedArg = "Possible inputs:
karat-sleuth
karat-sleuth <classified-dir>
karat-sleuth <unclassified-dir> {spam,ham}"

		# Set data directory to project root by default
		dataDir = File.expand_path("../training/", Dir.pwd)

		if ARGV.length > 2
			puts "Too many arguments. " + expectedArg
			exit
		end

		# If given the directory, look for separated ham/spam folders with emails
		haveHam = true
		haveSpam = true
		if ARGV.length >= 1
			dataDir = ARGV[0]
			hamDir = dataDir + "/ham"
			spamDir = dataDir + "/spam"
		end

		haveHam = false unless File.directory? hamDir
		haveSpam = false unless File.directory? spamDir

		# The directory could have either ham, spam, or both.
		if !haveSpam && !haveHam
			puts "Could not find spam or ham directory. " + expectedArg
			exit
		end

		# If the directory has been classified as ham/spam
		if ARGV.length == 2
			dataType = ARGV[1]
			if dataType != "spam" && dataType != "ham"
				puts "Invalid argument. " + expectedArg
				exit
			end
		end

		# Verify existence of training data
		unless File.directory? dataDir
			puts dataDir + ": No such directory. " + expectedArg
			exit
		end

		bayes = Classifier::Bayes.new 'spam', 'ham'

		# This should probably be in the library instead
		# Read in each item within the directory

		# Classify ham data sets
		if haveHam
			Dir.foreach(hamDir) do |item|
				next if item == '.' or item == '..'
				data = "#{hamDir}/#{item}"
				mail = Mail.read(data)
				# Use contents of ham mail to add into knowledge base
				if mail.subject
					bayes.train 'ham', mail.subject
				end
				if mail.body.decoded
					bayes.train 'ham', mail.body.decoded
				end
			end
		end

		# Classify spam data sets
		if haveSpam
			Dir.foreach(spamDir) do |item|
				next if item == '.' or item == '..'
				data = "#{spamDir}/#{item}"
				mail = Mail.read(data)
				# Use contents of spam mail to add into knowledge base
				if mail.subject
					bayes.train 'spam', mail.subject
				end
				if mail.body.decoded
					bayes.train 'spam', mail.body.decoded
				end
			end
		end
	end

end
