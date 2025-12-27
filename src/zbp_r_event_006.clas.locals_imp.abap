*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_registrations DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS GenerateRegistrationId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registrations~GenerateRegistrationId.
    METHODS SetRegistrationstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registrations~SetRegistrationstatus.
    METHODS MaxParticipantsNotReached FOR VALIDATE ON SAVE
      IMPORTING keys FOR Registrations~MaxParticipantsNotReached.

ENDCLASS.

CLASS lhc_registrations IMPLEMENTATION.

  METHOD GenerateRegistrationId.

    SELECT FROM zrap_regist_006 FIELDS MAX( registration_id ) INTO @DATA(max_reg_id).
    DATA(lv_registration_id) = max_reg_id + 1.

    MODIFY ENTITY IN LOCAL MODE ZR_REGISTRATION_006
           UPDATE FIELDS ( RegistrationId )
           WITH VALUE #( FOR key IN keys
                         ( %tky           = key-%tky
                           RegistrationId = lv_registration_id ) ).
  ENDMETHOD.

  METHOD SetRegistrationstatus.
    MODIFY ENTITY IN LOCAL MODE ZR_REGISTRATION_006
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = 'New' ) ).
  ENDMETHOD.

  METHOD MaxParticipantsNotReached.
    DATA message TYPE REF TO zcm_event_msg_006.

    READ ENTITY IN LOCAL MODE ZR_REGISTRATION_006
         FIELDS ( EventUuid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations INTO DATA(registration).
      SELECT SINGLE max_participants FROM zrap_event_006
        WHERE event_uuid = @registration-EventUuid INTO @DATA(lv_max_participants).

      SELECT COUNT( * ) FROM zrap_regist_006
        WHERE event_uuid = @registration-EventUuid INTO @DATA(lv_current_registrations).

      IF lv_max_participants <= lv_current_registrations.
        message = NEW zcm_event_msg_006( textid = zcm_event_msg_006=>max_participants_reached ).

        APPEND VALUE #( %tky = registration-%tky
                        %msg = message ) TO reported-registrations.
        APPEND VALUE #( %tky = registration-%tky ) TO failed-registrations.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Event RESULT result.

    METHODS GenerateEventId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Event~GenerateEventId.

    METHODS SetEventStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Event~SetEventStatus.

    METHODS CloseEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~CloseEvent RESULT result.

    METHODS OpenEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~OpenEvent RESULT result.

    METHODS ValidateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Event~ValidateDates.

    METHODS ValidateStartDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Event~ValidateStartDate.


ENDCLASS.

CLASS lhc_Event IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD GenerateEventId.
    SELECT FROM zrap_event_006 FIELDS MAX( event_id ) INTO @DATA(max_event_id).
    DATA(lv_event_id) = max_event_id + 1.

    MODIFY ENTITY IN LOCAL MODE ZR_EVENT_006
           UPDATE FIELDS ( EventId )
           WITH VALUE #( FOR key IN keys
                         ( %tky    = key-%tky
                           EventId = lv_event_id ) ).
  ENDMETHOD.

  METHOD SetEventStatus.
    MODIFY ENTITY IN LOCAL MODE ZR_EVENT_006
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = 'P' ) ).
  ENDMETHOD.

  METHOD CloseEvent.
    READ ENTITY IN LOCAL MODE ZR_EVENT_006
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events REFERENCE INTO DATA(event).
      event->Status = 'C'.
    ENDLOOP.

    MODIFY ENTITY IN LOCAL MODE ZR_EVENT_006
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN events
                         ( %tky = t-%tky Status = t-Status ) ).

    result = VALUE #( FOR t IN events
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD OpenEvent.
    READ ENTITY IN LOCAL MODE ZR_EVENT_006
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events REFERENCE INTO DATA(event).
      event->Status = 'O'.
    ENDLOOP.

    MODIFY ENTITY IN LOCAL MODE ZR_EVENT_006
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN events
                         ( %tky = t-%tky Status = t-Status ) ).

    result = VALUE #( FOR t IN events
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD ValidateDates.
    DATA message TYPE REF TO zcm_event_msg_006.

    READ ENTITY IN LOCAL MODE ZR_EVENT_006
         FIELDS ( StartDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events INTO DATA(event).
      IF event-EndDate < event-StartDate.
        message = NEW zcm_event_msg_006( textid = zcm_event_msg_006=>invalid_dates ).
        APPEND VALUE #( %tky = event-%tky
                        %msg = message ) TO reported-event.
        APPEND VALUE #( %tky = event-%tky ) TO failed-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateStartDate.
    DATA message TYPE REF TO zcm_event_msg_006.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    READ ENTITY IN LOCAL MODE ZR_EVENT_006
         FIELDS ( StartDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events INTO DATA(event).
      IF event-StartDate < lv_today.
        message = NEW zcm_event_msg_006( textid = zcm_event_msg_006=>invalid_startdate ).
        APPEND VALUE #( %tky = event-%tky
                        %msg = message ) TO reported-event.
        APPEND VALUE #( %tky = event-%tky ) TO failed-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
