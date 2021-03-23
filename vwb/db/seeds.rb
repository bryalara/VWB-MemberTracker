# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Edithomepage.create(name: 'home', description: 'This is the home description')
Edithomepage.create(name: 'about_us', description: 'This is the about us description')
Edithomepage.create(name: 'contact_us', description: 'This is the contact us description')
Edithomepage.create(name: 'officers', description: 'This is the officers description')
Edithomepage.create(name: 'officer_image_url', description: 'This is the the officer image URL description')
Edithomepage.create(name: 'landing_page_image_url', description: 'This is the landing page image url description')
Edithomepage.create(name: 'events_info', description: 'This is the events info description')

User.create(email: 'bryalara@tamu.edu', role: 1, firstName: 'Bryan', lastName: 'Lara', phoneNumber:'7138847570', classification:'Senior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'entao2000@gmail.com', role: 1, firstName: 'Yingtao', lastName: 'Jiang', phoneNumber:'9797399011', classification:'Senior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)
