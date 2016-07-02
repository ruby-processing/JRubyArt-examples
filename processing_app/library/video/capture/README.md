### README ###

You may know the video capture capabilities of your device (720p, 1280×720 px _or if you are loaded_ 1080p 1920x1080 px), or you could use some clever tool like v4l2-ctl (install v4l-utils linux), to find the right size settings for 'video capture' with your setup, there are probably be any number of tools for Windows / Mac that can do the same thing.

Failing that you could use some old-school safe settings like width 640, height 480 initially (for crappy old 480p cameras).

You should the run the `test_capture.rb` sketch (with width / height adjusted to match your equipment) and that will output the available capture settings (frame-rate etc).

