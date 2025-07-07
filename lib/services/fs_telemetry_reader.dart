import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';
import '../models/fs_telemetry.dart';

typedef OnTelemetryRead = void Function(FSTelemetry telemetry);

class FSTelemetryReader {
  FSTelemetry _telemetry = FSTelemetry();
  Map<String, dynamic> _telemetryProperties = {};
  Map<int, String> _telemetryIndexes = {};
  bool _active = false;
  StreamController<FSTelemetry>? _telemetryController;
  StreamSubscription<FSTelemetry>? _telemetrySubscription;

  // Named pipe para Windows
  RandomAccessFile? _pipeFile;
  Timer? _readTimer;

  // Callback para quando telemetria é lida
  OnTelemetryRead? onTelemetryRead;

  FSTelemetryReader() {
    _initializeTelemetryProperties();
  }

  void _initializeTelemetryProperties() {
    // Em Dart, usamos reflection para obter as propriedades
    // Como reflection não está disponível em Flutter, vamos usar um mapa manual
    _telemetryProperties = {
      'money': 'money',
      'temperaturemin': 'temperatureMin',
      'temperaturemax': 'temperatureMax',
      'temperaturetrend': 'temperatureTrend',
      'daytimeminutes': 'dayTimeMinutes',
      'weathercurrent': 'weatherCurrent',
      'weathernext': 'weatherNext',
      'day': 'day',
      'gameedition': 'gameEdition',
      'vehiclename': 'vehicleName',
      'wear': 'wear',
      'operationtimeminutes': 'operationTimeMinutes',
      'speed': 'speed',
      'fuelmax': 'fuelMax',
      'fuel': 'fuel',
      'fueltype': 'fuelType',
      'rpmmin': 'rpmMin',
      'rpmmax': 'rpmMax',
      'rpm': 'rpm',
      'isenginestarted': 'isEngineStarted',
      'gear': 'gear',
      'geargroupname': 'gearGroupName',
      'currentgeargroup': 'currentGearGroup',
      'currentgeargroupindex': 'currentGearGroupIndex',
      'geargroupnames': 'gearGroupNames',
      'geargroupratios': 'gearGroupRatios',
      'geargroupcount': 'gearGroupCount',
      'gearmaxspeeds': 'gearMaxSpeeds',
      'gearcount': 'gearCount',
      'gearsavailable': 'gearsAvailable',
      'isautomatic': 'isAutomatic',
      'prevgearname': 'prevGearName',
      'nextgearname': 'nextGearName',
      'prevprevgearname': 'prevPrevGearName',
      'nextnextgearname': 'nextNextGearName',
      'isgearchanging': 'isGearChanging',
      'islighton': 'isLightOn',
      'islighthighon': 'isLightHighOn',
      'islightturnrightenabled': 'isLightTurnRightEnabled',
      'islightturnrighton': 'isLightTurnRightOn',
      'islightturnleftenabled': 'isLightTurnLeftEnabled',
      'islightturnlefton': 'isLightTurnLeftOn',
      'islighthazardon': 'isLightHazardOn',
      'islightbeaconon': 'isLightBeaconOn',
      'iswiperson': 'isWipersOn',
      'iscruisecontrolon': 'isCruiseControlOn',
      'cruisecontrolspeed': 'cruiseControlSpeed',
      'cruisecontrolmaxspeed': 'cruiseControlMaxSpeed',
      'ishandbrakeon': 'isHandBrakeOn',
      'isdrivingvehicle': 'isDrivingVehicle',
      'isaiactive': 'isAiActive',
      'isreversedriving': 'isReverseDriving',
      'ismotorfanenabled': 'isMotorFanEnabled',
      'motortemperature': 'motorTemperature',
      'vehicleprice': 'vehiclePrice',
      'vehiclesellprice': 'vehicleSellPrice',
      'ishonkon': 'isHonkOn',
      'attachedimplementsposition': 'attachedImplementsPosition',
      'attachedimplementslowered': 'attachedImplementsLowered',
      'attachedimplementsselected': 'attachedImplementsSelected',
      'attachedimplementsturnedon': 'attachedImplementsTurnedOn',
      'attachedimplementswear': 'attachedImplementsWear',
      'anglerotation': 'angleRotation',
      'mass': 'mass',
      'totalmass': 'totalMass',
      'isonfield': 'isOnField',
      'defmax': 'defMax',
      'def': 'def',
      'airmax': 'airMax',
      'air': 'air',
    };
  }

