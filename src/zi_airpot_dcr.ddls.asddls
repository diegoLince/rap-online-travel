@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Aeroporto'

@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_AIRPOT_DCR
  as select from /dmo/airport

{
  key airport_id as AirportId, 
      
      @Semantics.text: true
      name       as Name,
      city       as City,
      country    as Country
}
