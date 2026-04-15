@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Flight'

//@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_FLIGHT_DCR
  as select from /dmo/flight
  association [1..1] to ZI_CARRIER_DCR as _Carrier on $projection.CarrierId = _Carrier.CarrierId

{
      @UI.facet: [{
        id: 'Flight',
        purpose: #STANDARD,
        position: 10,
        label: 'Voos',
        type: #IDENTIFICATION_REFERENCE
      },
      {
          id: 'Carrier',
          purpose: #STANDARD,
          position: 20,
          label: 'Carrier',
          type: #IDENTIFICATION_REFERENCE,   //Esse é o line item que aparece no relatorio do Flight dentro da tela do object page
          targetElement: '_Carrier'
      }]


      @UI: {
        lineItem: [{ position: 10 }],
        identification: [{ position: 10 }]
      }
      key carrier_id     as CarrierId,
      
      @UI: {
        lineItem: [{ position: 20 }],
        identification: [{ position: 20 }]
      }
      key connection_id  as ConnectionId,
      
      @UI: {
        lineItem: [{ position: 30 }],
        identification: [{ position: 30 }]
      }
      key flight_date    as FlightDate,

      @UI: {
        lineItem: [{ position: 40 }],
        identification: [{ position: 40 }]
      }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price          as Price,

      @UI: {
        lineItem: [{ position: 50 }],
        identification: [{ position: 50 }]
      }
      currency_code  as CurrencyCode,
      @UI: {
        lineItem: [{ position: 60 }],
        identification: [{ position: 60 }]
      }
      plane_type_id  as PlaneTypeId,
      @UI: {
        lineItem: [{ position: 70 }],
        identification: [{ position: 70 }]
      }
      seats_max      as SeatsMax,
      @UI: {
        lineItem: [{ position: 80 }],
        identification: [{ position: 80 }]
      }
      seats_occupied as SeatsOccupied,

      _Carrier
}
