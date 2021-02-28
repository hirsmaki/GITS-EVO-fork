disableSerialization;
closeDialog 0;
sleep 0.3;

if(BIS_EVO_MissionProgress > -1) exitWith {hint "Mission already in progress."};

_player = _this select 0;
_id = _this select 2;
_map = objNull;

mapRefresh = false;
cityToAttack = -1;
openMap true;
hint "Pick a city to assault";
mapclick = true;
_cursorPos = [];

onMapSingleClick "
  _marker= createMarker ['marker1',[0,0,0]];
                  _marker setMarkerColor 'ColorGreen';
                _marker setMarkerShape 'ELLIPSE';
                _marker setMarkerBrush 'Solid';
                _marker setMarkerSize [200, 200];

mapRefresh = true;
_nearestMarker = [BIS_EVO_MissionTowns, _pos] call BIS_fnc_nearestPosition;
cityToAttack = BIS_EVO_MissionTowns find _nearestMarker;
_dist = _pos distance getMarkerPos _nearestMarker;

if(_dist < 300) then {'marker1' setMarkerPos getMarkerPos _nearestMarker;}
else {
deleteMarker 'marker1';
cityToAttack = -1;
};
if(cityToAttack > -1) then {hint format ['Selected: %1', BIS_EVO_Townnames select 0];}
	else { hint 'No selection.'};
true;";

waitUntil{!visibleMap};
onMapSingleClick "";
deleteMarker "marker1";

if(cityToAttack > -1 and !(BIS_EVO_MissionTowns select cityToAttack in BIS_EVO_conqueredTowns)) then 
{
  hint format ["Launching assault on an %1!",BIS_EVO_Townnames select 0];
  BIS_EVO_MissionProgress = cityToAttack;
  publicVariable "BIS_EVO_MissionProgress";
  if(isServer) then 
  {
    _events = [] execVM "data\scripts\EVO_MissionManager.sqf";
  };
  closeDialog 0;
}
else 
{
  hint "Assault planning cancelled!";
  BIS_EVO_Onmission=false;
  closeDialog 0;
};
