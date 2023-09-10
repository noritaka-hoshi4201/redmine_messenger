# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start :rails do
    add_filter 'init.rb'
    root File.expand_path "#{File.dirname __FILE__}/.."
  end
end

require File.expand_path "#{File.dirname __FILE__}/../../../test/test_helper"

module RedmineMessenger
  class TestCase
    include ActionDispatch::TestProcess

    def self.prepare
      Role.where(id: [1, 2]).find_each do |r|
        r.permissions << :view_issues
        r.save
      end

      Project.where(id: [1, 2]).find_each do |project|
        EnabledModule.create project: project, name: 'issue_tracking'
      end
    end
  end
end
