require "selenium-webdriver"
driver = Selenium::WebDriver.for(:remote, :url => "http://localhost:9134")
driver.navigate.to "http://google.com"
element = driver.find_element(:name, 'q')
element.send_keys "PhantomJS"
element.submit
puts driver.title
driver.quit

# if working, should print: PhantomJS - Google Search

