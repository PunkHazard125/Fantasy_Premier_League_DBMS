-- Current Standings
SELECT * FROM Standings_View;

-- Team Info
SELECT * FROM Team_View;

-- Player Lists
SELECT

    psn.person_id as player_id,
    psn.first_name || ' ' || psn.last_name as player_name,
    plr.position,
    plr.shirt_number

FROM Player plr
JOIN Person psn ON psn.person_id = plr.person_id
JOIN Team t ON t.team_id = plr.team_id
WHERE t.team_id = 1
ORDER BY plr.shirt_number;

-- Manager List
SELECT * FROM Manager_View;

-- Sponsor List
SELECT * FROM Sponsor_View;

-- Stadiums
SELECT * FROM Stadium_View;

-- Fixtures
SELECT * FROM Fixtures ORDER BY match_day;

-- Results
SELECT * FROM Results ORDER BY match_day;

-- Previous Standings
SELECT * FROM Previous_Standings_View;

-- Affiliated Individuals
SELECT * FROM Person_View ORDER BY person_id;

-- Market Values
SELECT

    team_name,
    year,
    value / 1000000 AS value_in_millions

FROM Market_Value_View
WHERE team_id = 1
ORDER BY year;

