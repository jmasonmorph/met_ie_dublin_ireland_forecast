# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

# Read in a page
page = agent.get("https://www.met.ie/forecasts/dublin")

# Find somehing on the page using css selectors
text = page.at('div.forecast').text.strip

# "Issued at: 18 June 2018 17:00\n                                        TODAY - Monday 18th June\n                    Largely cloudy this evening with some drizzle at times, and a few short bright spells.\n\n                                        TONIGHT - Monday 18th June\n                        Dry with clear spells at first tonight, but it will turn cloudier with mist and drizzle through the second half of the night. Lows of 9 or 10 degrees in a light breeze.\n\n                    Grass Pollen Count\n                    High\n                    More information \n                    Solar UV Index\n                    Low to Moderate for Monday\n\n                    UV Index \n                    TOMORROW - Tuesday 19th June\n                        Tomorrow will be another cloudy day with spells of drizzle. It will gradually dry out through the day with some sunny breaks later in the afternoon. Highest temperatures of 18 to 22 degrees with a light easterly breeze.\n\n                    National Outlook\n"

text.gsub!(/[ \t]+/, ' ')
text.gsub!(/ *\n */, "\n")
#print text

text =~ /\nTODAY - (.+)\n(.*?)\n\n/is
todaydate = $1
todaycast = $2
print "TODAY [#{todaydate}] [#{todaycast}]\n"

text =~ /\nTOMORROW - (.+)\n(.*?)\n\n/is
tomozdate = $1
tomozcast = $2
print "TOMORROW [#{tomozdate}] [#{tomozcast}]\n"


# Write out to the sqlite database using scraperwiki library
ScraperWiki.save_sqlite(["day"], {
  "day" => todaydate,
  "today_forecast" => todaycast,
  "tomorrow" => tomozdate,
  "tomorrow_forecast" => tomozcast
})

# An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
#
