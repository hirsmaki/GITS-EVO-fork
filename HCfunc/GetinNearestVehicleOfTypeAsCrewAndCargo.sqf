// Arma 2 function
// This currently will only work with drivers and squads of one unit.

private ["_VehicleTypes","_Groups","_NumGroups","_NumSquadsLoaded","_gi","_Group","_Units",
         "_NumUnits","_Leader","_Unit","_PosLeader","_NearestVehicles","_FoundVehicle",
         "_nv","_vi","_Vehicle","_NewWaypoint","_VehicleCrewCapacity","_FreeCargoCapacity",
         "_TotalFree","_LoadingUnits","_CrewUnits","_CargoUnits"];

_VehicleTypes = + (_this select 0);
_Groups = + (_this select 1);

_NumGroups = count _Groups;
_NumSquadsLoaded = 0;

for [{ _gi = 0 }, { _gi < _NumGroups }, { _gi = _gi + 1 }] do {

	_Group = _Groups select _gi;
	_Units = units _Group;
	_NumUnits = count _Units;
	_Leader = leader _Group;

	if ( _Units call F_AllUnitsAreOnFoot ) then {

		_PosLeader = position _Leader;
		_NearestVehicles = nearestObjects [_PosLeader, _VehicleTypes, 100];
		_FoundVehicle = false;
		_nv = count _NearestVehicles;
		_vi = 0;

		while { (! _FoundVehicle) && (_vi < _nv) } do {

			_Vehicle = _NearestVehicles select _vi;
			_VehicleCrewCapacity = _Vehicle call F_VehicleCrewCapacity;
			_FreeCargoCapacity = _Vehicle call F_VehicleNumUnassignedCargo;
			_TotalFree = _VehicleCrewCapacity + _FreeCargoCapacity;
			
			if ( (!(_Vehicle call F_VehicleHasCrew)) 
			     && (_NumUnits <= _TotalFree) 
			     && (((getPosATL _Vehicle) select 2) <= 0.5) ) then {

				_LoadingUnits = [_Units, _VehicleCrewCapacity, _FreeCargoCapacity]
				                             call F_SeparateOutNewCrewAndCargoUnits;
				_CrewUnits = _LoadingUnits select 0;
				_CargoUnits = _LoadingUnits select 1;		
				
				[_CrewUnits, _Vehicle] call F_AssignCrewUnits;
				[_CargoUnits, _Vehicle] call F_AssignCargoUnits;

				[_Group, false] call F_DeleteGroupWaypoints;
				_Units orderGetIn true;
				_NewWaypoint = _Group addWaypoint [position _Vehicle, 0];
				_NewWaypoint setWaypointType "GETIN";
				_NumSquadsLoaded = _NumSquadsLoaded + 1;
				_FoundVehicle = true;
			};
			_vi = _vi + 1;
		};
	};
};

hintSilent format ["No. squads loading = %1 of %2 squads.", 
                   _NumSquadsLoaded, _NumGroups];

nil;
