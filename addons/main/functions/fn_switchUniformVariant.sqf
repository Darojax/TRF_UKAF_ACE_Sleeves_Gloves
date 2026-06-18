params ["_unit", "_targetUniformClass"];

if (
    isNull _unit
    || {_targetUniformClass isEqualTo ""}
    || {!local _unit}
    || {uniform _unit isEqualTo _targetUniformClass}
    || {!(isClass (configFile >> "CfgWeapons" >> _targetUniformClass))}
) exitWith {false};

[_unit, _targetUniformClass] spawn {
    params ["_unit", "_targetUniformClass"];

    waitUntil {
        sleep 0.05;
        !isSwitchingWeapon _unit
    };

    private _oldContainer = uniformContainer _unit;
    if (isNull _oldContainer) exitWith {};

    private _itemCargo = getItemCargo _oldContainer;
    private _magazineCargo = magazinesAmmo _oldContainer;
    private _weaponCargo = weaponsItemsCargo _oldContainer;
    private _backpackCargo = getBackpackCargo _oldContainer;

    private _selectedWeapon = currentWeapon _unit;

    removeUniform _unit;
    _unit forceAddUniform _targetUniformClass;

    private _newContainer = uniformContainer _unit;
    if (isNull _newContainer) exitWith {};

    clearItemCargoGlobal _newContainer;
    clearMagazineCargoGlobal _newContainer;
    clearWeaponCargoGlobal _newContainer;
    clearBackpackCargoGlobal _newContainer;

    private _itemClasses = _itemCargo select 0;
    private _itemCounts = _itemCargo select 1;

    {
        _newContainer addItemCargoGlobal [_x, _itemCounts select _forEachIndex];
    } forEach _itemClasses;

    {
        _x params ["_magazineClass", "_ammoCount"];
        _newContainer addMagazineAmmoCargo [_magazineClass, 1, _ammoCount];
    } forEach _magazineCargo;

    {
        _newContainer addWeaponWithAttachmentsCargoGlobal [_x, 1];
    } forEach _weaponCargo;

    private _backpackClasses = _backpackCargo select 0;
    private _backpackCounts = _backpackCargo select 1;

    {
        _newContainer addBackpackCargoGlobal [_x, _backpackCounts select _forEachIndex];
    } forEach _backpackClasses;

    if (_selectedWeapon != "") then {
        _unit selectWeapon _selectedWeapon;
    };
};

true
