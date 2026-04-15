@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection View Booking Entity'

@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true //Pode criar extensoes de metadata para essa projection

define view entity ZC_BOOKING_DCR as projection on ZI_BOOKING_DCR
{   
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    
    //FlightPrice,
    //CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _BookingStatus,
    _BookingSup : redirected to composition child ZC_BOOKING_SUP_DCR,   //Aponta para a Projection filha
    _Carrier,
    _Connection,
    _Customer,
    _Travel : redirected to parent ZC_TRAVEL_DCR  //Aponta para a PROJECTION pai
}
