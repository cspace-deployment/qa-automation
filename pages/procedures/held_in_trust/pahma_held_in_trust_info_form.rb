module PAHMAHeldInTrustInfoForm

  include Logging
  include Page
  include CollectionSpacePages

  #AGREEMENT DATE
  def pahma_agreement_date_input; disabled_input_locator_by_label("Agreement date") end

  ##DEPOSITORS
  def enter_pahma_depositors(test_data)
    depositors = test_data[CoreHeldInTrustData::DEPOSITOR_GRP.name] || [CoreHeldInTrustData.empty_depositor]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::DEPOSITOR_GRP.name)], depositors)

    depositors.each do |depositor|
      index = depositors.index depositor
      logger.info "Entering depositor data set at index #{index}: #{depositor}"
      enter_auto_complete(depositor_name_input(index), depositor_name_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_NAME.name], 'PAHMA Persons')
      enter_auto_complete(depositor_contact_input(index), depositor_contact_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT.name], 'PAHMA Persons')
      wait_for_options_and_select(depositor_contact_type_input(index), depositor_contact_type_options(index), depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT_TYPE.name])
      wait_for_element_and_type(depositor_note_input(index), depositor[CoreHeldInTrustData::DEPOSITOR_NOTE.name])
    end
  end

  ##AGREEMENT NOTE
  def agreement_note_input; text_area_locator([], PAHMAHeldInTrustData::AGREEMENT_NOTE.name) end

  def enter_agreement_note(test_data)
    logger.info "Entering agreement note #{test_data[PAHMAHeldInTrustData::AGREEMENT_NOTE.name]}"
    wait_for_element_and_type(agreement_note_input, test_data[PAHMAHeldInTrustData::AGREEMENT_NOTE.name])
  end

  def verify_agreement_note(test_data)
    errors = []
    text_values_match?(test_data[PAHMAHeldInTrustData::AGREEMENT_NOTE.name], element_value(agreement_note_input), errors)
    errors
  end

  ##INTERNAL APPROVAL
  def enter_pahma_internal_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_internal_approval]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name)], approvals)

    approvals.each do |approval|
      index = approvals.index approval
      logger.info "Entering internal approval data set at index #{index}: #{approval}"
      wait_for_options_and_select(int_approval_group_input(index),int_approval_group_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_GROUP.name])
      enter_auto_complete(int_approval_individual_input(index), int_approval_individual_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name], 'PAHMA Persons')
      wait_for_options_and_select(int_approval_status_input(index), int_approval_status_options(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_STATUS.name])
      enter_simple_date(int_approval_date_input(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_DATE.name])
      wait_for_element_and_type(int_approval_note_input(index), approval[CoreHeldInTrustData::INTERNAL_APPROVAL_NOTE.name])
    end
  end

  ##EXTERNAL APPROVAL
  def enter_pahma_external_approvals(test_data)
    approvals = test_data[CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name] || [CoreHeldInTrustData.empty_external_approval]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name)], approvals)

    approvals.each do |approval|
      index = approvals.index approval
      logger.info "Entering external approval data set at index #{index}: #{approval}"
      wait_for_options_and_select(ext_approval_group_input(index),ext_approval_group_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_GROUP.name])
      enter_auto_complete(ext_approval_individual_input(index), ext_approval_individual_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name], 'PAHMA Persons')
      wait_for_options_and_select(ext_approval_status_input(index), ext_approval_status_options(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_STATUS.name])
      enter_simple_date(ext_approval_date_input(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_DATE.name])
      wait_for_element_and_type(ext_approval_note_input(index), approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_NOTE.name])
    end
  end

  ##HANDLING LIMITATIONS
  def enter_pahma_handling_limitations(test_data)
    limitations = test_data[CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name] || [CoreHeldInTrustData.empty_handling_limitations]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name)], limitations)

    limitations.each do |limitation|
      index = limitations.index limitation
      logger.info "Entering handling limitations data set at index #{index}: #{limitation}"
      wait_for_options_and_select(handling_type_input(index),handling_type_options(index), limitation[CoreHeldInTrustData::HANDLING_TYPE.name])
      enter_auto_complete(handling_requestor_input(index), handling_requestor_options(index), limitation[CoreHeldInTrustData::HANDLING_REQUESTOR.name], 'PAHMA Persons')
      wait_for_options_and_select(handling_level_input(index), handling_level_options(index), limitation[CoreHeldInTrustData::HANDLING_LEVEL.name])
      enter_auto_complete(handling_on_behalf_of_input(index), handling_on_behalf_of_options(index), limitation[CoreHeldInTrustData::HANDLING_BEHALF.name], 'PAHMA Persons')
      wait_for_element_and_type(handling_detail_input(index), limitation[CoreHeldInTrustData::HANDLING_DETAIL.name])
      enter_simple_date(handling_date_input(index), limitation[CoreHeldInTrustData::HANDLING_DATE.name])
    end
  end

  ##CORRESPONDENCES
  def enter_pahma_correspondences(test_data)
    correspondences = test_data[CoreHeldInTrustData::CORRESPONDENCE_GRP.name] || [CoreHeldInTrustData.empty_correspondence]
    hide_notifications_bar
    prep_fieldsets_for_test_data([fieldset(CoreHeldInTrustData::CORRESPONDENCE_GRP.name)], correspondences)

    correspondences.each do |correspondence|
      index = correspondences.index correspondence
      logger.info "Entering correspondences data set at index #{index}: #{correspondence}"
      enter_simple_date(correspondence_date_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_DATE.name])
      enter_auto_complete(correspondence_sender_input(index), correspondence_sender_options(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_SENDER.name], 'PAHMA Persons')
      enter_auto_complete(correspondence_recipient_input(index), correspondence_recipient_options(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name], 'PAHMA Persons')
      wait_for_element_and_type(correspondence_summary_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_SUMMARY.name])
      wait_for_element_and_type(correspondence_reference_input(index), correspondence[CoreHeldInTrustData::CORRESPONDENCE_REF.name])
    end
  end
end
