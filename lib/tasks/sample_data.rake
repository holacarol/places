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
end
