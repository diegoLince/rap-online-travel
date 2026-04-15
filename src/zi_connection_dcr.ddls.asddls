@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Conexão'

@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true  //Melhora a ajuda de pesquisa criando um campo novo digitavel

define view entity ZI_CONNECTION_DCR
  as select from /dmo/connection
  association [1..*] to ZI_FLIGHT_DCR  as _Flight on $projection.CarrierId    = _Flight.CarrierId
                                                 and $projection.ConnectionId = _Flight.ConnectionId
  association [1..1] to ZI_CARRIER_DCR as _Carrier on $projection.CarrierId = _Carrier.CarrierId
  association [1..1] to ZI_AIRPOT_DCR  as _Airport on $projection.AirportFromId = _Airport.AirportId
  association [1..1] to ZI_AIRPOT_DCR  as _AirportDest on $projection.AirportToId = _AirportDest.AirportId
  
{
  @UI.facet: [{
      id: 'Connection',
      purpose: #STANDARD,
      position: 10,
      label: 'Conexão',
      type: #IDENTIFICATION_REFERENCE
  },
  {
      id: 'Flight',
      purpose: #STANDARD,
      position: 20,
      label: 'Voos',
      type: #LINEITEM_REFERENCE,   //Esse é o line item que aparece no relatorio do Flight dentro da tela do object page
      targetElement: '_Flight'
  }]
  
  @UI.selectionField: [{ position: 10 }]
  @UI.lineItem: [{ position: 10, label: 'Compania' }]
  @UI.identification: [{ position: 10  }]
  @ObjectModel.text.association: '_Carrier'
  @Consumption.valueHelpDefinition: [{  //Ajuda de pesquisa que foi criado no campo, aqui tem que apontar para um campo chave para funcionar
      entity: {
          name: 'ZI_CARRIER_DCR',
          element: 'CarrierId'
      }
  }]
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7  ///Margem de erro, define 70% da correção
  key carrier_id      as CarrierId,
  
  @UI.lineItem: [{ position: 20, label: 'Coexão' }]
  @UI.identification: [{ position: 20  }]
  key connection_id   as ConnectionId,
  
  @UI.selectionField: [{ position: 20 }]
  @UI.lineItem: [{ position: 30, label: 'Aeroporto Origem' }]
  @UI.identification: [{ position: 30  }]
  @ObjectModel.text.association: '_Airport'
  @Consumption.valueHelpDefinition: [{  //Ajuda de pesquisa que foi criado no campo
      entity: {
          name: 'ZI_AIRPOT_DCR',
          element: 'AirportId'
      }
  }]
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7  ///Margem de erro, define 70% da correção
      airport_from_id as AirportFromId,
      
  @UI.selectionField: [{ position: 30 }]                               //Cria um campo de pesquisa
  @UI.lineItem: [{ position: 40, label: 'Aeroporto Destino' }]         //Line item texto de tela
  @UI.identification: [{ position: 40, label: 'Aeroporto Destino'  }]  //Esse identification estara dentro da Object Page
  @ObjectModel.text.association: '_AirportDest'                        //Isso serve para dizer que tem um texto associado que vai estar como anotation semantcs na interface
  @Consumption.valueHelpDefinition: [{                                 //Ajuda de pesquisa que foi criado no campo para aparecer o match code bonitinho
      entity: {
          name: 'ZI_AIRPOT_DCR',
          element: 'AirportId'
      }
  }]
  @Search.defaultSearchElement: true //Disponibiliza um campo onde pode digitar e dar enter que encontra, a mesma annotation pode ser usada em outros campos porem na tela sera somente um para tods os campos
  @Search.fuzzinessThreshold: 0.7    //Margem de erro, define 70% da correção
      airport_to_id   as AirportToId,
      
      @UI.identification: [{ position: 50  }]
      @UI.lineItem: [{ position: 50 }]  //Line item texto de tela
      departure_time  as DepartureTime,
      
      @UI.identification: [{ position: 60  }]
      @UI.lineItem: [{ position: 60 }]  //Line item texto de tela
      arrival_time    as ArrivalTime,
      
      @UI.identification: [{ position: 70  }]
      @UI.lineItem: [{ position: 70 }]  //Line item texto de tela
      distance        as Distance,
      
      @UI.identification: [{ position: 80  }]
      @UI.lineItem: [{ position: 80 }]  //Line item texto de tela
      distance_unit   as DistanceUnit,
      
      _Flight,
      _Carrier,
      _Airport,
      _AirportDest
}
