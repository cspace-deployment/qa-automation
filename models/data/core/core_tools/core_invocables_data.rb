class CoreInvocablesData < CollectionSpaceData

  DATA = [
      # Invocable Doc Type
      INVOCABLE_NAME = new('name'),
      INVOCABLE_DESC = new('notes'),
      INVOCABLE_NO_CONTEXT = new('supportsNoContext'),
      INVOCABLE_SINGLE_CONTEXT = new('supportsSingleDoc'),
      INVOCABLE_LIST_CONTEXT = new('supportsDocList'),
      INVOCABLE_GROUP_CONTEXT = new('supportsSingleDoc'),
      INVOCABLE_DOC_TYPES_GROUP = new('forDocTypes', 'For record type'),
      INVOCABLE_DOC_TYPE = new('forDocType'),
      INVOCABLE_RUNS_ON_PANEL = new('', 'Runs on'),

      # Batch Job
      INVOCABLE_BATCH_CREATES_NEW_FOCUS = new('createsNewFocus', 'Navigate to new record when complete'),
      INVOCABLE_BATCH_LIST_PANEL = new('', 'Data Updates'),
      INVOCABLE_BATCH_CLASSNAME = new('className', 'Java class'),
      
      # Reports
      INVOCABLE_REPORT_OUTPUT_MIME = new('outputMIME', 'For record type'),
      INVOCABLE_REPORT_FILENAME = new('filename'),
      INVOCABLE_REPORT_LIST_PANEL = new('', 'Reports'),

      # Report & Batch roles
      REPORTER_AND_EDITOR_ROLE = new("CAN_EDIT_CAN_RUN"),
      REPORT_EDITOR_ROLE = new("CAN_EDIT_CANT_RUN"),
      REPORT_INVOKER_ROLE = new("CANT_EDIT_CAN_RUN"),
      NO_REPORT_PERMISSIONS_ROLE = new("NO_REPORT_PERMISSIONS"),
  ]

end
