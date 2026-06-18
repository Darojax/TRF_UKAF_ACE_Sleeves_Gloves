# [TRF] UKAF ACE Sleeves & Gloves

An ACE3 self-interaction addon for the **[TRF] United Kingdom Armed Forces – Equipment Mod**.

## What it does

This mod adds an ACE *self-interaction* (ACE menu on yourself) that lets a player swap
the UKAF uniform they are wearing between its matching **sleeve** and **glove**
variants — for example rolling sleeves up/down or putting gloves on/off — without
opening the arsenal and without losing the current loadout.

When you open the action, the addon:

1. Detects the uniform class you are wearing and works out which sleeve/glove
   variants exist for that uniform family.
2. Only offers variants that actually exist in `CfgWeapons`, so impossible
   combinations never appear.
3. On selection, swaps the uniform in place and **restores the full uniform
   contents** (items, magazines + ammo, weapons with attachments, and backpacks)
   plus your currently selected weapon, so the transition is loadout-safe.
4. Plays a short sleeve-roll / glove on-off sound for immersion.

Behaviour can be tuned per uniform family through CBA settings (each family can be
enabled or disabled in-game).

### Supported uniform families

- `TRF_PCS_*` — generic and regiment-specific variants
- `TRF_PCU_*` — generic and regiment-specific variants
- `TRF_CRYE_G4_*` — SFSG variants present in the base mod
- `16AA_PCS_*` — 16 Air Assault PCS variants

## Dependencies

- CBA_A3
- ACE3
- **[TRF] United Kingdom Armed Forces – Equipment Mod** (the base equipment mod)

> The base equipment mod is **not** included in this repository. Subscribe to it
> separately on the Steam Workshop. This addon only adds interactions on top of it.

## Repository layout

| Path | Purpose |
| --- | --- |
| `addons/main/` | Addon source (`config.cpp`, `functions/`, `sounds/`, `stringtable.xml`) — **edit here** |
| `@TRF_UKAF_ACE_Sleeves_Gloves/` | Packed, ready-to-use mod folder (the build output) |
| `tools/` | Build / sign / release helper scripts |

The `$PBOPREFIX$` is `z\trf_ukaf_ace_sleeves_gloves\addons\main`, so functions are
referenced as `\z\trf_ukaf_ace_sleeves_gloves\addons\main\functions\...`.

## Recompiling the mod after you make changes

All gameplay source lives in `addons/main/`. After editing any `config.cpp`,
`.sqf`, `stringtable.xml`, or sound file there, repack the addon so Arma 3 picks up
your changes.

### Option A — quick local rebuild (no Arma 3 Tools needed)

Use this while developing/testing locally. It runs a small pure-Python packer that
writes an **unsigned** PBO straight into the mod folder.

```powershell
python .\tools\build_pbo.py
```

Output:

```text
@TRF_UKAF_ACE_Sleeves_Gloves\addons\trf_ukaf_ace_sleeves_gloves_main.pbo
```

Then load `@TRF_UKAF_ACE_Sleeves_Gloves` as a mod in the Arma 3 launcher (or copy
it into your Arma 3 directory) and restart the game. Unsigned PBOs are fine for
local/self-hosted testing; servers with signature verification will reject them —
use Option B for those.

### Option B — release build (signed, Arma 3 Tools required)

Use this to produce a signed PBO suitable for a server or the Workshop. It uses
Bohemia's official `AddonBuilder` + `DSCreateKey` from **Arma 3 Tools** (install it
from Steam). The script locates the tools automatically under your Steam library.

First build (creates the signing key if it does not exist yet):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\build_release.ps1 -GenerateKey
```

Subsequent builds (reuse the existing key — omit `-GenerateKey`):

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\build_release.ps1
```

This produces, inside `@TRF_UKAF_ACE_Sleeves_Gloves\`:

- `addons\trf_ukaf_ace_sleeves_gloves_main.pbo` — the packed addon
- `addons\trf_ukaf_ace_sleeves_gloves_main.pbo.Darojax.bisign` — its signature
- `keys\Darojax.bikey` — the public key (clients/servers need this to validate)

> The **private** signing key lives in `_private/signing/` and is git-ignored on
> purpose — keep it secret and never commit it.