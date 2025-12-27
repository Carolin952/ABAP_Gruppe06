@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Base View for App 2'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_REGISTRATION_006_App2 
  as select from ZI_REGISTRATION_006
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
    LastChangedAt
    
}
