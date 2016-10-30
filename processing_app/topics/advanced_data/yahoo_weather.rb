#
# Loading XML Data
# by Daniel Shiffman.
#
# This example demonstrates how to use loadXML
# to retrieve data from an XML document via a URL
#

attr_reader :zip, :weather, :temperature
WOEID = '12761335' # yahoos code for ZIP = '10003'
def setup
  sketch_title 'Yahoo Weather'
  @zip = 10_003
  font = create_font('Times Roman', 26)
  # font = create_font('Merriweather-Light.ttf', 28)
  text_font(font)
  # The URL for the XML document

  fo = "http://query.yahooapis.com/v1/public/yql?format=xml&q=select+*+from+weather.forecast+where+woeid=%s+and+u='F'"
  url = format(fo, WOEID)
  # Load the XML document
  xml = loadXML(url)
  # Grab the element we want
  forecast = xml.getChild("results/channel/item/yweather:forecast");
  # Get the attributes we want
  @temperature = forecast.get_int('high')
  @weather = forecast.get_string('text')
end

def draw
  background(255)
  fill(0)
  # Display all the stuff we want to display
  text(format('Zip code: %s', zip), width * 0.15, height * 0.33)
  text(format("Today's high: %s", temperature), width * 0.15, height * 0.5)
  text(format('Forecast: %s',weather), width * 0.15, height * 0.66)
end

def settings
  size 600, 360, FX2D
end
