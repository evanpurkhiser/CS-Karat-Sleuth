require "bundler/gem_tasks"

namespace :training do

	directory 'tmp'
	directory 'training_sets'

	task :download => ['CSDMC2010_SPAM.zip']

	file 'CSDMC2010_SPAM.zip' => 'tmp' do
		# download this particular dataset
	end

	task :normalize do
		# Normaliez all downloaded files
	end

end
