require_relative '../../../../spec_helper'

class CorePlaceData < CoreAuthorityData

  DATA = [
      PLACE_TERM_GRP = new('placeTermGroup'),
      TERM_CURRENT_STATUS = new('historicalStatus'),
      TERM_TYPE_GRP = new('anthropologyPlaceTypes'),
      TERM_TYPE = new('anthropologyPlaceType'),
      TERM_ABBREVIATION = new('nameAbbrev'),
      TERM_NOTE = new('nameNote'),
      TERM_DATE = new('nameDate', 'Date'),

      PLACE_TYPES = new('anthropologyPlaceTypes'),
      PLACE_TYPE = new('anthropologyPlaceType'),

      PLACE_OWNERSHIP_GRP = new('anthropologyPlaceOwnerGroupList'),
      OWNERSHIP_OWNER = new('anthropologyPlaceOwner'),
      OWNERSHIP_START_DATE = new('anthropologyPlaceOwnershipStart', 'Start date'),
      OWNERSHIP_END_DATE = new('anthropologyPlaceOwnershipEnd', 'End date'),
      OWNERSHIP_NOTE = new('anthropologyPlaceOwnershipNote'),

      PLACE_NOTE_GRP = new('placeNoteGroup'),
      PLACE_NOTE = new('placeNoteText'),
      PLACE_NOTE_AUTHOR = new('placeNoteAuthor'),
      PLACE_NOTE_DATE = new('placeNoteDate'),

      PLACE_REFERENCE_GRP = new('placeReferenceGroupList'),
      REFERENCE = new('placeReference'),
      REFERENCE_NOTE = new('placeReferenceNote'),

      PLACE_ASSOCIATED_GRP = new('placeAssocGroupList'),
      ASSOCIATED_NAME = new('placeAssocName'),
      ASSOCIATED_ASSOCIATION = new('placeAssociation'),
      ASSOCIATED_DATE = new('placeAssocDate', 'Date'),
      ASSOCIATED_NOTE = new('placeAssocNote'),

      PLACE_ADDRESS_GRP = new('addrGroup'),
      ADDRESS_LINE_1 = new('addressPlace1'),
      ADDRESS_LINE_2 = new('addressPlace2'),
      ADDRESS_STATE = new('addressStateOrProvince'),
      ADDRESS_POSTAL_CODE = new('addressPostCode'),
      ADDRESS_COUNTRY = new('addressCountry'),
      ADDRESS_MUNICIPALITY = new('addressMunicipality'),
      ADDRESS_TYPE = new('addressType'),

      LOCALITY_INFO_PANEL = new('', 'Locality Information'),
      GEOREFERENCE_INFO_PANEL = new('', 'Georeference Information'),
      HIERARCHY_PANEL = new('', 'Hierarchy')
  ]

end
