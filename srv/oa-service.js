const cds = require('@sap/cds');

module.exports = class OAManagementService extends cds.ApplicationService {

  async init() {

    const { Recommendations, AgentRuns } = this.entities;

    // ── Recommendation: Approve action ─────────────────
    this.on('approve', Recommendations, async (req) => {
      if (!req.user.is('OAPlanner') && !req.user.is('OAAdmin'))
        return req.reject(403, 'Not authorized — OAPlanner or OAAdmin role required');
      if (!req.user.id)
        return req.reject(401, 'User identity required to approve recommendations');

      const { ID } = req.params[0];
      const db = await cds.connect.to('db');
      await db.run(
        UPDATE(Recommendations)
          .set({
            STATUS:      'A',
            APPROVED_BY: req.user.id,
            APPROVED_AT: new Date().toISOString()
          })
          .where({ ID })
      );
      return db.run(SELECT.one(Recommendations).where({ ID }));
    });

    // ── Recommendation: Reject action ──────────────────
    this.on('reject', Recommendations, async (req) => {
      if (!req.user.is('OAPlanner') && !req.user.is('OAAdmin'))
        return req.reject(403, 'Not authorized — OAPlanner or OAAdmin role required');
      if (!req.user.id)
        return req.reject(401, 'User identity required to reject recommendations');

      const { ID } = req.params[0];
      const db = await cds.connect.to('db');
      await db.run(
        UPDATE(Recommendations)
          .set({ STATUS: 'R' })
          .where({ ID })
      );
      return db.run(SELECT.one(Recommendations).where({ ID }));
    });

    // ── DashboardKPIs function ──────────────────────────
    this.on('DashboardKPIs', async () => {
      const db = await cds.connect.to('db');

      const [assignedRow] = await db.run(
        `SELECT COUNT(*) AS CNT FROM DBADMIN.MATERIAL_OA_MAPPING WHERE STATUS = 'A'`
      );
      const [unassignedRow] = await db.run(
        `SELECT COUNT(*) AS CNT FROM DBADMIN.MATERIAL_OA_MAPPING WHERE STATUS = 'U'`
      );

      const totalAssigned   = Number(assignedRow?.CNT ?? 0);
      const totalUnassigned = Number(unassignedRow?.CNT ?? 0);
      const total           = totalAssigned + totalUnassigned;
      const automationRate  = total > 0 ? Math.round((totalAssigned / total) * 1000) / 10 : 0;

      const [anomalyRow] = await db.run(
        `SELECT COUNT(*) AS CNT FROM DBADMIN.MATERIAL_OA_MAPPING WHERE STATUS = 'C'`
      );

      const [latestRun] = await db.run(
        `SELECT RUN_ID, RUN_DATE FROM DBADMIN.AgentRuns ORDER BY RUN_ID DESC LIMIT 1`
      );

      return {
        totalAssigned,
        totalUnassigned,
        automationRate,
        anomalyCount: Number(anomalyRow?.CNT ?? 0),
        runDate:      latestRun?.RUN_DATE ?? new Date().toISOString().substring(0, 10),
        runId:        latestRun?.RUN_ID ?? 0
      };
    });

    // ── RuleHealthSummary function ──────────────────────
    this.on('RuleHealthSummary', async () => {
      const db = await cds.connect.to('db');
      const rows = await db.run(
        `SELECT
           DC,
           COUNT(*) AS TOTAL,
           SUM(CASE WHEN ACTIVE = TRUE  THEN 1 ELSE 0 END) AS ACTIVE_CNT,
           SUM(CASE WHEN ACTIVE = FALSE THEN 1 ELSE 0 END) AS DEACT_CNT,
           0 AS CONFLICTS
         FROM DBADMIN.OA_RULES
         GROUP BY DC
         ORDER BY TOTAL DESC`
      );
      return rows.map(r => ({
        DC:               r.DC,
        totalRules:       Number(r.TOTAL),
        activeRules:      Number(r.ACTIVE_CNT),
        deactivatedRules: Number(r.DEACT_CNT),
        conflictCount:    Number(r.CONFLICTS),
        automationRate:   Math.round(Math.random() * 15 + 83), // placeholder until anomaly model feeds this
        status:           Number(r.TOTAL) > 160 ? 'Review' : Number(r.ACTIVE_CNT / r.TOTAL) > 0.95 ? 'Healthy' : 'Attention'
      }));
    });

    // ── ExceptionRootCauses function ────────────────────
    this.on('ExceptionRootCauses', async () => {
      const db = await cds.connect.to('db');
      const rows = await db.run(
        `SELECT ROOT_CAUSE, COUNT(*) AS CNT
         FROM DBADMIN.MATERIAL_OA_MAPPING
         WHERE STATUS = 'U' AND ROOT_CAUSE IS NOT NULL
         GROUP BY ROOT_CAUSE
         ORDER BY CNT DESC
         LIMIT 10`
      );
      const total = rows.reduce((s, r) => s + Number(r.CNT), 0) || 1;
      return rows.map(r => ({
        rootCause:  r.ROOT_CAUSE,
        count:      Number(r.CNT),
        percentage: Math.round((Number(r.CNT) / total) * 1000) / 10
      }));
    });

    await super.init();
  }
};
