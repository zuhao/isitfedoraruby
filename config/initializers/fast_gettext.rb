# Define the text domain
FastGettext.add_text_domain 'app', :path => 'locale', :type => :po
 

# set available locales
# (note: the first one is used as a fallback if you try to set an unavailable locale)
FastGettext.default_available_locales = ["en", "es"]
 
# Set the default textdomain
FastGettext.default_text_domain = 'app'
