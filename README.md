# Intelligent OA Assignment Agent — BTP CAP Application

AI-powered Order Area (OA) assignment automation for Germany DE E11, built on SAP BTP using CAP (Node.js), SAP Fiori Elements, and SAP HANA Cloud.

## Architecture

| Layer | Technology |
|---|---|
| Backend | CAP (Node.js) — OData V4 service |
| Frontend | SAP Fiori Elements (List Report + Object Page) |
| Database | SAP HANA Cloud (existing tables: OA_RULES, MATERIAL_MASTER, MATERIAL_OA_MAPPING) |
| Runtime | Cloud Foundry — GenAI subaccount (EU12) |

## Project Structure

```
AldiOA/
├── app/
│   ├── annotations.cds           # Fiori Elements UI annotations
│   ├── exceptions/               # Exception Inbox Fiori app
│   ├── recommendations/          # Recommendations Fiori app
│   └── router/                   # App Router + landing page
├── db/
│   └── schema.cds                # CDS data model (maps to existing HANA tables)
├── srv/
│   ├── oa-service.cds            # OData V4 service definition
│   └── oa-service.js             # Service implementation + handlers
├── mta.yaml                      # MTA deployment descriptor
├── xs-security.json              # XSUAA security descriptor
└── package.json
```

## HANA Cloud Tables Used

| Table | Description |
|---|---|
| `OA_RULES` | 3,196 mapping rules across 25 DCs |
| `MATERIAL_MASTER` | Article master data (article type, transport group, hierarchy nodes) |
| `MATERIAL_OA_MAPPING` | Daily assignment results and unassigned article log |

## API Endpoints

| Endpoint | Description |
|---|---|
| `GET /odata/v4/oa/Exceptions` | Unassigned articles with AI root-cause |
| `GET /odata/v4/oa/Rules` | All OA mapping rules |
| `GET /odata/v4/oa/Recommendations` | AI-generated recommendations |
| `POST /odata/v4/oa/Recommendations({id})/approve` | Approve a recommendation |
| `POST /odata/v4/oa/Recommendations({id})/reject` | Reject a recommendation |
| `GET /odata/v4/oa/DashboardKPIs()` | Daily dashboard KPIs |
| `GET /odata/v4/oa/RuleHealthSummary()` | Rule health per DC |
| `GET /odata/v4/oa/ExceptionRootCauses()` | Exception root cause breakdown |

## Deployment

Target: **GenAI subaccount** — Cloud Foundry `eu12`, Org `RFM_genai-4063`

```bash
# Login
cf login -a https://api.cf.eu12.hana.ondemand.com -o RFM_genai-4063 -s dev

# Build
npm ci
mbt build

# Deploy
cf deploy mta_archives/aldi-oa-agent_1.0.0.mtar
```
