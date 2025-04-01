-- transcript.person_id, transcript
-- 67318	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. 

-- clues: woman, rich, height between 5'5 - 5'7, red hair, drives a Tesla Model S, attended SQL Symphony Concert 3 times in Dec 2017
WITH money_bags AS (
    SELECT
        ssn
        , annual_income
    FROM income
    ORDER BY annual_income DESC
    ),

    license AS (
        SELECT id AS license_id
            , age
            , height
            , plate_number
            , car_make
            , car_model
        FROM drivers_license
        WHERE gender = 'female' AND
            height BETWEEN 65 AND 67 AND
            hair_color = 'red'AND
            car_make = 'Tesla' AND 
            car_model = 'Model S'


            -- PICK BACK UP HERE!! you need to add more criteria, i think
    )
    -- the_usual_suspects AS (
    -- SELECT ssn
    --     , id AS person_id
    --     , name
    --     , license_id
    --     , address_number
    --     , address_street_name
    -- FROM person
    -- WHERE 
    -- )
FROM money_bags;