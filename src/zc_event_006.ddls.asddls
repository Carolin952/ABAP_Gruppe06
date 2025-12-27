@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Projection View'
@ObjectModel.semanticKey: [ 'EventId' ]
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_EVENT_006 
  provider contract transactional_query
  as projection on ZR_EVENT_006
{
    key EventUuid,
    EventId,
    Title,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7 
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
    
    /* Associations */
    _Registrations : redirected to composition child ZC_REGISTRATION_006
}
