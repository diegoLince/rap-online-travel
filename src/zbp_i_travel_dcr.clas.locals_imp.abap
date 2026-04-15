CLASS lhc_ZI_TRAVEL_DCR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_dcr RESULT result.
    METHODS copia FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_dcr~copia.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_dcr\_booking.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_dcr.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_DCR IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    TRY.

        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr = '01'
                                                      object = '/DMO/TRV_m'
                                                      quantity = 1
                                             IMPORTING number = DATA(lv_last_number)
                                                       returned_quantity = DATA(lv_quantity) ).


      CATCH cx_nr_object_not_found  INTO DATA(lo_notfound).

        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entit>).

          APPEND VALUE #( %cid = <fs_entit>-%cid
                          %key = <fs_entit>-%key ) TO failed-zi_travel_dcr.

          APPEND VALUE #( %cid = <fs_entit>-%cid
                          %key = <fs_entit>-%key
                          %msg = lo_notfound ) TO reported-zi_travel_dcr.

        ENDLOOP.

      CATCH cx_number_ranges  INTO DATA(lo_number).

        LOOP AT entities ASSIGNING <fs_entit>.

          APPEND VALUE #( %cid = <fs_entit>-%cid
                          %key = <fs_entit>-%key ) TO failed-zi_travel_dcr.

          APPEND VALUE #( %cid = <fs_entit>-%cid
                          %key = <fs_entit>-%key
                          %msg = lo_notfound ) TO reported-zi_travel_dcr.

        ENDLOOP.

    ENDTRY.

    LOOP AT entities ASSIGNING <fs_entit>.

      APPEND VALUE #( %cid     = <fs_entit>-%cid
                      travelid = lv_last_number ) TO mapped-zi_travel_dcr.

    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_quantity TYPE /dmo/booking_id.

    "Busca os filhos linkado com o pai
    READ ENTITIES OF zi_travel_dcr IN LOCAL MODE
         ENTITY zi_travel_dcr BY \_Booking
         FROM CORRESPONDING #( entities )
         LINK DATA(lt_linked_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entitiy>) GROUP BY <fs_entitiy>-TravelId.

      lv_quantity = REDUCE #( INIT lv_maximo = CONV /dmo/booking_id( '0' )
                      FOR ls_linked_data IN lt_linked_data WHERE ( source-travelid = <fs_entitiy>-TravelId )
                      NEXT lv_maximo = COND /dmo/booking_id( WHEN lv_maximo < ls_linked_data-target-BookingId
                                                             THEN ls_linked_data-target-BookingId
                                                             ELSE lv_quantity ) ).

      "Aqui vamos cravar o valor do id no target que tem os dados
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity_mapp>)
         USING KEY entity WHERE TravelId = <fs_entitiy>-TravelId.

        LOOP AT <entity_mapp>-%target ASSIGNING FIELD-SYMBOL(<fs_target_booking>).

          APPEND CORRESPONDING #( <fs_target_booking> ) TO mapped-zi_booking_dcr ASSIGNING FIELD-SYMBOL(<mapp>).

          ADD 1 TO lv_quantity.

          IF <mapp> IS ASSIGNED.
            <mapp>-BookingId = lv_quantity.
          ENDIF.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD copia.

    DATA: lt_travel      TYPE TABLE FOR CREATE zi_travel_dcr.
    DATA: lt_booking     TYPE TABLE FOR CREATE zi_travel_dcr\_Booking.
    DATA: lt_booking_sup TYPE TABLE FOR CREATE zi_booking_dcr\_BookingSup.

    "Ler os dados da travel
    READ ENTITIES OF zi_travel_dcr IN LOCAL MODE
      ENTITY zi_travel_dcr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel_result)
      FAILED DATA(lt_travel_failed).

    "Ler os dados da booking
    READ ENTITIES OF zi_travel_dcr IN LOCAL MODE
      ENTITY zi_travel_dcr BY \_Booking
      ALL FIELDS
      WITH CORRESPONDING #( lt_travel_result )
      RESULT DATA(lt_booking_result)
      FAILED DATA(lt_booking_failed).

    "Ler os dados da Booking Sup
    READ ENTITIES OF zi_travel_dcr IN LOCAL MODE
      ENTITY zi_booking_dcr BY \_BookingSup
      ALL FIELDS
      WITH CORRESPONDING #( lt_booking_result )
      RESULT DATA(lt_booking_sup_result)
      FAILED DATA(lt_booking_sup_failed).

    LOOP AT lt_travel_result ASSIGNING FIELD-SYMBOL(<fs_travel_result>).

      "Appenda na tabela Travel
      APPEND VALUE #( %cid  = keys[ TravelId = <fs_travel_result>-TravelId ]-%cid
                      %data  = CORRESPONDING #( <fs_travel_result> EXCEPT travelid ) )
                      TO lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel_c>).

      "Append do CID_REF que é a referencia da tabela Travel que será criado na tabela de Booking
      APPEND VALUE #( %cid_ref = <fs_travel_c>-%cid ) TO lt_booking ASSIGNING FIELD-SYMBOL(<fs_booking_c>).

      LOOP AT lt_booking_result ASSIGNING FIELD-SYMBOL(<fs_booking_result>) USING KEY entity WHERE TravelId = <fs_travel_result>-TravelId.

        "Appenda os registroda da booking no "Target"
        APPEND VALUE #( %cid  = <fs_travel_result>-TravelId && <fs_booking_result>-BookingId
                        "%cid  = <fs_travel_result>-TravelId && <fs_booking_result>-BookingId
                        %data = CORRESPONDING #( <fs_booking_result> EXCEPT travelid bookingid ) )
                        TO <fs_booking_c>-%target ASSIGNING FIELD-SYMBOL(<fs_booking_cc>).

        "Append do CID_REF que é a referencia da tabela Booking que será criado na tabela de Booking Sup
        APPEND VALUE #( %cid_ref = <fs_booking_cc>-%cid ) TO lt_booking_sup ASSIGNING FIELD-SYMBOL(<fs_booking_sup_c>).

        LOOP AT lt_booking_sup_result ASSIGNING FIELD-SYMBOL(<fs_booking_sup_result>) USING KEY entity WHERE TravelId  = <fs_travel_result>-TravelId
                                                                                                         AND BookingId = <fs_booking_result>-BookingId.

          "Append dos Booking Sup na tabela dentro do "Target"
          APPEND VALUE #( %cid  = <fs_travel_result>-TravelId && <fs_booking_result>-BookingId && <fs_booking_sup_result>-BookingSupplementId
                          %data = CORRESPONDING #( <fs_booking_sup_result> EXCEPT travelid bookingid ) )
                          TO <fs_booking_sup_c>-%target ASSIGNING FIELD-SYMBOL(<fs_booking_sup_cc>).

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    "Update data
    MODIFY ENTITIES OF zi_travel_dcr IN LOCAL MODE
      ENTITY zi_travel_dcr
    CREATE FIELDS ( agencyid customerid begindate enddate bookingfee totalprice currencycode description )
    WITH lt_travel
      ENTITY zi_travel_dcr
    CREATE BY \_Booking FIELDS ( bookingdate customerid carrierid connectionid flightdate flightprice currencycode bookingstatus )
    WITH lt_booking
      ENTITY zi_booking_dcr
    CREATE BY \_BookingSup FIELDS ( supplementid price currencycode )
    WITH lt_booking_sup
    MAPPED DATA(lt_mapped).

    mapped-zi_travel_dcr = lt_mapped-zi_travel_dcr.


  ENDMETHOD.

ENDCLASS.
