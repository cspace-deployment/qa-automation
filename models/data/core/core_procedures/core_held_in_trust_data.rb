class CoreHeldInTrustData < CollectionSpaceData

  DATA = [
        HIT_NUMBER = new('hitNumber'),
        ENTRY_DATE = new('entryDate'),
        DEPOSITOR_GRP = new('hitDepositorGroup'),
        DEPOSITOR_NAME = new('depositor'),
        DEPOSITOR_CONTACT = new('depositorContact'),
        DEPOSITOR_CONTACT_TYPE = new('depositorContactType'),
        DEPOSITOR_NOTE = new('depositorNote'),
        AGREEMENT_STATUS_GRP = new('agreementGroup'),
        STATUS = new('agreementStatus'),
        STATUS_DATE = new('agreementStatusDate'),
        STATUS_NOTE = new('agreementStatusNote'),
        ENTRY_METHODS = new('entryMethods'),
        ENTRY_METHOD = new('entryMethod'),
        AGREEMENT_RENEWAL_DATES = new('agreementRenewalDates'),
        AGREEMENT_RENEWAL_DATE = new('agreementRenewalDate'),
        ENTRY_REASON = new('entryReason'),
        RETURN_DATE = new('returnDate'),
        ENTRY_NOTE = new('entryNote'),
        INTERNAL_APPROVAL_GRPS = new('internalApprovalGroup'),
        INTERNAL_APPROVAL_GROUP = new('internalApprovalGroupName'),
        INTERNAL_APPROVAL_INDIVIDUAL = new('internalApprovalIndividual'),
        INTERNAL_APPROVAL_STATUS = new('internalApprovalStatus'),
        INTERNAL_APPROVAL_DATE = new('internalApprovalDate'),
        INTERNAL_APPROVAL_NOTE = new('internalApprovalNote'),
        EXTERNAL_APPROVAL_GRPS = new('externalApprovalGroup'),
        EXTERNAL_APPROVAL_GROUP = new('externalApprovalGroupName'),
        EXTERNAL_APPROVAL_INDIVIDUAL = new('externalApprovalIndividual'),
        EXTERNAL_APPROVAL_STATUS = new('externalApprovalStatus'),
        EXTERNAL_APPROVAL_DATE = new('externalApprovalDate'),
        EXTERNAL_APPROVAL_NOTE = new('externalApprovalNote'),

        HANDLING_PREFERENCES = new('handlingPreferences'),
        HANDLING_LIMITATIONS_GRP = new('handlingLimitationsGroup'),
        HANDLING_TYPE = new('handlingLimitationsType'),
        HANDLING_REQUESTOR = new('handlingLimitationsRequestor'),
        HANDLING_LEVEL = new('handlingLimitationsLevel'),
        HANDLING_BEHALF = new('handlingLimitationsOnBehalfOf'),
        HANDLING_DETAIL = new('handlingLimitationsDetail'),
        HANDLING_DATE = new('handlingLimitationsDate'),

        CORRESPONDENCE_GRP = new('correspondenceGroup'),
        CORRESPONDENCE_DATE = new('correspondenceDate'),
        CORRESPONDENCE_SENDER = new('correspondenceSender'),
        CORRESPONDENCE_RECIPIENT = new('correspondenceRecipient'),
        CORRESPONDENCE_SUMMARY = new('correspondenceSummary'),
        CORRESPONDENCE_REF = new('correspondenceReference')
  ]

  def self.empty_depositor
    {
      DEPOSITOR_NAME.name => '',
      DEPOSITOR_CONTACT.name => '',
      DEPOSITOR_CONTACT_TYPE.name => '',
      DEPOSITOR_NOTE.name => ''
    }
  end

  def self.empty_agreement_status
    {
      STATUS.name => '',
      STATUS_DATE.name => '',
      STATUS_NOTE.name => ''
    }
  end

  def self.empty_internal_approval
    {
      INTERNAL_APPROVAL_GROUP.name => '',
      INTERNAL_APPROVAL_INDIVIDUAL.name => '',
      INTERNAL_APPROVAL_STATUS.name => '',
      INTERNAL_APPROVAL_DATE.name => '',
      INTERNAL_APPROVAL_NOTE.name => ''
    }
  end

  def self.empty_external_approval
    {
      EXTERNAL_APPROVAL_GROUP.name => '',
      EXTERNAL_APPROVAL_INDIVIDUAL.name => '',
      EXTERNAL_APPROVAL_STATUS.name => '',
      EXTERNAL_APPROVAL_DATE.name => '',
      EXTERNAL_APPROVAL_NOTE.name => ''
    }
  end

  def self.empty_handling_limitations
    {
      HANDLING_TYPE.name => '',
      HANDLING_REQUESTOR .name => '',
      HANDLING_LEVEL.name => '',
      HANDLING_BEHALF.name => '',
      HANDLING_DETAIL.name => '',
      HANDLING_DATE.name => ''
    }
  end

  def self.empty_correspondence
    {
      CORRESPONDENCE_DATE.name => '',
      CORRESPONDENCE_SENDER.name => '',
      CORRESPONDENCE_RECIPIENT.name => '',
      CORRESPONDENCE_SUMMARY.name => '',
      CORRESPONDENCE_REF.name => ''
    }
  end
end
