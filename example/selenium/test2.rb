# this downloads a google cache page to prove it works

require "selenium-webdriver"
driver = Selenium::WebDriver.for(:remote, :url => "http://localhost:9134")
driver.navigate.to "http://webcache.googleusercontent.com/search?q=cache:Ju15x29vkwoJ:https://github.com/jnicklas/capybara+&cd=1&hl=en&ct=clnk&gl=us"
#element = driver.find_element(:name, 'q')
#element.send_keys "PhantomJS"
#element.submit
#puts driver.title
puts driver.page_source
driver.quit

