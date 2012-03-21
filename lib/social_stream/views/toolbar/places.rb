module SocialStream
  module Views
    module Toolbar
      module Places
        def toolbar_menu_items type, options = {}
          super.tap do |items|
            case type
            when :home
              items << {
                :key => :places,
                :html => link_to(image_tag("btn/btn_places.png",:class =>"menu_icon")+t("place.title"),
                                 [current_subject, Place.new],
                                 :id => "toolbar_menu-places")
              }
            when :profile
              items << {
                :key => :places,
                :html => link_to(image_tag("btn/btn_places.png",:class =>"menu_icon")+t("place.title"),
                                 [options[:subject], Place.new],
                                 :id => "toolbar_menu-places")
              }
            end
          end
        end
      end
    end
  end
end

