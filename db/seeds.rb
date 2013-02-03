# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create! do |r|
  r.name       = 'Kaps Dewade'
  r.email      = 'kapildewade@gmail.com'
  r.password   = '$p@rt@n$428'
  r.role_id    =  1
  r.state = "active"
end

Role.create! do |r|
  r.name = "admin"
end

Role.create! do |r|
  r.name = "spartan"
end