@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRAVEL_DCR
  as select from ztravel_dcr
  composition [0..*] of ZI_BOOKING_DCR as _Booking
  association [0..1] to /DMO/I_Agency            as _Agency       on $projection.AgencyId      = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer          as _Customer     on $projection.CustomerId    = _Customer.CustomerID
  association [0..1] to I_Currency               as _Currency     on $projection.CurrencyCode  = _Currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _OveralStatus on $projection.OverallStatus = _OveralStatus.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode' //Define o tipo de moeda
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode' //Define o tipo de moeda
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,

      _Booking,
      _Agency,
      _Customer,
      _Currency,
      _OveralStatus
}
