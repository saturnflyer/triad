#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.ruby_opts = ["-w"]
  t.verbose = true
end

# Configure Reissue for automated versioning and changelog management
require "reissue"

Reissue::Task.create :reissue do |task|
  task.version_file = "lib/triad/version.rb"
  task.changelog_file = "CHANGELOG.md"
  task.version_limit = 2
  task.commit = true
  task.commit_finalize = true
  task.push_finalize = true
  task.fragment = :git
end

task default: :test
