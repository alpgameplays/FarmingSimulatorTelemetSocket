import '../lib/models/fs_telemetry.dart';
import '../lib/services/fs_telemetry_reader.dart';

void main() async {
  print('=== Farming Simulator Telemetry Reader ===');
  
  // Criar instância do leitor de telemetria
  final telemetryReader = FSTelemetryReader();
  
  // Configurar callback para quando telemetria for lida
  telemetryReader.onTelemetryRead = (telemetry) {
    print('\n--- Dados de Telemetria Atualizados ---');
    print('Veículo: ${telemetry.vehicleName.isEmpty ? "N/A" : telemetry.vehicleName}');
    print('Velocidade: ${telemetry.speed.toStringAsFixed(1)} km/h');
    print('RPM: ${telemetry.rpm}');
    print('Marcha: ${telemetry.gear}');
    print('Combustível: ${telemetry.fuel.toStringAsFixed(1)}/${telemetry.fuelMax.toStringAsFixed(1)} L');
    print('Motor Ligado: ${telemetry.isEngineStarted ? "Sim" : "Não"}');
    print('Temperatura: ${telemetry.motorTemperature.toStringAsFixed(1)}°C');
    print('Dinheiro: R\$ ${telemetry.money.toStringAsFixed(2)}');
    print('Dia: ${telemetry.day}');
    print('Tempo do Dia: ${telemetry.dayTimeMinutes} min');
    print('Clima: ${_getWeatherText(telemetry.weatherCurrent)}');
    print('----------------------------------------');
  };
  
  // Iniciar leitura de telemetria
  print('Iniciando leitura de telemetria...');
  telemetryReader.start();
  
  // Aguardar alguns segundos para ver os dados simulados
  await Future.delayed(Duration(seconds: 10));
  
  // Parar leitura
  print('\nParando leitura de telemetria...');
  telemetryReader.stop();
  
  print('Exemplo concluído!');
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