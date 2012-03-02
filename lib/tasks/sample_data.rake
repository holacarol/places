namespace :db do
  desc "Fill database with sample data"
  task :fakedata => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Alice",
               :email => "alice@places.com",
               :password => "demonstration",
               :password_confirmation => "demonstration")
    User.create!(:name => "Carol",
	       :email => "carol@places.com",
               :password => "demonstration",
               :password_confirmation => "demonstration")
    8.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@places.com"
      password  = "demonstration"
      User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
    end
  end

  desc "Fill user with places"
  task :places => :environment do
    puts 'Place population'
    places_start = Time.now

    2.times do |n|
      Actor.all(:limit => 2).each do |a|
        Place.create 	:title 		=> Faker::Company.name,
			:position 	=> "+#{n+48.8577}+#{n+2.295}",
			:url		=> Faker::Internet.domain_name,
			:author_id	=> a.id,
			:owner_id	=> a.id,
			:user_author_id	=> a.id
      end
    end

    places_end = Time.now
    puts '	-> ' + (places_end - places_start).round(4).to_s + 's'
  end

end
