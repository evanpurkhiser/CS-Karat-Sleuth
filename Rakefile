require "bundler/gem_tasks"

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
	training_data = Hash[training_data.map { |k, v| [File.join('tmp', k), v] }]

	# Task to download all defined spam sets
	task :download => training_data.keys

	directory 'tmp'
	directory 'training_sets'

	# Create download tasks for each file
	training_data.each do |name, url|
		file(name => 'tmp') { sh 'wget', '-O', name, url }
	end

	task :normalize do
		# Normaliez all downloaded files
	end

end
