require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

RAILS_VERSIONS = [
  "4.2.6"
]

def run_tests_for_version(version)
  commands = []

  commands << "rm Gemfile.lock"
  commands << "gem install rails -v #{version}"
  commands << "bundle install"
  commands << "bundle exec rspec"

  system({'RAILS_VERSION' => version}, commands.join(' && '))
end

task :all do
  RAILS_VERSIONS.each do |version|
    puts "Testing gem for rails version: #{version}"
    success = run_tests_for_version(version)

    unless success
      puts "Test suite aborted, errors occured."
      exit($?.exitstatus)
    end
  end
end

task :default do
  run_tests_for_version(ENV['RAILS_VERSION'] || '4.2.6')
end
