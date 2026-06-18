call TRF_UKAF_ACE_Sleeves_Gloves_fnc_registerSettings;

private _condition = {
    params ["_target", "_player", "_params"];

    (_target isEqualTo _player)
    && {alive _player}
    && {!isSwitchingWeapon _player}
    && {[_player, _target, []] call ace_common_fnc_canInteractWith}
    && {[_player] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_hasSupportedUniform}
};

private _insertChildren = {
    params ["_target", "_player", "_params"];

    [_player] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_buildVariantActions
};

private _action = [
    "TRF_UKAF_AdjustSleevesAndGloves",
    localize "STR_TRF_UKAF_ACE_SG_ROOT",
    "",
    {},
    _condition,
    _insertChildren
] call ace_interact_menu_fnc_createAction;

["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;
