# Informações de Transmissão do Farming Simulator 22

## Campos de Telemetria de Transmissão

Com as modificações feitas no mod de telemetria, agora você tem acesso a informações detalhadas sobre a transmissão do veículo usando os métodos oficiais da Giants Software.

### Campos Básicos de Transmissão

1. **Gear** (int) - Marcha atual (1, 2, 3, etc.)
2. **GearGroupName** (string) - Nome do grupo de marcha atual (legado)
3. **CurrentGearGroup** (string) - Nome do grupo de marcha atual (L, M, H, R)
4. **CurrentGearGroupIndex** (int) - Índice do grupo atual (1, 2, 3, etc.)

### Campos de Detalhes da Transmissão

5. **GearGroupNames** (string) - Lista de todos os grupos disponíveis separados por vírgula
6. **GearGroupRatios** (string) - Ratios de todos os grupos separados por vírgula
7. **GearGroupCount** (int) - Número total de grupos
8. **GearMaxSpeeds** (string) - Velocidades máximas de cada marcha separadas por vírgula
9. **GearCount** (int) - Número total de marchas

### Campos de Informações da Marcha (Métodos Oficiais)

10. **GearsAvailable** (bool) - Se marchas estão disponíveis
11. **IsAutomatic** (bool) - Se é transmissão automática
12. **PrevGearName** (string) - Nome da marcha anterior
13. **NextGearName** (string) - Nome da próxima marcha
14. **PrevPrevGearName** (string) - Nome da marcha anterior à anterior
15. **NextNextGearName** (string) - Nome da próxima à próxima marcha
16. **IsGearChanging** (bool) - Se está trocando de marcha

## Como Usar

### Exemplo em C#

```csharp
private void TelemetryReader_OnTelemetryRead(FSTelemetry telemetry)
{
    // Verificar se está em marcha ré
    bool isReverse = telemetry.CurrentGearGroup == "R";
    
    // Verificar se está em baixa velocidade (L)
    bool isLowSpeed = telemetry.CurrentGearGroup == "L";
    
    // Verificar se está em média velocidade (M)
    bool isMediumSpeed = telemetry.CurrentGearGroup == "M";
    
    // Verificar se está em alta velocidade (H)
    bool isHighSpeed = telemetry.CurrentGearGroup == "H";
    
    // Verificar se é transmissão automática
    bool isAutomatic = telemetry.IsAutomatic;
    
    // Verificar se está trocando de marcha
    bool isChanging = telemetry.IsGearChanging;
    
    // Obter informações das marchas próximas
    string previousGear = telemetry.PrevGearName;
    string nextGear = telemetry.NextGearName;
    
    // Obter todos os grupos disponíveis
    string[] groups = telemetry.GearGroupNames.Split(',');
    
    // Obter todos os ratios
    string[] ratios = telemetry.GearGroupRatios.Split(',');
    
    // Obter velocidades máximas das marchas
    string[] maxSpeeds = telemetry.GearMaxSpeeds.Split(',');
    
    Console.WriteLine($"Grupo atual: {telemetry.CurrentGearGroup}");
    Console.WriteLine($"Marcha atual: {telemetry.Gear}");
    Console.WriteLine($"Transmissão automática: {telemetry.IsAutomatic}");
    Console.WriteLine($"Trocando marcha: {telemetry.IsGearChanging}");
    Console.WriteLine($"Marcha anterior: {telemetry.PrevGearName}");
    Console.WriteLine($"Próxima marcha: {telemetry.NextGearName}");
    Console.WriteLine($"Total de grupos: {telemetry.GearGroupCount}");
    Console.WriteLine($"Total de marchas: {telemetry.GearCount}");
}
```

### Exemplo de Saída

Para um trator com transmissão FS22:

```json
{
  "Gear": 2,
  "CurrentGearGroup": "H",
  "CurrentGearGroupIndex": 3,
  "GearGroupNames": "L,M,H",
  "GearGroupRatios": "4.8076922084982,1.644736894992,1",
  "GearGroupCount": 3,
  "GearMaxSpeeds": "",
  "GearCount": 0,
  "GearsAvailable": true,
  "IsAutomatic": false,
  "PrevGearName": "1",
  "NextGearName": "3",
  "PrevPrevGearName": "R",
  "NextNextGearName": "4",
  "IsGearChanging": false
}
```

## Interpretação dos Dados

### Grupos de Marcha
- **R** - Marcha Ré (ratio negativo)
- **L** - Baixa velocidade (Low)
- **M** - Média velocidade (Medium)
- **H** - Alta velocidade (High)

### Ratios
Os ratios indicam a relação de transmissão de cada grupo:
- Valores negativos = marcha ré
- Valores menores = velocidades mais baixas
- Valores maiores = velocidades mais altas

### Informações da Marcha
- **GearsAvailable** - Indica se o veículo tem sistema de marchas
- **IsAutomatic** - Indica se é transmissão automática ou manual
- **PrevGearName/NextGearName** - Nomes das marchas anterior e próxima
- **IsGearChanging** - Indica se o veículo está no processo de troca de marcha

### Velocidades Máximas
As velocidades máximas indicam a velocidade máxima que cada marcha pode atingir em km/h.

## Detecção de Estado

Para detectar em qual grupo de marcha o veículo está:

```csharp
string GetGearGroupDescription(string currentGroup)
{
    switch (currentGroup)
    {
        case "R": return "Marcha Ré";
        case "L": return "Baixa Velocidade";
        case "M": return "Média Velocidade";
        case "H": return "Alta Velocidade";
        default: return "Desconhecido";
    }
}

// Verificar tipo de transmissão
string GetTransmissionType(bool isAutomatic)
{
    return isAutomatic ? "Automática" : "Manual";
}

// Verificar estado da troca de marcha
string GetGearChangeStatus(bool isChanging)
{
    return isChanging ? "Trocando Marcha" : "Marcha Estável";
}
```

## Notas Importantes

1. **Métodos Oficiais**: Os dados são obtidos usando os métodos oficiais da Giants Software (`getGearToDisplay()` e `getGearGroupToDisplay()`)
2. **Tempo Real**: Os dados são atualizados em tempo real conforme você troca de marcha no jogo
3. **Compatibilidade**: Funciona com diferentes tipos de transmissão (manual, automática, CVT)
4. **Valores Padrão**: Se o veículo não tiver transmissão ou os dados não estiverem disponíveis, os campos retornarão valores padrão
5. **Separadores**: Os arrays de strings (GearGroupNames, GearGroupRatios, GearMaxSpeeds) usam vírgula como separador
6. **Índices**: O índice do grupo começa em 1 (L=1, M=2, H=3, R=0)

## Implementação Técnica

### Métodos Utilizados
- `motor:getGearToDisplay()` - Retorna informações detalhadas da marcha atual
- `motor:getGearGroupToDisplay()` - Retorna informações do grupo de marcha atual

### Estrutura Simplificada
O código foi otimizado para usar apenas os métodos oficiais, removendo complexidade desnecessária e melhorando a performance. 