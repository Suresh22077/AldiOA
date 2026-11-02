using { aldi.oa as db } from '../db/schema';

// ─────────────────────────────────────────────────────
// OA Management Service — exposed as OData V4
// ─────────────────────────────────────────────────────
service OAManagementService @(path: '/odata/v4/oa') {

  // ── Rules ──────────────────────────────────────────
  @readonly
  entity Rules            as projection on db.OA_RULES;

  // ── Exceptions (unassigned articles) ────────────────
  @readonly
  entity Exceptions       as select from db.MATERIAL_OA_MAPPING
    mixin { material: Association to db.MATERIAL_MASTER on material.ARTICLE_ID = $projection.ARTICLE_ID
                                                        and material.DC         = $projection.DC }
    into {
      *,
      material.ARTICLE_TYPE,
      material.TRANSPORT_GROUP,
      material.HIERARCHY_NODE_2,
      material.BUOM
    }
    where STATUS = 'U';

  // ── Assignments ──────────────────────────────────────
  @readonly
  entity Assignments      as projection on db.MATERIAL_OA_MAPPING
    where STATUS = 'A' or STATUS = 'C';

  // ── Recommendations ─────────────────────────────────
  @(restrict: [
    { grant: ['READ'],          to: ['OAViewer', 'OAPlanner', 'OAAdmin'] },
    { grant: ['approve','reject'], to: ['OAPlanner', 'OAAdmin'] }
  ])
  entity Recommendations  as projection on db.Recommendations
    actions {
      action approve() returns Recommendations;
      action reject()  returns Recommendations;
    };

  // ── Agent Runs ───────────────────────────────────────
  @readonly
  entity AgentRuns        as projection on db.AgentRuns;

  // ── Dashboard KPIs (unbound function) ───────────────
  function DashboardKPIs() returns {
    totalAssigned   : Integer;
    totalUnassigned : Integer;
    automationRate  : Decimal(5,2);
    anomalyCount    : Integer;
    runDate         : Date;
    runId           : Integer;
  };

  // ── Rule Health Summary (unbound function) ───────────
  function RuleHealthSummary() returns array of {
    DC               : String(4);
    totalRules       : Integer;
    activeRules      : Integer;
    deactivatedRules : Integer;
    conflictCount    : Integer;
    automationRate   : Decimal(5,2);
    status           : String(20);
  };

  // ── Exception Root Cause Summary ────────────────────
  function ExceptionRootCauses() returns array of {
    rootCause   : String(200);
    count       : Integer;
    percentage  : Decimal(5,2);
  };
}
