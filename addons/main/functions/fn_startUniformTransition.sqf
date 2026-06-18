params ["_unit", "_sourceUniformClass", "_targetUniformClass", "_duration", "_progressText", "_soundType"];

if (
    isNull _unit
    || {!local _unit}
    || {_sourceUniformClass isEqualTo ""}
    || {_targetUniformClass isEqualTo ""}
    || {uniform _unit != _sourceUniformClass}
    || {isSwitchingWeapon _unit}
) exitWith {false};

[_unit, _soundType] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_playTransitionSound;

private _onFinish = {
    params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
    _args params ["_unit", "_sourceUniformClass", "_targetUniformClass"];

    [_unit, _targetUniformClass] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_switchUniformVariant;
};

private _onCondition = {
    params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
    _args params ["_unit", "_sourceUniformClass"];

    alive _unit
    && {!isSwitchingWeapon _unit}
    && {uniform _unit isEqualTo _sourceUniformClass}
    && {[_unit, _unit, []] call ace_common_fnc_canInteractWith}
};

[
    _duration,
    [_unit, _sourceUniformClass, _targetUniformClass],
    _onFinish,
    {},
    _progressText,
    _onCondition,
    []
] call ace_common_fnc_progressBar;

true
