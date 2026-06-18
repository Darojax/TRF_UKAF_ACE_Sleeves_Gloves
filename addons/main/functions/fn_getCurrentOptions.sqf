params ["_unit"];

if (isNull _unit) exitWith {[]};

[uniform _unit] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_getUniformOptions
