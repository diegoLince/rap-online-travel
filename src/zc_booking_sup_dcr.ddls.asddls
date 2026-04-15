@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Booking Supplement Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKING_SUP_DCR as projection on ZI_BOOKING_SUP
{

    @UI.facet: [{
      id: 'BookingSup',
          purpose: #STANDARD,
          position: 10,
          label: 'BookingSup',
          type: #IDENTIFICATION_REFERENCE
      }]

    @UI: { lineItem:       [{ position: 10 }],
           identification: [{ position: 10 }]}
    key TravelId,
    @UI: { lineItem:       [{ position: 20 }],
           identification: [{ position: 20 }]}
    key BookingId,
    @UI: { lineItem:       [{ position: 30 }],
           identification: [{ position: 30 }]}
    key BookingSupplementId,
    @UI: { lineItem:       [{ position: 40 }],
           identification: [{ position: 40 }]}
    SupplementId,
    @UI: { lineItem:       [{ position: 50 }],
           identification: [{ position: 50 }]}
    //Price,
    CurrencyCode,
    @UI: { lineItem:       [{ position: 60 }],
           identification: [{ position: 60 }]}
    LastChangedAt,
    /* Associations */
    _Booking : redirected to parent ZC_BOOKING_DCR,
    _Product,
    _SupplementText,
    _Travel : redirected to ZC_TRAVEL_DCR
}
