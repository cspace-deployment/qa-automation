require_relative '../../spec_helper'

test_id = Time.now.to_i

describe 'Place Authority records', order: :defined do

  include Logging
  include WebDriverManager

  before(:all) do
    @test = TestConfig.new Deployment::PAHMA
    @test.set_driver launch_browser
    @admin = @test.get_admin_user
    @login_page = LoginPage.new @test
    @create_new_page = CreateNewPage.new @test
    @exhibition_page = ExhibitionPage.new @test
    @place_authority_page = PlacePage.new @test
    @search_page = SearchPage.new @test
    @search_results_page = SearchResultsPage.new @test

    test_data = @test.pahma_authorities_test_data
    @place_0 = test_data[0]
    @place_1 = test_data[1]
    @place_2 = test_data[2]
    @place_3 = test_data[3]
    @place_4 = test_data[4]
    @place_5_type_empty = test_data[5]
    @place_5_type = test_data[6]
    @place_5_note = test_data[7]

    # Insert the unique test ID in the test data term display names
    [@place_0, @place_1, @place_2, @place_3, @place_4].each do |place|
      place[CorePlaceData::PLACE_TERM_GRP.name].each do |term|
        term[CorePlaceData::TERM_DISPLAY_NAME.name] = "#{term[CorePlaceData::TERM_DISPLAY_NAME.name]} #{test_id}"
      end
    end

    @place_0_display_name = @place_0[CorePlaceData::PLACE_TERM_GRP.name][0][CorePlaceData::TERM_DISPLAY_NAME.name]
    @place_1_display_name_0 = @place_1[CorePlaceData::PLACE_TERM_GRP.name][0][CorePlaceData::TERM_DISPLAY_NAME.name]
    @place_1_display_name_1 = @place_1[CorePlaceData::PLACE_TERM_GRP.name][1][CorePlaceData::TERM_DISPLAY_NAME.name]

    @login_page.load_page
    @login_page.log_in("sehyunhwang@berkeley.edu", "BlueWord2021!!")#@admin.username, @admin.password)
  end

  after(:all) { quit_browser @test.driver }

  context 'when part of local vocabulary' do

    it 'can be created via the Create New > Local link' do
      @search_page.click_create_new_link
      @create_new_page.click_create_new_authority_place_local
      @place_authority_page.when_displayed(@place_authority_page.page_h2, Config.short_wait)
      expect(@place_authority_page.element(@place_authority_page.page_h2).attribute('innerText')).to eql('Place - PAHMA')
    end

    it 'can be saved' do
      @place_authority_page.enter_place_display_name(@place_0_display_name, 0)
      @place_authority_page.save_record
      expect(@place_authority_page.element(@place_authority_page.page_h2).attribute('innerText')).to eql('Place - PAHMA')
    end

    it 'can be added to Procedure records' do
      @place_authority_page.click_create_new_link
      @create_new_page.click_create_new_exhibition
      @exhibition_page.enter_exhibition_num({ CoreExhibitionData::EXHIBITION_NUM.name => "Exhibition #{test_id}" })
      @exhibition_page.enter_venue_name(@place_0_display_name, 0)
      @exhibition_page.save_record
    end

    it 'are shown on the Terms Used list on the sidebar of a linked Procedure record' do
      @exhibition_page.expand_sidebar_terms_used
      @exhibition_page.click_sidebar_term @place_0_display_name
      @place_authority_page.verify_display_name(@place_0_display_name, 0)
    end
  end

  context 'when searched' do

    it 'can be filtered for all vocabulary types' do
      @place_authority_page.quick_search('Places', 'All', test_id)
      @search_results_page.wait_for_results
      expect(@search_results_page.row_exists? @place_0_display_name).to be true
    end

    it 'can be filtered for PAHMA vocabulary' do
      @search_results_page.quick_search('Places', 'PAHMA',test_id)
      @search_results_page.wait_for_results
      expect(@search_results_page.row_exists? @place_0_display_name).to be true
    end

    it 'can be loaded via PAHMA vocabulary search results' do
      @search_results_page.click_result @place_0_display_name
      @place_authority_page.wait_until(Config.short_wait) { @place_authority_page.page_title.include? @place_0_display_name }
      expect(@place_authority_page.element(@place_authority_page.page_h2).attribute('innerText')).to eql('Place - PAHMA')
    end
  end

  context 'when being created' do

    it 'require a display name' do
      @place_authority_page.click_create_new_link
      @create_new_page.click_create_new_authority_place_local
      @place_authority_page.click_save_button
      @place_authority_page.wait_for_notification 'Term display name is required. Please enter a value.'
    end

    it 'show display name as the h1 page heading' do
      @place_authority_page.enter_place_display_name(@place_1_display_name_0, 0)
      @place_authority_page.hit_tab
      @place_authority_page.wait_until(Config.short_wait) { @place_authority_page.element_text(@place_authority_page.page_h1) == @place_1_display_name_0 }
    end

    it 'show the display name that is in the first term row' do
      @place_authority_page.add_term_grp
      @place_authority_page.enter_place_display_name(@place_1_display_name_1, 1)
      @place_authority_page.move_term_grp_top 1
      @place_authority_page.save_record
      @place_authority_page.wait_until(Config.short_wait) { @place_authority_page.element_text(@place_authority_page.page_h1) == @place_1_display_name_1 }
    end

    it 'unfold record panels' do
      @place_authority_page.uncollapse_panel_if_collapsed CorePlaceData::LOCALITY_INFO_PANEL.label
      @place_authority_page.uncollapse_panel_if_collapsed CorePlaceData::GEOREFERENCE_INFO_PANEL.label
      @place_authority_page.uncollapse_panel_if_collapsed CorePlaceData::HIERARCHY_PANEL.label
    end

    it 'fold record panels' do
      @place_authority_page.toggle_panel CorePlaceData::LOCALITY_INFO_PANEL.label
      @place_authority_page.uncollapse_panel_if_collapsed CorePlaceData::GEOREFERENCE_INFO_PANEL.label
      @place_authority_page.uncollapse_panel_if_collapsed CorePlaceData::HIERARCHY_PANEL.label
    end
  end

  context 'when being created' do

    before(:all) do
      @place_authority_page.click_create_new_link
      @create_new_page.click_create_new_authority_place_local
    end

    it('allow Terms to be added') { @place_authority_page.enter_terms @place_2 }
    it('allow Types to be added') { @place_authority_page.enter_types @place_2 }
    it('allow Ownerships to be added') {@place_authority_page.enter_ownerships @place_2}
    it('allow Place Notes to be added') {@place_authority_page.enter_place_notes @place_2}
    it('allow References to be added') {@place_authority_page.enter_references @place_2}
    it('allow Associations to be added') {@place_authority_page.enter_associations @place_2}
    it('allow Addresses to be added') {@place_authority_page.enter_addresses @place_2}

  end

  context 'once created and saved' do

    before(:all) { @place_authority_page.save_record }

    it('display the right Terms') { expect(@place_authority_page.verify_terms @place_2).to be_empty }
    it('display the right Types') { expect(@place_authority_page.verify_types @place_2).to be_empty }
    it('display the right Ownerships') { expect(@place_authority_page.verify_ownerships @place_2).to be_empty}
    it('display the right Place Notes') { expect(@place_authority_page.verify_place_notes @place_2).to be_empty }
    it('display the right References') { expect(@place_authority_page.verify_references @place_2).to be_empty }
    it('display the right Associations') { expect(@place_authority_page.verify_associations @place_2).to be_empty}
    it('display the right Addresses') { expect(@place_authority_page.verify_addresses @place_2).to be_empty }

    it 'display Terms Used in the sidebar' do
      terms_used = []
      @place_2[CorePlaceData::PLACE_TERM_GRP.name].each { |term| terms_used << term[CorePlaceData::TERM_SOURCE.name] }
      @place_2[CorePlaceData::PLACE_OWNERSHIP_GRP.name].each { |owner| terms_used << owner[CorePlaceData::OWNERSHIP_OWNER.name] }
      @place_2[CorePlaceData::PLACE_NOTE_GRP.name].each { |note| terms_used << note[CorePlaceData::PLACE_NOTE_AUTHOR.name] }
      @place_2[CorePlaceData::PLACE_REFERENCE_GRP.name].each { |ref| terms_used << ref[CorePlaceData::REFERENCE.name] }
      @place_2[CorePlaceData::PLACE_ASSOCIATED_GRP.name].each { |assoc| terms_used << assoc[CorePlaceData::ASSOCIATED_NAME.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_STATE.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_COUNTRY.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_MUNICIPALITY.name] }

      @place_authority_page.expand_sidebar_terms_used
      @search_results_page.select_size("20")
      terms_used.each { |term| @place_authority_page.when_exists(@place_authority_page.terms_used_term_link(term), 1)}
      expect(@place_authority_page.elements(@place_authority_page.terms_used_links).length).to eql(terms_used.length)
    end
  end

  context 'when being edited to add data' do

    before(:all) { @place_2 = @place_3 }

    it('allow Terms to be changed or added') { @place_authority_page.enter_terms @place_2 }
    it('allow Types to be changed or added') { @place_authority_page.enter_types @place_2 }
    it('allow Ownerships to be changed or added') {@place_authority_page.enter_ownerships @place_2}
    it('allow Place Notes to be changed or added') {@place_authority_page.enter_place_notes @place_2}
    it('allow References to be changed or added') {@place_authority_page.enter_references @place_2}
    it('allow Associations to be changed or added') {@place_authority_page.enter_associations @place_2}
    it('allow Addresses to be changed or added') {@place_authority_page.enter_addresses @place_2}
    it('allow added data to be saved') { @place_authority_page.save_record(Config.medium_wait) }

    it('display the right Terms') { expect(@place_authority_page.verify_terms @place_2).to be_empty }
    it('display the right Types') { expect(@place_authority_page.verify_types @place_2).to be_empty }
    it('display the right Ownerships') { expect(@place_authority_page.verify_ownerships @place_2).to be_empty}
    it('display the right Place Notes') { expect(@place_authority_page.verify_place_notes @place_2).to be_empty }
    it('display the right References') { expect(@place_authority_page.verify_references @place_2).to be_empty }
    it('display the right Associations') { expect(@place_authority_page.verify_associations @place_2).to be_empty}
    it('display the right Addresses') { expect(@place_authority_page.verify_addresses @place_2).to be_empty }

    it 'display the right Terms Used in the sidebar' do
      terms_used = []
      @place_2[CorePlaceData::PLACE_TERM_GRP.name].each { |term| terms_used << term[CorePlaceData::TERM_SOURCE.name] }
      @place_2[CorePlaceData::PLACE_OWNERSHIP_GRP.name].each { |owner| terms_used << owner[CorePlaceData::OWNERSHIP_OWNER.name] }
      @place_2[CorePlaceData::PLACE_NOTE_GRP.name].each { |note| terms_used << note[CorePlaceData::PLACE_NOTE_AUTHOR.name] }
      @place_2[CorePlaceData::PLACE_REFERENCE_GRP.name].each { |ref| terms_used << ref[CorePlaceData::REFERENCE.name] }
      @place_2[CorePlaceData::PLACE_ASSOCIATED_GRP.name].each { |assoc| terms_used << assoc[CorePlaceData::ASSOCIATED_NAME.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_STATE.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_COUNTRY.name] }
      @place_2[CorePlaceData::PLACE_ADDRESS_GRP.name].each { |address| terms_used << address[CorePlaceData::ADDRESS_MUNICIPALITY.name] }

      @place_authority_page.expand_sidebar_terms_used
      terms_used.each { |term| @place_authority_page.when_exists(@place_authority_page.terms_used_term_link(term), 1) }
      expect(@place_authority_page.elements(@place_authority_page.terms_used_links).length).to eql(terms_used.length)
    end

    it 'display title bar with scroll bar' do
      @place_authority_page.scroll_to_bottom
      expect(@place_authority_page.visible? @place_authority_page.page_h1).to be true
      @place_authority_page.scroll_to_top
    end
  end

  context 'when being edited to remove data' do

    before(:all) { @place_2 = @place_4 }

    it('allow Terms to be removed') { @place_authority_page.enter_terms @place_2 }
    it('allow Types to be removed') { @place_authority_page.enter_types @place_2 }
    it('allow Ownerships to be removed') { @place_authority_page.enter_ownerships @place_2 }
    it('allow Place Notes to be removed') { @place_authority_page.enter_place_notes @place_2 }
    it('allow References to be removed') { @place_authority_page.enter_references @place_2 }
    it('allow Associations to be removed') { @place_authority_page.enter_associations @place_2 }
    it('allow Addresses to be removed') { @place_authority_page.enter_addresses @place_2 }
    it('allow deleted data to be saved') { @place_authority_page.save_record(Config.medium_wait) }

    it('display the right Terms') { expect(@place_authority_page.verify_terms @place_2).to be_empty }
    it('display the right Types') { expect(@place_authority_page.verify_types @place_2).to be_empty }
    it('display the right Ownerships') { expect(@place_authority_page.verify_ownerships @place_2).to be_empty}
    it('display the right Place Notes') { expect(@place_authority_page.verify_place_notes @place_2).to be_empty }
    it('display the right References') { expect(@place_authority_page.verify_references @place_2).to be_empty }
    it('display the right Associations') { expect(@place_authority_page.verify_associations @place_2).to be_empty}
    it('display the right Addresses') { expect(@place_authority_page.verify_addresses @place_2).to be_empty }

    it 'display the right Terms Used in the sidebar' do
      @place_authority_page.expand_sidebar_terms_used
      expect(@place_authority_page.elements(@place_authority_page.terms_used_links)).to be_empty
    end
  end

  context 'when being edited' do

    it 'cannot have all display names removed' do
      @place_authority_page.enter_place_display_name('', 0)
      @place_authority_page.hit_tab
      @place_authority_page.wait_until(1) { !@place_authority_page.enabled?(@place_authority_page.save_button) }
      @place_authority_page.wait_for_notification 'Term display name is required. Please enter a value.'
    end
  end

  context 'when being deleted' do

    context 'and the authority is not in use by other records' do

      before(:all) do
        @place_authority_page.revert_record
        @place_5_display_name = "Place 5 #{test_id}"
        @place_authority_page.click_create_new_link
        @create_new_page.click_create_new_authority_place_local
        @place_authority_page.enter_place_display_name(@place_5_display_name, 0)
        @place_authority_page.save_record
      end

      it 'requires confirmation' do
        @place_authority_page.click_delete_button
        @place_authority_page.when_displayed(@place_authority_page.confirm_delete_msg_span, 1)
      end

      it 'can be canceled by clicking the Cancel button' do
        @place_authority_page.cancel_deletion
        @place_authority_page.when_not_exists(@place_authority_page.confirm_delete_msg_span, 1)
      end

      it 'can be canceled by clicking the Close button' do
        @place_authority_page.click_delete_button
        @place_authority_page.when_displayed(@place_authority_page.confirm_delete_msg_span, 1)
        @place_authority_page.click_close_button
        @place_authority_page.when_not_exists(@place_authority_page.confirm_delete_msg_span, 1)
      end

      it('can be confirmed') { @place_authority_page.delete_record(Config.medium_wait) }

      it 'prevents the term being returned in search results' do
        @search_results_page.click_search_link
        @search_page.full_text_search @place_5_display_name
        @search_results_page.when_displayed(@search_results_page.no_results_msg, Config.short_wait)
      end
    end

    context 'and the authority is in use by other records' do

      before(:all) do
        @search_results_page.click_create_new_link
        @create_new_page.click_create_new_exhibition
        @exhibition_page.enter_exhibition_num({ CoreExhibitionData::EXHIBITION_NUM.name => "Exhibition Two #{test_id}" })
        @exhibition_page.enter_venue_name(@place_0_display_name,0)
        @exhibition_page.save_record

        @search_results_page.click_create_new_link
        @create_new_page.click_create_new_exhibition
        @exhibition_page.enter_exhibition_num({ CoreExhibitionData::EXHIBITION_NUM.name => "Exhibition Three #{test_id}" })
        @exhibition_page.enter_venue_name(@place_0_display_name,0)
        @exhibition_page.save_record
      end

      it 'cannot be done if it is in use by other records' do
        @exhibition_page.expand_sidebar_terms_used
        @exhibition_page.click_sidebar_term @place_0_display_name
        @place_authority_page.click_delete_button
        @place_authority_page.when_displayed(@place_authority_page.confirm_delete_msg_span, 1)
        expect(@place_authority_page.element_text(@place_authority_page.confirm_delete_msg_span)).to eql("#{@place_0_display_name} cannot be deleted because it is used by other records.")
      end
    end
  end

  context 'when no changes have been made' do

    before(:all) do
      @place_authority_page.cancel_deletion if @place_authority_page.exists?(@place_authority_page.confirm_delete_cancel_button)
      @place_authority_page.quick_search('Places', 'All', "#{test_id}")
      @search_results_page.click_result @place_0_display_name
    end

    it 'show disabled revert buttons' do
      @place_authority_page.when_displayed(@place_authority_page.revert_button, Config.short_wait)
      expect(@place_authority_page.enabled? @place_authority_page.revert_button).to be false
    end
  end

  context 'when unsaved changes have been made' do

    before(:all) { @place_authority_page.enter_types(@place_5_type) }

    it 'offer revert buttons that reverse the changes' do
      @place_authority_page.revert_record
      expect(@place_authority_page.verify_types(@place_5_type_empty)).to be_empty
    end
  end

  context 'when saved changes have been made' do

    before(:all) do
      @place_authority_page.enter_place_notes(@place_5_note)
      @place_authority_page.save_record
    end

    it 'show disabled revert buttons' do
      @place_authority_page.when_displayed(@place_authority_page.revert_button, Config.short_wait)
      expect(@place_authority_page.enabled? @place_authority_page.revert_button).to be false
    end
  end

  context 'with unsaved changes' do

    it 'offer a Don\'t Leave button' do
      @place_authority_page.enter_types(@place_5_type)
      @place_authority_page.click_search_link
      @place_authority_page.do_not_leave_record
      expect(@place_authority_page.verify_types(@place_5_type)).to be_empty
    end

    it 'offer a Close button' do
      @place_authority_page.click_search_link
      @place_authority_page.click_close_button
      expect(@place_authority_page.verify_types(@place_5_type)).to be_empty
    end

    it 'offer a Revert and Continue button' do
      @place_authority_page.click_search_link
      @place_authority_page.revert_and_continue
      @search_page.when_exists(@search_page.search_button_two, Config.short_wait)
      @search_page.quick_search('Places', nil, "#{test_id}")
      @search_results_page.click_result @place_0_display_name
      expect(@place_authority_page.verify_types(@place_5_type_empty)).to be_empty
    end

    it 'offer a Save and Continue button' do
      @place_authority_page.enter_types(@place_5_type)
      @place_authority_page.click_search_link
      @place_authority_page.save_and_continue
      @search_page.when_exists(@search_page.search_button_two, Config.short_wait)
      @search_page.quick_search('Places', nil, "#{test_id}")
      @search_results_page.click_result @place_0_display_name
      expect(@place_authority_page.verify_types(@place_5_type)).to be_empty
    end
  end
end
