class User < ApplicationRecord
    require 'csv'
    require 'activerecord-import/base'
    require 'activerecord-import/active_record/adapters/postgresql_adapter'
    
    enum role_types: [:Member, :Admin]

    def self.my_import(file)
        users=[]
        wmsg=[]
        begin
            CSV.foreach(file.path, headers: true) do |row|
                puts("READING FROM CSV..........................................")
                puts(row.to_h[1])
                users << User.new(row.to_h)
            end
        rescue StandardError => e
            puts("Error reading specified csv file, maybe no csv selected")
            wmsg.append("Error reading specified csv file")
        end
        users.each do |user|
            puts(user.firstName+' '+user.lastName)
            begin
                unless(wmsg.first=="Error reading specified csv file")
                    if(user.save)
                        wmsg.append("New user: "+user.firstName+" "+user.lastName+" created")
                        puts("New user: "+user.firstName+" "+user.lastName+" created")
                    else
                        puts("Error with user: "+user.firstName+" "+user.lastName+", might already exist")
                        wmsg.append("Error with user: "+user.firstName+" "+user.lastName+", might already exist")
                        if @user.valid?
                            wmsg.append("New user: "+user.firstName+" "+user.lastName+" created")
                        else
                            wmsg.append(user.errors.full_messages[0])
                            puts (user.errors.full_messages[0])
                        end
                    end
                end
            rescue StandardError => e
                puts(e)
            end
        end
        # begin
        #     unless(wmsg.length>0)
        #         puts("IMPORTING FROM CSV..........................................")
        #         User.import users, recursive: true,validate: true, ignore: true
        #     end
        # rescue StandardError => e
        #     puts(e)
        # end
        wmsg
        
    end

    def get_total_points(user)
        totalPoints = user.participationPoints  # initial points user has
        user.events.each do |event|
            totalPoints += event.points         # points from events attended
        end
        user.point_events.each do |pEvent|
            totalPoints += pEvent.points        # points from points attended
        end
        totalPoints
    end

    def self.to_csv
        attributes = %w{email}
    
        CSV.generate(headers: true) do |csv|
          csv << attributes
    
          all.each do |user|
            if(user.optInEmail==true)
                csv << attributes.map{ |attr| user.send(attr) }
            end
          end
        end
    end

    validates :email, presence: true, uniqueness: true
    validates :role, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0, :less_than =>2}
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :phoneNumber, presence: true, length: {is: 10}
    validates :classification, presence: true
    validates :tShirtSize, presence: true
    validates_inclusion_of :optInEmail, in: [true, false]
    validates_inclusion_of :approved, in: [true, false]
    validates :participationPoints, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}

    has_and_belongs_to_many :events, -> { distinct }
    has_and_belongs_to_many :point_events, -> { distinct }
end
