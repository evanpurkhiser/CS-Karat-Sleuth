require 'karat_sleuth'

class KaratSleuth::CLI

	# Available commands
	COMMANDS = %w(classify reclassify train get-examples help)

	# Usage string
	USAGE = <<-USAGE
karat-slueth - A command line tool for classifying spam email

Usage: karat-slueth COMMAND [options]

The following commands and options are available

train         Train the spam heuristics using a dataset of spam, ham, or both
              email messages. This command accepts a optional path to a folder
              containing a 'spam' and 'ham' folder. If these directories do not
              exist then a second option mussed be passed specifying if the
              email files in the given directories should be considered 'spam'
              or 'ham'.

              You may also sepcify a 'data-set' as the first option to this
              command. This will look for a directory in the current working
              directory named 'training' and then look for a folder with the
              dataset name given as the parameter.

              If no data-set is given and a 'training' folder exists then all
              datasets will be used to train the filter.

              karat-slueth train [data-set|path] [ham|spam]

classify      Classify a set of email messages. This will list out the input
              files with an identifier marking them as either 'ham' or 'spam.
              You may specify a path to mesages, a data-set, or give not
              additional parameters in which case it will classify all mesasges
              in the 'training' folder.

              The parameter behavior is inline with the 'train' command.

              karat-slueth classify [data-set|path]

reclassify    This will take a set of training data, train from it, and then
              reclassify the same emails and print out statistics about the messages trained
              on and how they were classified vs their actual values

get-examples  Download example testing and training data into a 'training'
              folder in the current working directory. This may be used with the
              'train' command as it contains 3 datasets 'hard', 'easy', and a
              'unknown' dataset. Some only contain ham while others also cotanin
              spam messages

help          This help message
USAGE

	def self.start(argv)
		cli = self.new argv

		if argv.length < 1
			puts "Please specify a command"
			puts "Execute `karat-slueth help` for more information"
			return 1
		end

		command = argv[0]

		unless COMMANDS.include? command
			puts "Invalid command: #{command}"
			puts "Execute `karat-slueth help` to see a list of valid commands"
			return 1
		end

		# Execute the command
		return cli.send command.gsub('-', '_').to_sym
	end

	def initialize(argv)
		@argv = argv
	end

	def train; end

	def classify; end

	def reclassify; end

	def get_examples; end

	# Output help / usage message
	def help
		puts USAGE
	end










	def old_code
		require 'mail'
		require 'classifier'

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
		hamDir = "default"
		spamDir = "default"
		if ARGV.length >= 1
			dataDir = ARGV[0]
			hamDir = dataDir + "/ham"
			spamDir = dataDir + "/spam"
		end

		haveHam = File.directory? hamDir
		haveSpam = File.directory? spamDir

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
