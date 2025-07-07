# Farming Simulator Telemetry - Flutter Implementation

Esta é uma implementação em Flutter/Dart da classe `FSTelemetryReader` originalmente escrita em C#. Ela permite ler dados de telemetria do Farming Simulator em tempo real.

## Estrutura do Projeto

```
lib/
├── models/
│   └── fs_telemetry.dart          # Modelo de dados de telemetria
├── services/
│   └── fs_telemetry_reader.dart   # Serviço principal de leitura
├── widgets/
│   └── telemetry_dashboard.dart   # Widget Flutter para exibição
└── main.dart                      # Arquivo principal do app

example/
└── telemetry_example.dart         # Exemplo de uso em Dart puro
```

## Características

### ✅ Implementado
- **Modelo de Dados Completo**: Todos os campos de telemetria do Farming Simulator
- **Enums**: TemperatureTrendType, WeatherType, GameEditionType, FuelType
- **Processamento de Dados**: Conversão de tipos e parsing de mensagens
- **Sistema de Eventos**: Callbacks e Streams para atualizações em tempo real
- **Interface Flutter**: Dashboard completo com UI moderna
- **Dados Simulados**: Fallback quando não há conexão com o jogo

### 🔄 Funcionalidades Equivalentes ao C#
- ✅ Leitura de telemetria em tempo real
- ✅ Processamento de headers e dados
- ✅ Conversão de tipos de dados
- ✅ Sistema de eventos/callbacks
- ✅ Mapeamento de propriedades
- ✅ Tratamento de arrays

### 🚧 Limitações Atuais
- **Named Pipes**: Dart/Flutter não tem suporte nativo a named pipes no Windows
- **Alternativas**: Implementação com dados simulados ou TCP/WebSocket

## Como Usar

### 1. Uso Básico

```dart
import 'package:your_app/services/fs_telemetry_reader.dart';
import 'package:your_app/models/fs_telemetry.dart';

void main() {
  final telemetryReader = FSTelemetryReader();
  
  // Configurar callback
  telemetryReader.onTelemetryRead = (telemetry) {
    print('Velocidade: ${telemetry.speed} km/h');
    print('RPM: ${telemetry.rpm}');
    print('Combustível: ${telemetry.fuel} L');
  };
  
  // Iniciar leitura
  telemetryReader.start();
  
  // Parar quando necessário
  telemetryReader.stop();
}
```

### 2. Usando Streams

```dart
final telemetryReader = FSTelemetryReader();

// Escutar mudanças via Stream
telemetryReader.telemetryStream.listen((telemetry) {
  // Atualizar UI ou processar dados
  updateUI(telemetry);
});

telemetryReader.start();
```

### 3. Em Widget Flutter

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FSTelemetryReader _reader = FSTelemetryReader();
  FSTelemetry _telemetry = FSTelemetry();

  @override
  void initState() {
    super.initState();
    _reader.onTelemetryRead = (telemetry) {
      setState(() {
        _telemetry = telemetry;
      });
    };
    _reader.start();
  }

  @override
  void dispose() {
    _reader.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Velocidade: ${_telemetry.speed} km/h');
  }
}
```

## Executando o Exemplo

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Executar exemplo Dart puro**:
   ```bash
   dart example/telemetry_example.dart
   ```

3. **Executar app Flutter**:
   ```bash
   flutter run
   ```

## Comparação com C#

| Funcionalidade | C# | Flutter/Dart |
|---|---|---|
| Named Pipes | ✅ Nativo | ❌ Não suportado |
| Reflection | ✅ Nativo | ❌ Não disponível |
| Eventos | ✅ Events | ✅ Callbacks + Streams |
| Conversão de Tipos | ✅ Convert.To* | ✅ Métodos customizados |
| Processamento de Dados | ✅ String.Split | ✅ String.split |
| Threading | ✅ Threads | ✅ Async/Await |

## Adaptações Necessárias

### 1. Named Pipes → TCP/WebSocket
Para conectar ao Farming Simulator, você precisará:

```dart
// Implementar conexão TCP
Socket.connect('localhost', 8080).then((socket) {
  socket.listen((data) {
    final message = String.fromCharCodes(data);
    telemetryReader.processMessage(message);
  });
});
```

### 2. Reflection → Mapeamento Manual
Como Dart não tem reflection, usamos mapeamento manual:

```dart
Map<String, String> _telemetryProperties = {
  'money': 'money',
  'speed': 'speed',
  'rpm': 'rpm',
  // ... todas as propriedades
};
```

## Próximos Passos

1. **Implementar TCP/WebSocket**: Para conexão real com o jogo
2. **Plugin Nativo**: Criar plugin para named pipes no Windows
3. **Persistência**: Salvar dados de telemetria
4. **Gráficos**: Adicionar visualizações de dados
5. **Configuração**: Interface para configurar conexão

## Contribuição

Para contribuir com melhorias:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Implemente as mudanças
4. Teste com dados reais do Farming Simulator
5. Envie um Pull Request

## Licença

Este projeto segue a mesma licença do projeto original C#. 