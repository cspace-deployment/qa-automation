require_relative '../spec_helper'

describe 'CollectionSpace' do

  include Logging
  include WebDriverManager

  before(:all) do
    @test = TestConfig.new Deployment::CORE
    @test.set_driver launch_browser
    @admin = @test.get_admin_user
    @login_page = LoginPage.new @test
    @create_new_page = CreateNewPage.new @test
    @search_page = SearchPage.new @test
    @search_results_page = SearchResultsPage.new @test
    @object_page = ObjectPage.new @test
    @inventory_movement_page = InventoryMovementPage.new @test

    @tango_object = {
      CoreObjectData::OBJECT_NUM.name => Time.now.to_i,
      CoreObjectData::TITLE_GRP.name => [{CoreObjectData::TITLE.name => "Tango Object"}]
    }
    @alpha_location_lmi = {
      CoreInventoryMovementData::REF_NUM.name => Time.now.to_i,
      CoreInventoryMovementData::CURRENT_LOCATION.name => "Alpha Location",
      CoreInventoryMovementData::LOCATION_DATE.name => "1700-01-01"
    }
    @bravo_location = {
      CoreInventoryMovementData::REF_NUM.name => Time.now.to_i,
      CoreInventoryMovementData::CURRENT_LOCATION.name => "Bravo Location",
      CoreInventoryMovementData::LOCATION_DATE.name => "1800-01-01"
    }
    @charlie_org = {
      CoreInventoryMovementData::REF_NUM.name => Time.now.to_i,
      CoreInventoryMovementData::CURRENT_LOCATION.name => "Charlie Organization",
      CoreInventoryMovementData::LOCATION_DATE.name => "1900-01-01"
    }

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)
  end

  after(:all) { quit_browser @test.driver }

  proc_alpha = {:xpath => '//div[@aria-colindex = "2"][@title = "Alpha Location"]'}
  proc_bravo = {:xpath => '//div[@aria-colindex = "2"][@title = "Bravo Location"]'}
  proc_charlie = {:xpath => '//div[@aria-colindex = "2"][@title = "Charlie Organization"]'}
  terms_alpha = {:xpath => '//div[@aria-colindex = "1"][@title ="Alpha Location"]'}
  terms_bravo = {:xpath => '//div[@aria-colindex = "1"][@title ="Bravo Location"]'}
  terms_charlie = {:xpath => '//div[@aria-colindex = "1"][@title = "Charlie Organization"]'}

  def current_location_locator; @object_page.input_locator_by_label("Computed current location") end
  def create_new_lmi(dataset, location, option)
    @inventory_movement_page.enter_reference_number dataset
    @inventory_movement_page.hit_tab
    @inventory_movement_page.enter_current_location(dataset, option)
    @inventory_movement_page.enter_location_date dataset
    @inventory_movement_page.save_record_only
  end

  it "Object Current Location is Created/Updated - Test 1a" do
    @search_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.create_new_object @tango_object
    @object_page.scroll_to_top
    @object_page.select_related_type "Location/Movement/Inventory"
    @object_page.click_create_new_button
    create_new_lmi(@alpha_location_lmi, "Alpha Location", 'Offsite Storage Locations')
    @inventory_movement_page.quick_search("Objects", [], "Tango Object")
    @search_results_page.click_result(0)
    @object_page.refresh_page
    @object_page.expand_sidebar_related_proc
    expect(@object_page.exists? proc_alpha).to be true
    expect(@object_page.element_value(current_location_locator)).to eql("Alpha Location")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_alpha).to be true
  end

  it "Object Current Location is Created/Updated - Test 1b" do
    @search_page.click_create_new_link
    @create_new_page.click_create_new_movement
    create_new_lmi(@bravo_location, "Bravo Location", 'Offsite Storage Locations')
    @inventory_movement_page.quick_search("Objects", [], "Tango Object")
    @search_results_page.click_result(0)
    @object_page.click_add_related_procedure
    @search_page.select_record_type_option("Location/Movement/Inventory")
    @search_page.enter_keyword("Bravo")
    @search_page.click_search_button
    @search_results_page.select_result_row('Bravo')
    @object_page.click_relate_selected_button
    @object_page.expand_sidebar_related_proc
    expect(@object_page.exists?(proc_bravo) && @object_page.exists?(proc_alpha)).to be true
    expect(@object_page.element_value(current_location_locator)).to eql("Alpha Location")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_alpha).to be true

    @object_page.refresh_page
    @object_page.when_exists(current_location_locator, Config.short_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(current_location_locator)).to eql("Bravo Location")
    @object_page.expand_sidebar_terms_used
    sleep Config.click_wait
    expect(@object_page.exists? terms_bravo).to be true
  end

  it "Object Current Location is Created/Updated - Test 1c" do
    @object_page.click_create_new_link
    @create_new_page.click_create_new_movement
    create_new_lmi(@charlie_org, "Charlie Organization", 'Local Organizations')
    @inventory_movement_page.quick_search("Objects", [], "Tango Object")
    @search_results_page.click_result(0)
    @object_page.click_movement_secondary_tab
    @object_page.click_relate_button
    @search_page.enter_keyword("Charlie")
    @search_page.click_search_button
    @search_results_page.select_result_row("Charlie Organization")
    @object_page.click_relate_selected_button
    @object_page.click_primary_record_tab
    @object_page.expand_sidebar_related_proc
    expect(@object_page.exists?(proc_charlie) && @object_page.exists?(proc_bravo) && @object_page.exists?(proc_alpha)).to be true
    expect(@object_page.element_value(current_location_locator)).to eql("Bravo Location")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_bravo).to be true

    @object_page.refresh_page
    @object_page.when_exists(current_location_locator, Config.short_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(current_location_locator)).to eql("Charlie Organization")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_charlie).to be true
  end

  it "Object Current Location is Created/Updated - Test 2" do
    @object_page.quick_search("Location/Movement/Inventory", [], "Alpha Location")
    @search_results_page.click_result(0)
    @inventory_movement_page.enter_location_date({CoreInventoryMovementData::LOCATION_DATE.name => "2000-01-01"})
    @inventory_movement_page.save_record_only
    @inventory_movement_page.expand_sidebar_related_obj
    @inventory_movement_page.click_sidebar_related_obj("Tango Object")
    @object_page.when_exists(current_location_locator, Config.short_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(current_location_locator)).to eql("Alpha Location")
    @object_page.refresh_page
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_alpha).to be true
  end

  it "Object Current Location is Updated When a Related L/M/I is Deleted - Test 3" do
    @object_page.expand_sidebar_related_proc
    @object_page.click_sidebar_related_proc("Alpha Location")
    @inventory_movement_page.delete_record
    @inventory_movement_page.quick_search("Objects", [], "Tango Object")
    @search_results_page.click_result(0)
    @object_page.refresh_page
    @object_page.expand_sidebar_related_proc
    expect(@object_page.elements(@object_page.related_proc_links).length).to eql(2)
    expect(@object_page.exists?(proc_charlie) && @object_page.exists?(proc_bravo)).to be true
    expect(@object_page.element_value(current_location_locator)).to eql("Charlie Organization")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_charlie).to be true
  end

  it "Object Current Location is Updated When Relationship to L/M/I is Deleted - Test 4" do
    @object_page.click_movement_secondary_tab
    @search_results_page.select_result_row("Charlie Organization")
    @object_page.unrelate_record
    @object_page.quick_search("Objects", [], "Tango Object")
    @search_results_page.click_result(0)
    @object_page.refresh_page
    @object_page.expand_sidebar_related_proc
    expect(@object_page.elements(@object_page.related_proc_links).length).to eql(1)
    expect(@object_page.exists? proc_bravo).to be true
    expect(@object_page.element_value(current_location_locator)).to eql("Bravo Location")
    @object_page.expand_sidebar_terms_used
    expect(@object_page.exists? terms_bravo).to be true
  end

end
