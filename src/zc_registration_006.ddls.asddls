@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_REGISTRATION_006 
  as projection on ZR_REGISTRATION_006
{
    key RegistrationUuid,
    RegistrationId,
    EventUuid,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZR_PARTICIPANT_006', element: 'ParticipantUuid' } }]
    @ObjectModel.text.element: ['FullName']
    ParticipantUuid,
    Status, 
    Remarks,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _Participant.FullName as FullName,
    
    /* Associations */
    _Event : redirected to parent ZC_EVENT_006,
    _Participant
}
