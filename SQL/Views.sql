CREATE OR REPLACE VIEW Standings_View AS
SELECT 
    RANK() OVER (ORDER BY s.points DESC, (t.goals_scored - t.goals_conceded) DESC) AS ranking,
    t.team_name,
    s.wins + s.draws + s.losses as played,
    s.wins * 3 + s.draws as points,
    s.wins,
    s.draws,
    s.losses,
    (t.goals_scored - t.goals_conceded) AS goal_difference
FROM Standings s
JOIN Team t ON s.team_id = t.team_id;

CREATE OR REPLACE VIEW Team_View AS
SELECT
    
    t.team_id,
    t.team_name,
    p.first_name || ' ' || p.last_name AS manager,
    s.stadium_name AS stadium
    
FROM Team t
JOIN stadium s ON s.stadium_id = t.stadium_id
JOIN manager m on m.team_id = t.team_id
JOIN person p on m.person_id = p.person_id;

CREATE OR REPLACE VIEW Manager_View AS
SELECT

    m.person_id as manager_id,
    p.first_name || ' ' || p.last_name as manager_name,
    t.team_name,
    m.experience_years

FROM Manager m
JOIN Person p ON p.person_id = m.person_id
JOIN Team t on t.team_id = m.team_id;

CREATE OR REPLACE VIEW person_view AS
SELECT

  psn.person_id,
  psn.first_name || ' ' || psn.last_name as name,
  
  CASE
  
    WHEN mgr.person_id IS NOT NULL THEN 'Manager'
    WHEN plr.person_id IS NOT NULL THEN 'Player'
    ELSE 'None'
    
  END AS category,
  
  psn.nationality
  
FROM Person psn
LEFT JOIN Manager mgr ON psn.person_id = mgr.person_id
LEFT JOIN Player plr ON psn.person_id = plr.person_id;

CREATE OR REPLACE VIEW Market_Value_View AS
SELECT

    t.team_id,
    t.team_name,
    m.year,
    m.value

FROM Market_Value m
JOIN Team t ON t.team_id = m.team_id;

CREATE OR REPLACE VIEW Sponsor_View AS
SELECT

    t.team_name,
    s.sponsor_name,
    s.sponsor_id

FROM Sponsor s
JOIN Team t ON t.team_id = s.team_id;

CREATE OR REPLACE VIEW Stadium_View AS
SELECT
    
    s.stadium_name,
    t.team_name,
    s.capacity,
    s.stadium_id

FROM Stadium s
JOIN Team t ON t.stadium_id = s.stadium_id;

CREATE OR REPLACE  VIEW Fixtures AS
SELECT

    CEIL(m.match_id / 10) AS match_day,
    t1.team_name || ' vs ' || t2.team_name AS fixture,
    s.stadium_name AS venue

FROM Match m
JOIN Team t1 ON t1.team_id = m.team_a_id
JOIN Team t2 ON t2.team_id = m.team_b_id
JOIN Stadium s ON t1.stadium_id = s.stadium_id;

CREATE OR REPLACE VIEW Results AS
SELECT

    CEIL(m.match_id / 10) AS match_day,
    t1.team_name || ' ' || r.score_a || ' - ' || r.score_b || ' ' || t2.team_name AS fixture,
    CASE
        WHEN r.winner_id IS NOT NULL THEN w.team_name
        ELSE 'Draw'
    END AS winner
    
FROM Result r
JOIN Match m ON m.match_id = r.match_id
JOIN Team t1 ON t1.team_id = m.team_a_id
JOIN Team t2 ON t2.team_id = m.team_b_id
LEFT JOIN Team w ON w.team_id = r.winner_id;

CREATE OR REPLACE VIEW Previous_Standings_View AS
SELECT 
    RANK() OVER (ORDER BY s.points DESC, (t.goals_scored - t.goals_conceded) DESC) AS ranking,
    t.team_name,
    s.played,
    s.points,
    s.wins,
    s.draws,
    s.losses,
    (t.goals_scored - t.goals_conceded) AS goal_difference
FROM Previous_Standings s
JOIN Team t ON s.team_id = t.team_id;

