require 'capybara/rspec'

# ふだんはブラウザなし
RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :rack_test }
end

# 画面を出す Chromium ドライバ
Capybara.register_driver :selenium_chromium do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  # headless を付けない＝ウィンドウを表示
  opts.add_argument 'no-sandbox'
  opts.add_argument 'disable-gpu'
  opts.add_argument 'window-size=1400,900'

  # WSL の Chromium 実体を探す
  %w[/usr/bin/chromium /usr/bin/chromium-browser].each do |bin|
    opts.binary = bin if File.exist?(bin)
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end

# JSテストはヘッドレスでも可視でも好みで切替可能（必要なら）
Capybara.register_driver :headless_chromium do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument 'headless=new'
  opts.add_argument 'no-sandbox'
  opts.add_argument 'disable-gpu'
  opts.add_argument 'window-size=1400,900'
  %w[/usr/bin/chromium /usr/bin/chromium-browser].each { |b| opts.binary = b if File.exist?(b) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
end
