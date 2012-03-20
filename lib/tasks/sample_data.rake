namespace :db do
  desc "Fill database with sample data"
  task :fakedata => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_friends
    sleep(10)
    make_places
  end
end

  def make_users
    puts 'User population'
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

  def make_friends
    puts 'Friends population'
    ties_start = Time.now
    
    @available_actors = Actor.all(:limit => 2)
    @available_actors.each do |a|
      actors = @available_actors.dup - Array(a)
      break if actors.size == 0
      actor = Actor.first
      unless a == actor
        puts a.name + " connecting with " + actor.name
        contact = a.contact_to!(actor)
	contact.user_author = a.user_author if a.subject_type != "User"
	contact.relation_ids = Array(Forgery::Extensions::Array.new(a.relation_customs).random.id)

	contact = actor.contact_to!(a)
	contact.user_author = actor.user_author if actor.subject_type != "User"
	contact.relation_ids = Array(Forgery::Extensions::Array.new(actor.relation_customs).random.id)
      end
    end

    ties_end = Time.now
    puts '	-> ' + (ties_end - ties_start).round(4).to_s + 's'  

  end  
    

  def make_places
    puts 'Place population'
    places_start = Time.now

    2.times do |n|
      Actor.all(:limit => 2).each do |a|
        address = {
		:streetAddress	=> Faker::Address.street_address(include_secondary = false),
		:locality 	=> Faker::Address.city,
		:region		=> Faker::Address.state,
		:postalCode	=> Faker::Address.zip_code,
		:country	=> Faker::Address.country}
        Place.create 	:title 			=> Faker::Company.name,
			:position 		=> "+#{n+48.8577}+#{n+2.295}",
			:address_attributes 	=> address,
			:url			=> Faker::Internet.domain_name,
			:author_id		=> a.id,
			:owner_id		=> a.id,
			:user_author_id		=> a.id,
			:_relation_ids		=> Array(Relation::Public.instance.id)
      end
    end

    places_end = Time.now
    puts '	-> ' + (places_end - places_start).round(4).to_s + 's'
  end


