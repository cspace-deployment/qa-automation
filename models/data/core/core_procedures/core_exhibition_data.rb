class CoreExhibitionData < CollectionSpaceData

  DATA = [
      EXHIBITION_NUM = new('exhibitionNumber'),
      SPONSOR = new('sponsor'),
      PLAN_NOTE = new('planningNote'),

      VENUE_GROUP = new('venueGroupList'),
      VENUE_NAME = new('venue'),
      VENUE_OPEN_DATE = new('venueOpeningDate'),
      VENUE_CLOSE_DATE = new('venueClosingDate'),
      VENUE_ATTENDANCE = new('venueAttendance'),
      VENUE_URL = new('venueUrl')
  ]

end
