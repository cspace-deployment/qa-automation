require_relative '../../../spec_helper'

describe 'Batch' do

include Logging
include WebDriverManager

test_run = TestConfig.new Deployment::CORE
test_id = Time.now.to_i

before(:all) do
  test_run.set_driver launch_browser
  @admin = test_run.get_admin_user
  @login_page = test_run.get_page CoreLoginPage
  @create_new_page = test_run.get_page CoreCreateNewPage
  @batch_page = test_run.get_page CoreInvocablesPage
  @search_page = test_run.get_page CoreSearchPage
  @tools_page = test_run.get_page CoreToolsPage
  @admin_page = test_run.get_page CoreAdminPage
  @search_results_page = test_run.get_page CoreSearchResultsPage

  @test_0 = {
    CoreInvocablesData::INVOCABLE_NAME.name => 'Merge Authority Items',
    CoreInvocablesData::INVOCABLE_DESC.name =>  'Merges two or more authority items. The "Target" record is the record that the rest of the records will be merged into.',
    CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label => 'Runs on',
    CoreInvocablesData::INVOCABLE_BATCH_LIST_PANEL.label => 'Data Updates'
  }

  @test_1 = {
      CoreInvocablesData::INVOCABLE_NAME.name => 'A batch that doesn\'t exist',
      CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label => 'Runs on',
  }

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)

    @search_page.click_admin_link


    # Initial Setup of Roles
    @admin_page.click_roles_link
    if not @admin_page.role_exists("NO_BATCH_PERMISSIONS")
      @admin_page.create_user_role("NO_BATCH_PERMISSIONS", "No Permissions to run or invoke data updates", {"Users" => "D", "Roles" => "W", "Term Lists" => "R"})
    end

    if not @admin_page.role_exists("CAN_EDIT_CAN_RUN_UPDATES")
      @admin_page.create_user_role("CAN_EDIT_CAN_RUN_UPDATES", "A role with CRUDL permissions", {"Data Update Invocations" => "D", "Data Updates" => "D", "Users" => "D", "Roles" => "W"})
      # @admin_page.save_record
    end

    if not @admin_page.role_exists("CANT_EDIT_CAN_RUN_UPDATES")
      @admin_page.create_user_role("CANT_EDIT_CAN_RUN_UPDATES", "A role with only Invocation permissions", {"Data Update Invocations" => "D", "Data Updates" => "R", "Users" => "D", "Roles" => "W"})

    end

    if not @admin_page.role_exists("CAN_EDIT_CANT_RUN_UPDATES")
      @admin_page.create_user_role("CAN_EDIT_CANT_RUN_UPDATES", "A role with only Edit permissions permissions", {"Data Updates" => "D", "Users" => "D", "Roles" => "W"})
    end

    # Account Setup
    @admin_page.click_users_link
    if not @admin_page.user_exists("DataUpdater")
      @admin_page.create_new_user("batch-test@email.edu", "DataUpdater", "DataUpdates", "CAN_EDIT_CAN_RUN_UPDATES")
    end

    @search_page.log_out
    @login_page.log_in("batch-test@email.edu", "DataUpdates")
  end

  after(:all) { quit_browser test_run.driver}

  describe 'An user with editor and invoker permissions interacting with the data updatess page tab' do

    context 'Data update UI interactions' do
      it 'should be able to change the current user role to data update editor' do

        @search_page.click_admin_link
        @admin_page.click_users_link

        @admin_page.change_user_role("DataUpdater", "NO_BATCH_PERMISSIONS", "CAN_EDIT_CAN_RUN_UPDATES")
        # currently the UI doesn't allow us to check which role is selected...
        # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
        @search_page.log_out
        @login_page.log_in("batch-test@email.edu", "DataUpdates")

        @search_page.click_tools_link
        @tools_page.click_batch_link
      end

      it 'should be able to filter based on a search' do
        @search_results_page.fill_search_filter_bar(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@search_results_page.row_exists? @test_0[CoreInvocablesData::INVOCABLE_NAME.name]).to be true
        expect(@search_results_page.row_exists? @test_1[CoreInvocablesData::INVOCABLE_NAME.name]).to be false
      end

      it 'should show all results when the clear button is clicked' do
        @search_results_page.fill_search_filter_bar(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@search_results_page.row_exists? @test_0[CoreInvocablesData::INVOCABLE_NAME.name]).to be true
        expect(@search_results_page.row_exists? @test_1[CoreInvocablesData::INVOCABLE_NAME.name]).to be false

        @tools_page.click_clear_button
        expect(@search_results_page.row_exists? @test_0[CoreInvocablesData::INVOCABLE_NAME.name]).to be true
        expect(@search_results_page.row_exists? @test_1[CoreInvocablesData::INVOCABLE_NAME.name]).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the escape key' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @batch_page.hit_escape
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the cancel button' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @tools_page.click_cancel_modal_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the close button' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @batch_page.click_close_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end

      it 'should be able to collapse and uncollapse the data updates and Runs on panels' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        #runs on
        # uncollapse it
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be false

        # collapse it
        @batch_page.toggle_panel CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be true


        # uncollapse it
        @batch_page.toggle_panel CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be false


        #data updates
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_REPORT_LIST_PANEL.label
        expect(@batch_page.is_collapsed CoreInvocablesData::INVOCABLE_REPORT_LIST_PANEL.label).to be false
      end
    end

    context 'checking ability to click buttons and fill fields' do

      it 'should be able to change the name of a data update' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@batch_page.enabled? @batch_page.invocable_name_locator).to be true
        expect(@batch_page.enabled? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true

        @batch_page.edit_invocable_name_and_save("This is a new test name")
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_name_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

        @batch_page.edit_invocable_name_and_save(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_name_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

      end

      it 'should be able to change the description of a data update' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
        expect(@batch_page.enabled? @batch_page.invocable_description_locator).to be true
        expect(@batch_page.enabled? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true

        @batch_page.edit_description_and_save("This is a new test description")
        expect(@batch_page.element_value @batch_page.invocable_description_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])

        @batch_page.edit_description_and_save(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
        expect(@batch_page.element_value @batch_page.invocable_description_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
      end

      it 'should not be able to alter the Java file associated with the data update' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

        expect(@batch_page.enabled? @batch_page.invocable_classname_locator).to be false
        expect(@batch_page.enabled? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to alter the data update contexts' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.enabled? @batch_page.invocable_no_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_single_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_group_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_list_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to alter the record types' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.enabled? @batch_page.invocable_batch_doctypes_locator).to be false
        expect(@batch_page.enabled? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end
    end




  end

  describe 'A user with only edit permissions interacting with the UI' do

    it 'should be able to change the current user role to data update Editor' do

      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("DataUpdater", "CAN_EDIT_CAN_RUN_UPDATES", "CAN_EDIT_CANT_RUN_UPDATES")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
      @search_page.log_out
      @login_page.log_in("batch-test@email.edu", "DataUpdates")

      @search_page.click_tools_link
      @tools_page.click_batch_link
    end

    it 'should be able to change the name of a report' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      sleep 1
      expect(@batch_page.element_value @batch_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
      expect(@batch_page.enabled? @batch_page.invocable_name_locator).to be true
      expect(@batch_page.enabled? @batch_page.revert_button).to be false
      expect(@batch_page.exists? @batch_page.run_button).to be false

      @batch_page.edit_invocable_name_and_save("This is a new test name")
      sleep 1
      expect(@batch_page.element_value @batch_page.invocable_name_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

      @batch_page.edit_invocable_name_and_save(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
      sleep 1
      expect(@batch_page.element_value @batch_page.invocable_name_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

    end

    it 'should be able to change the description of a report' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      sleep 1
      expect(@batch_page.element_value @batch_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
      expect(@batch_page.enabled? @batch_page.invocable_description_locator).to be true
      expect(@batch_page.enabled? @batch_page.revert_button).to be false
      expect(@batch_page.exists? @batch_page.run_button).to be false

      @batch_page.edit_description_and_save("This is a new test description")
      expect(@batch_page.element_value @batch_page.invocable_description_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])

      @batch_page.edit_description_and_save(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
      expect(@batch_page.element_value @batch_page.invocable_description_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
    end

    it 'should not be able to alter the Java class associated with the report' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

      expect(@batch_page.enabled? @batch_page.invocable_classname_locator).to be false
      expect(@batch_page.enabled? @batch_page.revert_button).to be false
      expect(@batch_page.exists? @batch_page.run_button).to be false
    end

    it 'should not be able to alter the report contexts' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
      expect(@batch_page.enabled? @batch_page.invocable_no_ctx_locator).to be false
      expect(@batch_page.enabled? @batch_page.invocable_single_ctx_locator).to be false
      expect(@batch_page.enabled? @batch_page.invocable_group_ctx_locator).to be false
      expect(@batch_page.enabled? @batch_page.invocable_list_ctx_locator).to be false
      expect(@batch_page.enabled? @batch_page.revert_button).to be false
      expect(@batch_page.exists? @batch_page.run_button).to be false
    end

    it 'should not be able to alter the record types' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
      expect(@batch_page.enabled? @batch_page.invocable_batch_doctypes_locator).to be false
      expect(@batch_page.enabled? @batch_page.revert_button).to be false
      expect(@batch_page.exists? @batch_page.run_button).to be false
    end

    it 'should not be able to run the report' do
      @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      expect(@batch_page.exists? @batch_page.run_button).to be false
    end

  end

  describe 'A user with only invoking permissions interacting with the UI' do
    it 'should be able to change the current user role to Report Editor' do
      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("DataUpdater", "CAN_EDIT_CANT_RUN_UPDATES", "CANT_EDIT_CAN_RUN_UPDATES")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
      @search_page.log_out
      @login_page.log_in("batch-test@email.edu", "DataUpdates")

      @search_page.click_tools_link
      @tools_page.click_batch_link
    end

    context 'checking inability to fill fields' do

      it 'should not be able to change the name of a report' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@batch_page.enabled? @batch_page.invocable_name_locator).to be false
        expect(@batch_page.exists? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to change the description of a report' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@batch_page.element_value @batch_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
        expect(@batch_page.enabled? @batch_page.invocable_description_locator).to be false
        expect(@batch_page.exists? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to alter the Jasper file associated with the data update' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

        expect(@batch_page.enabled? @batch_page.invocable_classname_locator).to be false
        expect(@batch_page.exists? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to alter the report contexts' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.enabled? @batch_page.invocable_no_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_single_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_group_ctx_locator).to be false
        expect(@batch_page.enabled? @batch_page.invocable_list_ctx_locator).to be false
        expect(@batch_page.exists? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end

      it 'should not be able to alter the record types' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @batch_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@batch_page.enabled? @batch_page.invocable_batch_doctypes_locator).to be false
        expect(@batch_page.exists? @batch_page.revert_button).to be false
        expect(@batch_page.enabled? @batch_page.run_button).to be true
      end
    end

    context 'checking ability to click the run button and dismiss modals' do
      it 'should be able to bring up a modal and dismiss it using the escape key' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        expect(@batch_page.enabled? @batch_page.run_button).to be true

        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @batch_page.hit_escape
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the cancel button' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        expect(@batch_page.exists? @batch_page.run_button).to be true
        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @tools_page.click_cancel_modal_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the close button' do
        @batch_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        expect(@batch_page.exists? @batch_page.run_button).to be true

        @tools_page.click_run_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be true # for the modal to exist
        @batch_page.click_close_button
        expect(@batch_page.exists? @batch_page.invocable_modal).to be false
      end
    end
  end

  describe 'A user with no permissions interacting with the UI' do

    it 'should be able to change the current user role to Report Editor' do
      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("DataUpdater", "CANT_EDIT_CAN_RUN_UPDATES", "NO_BATCH_PERMISSIONS")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("NO_BATCH_PERMISSIONS")).to be true
      @search_page.log_out
      @login_page.log_in("batch-test@email.edu", "DataUpdates")
    end

    it 'should not be able to see the data updates toolbar' do
      @search_page.click_tools_link
      expect(@tools_page.exists? @tools_page.batch_link).to be false
    end
  end
end

