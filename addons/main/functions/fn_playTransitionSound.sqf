params ["_unit", "_soundType"];

if (
    isNull _unit
    || {!(missionNamespace getVariable ["TRF_UKAF_ACE_Sleeves_Gloves_enableSounds", true])}
) exitWith {};

private _volume = missionNamespace getVariable ["TRF_UKAF_ACE_Sleeves_Gloves_soundVolume", 1];
if (_volume <= 0) exitWith {};

private _soundPathPool = switch (_soundType) do {
    case "gloves_on": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\gloves_on_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\gloves_on_02.ogg"
        ]
    };
    case "gloves_off": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\gloves_off_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\gloves_off_02.ogg"
        ]
    };
    case "sleeves_roll_short": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_roll_short_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_roll_short_02.ogg"
        ]
    };
    case "sleeves_roll_long": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_roll_long_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_roll_long_02.ogg"
        ]
    };
    case "sleeves_unroll_short": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_unroll_short_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_unroll_short_02.ogg"
        ]
    };
    case "sleeves_unroll_long": {
        [
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_unroll_long_01.ogg",
            "z\trf_ukaf_ace_sleeves_gloves\addons\main\sounds\sleeves_unroll_long_02.ogg"
        ]
    };
    default {[]};
};

if (_soundPathPool isEqualTo []) exitWith {};

private _soundPath = selectRandom _soundPathPool;
private _pitch = 0.97 + (random 0.06);

diag_log format [
    "[TRF_UKAF_ACE_SG] playSoundUI soundPath=%1 soundType=%2 pitch=%3 volume=%4 unit=%5",
    _soundPath,
    _soundType,
    _pitch,
    _volume,
    typeOf _unit
];

playSoundUI [_soundPath, _volume, _pitch, false, 0, false];
