module Localable
  extend ActiveSupport::Concern
  
  included do
    belongs_to :location

    accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

    def location_attributes=(attrs)
      if (loc = Location.from_attributes(attrs)).persisted?
        self.location = loc
      else
        errors.add :base, loc.errors.full_mesages.join(' ')
      end
    end
  end
end