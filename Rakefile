require "bundler/gem_tasks"
require "digest/md5"

namespace :training do

	training_data =
	{
		'CSDMC2010_SPAM.zip'          => 'http://csmining.org/index.php/spam-email-datasets-.html?file=tl_files/Project_Datasets/task2/CSDMC2010_SPAM.zip',
		'20021010_easy_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20021010_easy_ham.tar.bz2',
		'20021010_hard_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20021010_hard_ham.tar.bz2',
		'20021010_spam.tar.bz2'       => 'http://spamassassin.apache.org/publiccorpus/20021010_spam.tar.bz2',
		'20030228_easy_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20030228_easy_ham.tar.bz2',
		'20030228_easy_ham_2.tar.bz2' => 'http://spamassassin.apache.org/publiccorpus/20030228_easy_ham_2.tar.bz2',
		'20030228_hard_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20030228_hard_ham.tar.bz2',
		'20030228_spam.tar.bz2'       => 'http://spamassassin.apache.org/publiccorpus/20030228_spam.tar.bz2',
		'20030228_spam_2.tar.bz2'     => 'http://spamassassin.apache.org/publiccorpus/20030228_spam_2.tar.bz2',
		'20050311_spam_2.tar.bz2'     => 'http://spamassassin.apache.org/publiccorpus/20050311_spam_2.tar.bz2',
	}

	# Training data will be stored in the tmp directory. Prefix all names
	download_tasks = Hash[training_data.map { |k, v| [File.join('tmp', k), v] }]

	# Task to download all defined spam sets
	task :download => download_tasks.keys

	directory 'tmp'

	# Create download tasks for each file
	download_tasks.each do |name, url|
		file(name => 'tmp') { sh 'wget', '-O', name, url }
	end


	# Normalization organizes email message into groups based on the
	# 'difficulty' of the messages and based on weather the messages are known
	# spam / ham.
	task :normalize => :download do

		# Spam assassin sets match a pattern when they are extracted. The extracted
		# folder will be the name after the date of the archive file. The type of
		# emails it contains is also in the name of the file.

		# Let's get all the spam assassin files
		#
		# NOTE: Be aware, this matches the known file names for spam assassin
		#       archives. If we happen to add more training data that also matches
		#       this pattern, but doesn't match the extraction pattern then we may
		#       run into some problems later on
		spam_assassin_sets = training_data.keys.select { |k| k[/[0-9]{8}_.*\.tar\.bz2/] }

		spam_assassin_sets.each do |name|
			# Determine the type of messages and difficulty
			type = name[/ham|spam/]
			difficulty = name[/easy|hard/] || 'unknown'

			# Get the name of the folder that will be extracted
			folder = File.join 'tmp', name.match(/[0-9]+_(.*)\.tar\.bz2/)[1]

			# Where to extract the email messages to
			target  = File.join 'training', difficulty, type
			tarball = File.join 'tmp', name

			# Extract the messages to the tmp directory
			sh "tar -xf #{tarball} -C tmp"
			mkdir_p target

			Dir.glob(File.join(folder, '*.*')) do |filename|
				# The filename of the file should be it's MD5 checksum
				new_name = Digest::MD5.hexdigest(File.read filename) + '.msg'
				mv filename, File.join(target, new_name)
			end
			rm_r folder
		end

		# Normalize the CSMINING spam corpus
		#
		# The CSMINING 2010 spam corpus contains a set of training data under
		# the TRAINING folder. However, this isn't organized into spam vs ham in
		# the directory tree. Instead the 'SPAMTrain.label' file contains a list
		# of files and if they are spam or not.
		#
		# Move each file into the correct directory for spam vs ham
		begin
			# Extract the contents of the file
			sh "unzip -q -o tmp/CSDMC2010_SPAM.zip -d tmp"
			folder = 'tmp/CSDMC2010_SPAM/CSDMC2010_SPAM'

			# Map the filename to the boolean value of if it is spam or not
			spam_labels = File.readlines(File.join(folder, 'SPAMTrain.label'))
			spam_map = Hash[spam_labels.map { |line| [line[1..-1].strip, !line[0].to_i.zero?] }]

			# Contains both spam and ham files
			mkdir_p 'training/unknown/spam'
			mkdir_p 'training/unknown/ham'

			Dir.glob(File.join(folder, 'TRAINING', '*.eml')) do |filename|
				# The filename of the file should be it's MD5 checksum
				new_name = Digest::MD5.hexdigest(File.read filename) + '.msg'

				# Check if it's SPAM or HAM
				type = spam_map[File.basename filename] ? 'spam' : 'ham'

				mv filename, File.join('training/unknown', type, new_name)
			end

			rm_r 'tmp/CSDMC2010_SPAM'
		end
	end
end
