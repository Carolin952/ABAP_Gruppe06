@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Base View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_REGISTRATION_006 
  as select from ZI_REGISTRATION_006  
    association to parent ZR_EVENT_006 as _Event on $projection.EventUuid = _Event.EventUuid
    association [1..1] to ZR_PARTICIPANT_006 as _Participant on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
    key RegistrationUuid,
    RegistrationId,
    EventUuid,
    ParticipantUuid,
    Status,
    Remarks,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _Event,
    _Participant
}
