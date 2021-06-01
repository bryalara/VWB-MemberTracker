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
User.create(email: 'sainikhilnaru@gmail.com', role: 1, firstName: 'Sai', lastName: 'Naru', phoneNumber:'1231231234', classification:'Junior', tShirtSize:'L', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'mefsaenz@gmail.com', role: 1, firstName: 'Elisa', lastName: 'Flores', phoneNumber:'1231231234', classification:'Junior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'soto_samantha@tamu.edu', role: 1, firstName: 'Samantha', lastName: 'Soto', phoneNumber:'1231231234', classification:'Senior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'manseerat@tamu.edu', role: 1, firstName: 'Manseerat', lastName: 'Batra', phoneNumber:'1231231234', classification:'Senior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'paulinewade@tamu.edu', role: 1, firstName: 'Pauline', lastName: 'Wade', phoneNumber:'1231231234', classification:'Senior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'shayle@tamu.edu', role: 1, firstName: 'Yihao', lastName: 'Xie', phoneNumber:'1231231234', classification:'Senior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)
User.create(email: 'keerthana96@tamu.edu', role: 1, firstName: 'Keerthana', lastName: 'Reddy Nerella', phoneNumber:'1231231234', classification:'Senior', tShirtSize:'S', optInEmail: true, participationPoints: 0, approved: true)

# Edithomepage.create(name: 'home', description: 'This is the home description')
Edithomepage.create(name: 'About Us', description: 'Vets Without Borders is a student led organization centered around veterinary medicine, with a focus on international veterinary medicine',
                                        h1: 'Who Can Join', 
                                        d1: 'Anyone who is passionate about animals and interested in veterinary medicine!',
                                        h2: 'Why You Should Join',
                                        d2: 'Our organization offers many opportunities for students who wish to become vets. Wehost weekly volunteer events where you will gain experience with a variety of animals locally. We also have speakers at our meetings that you won\t want to miss! Additionaly, we host several trips during the summer where you are able to gain experience with animals abroad.')

Edithomepage.create(name: 'Service', description: 'Vets Without Borders offers 1-2 volunteer opportunities per week where you can gain animal experience locally')

Edithomepage.create(name: 'Volunteering', description: 'Vets Without Borders offers 1-2 volunteer opportunities per week where you can gain animal experience locally')

Edithomepage.create(name: 'Banner', description: 'Here is where you can upload an image for the banner on the landing page')

Officer.create( name: "name1 ",email: "name1@gmail.com ",  description: "description 1 ")
Officer.create( name: "name2 ",email: "name2@gmail.com ", description: "description 2 ")
Officer.create( name: "name3 ",email: "name3@gmail.com ",  description: "description 3 ")
Officer.create( name: "name4 ",email: "name4@gmail.com ",  description: "description 4 ")

# if @officer.image.attached?
#     @officer.image.attach(io: File.open('app/assets/images/deafultOfficerImage.png'), filename: 'defaultOfficerImage.png')
    
#   end