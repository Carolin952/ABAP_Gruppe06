@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participant Base View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_PARTICIPANT_006 
  as select from ZI_PARTICIPANT_006
{
    key ParticipantUuid,
    ParticipantId,
    FirstName,
    LastName,
    FullName, 
    Email,
    Phone,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
