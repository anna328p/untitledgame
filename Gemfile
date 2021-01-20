# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>= 2.7'

group :default do
  # SDL2
  gem 'ruby-sdl2',
      require: 'sdl2'

  # Utilities
  gem 'activesupport',
      require: ['active_support', 'active_support/core_ext']

  gem 'hashugar'
  gem 'narray'
  gem 'sqlite3'
end

group :default, :lint do
  # Linter
  gem 'rubocop'
end
