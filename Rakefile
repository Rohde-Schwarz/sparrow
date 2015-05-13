require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

RAILS_VERSIONS = [
  "3.2.17",
  "4.0.13"
]

def run_tests_for_version(version)
  commands = []

  commands << "rm Gemfile.lock"
  commands << "export RAILS_VERSION=#{version}"
  commands << "bundle update"
  commands << "bundle exec rspec"

  system(commands.join(';'))
end

task :default do
  RAILS_VERSIONS.each do |version|
    puts "Testing gem for rails version: #{version}"
    success = run_tests_for_version(version)

    if not success
      puts "Test suite aborted, errors occured."
      exit($?.exitstatus)
    end
  end
end
