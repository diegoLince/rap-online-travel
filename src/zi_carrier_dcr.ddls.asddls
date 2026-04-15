@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Carrier'

@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_CARRIER_DCR
  as select from /dmo/carrier

{   
  @UI: {
        lineItem: [{ position: 10 }],
        identification: [{ position: 10 }]
      }
  key carrier_id as CarrierId,
  @Semantics.text: true
      name       as Name
}
