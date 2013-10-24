require "bundler/gem_tasks"

namespace :training do

	training_data =
	{
		'CSDMC2010_SPAM.zip'          => 'http://csmining.org/index.php/spam-email-datasets-.html?file=tl_files/Project_Datasets/task2/CSDMC2010_SPAM.zip'
		'20021010_easy_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20021010_easy_ham.tar.bz2'
		'20021010_hard_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20021010_hard_ham.tar.bz2'
		'20021010_spam.tar.bz2'       => 'http://spamassassin.apache.org/publiccorpus/20021010_spam.tar.bz2'
		'20030228_easy_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20030228_easy_ham.tar.bz2'
		'20030228_easy_ham_2.tar.bz2' => 'http://spamassassin.apache.org/publiccorpus/20030228_easy_ham_2.tar.bz2'
		'20030228_hard_ham.tar.bz2'   => 'http://spamassassin.apache.org/publiccorpus/20030228_hard_ham.tar.bz2'
		'20030228_spam.tar.bz2'       => 'http://spamassassin.apache.org/publiccorpus/20030228_spam.tar.bz2'
		'20030228_spam_2.tar.bz2'     => 'http://spamassassin.apache.org/publiccorpus/20030228_spam_2.tar.bz2'
		'20050311_spam_2.tar.bz2'     => 'http://spamassassin.apache.org/publiccorpus/20050311_spam_2.tar.bz2'
	}

	directory 'tmp'
	directory 'training_sets'

	multitask :download => ['CSDMC2010_SPAM.zip']

	file 'CSDMC2010_SPAM.zip' => 'tmp' do
		# download this particular dataset
	end

	task :normalize do
		# Normaliez all downloaded files
	end

end
