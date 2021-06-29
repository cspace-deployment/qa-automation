module CoreHeldInTrustInfoForm

  include Logging
  include Page
  include CollectionSpacePages

  # SHOW / HIDE FORM

  # Hides the Held-in-Trust Information form
  def hide_hit_info_form
    logger.info 'Hiding the Held-in-Trust Info form'
    wait_for_element_and_click form_show_hide_button('Held-in-Trust Information')
  end

  # Un-hides the Held-in-Trust Information form
  def show_hit_info_form
    logger.info 'Showing the Held-in-Trust Info form'
    wait_for_element_and_click form_show_hide_button('Held-in-Trust Information')
  end

  # Hides the Culture Care and Handling form
  def hide_culture_care_and_handling_form
    logger.info 'Hiding the Culture Care and Handling form'
    wait_for_element_and_click form_show_hide_button('Culture Care and Handling')
  end

  # Un-hides the Culture Care and Handling form
  def show_culture_care_and_handling_form
    logger.info 'Showing the Culture Care and Handling form'
    wait_for_element_and_click form_show_hide_button('Culture Care and Handling')
  end

  # Hides the Correspondence form
  def hide_correspondence_form
    logger.info 'Hiding the Correspondence form'
    wait_for_element_and_click form_show_hide_button('Correspondence')
  end

  # Un-hides the Culture Care and Handling form
  def show_correspondence_form
    logger.info 'Showing the Correspondence form'
    wait_for_element_and_click form_show_hide_button('Correspondence')
  end

  # [HELD-IN-TRUST] INFORMATION form

  ##HELD-IN-TRUST NUMBER
  def hit_number_input; input_locator([], CoreHeldInTrustData::HIT_NUMBER.name) end
  def hit_number_options; input_options_locator([], CoreHeldInTrustData::HIT_NUMBER.name) end

  # Selects the next auto-generated Held-in-Trust number and inserts it into the test data set
  # @param [Hash] test_data
  # @return [Hash]
  def select_auto_hit_number(test_data)
    hide_notifications_bar
    hit_nbr = select_id_generator_option(hit_number_input, hit_number_options)
    logger.info "Selected auto-generated Held-in-Trust number '#{hit_nbr}'"
    test_data.merge!({CoreHeldInTrustData::HIT_NUMBER.name => hit_nbr})
  end

  # Enters a held-in-trust number
  # @param [String] num
  def enter_held_in_trust_number(test_data)
    logger.debug "Entering Held-in-Trust number #{test_data[CoreHeldInTrustData::HIT_NUMBER.name]}"
    wait_for_element_and_type(hit_number_input, test_data[CoreHeldInTrustData::HIT_NUMBER.name])
    hit_tab
  end

  # Verifies that the values of the Number field matches the corresponding fields in a given set of
  # test data.
  # @param [Hash] test_data
  def verify_held_in_trust_number(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::HIT_NUMBER.name], element_value(hit_number_input))
  end

  ## ENTRY DATE
  def entry_date_input; input_locator([],CoreHeldInTrustData::ENTRY_DATE.name) end

  def enter_entry_date(test_data)
    enter_simple_date(entry_date_input, test_data[CoreHeldInTrustData::ENTRY_DATE.name])
  end

  def verify_entry_date(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::ENTRY_DATE.name], element_value(entry_date_input))
  end

  ##DEPOSITORS
  def depositor_name_input(index); input_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_NAME.name) end
  def depositor_name_options(index); input_options_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_NAME.name) end
  def depositor_contact_input(index); input_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_CONTACT.name) end
  def depositor_contact_options(index); input_options_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_CONTACT.name) end
  def depositor_contact_type_input(index); input_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_CONTACT_TYPE.name) end
  def depositor_contact_type_options(index); input_options_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_CONTACT_TYPE.name) end
  def depositor_note_input(index); input_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name, index)], CoreHeldInTrustData::DEPOSITOR_NOTE.name) end

  def add_depositor_grp_btn; add_button_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name)]) end
  def move_depositor_grp_top_btn(index); move_top_button_locator([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name)], index) end

  def enter_depositors(test_data)
    depositors = test_data[CoreHeldInTrustData::DEPOSITOR_GRP.name] || [CoreHeldInTrustData.empty_depositor]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name)], depositors)

    depositors.each_with_index do |depositor, index|
      logger.info "Entering depositor data set at index #{index}: #{depositor}"
      enter_auto_complete(depositor_name_input(index), depositor_name_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_NAME.name], 'Local Persons')
      enter_auto_complete(depositor_contact_input(index), depositor_contact_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT.name], 'Local Persons')
      wait_for_options_and_select(depositor_contact_type_input(index), depositor_contact_type_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT_TYPE.name])
      wait_for_element_and_type(depositor_note_input(index), depositor[CoreHeldInTrustData::DEPOSITOR_NOTE.name])
    end
  end

  def verify_depositors(test_data)
    depositors = test_data[CoreHeldInTrustData::DEPOSITOR_GRP.name] || [CoreHeldInTrustData.empty_depositor]
    depositors.each_with_index do |depositor, index|
      verify_values_match(depositor[CoreHeldInTrustData::DEPOSITOR_NAME.name], element_value(depositor_name_input index))
      verify_values_match(depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT.name], element_value(depositor_contact_input index))
      verify_values_match(depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT_TYPE.name], element_value(depositor_contact_type_input index))
      verify_values_match(depositor[CoreHeldInTrustData::DEPOSITOR_NOTE.name], element_value(depositor_note_input index))
      end
  end

  # Adds a depositor term fieldset
  def add_depositor_grp
    wait_for_element_and_click add_depositor_grp_btn
  end

  # Moves the depositor term at a given index to the top of the terms
  # @param [Integer] index
  def move_depositor_grp_top(index)
    wait_for_element_and_click move_depositor_grp_top_btn(index)
  end

  ##AGREEMENT STATUS
  def agreement_status_input(index); input_locator([fieldset(CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name, index)], CoreHeldInTrustData::STATUS.name) end
  def agreement_status_options(index); input_options_locator([fieldset(CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name, index)], CoreHeldInTrustData::STATUS.name) end
  def agreement_status_date_input(index); input_locator([fieldset(CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name, index)], CoreHeldInTrustData::STATUS_DATE.name) end
  def agreement_status_note_input(index); input_locator([fieldset(CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name, index)], CoreHeldInTrustData::STATUS_NOTE.name) end

  def enter_agreement_statuses(test_data)
    agreements = test_data[CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name] || [CoreHeldInTrustData.empty_agreement_status]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name)], agreements)

    agreements.each_with_index do |agreement, index|
      logger.info "Entering agreement status data set at index #{index}: #{agreement}"
      wait_for_options_and_select(agreement_status_input(index), agreement_status_options(index), agreement[CoreHeldInTrustData::STATUS.name])
      enter_simple_date(agreement_status_date_input(index), agreement[CoreHeldInTrustData::STATUS_DATE.name])
      wait_for_element_and_type(agreement_status_note_input(index), agreement[CoreHeldInTrustData::STATUS_NOTE.name])
    end
  end

  def verify_agreement_statuses(test_data)
    agreements = test_data[CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name] || [CoreHeldInTrustData.empty_agreement_status]
    agreements.each_with_index do |agreement, index|
      verify_values_match(agreement[CoreHeldInTrustData::STATUS.name], element_value(agreement_status_input index))
      verify_values_match(agreement[CoreHeldInTrustData::STATUS_DATE.name], element_value(agreement_status_date_input index))
      verify_values_match(agreement[CoreHeldInTrustData::STATUS_NOTE.name], element_value(agreement_status_note_input index))
      end
  end

  ##AGREEMENT RENEWAL DATE
  def agreement_renewal_date_input(index); input_locator([fieldset(CoreHeldInTrustData::AGREEMENT_RENEWAL_DATES.name, index)]) end

  def enter_agreement_renewal_dates(test_data)
    renewals = test_data[CoreHeldInTrustData::AGREEMENT_RENEWAL_DATES.name] || [{CoreHeldInTrustData::AGREEMENT_RENEWAL_DATE.name => ''}]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::AGREEMENT_RENEWAL_DATES.name)], renewals)

    renewals.each_with_index do |renewal, index|
      logger.info "Entering agreement renewal date data set at index #{index}: #{renewal}"
      enter_simple_date(agreement_renewal_date_input(index), renewal[CoreHeldInTrustData::AGREEMENT_RENEWAL_DATE.name])
    end
  end

  def verify_agreement_renewal_dates(test_data)
    renewals = test_data[CoreHeldInTrustData::AGREEMENT_RENEWAL_DATES.name] || [{CoreHeldInTrustData::AGREEMENT_RENEWAL_DATE.name => ''}]
    renewals.each_with_index do |renewal, index|
      verify_values_match(renewal[CoreHeldInTrustData::AGREEMENT_RENEWAL_DATE.name], element_value(agreement_renewal_date_input index))
    end
  end

  ##ENTRY METHODS
  def entry_method_input(index); input_locator([fieldset(CoreHeldInTrustData::ENTRY_METHODS.name, index)]) end
  def entry_method_options(index); input_options_locator([fieldset(CoreHeldInTrustData::ENTRY_METHODS.name, index)]) end

  def select_entry_methods(test_data)
    entry_methods = test_data[CoreHeldInTrustData::ENTRY_METHODS.name] || [{CoreHeldInTrustData::ENTRY_METHOD.name => ''}]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::ENTRY_METHODS.name)], entry_methods)

    entry_methods.each_with_index do |entry_method, index|
      logger.info "Entering entry method data set at index #{index}: #{entry_method}"
      wait_for_options_and_select(entry_method_input(index), entry_method_options(index), entry_method[CoreHeldInTrustData::ENTRY_METHOD.name])
    end
  end

  def verify_entry_methods(test_data)
    entry_methods = test_data[CoreHeldInTrustData::ENTRY_METHODS.name] || [{CoreHeldInTrustData::ENTRY_METHOD.name => ''}]
    entry_methods.each_with_index do |entry_method, index|
      verify_values_match(entry_method[CoreHeldInTrustData::ENTRY_METHOD.name], element_value(entry_method_input index))
    end
  end

