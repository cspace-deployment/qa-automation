require_relative '../../../spec_helper'

describe 'BOTGARDEN' do

  include Logging
  include WebDriverManager

  before(:all) do
    @test = TestConfig.new Deployment::BOTGARDEN
    @test.set_driver launch_browser
    @test_data = @test.update_dead_flag_listener_data Deployment::BOTGARDEN

    #Initialize pages
    @admin = @test.get_admin_user
    @current_loc_page = InventoryMovementPage.new @test
    @create_new_page = CreateNewPage.new @test
    @login_page = LoginPage.new @test
    @object_page = ObjectPage.new @test
    @search_page = SearchPage.new @test
    @search_results_page = SearchResultsPage.new @test

    #Initialize test data
    @obj_record = {
      BOTGARDENObjectData::OBJECT_NUM.name => Time.now.to_i,
      BOTGARDENObjectData::TAXON_IDENT_GRP.name => [{BOTGARDENObjectData::TAXON_NAME.name => "Test Taxon "+Time.now.to_i.to_s}]
    }
    @current_loc_1 = @test_data["locations"][0]
    @current_loc_2 = @test_data["locations"][1]
    @current_loc_3 = @test_data["locations"][2]
    @new_action = @test_data["action"][0]

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)
  end

  after(:all) { quit_browser @test.driver }

  it "create object, current location records" do
    @search_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.enter_botgarden_accession_num @obj_record
    @object_page.enter_botgarden_taxonomics @obj_record
    @object_page.save_record

    @object_page.click_current_locations_tab
    [@current_loc_1, @current_loc_2].each do |record|
      @current_loc_page.click_create_new_button
      @current_loc_page.enter_botgarden_current_location_data record
      @current_loc_page.save_record
    end

    @current_loc_page.when_exists(@current_loc_page.nth_result_row(2), Config.short_wait)
    expect(@current_loc_page.elements(@current_loc_page.related_panel_rows).length).to eql(2)
    expect(@current_loc_page.element_text(@current_loc_page.related_record_h1)).to eql("Asian – #{@current_loc_2[BOTGARDENCurrentLocationData::ACTION_DATE.name]}")
    expect(@current_loc_page.elements(@current_loc_page.related_proc_links).length).to eql(2)

    @object_page.click_primary_record_tab
    @object_page.when_displayed(@object_page.botgarden_dead_flag_input, Config.short_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(@object_page.botgarden_dead_flag_input)).to eql("no")
    expect(@object_page.enabled? @object_page.botgarden_dead_flag_input).to be false
    expect(@object_page.elements(@object_page.related_proc_links).length).to eql(2)
  end

  it "Dead flag updates when all Current Locations marked Dead" do
    [[1, "no"], [0,"yes"]].each do |records_left, dead_flag|
      @object_page.close_notifications_bar
      @object_page.click_sidebar_related_proc("Asian")
      @current_loc_page.select_botgarden_action_code(@new_action)
      @current_loc_page.save_record
      @current_loc_page.wait_for_notification("Deleted")
      expect(@current_loc_page.elements(@search_results_page.result_rows).length).to eql(records_left)

      @current_loc_page.wait_for_element_and_click(@search_results_page.title_bar_record_link(@obj_record[BOTGARDENObjectData::OBJECT_NUM.name]))
      @object_page.when_displayed(@object_page.botgarden_dead_flag_input, Config.medium_wait)
      sleep Config.click_wait
      expect(@object_page.element_value(@object_page.botgarden_dead_flag_input)).to eql(dead_flag)
    end
    expect(@object_page.elements(@object_page.related_proc_links).length).to eql(0)
  end

  it "Dead flag resets to no when new related Current Location added to Accession marked Dead" do
    @object_page.click_current_locations_tab
    @current_loc_page.click_create_new_button
    @current_loc_page.enter_botgarden_current_location_data @current_loc_3
    @current_loc_page.save_record
    @current_loc_page.click_primary_record_tab
    @object_page.refresh_page
    @object_page.when_displayed(@object_page.botgarden_dead_flag_input, Config.medium_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(@object_page.botgarden_dead_flag_input)).to eql("no")
  end

end
