params ["_unit"];

private _currentUniform = uniform _unit;
private _options = [_unit] call TRF_UKAF_ACE_Sleeves_Gloves_fnc_getCurrentOptions;
private _currentIndex = _options findIf {(_x select 0) isEqualTo _currentUniform};

(_currentIndex >= 0) && {(count _options) > 1}
