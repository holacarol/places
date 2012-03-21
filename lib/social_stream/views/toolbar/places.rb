module SocialStream
  module ToolbarConfig
    module Places

      def profile_toolbar_items(subject = current_subject)
        items = super

        items << {
          :key => :placess,
          :name => image_tag("btn/btn_places.png",:class =>"menu_icon")+t("place.title"),
          :url => polymorphic_path([subject, Place.new]),
          :options => {:link => {:id => "places_menu"}}
        }
      end
      
      def home_toolbar_items
        items = super

        items << {
          :key => :places,
          :name => image_tag("btn/btn_places.png",:class =>"menu_icon")+t("place.title"),
          :url => polymorphic_path([current_subject, Place.new]),
          :options => {:link => {:id => "places_menu"}}
        }
      end
    end
  end
end
