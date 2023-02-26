# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class RoutingTest < Redmine::RoutingTest
  test 'routing messenger' do
    should_route 'GET /projects/1/settings/messenger' => 'projects#settings', id: '1', tab: 'messenger'
    should_route 'PUT /projects/1/messenger_setting' => 'messenger_settings#update', project_id: '1'
  end
end
