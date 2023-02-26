# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class IssueTest < ActiveSupport::TestCase
  fixtures :projects, :users, :members, :member_roles, :roles,
           :trackers, :projects_trackers,
           :enabled_modules,
           :issue_statuses, :issue_categories, :workflows,
           :enumerations,
           :issues, :journals, :journal_details,
           :custom_fields, :custom_fields_projects, :custom_fields_trackers, :custom_values,
           :time_entries

  include Redmine::I18n

  def setup
    set_language_if_valid 'en'
  end

  def teardown
    User.current = nil
  end

  def test_create
    issue = Issue.new project_id: 1, tracker_id: 1, author_id: 3, subject: 'test_create'

    assert_save issue
    assert_equal issue.tracker.default_status, issue.status
    assert_nil issue.description
  end
end
