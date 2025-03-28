# frozen_string_literal: true

module RedmineMessenger
  module Patches
    module IssuePatch
      extend ActiveSupport::Concern

      included do
        include InstanceMethods

        after_create_commit :send_messenger_create
        after_update_commit :send_messenger_update
      end

      module InstanceMethods
        def send_messenger_create
          channels = Messenger.channels_for_project project
          url = Messenger.url_for_project project

          if Messenger.setting_for_project project, :messenger_direct_users_messages
            messenger_to_be_notified.each do |user|
              channels.append "@#{user.login}" unless user == author
            end
          end

          return unless channels.present? && url
          return if is_private? && !Messenger.setting_for_project(project, :post_private_issues)

          initial_language = ::I18n.locale
          begin
            set_language_if_valid Setting.default_language

            attachment = {}
            if description.present? && Messenger.setting_for_project(project, :new_include_description)
              attachment[:text] = Messenger.markup_format description
            end
            attachment[:fields] = [{ title: I18n.t(:field_status),
                                     value: Messenger.markup_format(status.to_s),
                                     short: true },
                                   { title: I18n.t(:field_priority),
                                     value: Messenger.markup_format(priority.to_s),
                                     short: true }]
            if assigned_to.present?
              attachment[:fields] << { title: I18n.t(:field_assigned_to),
                                       value: Messenger.markup_format(assigned_to.to_s),
                                       short: true }
            end

            attachments.each do |att|
              attachment[:fields] << { title: I18n.t(:label_attachment),
                                       value: "<#{Messenger.object_url att}|#{ERB::Util.html_escape att.filename}>",
                                       short: true }
            end

            if RedmineMessenger.setting?(:display_watchers) && watcher_users.count.positive?
              attachment[:fields] << {
                title: I18n.t(:field_watcher),
                value: Messenger.markup_format(watcher_users.join(', ')),
                short: true
              }
            end

            Messenger.speak l(:label_messenger_issue_created,
                              project_url: Messenger.project_url_markdown(project),
                              url: send_messenger_mention_url(project, description),
                              user: author),
                            channels, url, attachment: attachment, project: project
          ensure
            ::I18n.locale = initial_language
          end
        end

        def send_messenger_update
          return if current_journal.nil?

          channels = Messenger.channels_for_project project
          url = Messenger.url_for_project project

          if Messenger.setting_for_project project, :messenger_direct_users_messages
            messenger_to_be_notified.each do |user|
              channels.append "@#{user.login}" unless user == current_journal.user
            end
          end

          return unless channels.present? && url && Messenger.setting_for_project(project, :post_updates)
          return if is_private? && !Messenger.setting_for_project(project, :post_private_issues)
          return if current_journal.private_notes? && !Messenger.setting_for_project(project, :post_private_notes)

          initial_language = ::I18n.locale
          begin
            set_language_if_valid Setting.default_language

            attachment = {}
            if Messenger.setting_for_project project, :updated_include_description
              attachment_text = Messenger.attachment_text_from_journal current_journal
              attachment[:text] = attachment_text if attachment_text.present?
            end

            fields = current_journal.details.map { |d| Messenger.detail_to_field d, project }
            if current_journal.notes.present?
              fields << { title: I18n.t(:label_comment),
                          value: Messenger.markup_format(current_journal.notes),
                          key: "comment"
                          short: false }
            end
            fields << { title: I18n.t(:field_is_private), short: true } if current_journal.private_notes?
            fields.compact!
            attachment[:fields] = fields if fields.any?

            keys = []
            if attachment[:fields].present?
              keys = attachment[:fields].map do |d| 
                if d[:key].present?
                  d[:key]
                else # 不明なら dump する
                  d.to_s
                end
              end
            end
            
            # 通知対象
            targets = ["title", "subject", "description", "assigned_to", "author", "attachment", "comment"]    
            
            if (keys-targets).size < keys.size
              Messenger.speak l(:label_messenger_issue_updated,
                                project_url: Messenger.project_url_markdown(project),
                                url: send_messenger_mention_url(project, description),
                                user: current_journal.user),
                              channels, url, attachment: attachment, project: project
            end
          ensure
            ::I18n.locale = initial_language
          end
        end

        private

        def messenger_to_be_notified
          to_be_notified = (notified_users + notified_watchers).compact
          to_be_notified.uniq
        end

        def send_messenger_mention_url(project, text)
          mention_to = ''
          if Messenger.setting_for_project(project, :auto_mentions) ||
             Messenger.textfield_for_project(project, :default_mentions).present?
            mention_to = Messenger.mentions project, text
          end
          if current_journal.nil?
            "<#{Messenger.object_url self}|#{Messenger.markup_format self}>#{mention_to}"
          else
            "<#{Messenger.object_url self}#change-#{current_journal.id}|#{Messenger.markup_format self}>#{mention_to}"
          end
        end
      end
    end
  end
end
