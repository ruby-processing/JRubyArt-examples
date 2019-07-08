# Loading XML Data
# by Martin Prout
#
# This example demonstrates how to use loadXML
# to retrieve data from an XML document via a URL
Weather = Struct.new(:location, :weather, :celsius, :fahrenheit)


attr_reader :weather
NOAA = 'KMIA' # NOAA Weather Miami Airport
def setup
  sketch_title "NOAA's National Weather Service"
  #    font = create_font('Times Roman', 26)
  # font = create_font('Merriweather-Light.ttf', 28)
  #    text_font(font)
  # The URL for the XML document

  fo = "https://w1.weather.gov/xml/current_obs/display.php?stid=%s"
  url = format(fo, NOAA)
  # Load the XML document
  xml = loadXML(url)
  @weather = Weather.new(
    xml.get_child('location'),
    xml.get_child('weather'),
    xml.get_child('temp_f'),
    xml.get_child('temp_c')
  )
end

def draw
  background(255)
  fill(0)
  # Display all the stuff we want to display
  text(format("Location: %s", weather.location.get_content), width * 0.15, height * 0.36)
  text(format("Temperature: %s Fahrenheit", weather.fahrenheit.get_content), width * 0.15, height * 0.5)
  text(format("Temperature: %s Celsius", weather.celsius.get_content), width * 0.15, height * 0.66)
  text(format('Weather: %s', weather.weather.get_content), width * 0.15, height * 0.82)
  no_loop
end

def settings
  size 600, 360
end
