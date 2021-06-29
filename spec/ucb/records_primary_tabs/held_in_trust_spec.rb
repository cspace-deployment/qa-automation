require_relative '../../../spec_helper'

[Deployment::CORE, Deployment::PAHMA].each do |deploy|

  describe "#{deploy.name} Use of Held-in-Trust records" do

    include Logging
    include WebDriverManager

    before(:all) do
      @config = TestConfig.new deploy
      @test_id = Time.now.to_i
      @test_data = @config.held_in_trust_test_data deploy

      @config.set_driver launch_browser
      @admin = @config.get_admin_user
      @login_page = LoginPage.new @config
      @create_new_page = CreateNewPage.new @config
      @search_page = SearchPage.new @config
      @search_results_page = SearchResultsPage.new @config
      @authority_page = AuthorityPage.new @config
      @held_in_trust_page = HeldInTrustPage.new @config

      @hit_0 = @test_data[0]
      @hit_1 = @test_data[1]
      @hit_2 = @test_data[2]
      @hit_3 = @test_data[3]
      @hit_4 = @test_data[4]
      @hit_5 = @test_data[5]
      @hit_6 = @test_data[6]

      # Insert the unique test ID in the test data Held-in-Trust numbers
      [@hit_1, @hit_2, @hit_3, @hit_4, @hit_5, @hit_6].each do |hit|
        hit[CoreHeldInTrustData::HIT_NUMBER.name] = "#{hit[CoreHeldInTrustData::HIT_NUMBER.name]} #{@test_id}"
      end

      @terms_used = []

      @login_page.load_page
      @login_page.log_in(@admin.username, @admin.password)
    end

    after(:all) { quit_browser @config.driver }

    context 'when created' do

      it 'require a Held-in-Trust number' do
        @search_page.click_create_new_link
        @create_new_page.click_create_new_held_in_trust
        @held_in_trust_page.click_save_button
        @held_in_trust_page.wait_for_notification 'Held-in-Trust number is required. Please enter a value.'
      end
      if deploy != Deployment::PAHMA
        it 'allow the user to choose a generated Held-in-Trust number of a selected pattern' do
          hit_num = @held_in_trust_page.select_id_generator_option(@held_in_trust_page.hit_number_input, @held_in_trust_page.hit_number_options)
          @hit_0.merge!({ CoreHeldInTrustData::HIT_NUMBER.name => hit_num })
          expect(hit_num).not_to be_empty
        end

        it 'show the user the "last generated value" for a Held-in-Trust number' do
          # Pause to allow the last-generated-value to be updated
          @held_in_trust_page.hit_tab
          @held_in_trust_page.wait_for_element_and_click @held_in_trust_page.hit_number_input
          @held_in_trust_page.wait_until(Config.short_wait) { @held_in_trust_page.elements(@held_in_trust_page.hit_number_options).any? &:displayed? }
          sleep 2
          expect(@held_in_trust_page.elements(@held_in_trust_page.hit_number_options).first.text).to include(@hit_0[CoreHeldInTrustData::HIT_NUMBER.name])
        end

        it 'allow the user to choose an incremented Held-in-Trust number of a selected pattern' do
          @held_in_trust_page.hit_tab
          prev_hit_num = @hit_0[CoreHeldInTrustData::HIT_NUMBER.name].split(//).last.to_i
          new_hit_num = @held_in_trust_page.select_id_generator_option(@held_in_trust_page.hit_number_input, @held_in_trust_page.hit_number_options)
          last_digit = new_hit_num.split(//).last.to_i
          (prev_hit_num == 9) ? (expect(last_digit).to be_zero) : (expect(last_digit).to eql(prev_hit_num + 1))
        end
      end
    end

    context 'when being created' do

      before(:all) {
        if deploy != Deployment::PAHMA
          @held_in_trust_page.revert_record
        end
        @held_in_trust_page.show_culture_care_and_handling_form
        @held_in_trust_page.show_correspondence_form
        @held_in_trust_page.scroll_to_top
      }

      it('allow a Held-in-Trust Number to be added') { @held_in_trust_page.enter_held_in_trust_number @hit_1 }
      if deploy != Deployment::PAHMA
        it('allow a Entry Date to be added') { @held_in_trust_page.enter_entry_date @hit_1 }
      end
      it('allow Depositors to be added') do
        if deploy == Deployment::PAHMA
          @held_in_trust_page.enter_pahma_depositors @hit_1
        else
          @held_in_trust_page.enter_depositors @hit_1
        end
      end
      it('allow Agreement Statuses to be added') { @held_in_trust_page.enter_agreement_statuses @hit_1 }
      if deploy != Deployment::PAHMA
        it('allow Entry Methods to be added') { @held_in_trust_page.select_entry_methods @hit_1 }
        it('allow a Entry Reason to be added') { @held_in_trust_page.select_entry_reason @hit_1 }
      end
      it('allow Agreement Renewal Dates to be added') { @held_in_trust_page.enter_agreement_renewal_dates @hit_1 }
      it('allow a Return Date to be added') { @held_in_trust_page.enter_return_date @hit_1 }
      it("allow #{(deploy == Deployment::PAHMA) ? 'Agreement Note' : 'Entry Note'} to be added") { @held_in_trust_page.enter_entry_note @hit_1}
      it('allow Internal Approvals to be added') do
        if deploy == Deployment::PAHMA
          @held_in_trust_page.enter_pahma_internal_approvals @hit_1
        else
          @held_in_trust_page.enter_internal_approvals @hit_1
        end
      end
      it('allow External Approvals to be added') do
        if deploy == Deployment::PAHMA
          @held_in_trust_page.enter_pahma_external_approvals @hit_1
        else
          @held_in_trust_page.enter_external_approvals @hit_1
        end
      end
      it('allow Handling Preferences to be added') { @held_in_trust_page.enter_handling_preferences @hit_1 }
      it('allow Handling Limitations to be added') do
        if deploy == Deployment::PAHMA
          @held_in_trust_page.enter_pahma_handling_limitations @hit_1
        else
          @held_in_trust_page.enter_handling_limitations @hit_1
        end
      end
      it('allow Correspondences to be added') do
        if deploy == Deployment::PAHMA
          @held_in_trust_page.enter_pahma_correspondences @hit_1
        else
          @held_in_trust_page.enter_correspondences @hit_1
        end
      end
    end

    context 'once created and saved' do

      before(:all) { @held_in_trust_page.save_record }

      it('show the right Held-in-Trust Number') { @held_in_trust_page.verify_held_in_trust_number @hit_1 }
      it('show the right Depositors') { @held_in_trust_page.verify_depositors @hit_1 }
      it('show the right Agreement Statuses') { @held_in_trust_page.verify_agreement_statuses @hit_1 }
      if deploy != Deployment::PAHMA
        it('show the right Entry Date') { @held_in_trust_page.verify_entry_date @hit_1 }
        it('show the right Entry Methods') { @held_in_trust_page.verify_entry_methods @hit_1 }
        it('show the right Entry Reason') { @held_in_trust_page.verify_entry_reason @hit_1 }
      end
      it('show the right Agreement Renewal Dates') { @held_in_trust_page.verify_agreement_renewal_dates @hit_1 }
      it('show the right Return Date') { @held_in_trust_page.verify_return_date @hit_1 }
      it('show the right Agreement Note') { @held_in_trust_page.verify_agreement_note @hit_1 }
      it("show the right #{(deploy == Deployment::PAHMA) ? 'Agreement Note' : 'Entry Note'}") { @held_in_trust_page.verify_entry_note @hit_1}
      it('show the right Internal Approvals') { @held_in_trust_page.verify_internal_approvals @hit_1 }
      it('show the right External Approvals') { @held_in_trust_page.verify_external_approvals @hit_1 }
      it('show the right Handling Preferences') { @held_in_trust_page.verify_handling_preferences @hit_1 }
      it('show the right Handling Limitations') { @held_in_trust_page.verify_handling_limitations @hit_1 }
      it('show the right Correspondences') { @held_in_trust_page.verify_correspondences @hit_1 }

      if deploy == Deployment::PAHMA
        it 'shows the right Agreement Date when Agreement Status is "agreed"' do
          expected_date = "#{@hit_1[CoreHeldInTrustData::AGREEMENT_STATUS_GRP.name][1][CoreHeldInTrustData::STATUS_DATE.name]}"
          expect(@held_in_trust_page.element_value @held_in_trust_page.pahma_agreement_date_input).to eql(expected_date)
        end
      end

      it 'shows the Held-in-Trust Number and the Depositor Group Name in the procedure header' do
        expected_heading = "#{@hit_1[CoreHeldInTrustData::HIT_NUMBER.name]} – #{@hit_1[CoreHeldInTrustData::DEPOSITOR_GRP.name][0][CoreHeldInTrustData::DEPOSITOR_NAME.name]}"
        expect(@held_in_trust_page.element_text @held_in_trust_page.page_h1).to eql(expected_heading)
      end

      it 'shows the Held-in-Trust Number and the first Depositor Group Name in the procedure header if multiple terms' do
        @held_in_trust_page.move_depositor_grp_top 1
        @held_in_trust_page.save_record
        expected_heading = "#{@hit_1[CoreHeldInTrustData::HIT_NUMBER.name]} – #{@hit_1[CoreHeldInTrustData::DEPOSITOR_GRP.name][1][CoreHeldInTrustData::DEPOSITOR_NAME.name]}"
        @held_in_trust_page.wait_until(Config.short_wait) { @held_in_trust_page.element_text(@held_in_trust_page.page_h1) == expected_heading }
      end

      #[NOTE]: tests below commented out to allow following tests to work while Terms Used sidebar rows do not display properly
=begin
      it 'show the right Terms used in the sidebar' do
        @hit_1[CoreHeldInTrustData::DEPOSITOR_GRP.name].each { |depositor| @terms_used << depositor[CoreHeldInTrustData::DEPOSITOR_NAME.name] }
        @hit_1[CoreHeldInTrustData::DEPOSITOR_GRP.name].each { |depositor| @terms_used << depositor[CoreHeldInTrustData::DEPOSITOR_CONTACT.name] }
        @hit_1[CoreHeldInTrustData::INTERNAL_APPROVAL_GRPS.name].each { |approval| @terms_used << approval[CoreHeldInTrustData::INTERNAL_APPROVAL_INDIVIDUAL.name] }
        @hit_1[CoreHeldInTrustData::EXTERNAL_APPROVAL_GRPS.name].each { |approval| @terms_used << approval[CoreHeldInTrustData::EXTERNAL_APPROVAL_INDIVIDUAL.name] }
        @hit_1[CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name].each { |limitations| @terms_used << limitations[CoreHeldInTrustData::HANDLING_REQUESTOR.name] }
        @hit_1[CoreHeldInTrustData::HANDLING_LIMITATIONS_GRP.name].each { |limitations| @terms_used << limitations[CoreHeldInTrustData::HANDLING_BEHALF.name] }
        @hit_1[CoreHeldInTrustData::CORRESPONDENCE_GRP.name].each { |correspondences| @terms_used << correspondences[CoreHeldInTrustData::CORRESPONDENCE_SENDER.name] }
        @hit_1[CoreHeldInTrustData::CORRESPONDENCE_GRP.name].each { |correspondences| @terms_used << correspondences[CoreHeldInTrustData::CORRESPONDENCE_RECIPIENT.name] }

        @terms_used.compact!

        @held_in_trust_page.show_twenty_terms
        errors = []
        @terms_used.each do |term|
          @held_in_trust_page.attempt_action(errors, "Term #{term} not found") do
            @held_in_trust_page.when_exists(@held_in_trust_page.terms_used_term_link(term), 1)
          end
        end
        @held_in_trust_page.wait_until(1, "Expected errors #{errors} to be empty") { errors.empty? }
      end

      it 'provide links to Terms used records' do
        hit_url = @held_in_trust_page.url
        @terms_used.each do |term|
          @held_in_trust_page.get(hit_url) unless @held_in_trust_page.url == hit_url
          @held_in_trust_page.click_sidebar_term term
          @authority_page.wait_until(Config.short_wait) { @authority_page.page_title.include? term }
          @authority_page.expand_sidebar_used_by
          @authority_page.click_sidebar_used_by @hit_1[CoreHeldInTrustData::HIT_NUMBER.name]
          @held_in_trust_page.wait_until(Config.short_wait) { @held_in_trust_page.page_title.include? @hit_1[CoreHeldInTrustData::HIT_NUMBER.name] }
        end
      end
=end

    end

    context 'when edited' do

      before(:all) { @held_in_trust_page.scroll_to_top }

      it('allow the Held-in-Trust Number to be edited') { @held_in_trust_page.enter_held_in_trust_number @hit_2 }
      if deploy != Deployment::PAHMA
        it('allow an Entry Date to be removed') { @held_in_trust_page.enter_entry_date @hit_2 }
      end
      it('allow Depositors to be removed') { @held_in_trust_page.enter_pahma_depositors @hit_2 }
      it('allow Agreement Statuses to be removed') { @held_in_trust_page.enter_agreement_statuses @hit_2 }
      if deploy != Deployment::PAHMA
        it('allow Entry Methods to be removed') { @held_in_trust_page.select_entry_methods @hit_2 }
        it('allow an Entry Reason to be removed') { @held_in_trust_page.select_entry_reason @hit_2 }
      end
      it('allow Agreement Renewal Dates to be removed') { @held_in_trust_page.enter_agreement_renewal_dates @hit_2 }
      it('allow a Return Date to be removed') { @held_in_trust_page.enter_return_date @hit_2 }
      it("allow an #{(deploy == Deployment::PAHMA) ? 'Agreement Note' : 'Entry Note'} to be removed") { @held_in_trust_page.enter_entry_note @hit_2 }
      it('allow Internal Approvals to be removed') { @held_in_trust_page.enter_pahma_internal_approvals @hit_2 }
      it('allow External Approvals to be removed') { @held_in_trust_page.enter_pahma_external_approvals @hit_2 }
      it('allow Handling Preferences to be removed') { @held_in_trust_page.enter_handling_preferences @hit_2 }
      it('allow Handling Limitations to be removed') { @held_in_trust_page.enter_pahma_handling_limitations @hit_2 }
      it('allow Correspondences to be removed') { @held_in_trust_page.enter_pahma_correspondences @hit_2 }
      it('allow deleted data to be saved') { @held_in_trust_page.save_record }

      it('show the right Held-in-Trust Number') { @held_in_trust_page.verify_held_in_trust_number @hit_2 }
      it('show the right Depositors') { @held_in_trust_page.verify_depositors @hit_2 }
      it('show the right Agreement Statuses') { @held_in_trust_page.verify_agreement_statuses @hit_2 }
      if deploy != Deployment::PAHMA
        it('show the right Entry Date') { @held_in_trust_page.verify_entry_date @hit_2 }
        it('show the right Entry Methods') { @held_in_trust_page.verify_entry_methods @hit_2 }
        it('show the right Entry Reason') { @held_in_trust_page.verify_entry_reason @hit_2 }
      end
      it('show the right Agreement Renewal Dates') { @held_in_trust_page.verify_agreement_renewal_dates @hit_2 }
      it('show the right Return Date') { @held_in_trust_page.verify_return_date @hit_2 }
      it("show the right #{(deploy == Deployment::PAHMA) ? 'Agreement Note' : 'Entry Note'}") { @held_in_trust_page.verify_entry_note @hit_2 }
      it('show the right Internal Approvals') { @held_in_trust_page.verify_internal_approvals @hit_2 }
      it('show the right External Approvals') { @held_in_trust_page.verify_external_approvals @hit_2 }
      it('show the right Handling Preferences') { @held_in_trust_page.verify_handling_preferences @hit_2 }
      it('show the right Handling Limitations') { @held_in_trust_page.verify_handling_limitations @hit_2 }
      it('show the right Correspondences') { @held_in_trust_page.verify_correspondences @hit_2 }

      it 'shows the Held-in-Trust Number and the Title in the procedure header' do
        expected_heading = "#{@hit_2[CoreHeldInTrustData::HIT_NUMBER.name]}"
        expect(@held_in_trust_page.element_text @held_in_trust_page.page_h1).to eql(expected_heading)
      end

      it 'show the right Terms used in the sidebar' do
        @held_in_trust_page.expand_sidebar_terms_used
        expect(@held_in_trust_page.elements @held_in_trust_page.terms_used_links).to be_empty
      end

      it 'do not allow the Held-in-Trust number to be removed' do
        @held_in_trust_page.enter_held_in_trust_number({ CoreHeldInTrustData::HIT_NUMBER.name => '' })
        @held_in_trust_page.hit_tab
        @held_in_trust_page.wait_for_notification 'Held-in-Trust number is required. Please enter a value.'
        expect(@held_in_trust_page.enabled? @held_in_trust_page.save_button).to be false
      end
    end

    context 'when being deleted' do

      context 'and the procedure is not in use by other records' do

        before(:all) do
          @held_in_trust_page.revert_record
          @held_in_trust_page.click_create_new_link
          @create_new_page.click_create_new_held_in_trust
          @held_in_trust_page.enter_held_in_trust_number @hit_3
          @held_in_trust_page.save_record
        end

        it 'requires confirmation' do
          @held_in_trust_page.click_delete_button
          @held_in_trust_page.when_displayed(@held_in_trust_page.confirm_delete_msg_span, 1)
        end

        it 'can be canceled by clicking the Cancel button' do
          @held_in_trust_page.cancel_deletion
          @held_in_trust_page.when_not_exists(@held_in_trust_page.confirm_delete_msg_span, 1)
        end

        it 'can be canceled by clicking the Close button' do
          @held_in_trust_page.click_delete_button
          @held_in_trust_page.when_displayed(@held_in_trust_page.confirm_delete_msg_span, 1)
          @held_in_trust_page.click_close_button
          @held_in_trust_page.when_not_exists(@held_in_trust_page.confirm_delete_msg_span, 1)
        end

        it('can be deleted') { @held_in_trust_page.delete_record }

        it 'prevents the procedure being returned in search results' do
          @search_results_page.click_search_link
          @search_page.quick_search('Held-in-Trust', nil, @hit_3[CoreHeldInTrustData::HIT_NUMBER.name])
          @search_results_page.when_displayed(@search_results_page.no_results_msg, Config.short_wait)
        end
      end

      context 'and the procedure is associated with other procedure records' do

        before(:all) do
          @search_results_page.click_create_new_link
          @create_new_page.click_create_new_held_in_trust
          @held_in_trust_page.enter_held_in_trust_number @hit_4
          @held_in_trust_page.save_record

          @held_in_trust_page.click_create_new_link
          @create_new_page.click_create_new_held_in_trust
          @held_in_trust_page.enter_held_in_trust_number @hit_5
          @held_in_trust_page.save_record

          @held_in_trust_page.click_add_related_procedure
          @search_page.full_text_search @hit_4[CoreHeldInTrustData::HIT_NUMBER.name]
          @search_results_page.wait_for_results
          @search_results_page.relate_records [@hit_4[CoreHeldInTrustData::HIT_NUMBER.name]]
          @held_in_trust_page.save_record
        end

        it('can be deleted successfully') { @held_in_trust_page.delete_record }
      end
    end

    context 'when no changes have been made' do

      before(:all) do
        @search_page.click_create_new_link
        @create_new_page.click_create_new_held_in_trust
        @held_in_trust_page.enter_held_in_trust_number @hit_6
        @held_in_trust_page.save_record
      end

      it('show disabled revert buttons') { expect(@held_in_trust_page.enabled? @held_in_trust_page.revert_button).to be false }
    end

    context 'when unsaved changes have been made' do

      before(:all) do
        @held_in_trust_page.enter_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Unsaved changes' })
        @held_in_trust_page.hit_tab
      end

      it 'offer revert buttons that reverse the changes' do
        @held_in_trust_page.revert_record
        @held_in_trust_page.verify_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => '' })
      end
    end

    context 'when saved changes have been made' do

      before(:all) do
        @held_in_trust_page.enter_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Saved change' })
        @held_in_trust_page.save_record
        @hit_6.merge!({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Saved change' })
      end

      it 'show disabled revert buttons' do
        @held_in_trust_page.when_displayed(@held_in_trust_page.revert_button, Config.short_wait)
        expect(@held_in_trust_page.enabled? @held_in_trust_page.revert_button).to be false
      end
    end

    context 'with unsaved changes' do

      it 'offer a Don\'t Leave button' do
        @held_in_trust_page.enter_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Unsaved change' })
        @held_in_trust_page.click_search_link
        @held_in_trust_page.do_not_leave_record
        @held_in_trust_page.verify_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Unsaved change' })
      end

      it 'offer a Close button' do
        @held_in_trust_page.click_search_link
        @held_in_trust_page.click_close_button
        @held_in_trust_page.verify_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Unsaved change' })
      end

      it 'offer a Revert and Continue button' do
        @held_in_trust_page.click_search_link
        @held_in_trust_page.revert_and_continue
        @search_page.when_exists(@search_page.search_button_two, Config.short_wait)
        @search_page.quick_search('Held-in-Trust', nil, @hit_6[CoreHeldInTrustData::HIT_NUMBER.name])
        @search_results_page.click_result @hit_6[CoreHeldInTrustData::HIT_NUMBER.name]
        @held_in_trust_page.verify_entry_note @hit_6
      end

      it 'offer a Save and Continue button' do
        @held_in_trust_page.enter_entry_note({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Saved agreement note' })
        @held_in_trust_page.click_search_link
        @held_in_trust_page.save_and_continue
        @hit_6.merge!({ CoreHeldInTrustData::ENTRY_NOTE.name => 'Saved agreement note' })
        @search_page.when_exists(@search_page.search_button_two, Config.short_wait)
        @search_page.quick_search('Held-in-Trust', nil, @hit_6[CoreHeldInTrustData::HIT_NUMBER.name])
        @search_results_page.click_result @hit_6[CoreHeldInTrustData::HIT_NUMBER.name]
        @held_in_trust_page.verify_entry_note @hit_6
      end
    end

    context 'when the user clicks the fold button for the Held-in-Trust Info form' do

      before { @held_in_trust_page.hide_hit_info_form }

      it('hides the form') { @held_in_trust_page.when_not_exists(@held_in_trust_page.hit_number_input, 1) }
    end

    context 'when the user clicks the unfold button for the Held-in-Trust form' do

      before { @held_in_trust_page.show_hit_info_form }

      it('unhides the form') { @held_in_trust_page.when_displayed(@held_in_trust_page.hit_number_input, 1) }
    end

  end
end
