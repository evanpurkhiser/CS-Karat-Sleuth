require 'karat_sleuth'

class KaratSleuth::CLI

	# Available commands
	COMMANDS = %w[classify reclassify train get-examples help]

	# The directory to look for data sets in by default
	DEFAULT_DATA_DIR = 'training'

	# Usage string
	USAGE = <<-USAGE
karat-sleuth - A command line tool for classifying spam email

Usage: karat-sleuth COMMAND [options]

The following commands and options are available

train         Train the spam heuristics using a dataset of spam, ham, or both
              email messages. This command accepts an optional path to a folder
              containing a 'spam' and 'ham' folder. If these directories do not
              exist then a second option must be passed specifying if the
              email files in the given directories should be considered 'spam'
              or 'ham'.

              You may also sepcify a 'data-set' as the first option to this
              command. This will look for a directory in the current working
              directory named 'training' and then look for a folder with the
              dataset name given as the parameter.

              If no data-set is given and a 'training' folder exists then all
              datasets will be used to train the filter.

              karat-sleuth train [data-set|path] [ham|spam]

classify      Classify a set of email messages. This will list out the input
              files with an identifier marking them as either 'ham' or 'spam'.
              You may specify a path to messages, a data-set, or give no
              additional parameters in which case it will classify all mesasges
              in the 'training' folder.

              The parameter behavior is inline with the 'train' command.

              karat-sleuth classify [data-set|path]

reclassify    This will take a set of training data, train from it, and then
              reclassify the same emails and print out statistics about the messages trained
              on and how they were classified vs their actual values.

              karat-sleuth reclassify [data-set|path]

get-examples  Download example testing and training data into a 'training'
              folder in the current working directory. This may be used with the
              'train' command as it contains 3 datasets 'hard', 'easy', and an
              'unknown' dataset. Some only contain ham while others also contain
              spam messages.

              karat-sleuth get-examples

