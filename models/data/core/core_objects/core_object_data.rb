require_relative '../../../../spec_helper'

class CoreObjectData < CollectionSpaceData

   DATA = [
       BRIEF_DESCRIP = new('briefDescription'),
       BRIEF_DESCRIPS = new('briefDescriptions'),
       COLLECTION = new('collection'),
       COMMENT = new('comment'),
       COMMENTS = new('comments'),
       COMPUTED_LOCATION = new('currentLocation', 'Computed current location'),

       CONTENT_PERSONS = new('contentPersons'),
       CONTENT_PERSON = new('contentPerson'),

       DATE = new('date'),
       DATE_ASSOC = new('dateAssociation'),
       DATE_EARLIEST_CERTAINTY = new('dateEarliestSingleCertainty'),
       DATE_EARLIEST_DAY = new('dateEarliestSingleDay'),
       DATE_EARLIEST_ERA = new('dateEarliestSingleEra'),
       DATE_EARLIEST_MONTH = new('dateEarliestSingleMonth'),
       DATE_EARLIEST_QUALIF = new('dateEarliestSingleQualifier'),
       DATE_EARLIEST_QUALIF_UNIT = new('dateEarliestSingleQualifierUnit'),
       DATE_EARLIEST_QUALIF_VALUE = new('dateEarliestSingleQualifierValue'),
       DATE_EARLIEST_YEAR = new('dateEarliestSingleYear'),
       DATE_LATEST_CERTAINTY = new('dateLatestCertainty'),
       DATE_LATEST_DAY = new('dateLatestDay'),
       DATE_LATEST_ERA = new('dateLatestEra'),
       DATE_LATEST_MONTH = new('dateLatestMonth'),
       DATE_LATEST_QUALIF = new('dateLatestQualifier'),
       DATE_LATEST_QUALIF_UNIT = new('dateLatestQualifierUnit'),
       DATE_LATEST_QUALIF_VALUE = new('dateLatestQualifierValue'),
       DATE_LATEST_YEAR = new('dateLatestYear'),
       DATE_NOTE = new('dateNote'),
       DATE_PERIOD = new('datePeriod'),
       DISTINGUISHING_FEATURES = new('distinguishingFeatures'),
       INVENTORY_STATUS = new('inventoryStatus'),
       INVENTORY_STATUS_LIST = new('inventoryStatusList'),
       NUM_OBJECTS = new('numberOfObjects'),
       NUM_TYPE = new('numberType'),
       NUM_VALUE = new('numberValue'),
       OBJ_NAME_CURRENCY = new('objectNameCurrency'),
       OBJ_NAME_GRP = new('objectNameGroup'),
       OBJ_NAME_LANG = new('objectNameLanguage'),
       OBJ_NAME_LEVEL = new('objectNameLevel'),
       OBJ_NAME_NAME = new('objectName'),
       OBJ_NAME_NOTE = new('objectNameNote'),
       OBJ_NAME_SYSTEM = new('objectNameSystem'),
       OBJ_NAME_TYPE = new('objectNameType'),
       OBJECT_NUM = new('objectNumber'),
       OTHER_NUM = new('otherNumber'),
       PUBLISH_TO = new('publishTo'),
       PUBLISH_TO_LIST = new('publishToList'),
       RECORD_STATUS = new('recordStatus'),
       RESPONSIBLE_DEPTS = new('responsibleDepartments'),
       RESPONSIBLE_DEPT = new('responsibleDepartment'),
       TITLE = new('title'),
       TITLE_GRP = new('titleGroup'),
       TITLE_LANG = new('titleLanguage'),
       TITLE_TYPE = new('titleType'),
       TITLE_TRANSLATION = new('titleTranslation'),
       TITLE_TRANSLATION_LANG = new('titleTranslationLanguage'),
       TITLE_TRANSLATION_SUB_GRP = new('titleTranslationSubGroup'),

        # Object description info
        AGE = new('age'),

        # Object history association info
        OWNERSHIP_EXCH_PRICE_VALUE = new('ownershipExchangePriceValue')
   ]

end
