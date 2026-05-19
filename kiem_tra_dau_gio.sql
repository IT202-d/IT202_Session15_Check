-- cau 1:
DELIMITER //
CREATE TRIGGER tg_check_score
BEFORE INSERT ON grades
FOR EACH ROW
	BEGIN 
		IF NEW.score < 0 THEN
			SET NEW.score = 0;
		END IF;
        IF NEW.score > 10 THEN
			SET NEW.score = 10;
		END IF;
    END //
DELIMITER ;


-- cau 2;
START TRANSACTION;
INSERT INTO students(student_id, full_name)
VALUES('SVO2', 'Ha Bich Ngoc');

UPDATE students
SET total_debt = 5000000
WHERE student_id = 'SV02';
COMMIT;

-- CAU 3:
DELIMITER //
CREATE TRIGGER tg_log_grade_update
AFTER UPDATE ON grades
FOR EACH ROW
	BEGIN 
		INSERT INTO grede_log(student_id, old_score, new_score, change_date)
		VALUES (OLD.student_id, OLD.score, NEW.score, NOW());
    
    END //
DELIMITER ;

-- CAU4 :
DELIMITER //
CREATE PROCEDURE sp_pay_tuition()
	BEGIN
		START TRANSACTION;
        
        UPDATE students
        SET total_debt = total_debt - 2000000
        WHERE student_id = 'SV01';
        
        IF (SELECT total_debt FROM students WHERE student_id = 'SV01')  < 0 THEN
			ROLLBACK;
        ELSE 
			COMMIT ;
		END IF;

	END //
DELIMITER ;

-- CAU 5: 
DELIMITER //
CREATE TRIGGER tg_prevent_pass_update
BEFORE UPDATE ON grades
FOR EACH ROW
	BEGIN 
		IF OLD.score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Không được sửa điểm  sinh viên vì đã qua môn';
         END IF;
         
    END //
DELIMITER ;