class SearchResultsPage

  include Logging
  include Page
  include CollectionSpacePages

  def result_rows; {:xpath => '//div[@class="cspace-ui-SearchResultTable--common"]//*[@aria-label="row"]'} end
  def botgarden_taxonomic_name_column; {:xpath => '//div[@class="cspace-ui-SearchResultTable--common"]//*[@aria-label="row"]//div[@aria-colindex = 3]'} end
  def no_results_msg; {:xpath => '//span[text()="No records found"]'} end
  def no_terms_msg; {:xpath => '//span[text() = "No terms found"]'} end
  def num_per_row_lower; {:xpath => '(//div[contains(@class, "PageSizeChooser")])[2]'} end
  def num_per_row_upper; {:xpath => '(//div[contains(@class, "PageSizeChooser")])[1]'} end
  def title_bar_header_text; {:xpath => '//header[contains(@class, "TitleBar")]//h1//div'} end
  def title_bar_record_link(identifier); {:xpath => "//a[contains(., \"#{identifier}\")]"} end
  def records_found_header_text; {:xpath => "//div[contains(@class, 'SearchResultSummary')]//div//span"} end
  def relate_selected_button; {:xpath => '//button[contains(.,"Relate selected")]'} end
  def search_filter_bar; {:xpath => '//div[contains(@class, "AdminSearchBar")]//input[contains(@class,"LineInput")]'} end
  def search_result_checkbox(identifier); {:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//div[@aria-label=\"row\"][contains(.,\"#{identifier}\")]//input"} end

  def fill_search_filter_bar(value)
    wait_for_element_and_type(search_filter_bar, value)
    sleep 1
  end

  def result_row(id)
    id.instance_of?(String) && id.include?('"') ?
      {:xpath => "//div[@class='cspace-ui-SearchResultTable--common']//*[@aria-label='row'][contains(.,'#{id}')]"} :
      {:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][contains(.,\"#{id}\")]"}
  end

  def result_row_checkbox(id); {:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//div[@aria-label=\"row\"][contains(.,\"#{id}\")]//input"} end

  # Checks whether the page header contains the keyword searched
  # @param [String] keyword
  # @return [boolean]
  def keyword_condition_present?(keyword)
    exists?({:xpath => "//h1[contains(.,\"#{keyword}\")]"})
  end

  # Checks whether a search parameter is included in the list of conditions applied
  # @param [String] condition
  # @return [boolean]
  def field_condition_present?(condition)
    exists?({:xpath => "//div[contains(@class,\"FieldConditionInput\")]//div[text()=\"#{condition}\"]"})
  end

  # Waits for search result rows to be present
  def wait_for_results
    wait_until(Config.medium_wait) { elements(result_rows).any? }
  end

  # Checks for the presence of a search results row containing a given string
  # @param [String] unique_identifier
  # @return [boolean]
  def row_exists?(unique_identifier)
    wait_for_results
    exists? result_row(unique_identifier)
  end

  # Clicks a search results row containing a given string
  # @param [String] unique_identifier
  def click_result(unique_identifier)
    wait_for_results
    wait_for_page_and_click result_row(unique_identifier)
  end

  # Clicks the checkbox for a search result row
  # @param [String] identifier
  def select_result_row(identifier)
    wait_for_element_and_click result_row_checkbox(identifier)
  end

  # Returns the display name for a search result row
  # @param [Integer] row number
  def name_of_nth_row(value)
    element(:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][#{value}]//div[@aria-colindex = 2]").attribute("title")
  end

  def botgarden_name_of_nth_row(value)
    element(:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][#{value}]//div[@aria-colindex = 3]").attribute("title")
  end

  # Clicks the checkbox for a search result row and returns display name
  # @param [Integer] row number
  def select_result_nth_row(value)
    name = name_of_nth_row(value)
    wait_for_element_and_click(:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][#{value}]")
    name
  end

  def botgarden_select_result_nth_row(value)
    name = botgarden_name_of_nth_row(value)
    wait_for_element_and_click(:xpath => "//div[@class=\"cspace-ui-SearchResultTable--common\"]//*[@aria-label=\"row\"][#{value}]")
    name
  end

  def click_search_result_cbx(identifier)
    wait_for_element_and_click search_result_checkbox(identifier)
  end

  # Selects search result rows and clicks the 'Relate' button
  # @param [Array<String>] identifiers
  def relate_records(identifiers)
    identifiers.each { |identifier| click_search_result_cbx identifier }
    wait_for_element_and_click relate_selected_button
    wait_for_notification 'related to'
  end

  def first_row_input; input_locator([], "0") end
  def second_row_input; input_locator([], "1") end

  def new_search; {:xpath => '//label[text()="Find"]'} end

  def relate_first_two
    wait_for_element_and_click first_row_input
    wait_for_element_and_click second_row_input
    wait_for_element_and_click relate_button
  end

  #SELECT BOX

  def header_select_size_input_locator; {:xpath => '(//div[contains(@class, "PageSizeChooser")]//input)[1]'} end
  def footer_select_size_input_locator; {:xpath => '(//div[contains(@class, "PageSizeChooser")]//input)[2]'} end
  def select_size_input_options; {:xpath => '//div[contains(@class, "PageSizeChooser")]//input/following-sibling::div//li'} end


  # Enters a size integer in header select box
  # @param [Integer] integer
  def select_size(integer)
    logger.info "Update results to show #{integer} records"
    begin
      wait_for_options_and_select(footer_select_size_input_locator, select_size_input_options, integer)
    rescue
      wait_for_options_and_select(header_select_size_input_locator, select_size_input_options, integer)
    end 
  end

  # Enters a size integer and hits enter
  # @param [Integer] integer
  def full_text_search(integer)
    select_size integer
    hit_enter
  end

  #SEARCH RESULTS NAVIGATION
  def navigation_bar; {:xpath => "//footer//nav"} end
  def navigation_pages; {:xpath => "//footer//nav//ul"} end
  def navigation_page_index_button(index); {:xpath => "(//footer//nav//ul//button)[#{index}]"} end
  def navigation_left_arrow; {:xpath => "(//footer//nav//button)[1]"} end
  def navigation_right_arrow; {:xpath => "(//footer//nav//button)[last()]"} end

end
