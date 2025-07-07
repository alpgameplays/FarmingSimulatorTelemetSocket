import 'dart:async';
import 'dart:io';
import 'fs_telemetry_reader.dart';
import '../models/fs_telemetry.dart';

class TCPTelemetryConnector {
  Socket? _socket;
  final FSTelemetryReader _telemetryReader;
  final String _host;
  final int _port;
  bool _isConnected = false;
  Timer? _reconnectTimer;

  TCPTelemetryConnector({
    required FSTelemetryReader telemetryReader,
    String host = 'localhost',
    int port = 8080,
  })  : _telemetryReader = telemetryReader,
        _host = host,
        _port = port;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      print('Conectando ao Farming Simulator via TCP: $_host:$_port');

      _socket = await Socket.connect(_host, _port);
      _isConnected = true;

      print('Conectado com sucesso!');

      // Escutar dados recebidos
      _socket!.listen(
        (data) {
          final message = String.fromCharCodes(data);
          _telemetryReader.processMessage(message);
        },
        onError: (error) {
          print('Erro na conexão TCP: $error');
          _handleDisconnection();
        },
        onDone: () {
          print('Conexão TCP fechada');
          _handleDisconnection();
        },
      );
    } catch (e) {
      print('Erro ao conectar via TCP: $e');
      _isConnected = false;

      // Tentar reconectar em 5 segundos
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _socket?.destroy();
    _socket = null;
    _isConnected = false;
    print('Desconectado do Farming Simulator');
  }

  void _handleDisconnection() {
    _isConnected = false;
    _socket = null;

    // Tentar reconectar automaticamente
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      if (!_isConnected) {
        print('Tentando reconectar...');
        connect();
      }
    });
  }

  // Método para enviar comandos para o jogo (se necessário)
  void sendCommand(String command) {
    if (_isConnected && _socket != null) {
      _socket!.write(command);
    }
  }
}

// Classe para configurar a conexão
class TelemetryConnectionConfig {
  final String host;
  final int port;
  final bool autoReconnect;
  final Duration reconnectInterval;

  const TelemetryConnectionConfig({
    this.host = 'localhost',
    this.port = 8080,
    this.autoReconnect = true,
    this.reconnectInterval = const Duration(seconds: 5),
  });
}

// Classe principal que combina TCP + TelemetryReader
class FSTelemetryClient {
  final FSTelemetryReader _telemetryReader;
  final TCPTelemetryConnector _tcpConnector;
  final TelemetryConnectionConfig _config;

  FSTelemetryClient({
    TelemetryConnectionConfig? config,
  })  : _config = config ?? const TelemetryConnectionConfig(),
        _telemetryReader = FSTelemetryReader(),
        _tcpConnector = TCPTelemetryConnector(
          telemetryReader: FSTelemetryReader(),
          host: config?.host ?? 'localhost',
          port: config?.port ?? 8080,
        );

  FSTelemetryReader get telemetryReader => _telemetryReader;
  bool get isConnected => _tcpConnector.isConnected;

  Future<void> connect() async {
    await _tcpConnector.connect();
  }

  void disconnect() {
    _tcpConnector.disconnect();
  }

  void start() {
    _telemetryReader.start();
  }

  void stop() {
    _telemetryReader.stop();
    disconnect();
  }

  // Configurar callback para telemetria
  set onTelemetryRead(OnTelemetryRead callback) {
    _telemetryReader.onTelemetryRead = callback;
  }

  // Stream de telemetria
  Stream<FSTelemetry> get telemetryStream => _telemetryReader.telemetryStream;
}
