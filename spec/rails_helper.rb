# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'factory_bot'
require 'capybara/rspec'
require 'email_spec'
require 'email_spec/rspec'
# Add additional requires below this line. Rails is not loaded until this point!

# rspecのsupportディレクトリ配下が読み込まれるようにする
# support/capybara.rbを読み込むために
Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # FactoryBot操作のため
  config.include FactoryBot::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # デフォルト（普通）は、高速なRack::Testドライバを使用
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # jsを使用するテストの場合は、chromeのヘッドレスドライバ使用
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  # js: true でない場合のデフォルトドライバを selenium_chrome に変更
  config.before(:each, type: :system, js: true) do
    Capybara.current_driver = :selenium_chrome
  end

  # deviseのヘルパーメソッドを呼び出せるようにする
  config.include Devise::Test::IntegrationHelpers, type: :system

  #各プロバイダのモックを作成するモジュールを読み込む
  config.include OmniauthMock, type: :system

end
