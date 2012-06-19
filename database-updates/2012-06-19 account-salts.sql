ALTER TABLE accounts ADD COLUMN salt VARCHAR(64) NOT NULL;
UPDATE accounts SET salt = 'indiawoncricketworldcup2011';
