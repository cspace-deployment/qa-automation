require_relative '../spec_helper'

describe 'CollectionSpace' do

  include Logging
  include WebDriverManager

  before(:all) do
    @test = TestConfig.new Deployment::CORE
    @test.set_driver launch_browser
    @admin = @test.get_admin_user
    @login_page = LoginPage.new @test
    @acquisition_page = AcquisitionPage.new @test
    @create_new_page = CreateNewPage.new @test
    @search_page = SearchPage.new @test
    @search_results_page = SearchResultsPage.new @test
    @object_page = ObjectPage.new @test
    @person_auth_page = PersonPage.new @test

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)

    @test_1_object = {
      CoreObjectData::OBJECT_NUM.name => Time.now.to_i
    }
    @test_7_object = {
      CoreObjectData::OBJECT_NUM.name => Time.now.to_i * 3
    }
    @Record_A = {
      CoreObjectData::OBJECT_NUM.name => Time.now.to_i * 4,
      CoreObjectData::OBJ_NAME_GRP.name => [CoreObjectData::OBJ_NAME_NAME.name => "Name A"]
    }
    @QA_TEST_record = {
      CoreObjectData::OBJECT_NUM.name => "QA TEST"
    }
    @related_obj = {
      CoreObjectData::OBJECT_NUM.name => Time.now.to_i * 6
    }
    @related_proc = {
      CoreAcquisitionData::ACQUIS_REF_NUM.name => Time.now.to_i * 5
    }

    [@QA_TEST_record, @related_proc, @related_obj].each do |record|
      @search_page.click_create_new_link
      if record == @related_proc
        @create_new_page.click_create_new_acquisition
        @acquisition_page.create_new_acquisition record
      else
        @create_new_page.click_create_new_object
        @object_page.create_new_object record
      end
    end
  end

  after(:all) { quit_browser @test.driver }

  person_a = {CoreObjectData::CONTENT_PERSON.name => "Person A"}
  person_b = {CoreObjectData::CONTENT_PERSON.name => "Person B"}
  add_persons = {CoreObjectData::CONTENT_PERSONS.name => [person_a, person_b]}
  title_a = {CoreObjectData::TITLE_GRP.name => [{CoreObjectData::TITLE.name => "Title A"}]}
  mmddyyyy = Time.now.strftime("%-m/%-d/%Y")
  def sidebar_record_text(label, identifier, index); @object_page.element(:xpath => "//section[contains(.,'#{label}')]//a[contains(., '#{identifier}')]//div[#{index}]")  end

  it "checks if the pages work in dialog" do
    @object_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.create_new_object @test_7_object
    @object_page.click_add_related_object
    @object_page.close_notifications_bar
    @search_page.click_modal_clear_button
    @search_page.click_search_and_wait_for_results @search_results_page
    expect(/1(–)\d+ of [1-9]\d+ records found/ === @object_page.element_text(@search_results_page.records_found_header_text)).to be true
    expect(@object_page.element_value(@search_results_page.footer_select_size_input_locator).to_i >= 0).to be true
    expect(@object_page.element_text(@search_results_page.num_per_row_lower)).to eql("per page")

    [20, 40].each do |variation|
      @object_page.scroll_to_element(@search_results_page.footer_select_size_input_locator)
      @search_results_page.select_size("#{variation}")
      @search_results_page.wait_for_results
      expect(@object_page.element_value(@search_results_page.footer_select_size_input_locator).to_i).to eql(variation)
      expect(@object_page.elements(@search_results_page.result_rows).length()).to eql(variation)
      expect(@object_page.exists? @search_results_page.navigation_pages).to be true

      @object_page.wait_for_element_and_click(@search_results_page.navigation_right_arrow)
      @search_results_page.wait_for_results
      expect(@object_page.enabled? @search_results_page.navigation_page_index_button(2)).to be false

      @object_page.wait_for_element_and_click(@search_results_page.navigation_page_index_button("last()".gsub('"', '')))
      expect(@object_page.enabled? @search_results_page.navigation_page_index_button("last()".gsub('"', ''))).to be false
      expect(@object_page.enabled? @search_results_page.navigation_right_arrow).to be false

      @object_page.wait_for_element_and_click(@search_results_page.navigation_left_arrow)
      expect(@object_page.enabled? @search_results_page.navigation_page_index_button("last()-1".gsub('"', ''))).to be false

      @object_page.wait_for_element_and_click(@search_results_page.navigation_page_index_button(1))
      expect(@object_page.enabled? @search_results_page.navigation_page_index_button(1)).to be false
      expect(@object_page.enabled? @search_results_page.navigation_left_arrow).to be false
    end
  end

  it "test adding multiple to current record from dialog" do
    relate_1 = @search_results_page.select_result_nth_row(3)
    @object_page.wait_for_element_and_click(@search_results_page.navigation_right_arrow)
    relate_2 = @search_results_page.select_result_nth_row(2)
    @object_page.click_relate_selected_button
    @object_page.when_not_exists(@object_page.dialog_box, Config.short_wait)
    @object_page.when_displayed(@object_page.section_header_text("Related Objects"), Config.medium_wait)
    @object_page.expand_sidebar_related_obj
    expect(@object_page.exists? @object_page.related_obj_link(relate_1)).to be true
    expect(@object_page.exists? @object_page.related_obj_link(relate_2)).to be true
    expect(@object_page.element_text(@object_page.section_header_text("Related Objects"))).to include("Related Objects: 2")
  end

  it "test pivoting" do
    pivot_record_id = @object_page.element_text(@object_page.related_obj_nth_link(1))
    @object_page.click_sidebar_nth_related_obj(1)
    @object_page.when_displayed(@object_page.page_h1, Config.medium_wait)
    expect(@object_page.element_text(@object_page.page_h1)).to include(pivot_record_id)
  end

  it "empty list on a new page" do
    @object_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.create_new_object @test_1_object
    @object_page.show_sidebar
    text = @object_page.element_text(@object_page.section_header_text("Related Objects"))
    expect(text.include? "Related Objects: 0").to be true

    @object_page.expand_sidebar_related_obj
    expect(@object_page.elements(@object_page.related_obj_links)).to be_empty
  end

  it "checks if possible to add object via dialog" do
    @object_page.click_add_related_object
    expect(@object_page.exists? @object_page.dialog_box).to be true
    expect(@object_page.exists? @object_page.inactive_page_check).to be true

    @search_page.click_search_and_wait_for_results @search_results_page
    expect(@object_page.enabled? @search_results_page.relate_selected_button).to be false
    @search_results_page.select_result_row(@related_obj[CoreObjectData::OBJECT_NUM.name])
    @object_page.click_relate_selected_button
    @object_page.when_not_exists(@object_page.dialog_box, Config.short_wait)
    @object_page.when_displayed(@object_page.related_obj_links, Config.short_wait)
    expect(@object_page.exists? @object_page.related_obj_link(@related_obj[CoreObjectData::OBJECT_NUM.name])).to be true
  end

  it "checks if search functionality works" do
    @object_page.click_add_related_object
    expect(@object_page.exists? @object_page.dialog_box).to be true
    expect(@object_page.exists? @object_page.inactive_page_check).to be true

    @search_page.enter_keyword("QA TEST")
    @search_page.click_search_and_wait_for_results @search_results_page
    expect(@object_page.elements(@search_results_page.result_rows)).not_to be_empty
    @object_page.click_close_button
  end

  it "test correct display of summary in object records" do
    @object_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.create_new_object @Record_A
    time_stamp_A = @object_page.element_text(@object_page.notifications_timestamp).gsub(/\:\d{2}(?=\s)/, '')
    @object_page.click_add_related_object
    @search_page.click_search_and_wait_for_results @search_results_page
    @search_results_page.select_result_row(@related_obj[CoreObjectData::OBJECT_NUM.name])
    @object_page.click_relate_selected_button
    @object_page.click_sidebar_related_obj(@related_obj[CoreObjectData::OBJECT_NUM.name])
    @object_page.expand_sidebar_related_obj
    record_A_row = @object_page.related_obj_link(@Record_A[CoreObjectData::OBJECT_NUM.name])
    expect(@object_page.exists? record_A_row).to be true
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Name A")
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 3).attribute('title')).to eql(mmddyyyy + ", " +time_stamp_A)

    @object_page.click_sidebar_related_obj(@Record_A[CoreObjectData::OBJECT_NUM.name])
    @object_page.enter_titles(title_a)
    @object_page.save_record
    time_stamp_A = @object_page.element_text(@object_page.notifications_timestamp).gsub(/\:\d{2}(?=\s)/,'')
    @object_page.click_sidebar_related_obj(@related_obj[CoreObjectData::OBJECT_NUM.name])
    @object_page.expand_sidebar_related_obj
    expect(@object_page.exists? record_A_row).to be true
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Title A")
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 3).attribute('title')).to eql(mmddyyyy + ", " + time_stamp_A)
  end

  it "test correct display of summary in procedural records" do
    @Record_A[CoreObjectData::OBJECT_NUM.name] = Time.now.to_i / 4
    @object_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.create_new_object @Record_A
    time_stamp_A = @object_page.element_text(@object_page.notifications_timestamp).gsub(/\:\d{2}(?=\s)/,'')
    @object_page.click_add_related_procedure
    @search_page.click_search_and_wait_for_results @search_results_page
    @search_results_page.select_result_row(@related_proc[CoreAcquisitionData::ACQUIS_REF_NUM.name])
    @object_page.click_relate_selected_button
    @object_page.expand_sidebar_related_proc
    @object_page.click_sidebar_related_proc(@related_proc[CoreAcquisitionData::ACQUIS_REF_NUM.name])
    @acquisition_page.expand_sidebar_related_obj
    record_A_row = @acquisition_page.related_obj_link(@Record_A[CoreObjectData::OBJECT_NUM.name])
    expect(@acquisition_page.exists? record_A_row).to be true
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Name A")
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 3).attribute('title')).to eql(mmddyyyy + ", " + time_stamp_A)

    @acquisition_page.expand_sidebar_related_obj
    @acquisition_page.click_sidebar_related_obj(@Record_A[CoreObjectData::OBJECT_NUM.name])
    @object_page.enter_titles(title_a)
    @object_page.save_record
    time_stamp_A = @object_page.element_text(@object_page.notifications_timestamp).gsub(/\:\d{2}(?=\s)/,'')
    @object_page.expand_sidebar_related_proc
    @object_page.click_sidebar_related_proc(@related_proc[CoreAcquisitionData::ACQUIS_REF_NUM.name])
    @acquisition_page.when_exists(record_A_row, Config.click_wait)
    expect(@acquisition_page.exists? record_A_row).to be true
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Title A")
    expect(sidebar_record_text("Related Objects", @Record_A[CoreObjectData::OBJECT_NUM.name], 3).attribute('title')).to eql(mmddyyyy + ", " + time_stamp_A)
  end

  it "test correct display of summary on authority pages" do
    @Record_A[CoreObjectData::OBJECT_NUM.name] = Time.now.to_i / 7
    @object_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.enter_core_object_id_data @Record_A
    @object_page.enter_content_person(add_persons)
    @object_page.save_record
    @object_page.scroll_to_top
    @object_page.expand_sidebar_terms_used
    @object_page.click_sidebar_term("Person A")
    @person_auth_page.when_displayed(@person_auth_page.page_h1, Config.short_wait)
    expect(@person_auth_page.element_text(@person_auth_page.page_h1)).to eql("Person A")
    @person_auth_page.expand_sidebar_used_by
    expect(@person_auth_page.exists? @person_auth_page.used_by_link(@Record_A[CoreObjectData::OBJECT_NUM.name])).to be true
    expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Name A")
    expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 4).attribute('title')).to eql("Content person")

    @person_auth_page.click_sidebar_used_by(@Record_A[CoreObjectData::OBJECT_NUM.name])
    @object_page.enter_titles(title_a)
    @object_page.save_record
    @object_page.click_sidebar_term("Person A")
    @person_auth_page.when_displayed(@person_auth_page.used_by_links, Config.medium_wait)
    expect(@person_auth_page.exists? @person_auth_page.used_by_link(@Record_A[CoreObjectData::OBJECT_NUM.name])).to be true
    expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 1).attribute('title').to_i).to eql(@Record_A[CoreObjectData::OBJECT_NUM.name])
    #expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 2).attribute('title')).to eql("Title A")
    expect(sidebar_record_text("Used By", @Record_A[CoreObjectData::OBJECT_NUM.name], 4).attribute('title')).to eql("Content person")
  end

  it "test if the close button works" do
    @person_auth_page.click_sidebar_used_by(@Record_A[CoreObjectData::OBJECT_NUM.name])
    orig = @object_page.element_text(@object_page.section_header_text("Related Object"))
    @object_page.click_add_related_object
    @object_page.click_close_button
    expect(@object_page.exists? @object_page.dialog_box).to be false
    expect(@object_page.element_text(@object_page.timestamp)).not_to eql("Editing")
    expect(@object_page.element_text(@object_page.section_header_text("Related Object"))).to eql(orig)
  end

  it "test if the close button works using Esc key" do
    orig = @object_page.element_text(@object_page.section_header_text("Related Object"))
    @object_page.click_add_related_object
    @object_page.hit_escape
    @object_page.when_not_exists(@object_page.dialog_box, Config.short_wait)
    expect(@object_page.element_text(@object_page.timestamp)).not_to eql("Editing")
    expect(@object_page.element_text(@object_page.section_header_text("Related Object"))).to eql(orig)
  end

  it "test adding a relation to self" do
    @object_page.click_add_related_object
    @search_page.full_text_search @Record_A[CoreObjectData::OBJECT_NUM.name]
    expect(@search_results_page.row_exists?(@Record_A[CoreObjectData::OBJECT_NUM.name])).to be true
    expect(@search_results_page.exists? @search_results_page.result_row_checkbox(@Record_A[CoreObjectData::OBJECT_NUM.name])).to be false
    @object_page.click_close_button
  end
  
  it "test adding multiple copies of a record" do
    @object_page.hide_notifications_bar
    @object_page.click_add_related_object
    @search_page.click_modal_clear_button
    @search_page.click_search_button
    @search_results_page.select_result_row(@related_obj[CoreObjectData::OBJECT_NUM.name])
    @search_results_page.click_relate_selected_button
    @object_page.when_not_exists(@object_page.dialog_box, Config.short_wait)
    expect(@object_page.exists? @object_page.related_obj_link(@related_obj[CoreObjectData::OBJECT_NUM.name])).to be true

    @object_page.click_add_related_object
    @search_page.click_search_button
    expect(@search_results_page.row_exists?(@related_obj[CoreObjectData::OBJECT_NUM.name])).to be true
    expect(@search_results_page.exists? @search_results_page.result_row_checkbox(@related_obj[CoreObjectData::OBJECT_NUM.name])).to be false
  end

end
