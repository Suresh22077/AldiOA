namespace aldi.oa;

using { cuid, managed } from '@sap/cds/common';

// ─────────────────────────────────────────────────────
// Mapped to existing HANA table: OA_RULES
// ─────────────────────────────────────────────────────
@cds.persistence.exists
entity OA_RULES {
  key RULE_ID          : String(20);
      DC               : String(4)    @title: 'Distribution Center';
      ARTICLE_TYPE     : String(10)   @title: 'Article Type';
      TRANSPORT_GROUP  : String(10)   @title: 'Transport Group';
      HIERARCHY_NODE_2 : String(18)   @title: 'Hierarchy Node 2';
      ORDER_AREA_ID    : String(10)   @title: 'Order Area';
      BUOM             : String(3)    @title: 'Base Unit of Measure';
      HIERARCHY_NODE   : String(18)   @title: 'Hierarchy Node';
      DISTR_PROFILE    : String(10)   @title: 'Distribution Profile';
      STAGING_TIME     : Integer      @title: 'Staging Time (h)';
      SHELF_LIFE       : Integer      @title: 'Shelf Life (days)';
      ROUNDING_PROFILE : String(6)    @title: 'Rounding Profile';
      ACTIVE           : Boolean      @title: 'Active';
      FIRE_COUNT       : Integer      @title: 'Fire Count (90d)';
      LAST_FIRED       : Date         @title: 'Last Fired';
      CREATED_AT       : Timestamp;
      CHANGED_AT       : Timestamp;
}

// ─────────────────────────────────────────────────────
// Mapped to existing HANA table: MATERIAL_MASTER
// ─────────────────────────────────────────────────────
@cds.persistence.exists
entity MATERIAL_MASTER {
  key ARTICLE_ID       : String(18)   @title: 'Article ID';
      DC               : String(4)    @title: 'Distribution Center';
      ARTICLE_TYPE     : String(10)   @title: 'Article Type';
      TRANSPORT_GROUP  : String(10)   @title: 'Transport Group';
      HIERARCHY_NODE_2 : String(18)   @title: 'Hierarchy Node 2';
      HIERARCHY_NODE   : String(18)   @title: 'Hierarchy Node';
      BUOM             : String(3)    @title: 'Base Unit of Measure';
      AVAIL_GROUP      : String(10)   @title: 'Availability Group';
      DC_MATL_STATUS   : String(4)    @title: 'DC Material Status';
      SOURCE_OF_SUPPLY : String(20)   @title: 'Source of Supply';
      CHANGED_AT       : Timestamp;
}

// ─────────────────────────────────────────────────────
// Mapped to existing HANA table: MATERIAL_OA_MAPPING
// ─────────────────────────────────────────────────────
@cds.persistence.exists
entity MATERIAL_OA_MAPPING {
  key ARTICLE_ID       : String(18)   @title: 'Article ID';
  key DC               : String(4)    @title: 'Distribution Center';
      ORDER_AREA_ID    : String(10)   @title: 'Assigned Order Area';
      PREVIOUS_OA      : String(10)   @title: 'Previous Order Area';
      RULE_ID          : String(20)   @title: 'Applied Rule';
      ASSIGNMENT_DATE  : Date         @title: 'Assignment Date';
      RUN_ID           : Integer      @title: 'Run ID';
      STATUS           : String(1)    @title: 'Status';
      AI_CONFIDENCE    : Decimal(5,2) @title: 'AI Confidence %';
      ROOT_CAUSE       : String(200)  @title: 'Root Cause (AI)';
      RECOMMENDED_OA   : String(10)   @title: 'Recommended OA';
      ASSIGNED_AT      : Timestamp;
}

// ─────────────────────────────────────────────────────
// Managed table — agent recommendations log
// ─────────────────────────────────────────────────────
entity Recommendations : cuid, managed {
      RUN_ID           : Integer      @title: 'Run ID';
      TYPE             : String(20)   @title: 'Recommendation Type';
      TITLE            : String(200)  @title: 'Title';
      DESCRIPTION      : String(2000) @title: 'Description';
      CONFIDENCE       : Decimal(5,2) @title: 'Confidence %';
      DC               : String(4)    @title: 'DC';
      IMPACT_COUNT     : Integer      @title: 'Estimated Impact (articles)';
      STATUS           : String(1)    @title: 'Status';
      APPROVED_BY      : String(100)  @title: 'Approved By';
      APPROVED_AT      : Timestamp    @title: 'Approved At';
}

// ─────────────────────────────────────────────────────
// Managed table — daily run log
// ─────────────────────────────────────────────────────
entity AgentRuns : cuid, managed {
      RUN_ID           : Integer      @title: 'Run ID';
      RUN_DATE         : Date         @title: 'Run Date';
      TOTAL_ASSIGNED   : Integer      @title: 'Total Assigned';
      TOTAL_UNASSIGNED : Integer      @title: 'Total Unassigned';
      AUTOMATION_RATE  : Decimal(5,2) @title: 'Automation Rate %';
      ANOMALY_COUNT    : Integer      @title: 'Anomalies Detected';
      STATUS           : String(1)    @title: 'Status';
}
