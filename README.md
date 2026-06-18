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

### Missing uniforms are safe

Every family above is **optional**. The addon builds candidate uniform class names
and only ever offers one if it actually exists in `CfgWeapons`
(`isClass` check in `fn_getUniformOptions`). So if a family — say `16AA_PCS_*` — is
not present in your loaded modpack, those uniforms simply never appear and nothing
breaks. The addon doesn't even hard-depend on the TRF base mod (it only requires
CBA + ACE), so it loads cleanly on its own and just finds nothing to act on. You can
run it with any subset of the families installed.

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

## Extending the mod (adding variants without breaking it)

The golden rule is: **never reference a uniform class directly — always let it be
discovered through the existing `isClass` filter.** That filter is what guarantees a
missing uniform is skipped instead of throwing an error. As long as you follow it,
adding support for more uniforms can never break the mod when those uniforms aren't
installed.

### Adding more variants to an existing family — no code change

If the base mod adds new variants that follow an existing naming convention
(e.g. a new PCS regiment group `TRF_PCS_FS_NEWREGT_G`), **you don't have to touch the
code at all.** When a player wears one, `fn_getUniformOptions` derives the group from
the worn class and enumerates its sleeve states (`FS`/`HS`/`RS`) and glove states
(`G`/`NG`) automatically, keeping only the combinations that exist. New conforming
variants are picked up for free; absent ones are skipped.

The conventions each family branch expects:

| Family | Pattern | Sleeve states | Glove states |
| --- | --- | --- | --- |
| `TRF_PCS` | `TRF_PCS_<sleeve>_<group>_<glove>` | `FS`, `HS`, `RS` | `G`, `NG` |
| `TRF_PCU` | `TRF_PCU_<group>_<glove>` | _(none)_ | `G`, `NG` |
| `TRF_CRYE_G4` | `TRF_CRYE_G4_<group>_<glove>_<sleeve>` | `FS`, `RS` | `G`, `NG` |
| `16AA_PCS` | `16AA_PCS_[<sleeveTok><gloveTok>_]<group>` | `FS`=`""`, `HS`=`H`, `RS`=`R` | `G`=`G`, `NG`=`""` |

A trailing `_U` on the worn class (the item vs. wearable form) is handled
automatically. If a new variant only *partly* follows the scheme, prefer renaming it
to match — that keeps the auto-discovery working.

### Adding a brand-new uniform family

This needs code, but stays crash-safe as long as you reuse the existing pattern:

1. **`addons/main/functions/fn_getUniformOptions.sqf`** — add a new branch that
   recognises the family's prefix and builds candidate class names. Push each
   candidate **only** through the provided `_pushIfExists` helper:

   ```sqf
   // _pushIfExists already guards with isClass — never pushBack a raw class yourself
   [_candidateClass, _sleeveState, _gloveState] call _pushIfExists;
   ```

   Gate the whole branch behind a family toggle, matching the others:

   ```sqf
   if !(["MyFamily", true] call _familyEnabled) exitWith {[]};
   ```

   `_familyEnabled` reads the CBA variable
   `TRF_UKAF_ACE_Sleeves_Gloves_enableMyFamily`.

2. **`addons/main/functions/fn_registerSettings.sqf`** — add a matching `CHECKBOX`
   setting named `TRF_UKAF_ACE_Sleeves_Gloves_enableMyFamily` (copy an existing
   `enablePCS` block) so the family can be toggled in-game.

3. **`addons/main/stringtable.xml`** — add the `STR_…` keys your new setting and any
   new labels reference, in every language section.

4. Rebuild (see *Recompiling the mod after you make changes* above) and test.

Because step 1 routes everything through the `isClass` filter, a new family with no
matching uniforms installed contributes zero options and the action behaves exactly
as before — no errors, no empty menu entries.