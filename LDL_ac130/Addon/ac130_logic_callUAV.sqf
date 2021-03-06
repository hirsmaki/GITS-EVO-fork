/*	ac130_logic_callUAV.sqf for AC130-Script
*	@author: LurchiDerLurch
*	@param: nothing
*	@return: nothing
*	@description: 
*/

if(!isServer)exitWith{};

//local variables
private ["_objects","_object","_i"];

_objects = synchronizedObjects (_this select 0);

for [{_i = 0},{_i < count _objects},{_i = _i + 1}] do 
{
	_object = (_objects select _i);
	_object addAction ["Call UAV", "LDL_ac130\Actions\uav_action_map.sqf"];
};

sleep 3;

if(isNil "LDL_initDone") exitWith
{
	hintc "Missing 'LDL AC-130 Init' ('Logics' -> 'LDL Logics')";
};