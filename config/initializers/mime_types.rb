# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Rack::Mime::MIME_TYPES['.otf'] = 'font/opentype'
Rack::Mime::MIME_TYPES['.svg'] = 'image/svg+xml'
Rack::Mime::MIME_TYPES['.mp4'] = 'video/mp4'
Rack::Mime::MIME_TYPES['.webm'] = 'audio/webm'
