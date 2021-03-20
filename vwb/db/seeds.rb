# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Edithomepage.create(name: 'Title0', description: 'This is the title0')
Edithomepage.create(name: 'Title1', description: 'This is the title1')
Edithomepage.create(name: 'Title2', description: 'This is the title2')

user = User.new(email: 'bryalara@tamu.edu', role: 1, firstName: 'Bryan', lastName: 'Lara', phoneNumber:'7138847570', classification:'Senior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)

