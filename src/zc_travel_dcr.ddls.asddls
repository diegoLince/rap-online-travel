@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Viiew Travel Entity'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true //Define um campo que sera usado para buscar, mas pricisa incluir mais uma annotation nos campos desejados

@Metadata.allowExtensions: true //Pode criar extensoes de metadata para essa projection

define root view entity ZC_TRAVEL_DCR 
provider contract transactional_query //tipo de contrato, normalmente sera esse, pois aceita leitura delete insert etc.
as projection on ZI_TRAVEL_DCR
{   

    @Search.defaultSearchElement: true
    key TravelId,
    
    
    AgencyId,
    
    _Agency.Name as Agency_name,
    
    
    CustomerId,
    
    
    BeginDate,
    
    
    EndDate,
    //BookingFee,
    //TotalPrice,
    CurrencyCode,
    
    
    Description,
    
    //@UI: { lineItem:       [{ position: 70 }]}
           //identification: [{ position: 70 }] }
    OverallStatus,
    
    
    CreatedBy,
    
    
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking : redirected to composition child ZC_BOOKING_DCR, //Aqui apontamos para a Projection do booking, porque projection conversa com projection
    _Currency,
    _Customer,
    _OveralStatus
}
