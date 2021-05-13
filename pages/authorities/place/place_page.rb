class PlacePage < AuthorityPage

  include Logging
  include Page
  include CollectionSpacePages
  include CorePlaceInfoForm
  include PAHMAPlaceInfoForm

  def enter_pahma_place_auth_data(data)
    enter_term_display_name
    enter_term_name
  end

  def create_new_pahma_place_record(data)
    enter_pahma_place_auth_data data
  end
end
