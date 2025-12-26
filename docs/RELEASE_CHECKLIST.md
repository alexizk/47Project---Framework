# Release checklist

## Before
- [ ] Run GUI once (Home/Verify/Doctor)
- [ ] Safe Mode behavior OK
- [ ] Pack Manager: stage/diff/apply (UPDATE token) OK
- [ ] Snapshots: create/restore OK
- [ ] Manifest verification OK (`tools/verify_manifest.ps1`)

## Release
Run:
```powershell
.\tools\release.ps1 -Version vXX -Notes "highlights..."
```

## After
- [ ] Update release notes (docs/RELEASE_NOTES_TEMPLATE.md)
- [ ] Build portable zip (tools/build_portable.ps1)
- [ ] Optional: sign scripts (tools/sign_release.ps1)
