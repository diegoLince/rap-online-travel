CLASS zcl_carga_t_cdr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_carga_t_cdr IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
   " INSERT ztravel_dcr
    "FROM ( SELECT * FROM /dmo/travel_m  ).

    INSERT zbooking_dcr
    FROM ( SELECT * FROM /dmo/booking_m  ).

    INSERT zbooking_sup_dcr
    FROM ( SELECT * FROM /dmo/booksuppl_m  ).

    COMMIT WORK AND WAIT.
  ENDMETHOD.

ENDCLASS.
