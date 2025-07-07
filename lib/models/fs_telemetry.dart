enum TemperatureTrendType {
  rising(-1),
  stable(0),
  dropping(1);

  const TemperatureTrendType(this.value);
  final int value;

  static TemperatureTrendType fromValue(int value) {
    return TemperatureTrendType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TemperatureTrendType.stable,
    );
  }
}

enum WeatherType {
  sun(1),
  rain(2),
  cloud(3),
  snow(4);

  const WeatherType(this.value);
  final int value;

  static WeatherType fromValue(int value) {
    return WeatherType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WeatherType.sun,
    );
  }
}

enum GameEditionType {
  fs19(19),
  fs22(22),
  fs25(25);

  const GameEditionType(this.value);
  final int value;

  static GameEditionType fromValue(int value) {
    return GameEditionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GameEditionType.fs22,
    );
  }
}

enum FuelType {
  undefined(0),
  diesel(1),
  electric(2),
  methane(3);

  const FuelType(this.value);
  final int value;

  static FuelType fromValue(int value) {
    return FuelType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FuelType.undefined,
    );
  }
}

class FSTelemetry {
  // GameData
  double money = 0.0;
  double temperatureMin = 0.0;
  double temperatureMax = 0.0;
  TemperatureTrendType temperatureTrend = TemperatureTrendType.stable;
  int dayTimeMinutes = 0;
  WeatherType weatherCurrent = WeatherType.sun;
  WeatherType weatherNext = WeatherType.sun;
  int day = 0;
  GameEditionType gameEdition = GameEditionType.fs22;

  // VehicleData
  String vehicleName = '';
  double wear = 0.0;
  int operationTimeMinutes = 0;
  double speed = 0.0;
  double fuelMax = 0.0;
  double fuel = 0.0;
  FuelType fuelType = FuelType.undefined;
  int rpmMin = 0;
  int rpmMax = 0;
  int rpm = 0;
  bool isEngineStarted = false;
  int gear = 0;
  String gearGroupName = '';
  String currentGearGroup = '';
  int currentGearGroupIndex = 0;
  String gearGroupNames = '';
  String gearGroupRatios = '';
  int gearGroupCount = 0;
  String gearMaxSpeeds = '';
  int gearCount = 0;
  bool gearsAvailable = false;
  bool isAutomatic = false;
  String prevGearName = '';
  String nextGearName = '';
  String prevPrevGearName = '';
  String nextNextGearName = '';
  bool isGearChanging = false;
  bool isLightOn = false;
  bool isLightHighOn = false;
  bool isLightTurnRightEnabled = false;
  bool isLightTurnRightOn = false;
  bool isLightTurnLeftEnabled = false;
  bool isLightTurnLeftOn = false;
  bool isLightHazardOn = false;
  bool isLightBeaconOn = false;
  bool isWipersOn = false;
  bool isCruiseControlOn = false;
  int cruiseControlSpeed = 0;
  int cruiseControlMaxSpeed = 0;
  bool isHandBrakeOn = false;
  bool isDrivingVehicle = false;
  bool isAiActive = false;
  bool isReverseDriving = false;
  bool isMotorFanEnabled = false;
  double motorTemperature = 0.0;
  double vehiclePrice = 0.0;
  double vehicleSellPrice = 0.0;
  bool isHonkOn = false;
  List<int> attachedImplementsPosition = [];
  List<bool> attachedImplementsLowered = [];
  List<bool> attachedImplementsSelected = [];
  List<bool> attachedImplementsTurnedOn = [];
  List<double> attachedImplementsWear = [];
  double angleRotation = 0.0;
  double mass = 0.0;
  double totalMass = 0.0;
  bool isOnField = false;
  double defMax = 0.0;
  double def = 0.0;
  double airMax = 0.0;
  double air = 0.0;

  // Método para criar uma cópia do objeto
  FSTelemetry copy() {
    final copy = FSTelemetry();

    // GameData
    copy.money = money;
    copy.temperatureMin = temperatureMin;
    copy.temperatureMax = temperatureMax;
    copy.temperatureTrend = temperatureTrend;
    copy.dayTimeMinutes = dayTimeMinutes;
    copy.weatherCurrent = weatherCurrent;
    copy.weatherNext = weatherNext;
    copy.day = day;
    copy.gameEdition = gameEdition;

    // VehicleData
    copy.vehicleName = vehicleName;
    copy.wear = wear;
    copy.operationTimeMinutes = operationTimeMinutes;
    copy.speed = speed;
    copy.fuelMax = fuelMax;
    copy.fuel = fuel;
    copy.fuelType = fuelType;
    copy.rpmMin = rpmMin;
    copy.rpmMax = rpmMax;
    copy.rpm = rpm;
    copy.isEngineStarted = isEngineStarted;
    copy.gear = gear;
    copy.gearGroupName = gearGroupName;
    copy.currentGearGroup = currentGearGroup;
    copy.currentGearGroupIndex = currentGearGroupIndex;
    copy.gearGroupNames = gearGroupNames;
    copy.gearGroupRatios = gearGroupRatios;
    copy.gearGroupCount = gearGroupCount;
    copy.gearMaxSpeeds = gearMaxSpeeds;
    copy.gearCount = gearCount;
    copy.gearsAvailable = gearsAvailable;
    copy.isAutomatic = isAutomatic;
    copy.prevGearName = prevGearName;
    copy.nextGearName = nextGearName;
    copy.prevPrevGearName = prevPrevGearName;
    copy.nextNextGearName = nextNextGearName;
    copy.isGearChanging = isGearChanging;
    copy.isLightOn = isLightOn;
    copy.isLightHighOn = isLightHighOn;
    copy.isLightTurnRightEnabled = isLightTurnRightEnabled;
    copy.isLightTurnRightOn = isLightTurnRightOn;
    copy.isLightTurnLeftEnabled = isLightTurnLeftEnabled;
    copy.isLightTurnLeftOn = isLightTurnLeftOn;
    copy.isLightHazardOn = isLightHazardOn;
    copy.isLightBeaconOn = isLightBeaconOn;
    copy.isWipersOn = isWipersOn;
    copy.isCruiseControlOn = isCruiseControlOn;
    copy.cruiseControlSpeed = cruiseControlSpeed;
    copy.cruiseControlMaxSpeed = cruiseControlMaxSpeed;
    copy.isHandBrakeOn = isHandBrakeOn;
    copy.isDrivingVehicle = isDrivingVehicle;
    copy.isAiActive = isAiActive;
    copy.isReverseDriving = isReverseDriving;
    copy.isMotorFanEnabled = isMotorFanEnabled;
    copy.motorTemperature = motorTemperature;
    copy.vehiclePrice = vehiclePrice;
    copy.vehicleSellPrice = vehicleSellPrice;
    copy.isHonkOn = isHonkOn;
    copy.attachedImplementsPosition = List.from(attachedImplementsPosition);
    copy.attachedImplementsLowered = List.from(attachedImplementsLowered);
    copy.attachedImplementsSelected = List.from(attachedImplementsSelected);
    copy.attachedImplementsTurnedOn = List.from(attachedImplementsTurnedOn);
    copy.attachedImplementsWear = List.from(attachedImplementsWear);
    copy.angleRotation = angleRotation;
    copy.mass = mass;
    copy.totalMass = totalMass;
    copy.isOnField = isOnField;
    copy.defMax = defMax;
    copy.def = def;
    copy.airMax = airMax;
    copy.air = air;

    return copy;
  }
}
