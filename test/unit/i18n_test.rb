# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class I18nTest < ActiveSupport::TestCase
  include Redmine::I18n

  def setup
    User.current = nil
  end

  def teardown
    set_language_if_valid 'en'
  end

  def test_valid_languages
    assert_kind_of Array, valid_languages
    assert_kind_of Symbol, valid_languages.first
  end

  def test_locales_validness
    lang_files_count = Rails.root.glob('plugins/redmine_messenger/config/locales/*.yml').size

    assert_equal 7, lang_files_count
    valid_languages.each do |lang|
      assert set_language_if_valid(lang)
      case lang.to_s
      when 'en'

        assert_equal 'Messenger username', l(:label_settings_messenger_username)
      when 'de', 'fr', 'ja', 'ko', 'pt-BR'

        assert_not l(:label_settings_messenger_username) == 'Messenger username', lang
      end
    end

    set_language_if_valid 'en'
  end
end
