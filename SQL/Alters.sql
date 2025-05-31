-- Team
ALTER TABLE Team ADD CONSTRAINT fk_team_stadium FOREIGN KEY (stadium_id) REFERENCES Stadium(stadium_id);
ALTER TABLE Team ADD CONSTRAINT fk_team_manager FOREIGN KEY (manager_id) REFERENCES Manager(person_id);

-- Manager
ALTER TABLE Manager ADD CONSTRAINT fk_manager_person FOREIGN KEY (person_id) REFERENCES Person(person_id);
ALTER TABLE Manager ADD CONSTRAINT fk_manager_team FOREIGN KEY (team_id) REFERENCES Team(team_id);

-- Player
ALTER TABLE Player ADD CONSTRAINT fk_player_person FOREIGN KEY (person_id) REFERENCES Person(person_id);
ALTER TABLE Player ADD CONSTRAINT fk_player_team FOREIGN KEY (team_id) REFERENCES Team(team_id);
ALTER TABLE Player ADD CONSTRAINT unique_shirt_number UNIQUE (team_id, shirt_number);

-- Sponsor
ALTER TABLE Sponsor ADD CONSTRAINT fk_sponsor_team FOREIGN KEY (team_id) REFERENCES Team(team_id);

-- Market Value
ALTER TABLE Market_Value ADD CONSTRAINT fk_marketvalue_team FOREIGN KEY (team_id) REFERENCES Team(team_id);

-- Match
ALTER TABLE Match ADD CONSTRAINT fk_match_team_a FOREIGN KEY (team_a_id) REFERENCES Team(team_id);
ALTER TABLE Match ADD CONSTRAINT fk_match_team_b FOREIGN KEY (team_b_id) REFERENCES Team(team_id);
ALTER TABLE Match ADD CONSTRAINT fk_match_stadium FOREIGN KEY (stadium_id) REFERENCES Stadium(stadium_id);
ALTER TABLE Match ADD CONSTRAINT chk_teams_different CHECK (team_a_id <> team_b_id);

-- Result
ALTER TABLE Result ADD CONSTRAINT fk_result_match FOREIGN KEY (match_id) REFERENCES Match(match_id);
ALTER TABLE Result ADD CONSTRAINT fk_result_winner FOREIGN KEY (winner_id) REFERENCES Team(team_id);

-- Standings
ALTER TABLE Standings ADD CONSTRAINT fk_standings_team FOREIGN KEY (team_id) REFERENCES Team(team_id);

-- Previous_Standings
ALTER TABLE Previous_Standings ADD CONSTRAINT fk_previous_standings_team FOREIGN KEY (team_id) REFERENCES Team(team_id);

