CREATE OR REPLACE VIEW Standings_View AS
SELECT 
    RANK() OVER (ORDER BY s.points DESC, (t.goals_scored - t.goals_conceded) DESC) AS ranking,
    t.team_name,
    s.played,
    s.points,
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

