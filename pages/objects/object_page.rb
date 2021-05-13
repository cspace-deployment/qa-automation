class ObjectPage

  include Logging
  include Page
  include CollectionSpacePages
  include Sidebar
  include CoreObjectIdInfoForm
  include CoreObjectDescInfoForm
  include CoreObjectHistoryAssocInfoForm
  include PAHMAObjectIdInfoForm
  include BOTGARDENObjectIdInfoForm
  include BAMPFAObjectIdInfoForm

  def page_heading; {:xpath => '//h1'} end

  def enter_core_object_id_data(data)
    enter_object_number data
    enter_num_objects data
    enter_other_numbers data
    enter_resp_depts data
    select_collection data
    select_status data
    enter_publish_to data
    select_inventory_status data
    enter_brief_description data
    enter_dist_features data
    enter_comments data
    enter_titles data
    enter_object_names data
  end

  def enter_botgarden_object_id_data(data)
    enter_botgarden_accession_num data
    enter_botgarden_taxonomics data
  end

  def enter_pahma_object_id_data(data)
    enter_pahma_museum_number data
    select_pahma_legacy_dept data
    enter_pahma_num_pieces data
    enter_pahma_count_note data
    select_pahma_is_component data
    select_pahma_object_statuses data
    enter_pahma_alt_num data
    enter_pahma_desc data
    enter_pahma_object_classes data
    enter_pahma_object_names data
    enter_pahma_resp_collection_mgr data
    select_pahma_object_type data
    enter_pahma_assoc_cult_grps data
    enter_pahma_enthno_file_codes data
    enter_pahma_comments data
    enter_pahma_annotations data
    enter_pahma_dimensions data
    enter_pahma_materials data
    enter_pahma_taxonomics data
    enter_pahma_titles data
    enter_pahma_usages data
    select_pahma_series data
    select_pahma_collections data
    select_pahma_tms_source data
  end

  def enter_bampfa_object_id_data(data)
    enter_bampfa_id_prefix data
    enter_bampfa_id_year data
    enter_bampfa_id_gift_1 data
    enter_bampfa_id_gift_2 data
    enter_bampfa_id_gift_3 data
    enter_bampfa_id_alpha data
    select_bampfa_artist_name data
  end

  def enter_number_and_text(data)
    enter_object_number data
    enter_brief_description data
  end

  def enter_number(data)
    enter_object_number data
  end

  def select_template(template)
    select_object_template(template)
  end

  # Enters data in the various forms on the new object page
  # @param [Hash] data_set
  # @return [Array<Object>]
  def enter_object_data(data_set)
    enter_core_object_id_data data_set
  end

  # Combines methods to enter new object data, save it, and wait for a delete button to appear. Returns any errors caused by form fields.
  # @param [Hash] data_set
  # @return [Array<Object>]
  def create_new_object(data_set)
    data_input_errors = enter_object_data data_set
    wait_for_element_and_click top_save_button
    when_exists(delete_button, Config.short_wait)
    data_input_errors
  end

  def create_new_pahma_object(data_set)
    data_input_errors = enter_pahma_object_id_data(data_set)
    wait_for_element_and_click top_save_button
    when_exists(delete_button, Config.short_wait)
    data_input_errors
  end

  # Checks data in the various forms on the new object page
  # @param [Hash] data_set
  def verify_object_data(data_set)
    verify_object_info_data data_set
  end

end
