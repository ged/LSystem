#!/usr/bin/env ruby -S rake

require 'rake'
require 'rake/deveiate'

EXAMPLE_IMAGES = Rake::FileList[ 'examples/*.png' ]


Rake::DevEiate.setup( 'lsystem' ) do |project|
	project.publish_to = 'deveiate:/usr/local/www/public/code'
end


file EXAMPLE_IMAGES

task :docs => EXAMPLE_IMAGES do
	mkdir_p 'docs/examples/'
	cp EXAMPLE_IMAGES.to_a, 'docs/examples/'
end


