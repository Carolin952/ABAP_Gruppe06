@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Interface View'
define view entity ZI_EVENT_006 
  as select from zrap_event_006 
{
    key event_uuid as EventUuid,
    event_id as EventId,
    title as Title,
    location as Location,
    start_date as StartDate,
    end_date as EndDate,
    max_participants as MaxParticipants,
    status as Status,
    
    case status
        when 'P' then 'Planned'
        when 'O' then 'Open'
        when 'C' then 'Closed'
        else 'Not defined'
    end as StatusText,
    
    description as Description,
    
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
   @Semantics.systemDateTime.createdAt: true
    cast(created_at as abap.dec(21,0)) as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    cast(last_changed_at as abap.dec(21,0)) as LastChangedAt
}
