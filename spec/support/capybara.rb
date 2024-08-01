require 'capybara/rspec'
require 'selenium-webdriver'

# selenium_chrome_headlessという名前でCapybaraドライバ登録
Capybara.register_driver :selenium_chrome_headless do |_app|
  # Chromeオプション設定のためのオブジェクト
  options = Selenium::WebDriver::Chrome::Options.new
  # GUI使わずに実行
  options.add_argument('--headless')
  # コンテナ内でChrome実行するのに必要
  # サンドボックス:ブラウザを他のシステムプロセスから隔離された環境で実行すること
  options.add_argument('--no-sandbox')
  # コンテナ内でChrome実行するのに必要
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')
end
# jsを使用するテストには自動でヘッドレスモードのChromeが使用される
Capybara.javascript_driver = :selenium_chrome_headless

Capybara.configure do |config|
  config.default_driver = :selenium_chrome
  # または
  # config.default_driver = :rack_test
end
