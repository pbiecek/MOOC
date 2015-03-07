DROP TABLE IF EXISTS course_submissions;
DROP TABLE IF EXISTS course_lessons;

CREATE TABLE IF NOT EXISTS course_lessons (
  id int(10) unsigned NOT NULL /* AUTO_INCREMENT */,
  course_id int(10) unsigned NOT NULL,
  name varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  type smallint(6) NOT NULL,
  position int(11) NOT NULL,
  active tinyint(1) NOT NULL,
  created_at timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  updated_at timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  expect text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id),
  KEY course_lessons_course_id_foreign (course_id)
) ;

CREATE TABLE IF NOT EXISTS course_submissions (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  user_id int(10) unsigned NOT NULL,
  lesson_id int(10) unsigned NOT NULL,
  content text COLLATE utf8_unicode_ci NOT NULL,
  message text COLLATE utf8_unicode_ci NOT NULL,
  status enum('new','pending','errors','ok','expired') COLLATE utf8_unicode_ci NOT NULL,
  evaluated_at timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY course_submissions_user_id_foreign (user_id),
  KEY course_submissions_lesson_id_foreign (lesson_id)
) ;


/*CREATE TABLE IF NOT EXISTS tbl_user ( -- participates in the course
    -- the only requirement for id is uniqueness, hence all other than PK can be removed
    id INTEGER AUTO_INCREMENT PRIMARY KEY COMMENT 'Some sort of user id for referential constraints'
    -- more columns go here:
);


CREATE TABLE IF NOT EXISTS tbl_excercise (
    id INTEGER AUTO_INCREMENT PRIMARY KEY COMMENT 'ID to be referenced further on',
    expect TEXT NOT NULL    -- Przemek's R code to be appended at the end of the submitted script
                            -- to perform the actual evaluation step, should print the message (if any)
                            -- and exit with 0 (ok) or != 0 (errors)
    -- all other stuff if needed (description of the task, etc.)
);


CREATE TABLE IF NOT EXISTS tbl_submission (
    id INTEGER AUTO_INCREMENT PRIMARY KEY COMMENT 'Submission ID',
    user_id INTEGER NOT NULL,
    excercise_id INTEGER NOT NULL,
    content TEXT NOT NULL, -- code submitted
    submitted_dttm TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    evaluated_dttm TIMESTAMP,
    status ENUM ('new', 'pending', 'errors', 'ok', 'expired'),
    message TEXT,

    INDEX usr_idx (user_id),
    FOREIGN KEY (user_id) REFERENCES tbl_user (id),

    INDEX exc_idx (excercise_id),
    FOREIGN KEY (excercise_id) REFERENCES tbl_excercise (id)
);*/


