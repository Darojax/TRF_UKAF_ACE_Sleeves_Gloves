params ["_unit"];

private _currentUniform = uniform _unit;
private _options = [_unit] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_getCurrentOptions;
private _actions = [];
private _isCryeG4 = (_currentUniform find "TRF_CRYE_G4_") isEqualTo 0;
private _gloveDuration = missionNamespace getVariable ["TRF_UKAF_ACE_Sleeves_Gloves_gloveDuration", 2];
private _sleeveStepDuration = missionNamespace getVariable ["TRF_UKAF_ACE_Sleeves_Gloves_sleeveStepDuration", 2];
private _gloveIcon = "";
private _sleeveIcon = "";

private _currentIndex = _options findIf {(_x select 0) isEqualTo _currentUniform};
if (_currentIndex < 0) exitWith {[]};

private _currentOption = _options select _currentIndex;
_currentOption params ["", "_currentSleeveState", "_currentGloveState"];

private _availableSleeveStates = [];
{
    private _sleeveState = _x select 1;
    private _gloveState = _x select 2;

    if (
        _sleeveState != ""
        && {_gloveState isEqualTo _currentGloveState}
        && {!(_sleeveState in _availableSleeveStates)}
    ) then {
        _availableSleeveStates pushBack _sleeveState;
    };
} forEach _options;

private _orderedSleeveStates = [];
{
    if (_x in _availableSleeveStates) then {
        _orderedSleeveStates pushBack _x;
    };
} forEach ["FS", "HS", "RS"];

private _getSleeveLabel = {
    params ["_sleeveState"];

    switch (_sleeveState) do {
        case "FS": {localize "STR_TRF_UKAF_ACE_SG_SLEEVE_FULL"};
        case "HS": {localize "STR_TRF_UKAF_ACE_SG_SLEEVE_HALF"};
        case "RS": {
            if (_isCryeG4 && {!("HS" in _orderedSleeveStates)}) then {
                localize "STR_TRF_UKAF_ACE_SG_SLEEVE_HALF"
            } else {
                localize "STR_TRF_UKAF_ACE_SG_SLEEVE_ROLLED"
            };
        };
        default {""};
    }
};

private _getSleeveOrder = {
    params ["_sleeveState"];

    _orderedSleeveStates find _sleeveState
};

private _gloveTargetIndex = _options findIf {
    (_x select 1) isEqualTo _currentSleeveState
    && {(_x select 2) != _currentGloveState}
};

if (_gloveTargetIndex >= 0) then {
    private _gloveTargetUniform = (_options select _gloveTargetIndex) select 0;
    private _gloveLabel = if (_currentGloveState isEqualTo "G") then {
        localize "STR_TRF_UKAF_ACE_SG_REMOVE_GLOVES"
    } else {
        localize "STR_TRF_UKAF_ACE_SG_PUT_ON_GLOVES"
    };
    private _gloveProgressText = if (_currentGloveState isEqualTo "G") then {
        localize "STR_TRF_UKAF_ACE_SG_PROGRESS_REMOVING_GLOVES"
    } else {
        localize "STR_TRF_UKAF_ACE_SG_PROGRESS_PUTTING_ON_GLOVES"
    };
    private _gloveSoundType = if (_currentGloveState isEqualTo "G") then {
        "gloves_off"
    } else {
        "gloves_on"
    };

    _actions pushBack (
        [_unit, _currentUniform, _gloveTargetUniform, _gloveLabel, _gloveIcon, _gloveDuration, _gloveProgressText, _gloveSoundType] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_buildVariantAction
    );
};

{
    _x params ["_targetUniformClass", "_targetSleeveState", "_targetGloveState"];

    if (
        _targetUniformClass != _currentUniform
        && {_targetSleeveState != ""}
        && {_targetSleeveState != _currentSleeveState}
        && {_targetGloveState isEqualTo _currentGloveState}
    ) then {
        private _currentOrder = [_currentSleeveState] call _getSleeveOrder;
        private _targetOrder = [_targetSleeveState] call _getSleeveOrder;
        private _stepDistance = abs (_targetOrder - _currentOrder);
        private _duration = _sleeveStepDuration * _stepDistance;
        private _isRolling = _targetOrder > _currentOrder;
        private _progressText = if (_isRolling) then {
            localize "STR_TRF_UKAF_ACE_SG_PROGRESS_ROLLING_SLEEVES"
        } else {
            localize "STR_TRF_UKAF_ACE_SG_PROGRESS_UNROLLING_SLEEVES"
        };
        private _soundType = if (_isRolling) then {
            if (_stepDistance > 1) then {
                "sleeves_roll_long"
            } else {
                "sleeves_roll_short"
            }
        } else {
            if (_stepDistance > 1) then {
                "sleeves_unroll_long"
            } else {
                "sleeves_unroll_short"
            }
        };
        private _label = [_targetSleeveState] call _getSleeveLabel;

        if (_label != "") then {
            _actions pushBack (
                [_unit, _currentUniform, _targetUniformClass, _label, _sleeveIcon, _duration, _progressText, _soundType] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_buildVariantAction
            );
        };
    };
} forEach _options;

_actions
