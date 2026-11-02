using OAManagementService as service from '../srv/oa-service';

// ─────────────────────────────────────────────────────
// Exceptions — List Report with Object Page
// ─────────────────────────────────────────────────────
annotate service.Exceptions with @(
  UI.HeaderInfo: {
    TypeName:       'Unassigned Article',
    TypeNamePlural: 'Unassigned Articles',
    Title:          { Value: ARTICLE_ID },
    Description:    { Value: DC }
  },
  UI.SelectionFields: [ DC, ROOT_CAUSE, AI_CONFIDENCE ],
  UI.LineItem: [
    { Value: ARTICLE_ID,     Label: 'Article' },
    { Value: DC,             Label: 'DC' },
    { Value: ARTICLE_TYPE,   Label: 'Article Type' },
    { Value: TRANSPORT_GROUP,Label: 'Trans.Grp' },
    { Value: PREVIOUS_OA,    Label: 'Last OA' },
    { Value: ROOT_CAUSE,     Label: 'Root Cause (AI)' },
    { Value: RECOMMENDED_OA, Label: 'Recommended OA' },
    { Value: AI_CONFIDENCE,  Label: 'Confidence %' },
    { Value: STATUS,         Label: 'Status' }
  ],
  UI.Facets: [
    {
      $Type:  'UI.ReferenceFacet',
      Label:  'AI Explanation',
      ID:     'aiExplanation',
      Target: '@UI.FieldGroup#AIExplanation'
    },
    {
      $Type:  'UI.ReferenceFacet',
      Label:  'Article Master Data',
      ID:     'materialData',
      Target: '@UI.FieldGroup#MaterialData'
    }
  ],
  UI.FieldGroup#AIExplanation: {
    Label: 'AI Explanation',
    Data: [
      { Value: ROOT_CAUSE,     Label: 'Root Cause' },
      { Value: RECOMMENDED_OA, Label: 'Recommended OA' },
      { Value: AI_CONFIDENCE,  Label: 'Confidence %' }
    ]
  },
  UI.FieldGroup#MaterialData: {
    Label: 'Master Data',
    Data: [
      { Value: ARTICLE_TYPE,     Label: 'Article Type' },
      { Value: TRANSPORT_GROUP,  Label: 'Transport Group' },
      { Value: HIERARCHY_NODE_2, Label: 'Hierarchy Node 2' },
      { Value: BUOM,             Label: 'Base UoM' },
      { Value: ASSIGNMENT_DATE,  Label: 'Assignment Date' }
    ]
  }
);

// ─────────────────────────────────────────────────────
// Recommendations — List Report with Object Page
// ─────────────────────────────────────────────────────
annotate service.Recommendations with @(
  UI.HeaderInfo: {
    TypeName:       'Recommendation',
    TypeNamePlural: 'Recommendations',
    Title:          { Value: TITLE },
    Description:    { Value: TYPE }
  },
  UI.SelectionFields: [ TYPE, STATUS, DC ],
  UI.LineItem: [
    { Value: TYPE,         Label: 'Type' },
    { Value: TITLE,        Label: 'Title' },
    { Value: DC,           Label: 'DC' },
    { Value: CONFIDENCE,   Label: 'Confidence %' },
    { Value: IMPACT_COUNT, Label: 'Impact (articles)' },
    { Value: STATUS,       Label: 'Status' }
  ],
  UI.Facets: [
    {
      $Type:  'UI.ReferenceFacet',
      Label:  'Details',
      ID:     'rcDetails',
      Target: '@UI.FieldGroup#RcDetails'
    }
  ],
  UI.FieldGroup#RcDetails: {
    Data: [
      { Value: TITLE,        Label: 'Title' },
      { Value: DESCRIPTION,  Label: 'Description' },
      { Value: CONFIDENCE,   Label: 'Confidence %' },
      { Value: DC,           Label: 'Distribution Center' },
      { Value: IMPACT_COUNT, Label: 'Estimated Impact (articles)' },
      { Value: STATUS,       Label: 'Status' },
      { Value: APPROVED_BY,  Label: 'Approved By' },
      { Value: APPROVED_AT,  Label: 'Approved At' }
    ]
  },
  UI.Identification: [
    { $Type: 'UI.DataFieldForAction', Action: 'OAManagementService.approve', Label: 'Approve' },
    { $Type: 'UI.DataFieldForAction', Action: 'OAManagementService.reject',  Label: 'Reject' }
  ]
);

// ─────────────────────────────────────────────────────
// Rules — read-only List Report
// ─────────────────────────────────────────────────────
annotate service.Rules with @(
  UI.HeaderInfo: {
    TypeName:       'OA Rule',
    TypeNamePlural: 'OA Rules',
    Title:          { Value: RULE_ID },
    Description:    { Value: DC }
  },
  UI.SelectionFields: [ DC, ACTIVE, ORDER_AREA_ID ],
  UI.LineItem: [
    { Value: RULE_ID,          Label: 'Rule ID' },
    { Value: DC,               Label: 'DC' },
    { Value: ARTICLE_TYPE,     Label: 'Article Type' },
    { Value: TRANSPORT_GROUP,  Label: 'Trans.Grp' },
    { Value: HIERARCHY_NODE_2, Label: 'HNode 2' },
    { Value: ORDER_AREA_ID,    Label: 'Order Area' },
    { Value: BUOM,             Label: 'Base UoM' },
    { Value: FIRE_COUNT,       Label: 'Fired (90d)' },
    { Value: LAST_FIRED,       Label: 'Last Fired' },
    { Value: ACTIVE,           Label: 'Active' }
  ]
);

// ─────────────────────────────────────────────────────
// Agent Runs — read-only List Report
// ─────────────────────────────────────────────────────
annotate service.AgentRuns with @(
  UI.HeaderInfo: {
    TypeName:       'Agent Run',
    TypeNamePlural: 'Agent Runs',
    Title:          { Value: RUN_ID }
  },
  UI.LineItem: [
    { Value: RUN_ID,           Label: 'Run #' },
    { Value: RUN_DATE,         Label: 'Run Date' },
    { Value: TOTAL_ASSIGNED,   Label: 'Assigned' },
    { Value: TOTAL_UNASSIGNED, Label: 'Unassigned' },
    { Value: AUTOMATION_RATE,  Label: 'Automation %' },
    { Value: ANOMALY_COUNT,    Label: 'Anomalies' },
    { Value: STATUS,           Label: 'Status' }
  ]
);
