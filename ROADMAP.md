# Roadmap

This roadmap aligns *Aliens at War II* with the long-term vision of being an approachable, moddable space RTS while drawing inspiration from the live-ops cadence, large-scale battles, and player tooling emphasized by [Beyond All Reason](https://github.com/beyond-all-reason/Beyond-All-Reason).

## Vision pillars

- **Grand-scale clarity** – support hundreds of units, large maps, and fluid control schemes that remain readable.
- **Economy with intent** – evolve the two-resource economy into an energy/industry model that rewards map control and logistical planning.
- **Player empowerment** – deliver smart defaults, automation aids, and UX polish so new commanders can contribute quickly.
- **Community-first evolution** – cultivate modding, matchmaking, replays, and seasonal live events to keep the metagame fresh.

## Milestone overview

| Phase | Codename | Focus | Exit criteria |
| --- | --- | --- | --- |
| 0 | **Staging Orbit** | Audit and stabilize upstream fork, trim unlicensed assets. | Clean build with license-compliant content, automated smoke test running in CI. |
| 1 | **Skirmish Foundations** | Core UX polish, tutorials, AI parity, initial content pipeline. | New-player tutorial, accessible HUD, baseline AI vs AI parity on medium maps. |
| 2 | **Galactic Operations** | Expand roster, economy depth, map variety, cooperative play. | Distinct unit tech tiers, dual-resource upkeep, 10+ competitive/skirmish maps, online co-op prototype. |
| 3 | **Alliance Network** | Competitive & community tooling: matchmaking, replays, events. | Ranked & casual queues, replay browser, seasonal rotation, clan support. |
| 4 | **Living Galaxy** | Ongoing live-ops, mod marketplace, narrative campaigns. | Quarterly balance patches, curated mod highlights, first campaign episode shipped. |

## Phase 0 – Staging Orbit (in-flight)

1. **Licensing & asset hygiene**
   - Remove or replace flagged skyline and Egregoria assets, establish SPDX tracking per package.
   - Automate license scanning in CI to prevent regressions.
2. **Baseline stability**
   - Establish reproducible Godot export presets (desktop + headless) validated nightly.
   - Restore failing unit tests and add smoke test map that runs in headless CI builds.
3. **Technical debt audit**
   - Mirror BAR's approach of documenting engine deltas: catalog upstream divergences, profiling hot spots, and build configuration toggles.

## Phase 1 – Skirmish Foundations

- **Gameplay & UX**
  - Ship an interactive tutorial scenario covering camera controls, basic construction, and combat cadence similar to BAR's onboarding skirmishes.
  - Introduce context-sensitive build queues, factory repeat toggles, and command preview ghosts for clear feedback.
    - [x] Factory repeat toggles keep production structures cycling orders automatically when resources allow.
  - Redesign HUD panels to surface energy/industry trends, build progress bars, and alert banners inspired by BAR's strategic UI.
- **AI & Pathfinding**
  - Implement influence-map driven AI priorities (raiding, expansion, teching) and stress-test large formations for blob avoidance.
  - Add BAR-like assist/guard behaviors so engineers auto-support production lines and reclaim wreckage.
- **Content & tooling**
  - Standardize map authoring templates with metadata (size, biome, suggested player count) and generate 5 teaching maps.
  - Integrate Meshy ingestion pipeline into CI with preview renders for PR review.

### Phase 1 readiness checklist

- Players can complete tutorial and defeat AI on at least two medium maps.
- HUD communicates unit queues, resource surpluses/deficits, and global alerts without debug overlays.
- Automated regression suite validates pathfinding on stress maps and command helpers (assist, repeat).

## Phase 2 – Galactic Operations

- **Economy & progression**
  - Introduce energy grids, logistic relays, and upkeep akin to BAR's continuous energy/metal management.
  - Implement reclaimable wreckage fields and orbital resource nodes that encourage map contention.
  - Unlock technology tiers with research structures, enabling specialized units (stealth, siege, orbital strikes).
- **Unit roster & balance**
  - Expand to 3 playable factions, each with differentiated tech trees mirroring BAR's asymmetrical unit mix.
  - Add specialized support units (radar drones, shield projectors, engineer dropships) and corresponding counterplay.
  - Establish telemetry-driven balance patches triggered by match data collection.
- **Multiplayer foundations**
  - Deliver deterministic lockstep netcode prototype with rollback-friendly state sync inspired by BAR's large-scale multiplayer stability.
  - Stand up dedicated server orchestration with lobby listings, spectator slots, and pause/surrender flows.
- **Worldbuilding & maps**
  - Produce 10+ competitive maps across multiple planet biomes with scripted map events (meteor showers, solar flares) optional.
  - Add skybox and lighting variants to reinforce the cosmic tone while maintaining readability.

### Phase 2 readiness checklist

- Factions achieve 45–55% win parity in telemetry across the active ladder.
- Netcode supports 4v4 matches on large maps without desyncs under load testing.
- Map catalog includes quickplay tags, thumbnail previews, and recommended player counts.

## Phase 3 – Alliance Network

- **Competitive ecosystem**
  - Launch ranked and casual matchmaking queues with ELO placement, party support, and cross-region data centers.
  - Provide in-client tournament toolkit (check-in, bracket view, auto-host) similar to BAR community events.
  - Ship replay browser with timeline scrubbing, bookmark sharing, and patch compatibility conversion.
- **Social & community**
  - Embed global chat channels, clan management, and friends list tied to platform accounts.
  - Implement live spectator tools (fog-of-war toggle, player POV) and casting overlays for esports broadcasts.
- **Modding & customization**
  - Package mod SDK with schema docs, sample mods, and sandbox verification harness inspired by BAR's rapid iteration workflow.
  - Host curated mod portal with ratings, dependency resolution, and one-click install inside the launcher.

### Phase 3 readiness checklist

- Ranked seasons run end-to-end with season rewards and leaderboard snapshots.
- Replay files are versioned, searchable, and streamable for community casting.
- At least 20 curated mods survive automated QA and are installable in-client.

## Phase 4 – Living Galaxy

- **Narrative & PvE**
  - Release branching campaign episodes with voiced briefings, co-op variants, and persistent choices.
  - Add horde/raid PvE modes with rotating mutators to sustain off-season engagement.
- **Live operations**
  - Establish quarterly balance cadence informed by analytics and council feedback, mirroring BAR's community-driven balance patches.
  - Rotate seasonal map pools, limited-time events, and cosmetic unlocks to refresh metas.
- **Sustainable ecosystem**
  - Monetization-friendly cosmetic pipeline (battle passes, commander skins) while keeping gameplay fair.
  - Long-term infrastructure roadmap: autoscaling servers, anti-cheat, telemetry dashboards, GDPR-compliant data retention.

### Evergreen workstreams

- **Quality assurance** – Expand automated tests (unit, integration, soak), maintain compatibility matrix (Windows, Linux, Steam Deck).
- **Accessibility** – Subtitle all narrative content, add colorblind palettes, remappable controls, and scalable UI widgets.
- **Community governance** – Document code of conduct, moderation tooling, and transparent contributor RFC process.

This roadmap should be revisited quarterly with telemetry, player feedback, and contributor capacity to keep the project aligned with its goals while iterating toward BAR-level polish.
