params ["_unit", "_sourceUniformClass", "_targetUniformClass", "_label", "_icon", "_duration", "_progressText", "_soundType"];

private _statement = {
    params ["_target", "_player", "_params"];
    _params params ["_sourceUniformClass", "_targetUniformClass", "_duration", "_progressText", "_soundType"];

    [_player, _sourceUniformClass, _targetUniformClass, _duration, _progressText, _soundType] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_startUniformTransition;
};

private _condition = {
    params ["_target", "_player", "_params"];
    _params params ["_sourceUniformClass", "_targetUniformClass"];

    alive _player
    && {!isSwitchingWeapon _player}
    && {uniform _player isEqualTo _sourceUniformClass}
    && {uniform _player != _targetUniformClass}
};

private _action = [
    format ["TRF_UKAF_SetUniform_%1_to_%2", _sourceUniformClass, _targetUniformClass],
    _label,
    _icon,
    _statement,
    _condition,
    {},
    [_sourceUniformClass, _targetUniformClass, _duration, _progressText, _soundType]
] call ace_interact_menu_fnc_createAction;

[_action, [], _unit]