help          This help message
USAGE

	# Start the command line parser. This will accept a list of arguments and
	# will execute a command based on the first argument. All other arguments
	# will be passed to the CLI object
	def self.start(argv)
		if argv.length < 1
			puts "Please specify a command"
			puts "Execute `karat-sleuth help` for more information"
			return 1
		end

		command = argv.shift
		cli = self.new argv

		unless COMMANDS.include? command
			puts "Invalid command: #{command}"
			puts "Execute `karat-sleuth help` to see a list of valid commands"
			return 1
		end

		# Execute the command
		return cli.send command.gsub('-', '_').to_sym
	end

	def initialize(argv)
		@argv = argv
	end

	# Detect a list of emails. This looks at the first (or more) options passed
	# to the command and will check a few different things:
	#
	#  1. If no files or directories are passed then use all emails from the
	#     DEFAULT_DATA_DIR
	#
	#  2. If no directories are given, but a target ('ham', or 'spam') is given
	#     then use all emails in the DEFAULT_DATA_DIR that match the target
	#
	#  3. If multiple arguments are given that are existing _file_ paths then
	#     these are the emails to add to the returned list
	#
	#  4. If a single directory path is given then check that the directory
	#     exists. If so then check for 'spam' and 'ham' subdirectories. If these
	#     exist then group a list of email file paths into 'ham' and 'spam' keys
	#     on the returned hash
	#
	#  5. If the given option is not a directory then look for the
	#     DEFAULT_DATA_DIR and check if that contains the given dataset folder
	#
	# This will always check if the last argument is 'ham' or 'spam' and set the
	# :target key based on this
	#
	# Here's an example of what the returned hash may look like:
	#
	# {
	#   # The target key indicates 'targeted' email type. This could mean
	#   # multiple things based on CLI interpretation. This will be Nil if no
	#   # target type was specified as the last argument
	#   :target => nil,
	#
	#   # Indicates if the emails list has been grouped by spam or ham or if is
	#   # just a single array of email paths
	#   :grouped => true,
	#
	#   # The list of emails. If the grouped key is true then this will be
	#   # grouped based on the classification of emails (as it is here).
	#   # However if not grouped then this will just be a single array of email
	#   # paths.
	#   :emails =>
	#   {
	#     :ham  => [list of files],
	#     :spam => [list of files],
	#   },
	# }
	#
	# This may return false if we can't find any emails what so ever
	def detect_emails
		# Test if the DEFAULT_DATA_DIR exists
		data_dir_exists = File.directory? DEFAULT_DATA_DIR

		argv = @argv.clone

		# Case #1
		#
		# If no arguments exist at all then look for all files in the
		# DEFAULT_DATA_DIR
		if argv.empty?
			# Can't do anything without any emails!
			return false unless data_dir_exists

			# Get all emails in the default data directory
			return \
			{
				:target  => nil,
				:grouped => true,
				:emails  =>
				{
					:ham  => Dir.glob(File.join(DEFAULT_DATA_DIR, '**/ham/*')),
					:spam => Dir.glob(File.join(DEFAULT_DATA_DIR, '**/spam/*')),
				},
			}
		end

		result = { :target  => nil, :grouped => false }

		# Check if the ham or spam target has been specified as the last
		# parameter. This removes the target from argv
		result[:target] = argv.pop.to_sym if ['ham', 'spam'].include? argv.last

		# Case #2
		#
		# If we have no more arguments then we're looking for the
		# DEFAULT_DATA_DIR and only looking at the datasets for the specified
		# target
		if argv.empty?
			# Can't do anything without any emails!
			return false unless data_dir_exists

			glob_path = File.join(DEFAULT_DATA_DIR, '*', result[:target].to_s, '*')

			# Find emails in each dataset belonging to the target group
			result[:emails]  = { result[:target] => Dir.glob(glob_path) }
			result[:grouped] = true

			return result
		end

		# Case #3
		#
		# If we have more than one argument then that is our list of emails.
		# Make sure each and every one of them is a file
		if argv.length > 1
			# Remove emails that don't exist
			emails = argv.reject { |p| ! File.exist? p }

			# Can't do anything with an empty email list
			return false if emails.empty?

			result[:emails] = emails;
			return result
		end

		item = argv.shift

		# Case #4
		#
		# If we've been given a single directory that exists then look for all
		# emails in that directory. If a 'ham' or 'spam' folder exists then
		# group them
		if File.directory? item
			# Check for ham/spam directory
			target_dirs = Pathname.glob(File.join(item, '*/'))
				.map(&:basename)
				.map(&:to_s)
				.send(:&, ['spam', 'ham'])
				.map(&:to_sym)

			# Just return email paths if the directory has neither spam nor ham
			# directories
			if target_dirs.empty?
				result[:emails] = Dir.glob(File.join(item, '**/*'))

			# If the directory contains target_dirs then we can group our emails
			# based on which ones are in which directories
			else
				# If we have a particular target then ignore the other directory
				target_dirs = [result[:target]] if result[:target]

				result[:emails]  = Hash.new
				result[:grouped] = true

				target_dirs.each do |dir|
					result[:emails][dir] = Dir.glob(File.join(item, dir.to_s, '*'))
				end
			end

			return result

		# Case #5
		#
		# A data-set name was passed, check if this exists in the
		# DEFAULT_DATA_DIR and group emails into spam/ham accordingly
		else
			path = File.join(DEFAULT_DATA_DIR, item)

			# Can't do anything if the data-set doesn't exist
			return false unless File.directory? path

			result[:grouped] = true

			# If we have a specified target only groups those emails
			if result[:target]
				glob_path = File.join(path, result[:target].to_s, '*')
				result[:emails] = { result[:target] => Dir.glob(glob_path) }

			# Get emails from both ham and spam for this dataset
			else
				result[:emails] =
				{
					:ham  => Dir.glob(File.join(path, 'ham',  '*')),
					:spam => Dir.glob(File.join(path, 'spam', '*')),
				}
			end

			return result
		end

		return false
	end

	# Commands that may be executed via the COMMAND
	module Commands

		# Train the classifier from emails
		def train
			require 'classifier'
			require 'mail'

			options = detect_emails
			bayes   = Classifier::Bayes.new 'spam', 'ham'

			# Don't do anything right now unless it's grouped
			return if ! options[:grouped]

			total = 0

			options[:emails].each do |type, emails|
				emails.each do |path|
					mail = Mail.read(path)

					# Use contents of email to add into knowledge base
					if mail.subject
						bayes.train type.to_s, mail.subject
					end
					if mail.body.decoded
						bayes.train type.to_s, mail.body.decoded
					end

					print "\r#{total += 1}"
					STDOUT.flush
				end
			end

			bayes.persist
		end

		# Use the classifier to group emails
		def classify
			require 'classifier'
			require 'mail'
			require 'colorize'

			options = detect_emails
			bayes   = Classifier::Bayes.new 'spam', 'ham'
			bayes.reload!

			# Don't do anything right now unless it's grouped
			return if ! options[:grouped]

			total_positive = 0 # Total number of ham messages
			total_negative = 0 # Total number of spam messages
			true_positive  = 0 # Number of correctly identified ham messages
			true_negative  = 0 # Number of correctly identified spam messages
			false_positive = 0 # Number of spam messages incorrectly identified as ham
			false_negative = 0 # Number of ham messages incorrectly identified as spam

			options[:emails].each do |type, emails|
				emails.each do |path|
					mail = Mail.read(path)

					# Use contents of email to classify message and print accuracy
					if mail.body.decoded
						result = bayes.classify mail.body.decoded
						output = "\r#{path}     #{type}     #{result}\n"
						if "#{type}" == result.downcase
							print output.green
						else
							print output.red
						end

						# Identify true and false positives (ham)
						if "#{type}" == 'ham'
							total_positive += 1
							print "hit ham"
							if result == 'Ham'
								true_positive += 1
							else
								false_positive += 1
							end
						end

						# Identify true and false negatives (spam)
						if "#{type}" == 'spam'
							total_negative += 1
							print "hit spam"
							if result == 'Spam'
								true_negative += 1
							else
								false_negative +=1
							end
						end

						total = total_positive + total_negative
						print "\n\r#{total}\e[1A\r\e[K#{"-"*(output.length - 2)}".light_white
						
					end
				end
			end

			# Pretty print total results in a confusion matrix
			puts "\n\n\nActual vs. Predicted\n".light_cyan
			format = "%6s\t%6s\t%6s\n".light_cyan
			printf(format, " ", "Ham", "Spam")
			printf(format, "     .", "------", "------")
			printf(format, "Ham  |", "#{true_positive}", "#{false_positive}")
			printf(format, "Spam |", "#{false_negative}", "#{true_negative}")
			puts "\n"
		end

		def reclassify; end

		# Execute the rake tasks to download example training / testing data
		def get_examples
			pwd = Dir.pwd
			Dir.chdir File.expand_path('../..', __dir__)

			require 'rake'
			Rake.load_rakefile 'Rakefile'
			Rake::Task['training:normalize'].invoke(pwd)
		end

		# Output help / usage message
		def help
			puts USAGE
		end

	end

	include Commands
end
