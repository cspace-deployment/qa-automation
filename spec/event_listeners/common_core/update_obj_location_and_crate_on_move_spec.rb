require_relative '../../../spec_helper'

[Deployment::PAHMA, Deployment::BAMPFA].each do |deploy|
  describe "#{deploy.name}"  do

    include Logging
    include WebDriverManager

    before(:all) do
      @test = TestConfig.new deploy
      @test.set_driver launch_browser
      @admin = @test.get_admin_user
      @login_page = LoginPage.new @test
      @create_new_page = CreateNewPage.new @test
      @search_page = SearchPage.new @test
      @search_results_page = SearchResultsPage.new @test
      @object_page = ObjectPage.new @test
      @movement_page = InventoryMovementPage.new @test

      @id_num = Time.now.to_i
      @object_1 = {
        PAHMAObjectData::OBJECT_NUM.name => @id_num,
        BAMPFAObjectData::ID_PREFIX.name => @id_num
      }
      @movement_1 = {
        PAHMAInventoryMovementData::CURRENT_LOCATION.name => "movement 1",
        PAHMAInventoryMovementData::CRATE.name => "crate 1",
        PAHMAInventoryMovementData::LOCATION_DATE.name => (Date.today - 1).to_s
      }
      @movement_4 = {
        PAHMAInventoryMovementData::CURRENT_LOCATION.name => "movement 4",
        PAHMAInventoryMovementData::CRATE.name => "crate 4",
        PAHMAInventoryMovementData::LOCATION_DATE.name => Date.today.to_s
      }

      @login_page.load_page
      @login_page.log_in(@admin.username, @admin.password)

      @search_page.click_create_new_link
      @create_new_page.click_create_new_object
      if deploy == Deployment::PAHMA
        @object_page.enter_pahma_object_id_data @object_1
      else
        @object_page.enter_id_number @object_1
      end
      @object_page.save_record
    end

    after(:all) { quit_browser @test.driver }

    def create_movement(data, deployment)
      @search_page.click_create_new_link
      @create_new_page.click_create_new_movement
      (deployment == Deployment::PAHMA) ? @movement_page.create_unlocked_pahma_movement(data) : @movement_page.create_unlocked_bampfa_movement(data)
    end

    def update_current_location(data, deployment)
      (deployment == Deployment::PAHMA) ? @movement_page.enter_pahma_current_location_only(data) : @movement_page.enter_bampfa_current_location_only(data)
      @movement_page.save_record_only
    end

    it "Relate a Cataloging/Object record to a LMI record" do
      create_movement(@movement_1, deploy)
      @movement_page.click_add_related_object
      @search_page.full_text_search @id_num
      @search_results_page.wait_for_results
      @search_results_page.relate_records([@object_1[PAHMAObjectData::OBJECT_NUM.name]])
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_location @movement_1
    end

    it "Update the location of the Movement record" do
      @movement_1[PAHMAInventoryMovementData::CURRENT_LOCATION.name] = "movement 1a"
      @object_page.expand_sidebar_related_proc
      @object_page.click_sidebar_related_proc("movement 1")
      update_current_location(@movement_1, deploy)
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_location @movement_1
      @object_page.wait_for_pahma_crate @movement_1
    end

    it "Update the crate of the Movement record" do
      @movement_1[PAHMAInventoryMovementData::CRATE.name] = "crate 1a"
      @object_page.expand_sidebar_related_proc
      @object_page.click_sidebar_related_proc("movement 1")
      @movement_page.enter_pahma_crate_only @movement_1
      @movement_page.save_record_only
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_crate @movement_1
    end

    it "Relate a new Movement record with the existing Cataloging record" do
      create_movement(@movement_4, deploy)
      @movement_page.click_add_related_object
      @search_page.full_text_search @id_num
      @search_results_page.wait_for_results
      @search_results_page.relate_records([@object_1[PAHMAObjectData::OBJECT_NUM.name]])
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_location @movement_4
      @object_page.wait_for_pahma_crate @movement_4
    end

    it "Update the 'Location date' of a Movement record to be the most recent" do
      @movement_1[PAHMAInventoryMovementData::LOCATION_DATE.name] = (Date.today + 1).to_s
      @object_page.expand_sidebar_related_proc
      @object_page.click_sidebar_related_proc("movement 1")
      @movement_page.enter_location_date @movement_1
      @movement_page.save_record_only
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_location @movement_1
      @object_page.wait_for_pahma_crate @movement_1
    end

    it "Modify/update one of two related Movement records that have the same 'Location date' value" do
      @movement_4[PAHMAInventoryMovementData::NOTE.name] = "note update"
      @movement_4[PAHMAInventoryMovementData::LOCATION_DATE.name] = (Date.today + 1).to_s
      @object_page.expand_sidebar_related_proc
      @object_page.click_sidebar_related_proc("movement 4")
      @movement_page.enter_location_date @movement_4
      @movement_page.enter_pahma_note @movement_4
      @movement_page.save_record_only
      @movement_page.expand_sidebar_related_obj
      @movement_page.click_sidebar_related_obj @object_1[PAHMAObjectData::OBJECT_NUM.name]
      @object_page.wait_for_pahma_location @movement_4
      @object_page.wait_for_pahma_crate @movement_4
    end

  end
end
