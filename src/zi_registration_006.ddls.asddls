@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Interface View'
define view entity ZI_REGISTRATION_006
  as select from zrap_regist_006
{
    key registration_uuid as RegistrationUuid,
    registration_id as RegistrationId,
    event_uuid as EventUuid,
    participant_uuid as ParticipantUuid,
    status as Status,
    remarks as Remarks,
    
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    cast(created_at as abap.dec(21,0)) as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    cast(last_changed_at as abap.dec(21,0)) as LastChangedAt
}
