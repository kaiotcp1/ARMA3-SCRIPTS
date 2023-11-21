// Infantry Occupy House - Kaio
// by Zenophon
// GIT >>


_grupoSoldadosObjeto = nil; // Inicializa a variável de controle do grupo
_enableScript = true;



while { _enableScript } do {
	private ["_triggerName", "_securityLocal", "_ammoBox"];

	_triggerName = _this select 0;
	_securityLocal = _this select 1;
	_ammoBox = _this select 2;

	_triggerPos = getPos _triggerName;
	_securityLocation = _securityLocal;
	_playersInRange = [];

     if (!_enableScript) exitWith {};

	// Verificar se pelo menos um jogador está a menos de 600 metros de distância do _triggerPos
	{
		if (player distance _triggerPos < 600) then {
			_playersInRange pushBack _x;
			_distanceStr = player distance _triggerPos;
			hint str _distanceStr;
		}
	} forEach allPlayers;

	    // Se pelo menos um jogador estiver dentro da faixa e o grupo ainda não foi gerado
	if (count _playersInRange > 0 && isNil "_grupoSoldadosObjeto") then {
		// spawn do grupo diretamente e obter o objeto do grupo
		_grupoSoldadosObjeto = [_securityLocation, WEST, ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_grenadier_rpg",
			"rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_machinegunner",
		"rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_machinegunner"],
	[], [], [], [], [], 230] call BIS_fnc_spawnGroup;

	_grupoSoldadosObjeto deleteGroupWhenEmpty true;

	        // Iterar pelos membros do grupo e definir a posição de cada um
	{
		_soldado = _x;
		_soldado setPosATL _triggerPos;
		_soldado allowDamage false;
        sleep 1;
	} forEach units _grupoSoldadosObjeto;

	sleep 2;

	{
		_soldado = _x;
		_soldado allowDamage true;
	} forEach units _grupoSoldadosObjeto;

	sleep 1;
	[_grupoSoldadosObjeto, _triggerPos] execVM "\x\cba\addons\ai\fnc_waypointGarrison.sqf";
} else {
	// Se o grupo já foi gerado ou não há jogadores dentro da faixa
	_totalGrupos = count allGroups;
    hint format ["Total de grupos no mapa: %1", _totalGrupos];
};

if (player distance _triggerPos > 600 && !isNil "_grupoSoldadosObjeto") then {
	// Deletar cada membro do grupo
	{
		_soldado = _x;
		deleteVehicle _soldado;
	} forEach units _grupoSoldadosObjeto;

	        // Aguardar até que todos os veículos (membros do grupo) sejam deletados
	waitUntil {
		sleep 5;
		{
			!alive _x
		} count units _grupoSoldadosObjeto == 0
	};

     // Deletar o grupo após deletar todos os membros
	deleteGroup _grupoSoldadosObjeto;
};

if (!alive _ammoBox) then {
		deleteVehicle _triggerName;
		hint "Trigger deletado com sucesso";
        _marker1 = ["markername1", _triggerPos, "ELLIPSE", [600, 600], "COLOR:", "ColorGreen", "PERSIST", "GRID"] call CBA_fnc_createMarker;
        _enableScript = false;
	};

sleep 10;
}