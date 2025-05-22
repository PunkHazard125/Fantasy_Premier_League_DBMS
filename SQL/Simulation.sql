CREATE OR REPLACE PROCEDURE simulate_matches IS

    CURSOR match_cursor IS
    
        SELECT m.match_id, m.team_a_id, m.team_b_id, t1.strength as strength_a, t2.strength as strength_b
        FROM Match m
        JOIN Team t1 ON t1.team_id = m.team_a_id
        JOIN Team t2 ON t2.team_id = m.team_b_id;
        
    v_match_id Match.match_id%type;
    v_team_a_id Match.team_a_id%type;
    v_team_b_id Match.team_b_id%type;
    
    v_strength_a Team.strength%type;
    v_strength_b Team.strength%type;
    
    v_score_a NUMBER;
    v_score_b NUMBER;
    v_winner_id NUMBER;
    
    v_bias_a NUMBER;
    v_bias_b NUMBER;

BEGIN
    
    DBMS_RANDOM.INITIALIZE(TRUNC(DBMS_RANDOM.VALUE * 10000));
    
    FOR current_match IN match_cursor LOOP
    
        v_match_id := current_match.match_id;
        v_team_a_id := current_match.team_a_id;
        v_team_b_id := current_match.team_b_id;
        
        v_strength_a := current_match.strength_a;
        v_strength_b := current_match.strength_b;
        
        v_bias_a := FLOOR(DBMS_RANDOM.VALUE(0, ((v_strength_a / 2) + 2)));
        v_bias_b := FLOOR(DBMS_RANDOM.VALUE(0, ((v_strength_b / 2) + 1)));
        
        v_score_a := LEAST(6, v_bias_a);
        v_score_b := LEAST(6, v_bias_b);
        
        IF v_score_a > v_score_b THEN
            v_winner_id := v_team_a_id;
        ELSIF v_score_b > v_score_a THEN
            v_winner_id := v_team_b_id; 
        ELSE
            v_winner_id := NULL;
        END IF;     
        
        MERGE INTO Result r
        USING (SELECT v_match_id as match_id FROM DUAL) m
        ON (r.match_id = m.match_id)
        WHEN MATCHED THEN
            UPDATE SET score_a = v_score_a, score_b = v_score_b, winner_id = v_winner_id
        WHEN NOT MATCHED THEN
            INSERT (match_id, score_a, score_b, winner_id)
            VALUES(v_match_id, v_score_a, v_score_b, v_winner_id);
    
    END LOOP;    

END;
/


CREATE OR REPLACE TRIGGER update_standings
AFTER INSERT OR UPDATE ON Result
FOR EACH ROW

DECLARE

    v_team_a Match.team_a_id%TYPE;
    v_team_b Match.team_b_id%TYPE;
    v_score_a Result.score_a%TYPE;
    v_score_b Result.score_b%TYPE;
    
    
BEGIN

    SELECT team_a_id, team_b_id INTO v_team_a, v_team_b
    FROM Match
    WHERE match_id = :NEW.match_id;
    
    v_score_a := :NEW.score_a;
    v_score_b := :NEW.score_b;
    
    UPDATE Standings SET played = played + 1 WHERE team_id IN (v_team_a, v_team_b);
    
    UPDATE Team SET goals_scored = goals_scored + v_score_a WHERE team_id = v_team_a;
    UPDATE Team SET goals_scored = goals_scored + v_score_b WHERE team_id = v_team_b;
    
    UPDATE Team SET goals_conceded = goals_conceded + v_score_b WHERE team_id = v_team_a;
    UPDATE Team SET goals_conceded = goals_conceded + v_score_a WHERE team_id = v_team_b;
    
    IF :NEW.winner_id IS NULL THEN
        UPDATE Standings SET draws = draws + 1, points = points + 1 WHERE team_id IN (v_team_a, v_team_b);
    ELSIF :NEW.winner_id = v_team_a THEN
        UPDATE Standings SET wins = wins + 1, points = points + 3 WHERE team_id = v_team_a;
        UPDATE Standings SET losses = losses + 1 WHERE team_id = v_team_b;
    ELSIF :NEW.winner_id = v_team_b THEN
        UPDATE Standings SET wins = wins + 1, points = points + 3 WHERE team_id = v_team_b;
        UPDATE Standings SET losses = losses + 1 WHERE team_id = v_team_a;
    END IF;    

END;
/

CREATE OR REPLACE PROCEDURE reset_league IS

BEGIN

    UPDATE Result
    SET
        score_a = 0,
        score_b = 0,
        winner_id = NULL;
        

    UPDATE Standings
    SET
        played = 0,
        points = 0,
        wins = 0,
        draws = 0,
        losses = 0;
    

    UPDATE Team
    SET
        goals_scored = 0,
        goals_conceded = 0;
    
    COMMIT;
    
END;
/


BEGIN
    simulate_matches;
END;
/
