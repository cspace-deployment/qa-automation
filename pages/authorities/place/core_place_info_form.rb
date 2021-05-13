module CorePlaceInfoForm

  include Logging
  include Page
  include CollectionSpacePages

  def place_display_name_input(index); input_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)], CorePlaceData::TERM_DISPLAY_NAME.name) end

  def place_term_add_btn; add_button_locator [fieldset(CorePlaceData::PLACE_TERM_GRP.name)] end

  def place_term_display_name_input(index); term_display_name_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_name_input(index); term_name_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_qualifier_input(index); term_qualifier_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_status_input(index); term_status_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_status_options(index); term_status_options [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_type_input(index); term_type_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_type_options(index); term_type_options [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_flag_input(index); term_flag_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_flag_options(index); term_flag_options [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_language_input(index); term_language_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_language_options(index); term_language_options [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_pref_for_lang_input(index); term_pref_for_lang_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end

  def place_term_source_name_input(index); term_source_name_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_source_name_options(index); term_source_name_options [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_source_detail_input(index);term_source_detail_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_source_id_input(index); term_source_id_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end
  def place_term_source_note_input(index); term_source_note_input [fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)] end

  def place_term_current_status_input(index); input_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)], CorePlaceData::TERM_CURRENT_STATUS.name) end
  def place_term_current_status_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)], CorePlaceData::TERM_CURRENT_STATUS.name) end
  def place_term_abbreviation_input(index); input_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)], CorePlaceData::TERM_ABBREVIATION.name) end
  def place_term_note_input(index); input_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)], CorePlaceData::TERM_NOTE.name) end
  def place_term_date_input(index); structured_date_input_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name, index)]) end


  def add_term_grp_btn; add_button_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name)]) end
  def move_place_term_grp_top_btn(index); move_top_button_locator([fieldset(CorePlaceData::PLACE_TERM_GRP.name)], index) end

  def place_record_type_input(index); input_locator([fieldset(CorePlaceData::PLACE_TYPES.name, index)]) end
  def place_record_type_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_TYPES.name, index)]) end


  # Adds a term fieldset
  def add_term_grp
    wait_for_element_and_click add_term_grp_btn
  end

  # Moves the term at a given index to the top of the terms
  # @param [Integer] index
  def move_term_grp_top(index)
    wait_for_element_and_click move_place_term_grp_top_btn(index)
  end

  # Enters a display name in the place info term fieldset at a given index
  # @param [String] name
  # @param [Integer] index
  def enter_place_display_name(name, index)
    logger.debug "Entering display name '#{name}'"
    wait_for_element_and_type(place_display_name_input(index), name)
  end
  # Verifies that the display name in the place info term fieldset at a given index matches a given value
  # @param [String] name
  # @param [Integer] index
  def verify_display_name(name, index)
    wait_until(Config.short_wait, "Expected display name '#{name}', but got '#{element_value(place_display_name_input index)}'") do
      text_values_match?(name, element_value(place_display_name_input index))
    end
  end

  # Completes the various fields in a term fieldset per a given set of test data, adding or removing data.
  # @param [Hash] test_data
  def enter_terms(test_data)
    terms = test_data[CorePlaceData::PLACE_TERM_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_TERM_GRP.name)], terms)

    terms.each do |term|
      index = terms.index term
      logger.info "Entering place term data set at index #{index}: #{term}"
      enter_place_display_name(term[CorePlaceData::TERM_DISPLAY_NAME.name], index)
      wait_for_element_and_type(place_term_name_input(index), term[CorePlaceData::TERM_NAME.name])
      wait_for_element_and_type(place_term_qualifier_input(index), term[CorePlaceData::TERM_QUALIFIER.name])
      wait_for_options_and_select(place_term_status_input(index), place_term_status_options(index), term[CorePlaceData::TERM_STATUS.name])
      wait_for_options_and_select(place_term_type_input(index), place_term_type_options(index), term[CorePlaceData::TERM_TYPE.name])
      wait_for_options_and_select(place_term_flag_input(index), place_term_flag_options(index), term[CorePlaceData::TERM_FLAG.name])
      wait_for_options_and_select(place_term_current_status_input(index),place_term_current_status_options(index), term[CorePlaceData::TERM_CURRENT_STATUS.name])
      wait_for_options_and_select(place_term_language_input(index), place_term_language_options(index), term[CorePlaceData::TERM_LANGUAGE.name])
      wait_for_element_and_click place_term_pref_for_lang_input(index) if term[CorePlaceData::TERM_PREF_FOR_LANGUAGE.name]
      wait_for_element_and_type(place_term_abbreviation_input(index), term[CorePlaceData::TERM_ABBREVIATION.name])
      wait_for_element_and_type(place_term_note_input(index), term[CorePlaceData::TERM_NOTE.name])
      enter_simple_date(place_term_date_input(index), term[CorePlaceData::TERM_DATE.name])
      enter_auto_complete(place_term_source_name_input(index), place_term_source_name_options(index), term[CorePlaceData::TERM_SOURCE.name], 'Local Citations')
      wait_for_element_and_type(place_term_source_detail_input(index), term[CorePlaceData::TERM_SOURCE_DETAIL.name])
      wait_for_element_and_type(place_term_source_id_input(index), term[CorePlaceData::TERM_SOURCE_ID.name])
      wait_for_element_and_type(place_term_source_note_input(index), term[CorePlaceData::TERM_SOURCE_NOTE.name])
    end
  end

  # Verifies that the values of the various fields in a term fieldset match the corresponding fields in a given set of
  # test data. Returns an array of mismatches.
  # @param [Hash] test_data
  # @return [Array<String>]
  def verify_terms(test_data)
    terms = test_data[CorePlaceData::PLACE_TERM_GRP.name]
    errors = []
    terms.each do |term|
      index = terms.index term
      text_values_match?(term[CorePlaceData::TERM_DISPLAY_NAME.name], element_value(place_display_name_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_NAME.name], element_value(place_term_name_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_QUALIFIER.name], element_value(place_term_qualifier_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_STATUS.name], element_value(place_term_status_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_TYPE.name], element_value(place_term_type_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_FLAG.name], element_value(place_term_flag_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_CURRENT_STATUS.name], element_value(place_term_current_status_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_LANGUAGE.name], element_value(place_term_language_input index), errors)
      # TODO - element does not indicate its state # text_values_match?(term[CorePlaceData::TERM_PREF_FOR_LANGUAGE.name], element_value(org_term_pref_for_lang_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_ABBREVIATION.name], element_value(place_term_abbreviation_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_NOTE.name], element_value(place_term_note_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_DATE.name], element_value(place_term_date_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_SOURCE.name], element_value(place_term_source_name_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_SOURCE_DETAIL.name], element_value(place_term_source_detail_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_SOURCE_ID.name], element_value(place_term_source_id_input index), errors)
      text_values_match?(term[CorePlaceData::TERM_SOURCE_NOTE.name], element_value(place_term_source_note_input index), errors)
    end
    errors
  end

  # TYPES

  # Adds or remove place types per a given set of test data
  # @param [Hash] test_data
  def enter_types(test_data)
    types = test_data[CorePlaceData::PLACE_TYPES.name]
    types = [{CorePlaceData::PLACE_TYPE.name => ''}] unless types
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_TYPES.name)], types)

    types.each do |type|
      index = types.index type
      logger.info "Entering place type data set at index #{index}: #{type}"
      wait_for_options_and_select(place_record_type_input(index), place_record_type_options(index), type[CorePlaceData::PLACE_TYPE.name])
    end
  end

  # Verifies that the values of the various fields in a term fieldset match the corresponding fields in a given set of
  # test data. Returns an array of mismatches.
  # @param [Hash] test_data
  # @return [Array<String>]
  def verify_types(test_data)
    types = test_data[CorePlaceData::PLACE_TYPES.name]
    errors = []
    types.each do |type|
      index = types.index type
      text_values_match?(type[CorePlaceData::PLACE_TYPE.name], element_value(place_record_type_input index), errors)
    end
    errors
  end

  # TYPES

  def place_ownership_owner_input(index); input_locator([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name, index)], CorePlaceData::OWNERSHIP_OWNER.name) end
  def place_ownership_owner_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name, index)], CorePlaceData::OWNERSHIP_OWNER.name) end
  def place_ownership_note_input(index); input_locator([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name, index)], CorePlaceData::OWNERSHIP_NOTE.name) end
  def place_ownership_start_date_input(index); structured_date_input_locator([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name, index)]) end
  def place_ownership_end_date_input(index); {:xpath => "(#{fieldset_xpath([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name, index)])}//div[contains(@class, 'StructuredDateInput')]/input)[2]"} end

  # Adds or remove ownership data per a given set of test data
  # @param [Hash] test_data
  def enter_ownerships(test_data)
    ownerships = test_data[CorePlaceData::PLACE_OWNERSHIP_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_OWNERSHIP_GRP.name)], ownerships)

    ownerships.each do |ownership|
      index = ownerships.index ownership
      logger.info "Entering place ownership data set at index #{index}: #{ownership}"
      enter_auto_complete(place_ownership_owner_input(index), place_ownership_owner_options(index), ownership[CorePlaceData::OWNERSHIP_OWNER.name], 'PAHMA Persons')
      enter_simple_date(place_ownership_start_date_input(index), ownership[CorePlaceData::OWNERSHIP_START_DATE.name])
      enter_simple_date(place_ownership_end_date_input(index), ownership[CorePlaceData::OWNERSHIP_END_DATE.name])
      wait_for_element_and_type(place_ownership_note_input(index), ownership[CorePlaceData::OWNERSHIP_NOTE.name])
    end
  end

  # Verifies that the values of the various fields in a term fieldset match the corresponding fields in a given set of
  # test data. Returns an array of mismatches.
  # @param [Hash] test_data
  # @return [Array<String>]
  def verify_ownerships(test_data)
    ownerships = test_data[CorePlaceData::PLACE_OWNERSHIP_GRP.name]
    errors = []
    ownerships.each do |ownership|
      index = ownerships.index ownership
      text_values_match?(ownership[CorePlaceData::OWNERSHIP_OWNER.name], element_value(place_ownership_owner_input index), errors)
      text_values_match?(ownership[CorePlaceData::OWNERSHIP_START_DATE.name], element_value(place_ownership_start_date_input index), errors)
      text_values_match?(ownership[CorePlaceData::OWNERSHIP_END_DATE.name], element_value(place_ownership_end_date_input index), errors)
      text_values_match?(ownership[CorePlaceData::OWNERSHIP_NOTE.name], element_value(place_ownership_note_input index), errors)
    end
    errors
  end

  #PLACE NOTE

  def place_note_input(index); text_area_locator([fieldset(CorePlaceData::PLACE_NOTE_GRP.name, index)], CorePlaceData::PLACE_NOTE.name) end
  def place_note_author_input(index); input_locator([fieldset(CorePlaceData::PLACE_NOTE_GRP.name, index)], CorePlaceData::PLACE_NOTE_AUTHOR.name) end
  def place_note_author_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_NOTE_GRP.name, index)], CorePlaceData::PLACE_NOTE_AUTHOR.name) end
  def place_note_date_input(index); {:xpath => "#{fieldset_xpath([fieldset(CorePlaceData::PLACE_NOTE_GRP.name, index)])}//div[contains(@class, 'DateInput')]/input"} end

  def enter_place_notes(test_data)
    place_notes = test_data[CorePlaceData::PLACE_NOTE_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_NOTE_GRP.name)], place_notes)

    place_notes.each do |place_note|
      index = place_notes.index place_note
      logger.info "Entering place ownership data set at index #{index}: #{place_note}"
      wait_for_element_and_type(place_note_input(index), place_note[CorePlaceData::PLACE_NOTE.name])
      enter_auto_complete(place_note_author_input(index), place_note_author_options(index), place_note[CorePlaceData::PLACE_NOTE_AUTHOR.name], 'PAHMA Persons')
      enter_simple_date(place_note_date_input(index), place_note[CorePlaceData::PLACE_NOTE_DATE.name])
    end
  end

  def verify_place_notes(test_data)
    place_notes = test_data[CorePlaceData::PLACE_NOTE_GRP.name]
    errors = []
    place_notes.each do |place_note|
      index = place_notes.index place_note
      text_values_match?(place_note[CorePlaceData::PLACE_NOTE.name], element_value(place_note_input index), errors)
      text_values_match?(place_note[CorePlaceData::PLACE_NOTE_AUTHOR.name], element_value(place_note_author_input index), errors)
      text_values_match?(place_note[CorePlaceData::PLACE_NOTE_DATE.name], element_value(place_note_date_input index), errors)
    end
    errors
  end

  # REFERENCES

  def place_reference_input(index); input_locator([fieldset(CorePlaceData::PLACE_REFERENCE_GRP.name, index)], CorePlaceData::REFERENCE.name) end
  def place_reference_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_REFERENCE_GRP.name, index)], CorePlaceData::REFERENCE.name) end
  def place_reference_note_input(index); input_locator([fieldset(CorePlaceData::PLACE_REFERENCE_GRP.name, index)], CorePlaceData::REFERENCE_NOTE.name) end

  def enter_references(test_data)
    references = test_data[CorePlaceData::PLACE_REFERENCE_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_REFERENCE_GRP.name)], references)

    references.each do |reference|
      index = references.index reference
      logger.info "Entering place reference data set at index #{index}: #{reference}"
      enter_auto_complete(place_reference_input(index), place_reference_options(index), reference[CorePlaceData::REFERENCE.name], 'Local Citations')
      wait_for_element_and_type(place_reference_note_input(index), reference[CorePlaceData::REFERENCE_NOTE.name])
    end
  end

  def verify_references(test_data)
    references = test_data[CorePlaceData::PLACE_REFERENCE_GRP.name]
    errors = []
    references.each do |reference|
      index = references.index reference
      text_values_match?(reference[CorePlaceData::REFERENCE.name], element_value(place_reference_input index), errors)
      text_values_match?(reference[CorePlaceData::REFERENCE_NOTE.name], element_value(place_reference_note_input index), errors)
    end
    errors
  end

  # ASSOCIATED PERSON/ORGANIZATION

  def place_associated_name_input(index); input_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name, index)], CorePlaceData::ASSOCIATED_NAME.name) end
  def place_associated_name_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name, index)], CorePlaceData::ASSOCIATED_NAME.name) end
  def place_associated_association_input(index); input_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name, index)], CorePlaceData::ASSOCIATED_ASSOCIATION.name) end
  def place_associated_association_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name, index)], CorePlaceData::ASSOCIATED_ASSOCIATION.name) end
  def place_associated_date_input(index); structured_date_input_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name,index)]) end
  def place_associated_note_input(index);  input_locator([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name, index)], CorePlaceData::ASSOCIATED_NOTE.name) end

  def enter_associations(test_data)
    associations = test_data[CorePlaceData::PLACE_ASSOCIATED_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_ASSOCIATED_GRP.name)], associations)

    associations.each do |association|
      index = associations.index association
      logger.info "Entering place associations data set at index #{index}: #{association}"
      enter_auto_complete(place_associated_name_input(index), place_associated_name_options(index), association[CorePlaceData::ASSOCIATED_NAME.name], 'PAHMA Persons')
      wait_for_options_and_select(place_associated_association_input(index), place_associated_association_options(index), association[CorePlaceData::ASSOCIATED_ASSOCIATION.name])
      enter_simple_date(place_associated_date_input(index), association[CorePlaceData::ASSOCIATED_DATE.name])
      wait_for_element_and_type(place_associated_note_input(index), association[CorePlaceData::ASSOCIATED_NOTE.name])
    end
  end

  def verify_associations(test_data)
    associations = test_data[CorePlaceData::PLACE_ASSOCIATED_GRP.name]
    errors = []
    associations.each do |association|
      index = associations.index association
      text_values_match?(association[CorePlaceData::ASSOCIATED_NAME.name], element_value(place_associated_name_input index), errors)
      text_values_match?(association[CorePlaceData::ASSOCIATED_ASSOCIATION.name], element_value(place_associated_association_input index), errors)
      text_values_match?(association[CorePlaceData::ASSOCIATED_DATE.name], element_value(place_associated_date_input index), errors)
      text_values_match?(association[CorePlaceData::ASSOCIATED_NOTE.name], element_value(place_associated_note_input index), errors)
    end
    errors
  end

  # ADDRESSES

  def place_address_line_1_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_LINE_1.name) end
  def place_address_line_2_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_LINE_2.name) end
  def place_address_municipality_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_MUNICIPALITY.name) end
  def place_address_municipality_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_MUNICIPALITY.name) end

  def place_address_state_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_STATE.name) end
  def place_address_state_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_STATE.name) end

  def place_address_country_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_COUNTRY.name) end
  def place_address_country_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_COUNTRY.name) end

  def place_address_type_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_TYPE.name) end
  def place_address_type_options(index); input_options_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_TYPE.name) end
  def place_address_postal_code_input(index); input_locator([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name, index)], CorePlaceData::ADDRESS_POSTAL_CODE.name) end

  def enter_addresses(test_data)
    addresses = test_data[CorePlaceData::PLACE_ADDRESS_GRP.name]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CorePlaceData::PLACE_ADDRESS_GRP.name)], addresses)

    addresses.each do |address|
      index = addresses.index address
      logger.info "Entering place address data set at index #{index}: #{address}"
        wait_for_element_and_type(place_address_line_1_input(index), address[CorePlaceData::ADDRESS_LINE_1.name])
        enter_auto_complete(place_address_state_input(index), place_address_state_options(index), address[CorePlaceData::ADDRESS_STATE.name], 'PAHMA Places')
        wait_for_element_and_type(place_address_postal_code_input(index), address[CorePlaceData::ADDRESS_POSTAL_CODE.name])
        wait_for_element_and_type(place_address_line_2_input(index), address[CorePlaceData::ADDRESS_LINE_2.name])
        enter_auto_complete(place_address_country_input(index), place_address_country_options(index), address[CorePlaceData::ADDRESS_COUNTRY.name], 'PAHMA Places')
        enter_auto_complete(place_address_municipality_input(index), place_address_municipality_options(index), address[CorePlaceData::ADDRESS_MUNICIPALITY.name], 'PAHMA Places')
        wait_for_options_and_select(place_address_type_input(index), place_address_type_options(index), address[CorePlaceData::ADDRESS_TYPE.name])
    end
  end

  def verify_addresses(test_data)
    addresses = test_data[CorePlaceData::PLACE_ADDRESS_GRP.name]
    errors = []
    addresses.each do |address|
      index = addresses.index address
      text_values_match?(address[CorePlaceData::ADDRESS_LINE_1.name], element_value(place_address_line_1_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_STATE.name], element_value(place_address_state_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_POSTAL_CODE.name], element_value(place_address_postal_code_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_LINE_2.name], element_value(place_address_line_2_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_COUNTRY.name], element_value(place_address_country_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_MUNICIPALITY.name], element_value(place_address_municipality_input index), errors)
      text_values_match?(address[CorePlaceData::ADDRESS_TYPE.name], element_value(place_address_type_input index), errors)
    end
    errors
  end

end
