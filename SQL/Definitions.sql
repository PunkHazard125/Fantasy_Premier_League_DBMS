DROP TABLE Person CASCADE CONSTRAINTS;
DROP TABLE Team CASCADE CONSTRAINTS;
DROP TABLE Stadium CASCADE CONSTRAINTS;
DROP TABLE Manager CASCADE CONSTRAINTS;
DROP TABLE Player CASCADE CONSTRAINTS;
DROP TABLE Sponsor CASCADE CONSTRAINTS;
DROP TABLE Market_Value CASCADE CONSTRAINTS;
DROP TABLE Match CASCADE CONSTRAINTS;
DROP TABLE Result CASCADE CONSTRAINTS;
DROP TABLE Standings CASCADE CONSTRAINTS;


CREATE TABLE Person (

    person_id VARCHAR2(6) PRIMARY KEY,
    first_name VARCHAR2(20) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    nationality VARCHAR2(30)
    
);

CREATE TABLE Stadium (

    stadium_id VARCHAR2(6) PRIMARY KEY,
    stadium_name VARCHAR2(30) NOT NULL,
    capacity NUMBER
    
);

CREATE TABLE Team (

    team_id NUMBER PRIMARY KEY,
    team_name VARCHAR2(30) NOT NULL,
    stadium_id VARCHAR2(6) UNIQUE NOT NULL,
    manager_id VARCHAR2(6) NOT NULL,
    goals_scored NUMBER DEFAULT 0,
    goals_conceded NUMBER DEFAULT 0,
    strength NUMBER DEFAULT 0
    
);

CREATE TABLE Manager (

    person_id VARCHAR2(6) PRIMARY KEY,
    team_id NUMBER UNIQUE NOT NULL,
    experience_years NUMBER
    
);

CREATE TABLE Player (

    person_id VARCHAR2(6) PRIMARY KEY,
    team_id NUMBER NOT NULL,
    position VARCHAR2(10),
    shirt_number NUMBER(2, 0)
    
);

CREATE TABLE Sponsor (

    sponsor_id VARCHAR2(6) PRIMARY KEY,
    sponsor_name VARCHAR2(30) NOT NULL,
    team_id NUMBER NOT NULL
    
);

CREATE TABLE Market_Value (

    team_id NUMBER NOT NULL,
    year NUMBER NOT NULL,
    value NUMBER(15, 2),
    PRIMARY KEY (team_id, year)
    
);

CREATE TABLE Match (

    match_id NUMBER PRIMARY KEY,
    team_a_id NUMBER NOT NULL,
    team_b_id NUMBER NOT NULL,
    stadium_id VARCHAR2(6) NOT NULL
    
);

CREATE TABLE Result (

    match_id NUMBER PRIMARY KEY,
    score_a NUMBER DEFAULT 0,
    score_b NUMBER DEFAULT 0,
    winner_id NUMBER
    
);

CREATE TABLE Standings (

    team_id NUMBER PRIMARY KEY,
    played NUMBER DEFAULT 0,
    points NUMBER DEFAULT 0,
    wins NUMBER DEFAULT 0,
    draws NUMBER DEFAULT 0,
    losses NUMBER DEFAULT 0
    
);

