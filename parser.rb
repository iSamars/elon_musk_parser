# frozen_string_literal: true
require 'selenium-webdriver'
require 'nokogiri'

# selenium options
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options

# loading elonmusk page
driver.navigate.to 'https://twitter.com/elonmusk'
driver.manage.timeouts.implicit_wait = 10
driver.find_element(tag_name: 'article') # wait while page loading

doc = Nokogiri::HTML(driver.page_source)

tweets_texts = doc.xpath('//div[contains(@class, "css-901oao r-18jsvk2 r-1qd0xha r-a023e6 r-16dba41 r-ad9z0x r-bcqeeo r-bnwqim r-qvutc0")]/span')
tweets_links = doc.xpath('//a[@class = "css-4rbku5 css-18t94o4 css-901oao r-m0bqgq r-1loqt21 r-1q142lx r-1qd0xha r-a023e6 r-16dba41 r-ad9z0x r-bcqeeo r-3s2u2q r-qvutc0"]')

res = ''

(0..2).each do |i|
  res += "\nPost #{i + 1}:\n#{tweets_texts[i].text}\nCommented by:\n"

  # loading tweet[i] comment page
  driver.navigate.to("https://twitter.com/#{tweets_links[i]['href']}/retweets/with_comments")
  driver.find_element(tag_name: 'article') # wait while page loading

  tweet_doc = Nokogiri::HTML(driver.page_source)
  comments_authors = tweet_doc.xpath('//a[@class="css-4rbku5 css-18t94o4 css-1dbjc4n r-1loqt21 r-1wbh5a2 r-dnmrzs r-1ny4l3l"]')

  (1..3).each do |j|
    res += "- https://twitter.com#{comments_authors[j]['href']}\n"
  end
end

puts res
