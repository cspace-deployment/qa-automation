module BOTGARDENTaxonInfoForm

  def botgarden_access_code_input; input_locator([], BOTGARDENTaxonData::ACCESS_RESTRICTIONS.name) end
  def botgarden_attribute_conserv_categ_input(index); input_locator([fieldset(BOTGARDENTaxonData::PLANT_ATTRIB_GRP.name, index)], BOTGARDENTaxonData::CONSERV_CATEG.name) end
  def botgarden_attribute_conserv_categ_options(index); input_options_locator([fieldset(BOTGARDENTaxonData::PLANT_ATTRIB_GRP.name, index)], BOTGARDENTaxonData::CONSERV_CATEG.name) end

  # PLANT ATTRIBUTE INFORMATION

  def enter_botgarden_attributes(data)
    attributes = data[BOTGARDENTaxonData::PLANT_ATTRIB_GRP.name]
    prep_fieldsets_for_test_data([fieldset(BOTGARDENTaxonData::PLANT_ATTRIB_GRP.name)], attributes)
    attributes && attributes.each_with_index do |attribute, index|
      logger.debug "Entering plant attribute information '#{attribute}' at index #{index}"
      # TODO - attribute date input
      # TODO - attribute height input
      # TODO - attribute width input
      # TODO - attribute DBH input
      # TODO - attribute recorded by input
      # TODO - attribute conservation organization input
      enter_auto_complete(botgarden_attribute_conserv_categ_input(index), botgarden_attribute_conserv_categ_options(index), attribute[BOTGARDENTaxonData::CONSERV_CATEG.name], 'Conservation Categories')
      # TODO - attribute habit input
      # TODO - attribute climate rating input
      # TODO - attribute frost sensitive input
      # TODO - attribute medicinal use input
      # TODO - attribute economic use input
    end
  end

end
