module PlacelikesHelper
	# Construct the like sentence below the name of a Place
	def like_place_sentence(activity)
		friends_count = friends_like(activity)
		#likes_count = activity.direct_object.like_count
		likes_count = activity.siblings.joins(:activity_verb).where('activity_verbs.name' => "like").count
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

		return like_sentence.html_safe
	end

	# Return the number of friends who like this activity
	def friends_like(activity)
		# Total number of likes of the place, including me
		likes = activity.siblings.joins(:activity_verb).where('activity_verbs.name' => "like")
		friend_likes = likes.joins(:channel).joins('INNER JOIN contacts ON contacts.receiver_id = channels.author_id').
			where('contacts.sender_id' => current_subject).where('contacts.ties_count' => 1)

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

end