  void start() async {
    if (_active) return;

    _active = true;
    _telemetryController = StreamController<FSTelemetry>.broadcast();

    // Iniciar leitura do named pipe
    await _startPipeReader();

    // Escutar eventos de telemetria
    _telemetrySubscription = _telemetryController!.stream.listen((telemetry) {
      onTelemetryRead?.call(telemetry);
    });
  }

  void stop() {
    _active = false;
    _telemetrySubscription?.cancel();
    _telemetryController?.close();
    _readTimer?.cancel();
    _pipeFile?.close();
  }

  Future<void> _startPipeReader() async {
    try {
      // Em Windows, tentar conectar ao named pipe
      if (Platform.isWindows) {
        await _connectToNamedPipe();
      } else {
        // Para outras plataformas, usar TCP ou simular dados
        await _startSimulatedData();
      }
    } catch (e) {
      print('Erro ao iniciar leitor de telemetria: $e');
      // Fallback para dados simulados
      await _startSimulatedData();
    }
  }

  Future<void> _connectToNamedPipe() async {
    try {
      // Tentar conectar ao named pipe do Farming Simulator
      final pipePath = r'\\.\pipe\fssimx';

      // Como Dart não tem suporte nativo a named pipes no Windows,
      // vamos usar uma abordagem alternativa com TCP ou simular
      print('Tentando conectar ao named pipe: $pipePath');

      // Por enquanto, vamos usar dados simulados
      await _startSimulatedData();
    } catch (e) {
      print('Erro ao conectar ao named pipe: $e');
      await _startSimulatedData();
    }
  }

  Future<void> _startSimulatedData() async {
    print('Iniciando dados simulados de telemetria...');

    // Simular dados de telemetria a cada 100ms
    _readTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!_active) {
        timer.cancel();
        return;
      }

