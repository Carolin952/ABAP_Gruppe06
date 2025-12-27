CLASS lhc_Registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Registration RESULT result.

    METHODS ApproveRegistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~ApproveRegistration RESULT result.

    METHODS RejectRegistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~RejectRegistration RESULT result.

ENDCLASS.

CLASS lhc_Registration IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

 METHOD ApproveRegistration.
    DATA message TYPE REF TO zcm_reg_msg_006.

    READ ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
         ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    DATA lt_updates TYPE TABLE FOR UPDATE zr_registration_006_app2.

    LOOP AT registrations INTO DATA(ls_reg).
      IF ls_reg-Status = 'Approved'.
        message = NEW zcm_reg_msg_006( textid = zcm_reg_msg_006=>already_approved ).
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
        CONTINUE.
      ENDIF.

      IF ls_reg-Status = 'Rejected'.
        message = NEW zcm_reg_msg_006( textid = zcm_reg_msg_006=>already_rejected ).
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = ls_reg-%tky Status = 'Approved' ) TO lt_updates.

      message = NEW zcm_reg_msg_006( severity = if_abap_behv_message=>severity-success
                                     textid   = zcm_reg_msg_006=>approve_success ).
      APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
    ENDLOOP.

    IF lt_updates IS NOT INITIAL.
      MODIFY ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
             ENTITY Registration UPDATE FIELDS ( Status ) WITH lt_updates.
    ENDIF.

    READ ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
         ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(updated_regs).
    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD RejectRegistration.
    DATA message TYPE REF TO zcm_reg_msg_006.

    READ ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
         ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    DATA lt_updates TYPE TABLE FOR UPDATE zr_registration_006_app2.

    LOOP AT registrations INTO DATA(ls_reg).
      IF ls_reg-Status = 'Approved'.
        message = NEW zcm_reg_msg_006( textid = zcm_reg_msg_006=>already_approved ).
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
        CONTINUE.
      ENDIF.

      IF ls_reg-Status = 'Rejected'.
        message = NEW zcm_reg_msg_006( textid = zcm_reg_msg_006=>already_rejected ).
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = ls_reg-%tky Status = 'Rejected' ) TO lt_updates.

      message = NEW zcm_reg_msg_006( severity = if_abap_behv_message=>severity-success
                                     textid   = zcm_reg_msg_006=>reject_success ).
      APPEND VALUE #( %tky = ls_reg-%tky %msg = message ) TO reported-registration.
    ENDLOOP.

    IF lt_updates IS NOT INITIAL.
      MODIFY ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
             ENTITY Registration UPDATE FIELDS ( Status ) WITH lt_updates.
    ENDIF.

    READ ENTITIES OF zr_registration_006_app2 IN LOCAL MODE
         ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(updated_regs).
    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

ENDCLASS.
