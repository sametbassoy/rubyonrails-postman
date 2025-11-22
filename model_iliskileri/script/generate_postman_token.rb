# frozen_string_literal: true

user = User.find_or_create_by!(email: 'postman@example.com') do |u|
  u.name = 'Postman Bot'
  u.password = 'Secret123'
  u.password_confirmation = 'Secret123'
end

puts JsonWebToken.encode(sub: user.id)
