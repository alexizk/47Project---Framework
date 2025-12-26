# 47Project Framework

A Windows-first (PowerShell 7+) **Nexus shell** that unifies the Project47 toolset into one place:
- GUI hub with Apps/Modules/Plans/Snapshots/Pack Manager
- CLI shell for non-GUI environments
- Safe update workflows (stage → diff → apply) + snapshots + policy controls

> Current bundle: **v20** (2025-12-26)

## Quick start

### Windows (recommended)
1) Double-click: `Run_47Project_Framework.cmd`  
   - launches the framework  
   - installs PowerShell 7 via winget if missing (when available)

Optional shortcuts:
```powershell
.\tools\install_windows.ps1
```

### Linux / macOS
Install PowerShell 7+, then:
```bash
pwsh -NoLogo -NoProfile -File Framework/47Project.Framework.ps1
```

## Main entry points
- GUI: `47Project.Framework.GUI.v13.ps1`
- CLI: `Framework/47Project.Framework.ps1`
- Smart launcher: `47Project.Framework.Launch.ps1`

## Highlights

### Apps Hub (GUI)
- Discovers **scripts** + **modules**
- Reads metadata from comment-based help and `modules/*/module.json`
- Favorites are pinned; details panel includes Copy Path / Copy CLI

### Command Palette (Ctrl+K)
- Fuzzy search pages/apps
- Shows **Pinned** + **Recent** when empty
- Pinned pages stored in `data/pinned-commands.json`

### Safe Mode
- Global toggle that disables destructive actions
- Stored in `data/safe-mode.json`

### Pack Manager
- Stage pack zip (safe extract)
- Diff staged vs project
- Apply staged pack (**typed confirmation: UPDATE**)  
  *(apply is copy-only: no deletes)*

### Snapshots
Create/restore safety checkpoints before risky changes.

### Verify + Doctor
- Verify page exports a readiness report
- Doctor runs diagnostics and helps identify missing prerequisites

## Data & logs
- Data folder: `data/`
- Logs: `data/logs/YYYY-MM-DD.log`
- UI state: `data/ui-state.json`

## Documentation
Start here: `docs/INDEX.md`

## Release integrity
- `dist_manifest.json` contains SHA256 hashes for all files in the pack.

## License
Internal / project license as defined by the repository (add if/when you publish).

## Versioning
- `version.json` is the single source of truth for pack version/date.
- `tools/bump_version.ps1` updates version.json and regenerates dist_manifest.json.

## Integrity
Verify the pack against the manifest:
```powershell
.\tools\verify_manifest.ps1
```

## Contributing
See `CONTRIBUTING.md`.

## Releases
- Run the release pipeline:
```powershell
.\tools\release.ps1 -Version vXX -Notes "summary"
```
- Checklist: `docs/RELEASE_CHECKLIST.md`

## Maintenance
Smoke test:
```powershell
.\tools\smoke_test.ps1
```
Safe fixes:
```powershell
.\tools\fix_common_issues.ps1 -ResetDataJson -RegenerateManifest
```
Privacy: `PRIVACY.md`

## Support
In the GUI: About -> **Copy Support Info** copies environment details to clipboard.

## Offline HTML docs
```powershell
.\tools\build_docs.ps1
```
Open: `docs/site/index.html`

## Module Wizard (GUI)
Use the Module Wizard page to generate module scaffolding.

## Offline update notifier
Drop pack zip files into `pack_updates/` to show a Local Updates banner.
