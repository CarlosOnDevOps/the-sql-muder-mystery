-- transcript.person_id, transcript
-- 67318	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. 

-- clues: woman, rich, height between 5'5 - 5'7, red hair, drives a Tesla Model S, attended SQL Symphony Concert 3 times in Dec 2017

        SELECT person_id
            , event_id
            , event_name
            , date as concert_date
        FROM facebook_event_checkin
        WHERE event_name = 'SQL Symphony Concert' AND
            date BETWEEN'20171201' and '20171231' 
        GROUP BY person_id
        HAVING COUNT(1) >= 3;
-- output: 24556, 99716

/* THIS IS THE SOLUTION */
-- 99716 fits the female description so let's follow up on this lead
SELECT f.event_name
	, f.date AS concert_date	
	, p.name
	, p.ssn
	, p.id
FROM facebook_event_checkin f
JOIN person p ON p.id=f.person_id
WHERE person_id = 99716
-- output: Miranda Priestly 
   