-- Exercise 1, Question 1
SELECT PS.NAME_OF_SCHOOL, SO.COMMUNITY_AREA_NAME, PS.AVERAGE_STUDENT_ATTENDANCE, SO.HARDSHIP_INDEX
FROM CHICAGO_PUBLIC_SCHOOLS AS PS
LEFT OUTER JOIN CHICAGO_SOCIOECONOMIC_DATA AS SO
    ON PS.COMMUNITY_AREA_NUMBER = SO.COMMUNITY_AREA_NUMBER
WHERE SO.HARDSHIP_INDEX = 98
;

-- Exercise 1, Question 2
SELECT CR.CASE_NUMBER, CR.PRIMARY_TYPE, SO.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME AS CR
LEFT OUTER JOIN CHICAGO_SOCIOECONOMIC_DATA AS SO
    ON CR.COMMUNITY_AREA_NUMBER = SO.COMMUNITY_AREA_NUMBER
WHERE LOCATION_DESCRIPTION LIKE '%SCHOOL%'
;

-- Exercise 2, Question 1
CREATE OR REPLACE VIEW view(School_Name, Safety_Rating, Family_Rating, Environment_Rating,
                            Instruction_Rating, Leaders_Rating, Teachers_Rating
                 ) AS
        SELECT  NAME_OF_SCHOOL, Safety_Icon, Family_Involvement_Icon, Environment_Icon,
                Instruction_Icon, Leaders_Icon, Teachers_Icon
        FROM CHICAGO_PUBLIC_SCHOOLS
;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Mysql_learners'
AND TABLE_NAME = 'view'
;

SELECT School_Name, Leaders_Rating
FROM view
;
	
-- Exercise 3, Question 1
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;

DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
    BEGIN
    END @ 
DELIMITER ;

-- Exercise 3, Question 2
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;

DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
    BEGIN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Score = in_Leader_Score
        WHERE School_ID = in_School_ID
        ;
    END @ 
DELIMITER ;

-- Exercise 3, Question 3
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;
DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
    BEGIN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Score = in_Leader_Score
        WHERE School_ID = in_School_ID
        ;
        IF in_Leader_Score BETWEEN 80 AND 99 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Very Strong'
            WHERE School_ID = in_School_ID
            ;
		ELSEIF in_Leader_Score BETWEEN 60 AND 79 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Strong'
            WHERE School_ID = in_School_ID
            ;
		ELSEIF in_Leader_Score BETWEEN 40 AND 59 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Average'
            WHERE School_ID = in_School_ID
			;
		ELSEIF in_Leader_Score BETWEEN 20 AND 39 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Weak'
            WHERE School_ID = in_School_ID
			;
		ELSEIF in_Leader_Score BETWEEN 0 AND 19 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Very Weak'
            WHERE School_ID = in_School_ID
			;
		END IF;
    END @ 
DELIMITER ;

-- Exercise 3, Question 4
-- This below be able to perform our changes
ALTER TABLE CHICAGO_PUBLIC_SCHOOLS MODIFY COLUMN Leaders_Icon VARCHAR(11);
CALL UPDATE_LEADERS_SCORE(610038, 38)
;

-- Exercise 4, Question 1
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;
DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
    BEGIN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Score = in_Leader_Score
        WHERE School_ID = in_School_ID
        ;
        IF in_Leader_Score BETWEEN 80 AND 99 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Very Strong'
            WHERE School_ID = in_School_ID
            ;
		ELSEIF in_Leader_Score BETWEEN 60 AND 79 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Strong'
            WHERE School_ID = in_School_ID
            ;
		ELSEIF in_Leader_Score BETWEEN 40 AND 59 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Average'
            WHERE School_ID = in_School_ID
			;
		ELSEIF in_Leader_Score BETWEEN 20 AND 39 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Weak'
            WHERE School_ID = in_School_ID
			;
		ELSEIF in_Leader_Score BETWEEN 0 AND 19 THEN
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Icon = 'Very Weak'
            WHERE School_ID = in_School_ID
			;
		ELSE
			ROLLBACK;
		END IF;
    END @ 
DELIMITER ;

-- Exercise 4, Question 2
DROP PROCEDURE IF EXISTS UPDATE_LEADERS_SCORE;
DELIMITER @
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
    BEGIN
		START TRANSACTION;
			UPDATE CHICAGO_PUBLIC_SCHOOLS
			SET Leaders_Score = in_Leader_Score
			WHERE School_ID = in_School_ID
			;
			IF in_Leader_Score BETWEEN 80 AND 99 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Strong'
				WHERE School_ID = in_School_ID
				;
			ELSEIF in_Leader_Score BETWEEN 60 AND 79 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Strong'
				WHERE School_ID = in_School_ID
				;
			ELSEIF in_Leader_Score BETWEEN 40 AND 59 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Average'
				WHERE School_ID = in_School_ID
				;
			ELSEIF in_Leader_Score BETWEEN 20 AND 39 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Weak'
				WHERE School_ID = in_School_ID
				;
			ELSEIF in_Leader_Score BETWEEN 0 AND 19 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Weak'
				WHERE School_ID = in_School_ID
				;
			ELSE
				ROLLBACK;
			END IF;
        COMMIT;
    END @ 
DELIMITER ;