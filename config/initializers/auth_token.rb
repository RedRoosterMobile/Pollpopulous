# hacky auth
digest = Digest::SHA1.hexdigest([Time.now, rand].join)

Rails.application.config.auth_code = digest

puts 'Auth-Code:'
puts digest