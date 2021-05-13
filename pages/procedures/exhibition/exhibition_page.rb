class ExhibitionPage

  include Logging
  include Page
  include CollectionSpacePages
  include Sidebar
  include CoreExhibitionInfoForm

  def enter_number_and_text(data)
    enter_exhibition_num data
    enter_planning_note data
  end

  def enter_number(data)
    enter_exhibition_num data
  end
end
