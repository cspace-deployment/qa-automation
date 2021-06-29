class CreateNewPage

  include Logging
  include Page
  include CollectionSpacePages

  def object_link; {:id => 'collectionobject'} end
  def acquisition_link; {:id => 'acquisition'} end
  def exhibition_link; {:id => 'exhibition'} end
  def held_in_trust_link; {:id => 'hit'} end
  def movement_link; {:id => 'movement'} end
  def use_of_collections_link; {:id => 'uoc'} end
  def authority_org_local_link; {:id => 'organization/local'} end
  def authority_org_ulan_link; {:id => 'organization/ulan'} end
  def condition_check_link; {:id => 'conditioncheck'} end
  def conservation_link; {:id => 'conservation'} end
  def group_link; {:id => 'group'} end
  def intake_link; {:id => 'intake'} end
  def loan_in_link; {:id => 'loanin'} end
  def loan_out_link; {:id => 'loanout'} end
  def media_handling_link; {:id => 'media'} end
  def nagpra_claim_link; {:id => 'claim'} end
  def osteology_link; {:id => 'osteology'} end
  def object_exit_link; {:id => 'objectexit'} end
  def valuation_control_link; {:id => 'valuation'} end
  def authority_citation_local_link; {:id => 'citation/local'} end
  def authority_citation_worldcat_link; {:id => 'citation/worldcat'} end
  def authority_concept_activity_link; {:id => 'concept/activity'} end
  def authority_concept_arch_culture_link; {:id => 'concept/archculture'} end
  def authority_concept_associated_link; {:id => 'concept/associated'} end
  def authority_concept_ethno_culture_link; {:id => 'concept/ethculture'} end
  def authority_concept_ethno_file_code_link; {:id => 'concept/ethusecode'} end
  def authority_concept_material_link; {:id => 'concept/material'} end
  def authority_concept_nomenclature_link; {:id => 'concept/nomenclature'} end
  def authority_concept_object_class_link; {:id => 'concept/objectclass'} end
  def authority_concept_object_name_link; {:id => 'concept/objectname'} end
  def authority_concept_occasion_link; {:id => 'concept/occasion'} end
  def authority_person_local_link; {:id => 'person/local'} end
  def authority_person_ulan_link; {:id => 'person/ulan'} end
  def authority_place_local_link; {:id => 'place/local'} end
  def authority_place_tgn_link; {:id => 'place/tgn'} end
  def authority_storage_crate_link; {:id => 'location/crate'} end
  def authority_storage_local_link; {:id => 'location/local'} end
  def authority_storage_offsite_link; {:id => 'location/offsite'} end
  def authority_taxon_default_link; {:id => 'taxon/local'} end
  def authority_work_local_link; {:id => 'work/local'} end
  def authority_work_cona_link; {:id => 'work/cona'} end

  # Loads the Create New page with a given base URL
  # @param [String] base_url
  def load_page(base_url)
    start = Time.now
    get "#{base_url}/create"
    wait_for_title 'Create New', start
  end

  # Clicks the link to create a new collection object
  def click_create_new_object
    wait_for_page_and_click object_link
  end

  # Clicks the link to create a new acquisition record
  def click_create_new_acquisition
    wait_for_page_and_click acquisition_link
  end

  # Clicks the link to create a new inventory/movement record
  def click_create_new_movement
    wait_for_page_and_click movement_link
  end

  # Clicks the link to create a new media handling record
  def click_create_new_media
    wait_for_page_and_click media_handling_link
  end

  # Clicks the link to create a new use of collections procedure
  def click_create_new_use_of_collections
    wait_for_page_and_click use_of_collections_link
  end

  # Clicks the link to create a new exhibition record
  def click_create_new_exhibition
    wait_for_page_and_click exhibition_link
  end

  # Clicks the links to create a new held in trust record
  def click_create_new_held_in_trust
    wait_for_page_and_click held_in_trust_link
  end

  # Clicks the link to create a new Local organization
  def click_create_new_org_local
    wait_for_page_and_click authority_org_local_link
  end

  # Clicks the ULAN link to create an organization
  def click_create_new_org_ulan
    wait_for_element_and_click authority_org_ulan_link
  end

  # Clicks the link to create a new condition check
  def click_create_new_condition_check
    wait_for_element_and_click condition_check_link
  end

  # Clicks the link to create a new conservation
  def click_create_new_conservation
    wait_for_element_and_click conservation_link
  end

  # Clicks the link to create a new group record
  def click_create_new_group
    wait_for_element_and_click group_link
  end

  # Clicks the link to create a new intake record
  def click_create_new_intake
    wait_for_element_and_click intake_link
  end

  # Clicks the link to create a new loan in record
  def click_create_new_loan_in
    wait_for_element_and_click loan_in_link
  end

  # Clicks the link to create a new loan out record
  def click_create_new_loan_out
    wait_for_element_and_click loan_out_link
  end

  # Clicks the link to create a new media handling record
  def click_create_new_media_handling
    wait_for_element_and_click media_handling_link
  end

  def click_create_new_nagpra_claim
    wait_for_element_and_click nagpra_claim_link
  end

  # Clicks the link to create a new object exit record
  def click_create_new_object_exit
    wait_for_element_and_click object_exit_link
  end

  def click_create_new_osteology
    wait_for_element_and_click osteology_link
  end

  # Clicks the link to create a new valuation control record
  def click_create_new_valuation_control
    wait_for_element_and_click valuation_control_link
  end

  # Clicks the link to create a new local citation record
  def click_create_new_authority_citation_local
    wait_for_element_and_click authority_citation_local_link
  end

  # Clicks the link to create a new worldcat citation record
  def click_create_new_authority_citation_world
    wait_for_element_and_click authority_citation_worldcat_link
  end

  # Clicks the link to create a new activity record
  def click_create_new_authority_concept_activity
    wait_for_element_and_click authority_concept_activity_link
  end

  # Clicks the link to create a new associated concept record
  def click_create_new_authority_concept_associated
    wait_for_element_and_click authority_concept_associated_link
  end

  def click_create_new_authority_concept_arch_culture
    wait_for_element_and_click authority_concept_arch_culture_link
  end

  def click_create_new_authority_concept_ethno_culture
    wait_for_element_and_click authority_concept_ethno_culture_link
  end

  def click_create_new_authority_concept_ethno_file_code
    wait_for_element_and_click authority_concept_ethno_file_code_link
  end

  # Clicks the link to create a new concept material record
  def click_create_new_authority_concept_material
    wait_for_element_and_click authority_concept_material_link
  end

  # Clicks the link to create a new concept nomenclature record
  def click_create_new_authority_concept_nomenclature
    wait_for_element_and_click authority_concept_nomenclature_link
  end

  def click_create_new_authority_concept_object_class
    wait_for_element_and_click authority_concept_object_class_link
  end

  def click_create_new_authority_concept_object_name
    wait_for_element_and_click authority_concept_object_name_link
  end

  # Clicks the link to create a new concept occasion record
  def click_create_new_authority_concept_occasion
    wait_for_element_and_click authority_concept_occasion_link
  end

  # Clicks the link to create a new local person record
  def click_create_new_authority_person_local
    wait_for_element_and_click authority_person_local_link
  end

  # Clicks the link to create new ulan person record
  def click_create_new_authority_person_ulan
    wait_for_element_and_click authority_person_ulan_link
  end

  # Clicks the link to create a new local place record
  def click_create_new_authority_place_local
    wait_for_element_and_click authority_place_local_link
  end

  # Clicks the link to create a new tgn place record
  def click_create_new_authority_place_tgn
    wait_for_element_and_click authority_place_tgn_link
  end

  def click_create_new_authority_storage_crate
    wait_for_element_and_click authority_storage_crate_link
  end

  # Clicks the link to create a new local storage record
  def click_create_new_authority_storage_local
    wait_for_element_and_click authority_storage_local_link
  end

  # Clicks the link to create a new offsite storage record
  def click_create_new_authority_storage_offsite
    wait_for_element_and_click authority_storage_offsite_link
  end

  def click_create_new_authority_taxon_default
    logger.info 'Clicking Taxon Default'
    wait_for_element_and_click authority_taxon_default_link
  end

  # Clicks the link to create a new local work record
  def click_create_new_authority_work_local
    wait_for_element_and_click authority_work_local_link
  end

  # Clicks the link to create a new cona work record
  def click_create_new_authority_work_cona
    wait_for_element_and_click authority_work_cona_link
  end

end
