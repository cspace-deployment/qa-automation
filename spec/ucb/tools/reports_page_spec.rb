require_relative '../../../spec_helper'

describe 'Reports' do

  include Logging
  include WebDriverManager

  test_run = TestConfig.new Deployment::CORE
  test_id = Time.now.to_i

  before(:all) do
    test_run.set_driver launch_browser
    @admin = test_run.get_admin_user
    @login_page = test_run.get_page CoreLoginPage
    @create_new_page = test_run.get_page CoreCreateNewPage
    @reports_page = test_run.get_page CoreInvocablesPage
    @search_page = test_run.get_page CoreSearchPage
    @tools_page = test_run.get_page CoreToolsPage
    @admin_page = test_run.get_page CoreAdminPage
    @search_results_page = test_run.get_page CoreSearchResultsPage

    @test_0 = {
        CoreInvocablesData::INVOCABLE_NAME.name => 'Use of Collections Approval Status Report',
        CoreInvocablesData::INVOCABLE_DESC.name =>  'Lists Use of Collections requests with a value in the \'Authorization\' field group, filtered by authorized by, authorization status, and/or date requested range. Displays the record number, title, requested date, completed date, authorization date, authorizer and authorization status. Available output formats: PDF, CSV, MS Word.',
    }

    @test_1 = {
        CoreInvocablesData::INVOCABLE_NAME.name => 'Use of Collections by Requester and/or Object Report',
        CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label => 'Runs on',
        CoreInvocablesData::INVOCABLE_REPORT_LIST_PANEL.label => 'Reports'
    }

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)

    @search_page.click_admin_link


    # Initial Setup of Roles
    @admin_page.click_roles_link
    if not @admin_page.role_exists("NO_REPORT_PERMISSIONS")
      @admin_page.create_user_role("NO_REPORT_PERMISSIONS", "No Permissions to run or invoke reports", {"Users" => "D", "Roles" => "W"})
    end

    if not @admin_page.role_exists("CAN_EDIT_CAN_RUN")
      @admin_page.create_user_role("CAN_EDIT_CAN_RUN", "A role with CRUDL permissions", {"Report Invocations" => "D", "Reports" => "D", "Users" => "D", "Roles" => "W"})
      # @admin_page.save_record
    end

    if not @admin_page.role_exists("CANT_EDIT_CAN_RUN")
      @admin_page.create_user_role("CANT_EDIT_CAN_RUN", "A role with only Invocation permissions", {"Report Invocations" => "D", "Reports" => "R", "Users" => "D", "Roles" => "W"})

    end

    if not @admin_page.role_exists("CAN_EDIT_CANT_RUN")
      @admin_page.create_user_role("CAN_EDIT_CANT_RUN", "A role with only Edit permissions permissions", {"Reports" => "D", "Users" => "D", "Roles" => "W"})
    end

    # Account Setup
    @admin_page.click_users_link
    if not @admin_page.user_exists("Reporter")
      @admin_page.create_new_user("report-test@email.edu", "Reporter", "Reporter", "CAN_EDIT_CAN_RUN")
    end

    @search_page.log_out
    @login_page.log_in("report-test@email.edu", "Reporter")

    # @search_page.click_tools_link
    # @tools_page.click_reports_link
  end

  after(:all) { quit_browser test_run.driver}

  describe 'An user with editor and invoker permissions interacting with the reports page tab' do

    context 'report UI interactions' do
      it 'should be able to change the current user role to Report Editor' do

        @search_page.click_admin_link
        @admin_page.click_users_link

        @admin_page.change_user_role("Reporter", "NO_REPORT_PERMISSIONS", "CAN_EDIT_CAN_RUN")
        # currently the UI doesn't allow us to check which role is selected...
        # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
        @search_page.log_out
        @login_page.log_in("report-test@email.edu", "Reporter")

        @search_page.click_tools_link
        @tools_page.click_reports_link
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
        expect(@search_results_page.row_exists? @test_1[CoreInvocablesData::INVOCABLE_NAME.name]).to be true
      end

      it 'should be able to bring up a modal and dismiss it using the escape key' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @reports_page.hit_escape
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the cancel button' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @tools_page.click_cancel_modal_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the close button' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @reports_page.click_close_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end

      it 'should be able to collapse and uncollapse the Reports and Runs on panels' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        #runs on
        # uncollapse it
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be false

        # collapse it
        @reports_page.toggle_panel CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be true


        # uncollapse it
        @reports_page.toggle_panel CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.is_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label).to be false


        #Reports
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_REPORT_LIST_PANEL.label
        expect(@reports_page.is_collapsed CoreInvocablesData::INVOCABLE_REPORT_LIST_PANEL.label).to be false
      end
    end

    context 'checking ability to click buttons and fill fields' do

      it 'should be able to change the name of a report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@reports_page.enabled? @reports_page.invocable_name_locator).to be true
        expect(@reports_page.enabled? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true

        @reports_page.edit_invocable_name_and_save("This is a new test name")
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_name_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

        @reports_page.edit_invocable_name_and_save(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_name_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

      end

      it 'should be able to change the description of a report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
        expect(@reports_page.enabled? @reports_page.invocable_description_locator).to be true
        expect(@reports_page.enabled? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true

        @reports_page.edit_description_and_save("This is a new test description")
        expect(@reports_page.element_value @reports_page.invocable_description_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])

        @reports_page.edit_description_and_save(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
        expect(@reports_page.element_value @reports_page.invocable_description_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
      end

      it 'should not be able to alter the Jasper file associated with the report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

        expect(@reports_page.enabled? @reports_page.invocable_report_filename_locator).to be false
        expect(@reports_page.enabled? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to alter the report contexts' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.enabled? @reports_page.invocable_no_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_single_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_group_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_list_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to alter the record types or default MIME type' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.enabled? @reports_page.invocable_report_doctypes_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_mimetype_locator).to be false
        expect(@reports_page.enabled? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end
    end




  end

  describe 'A user with only edit permissions interacting with the UI' do

    it 'should be able to change the current user role to Report Editor' do

      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("Reporter", "CAN_EDIT_CAN_RUN", "CAN_EDIT_CANT_RUN")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
      @search_page.log_out
      @login_page.log_in("report-test@email.edu", "Reporter")

      @search_page.click_tools_link
      @tools_page.click_reports_link
    end

    it 'should be able to change the name of a report' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      sleep 1
      expect(@reports_page.element_value @reports_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
      expect(@reports_page.enabled? @reports_page.invocable_name_locator).to be true
      expect(@reports_page.enabled? @reports_page.revert_button).to be false
      expect(@reports_page.exists? @reports_page.run_button).to be false

      @reports_page.edit_invocable_name_and_save("This is a new test name")
      sleep 1
      expect(@reports_page.element_value @reports_page.invocable_name_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

      @reports_page.edit_invocable_name_and_save(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
      sleep 1
      expect(@reports_page.element_value @reports_page.invocable_name_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])

    end

    it 'should be able to change the description of a report' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      sleep 1
      expect(@reports_page.element_value @reports_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
      expect(@reports_page.enabled? @reports_page.invocable_description_locator).to be true
      expect(@reports_page.enabled? @reports_page.revert_button).to be false
      expect(@reports_page.exists? @reports_page.run_button).to be false

      @reports_page.edit_description_and_save("This is a new test description")
      expect(@reports_page.element_value @reports_page.invocable_description_locator).not_to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])

      @reports_page.edit_description_and_save(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
      expect(@reports_page.element_value @reports_page.invocable_description_locator).to eq(@test_0[CoreInvocablesData::INVOCABLE_DESC.name])
    end

    it 'should not be able to alter the Jasper file associated with the report' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

      expect(@reports_page.enabled? @reports_page.invocable_report_filename_locator).to be false
      expect(@reports_page.enabled? @reports_page.revert_button).to be false
      expect(@reports_page.exists? @reports_page.run_button).to be false
    end

    it 'should not be able to alter the report contexts' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
      expect(@reports_page.enabled? @reports_page.invocable_no_ctx_locator).to be false
      expect(@reports_page.enabled? @reports_page.invocable_single_ctx_locator).to be false
      expect(@reports_page.enabled? @reports_page.invocable_group_ctx_locator).to be false
      expect(@reports_page.enabled? @reports_page.invocable_list_ctx_locator).to be false
      expect(@reports_page.enabled? @reports_page.revert_button).to be false
      expect(@reports_page.exists? @reports_page.run_button).to be false
    end

    it 'should not be able to alter the record types or default MIME type' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
      expect(@reports_page.enabled? @reports_page.invocable_report_doctypes_locator).to be false
      expect(@reports_page.enabled? @reports_page.invocable_mimetype_locator).to be false
      expect(@reports_page.enabled? @reports_page.revert_button).to be false
      expect(@reports_page.exists? @reports_page.run_button).to be false
    end

    it 'should not be able to run the report' do
      @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
      expect(@reports_page.exists? @reports_page.run_button).to be false
    end

  end

  describe 'A user with only invoking permissions interacting with the UI' do
    it 'should be able to change the current user role to Report Editor' do
      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("Reporter", "CAN_EDIT_CANT_RUN", "CANT_EDIT_CAN_RUN")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
      @search_page.log_out
      @login_page.log_in("report-test@email.edu", "Reporter")

      @search_page.click_tools_link
      @tools_page.click_reports_link
    end

    context 'checking inability to fill fields' do

      it 'should not be able to change the name of a report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_name_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_NAME.name])
        expect(@reports_page.enabled? @reports_page.invocable_name_locator).to be false
        expect(@reports_page.exists? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to change the description of a report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        sleep 1
        expect(@reports_page.element_value @reports_page.invocable_description_locator).to eql(@test_0[CoreInvocablesData::INVOCABLE_DESC.name ])
        expect(@reports_page.enabled? @reports_page.invocable_description_locator).to be false
        expect(@reports_page.exists? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to alter the Jasper file associated with the report' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label

        expect(@reports_page.enabled? @reports_page.invocable_report_filename_locator).to be false
        expect(@reports_page.exists? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to alter the report contexts' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.enabled? @reports_page.invocable_no_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_single_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_group_ctx_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_list_ctx_locator).to be false
        expect(@reports_page.exists? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end

      it 'should not be able to alter the record types or default MIME type' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        @reports_page.uncollapse_panel_if_collapsed CoreInvocablesData::INVOCABLE_RUNS_ON_PANEL.label
        expect(@reports_page.enabled? @reports_page.invocable_report_doctypes_locator).to be false
        expect(@reports_page.enabled? @reports_page.invocable_mimetype_locator).to be false
        expect(@reports_page.exists? @reports_page.revert_button).to be false
        expect(@reports_page.enabled? @reports_page.run_button).to be true
      end
    end

    context 'checking ability to click the run button and dismiss modals' do
      it 'should be able to bring up a modal and dismiss it using the escape key' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        expect(@reports_page.enabled? @reports_page.run_button).to be true

        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @reports_page.hit_escape
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the cancel button' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]

        expect(@reports_page.exists? @reports_page.run_button).to be true
        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @tools_page.click_cancel_modal_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end

      it 'should be able to bring up a modal and dismiss it using the close button' do
        @reports_page.click_invocable @test_0[CoreInvocablesData::INVOCABLE_NAME.name]
        expect(@reports_page.exists? @reports_page.run_button).to be true

        @tools_page.click_run_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be true # for the modal to exist
        @reports_page.click_close_button
        expect(@reports_page.exists? @reports_page.invocable_modal).to be false
      end
    end
  end

  describe 'A user with no permissions interacting with the UI' do

    it 'should be able to change the current user role to Report Editor' do
      @search_page.click_admin_link
      @admin_page.click_users_link

      @admin_page.change_user_role("Reporter", "CANT_EDIT_CAN_RUN", "NO_REPORT_PERMISSIONS")
      # currently the UI doesn't allow us to check which role is selected...
      # expect(@admin_page.role_locator("CAN_EDIT_CAN_RUN")).to be true
      @search_page.log_out
      @login_page.log_in("report-test@email.edu", "Reporter")
    end

    it 'should not be able to see the reports toolbar' do
      @search_page.click_tools_link
      expect(@tools_page.exists? @tools_page.reports_link).to be false
    end
  end
end

