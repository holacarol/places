# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
 user.name                  "Carol"
 user.email                 "carol@places.com"
 user.password              "demonstration"
 user.password_confirmation "demonstration"
end
