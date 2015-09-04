# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#DataDevice.create([{
#  date: DateTime.now,
#  packet_type: 85,
#  content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
#  processed: 1,
#  device_id: Device.first.id
#  }])
admins = Admin::Admin.create([{name: "Илья Евстрин", email: "evstrin@toplast.ru", password: "password", role: 0}, {name: "Alexander Andreev", email: "cinic.rus@gmail.com", password: "password", role: 0}])