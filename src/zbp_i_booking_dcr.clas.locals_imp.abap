CLASS lhc_zi_booking_dcr DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsup FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_dcr\_Bookingsup.

ENDCLASS.

CLASS lhc_zi_booking_dcr IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsup.

    DATA lv_quantity TYPE /dmo/booking_id.

    "Busca os filhos linkado com o pai
    READ ENTITIES OF zi_travel_dcr IN LOCAL MODE
         ENTITY zi_booking_dcr BY \_BookingSup
         FROM CORRESPONDING #( entities )
         LINK DATA(lt_linked_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entitiy>) GROUP BY ( TravelId  = <fs_entitiy>-TravelId
                                                                     BookingId = <fs_entitiy>-BookingId ).


      lv_quantity = REDUCE #( INIT lv_maximo = CONV /dmo/booking_supplement_id( '0' )
                      FOR ls_linked_data IN lt_linked_data WHERE ( source-travelid  = <fs_entitiy>-TravelId
                                                               AND source-BookingId = <fs_entitiy>-BookingId )
                      NEXT lv_maximo = COND /dmo/booking_supplement_id( WHEN ls_linked_data-target-BookingSupplementId > lv_maximo
                                                                        THEN ls_linked_data-target-BookingSupplementId
                                                                        ELSE lv_maximo ) ).

      "Aqui vamos cravar o valor do id no target que tem os dados
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity_mapp>)
         USING KEY entity WHERE TravelId  = <fs_entitiy>-TravelId
                            AND BookingId = <fs_entitiy>-BookingId.

        LOOP AT <entity_mapp>-%target ASSIGNING FIELD-SYMBOL(<fs_target_booking_sup>).

          APPEND CORRESPONDING #( <fs_target_booking_sup> ) TO mapped-zi_booking_sup ASSIGNING FIELD-SYMBOL(<mapp>).

          ADD 1 TO lv_quantity.

          IF <mapp> IS ASSIGNED.
            <mapp>-BookingSupplementId = lv_quantity.
          ENDIF.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
