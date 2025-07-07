import 'package:flutter/material.dart';
import '../models/fs_telemetry.dart';
import '../services/fs_telemetry_reader.dart';

class TelemetryDashboard extends StatefulWidget {
  const TelemetryDashboard({Key? key}) : super(key: key);

  @override
  State<TelemetryDashboard> createState() => _TelemetryDashboardState();
}

class _TelemetryDashboardState extends State<TelemetryDashboard> {
  final FSTelemetryReader _telemetryReader = FSTelemetryReader();
  FSTelemetry _currentTelemetry = FSTelemetry();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _setupTelemetryReader();
  }

  void _setupTelemetryReader() {
    _telemetryReader.onTelemetryRead = (telemetry) {
      setState(() {
        _currentTelemetry = telemetry;
      });
    };
  }

  void _toggleConnection() {
    if (_isConnected) {
      _telemetryReader.stop();
      setState(() {
        _isConnected = false;
      });
    } else {
      _telemetryReader.start();
      setState(() {
        _isConnected = true;
      });
    }
  }

  @override
  void dispose() {
    _telemetryReader.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Simulator Telemetry'),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(_isConnected ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleConnection,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.green[100]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConnectionStatus(),
              const SizedBox(height: 20),
              _buildGameDataSection(),
              const SizedBox(height: 20),
              _buildVehicleDataSection(),
              const SizedBox(height: 20),
              _buildEngineDataSection(),
              const SizedBox(height: 20),
              _buildLightingDataSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              _isConnected ? 'Conectado' : 'Desconectado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameDataSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados do Jogo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildDataRow('Dinheiro',
                'R\$ ${_currentTelemetry.money.toStringAsFixed(2)}'),
            _buildDataRow('Dia', '${_currentTelemetry.day}'),
            _buildDataRow(
                'Tempo do Dia', '${_currentTelemetry.dayTimeMinutes} min'),
            _buildDataRow('Temperatura Min',
                '${_currentTelemetry.temperatureMin.toStringAsFixed(1)}°C'),
            _buildDataRow('Temperatura Max',
                '${_currentTelemetry.temperatureMax.toStringAsFixed(1)}°C'),
            _buildDataRow('Tendência',
                _getTemperatureTrendText(_currentTelemetry.temperatureTrend)),
            _buildDataRow('Clima Atual',
                _getWeatherText(_currentTelemetry.weatherCurrent)),
            _buildDataRow('Próximo Clima',
                _getWeatherText(_currentTelemetry.weatherNext)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDataSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados do Veículo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildDataRow(
                'Nome',
                _currentTelemetry.vehicleName.isEmpty
                    ? 'N/A'
                    : _currentTelemetry.vehicleName),
            _buildDataRow('Velocidade',
                '${_currentTelemetry.speed.toStringAsFixed(1)} km/h'),
            _buildDataRow(
                'Desgaste', '${_currentTelemetry.wear.toStringAsFixed(1)}%'),
            _buildDataRow('Combustível',
                '${_currentTelemetry.fuel.toStringAsFixed(1)}/${_currentTelemetry.fuelMax.toStringAsFixed(1)} L'),
            _buildDataRow('Tipo de Combustível',
                _getFuelTypeText(_currentTelemetry.fuelType)),
            _buildDataRow(
                'Massa', '${_currentTelemetry.mass.toStringAsFixed(1)} kg'),
            _buildDataRow('Massa Total',
                '${_currentTelemetry.totalMass.toStringAsFixed(1)} kg'),
            _buildDataRow(
                'No Campo', _currentTelemetry.isOnField ? 'Sim' : 'Não'),
          ],
        ),
      ),
    );
  }

  Widget _buildEngineDataSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados do Motor',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildDataRow('Motor Ligado',
                _currentTelemetry.isEngineStarted ? 'Sim' : 'Não'),
            _buildDataRow('RPM',
                '${_currentTelemetry.rpm} (${_currentTelemetry.rpmMin}-${_currentTelemetry.rpmMax})'),
            _buildDataRow('Marcha', '${_currentTelemetry.gear}'),
            _buildDataRow(
                'Automático', _currentTelemetry.isAutomatic ? 'Sim' : 'Não'),
            _buildDataRow('Temperatura',
                '${_currentTelemetry.motorTemperature.toStringAsFixed(1)}°C'),
            _buildDataRow('Ventilador',
                _currentTelemetry.isMotorFanEnabled ? 'Ligado' : 'Desligado'),
            _buildDataRow('Tempo de Operação',
                '${_currentTelemetry.operationTimeMinutes} min'),
          ],
        ),
      ),
    );
  }

  Widget _buildLightingDataSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Iluminação e Controles',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildDataRow('Luzes',
                _currentTelemetry.isLightOn ? 'Ligadas' : 'Desligadas'),
            _buildDataRow('Luz Alta',
                _currentTelemetry.isLightHighOn ? 'Ligada' : 'Desligada'),
            _buildDataRow('Pisca Direita',
                _currentTelemetry.isLightTurnRightOn ? 'Ligado' : 'Desligado'),
            _buildDataRow('Pisca Esquerda',
                _currentTelemetry.isLightTurnLeftOn ? 'Ligado' : 'Desligado'),
            _buildDataRow('Luz de Emergência',
                _currentTelemetry.isLightHazardOn ? 'Ligada' : 'Desligada'),
            _buildDataRow('Farol Rotativo',
                _currentTelemetry.isLightBeaconOn ? 'Ligado' : 'Desligado'),
            _buildDataRow('Limpadores',
                _currentTelemetry.isWipersOn ? 'Ligados' : 'Desligados'),
            _buildDataRow('Controle de Cruzeiro',
                _currentTelemetry.isCruiseControlOn ? 'Ligado' : 'Desligado'),
            if (_currentTelemetry.isCruiseControlOn)
              _buildDataRow('Velocidade Cruzeiro',
                  '${_currentTelemetry.cruiseControlSpeed} km/h'),
            _buildDataRow('Freio de Mão',
                _currentTelemetry.isHandBrakeOn ? 'Ativado' : 'Desativado'),
            _buildDataRow(
                'Buzina', _currentTelemetry.isHonkOn ? 'Ativa' : 'Inativa'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getTemperatureTrendText(TemperatureTrendType trend) {
    switch (trend) {
      case TemperatureTrendType.rising:
        return 'Subindo';
      case TemperatureTrendType.dropping:
        return 'Caindo';
      case TemperatureTrendType.stable:
        return 'Estável';
    }
  }

  String _getWeatherText(WeatherType weather) {
    switch (weather) {
      case WeatherType.sun:
        return 'Ensolarado';
      case WeatherType.rain:
        return 'Chuva';
      case WeatherType.cloud:
        return 'Nublado';
      case WeatherType.snow:
        return 'Neve';
    }
  }

  String _getFuelTypeText(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.electric:
        return 'Elétrico';
      case FuelType.methane:
        return 'Metano';
      case FuelType.undefined:
        return 'Indefinido';
    }
  }
}
