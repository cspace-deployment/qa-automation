require_relative '../../../spec_helper'

describe 'BOTGARDEN' do

  include Logging
  include WebDriverManager

  before(:all) do
    @test = TestConfig.new Deployment::BOTGARDEN
    @test.set_driver launch_browser

    @admin = @test.get_admin_user
    @concept_page = ConceptPage.new @test
    @create_new_page = CreateNewPage.new @test
    @login_page = LoginPage.new @test
    @object_page = ObjectPage.new @test
    @search_page = SearchPage.new @test
    @search_results_page = SearchResultsPage.new @test
    @taxon_page = TaxonPage.new @test

    @login_page.load_page
    @login_page.log_in(@admin.username, @admin.password)
  end

  after(:all) { quit_browser @test.driver }

  red_dot_record = "N/A"
  scientific_name = "test"+Time.now.to_i.to_s
  obj_rec = {
    BOTGARDENObjectData::OBJECT_NUM.name => Time.now.to_i,
    BOTGARDENObjectData::TAXON_IDENT_GRP.name => [{BOTGARDENObjectData::TAXON_NAME.name => scientific_name}]
  }

  it "find conservation category value with set qualifier field" do
    @search_page.quick_search("Concepts", "Conservation Category", "red dot on label")
    @search_results_page.wait_for_results
    red_dot_record = @search_results_page.botgarden_select_result_nth_row(1)
    @concept_page.verify_qualifier_name("red dot on label", 0)
  end

  it "create a new object record for #{scientific_name} taxon" do
    @concept_page.click_create_new_link
    @create_new_page.click_create_new_object
    @object_page.enter_botgarden_object_id_data obj_rec
    summary = "#{obj_rec[BOTGARDENObjectData::OBJECT_NUM.name]} – #{scientific_name}"
    @object_page.click_save_button
    @object_page.wait_for_notification("Saving #{summary}")
    @object_page.wait_for_notification("Saved #{summary}")
    @object_page.verify_values_match(summary, @object_page.element_text(@object_page.page_h1))

    #value in Rare field should be "no"; if yes, enter a unique Taxon name for scientific_name
    #and re-run test (confirm that Rare = "no")
    expect(@object_page.element_value(@object_page.botgarden_object_rarity)).to eql("no")
  end

  it "set Conservation category field to term with Qualifier" do
    @object_page.expand_sidebar_terms_used
    @object_page.click_sidebar_term(scientific_name)
    taxon = {BOTGARDENTaxonData::PLANT_ATTRIB_GRP.name => [{BOTGARDENTaxonData::CONSERV_CATEG.name => red_dot_record}]}
    @taxon_page.enter_botgarden_attributes(taxon)
    @taxon_page.click_save_button
    summary = "#{scientific_name}" # no TERM_STATUS value created for new test taxon
    @object_page.verify_values_match(scientific_name, @taxon_page.element_text(@taxon_page.page_h1))
    @taxon_page.wait_for_notification("Saving #{summary}")
    @taxon_page.wait_for_notification("Saved #{summary}")
    expect(@taxon_page.exists? @taxon_page.terms_used_term_link(red_dot_record))
  end

  it "confirm that the Rare field has been set to 'yes'" do
    @taxon_page.hide_notifications_bar
    @taxon_page.scroll_to_top
    @taxon_page.expand_sidebar_used_by
    @taxon_page.click_sidebar_used_by(obj_rec[BOTGARDENObjectData::OBJECT_NUM.name])
    @object_page.when_exists(@object_page.botgarden_object_rarity, Config.short_wait)
    sleep Config.click_wait
    expect(@object_page.element_value(@object_page.botgarden_object_rarity)).to eql("yes")
  end

end