      // Simular dados de telemetria
      _simulateTelemetryData();
    });
  }

  void _simulateTelemetryData() {
    // Simular dados básicos
    _telemetry.speed = (DateTime.now().millisecondsSinceEpoch % 100) / 10.0;
    _telemetry.rpm = 1000 + (DateTime.now().millisecondsSinceEpoch % 3000);
    _telemetry.fuel =
        50.0 + (DateTime.now().millisecondsSinceEpoch % 20) / 10.0;
    _telemetry.isEngineStarted = true;
    _telemetry.gear = 1 + (DateTime.now().millisecondsSinceEpoch % 6);

    if (_active) {
      _telemetryController?.add(_telemetry.copy());
    }
  }

  void _processTelemetryIndexes(String headersText) {
    final headers = headersText.split('§');

    for (int i = 1; i < headers.length - 1; i++) {
      final header = headers[i].toLowerCase();

      if (!_telemetryProperties.containsKey(header)) {
        print('Propriedade não encontrada: ${headers[i]}');
        if (_telemetryIndexes.containsKey(i)) {
          _telemetryIndexes.remove(i);
        }
        continue;
      }

      _telemetryIndexes[i] = _telemetryProperties[header]!;
    }
  }

  void _processTelemetry(String telemetryText) {
    print('Processando telemetria: $telemetryText');

    final values = telemetryText.split('§');

    for (int i = 1; i < values.length - 1; i++) {
      if (!_telemetryIndexes.containsKey(i)) continue;

      final propertyName = _telemetryIndexes[i]!;
      final value = values[i];

      _setPropertyValue(propertyName, value);
    }

    if (_active) {
      _telemetryController?.add(_telemetry.copy());
    }
  }

  void _setPropertyValue(String propertyName, String value) {
    try {
      switch (propertyName) {
        case 'money':
        case 'temperatureMin':
        case 'temperatureMax':
        case 'wear':
        case 'speed':
        case 'fuelMax':
        case 'fuel':
        case 'motorTemperature':
        case 'vehiclePrice':
        case 'vehicleSellPrice':
        case 'angleRotation':
        case 'mass':
        case 'totalMass':
        case 'defMax':
        case 'def':
        case 'airMax':
        case 'air':
          final doubleValue = _convertToDouble(value);
          _setFieldValue(propertyName, doubleValue);
          break;

        case 'dayTimeMinutes':
        case 'day':
        case 'operationTimeMinutes':
        case 'rpmMin':
        case 'rpmMax':
        case 'rpm':
        case 'gear':
        case 'currentGearGroupIndex':
        case 'gearGroupCount':
        case 'gearCount':
        case 'cruiseControlSpeed':
        case 'cruiseControlMaxSpeed':
          final intValue = _convertToInt(value);
          _setFieldValue(propertyName, intValue);
          break;

        case 'temperatureTrend':
          final trendValue = _convertToTemperatureTrend(value);
          _setFieldValue(propertyName, trendValue);
          break;

        case 'weatherCurrent':
        case 'weatherNext':
          final weatherValue = _convertToWeatherType(value);
          _setFieldValue(propertyName, weatherValue);
          break;

        case 'gameEdition':
          final editionValue = _convertToGameEditionType(value);
          _setFieldValue(propertyName, editionValue);
          break;

        case 'fuelType':
          final fuelValue = _convertToFuelType(value);
          _setFieldValue(propertyName, fuelValue);
          break;

        case 'isEngineStarted':
        case 'gearsAvailable':
        case 'isAutomatic':
        case 'isGearChanging':
        case 'isLightOn':
        case 'isLightHighOn':
        case 'isLightTurnRightEnabled':
        case 'isLightTurnRightOn':
        case 'isLightTurnLeftEnabled':
        case 'isLightTurnLeftOn':
        case 'isLightHazardOn':
        case 'isLightBeaconOn':
        case 'isWipersOn':
        case 'isCruiseControlOn':
        case 'isHandBrakeOn':
        case 'isDrivingVehicle':
        case 'isAiActive':
        case 'isReverseDriving':
        case 'isMotorFanEnabled':
        case 'isHonkOn':
        case 'isOnField':
          final boolValue = _convertToBoolean(value);
          _setFieldValue(propertyName, boolValue);
          break;

        case 'vehicleName':
        case 'gearGroupName':
        case 'currentGearGroup':
        case 'gearGroupNames':
        case 'gearGroupRatios':
        case 'gearMaxSpeeds':
        case 'prevGearName':
        case 'nextGearName':
        case 'prevPrevGearName':
        case 'nextNextGearName':
          _setFieldValue(propertyName, value);
          break;

        case 'attachedImplementsPosition':
        case 'attachedImplementsLowered':
        case 'attachedImplementsSelected':
        case 'attachedImplementsTurnedOn':
        case 'attachedImplementsWear':
          final arrayValue = _convertToArray(propertyName, value);
          _setFieldValue(propertyName, arrayValue);
          break;
      }
    } catch (e) {
      print('Erro ao definir propriedade $propertyName com valor $value: $e');
    }
  }

  void _setFieldValue(String fieldName, dynamic value) {
    switch (fieldName) {
      case 'money':
        _telemetry.money = value;
        break;
      case 'temperatureMin':
        _telemetry.temperatureMin = value;
        break;
      case 'temperatureMax':
        _telemetry.temperatureMax = value;
        break;
      case 'temperatureTrend':
        _telemetry.temperatureTrend = value;
        break;
      case 'dayTimeMinutes':
        _telemetry.dayTimeMinutes = value;
        break;
      case 'weatherCurrent':
        _telemetry.weatherCurrent = value;
        break;
      case 'weatherNext':
        _telemetry.weatherNext = value;
        break;
      case 'day':
        _telemetry.day = value;
        break;
      case 'gameEdition':
        _telemetry.gameEdition = value;
        break;
      case 'vehicleName':
        _telemetry.vehicleName = value;
        break;
      case 'wear':
        _telemetry.wear = value;
        break;
      case 'operationTimeMinutes':
        _telemetry.operationTimeMinutes = value;
        break;
      case 'speed':
        _telemetry.speed = value;
        break;
      case 'fuelMax':
        _telemetry.fuelMax = value;
        break;
      case 'fuel':
        _telemetry.fuel = value;
        break;
      case 'fuelType':
        _telemetry.fuelType = value;
        break;
      case 'rpmMin':
        _telemetry.rpmMin = value;
        break;
      case 'rpmMax':
        _telemetry.rpmMax = value;
        break;
      case 'rpm':
        _telemetry.rpm = value;
        break;
      case 'isEngineStarted':
        _telemetry.isEngineStarted = value;
        break;
      case 'gear':
        _telemetry.gear = value;
        break;
      case 'gearGroupName':
        _telemetry.gearGroupName = value;
        break;
      case 'currentGearGroup':
        _telemetry.currentGearGroup = value;
        break;
      case 'currentGearGroupIndex':
        _telemetry.currentGearGroupIndex = value;
        break;
      case 'gearGroupNames':
        _telemetry.gearGroupNames = value;
        break;
      case 'gearGroupRatios':
        _telemetry.gearGroupRatios = value;
        break;
      case 'gearGroupCount':
        _telemetry.gearGroupCount = value;
        break;
      case 'gearMaxSpeeds':
        _telemetry.gearMaxSpeeds = value;
        break;
      case 'gearCount':
        _telemetry.gearCount = value;
        break;
      case 'gearsAvailable':
        _telemetry.gearsAvailable = value;
        break;
      case 'isAutomatic':
        _telemetry.isAutomatic = value;
        break;
      case 'prevGearName':
        _telemetry.prevGearName = value;
        break;
      case 'nextGearName':
        _telemetry.nextGearName = value;
        break;
      case 'prevPrevGearName':
        _telemetry.prevPrevGearName = value;
        break;
      case 'nextNextGearName':
        _telemetry.nextNextGearName = value;
        break;
      case 'isGearChanging':
        _telemetry.isGearChanging = value;
        break;
      case 'isLightOn':
        _telemetry.isLightOn = value;
        break;
      case 'isLightHighOn':
        _telemetry.isLightHighOn = value;
        break;
      case 'isLightTurnRightEnabled':
        _telemetry.isLightTurnRightEnabled = value;
        break;
      case 'isLightTurnRightOn':
        _telemetry.isLightTurnRightOn = value;
        break;
      case 'isLightTurnLeftEnabled':
        _telemetry.isLightTurnLeftEnabled = value;
        break;
      case 'isLightTurnLeftOn':
        _telemetry.isLightTurnLeftOn = value;
        break;
      case 'isLightHazardOn':
        _telemetry.isLightHazardOn = value;
        break;
      case 'isLightBeaconOn':
        _telemetry.isLightBeaconOn = value;
        break;
      case 'isWipersOn':
        _telemetry.isWipersOn = value;
        break;
      case 'isCruiseControlOn':
        _telemetry.isCruiseControlOn = value;
        break;
      case 'cruiseControlSpeed':
        _telemetry.cruiseControlSpeed = value;
        break;
      case 'cruiseControlMaxSpeed':
        _telemetry.cruiseControlMaxSpeed = value;
        break;
      case 'isHandBrakeOn':
        _telemetry.isHandBrakeOn = value;
        break;
      case 'isDrivingVehicle':
        _telemetry.isDrivingVehicle = value;
        break;
      case 'isAiActive':
        _telemetry.isAiActive = value;
        break;
      case 'isReverseDriving':
        _telemetry.isReverseDriving = value;
        break;
      case 'isMotorFanEnabled':
        _telemetry.isMotorFanEnabled = value;
        break;
      case 'motorTemperature':
        _telemetry.motorTemperature = value;
        break;
      case 'vehiclePrice':
        _telemetry.vehiclePrice = value;
        break;
      case 'vehicleSellPrice':
        _telemetry.vehicleSellPrice = value;
        break;
      case 'isHonkOn':
        _telemetry.isHonkOn = value;
        break;
      case 'attachedImplementsPosition':
        _telemetry.attachedImplementsPosition = value;
        break;
      case 'attachedImplementsLowered':
        _telemetry.attachedImplementsLowered = value;
        break;
      case 'attachedImplementsSelected':
        _telemetry.attachedImplementsSelected = value;
        break;
      case 'attachedImplementsTurnedOn':
        _telemetry.attachedImplementsTurnedOn = value;
        break;
      case 'attachedImplementsWear':
        _telemetry.attachedImplementsWear = value;
        break;
      case 'angleRotation':
        _telemetry.angleRotation = value;
        break;
      case 'mass':
        _telemetry.mass = value;
        break;
      case 'totalMass':
        _telemetry.totalMass = value;
        break;
      case 'isOnField':
        _telemetry.isOnField = value;
        break;
      case 'defMax':
        _telemetry.defMax = value;
        break;
      case 'def':
        _telemetry.def = value;
        break;
      case 'airMax':
        _telemetry.airMax = value;
        break;
      case 'air':
        _telemetry.air = value;
        break;
    }
  }

  double _convertToDouble(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  int _convertToInt(String value) {
    return int.tryParse(value) ?? 0;
  }

  bool _convertToBoolean(String value) {
    return value.trim() == '1';
  }

  TemperatureTrendType _convertToTemperatureTrend(String value) {
    final intValue = int.tryParse(value) ?? 0;
    return TemperatureTrendType.fromValue(intValue);
  }

  WeatherType _convertToWeatherType(String value) {
    final intValue = int.tryParse(value) ?? 1;
    return WeatherType.fromValue(intValue);
  }

  GameEditionType _convertToGameEditionType(String value) {
    final intValue = int.tryParse(value) ?? 22;
    return GameEditionType.fromValue(intValue);
  }

  FuelType _convertToFuelType(String value) {
    final intValue = int.tryParse(value) ?? 0;
    return FuelType.fromValue(intValue);
  }

  dynamic _convertToArray(String propertyName, String value) {
    final textValues = value.split('¶');
    final array = <dynamic>[];

    for (int i = 0; i < textValues.length - 1; i++) {
      final elementValue = textValues[i];

      switch (propertyName) {
        case 'attachedImplementsPosition':
          array.add(_convertToInt(elementValue));
          break;
        case 'attachedImplementsLowered':
        case 'attachedImplementsSelected':
        case 'attachedImplementsTurnedOn':
          array.add(_convertToBoolean(elementValue));
          break;
        case 'attachedImplementsWear':
          array.add(_convertToDouble(elementValue));
          break;
      }
    }

    return array;
  }

  // Método para processar mensagens recebidas (para uso com TCP ou WebSocket)
  void processMessage(String message) {
    if (message.startsWith('HEADER')) {
      _processTelemetryIndexes(message);
    } else {
      _processTelemetry(message);
    }
  }

  // Stream para escutar mudanças de telemetria
  Stream<FSTelemetry> get telemetryStream {
    return _telemetryController?.stream ?? Stream.empty();
  }

  // Getter para o estado atual da telemetria
  FSTelemetry get currentTelemetry => _telemetry.copy();
}
