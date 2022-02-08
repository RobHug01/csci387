DROP TABLE IF EXISTS users, surveys, input_types, questions, question_choices, answers;

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    password_hashed VARCHAR(255) NOT NULL,
    email VARCHAR(20),
    admin BOOLEAN NOT NULL
);

CREATE TABLE surveys(
    id INT AUTO_INCREMENT PRIMARY KEY,
    survey_name VARCHAR(45) NOT NULL,
    users_id INT NOT NULL,
    FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE 
);

CREATE TABLE input_types(
    id INT AUTO_INCREMENT PRIMARY KEY,
    input_type_name VARCHAR(45)
);

CREATE TABLE questions(
    id INT AUTO_INCREMENT PRIMARY KEY,
    input_types_id INT NULL,
    surveys_id INT NOT NULL,
    question_text VARCHAR(255) NOT NULL,
    question_required BOOLEAN NOT NULL,
    FOREIGN KEY (input_types_id) REFERENCES input_types(id) ON DELETE SET NULL,
    FOREIGN KEY (surveys_id) REFERENCES surveys(id) ON DELETE CASCADE
);

CREATE TABLE question_choices(
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_choice_text VARCHAR(45) NOT NULL,
    questions_id INT NOT NULL,
    FOREIGN KEY (questions_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE response(
    id INT AUTO_INCREMENT PRIMARY KEY,
    surveys_id INT,
    users_id INT,
    FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (surveys_id) REFERENCES surveys(id) ON DELETE CASCADE
)

CREATE TABLE answers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    response_id INT,
    questions_id INT,
    answer_text VARCHAR(255),
    answer_numeric INT,
    answer_yn BOOLEAN,
    question_choices_id INT,
    FOREIGN KEY (response) REFERENCES response(id) ON DELETE CASCADE,
    FOREIGN KEY (questions_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (question_choices_id) REFERENCES question_choices(id) ON DELETE SET NULL
);

INSERT INTO input_types (input_type_name) VALUES("Numeric");
INSERT INTO input_types (input_type_name) VALUES("Multiple Choice");
INSERT INTO input_types (input_type_name) VALUES("Yes or No");
INSERT INTO input_types (input_type_name) VALUES("Text");

DROP PROCEDURE IF EXISTS createUser;
DROP PROCEDURE IF EXISTS createSurvey;
DROP PROCEDURE IF EXISTS createQuestion;
DROP PROCEDURE IF EXISTS createQuestionChoice;
DROP PROCEDURE IF EXISTS createAnswer;

DELIMITER $$

CREATE PROCEDURE createUser(
    IN p_username VARCHAR(20),
    IN p_password_hashed VARCHAR(255),
    IN p_email VARCHAR(20)
)

BEGIN
    IF (SELECT EXISTS(SELECT 1 FROM users WHERE username = p_username)) THEN
        SELECT 'Username already exists';
    ELSEIF (SELECT EXISTS(SELECT 1 FROM users WHERE email = p_email)) THEN
        SELECT 'Email already exists';
    ELSE
        INSERT INTO users (username, password_hashed, email, admin) VALUES(p_email, p_password_hashed, p_email, 0);
    END IF;
END$$

CREATE PROCEDURE createSurvey(
    IN p_survey_name VARCHAR(45),
    IN p_user_id INT
)

BEGIN
    INSERT INTO surveys (survey_name, user_id) VALUES(p_survey_name, p_user_id);
END$$

CREATE PROCEDURE createQuestion(
    IN p_input_types_id INT,
    IN p_surveys_id INT,
    IN p_question_text VARCHAR(255),
    IN question_required BOOLEAN
)

BEGIN
    INSERT INTO questions (input_types_id, surveys_id, question_text, question_required) VALUES(p_input_types_id, p_surveys_id, p_question_text, p_question_required);
END$$

CREATE PROCEDURE createQuestionChoice(
    IN p_question_choice_text VARCHAR(45),
    IN p_question_id INT
)

BEGIN
    INSERT INTO question_choices (question_choice_text, questions_id) VALUES(p_question_choice_text, p_question_id);
END$$

CREATE PROCEDURE createAnswer(
    IN p_question_id INT,
    IN p_user_id INT,
    IN p_answer_text VARCHAR(255),
    IN p_answer_numeric INT,
    IN p_answer_yn BOOLEAN,
    IN p_question_choice_id INT
)

BEGIN
    INSERT INTO answers (questions_id, users_id, answer_text, answer_numeric, answer_yn, question_choices_id) VALUES(p_question_id, p_user_id, p_answer_text, p_answer_numeric, p_answer_yn, p_question_choice_id);
END$$

DELIMITER ;
        