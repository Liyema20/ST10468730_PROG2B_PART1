 Every race begins with a database.All races start with the establishment of a race database.

A South African Road Running full-stacked event management solution.
Walking- and cycling-friendliness. It allows the creation and management of events by the Organisers,
There are three types of results: categories, and results, and **Participants** browse events, enter categories,
Log and review their own racial history. To access Part 1 please visit this repository.
planning deliverables - entity relationship diagram, api endpoint plan,
and the SQL database script.

## Roles

- Organiser: Access to create, edit and delete events, manage event categories,
  Capture participant results and see all the participant Counts of their events.
- Log in, view events, and register for an event and
  Changing the category, checking their own enrollments and monitoring their individual
  results.

## Repository structure

```
.
├── docs/
│   ├── raceday_erd.png                  # Section A — ERD
│   ├── RaceDay_API_Endpoint_Plan.pdf    # Section B — API endpoint plan
│   └── RaceDay_Schema.sql               # Section C — SQL schema + seed data
├── .github/
│   └── workflows/
│       └── validate-structure.yml       # CI: validates /docs contains required files
└── README.md
```

## CI/CD

It runs on a GitHub Actions workflow (`.github/workflows/validate-structure.yml`)
All pushes are confirmed by:
If the `/docs` folder is present, then
- it is the listing of the database objects in the ERD, endpoint plan, and SQL script, and
The top level of the repo contains - and README.md - .

**Latest build:**

![CI passing](docs/ci-success-screenshot.png)

## Video walkthrough

Clicking on an unlisted YouTube video thru the planning documents,
decisions, endpoint plan selections, and a 'live' run of the SQL script in SSMS:

🔗 [Watch the walkthrough](PASTE_YOUR_YOUTUBE_LINK_HERE)

## AI tool disclosure

As instructed in the call to action: if any AI was used briefly tell about it here.
     e.g. Claude was used to help draft ERD diagram, API endpoint plan
     table, and SQL script structure; all design decisions, entity choices, and program specifications; all design decisions, entity choices, and program specifications;
     By me it means your baccarat and testing was reviewed and validated". Don't be flattery, and do don't be long-winded.
