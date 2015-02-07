Warbler::Config.new do |config|
  config.webxml.rails.env = 'development'

  # Application directories to be included in the webapp.
  config.dirs = ['config',  'bin', 'public', 'app','lib']
end