#!/bin/bash

# BUNDLER_VERSION=$(fgrep -A1 'BUNDLED WITH' Gemfile.lock | tail -1 | sed -e 's/^ *//')
EDITOR_USER="papyri"

# make sure we can run jruby/bundle as $EDITOR_USER before doing anything
sudo -u $EDITOR_USER -i jruby --version && sudo -u $EDITOR_USER -i bundle --version
if [ $? -eq 0 ]; then
  sudo -u $EDITOR_USER -i bundle install --deployment
  # Needed for asset pipeline:
  sudo -u $EDITOR_USER -i bundle exec rake assets:precompile RAILS_ENV="production" RAILS_RELATIVE_URL_ROOT='/editor' RAILS_GROUPS="assets"
  sudo -u $EDITOR_USER -i bundle exec cap local externals:setup
  sudo -u $EDITOR_USER -i bundle exec rake db:migrate RAILS_ENV="production"
  sudo systemctl restart papyri.editor
fi
