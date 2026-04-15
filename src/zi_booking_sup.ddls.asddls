@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_SUP
  as select from zbooking_sup_dcr
  association to parent ZI_BOOKING_DCR as _Booking on $projection.BookingId = _Booking.BookingId
                                                  and $projection.TravelId  = _Booking.TravelId
  association [1..1] to /DMO/I_Supplement     as _Product        on $projection.SupplementId = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.SupplementId = _SupplementText.SupplementID
  association [1..1] to ZI_TRAVEL_DCR         as _Travel on $projection.TravelId = _Travel.TravelId
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode' //Define o tipo de moeda
      price                 as Price,
      currency_code         as CurrencyCode,
      last_changed_at       as LastChangedAt,
      
      _Booking,
      _Product,
      _SupplementText,
      _Travel 
}
