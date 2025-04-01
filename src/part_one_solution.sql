/* 1. Start by retrieving the corresponding crime scene report from the police department’s database */
   -- clues: murder on Jan 15, 2018
SELECT
    date
    , type
    , description
FROM crime_scene_report
WHERE
    type  = 'murder' AND
    date <= '2018-02-01' AND 
    city = 'SQL City';

/* 1. output:
20180215	murder	REDACTED REDACTED REDACTED
20180215	murder	Someone killed the guard! He took an arrow to the knee!
20180115	murder	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave". */

/* 2. What do we know? Two witnesses and their address. Time to follow up with them */
-- 2.a follow up with witness #1 who lives at the last house on their street
SELECT
	id
	, name
	, address_number
	, address_street_name
FROM person
WHERE
	address_street_name = 'Northwestern Dr'
ORDER BY
	address_number DESC;

/* 2.a. output */
-- 14887	Morty Schapiro	4919	Northwestern Dr

-- 2.b. join to the interview table to get Morty Schapiro's interrogation transcript
SELECT
	p.id
	, p.name
	, p.address_number
	, p.address_street_name
	, i.transcript
FROM person p
JOIN interview i on i.person_id=p.id
WHERE
	address_street_name = 'Northwestern Dr' AND
	person_id = 14887
ORDER BY
	address_number DESC;

/* 2.b. output */
-- transcript: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

-- 2.c this might be our lead, but remember we had two witnesses so let's follow up with the other witness before moving on
SELECT
	p.id
	, p.name
	, p.address_number
	, p.address_street_name
	, i.transcript
FROM person p
JOIN interview i on i.person_id=p.id
WHERE
	address_street_name = 'Franklin Ave' AND
	name LIKE 'Annabel%'
ORDER BY
	address_number DESC;

-- 2.c output
-- 16371	Annabel Miller	103	Franklin Ave	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

-- organize our work thus far
SELECT
	p.id
	, p.name
	, p.address_number
	, p.address_street_name
	, i.transcript
FROM person p
JOIN interview i on i.person_id=p.id
WHERE
	person_id IN (14887, 16371)
ORDER BY
	address_number DESC;

/* 3. What do we know? Identified our two witnessess: Annabel Miller and Morty Schapiro. Both claim they saw this activity as a local gym. Follow up. */
-- clues: license plate contains this text = H42W, local gym = Get Fit Now, gym membership number contains this text = 48Z, potential crime date = Jan 9
-- 3A. investigate license plate
SELECT
	*
FROM drivers_license 
WHERE plate_number LIKE '%H42W%'

-- 3A output:
-- 183779	21	65	blue	blonde	female	H42W0X	Toyota	Prius
-- 423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS
-- 664760	21	71	black	black	male	4H42WR	Nissan	Altima

-- 3B. work backwards and join to other relevant tables
SELECT
	dl.id
	, dl.plate_number
	, p.name
	, p.id
	, m.membership_status
	, ci.check_in_date
FROM drivers_license dl
JOIN person p ON p.license_id=dl.id
JOIN get_fit_now_member m ON m.person_id=p.id
JOIN get_fit_now_check_in ci ON ci.membership_id=m.id
WHERE plate_number LIKE '%H42W%'

/* 3B. output
423327	0H42W2	Jeremy Bowers	67318	gold	20180109 */

