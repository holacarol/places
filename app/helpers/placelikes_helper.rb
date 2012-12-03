module PlacelikesHelper
	# Construct the like sentence below the name of a Place
	def like_place_sentence(place)
		friends_count = friends_like(place)
		#likes_count = activity.direct_object.like_count
		likes_count = place.post_activity.children.joins(:activity_verb).where('activity_verbs.name' => "like").count
		others_count = likes_count - friends_count
		like_sentence = ""

		if friends_count > 0
			like_sentence += t("activity.like_construction.like_friends",
					:friends => friends_count,
					:count => friends_count)
		end

		if friends_count > 0 && others_count > 0
			like_sentence += t("activity.like_construction.like_and")
			like_sentence += t("activity.like_construction.like_others",
					:people => others_count,
					:count => others_count)
		elsif friends_count = 0 && others_count > 0
			like_sentence += t("activity.like_construction.like_people",
					:people => others_count,
					:count => others_count)
		end

		if likes_count > 0
			like_sentence += t("activity.like_construction.like_final",
					:count => likes_count)
		end

#		if others_count == 1 && place.post_activity.liked_by?(current_subject)
#				like_sentence = t("activity.like_construction.like_you")
#		end

		return like_sentence.html_safe
	end


	def contacts_sentence(place)
		like_sentence = ""
		friends_count = friends_like(place)
		if friends_count > 0
			like_sentence += t("activity.like_construction.like_friends",
					:friends => friends_count,
					:count => friends_count)
		end

		return like_sentence.html_safe
	end

	

	def others_sentence(place)
		like_sentence = ""
		friends_count = friends_like(place)
		likes_count = place.post_activity.children.joins(:activity_verb).where('activity_verbs.name' => "like").count
		others_count = likes_count - friends_count
		
		if friends_count > 0 && others_count > 0
			like_sentence += t("activity.like_construction.like_and")
			like_sentence += t("activity.like_construction.like_others",
					:people => others_count,
					:count => others_count)
		elsif friends_count = 0 && others_count > 0
			like_sentence += t("activity.like_construction.like_people",
					:people => others_count,
					:count => others_count)
		end

		if likes_count > 0
			like_sentence += t("activity.like_construction.like_final",
					:count => likes_count)
		end

		return like_sentence.html_safe
	end



	# Return the number of friends who like this activity
	def friends_like(place)
		# Total number of likes of the place, including me
		likes = place.post_activity.children.joins(:activity_verb).where('activity_verbs.name' => "like")
		friend_likes = likes.joins(:channel).joins('INNER JOIN contacts ON contacts.receiver_id = channels.author_id').
			where('contacts.sender_id' => current_subject).where('contacts.ties_count > 0')

		friend_likes.count
	end



	def place_link_like(object)
	    params = place_link_like_params(object)
   		link_to params[0],params[1],params[2]
  	end

  	def place_link_like_params(object)
	    params = Array.new
	    if !user_signed_in?
	      params << image_tag("btn/nolike.png", :class => "menu_icon")+t('activity.verb.like.Place.like')
	      params << new_user_session_path
	      params << {:class => "verb_like",:id => "like_" + dom_id(object)}
	    else
	      if (object.liked_by?(current_subject))
	        params << image_tag("btn/like.png", :class => "menu_icon")+t('activity.verb.like.Place.unlike')
	        params << [object, :like]
	        params << {:class => "verb_like",:id => "like_" + dom_id(object),:method => :delete, :remote => true}
	      else
	        params << image_tag("btn/nolike.png", :class => "menu_icon")+t('activity.verb.like.Place.like')
	        params << [object, :like]
	        params << {:class => "verb_like",:id => "like_" + dom_id(object),:method => :post, :remote => true}
	      end
	    end
	end

	def place_star(object)
		params = place_star_params(object)
		link_to params[0], params[1], params [2]
	end

	 def place_star_params(object)
	    params = Array.new
	    if !user_signed_in?
	      params << image_tag("nolike-22x22.png", :class => "place_star")
	      params << new_user_session_path
	      params << {:class => "place_list_star",:id => "like_" + dom_id(object), :title => t('activity.verb.like.Place.like')}
	    else
	      if (object.liked_by?(current_subject))
	        params << image_tag("like-22x22.png", :class => "place_star")
	        params << [object, :like]
	        params << {:class => "place_list_star",:id => "like_" + dom_id(object),:method => :delete, :remote => true, :title => t('activity.verb.like.Place.unlike')}
	      else
	        params << image_tag("nolike-22x22.png", :class => "place_star")
	        params << [object, :like]
	        params << {:class => "place_list_star",:id => "like_" + dom_id(object),:method => :post, :remote => true, :title => t('activity.verb.like.Place.like')}
	      end
	    end
	end

end
