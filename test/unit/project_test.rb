# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :journals, :journal_details,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :custom_fields,
           :custom_fields_projects,
           :custom_fields_trackers,
           :custom_values,
           :roles,
           :member_roles,
           :members,
           :enabled_modules,
           :versions,
           :groups_users,
           :time_entries,
           :news, :comments,
           :documents,
           :workflows

  def setup
    User.current = User.find 1
  end

  def test_create_project
    Project.delete_all
    Project.create! name: 'Project Messenger', identifier: 'project-messenger'

    assert_equal 1, Project.count
  end

  def test_load_project
    Project.find 1
  end
end
