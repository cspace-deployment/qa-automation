module CoreExhibitionInfoForm

  include Logging
  include Page
  include CollectionSpacePages

  def exhibition_num_input_locator; input_locator([], CoreExhibitionData::EXHIBITION_NUM.name) end
  def exhibition_num_options_locator; input_options_locator([], CoreExhibitionData::EXHIBITION_NUM.name) end

  # Enters an exhibition number
  # @param [String] num
  def enter_exhibition_num(data)
    logger.debug "Entering exhibition number #{data[CoreExhibitionData::EXHIBITION_NUM.name]}"
    wait_for_options_and_type(exhibition_num_input_locator, exhibition_num_options_locator, data[CoreExhibitionData::EXHIBITION_NUM.name])
  end

  def sponsor_input_locator(index); input_locator([fieldset(CoreExhibitionData::SPONSOR.name, index)]) end
  def sponsor_options_locator(index); input_options_locator([fieldset(CoreExhibitionData::SPONSOR.name, index)]) end

  # Selects an existing sponsor from the sponsor input
  # @param [String] name
  # @param [Integer] index
  def select_sponsor(name, index)
    enter_auto_complete(sponsor_input_locator(index), sponsor_options_locator(index), name)
  end

  def plan_note_input_locator; text_area_locator([], CoreExhibitionData::PLAN_NOTE.name) end

  # Enters planning note
  # @param [Hash] data_set
  def enter_planning_note(data_set)
    planning_note = data_set[CoreExhibitionData::PLAN_NOTE.name]
    logger.debug "Entering conservation note '#{planning_note}'"
    wait_for_element_and_type(plan_note_input_locator, planning_note) if planning_note
  end

  def venue_name_input_locator(index); input_locator([fieldset(CoreExhibitionData::VENUE_GROUP.name, index)], CoreExhibitionData::VENUE_NAME.name) end
  def venue_name_options_locator(index); input_options_locator([fieldset(CoreExhibitionData::VENUE_GROUP.name, index)], CoreExhibitionData::VENUE_NAME.name) end

  # Enters venue information
  #@param [Hash] data_set
  def enter_venue_info(data_set, location_group = nil)
    venues = data_set[CoreExhibitionData::VENUE_GROUP.name]
    prep_fieldsets_for_test_data([fieldset(CoreExhibitionData::VENUE_GROUP.name)], venues)
    venues && venues.each_with_index do |venue, index|
      logger.debug "Entering venue #{venue[CoreExhibitionData::VENUE_NAME]} info at index #{index}"
      enter_auto_complete(venue_name_input_locator(index), venue_name_options_locator(index), venue[CoreExhibitionData::VENUE_NAME.name], location_group)
      ##TODO: Venue Opening date
      ##TODO: Venue Closing date
      ##TODO: Venue Attendance
      ##TODO: Venue URL
    end
  end

  # Enters venue name
  # @param [String] name
  # @param [Integer] index
  def enter_venue_name(name, index)
    enter_auto_complete(venue_name_input_locator(index), venue_name_options_locator(index), name)
  end

end
