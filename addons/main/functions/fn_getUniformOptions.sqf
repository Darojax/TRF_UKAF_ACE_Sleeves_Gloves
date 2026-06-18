params ["_uniformClass"];

if (_uniformClass isEqualTo "") exitWith {[]};

private _tokens = _uniformClass splitString "_";
private _options = [];
private _appendItemSuffix = "";

private _familyEnabled = {
    params ["_familyName", "_defaultValue"];

    missionNamespace getVariable [format ["TRF_UKAF_ACE_Sleeves_Gloves_enable%1", _familyName], _defaultValue]
};

if (
    (count _tokens > 0)
    && {(_tokens select ((count _tokens) - 1)) isEqualTo "U"}
) then {
    _appendItemSuffix = "_U";
    _tokens resize ((count _tokens) - 1);
};

private _pushIfExists = {
    params ["_candidateClass", "_sleeveState", "_gloveState"];

    if (isClass (configFile >> "CfgWeapons" >> _candidateClass)) then {
        _options pushBack [_candidateClass, _sleeveState, _gloveState];
    };
};

if (
    (count _tokens >= 4)
    && {(_tokens select 0) isEqualTo "TRF"}
    && {(_tokens select 1) isEqualTo "PCS"}
) then {
    if !(["PCS", true] call _familyEnabled) exitWith {[]};

    private _groupTokens = _tokens select [3, (count _tokens) - 4];
    private _groupPrefix = if (_groupTokens isEqualTo []) then {""} else {(_groupTokens joinString "_") + "_"};

    {
        private _sleeveState = _x;

        {
            private _gloveState = _x;
            private _candidateClass = format ["TRF_PCS_%1_%2%3%4", _sleeveState, _groupPrefix, _gloveState, _appendItemSuffix];

            [_candidateClass, _sleeveState, _gloveState] call _pushIfExists;
        } forEach ["G", "NG"];
    } forEach ["FS", "HS", "RS"];

    _options
} else {
    if (
        (count _tokens >= 3)
        && {(_tokens select 0) isEqualTo "TRF"}
        && {(_tokens select 1) isEqualTo "PCU"}
    ) then {
        if !(["PCU", true] call _familyEnabled) exitWith {[]};

        private _groupTokens = _tokens select [2, (count _tokens) - 3];
        private _groupPrefix = if (_groupTokens isEqualTo []) then {""} else {(_groupTokens joinString "_") + "_"};

        {
            private _gloveState = _x;
            private _candidateClass = format ["TRF_PCU_%1%2%3", _groupPrefix, _gloveState, _appendItemSuffix];

            [_candidateClass, "", _gloveState] call _pushIfExists;
        } forEach ["G", "NG"];

        _options
    } else {
        if (
            (count _tokens >= 5)
            && {(_tokens select 0) isEqualTo "TRF"}
            && {(_tokens select 1) isEqualTo "CRYE"}
            && {(_tokens select 2) isEqualTo "G4"}
        ) then {
            if !(["CryeG4", true] call _familyEnabled) exitWith {[]};

            private _groupTokens = _tokens select [3, (count _tokens) - 5];
            private _groupPrefix = if (_groupTokens isEqualTo []) then {""} else {(_groupTokens joinString "_") + "_"};

            {
                private _sleeveState = _x;

                {
                    private _gloveState = _x;
                    private _candidateClass = format ["TRF_CRYE_G4_%1%2_%3%4", _groupPrefix, _gloveState, _sleeveState, _appendItemSuffix];

                    [_candidateClass, _sleeveState, _gloveState] call _pushIfExists;
                } forEach ["G", "NG"];
            } forEach ["FS", "RS"];

            _options
        } else {
            if (
                (count _tokens >= 3)
                && {(count _tokens) <= 4}
                && {(_tokens select 0) isEqualTo "16AA"}
                && {(_tokens select 1) isEqualTo "PCS"}
            ) then {
                if !(["16AA", true] call _familyEnabled) exitWith {[]};

                private _groupToken = _tokens select ((count _tokens) - 1);

                private _sleeveTokens = [["FS", ""], ["HS", "H"], ["RS", "R"]];
                private _gloveTokens = [["G", "G"], ["NG", ""]];

                {
                    _x params ["_sleeveState", "_sleeveToken"];

                    {
                        _x params ["_gloveState", "_gloveToken"];

                        private _combinedToken = _sleeveToken + _gloveToken;
                        private _candidatePrefix = if (_combinedToken isEqualTo "") then {""} else {_combinedToken + "_"};
                        private _candidateClass = format ["16AA_PCS_%1%2%3", _candidatePrefix, _groupToken, _appendItemSuffix];

                        [_candidateClass, _sleeveState, _gloveState] call _pushIfExists;
                    } forEach _gloveTokens;
                } forEach _sleeveTokens;

                _options
            } else {
                []
            };
        };
    };
};
