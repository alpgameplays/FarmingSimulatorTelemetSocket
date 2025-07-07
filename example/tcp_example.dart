import '../lib/models/fs_telemetry.dart';
import '../lib/services/tcp_telemetry_connector.dart';

void main() async {
  print('=== Farming Simulator Telemetry TCP Client ===');

  // Configurar conexão
  final config = TelemetryConnectionConfig(
    host: 'localhost',
    port: 8080,
    autoReconnect: true,
    reconnectInterval: Duration(seconds: 5),
  );

  // Criar cliente de telemetria
  final client = FSTelemetryClient(config: config);

  // Configurar callback para telemetria
  client.onTelemetryRead = (telemetry) {
    print('\n--- Dados de Telemetria (TCP) ---');
    print('Status: ${client.isConnected ? "Conectado" : "Desconectado"}');
    print(
        'Veículo: ${telemetry.vehicleName.isEmpty ? "N/A" : telemetry.vehicleName}');
    print('Velocidade: ${telemetry.speed.toStringAsFixed(1)} km/h');
    print('RPM: ${telemetry.rpm}');
    print('Marcha: ${telemetry.gear}');
    print(
        'Combustível: ${telemetry.fuel.toStringAsFixed(1)}/${telemetry.fuelMax.toStringAsFixed(1)} L');
    print('Motor Ligado: ${telemetry.isEngineStarted ? "Sim" : "Não"}');
    print('Temperatura: ${telemetry.motorTemperature.toStringAsFixed(1)}°C');
    print('Dinheiro: R\$ ${telemetry.money.toStringAsFixed(2)}');
    print('Dia: ${telemetry.day}');
    print('Tempo do Dia: ${telemetry.dayTimeMinutes} min');
    print('Clima: ${_getWeatherText(telemetry.weatherCurrent)}');
    print('----------------------------------------');
  };

  // Conectar ao Farming Simulator
  print('Tentando conectar ao Farming Simulator...');
  await client.connect();

  // Iniciar leitura de telemetria
  print('Iniciando leitura de telemetria...');
  client.start();

  // Aguardar alguns segundos
  await Future.delayed(Duration(seconds: 15));

  // Parar e desconectar
  print('\nParando cliente de telemetria...');
  client.stop();

  print('Exemplo TCP concluído!');
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
