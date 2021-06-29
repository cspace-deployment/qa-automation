module CollectionSpacePages

  include Page
  include Logging

  # ELEMENT LOCATORS

  def quick_search_type_select; {:xpath => '//div[contains(@class,"QuickSearchInput")]//div[contains(@class,"DropdownMenuInput")]/input'} end
  def quick_search_type_options; {:xpath => '//div[contains(@class,"QuickSearchInput")]//li'} end
  def quick_search_sub_type_select; {:xpath => '(//div[contains(@class,"QuickSearchInput")]//div[contains(@class,"DropdownMenuInput")])[2]/input'} end
  def quick_search_sub_type_options; {:xpath => '(//div[contains(@class,"QuickSearchInput")]//div[contains(@class,"DropdownMenuInput")])[2]//li'} end
  def quick_search_input; {:xpath => '//div[contains(@class,"QuickSearchInput")]//input[@placeholder="Search"]'} end
  def quick_search_button; {:xpath => '//div[contains(@class,"QuickSearchInput")]//button'} end
  def dialog_search_button; {:xpath => '//footer//button[@name = "search"]'} end
  def my_collection_space_link; {:xpath => '//a[contains(.,"My CollectionSpace")]'} end
  def create_new_link; {:xpath => '//a[contains(.,"Create New")]'} end
  def search_link; {:xpath => '//a[contains(.,"Search")]'} end
  def admin_link; {:xpath => '//a[contains(.,"Administration")]'} end
  def sign_out_link; {:xpath => '//a[contains(.,"Sign out")]'} end
  def tools_link; {:xpath => '//a[contains(.,"Tools")]'} end
  def save_button; {:name => 'save'} end
  def top_save_button; {:xpath => '//div[@class="cspace-ui-RecordHeader--common"]//button[@name="save"]'} end
  def bottom_save_button; {:xpath => '//footer//button[@name="save"]'} end
  def save_only_button; {:xpath => '//button[contains(.,"Save only")]'} end
  def save_and_lock_button; {:xpath => '//button[contains(.,"Save and lock")]'} end
  def delete_button; {:name => 'delete'} end
  def revert_button; {:name => 'revert'} end
  def close_button; {:name => 'close'} end
  def create_new_button; {:name => 'create'} end
  def run_button; {:name => 'run'} end
  def invoke_button; {:name => 'invoke'} end
  def use_selection_button; {:name => 'accept'} end
  def clone_button; {:name => 'clone'} end
  def timestamp; {:xpath => '//div[@class = "cspace-ui-RecordHistory--common"]//button//span'} end
  def header_bar; {:xpath => '//header/div'} end
  def page_h1; {:xpath => '//h1'} end
  def page_h2; {:xpath => '//h2'} end
  def form_show_hide_button(heading_text); {:xpath => "//button[contains(.,\"#{heading_text}\")]"} end
  def open_link; {:xpath => '//a[contains(@href,"/record")][contains(.,"Open")]'} end

  def related_tab; {:xpath => '//input[@placeholder="+ Related"]'} end
  def related_option; {:xpath => "//input[@placeholder='+ Related']/following-sibling::div//li"} end
  def relate_button; {:name => 'relate'} end
  def relate_selected_button; {:name => 'accept'} end
  def unrelate_button; {:name => 'unrelate'} end
  def unrelate_option; {:xpath => '//button[@name = "cancel"]/following-sibling::button'} end

  def relation_editor_unrelate_button; {:xpath => '//div[contains(@class,"RelationEditor")]//button'} end
  def relation_editor_cancel_button; {:xpath => '//div[contains(@class,"ConfirmRecordUnrelateModal")]//button[@name="cancel"]'} end

  def term_search_result_msg; {:xpath => '//span[contains(text(), "matching term")]'} end

  def notifications_bar; {:xpath => '//div[@class="cspace-ui-NotificationBar--common"]'} end
  def notifications_close_button; {:xpath => '//div[@class="cspace-ui-NotificationBar--common"]//button'} end
  def notifications_timestamp; {:xpath => '//div[contains(@class, "NotificationBar")]//header'} end

  def dialog_box; {:xpath => "//div[@role = 'dialog']"} end
  def dialog_message; {:xpath => '//div[@role = "dialog"]//header/following-sibling::div//span'} end
  def do_not_leave_button; {:xpath => '//button[contains(., "Don\'t leave")]'} end
  def save_and_continue_button; {:xpath => '//button[contains(., "Save and continue")]'} end
  def revert_and_continue_button; {:xpath => '//button[contains(., "Revert and continue")]'} end

  def confirm_delete_msg_span; {:xpath => '//div[contains(@class,"ConfirmRecordDeleteModal")]//header/following-sibling::div/span'} end
  def confirm_delete_button; {:xpath => '//div[contains(@class,"ConfirmRecordDeleteModal")]//button[@name="delete"]'} end
  def confirm_delete_cancel_button; {:xpath => '//div[contains(@class,"ConfirmRecordDeleteModal")]//button[@name="cancel"]'} end

  def toggle_panel_button(label); {:xpath => "//section[contains(@class, \"Panel\")][contains(., \"#{label}\")]//button"} end
  def collapsed_panel_locator(label); {:xpath => "//section[contains(@class, 'collapsed')][contains(., \"#{label}\")]"} end
  def toggle_subpanel_button(label); {:xpath => "//section//section[contains(@class, \"Panel\")][contains(., \"#{label}\")]//button"} end

  # To be used when checking if the rest of a page is inactive/greyed out when a dialog box is open
  def inactive_page_check; {:xpath => '//div[@aria-hidden = "true"]'} end

  # Returns a hash containing both the data name used to locate a set of data fields on the page and also the index of the data (i.e., which row)
  # @param [String] data_name
  # @param [Integer] index
  # @return [Hash]
  def fieldset(data_name, index=nil)
    {:data_name => data_name, :index => index}
  end

  # Returns the XPath to a given set of fields in the UI, with nesting determined by the given fieldsets if any
  # @param [Array<Hash>] fieldsets
  # @return [String]
  def fieldset_xpath(fieldsets=nil)
    xpath = ''
    if fieldsets
      # For each fieldset, append to the XPath string
      fieldsets.each do |pair|
        xpath << "//fieldset[@data-name=\"#{pair[:data_name]}\"]" if pair[:data_name]
        xpath << "//div[@data-instancename=\"#{pair[:index]}\"]" if pair[:index]
      end
    end
    xpath
  end

  def fieldset_siblings_xpath(fieldsets)
    xpath = '('
    fieldsets.each do |pair|
      xpath << "//fieldset[@data-name=\"#{pair[:data_name]}\"]" if pair[:data_name]
      if pair == fieldsets.last
        xpath << "//div[@data-instancename=\"0\"]"
      else
        xpath << "//div[@data-instancename=\"#{pair[:index]}\"]" if pair[:index]
      end
    end
    xpath << ')[1]/following-sibling::div'
  end

  def fieldset_move_top_btn_xpath(fieldsets, row_index)
    xpath = '('
    fieldsets.each do |pair|
      xpath << "//fieldset[@data-name=\"#{pair[:data_name]}\"]" if pair[:data_name]
      if pair == fieldsets.last
        xpath << "//div[@data-instancename=\"#{row_index}\"]"
      else
        xpath << "//div[@data-instancename=\"#{pair[:index]}\"]" if pair[:index]
      end
    end
    xpath << '//button[@data-name="moveToTop"])'
  end

  def fieldset_remove_btn_xpath(fieldsets, row_index)
    xpath = '('
    fieldsets.each do |pair|
      xpath << "//fieldset[@data-name=\"#{pair[:data_name]}\"]" if pair[:data_name]
      if pair == fieldsets.last
        xpath << "//div[@data-instancename=\"#{row_index}\"]"
      else
        xpath << "//div[@data-instancename=\"#{pair[:index]}\"]" if pair[:index]
      end
    end
    xpath << '//button[@data-name="remove"])[last()]'
  end

  def fieldset_data_instance_count(fieldsets)
    ui_sibling_fieldsets = elements({:xpath => fieldset_siblings_xpath(fieldsets)})
    ui_sibling_fieldsets.length + 1
  end

  # Returns a hash containing the XPath to an input element, with a data-name attribute if given
  # @param [Array<Hash>] fieldsets
  # @param [String] input_data_name
  # @return [Hash]
  def input_locator(fieldsets, input_data_name=nil)
    {:xpath => "#{fieldset_xpath fieldsets}//input#{'[@data-name="' + input_data_name + '"]' if input_data_name}"}
  end

  def disabled_input_locator_by_label(label)
    {:xpath => "//label[contains(., \"#{label}\")]/following-sibling::input"}
  end

  # Returns a hash containing the XPath to an input element, based on the label text of the input
  # @param [String] label
  # @return [Hash]
  def input_locator_by_label(label)
    {:xpath => "//label[contains(., \"#{label}\")]/following-sibling::div//input"}
  end

  # Returns a hash containing the XPath to a text_area element, with a data-name attribute if given
  # @param [Hash] fieldset
  # @param [String] text_data_name
  # @return [Hash]
  def text_area_locator(fieldset, text_data_name=nil)
    {:xpath => "#{fieldset_xpath fieldset}//textarea#{'[@data-name="' + text_data_name + '"]' if text_data_name}"}
  end

  def rich_text_input_locator_by_label(label)
    {xpath: "//label[contains(., \"#{label}\")]/following-sibling::div//div[contains(@class, 'ql-editor')]"}
  end

  # Returns a hash containing the XPath to a set of options for an input, with a data-name attribute if given
  # @param [Array<Hash>] fieldsets
  # @param [String] options_data_name
  # @return [Hash]
  def input_options_locator(fieldsets, options_data_name=nil)
    {:xpath => "#{fieldset_xpath fieldsets}//input#{'[@data-name="' + options_data_name + '"]' if options_data_name}/following-sibling::div//li"}
  end

  def input_options_locator_by_label(label)
    {:xpath => "//label[contains(., \"#{label}\")]/following-sibling::div//li"}
  end

  # Returns a has containing the XPath to a structured date input
  # @param [Array<Hash>] fieldsets
  # @return [Hash]
  def structured_date_input_locator(fieldsets)
    {:xpath => "#{fieldset_xpath fieldsets}//div[contains(@class, 'StructuredDateInput')]/input"}
  end

  # Returns a hash containing the XPath to a 'move top' button for a row
  # @param [Array<Hash>] fieldsets
  # @param [Integer] row_index
  # @return [Hash]
  def move_top_button_locator(fieldsets, row_index)
    {:xpath => fieldset_move_top_btn_xpath(fieldsets, row_index)}
  end

  # Returns a hash containing the XPath to a 'delete' button for a row
  # @param [Array<Hash>] fieldsets
  # @param [Integer] row_index
  # @return [Hash]
  def delete_button_locator(fieldsets, row_index)
    {:xpath => fieldset_remove_btn_xpath(fieldsets, row_index)}
  end

  # Returns a hash containing the XPath to an 'add' button for adding a row to a fieldset
  # @param [Array<Hash>] fieldsets
  # @return [Hash]
  def add_button_locator(fieldsets)
    {:xpath => "(#{fieldset_xpath fieldsets}//button[@data-name=\"add\"])[last()]"}
  end

  # PAGE INTERACTIONS

  # Waits for a given page title to load
  # @param [String] title_prefix
  def wait_for_title(title_prefix, start_time=nil)
    finish = wait_until(Config.medium_wait) { page_title == "#{title_prefix} | CollectionSpace" }
    logger.debug "BENCHMARK - #{title_prefix} page title loaded in #{finish - start_time} seconds" if start_time
  end

  # @param [String] condition
  # @return [boolean]
  def title_bar_field_present?(field)
    exists?({:xpath => "//header[contains(@class,'TitleBar')]//div[contains(., '#{field}')]"})
  end

  # Performs a search in the header bar, selecting a type and entering a search string
  # @param [String] type_string
  # @param [String] sub_type_string
  # @param [String] term_string
  def quick_search(type_string, sub_type_string, term_string)
    type_option = type_string || 'All Records'
    sub_type_option = sub_type_string || 'All'
    logger.info "Performing quick search for '#{term_string}' in '#{type_option}, #{sub_type_option}'"
    scroll_to_top
    wait_for_options_and_select(quick_search_type_select, quick_search_type_options, type_option)
    wait_for_options_and_select(quick_search_sub_type_select, quick_search_sub_type_options, sub_type_option) if exists?(quick_search_sub_type_select)
    wait_for_element_and_type(quick_search_input, term_string) if term_string
    hit_enter
  end

  #Clicks the 'Search' button in an open dialog
  def click_dialog_search_button
    logger.info 'Clicking search button in open dialog'
    wait_for_element_and_click dialog_search_button
  end

  # Clicks the 'Create New' link in the navigation menu
  def click_create_new_link
    logger.info 'Clicking link to Create New'
    scroll_to_top
    wait_for_element_and_click create_new_link
  end

  # Clicks the 'Search' link in the navigation menu
  def click_search_link
    logger.info 'Clicking link to Search'
    scroll_to_top
    wait_for_element_and_click search_link
  end

  def click_tools_link
    logger.info 'Clicking link to Tools'
    scroll_to_top
    wait_for_element_and_click tools_link
  end

  def click_admin_link
    logger.info 'Clicking link to Administration'
    scroll_to_top
    wait_for_element_and_click admin_link
  end

  def click_invoke_button
    logger.info 'Clicking invoke button'
    scroll_to_top
    wait_for_element_and_click invoke_button
  end

  # SAVE, DELETE, REVERT, CANCEL

  # Clicks the save button
  def click_save_button
    wait_for_element_and_click save_button
  end

  # Clicks save and waits for confirmation the record has been saved
  def save_record(timeout = nil)
    logger.info 'Saving the record'
    start = click_save_button
    finish = wait_for_notification('Saved', timeout)
    logger.warn "BENCHMARK - Took #{finish - start} seconds to save record"
  end

  # Clicks the save-only option for a record
  def save_record_only
    logger.info 'Saving but not locking the record'
    click_save_button
    start = wait_for_element_and_click save_only_button
    finish = wait_for_notification 'Saved'
    logger.warn "BENCHMARK - Took #{finish - start} seconds to save but not lock record"
  end

  # Clicks the save-and-lock option for a record
  def save_and_lock_record
    logger.info 'Saving and locking the record'
    click_save_button
    start = wait_for_element_and_click save_and_lock_button
    finish = wait_for_notification 'Saved'
    logger.warn "BENCHMARK - Took #{finish - start} seconds to save and lock record"
  end

  # Clicks the delete button
  def click_delete_button
    wait_for_element_and_click delete_button
  end

  # Clicks delete, confirms the deletion, and waits for confirmation the record has been deleted
  def delete_record(timeout = nil)
    logger.info 'Deleting the record'
    click_delete_button
    start = wait_for_element_and_click confirm_delete_button
    finish = wait_for_notification('Deleted', timeout)
    logger.warn "BENCHMARK - Took #{finish - start} seconds to delete record"
  end

  # Returns the delete confirmation message text
  # @return [String]
  def confirm_delete_msg
    when_exists(confirm_delete_msg_span, Config.short_wait)
    element_text confirm_delete_msg_span
  end

  # Clicks the cancel button on a delete confirmation pop-up
  def cancel_deletion
    logger.info 'Clicking the cancel button'
    wait_for_element_and_click confirm_delete_cancel_button
  end

  # Clicks the close button on a modal. The button sometimes does not respond to a click() right away or it is replaced
  # by a DOM update, so rescues stale element errors and retries the click if needed
  def click_close_button
    logger.info 'Clicking the close button'
    wait_for_element_and_click close_button rescue Selenium::WebDriver::Error::StaleElementReferenceError
    sleep Config.click_wait
    wait_for_element_and_click close_button if exists? close_button
  end

  # Clicks the Don't leave button in a modal
  def do_not_leave_record
    logger.info 'Clicking the Don\'t leave button'
    wait_for_element_and_click do_not_leave_button
  end

  # Clicks the Revert and continue button in a modal
  def revert_and_continue
    logger.info 'Clicking the Revert and continue button'
    wait_for_element_and_click revert_and_continue_button
  end

  # Clicks the Save and continue button in a modal
  def save_and_continue
    logger.info 'Clicking the Save and continue button'
    wait_for_element_and_click save_and_continue_button
  end

  # Reverts changes to a record
  def revert_record
    logger.info 'Reverting the record'
    wait_for_element_and_click revert_button
    when_not_enabled(revert_button, Config.short_wait)
  end

  # Clicks the create-new button for a record
  def click_create_new_button
    logger.info 'Clicking the Create button'
    wait_for_element_and_click create_new_button
  end

  # Clicks the clone button for a record
  def click_clone_button
    logger.info 'Clicking the Clone button'
    wait_for_element_and_click clone_button
  end

  def click_use_selection_button
    logger.info 'Clicking the Use Selection button'
    wait_for_element_and_click use_selection_button
  end

  # Clicks the unrelate button for a record
  def click_unrelate_button
    logger.info 'Clicking the Unrelate button'
    wait_for_element_and_click unrelate_button
  end

  # Clicks the unrelate button in relation editor for a record
  def click_relation_editor_unrelate_button
    logger.info 'Clicking the Unrelate button'
    wait_for_element_and_click relation_editor_unrelate_button
  end

  # Clicks the cancel button in relation editor for a record
  def click_relation_editor_cancel_button
    logger.info 'Clicking the cancel button'
    wait_for_element_and_click relation_editor_cancel_button
  end

  # Removes a related record
  def unrelate_record
    logger.info 'Removing a related record'
    click_unrelate_button
    wait_for_element_and_click unrelate_option
  end

  # Clicks the relate selected button
  def click_relate_selected_button
    logger.info 'Clicking the Relate Selected button'
    wait_for_element_and_click relate_selected_button
  end

  # LOG OUT

  # Logs out using the sign out link in the header
  def log_out
    logger.info 'Logging out'
    unhide_header_bar
    start = wait_for_element_and_click sign_out_link
    finish = wait_until(Config.short_wait) { url.include? '/login' }
    logger.warn "BENCHMARK - Took #{finish - start} seconds to log out"
  end

  # FLOATING HEADER AND NOTIFICATIONS BARS

  # Waits for the notifications bar to contain a given string
  # @param [String] string
  def wait_for_notification(string, timeout = nil)
    unhide_notifications_bar
    wait = timeout || Config.short_wait
    when_displayed(notifications_bar, wait)
    wait_until(wait) { element_text(notifications_bar).include? string }
    Time.now
  end

  # Closes the notifications bar if it is present
  def close_notifications_bar
    click_element notifications_close_button if exists?(notifications_close_button)
  end

  # Hides the notifications bar to ensure it does not obscure elements on the page
  def hide_notifications_bar
    when_exists(notifications_bar, Config.short_wait)
    @driver.execute_script("arguments[0].style.visibility='hidden';", element(notifications_bar))
  end

  # Un-hides the notifications bar
  def unhide_notifications_bar
    when_exists(notifications_bar, Config.short_wait)
    @driver.execute_script("arguments[0].style.visibility='visible';", element(notifications_bar))
  end

  # Hides the header bar to ensure it does not obscure elements on the page
  def hide_header_bar
    when_exists(header_bar, Config.medium_wait)
    @driver.execute_script("arguments[0].style.visibility='hidden';", element(header_bar))
  end

  def unhide_header_bar
    @driver.execute_script("arguments[0].style.visibility='visible';", element(header_bar))
  end

  # SECONDARY TAB

  # Clicks the relate button
  def click_relate_button
    logger.info 'Clicking the Relate button'
    wait_for_element_and_click relate_button
  end

  # Selects the secondary tab of a given record type
  # @param [String] option
  def select_related_type(option)
    logger.info "Clicking related record type '#{option}'"
    wait_for_options_and_select(related_tab, related_option, option)
  end

  # Clicks the 'Open' link for a record on another record's secondary tab
  def click_open_link
    logger.info 'Clicking Open link'
    wait_for_element_and_click open_link
  end

  # STRUCTURED DATES

  # Enters a date string in a structured date input and then reverse tabs from the field to collapse the structured date pop-up,
  # preventing subsequent input entries failing because the inputs are obscured by the pop-up.
  # @param [Hash] input
  # @param [String] string
  def enter_simple_date(input, string)
    wait_for_element_and_type(input, string)
    hit_enter
    hit_shift_tab
  end

  def date_period; input_locator([], CoreObjectData::DATE_PERIOD.name) end
  def date_assoc; input_locator([], CoreObjectData::DATE_ASSOC.name) end
  def date_note; input_locator([], CoreObjectData::DATE_NOTE.name) end
  def date_earliest_year; input_locator([], CoreObjectData::DATE_EARLIEST_YEAR.name) end
  def date_earliest_month; input_locator([], CoreObjectData::DATE_EARLIEST_MONTH.name) end
  def date_earliest_day; input_locator([], CoreObjectData::DATE_EARLIEST_DAY.name) end
  def date_earliest_era; input_locator([], CoreObjectData::DATE_EARLIEST_ERA.name) end
  def date_earliest_certainty; input_locator([], CoreObjectData::DATE_EARLIEST_CERTAINTY.name) end
  def date_earliest_qualif; input_locator([], CoreObjectData::DATE_EARLIEST_QUALIF.name) end
  def date_earliest_qualif_value; input_locator([], CoreObjectData::DATE_EARLIEST_QUALIF_VALUE.name) end
  def date_earliest_qualif_unit; input_locator([], CoreObjectData::DATE_EARLIEST_QUALIF_UNIT.name) end
  def date_latest_year; input_locator([], CoreObjectData::DATE_LATEST_YEAR.name) end
  def date_latest_month; input_locator([], CoreObjectData::DATE_LATEST_MONTH.name) end
  def date_latest_day; input_locator([], CoreObjectData::DATE_LATEST_DAY.name) end
  def date_latest_era; input_locator([], CoreObjectData::DATE_LATEST_ERA.name) end
  def date_latest_certainty; input_locator([], CoreObjectData::DATE_LATEST_CERTAINTY.name) end
  def date_latest_qualif; input_locator([], CoreObjectData::DATE_LATEST_QUALIF.name) end
  def date_latest_qualif_value; input_locator([], CoreObjectData::DATE_LATEST_QUALIF_VALUE.name) end
  def date_latest_qualif_unit; input_locator([], CoreObjectData::DATE_LATEST_QUALIF_UNIT.name) end

  # TERM POP-UPS

  def term_popup_link(term_string); {:xpath => "//div[@class='cspace-ui-MiniViewPopup--common']//a[text()=\"#{term_string}\"]"} end

  # Clicks the term link in a term pop-up
  # @param [String] term_string
  def click_term_popup_link(term_string)
    wait_for_element_and_click term_popup_link(term_string)
  end

  # For inputs that offer auto-generated identifiers, selects the auto-generated option and returns its value
  # @param [Hash] input_locator
  # @param [Hash] options_locator
  # @return [String]
  def select_id_generator_option(input_locator, options_locator)
    wait_for_element_and_click input_locator
    wait_until(Config.short_wait) { elements(options_locator).any? &:displayed? }
    elements(options_locator).first.click
    sleep Config.click_wait
    wait_until(2) { !element_value(input_locator).empty? }
    element_value input_locator
  end

  # ADDING AND DELETING ROWS OF DATA

  # Compares the number of fieldsets in the UI with the number of corresponding data sets in test data. Adds or removes
  # fieldsets as necessary so that the right number are present for subsequent data entry.
  #
  # @param [Array<Hash>] fieldsets
  # @param [Array<Hash>] data_set
  def prep_fieldsets_for_test_data(fieldsets, data_set)

    # Get the count of data sets in the test data, the count of data sets in the UI, and the difference
    test_data_set_count = data_set ? data_set.length : 0
    ui_data_set_count = fieldset_data_instance_count fieldsets
    data_set_diff = ui_data_set_count - test_data_set_count
    logger.debug "The number of data sets required by the test data is #{test_data_set_count}, and the UI currently has #{ui_data_set_count} visible"

    # Remove excess rows in the UI
    if data_set_diff > 0
      row_index = test_data_set_count
      data_set_diff.times do
        logger.debug "Removing a data set at XPath '#{fieldset_remove_btn_xpath(fieldsets, row_index)}'"
        if ui_data_set_count == 1
          wait_until(Config.short_wait) { elements(input_locator fieldsets).any?(&:enabled?) || elements(text_area_locator fieldsets).any?(&:enabled?) }
          logger.debug "Clearing input with locator '#{input_locator fieldsets}'"
          elements(input_locator fieldsets).each_with_index do |el, i|
            if el.attribute('type') == 'checkbox'
              logger.warn "Skipping clearing element #{i} because it is a checkbox whose state cannot be determined"
            else
              el.clear
            end
          end
          elements(text_area_locator fieldsets).each &:clear
        else
          wait_for_element_and_click({:xpath => fieldset_remove_btn_xpath(fieldsets, row_index)})
          wait_until(Config.short_wait) { fieldset_data_instance_count(fieldsets) < ui_data_set_count }
          ui_data_set_count -= 1
        end
      end

    # Add missing rows in the UI
    elsif data_set_diff < 0
      data_set_diff.abs.times do
        logger.debug "Adding a data set at XPath '#{add_button_locator(fieldsets)}'"
        wait_for_element_and_click add_button_locator(fieldsets)
        wait_until(Config.short_wait) { fieldset_data_instance_count(fieldsets) > ui_data_set_count }
        ui_data_set_count += 1
      end

    else
      logger.debug 'No need to add or remove rows'
    end
  end

  # Executes a given block a configurable number of times until the block completes; intended for data updates made by
  # an event listener
  def wait_for_event_listener(&blk)
    tries = Config.medium_wait
    begin
      refresh_page
      yield
    rescue => e
      logger.error e.message
      (tries -= 1).zero? ? fail : (sleep 1; retry)
    end
  end

  # PANELS

  def is_collapsed(panel_label)
    exists? collapsed_panel_locator panel_label
  end

  def toggle_panel(panel_label)
      click_element toggle_panel_button panel_label
  end

  def toggle_subpanel(panel_label)
      click_element toggle_subpanel_button panel_label
  end

  def uncollapse_panel_if_collapsed(label)
    if is_collapsed label
      toggle_panel label
    end
  end

  def uncollapse_subpanel_if_collapsed(label)
    if is_collapsed label
      toggle_subpanel label
    end
  end

  def primary_tab; {:xpath => '//button[text()="Primary Record"]'} end
  def current_locations_tab; {:xpath => '//button[text()="Current Locations"]'} end
  def exhibition_tab; {:xpath => '//button[text()="Exhibitions"]'} end
  def related_tab_button(relate); {:xpath => '//div[contains(@class,"RecordBrowser")]//button[contains(., "' + relate + '")]'} end
  def related_panel_rows; {:xpath => '//div[contains(@class,"cspace-ui-RelatedRecordBrowser")]//div[@class="cspace-ui-SearchResultTable--common"]//*[@aria-label="row"]'} end
  def nth_result_row(value); {:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][#{value}]"} end
  def close_tab(label); {:xpath => "//button[text() = '#{label}']//following-sibling::button[@aria-label = 'close']"} end
  def movement_secondary_tab; {:xpath => '//button[contains(text(), "Inventory") and contains(text(), "Movement")]'} end
  def related_record_h1; {:xpath => '(//h1)[2]'} end

  # Clicks the Primary Record tab on a record
  def click_primary_record_tab
    logger.info 'Clicking the primary record tab'
    wait_for_element_and_click primary_tab
  end

  #Clicks the secondary 'Current Locations' tab on a record
  def click_current_locations_tab
    logger.info 'Clicking the secondary Current Locations tab'
    when_displayed(primary_tab, Config.short_wait)
    wait_for_element_and_click(current_locations_tab, 2)
  rescue
    select_related_type 'Current Locations'
  end

  #Clicks the secondary 'Exhibitions' tab on a record
  def click_exhibitions_tab
    logger.info 'Clicking the secondary Exhibitions tab'
    when_displayed(primary_tab, Config.short_wait)
    wait_for_element_and_click(exhibition_tab, 2)
  rescue
    select_related_type 'Exhibitions'
  end

  # Clicks the secondary 'Location/Movement/Inventory' tab on a record
  def click_movement_secondary_tab
    logger.info 'Clicking the secondary Movement tab'
    when_displayed(primary_tab, Config.short_wait)
    wait_for_element_and_click(movement_secondary_tab, 2)
  rescue
    select_related_type 'Location/Movement/Inventory'
  end

  def click_pahma_movement_secondary_tab
    logger.info 'Clicking the secondary Movement tab'
    when_displayed(primary_tab, Config.short_wait)
    wait_for_element_and_click(movement_secondary_tab, 2)
  rescue
    select_related_type 'Inventory/Movement'
  end

  def hit_related_tab(relate)
    logger.info 'Clicking link to Create New' + relate
    scroll_to_top
    wait_for_element_and_click related_tab_button(relate)
  end

  # Closes the specified secondary tab on a record
  def click_close_tab(label)
    logger.info "Closing the secondary #{label} tab"
    wait_for_element_and_click close_tab(label)
  end

end
