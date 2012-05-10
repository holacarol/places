# By using the symbol ':user', we get Factory Girl to simulate the User model.
#Factory.define :user do |user|
# user.name                  "Carol"
# user.email                 "carol@places.com"
# user.password              "demonstration"
# user.password_confirmation "demonstration"
#end

Factory.define :address do |a|
  a.streetAddress	"12, Test St."
  a.locality		"Testcity"
  a.region		"Testregion"
  a.postalCode		"12345"
  a.country		"Testland"
end

Factory.define :place do |p|
  p.sequence(:title)	{ |n| "Test place #{ n }" }
  p.latitude    "40.4166909"
  p.longitude   "-3.7003454"
  p.association		:address
  p.url			"http://www.testplace.com"
  p.author_id 		{ Factory(:friend).receiver.id }
  p.owner_id 		{ |q| q.author_id }
  p.user_author_id 	{ |q| q.author_id }
  p.relation_ids 	{ |q| Array(Relation::Public.instance.id) }
end
