CLASS zcl_operations_dcr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_operations_dcr IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

**********************************************************************
    "Exemplo lendo a Travel
    "READ ENTITY zi_travel_dcr
    "ALL FIELDS WITH VALUE #( ( %key-TravelId = '00000120' ) )
    "FIELDS ( TravelId AgencyId )
    "FROM VALUE #( ( %key-TravelId = '00000120'
    "                %control      = VALUE #( AgencyId = if_abap_behv=>mk-on ) ) )
    "RESULT DATA(lt_travel)
    "FAILED DATA(lt_fail)
    "REPORTED DATA(lt_report).

**********************************************************************
    "Exemplo lendo os filhos na Booking
    "READ ENTITY zi_travel_dcr
    "BY \_Booking
    "FIELDS ( BookingDate CustomerId )
    "WITH VALUE #( ( %key-TravelId = '00000120' ) )
    "RESULT DATA(lt_result)
    "FAILED DATA(lt_fail)
    "REPORTED DATA(lt_report).

**********************************************************************

    "Exemplo lendo a entidades filhos junto
    "READ ENTITIES OF zi_travel_dcr
    "ENTITY zi_travel_dcr
    "ALL FIELDS
    "WITH VALUE #( ( %key-TravelId = '00000120' ) )
    "    RESULT DATA(lt_result2)
    "ENTITY zi_booking_dcr
    "    ALL FIELDS
    "WITH VALUE #( ( %key-TravelId  = '00000120'
    "                %key-BookingId = '0001' ) )
    "    RESULT DATA(lt_booking)
    "ENTITY zi_booking_sup
    "    ALL FIELDS
    "WITH VALUE #( ( %key-TravelId  = '00000120'
    "                %key-BookingId = '0001'
    "                %key-BookingSupplementId = '01') )
    "    RESULT DATA(lt_booking_sup)
    "FAILED DATA(lt_fail2)
    "REPORTED DATA(lt_report2).

**********************************************************************

    "Exemplo lendo a entidades filhos com associassion
    "READ ENTITIES OF zi_travel_dcr
    "ENTITY zi_travel_dcr
    "ALL FIELDS
    "WITH VALUE #( ( %key-TravelId = '00000120' ) )
    "    RESULT DATA(lt_result3)
    "BY \_Booking
    "  ALL FIELDS
    "  WITH VALUE #( (  %key-TravelId = '00000120' ) )
    "    RESULT DATA(lt_booking3)
    "FAILED DATA(lt_fail3)
    "REPORTED DATA(lt_report3).

**********************************************************************

    "out->write(  data = lt_fail2 ).
    "out->write(  data = lt_report2 ).
    "out->write(  data = lt_report ).

**********************************************************************

    "Criando uma entidade
*    MODIFY ENTITIES OF zi_travel_dcr
*       ENTITY zi_travel_dcr
*      CREATE FROM VALUE #(  ( %cid               = 'cid'
*                              %data-BeginDate    = '20250320'
*                              %control-BeginDate = if_abap_behv=>mk-on
*                          ) )
*      CREATE BY \_Booking
*      FROM VALUE #( ( %cid_ref = 'cid'
*                      %target  = VALUE #( (  %cid               = 'cidb'
*                                             %data-BookingDate  = '20260320'
*                                             %control-BookingDate = if_abap_behv=>mk-on
*                      ) ) ) )
*                         FAILED DATA(lt_fail)
*                         REPORTED DATA(lt_report)
*                         MAPPED DATA(lt_mapp).
*
*    IF lt_fail IS INITIAL.
*      COMMIT ENTITIES.
*    ENDIF.

    "Deletando uma entidade
*    MODIFY ENTITY zi_travel_dcr
*      DELETE FROM VALUE #( ( %key-travelid = '00004621' ) )
*          FAILED DATA(lt_fail2)
*          REPORTED DATA(lt_report2)
*          MAPPED DATA(lt_mapp2).
*
*
*    IF lt_fail2 IS INITIAL.
*      COMMIT ENTITIES.
*    ENDIF.

    "Modificando uma entidade
*    MODIFY ENTITY zi_travel_dcr
*    UPDATE FROM VALUE #( ( %key-TravelId = '00004620'
*                           %data-BeginDate = '20250627'
*                           %control-BeginDate = if_abap_behv=>mk-on
*                        ) )
*              FAILED DATA(lt_fail2)
*              REPORTED DATA(lt_report2)
*              MAPPED DATA(lt_mapp2).
*
*    IF lt_fail2 IS INITIAL.
*      COMMIT ENTITIES.
*    ENDIF.

    "Update em campo especifico sem ter que passar a estrutura de controle
*    MODIFY ENTITY zi_travel_dcr
*        UPDATE FIELDS ( BeginDate )
*        WITH VALUE #( ( %key-TravelId   = '00004620'
*                        %data-BeginDate = '20250626' ) )
*                  FAILED DATA(lt_fail2)
*                  REPORTED DATA(lt_report2)
*                  MAPPED DATA(lt_mapp2).
*
*    IF lt_fail2 IS INITIAL.
*      COMMIT ENTITIES.
*    ENDIF.

    "Update com set fields
    MODIFY ENTITY zi_travel_dcr
           UPDATE SET FIELDS WITH VALUE
           #( ( %key-TravelId   = '00004620'
                %data-BeginDate = '20250625' ) )
                     FAILED DATA(lt_fail2)
                     REPORTED DATA(lt_report2)
                     MAPPED DATA(lt_mapp2).

    IF lt_fail2 IS INITIAL.
      COMMIT ENTITIES.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
