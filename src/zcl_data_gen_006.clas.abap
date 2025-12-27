CLASS zcl_data_gen_006 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_data_gen_006 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_events        TYPE TABLE OF zrap_event_006,
          lt_participants  TYPE TABLE OF zrap_partic_006,
          lt_registrations TYPE TABLE OF zrap_regist_006,
          ls_event         TYPE zrap_event_006,
          ls_participant   TYPE zrap_partic_006,
          ls_registration  TYPE zrap_regist_006.

    TRY.
        DELETE FROM zrap_regist_006.
        out->write( |Gelöschte Registrierungen: { sy-dbcnt }| ).

        DELETE FROM zrap_partic_006.
        out->write( |Gelöschte Teilnehmer: { sy-dbcnt }| ).

        DELETE FROM zrap_event_006.
        out->write( |Gelöschte Events: { sy-dbcnt }| ).


        DATA(lt_fnames) = VALUE stringtab( ( |Ingrid| ) ( |Sandra| ) ( |Ella| ) ( |Annika| ) ( |Mathias| ) ( |Paul| ) ).
        DATA(lt_lnames) = VALUE stringtab( ( |Meyer| ) ( |Müller| ) ( |Bräuniger| ) ( |Morningstar| ) ( |Bauer| ) ( |Sternwald| ) ).

        LOOP AT lt_fnames ASSIGNING FIELD-SYMBOL(<fn>).
          DATA(lv_p_idx) = sy-tabix.
          READ TABLE lt_lnames ASSIGNING FIELD-SYMBOL(<ln>) INDEX lv_p_idx.

          CLEAR ls_participant.
          ls_participant-client           = sy-mandt.
          ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
          ls_participant-participant_id   = |PART-{ lv_p_idx }|.
          ls_participant-first_name       = <fn>.
          ls_participant-last_name        = <ln>.
          ls_participant-email            = |{ to_lower( <fn> ) }.{ to_lower( <ln> ) }@gruppe06.de|.
          ls_participant-phone            = |+49 151 66600{ lv_p_idx }|.

          " Administrative Daten
          ls_participant-created_by       = sy-uname.
          GET TIME STAMP FIELD ls_participant-created_at.
          ls_participant-last_changed_by  = sy-uname.
          GET TIME STAMP FIELD ls_participant-last_changed_at.

          APPEND ls_participant TO lt_participants.
        ENDLOOP.

        INSERT zrap_partic_006 FROM TABLE @lt_participants.
        out->write( |Eingefügte Teilnehmer: { sy-dbcnt }| ).


        DATA(lt_titles) = VALUE stringtab( ( |S/4HANA Bootcamp| ) ( |Clean ABAP| ) ( |RAP Training| )
                                           ( |Cloud Deep Dive| ) ( |BTP Extension| ) ( |DevOps| ) ).

        DATA(lt_locations) = VALUE stringtab( ( |Walldorf| ) ( |Remote| ) ( |München| )
                                              ( |Berlin| ) ( |Remote| ) ( |Hamburg| ) ).

        LOOP AT lt_titles ASSIGNING FIELD-SYMBOL(<title>).
          DATA(lv_e_idx) = sy-tabix.

          READ TABLE lt_locations ASSIGNING FIELD-SYMBOL(<loc>) INDEX lv_e_idx.

          CLEAR ls_event.
          ls_event-client           = sy-mandt.
          ls_event-event_uuid       = cl_system_uuid=>create_uuid_x16_static( ).
          ls_event-event_id         = lv_e_idx.
          ls_event-title            = <title>.

          ls_event-location         = <loc>.

          ls_event-start_date       = cl_abap_context_info=>get_system_date( ) + ( lv_e_idx * 7 ).
          ls_event-end_date         = ls_event-start_date + 2.
          ls_event-max_participants = 10.
          ls_event-status           = 'P'.
          ls_event-description      = |Workshop zu { <title> } in { <loc> }|.

          ls_event-created_by       = sy-uname.
          GET TIME STAMP FIELD ls_event-created_at.
          ls_event-last_changed_by  = sy-uname.
          GET TIME STAMP FIELD ls_event-last_changed_at.

          APPEND ls_event TO lt_events.
        ENDLOOP.

        INSERT zrap_event_006 FROM TABLE @lt_events.
        out->write( |Eingefügte Events: { sy-dbcnt }| ).


        LOOP AT lt_participants ASSIGNING FIELD-SYMBOL(<p_ref>).
          READ TABLE lt_events ASSIGNING FIELD-SYMBOL(<ev>) INDEX sy-tabix.
          IF sy-subrc = 0.
            CLEAR ls_registration.
            ls_registration-client            = sy-mandt.
            ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            ls_registration-registration_id   = |REG-{ sy-tabix }|.
            ls_registration-event_uuid        = <ev>-event_uuid.
            ls_registration-participant_uuid  = <p_ref>-participant_uuid.
            ls_registration-status            = 'New'.

            ls_registration-created_by        = sy-uname.
            GET TIME STAMP FIELD ls_registration-created_at.
            ls_registration-last_changed_by   = sy-uname.
            GET TIME STAMP FIELD ls_registration-last_changed_at.

            APPEND ls_registration TO lt_registrations.
          ENDIF.
        ENDLOOP.

        INSERT zrap_regist_006 FROM TABLE @lt_registrations.
        out->write( |Eingefügte Registrierungen: { sy-dbcnt }| ).

        out->write( |--- FERTIG: Testdaten wurden erfolgreich generiert! ---| ).

      CATCH cx_uuid_error INTO DATA(lx_uuid).
        out->write( |UUID Fehler: { lx_uuid->get_text( ) }| ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
