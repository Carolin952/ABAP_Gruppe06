@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Base View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_EVENT_006 
  as select from ZI_EVENT_006
  composition [0..*] of ZR_REGISTRATION_006 as _Registrations
{
    key EventUuid,
    EventId,
    Title,
    Location,
    StartDate,
    EndDate,
    MaxParticipants,
    Status,
    StatusText,
    Description,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _Registrations
}
