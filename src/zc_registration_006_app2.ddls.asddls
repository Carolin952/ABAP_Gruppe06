@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Projection View App 2'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_REGISTRATION_006_APP2 
provider contract transactional_query
  as projection on ZR_REGISTRATION_006_App2
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
