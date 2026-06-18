[
    "TRF_UKAF_ACE_Sleeves_Gloves_gloveDuration",
    "SLIDER",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_GLOVE_DURATION",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_GLOVE_DURATION_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_TIMINGS"
    ],
    [0, 10, 2, 1],
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_sleeveStepDuration",
    "SLIDER",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_SLEEVE_STEP_DURATION",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_SLEEVE_STEP_DURATION_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_TIMINGS"
    ],
    [0, 10, 2, 1],
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_enablePCS",
    "CHECKBOX",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_PCS",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_PCS_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_FAMILIES"
    ],
    true,
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_enablePCU",
    "CHECKBOX",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_PCU",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_PCU_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_FAMILIES"
    ],
    true,
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_enableCryeG4",
    "CHECKBOX",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_CRYE_G4",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_CRYE_G4_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_FAMILIES"
    ],
    true,
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_enable16AA",
    "CHECKBOX",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_16AA",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_16AA_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_FAMILIES"
    ],
    true,
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_enableSounds",
    "CHECKBOX",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_SOUNDS",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_ENABLE_SOUNDS_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_AUDIO"
    ],
    true,
    1
] call CBA_fnc_addSetting;

[
    "TRF_UKAF_ACE_Sleeves_Gloves_soundVolume",
    "SLIDER",
    [
        localize "STR_TRF_UKAF_ACE_SG_SETTING_SOUND_VOLUME",
        localize "STR_TRF_UKAF_ACE_SG_SETTING_SOUND_VOLUME_DESC"
    ],
    [
        localize "STR_TRF_UKAF_ACE_SG_CATEGORY",
        localize "STR_TRF_UKAF_ACE_SG_SUBCATEGORY_AUDIO"
    ],
    [0, 2, 1, 2],
    1
] call CBA_fnc_addSetting;
