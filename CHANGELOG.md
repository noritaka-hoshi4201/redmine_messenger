Changelog
=========

1.0.15
------

- Ruby 3.2 support
- Redmine 5.0 is required. Use git tag 1.0.14, if you use an older version.

1.0.14
------

- Fix i18n bug: switch back to used language after sending message
- Ruby 2.7 or higher is required. Maintained ruby versions are supported only, see <https://www.ruby-lang.org/en/downloads/>
- Redmine 4.2 is required. Use git tag 1.0.13, if you use an older version.

1.0.13
------

- Slack compatible url formating, see #100

1.0.12
------

- Fixed settings bug introducted with version 1.0.11

1.0.11
------

- Upcoming Redmine 5 support
- Ruby 3 support
- Ruby 2.6 or higher is required
- Use redmine_plugin_kit as plugin loader

1.0.10
------

- Web service is called asynchron which does not block performance while sending message

1.0.9
-----

- Redmine 4.1 is required. Use git tag 1.0.8, if you use an older version.
- Redmine 4.2 support
- Ruby 2.5 or higher is required

1.0.8
-----

- Drop testing with travis - we use github actions
- Add translation pt-BR - thanks to @lucianocosta

1.0.7
-----

- Added feature to send messages directly to users to be notified - thanks to @Ujifman

1.0.6
-----

- Redmine 4 is required. Use git tag 1.0.5, if you use an older version.
- Redmine 4.1 support
- Fix problems with changed fields, description and notes
- Fix problems with quotes #38
- Redundant status and priority in messages #56
- Show attachments for new issues
- Show indicator for private comment on issue
- Ruby 2.4 or higher is required
- Fix project name with &

1.0.5
-----

- ruby 2.4.x or newer is required

1.0.4
-----

- Frensh translation added - thanks to @ZerooCool

1.0.3
-----

- Redmine 4 support

1.0.2
-----

- Bug fixed with issue urls, if Redmine is in subdirectory
- slim is used as template engine
- add private contacts, db and passwords support (if plugins are installed)
- Discord support added to documentation

1.0.1
-----

- Japanese translation has been added - thanks @Yoto
- Default mentions has been added - thanks @xstasi

1.0.0
-----

- Redmine 3.4.x compatibility
- Commit message issue bug fix
- Some code cleanups

0.9.9
-----

- All global messenger settings can be overwritten project based
- Locale support added
- Wiki added supported for notification
- Contact added/updated supported for notification (if redmine_contacts is installed)
- Password added/updated supported for notification (if redmine_passwords is installed)
- DB entry added/updated supported for notification (if redmine_db is installed)
- SSL verify can be disabled
- Lots of refactoring and code cleanups
- Swith from httpclient to net/http
- Fork of redmine_rocketchat, redmine_slack and redmine_mattermost (base functions for all three messenger)

v0.6.1
------

unknown changes

v0.4
----

unknown changes

v0.3
----

unknown changes

v0.2
----

unknown changes

v0.1
----

unknown changes
