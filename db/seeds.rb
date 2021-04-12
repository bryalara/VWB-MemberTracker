# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'bryalara@tamu.edu', role: 1, firstName: 'Bryan', lastName: 'Lara', phoneNumber:'7138847570', classification:'Senior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'entao2000@gmail.com', role: 1, firstName: 'Yingtao', lastName: 'Jiang', phoneNumber:'9797399011', classification:'Senior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'phand972@gmail.com', role: 1, firstName: 'Daniel', lastName: 'Phan', phoneNumber:'7133631944', classification:'Junior', tShirtSize:'XXL', optInEmail: true, participationPoints: 0, approved: true)


# Edithomepage.create(name: 'home', description: 'This is the home description')
Edithomepage.create(name: 'about_us', description: 'This is the about us description')
Edithomepage.create(name: 'service', description: 'This is the service description')
Edithomepage.create(name: 'landing_page_image')

Officer.create( name: "name1 ",email: "name1@gmail.com ",  description: "description 1 ")
Officer.create( name: "name2 ",email: "name2@gmail.com ", description: "description 2 ")
Officer.create( name: "name3 ",email: "name3@gmail.com ",  description: "description 3 ")
Officer.create( name: "name4 ",email: "name4@gmail.com ",  description: "description 4 ")


# if @officer.image.attached?
#     @officer.image.attach(io: File.open('app/assets/images/deafultOfficerImage.png'), filename: 'defaultOfficerImage.png')
    
#   end