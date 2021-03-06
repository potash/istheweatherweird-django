with reference_dates0 as (
    select generate_series(
        '{timestamp}'::timestamp with time zone - '100 years'::interval,
        '{timestamp}'::timestamp with time zone, 
        '1 year'::interval) as ref_date
),

reference_dates as (
    select ref_date, 
           extract(year from ref_date) as year
    from reference_dates0
)

select distinct on(year) year, temp
from reference_dates
join isd
    on isd.timestamp between ref_date - '1 hour'::interval and
                             ref_date + '1 hour'::interval
where place_id = {place_id}
order by year,
    -- no abs(time interval) function so use greatest(interval, -interval)
    greatest(ref_date - timestamp, timestamp - ref_date);