##ENTRY REASON
  def entry_reason_input; input_locator([], CoreHeldInTrustData::ENTRY_REASON.name) end
  def entry_reason_options; input_options_locator([], CoreHeldInTrustData::ENTRY_REASON.name) end

  def select_entry_reason(test_data)
    hide_notifications_bar
    logger.info "Entering entry reason data set"
    wait_for_options_and_select(entry_reason_input, entry_reason_options, test_data[CoreHeldInTrustData::ENTRY_REASON.name])
  end

  def verify_entry_reason(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::ENTRY_REASON.name], element_value(entry_reason_input))
  end

  ##RETURN DATE
  def return_date_input; input_locator([],CoreHeldInTrustData::RETURN_DATE.name) end

  def enter_return_date(test_data)
    logger.info "Entering return date"
    enter_simple_date(return_date_input, test_data[CoreHeldInTrustData::RETURN_DATE.name])
  end

  def verify_return_date(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::RETURN_DATE.name], element_value(return_date_input))
  end

  ##ENTRY NOTE
  def entry_note_input; text_area_locator([], CoreHeldInTrustData::ENTRY_NOTE.name) end

  def enter_entry_note(test_data)
    logger.info "Entering entry note #{test_data[CoreHeldInTrustData::ENTRY_NOTE.name]}"
    wait_for_element_and_type(entry_note_input, test_data[CoreHeldInTrustData::ENTRY_NOTE.name])
  end

  def verify_entry_note(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::ENTRY_NOTE.name], element_value(entry_note_input))
  end

  ##INTERNAL APPROVAL
  def int_approval_group_input(index); input_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_GROUP.name) end
  def int_approval_group_options(index); input_options_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_GROUP.name) end
  def int_approval_individual_input(index); input_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name) end
  def int_approval_individual_options(index); input_options_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name) end
  def int_approval_status_input(index); input_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_STATUS.name) end
  def int_approval_status_options(index); input_options_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_STATUS.name) end
  def int_approval_date_input(index);  input_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_DATE.name) end
  def int_approval_note_input(index); input_locator([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::INTERNAL_APPROVAL_NOTE.name) end

  def enter_internal_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_internal_approval]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name)], approvals)

    approvals.each_with_index do |approval, index|
      logger.info "Entering internal approval data set at index #{index}: #{approval}"
      wait_for_options_and_select(int_approval_group_input(index),int_approval_group_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_GROUP.name])
      enter_auto_complete(int_approval_individual_input(index), int_approval_individual_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name], 'Local Persons')
      wait_for_options_and_select(int_approval_status_input(index), int_approval_status_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_STATUS.name])
      enter_simple_date(int_approval_date_input(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_DATE.name])
      wait_for_element_and_type(int_approval_note_input(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_NOTE.name])
    end
  end

  def verify_internal_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_internal_approval]
    approvals.each_with_index do |approval, index|
      verify_values_match(approval[CoreHeldInTrustData::INTERNAL_APPROVAL_GROUP.name], element_value(int_approval_group_input index))
      verify_values_match(approval[CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name], element_value(int_approval_individual_input index))
      verify_values_match(approval[CoreHeldInTrustData::INTERNAL_APPROVAL_STATUS.name], element_value(int_approval_status_input index))
      verify_values_match(approval[CoreHeldInTrustData::INTERNAL_APPROVAL_DATE.name], element_value(int_approval_date_input index))
      verify_values_match(approval[CoreHeldInTrustData::INTERNAL_APPROVAL_NOTE.name], element_value(int_approval_note_input index))
    end
  end

  ##EXTERNAL APPROVAL
  def ext_approval_group_input(index); input_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_GROUP.name) end
  def ext_approval_group_options(index); input_options_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_GROUP.name) end
  def ext_approval_individual_input(index); input_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name) end
  def ext_approval_individual_options(index); input_options_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name) end
  def ext_approval_status_input(index); input_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_STATUS.name) end
  def ext_approval_status_options(index); input_options_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_STATUS.name) end
  def ext_approval_date_input(index);  input_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_DATE.name) end
  def ext_approval_note_input(index); input_locator([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name, index)], CoreHeldInTrustData::EXTERNAL_APPROVAL_NOTE.name) end

  def enter_external_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_external_approval]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name)], approvals)

    approvals.each_with_index do |approval, index|
      logger.info "Entering external approval data set at index #{index}: #{approval}"
      wait_for_options_and_select(ext_approval_group_input(index),ext_approval_group_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_GROUP.name])
      enter_auto_complete(ext_approval_individual_input(index), ext_approval_individual_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name], 'Local Persons')
      wait_for_options_and_select(ext_approval_status_input(index), ext_approval_status_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_STATUS.name])
      enter_simple_date(ext_approval_date_input(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_DATE.name])
      wait_for_element_and_type(ext_approval_note_input(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_NOTE.name])
    end
  end

  def verify_external_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_external_approval]
    approvals.each_with_index do |approval, index|
      verify_values_match(approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_GROUP.name], element_value(ext_approval_group_input index))
      verify_values_match(approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name], element_value(ext_approval_individual_input index))
      verify_values_match(approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_STATUS.name], element_value(ext_approval_status_input index))
      verify_values_match(approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_DATE.name], element_value(ext_approval_date_input index))
      verify_values_match(approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_NOTE.name], element_value(ext_approval_note_input index))
    end
  end

  # [CULTURE CARE AND HANDLING] form

  #HANDLING LIMITATIONS
  def handling_preferences_input; text_area_locator([], CoreHeldInTrustData::HANDLING_PREFERENCES.name) end

  #HANDLING PREFERENCES
  def enter_handling_preferences(test_data)
    logger.info "Entering handling preferences #{test_data[CoreHeldInTrustData::HANDLING_PREFERENCES.name]}"
    wait_for_element_and_type(handling_preferences_input, test_data[CoreHeldInTrustData::HANDLING_PREFERENCES.name])
  end

  def verify_handling_preferences(test_data)
    verify_values_match(test_data[CoreHeldInTrustData::HANDLING_PREFERENCES.name], element_value(handling_preferences_input))
  end

  #HANDLING LIMITATIONS
  def handling_type_input(index); input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_TYPE.name) end
  def handling_type_options(index); input_options_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_TYPE.name) end
  def handling_requestor_input(index); input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_REQUESTOR.name) end
  def handling_requestor_options(index); input_options_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_REQUESTOR.name) end
  def handling_level_input(index); input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_LEVEL.name) end
  def handling_level_options(index); input_options_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_LEVEL.name) end
  def handling_on_behalf_of_input(index); input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_BEHALF.name) end
  def handling_on_behalf_of_options(index); input_options_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_BEHALF.name) end
  def handling_detail_input(index);  input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_DETAIL.name) end
  def handling_date_input(index); input_locator([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name, index)], CoreHeldInTrustData::HANDLING_DATE.name) end

  def enter_handling_limitations(test_data)
    limitations = test_data[CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name] || [CoreHeldInTrustData.empty_handling_limitations]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name)], limitations)

    limitations.each_with_index do |limitation, index|
      logger.info "Entering handling limitations data set at index #{index}: #{limitation}"
      wait_for_options_and_select(handling_type_input(index),handling_type_options(index), limitation[CoreHeldInTrustData::HANDLING_TYPE.name])
      enter_auto_complete(handling_requestor_input(index), handling_requestor_options(index), limitation[CoreHeldInTrustData::HANDLING_REQUESTOR.name], 'Local Persons')
      wait_for_options_and_select(handling_level_input(index), handling_level_options(index), limitation[CoreHeldInTrustData::HANDLING_LEVEL.name])
      enter_auto_complete(handling_on_behalf_of_input(index), handling_on_behalf_of_options(index), limitation[CoreHeldInTrustData::HANDLING_BEHALF.name], 'Local Persons')
      wait_for_element_and_type(handling_detail_input(index), limitation[CoreHeldInTrustData::HANDLING_DETAIL.name])
      enter_simple_date(handling_date_input(index), limitation[CoreHeldInTrustData::HANDLING_DATE.name])
    end
  end

  def verify_handling_limitations(test_data)
    limitations = test_data[CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name] || [CoreHeldInTrustData.empty_handling_limitations]
    limitations.each_with_index do |limitation, index|
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_TYPE.name], element_value(handling_type_input index))
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_REQUESTOR.name], element_value(handling_requestor_input index))
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_LEVEL.name], element_value(handling_level_input index))
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_BEHALF.name], element_value(handling_on_behalf_of_input index))
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_DETAIL.name], element_value(handling_detail_input index))
      verify_values_match(limitation[CoreHeldInTrustData::HANDLING_DATE.name], element_value(handling_date_input index))
    end
  end

  # [CORRESPONDENCE] form

  ##EXTERNAL APPROVAL
  def correspondence_date_input(index);  input_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_DATE.name) end
  def correspondence_sender_input(index); input_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_SENDER.name) end
  def correspondence_sender_options(index); input_options_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_SENDER.name) end
  def correspondence_recipient_input(index); input_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name) end
  def correspondence_recipient_options(index); input_options_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name) end
  def correspondence_summary_input(index); input_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_SUMMARY.name) end
  def correspondence_reference_input(index); input_locator([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name, index)], CoreHeldInTrustData::CORRESPONDENCE_REF.name) end

  def enter_correspondences(test_data)
    correspondences = test_data[CoreHeldInTrustData::CORRESPONDENCE_GRP.name] || [CoreHeldInTrustData.empty_correspondence]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name)], correspondences)

    correspondences.each_with_index do |correspondence, index|
      logger.info "Entering correspondences data set at index #{index}: #{correspondence}"
      enter_simple_date(correspondence_date_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_DATE.name])
      enter_auto_complete(correspondence_sender_input(index), correspondence_sender_options(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_SENDER.name], 'Local Persons')
      enter_auto_complete(correspondence_recipient_input(index), correspondence_recipient_options(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name], 'Local Persons')
      wait_for_element_and_type(correspondence_summary_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_SUMMARY.name])
      wait_for_element_and_type(correspondence_reference_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_REF.name])
    end
  end

  def verify_correspondences(test_data)
    correspondences = test_data[CoreHeldInTrustData::CORRESPONDENCE_GRP.name] || [CoreHeldInTrustData.empty_correspondence]
    correspondences.each_with_index do |correspondence, index|
      verify_values_match(correspondence[CoreHeldInTrustData::CORRESPONDENCE_DATE.name], element_value(correspondence_date_input index))
      verify_values_match(correspondence[CoreHeldInTrustData::CORRESPONDENCE_SENDER.name], element_value(correspondence_sender_input index))
      verify_values_match(correspondence[CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name], element_value(correspondence_recipient_input index))
      verify_values_match(correspondence[CoreHeldInTrustData::CORRESPONDENCE_SUMMARY.name], element_value(correspondence_summary_input index))
      verify_values_match(correspondence[CoreHeldInTrustData::CORRESPONDENCE_REF.name], element_value(correspondence_reference_input index))
    end
  end

end
