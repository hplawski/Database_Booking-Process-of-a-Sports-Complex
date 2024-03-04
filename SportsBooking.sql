
CREATE DATABASE sports_booking; 

--create tables
CREATE TABLE members (
    id VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    member_since TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);


CREATE TABLE pending_terminations (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    request_date TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);

CREATE TABLE rooms (
    id VARCHAR(255) PRIMARY KEY,
    room_type VARCHAR(255) NOT NULL,
    price DECIMAL(6, 2) NOT NULL
);


CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    room_id VARCHAR(255) NOT NULL,
    booked_date DATE NOT NULL,
    booked_time TIME NOT NULL,
    member_id VARCHAR(255) NOT NULL,
    datetime_of_booking TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_status VARCHAR(255) NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT uc1 UNIQUE (room_id, booked_date, booked_time)
);



--alter table bookings 
ALTER TABLE bookings
    ADD CONSTRAINT fk1 FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk2 FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE ON UPDATE CASCADE;
	

--insert data
INSERT INTO members (id, password, email, member_since, payment_due) VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com', '2018-02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com', '2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16 22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18 16:28:35', 0);


INSERT INTO rooms (id, room_type, price) VALUES ('AR', 'Archery Range', 120),
('B1', 'Badminton Court', 8),
('B2', 'Badminton Court', 8),
('MPF1', 'Multi Purpose Field', 50),
('MPF2', 'Multi Purpose Field', 60),
('T1', 'Tennis Court', 10),
('T2', 'Tennis Court', 10);


INSERT INTO bookings (id, room_id, booked_date, booked_time, member_id, datetime_of_booking, payment_status) 
VALUES 
(1, 'AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20 05:22:10', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30 14:40:23', 'Paid');



--create view
CREATE VIEW member_bookings AS
SELECT bookings.id, bookings.room_id, rooms.room_type, bookings.booked_date, bookings.booked_time, bookings.member_id, bookings.datetime_of_booking, rooms.price, bookings.payment_status
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
ORDER BY bookings.id;


--create procedures
CREATE OR REPLACE FUNCTION insert_new_member(p_id VARCHAR(255), p_password VARCHAR(255), p_email VARCHAR(255)) RETURNS VOID AS $$
BEGIN
    INSERT INTO members (id, password, email) VALUES (p_id, p_password, p_email);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_member(p_id VARCHAR(255)) RETURNS VOID AS $$
BEGIN
    DELETE FROM members WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_member_password(p_id VARCHAR(255), p_password VARCHAR(255)) RETURNS VOID AS $$
BEGIN
    UPDATE members SET password = p_password WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_member_email(p_id VARCHAR(255), p_email VARCHAR(255)) RETURNS VOID AS $$
BEGIN
    UPDATE members SET email = p_email WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION make_booking(p_room_id VARCHAR(255), p_booked_date DATE, p_booked_time TIME, p_member_id VARCHAR(255)) RETURNS VOID AS $$
DECLARE
    v_price DECIMAL(6, 2);
    v_payment_due DECIMAL(6, 2);
BEGIN
    SELECT price INTO v_price FROM rooms WHERE id = p_room_id;
    
    INSERT INTO bookings (room_id, booked_date, booked_time, member_id)
    VALUES (p_room_id, p_booked_date, p_booked_time, p_member_id);
    
    SELECT payment_due INTO v_payment_due FROM members WHERE id = p_member_id;
    
    UPDATE members SET payment_due = v_payment_due + v_price WHERE id = p_member_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_payment(p_id INT) RETURNS VOID AS $$
DECLARE
    v_member_id VARCHAR(255);
    v_payment_due DECIMAL(6, 2);
    v_price DECIMAL(6, 2);
BEGIN
    UPDATE bookings SET payment_status = 'Paid' WHERE id = p_id;

    SELECT member_id, price INTO v_member_id, v_price FROM member_bookings WHERE id = p_id;
    
    SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
    
    UPDATE members SET payment_due = v_payment_due - v_price WHERE id = v_member_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cancel_booking(p_booking_id INT) RETURNS VOID AS $$
DECLARE
    v_cancellation INT;
    v_member_id VARCHAR(255);
    v_payment_status VARCHAR(255);
    v_booked_date DATE;
    v_price DECIMAL(6, 2);
    v_payment_due DECIMAL(6, 2);
BEGIN
    --Initialize variables
    v_cancellation := 0;

    --Fetch booking details
    SELECT member_id, booked_date, price, payment_status 
    INTO v_member_id, v_booked_date, v_price, v_payment_status 
    FROM member_bookings 
    WHERE id = p_booking_id;

    --Fetch payment due for the member
    SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;

    --Check cancellation conditions
    IF CURRENT_DATE >= v_booked_date THEN
        RAISE EXCEPTION 'Cancellation cannot be done on/after the booked date';
    ELSIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid' THEN
        RAISE EXCEPTION 'Booking has already been cancelled or paid';
    ELSE
        --Update booking status to Cancelled
        UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;

        --Check cancellation count
        v_cancellation := check_cancellation(v_member_id);
        
        --Adjust payment due based on cancellation count
        IF v_cancellation >= 2 THEN
            v_payment_due := v_payment_due + 10;
        END IF;

        --Deduct booking price from member's payment due
        v_payment_due := v_payment_due - v_price;
        
        --Update member's payment due
        UPDATE members SET payment_due = v_payment_due WHERE id = v_member_id;
        
        --Set cancellation message
        RAISE NOTICE 'Booking Cancelled';
    END IF;
END;
$$ LANGUAGE plpgsql;







--create trigger
CREATE OR REPLACE FUNCTION payment_check() RETURNS TRIGGER AS $$
DECLARE
    v_payment_due DECIMAL(6, 2);
BEGIN
    --Fetch payment_due for the member being deleted
    SELECT payment_due INTO v_payment_due FROM members WHERE id = OLD.id;
    
    --Check if payment_due is greater than 0
    IF v_payment_due > 0 THEN
        --Insert the member's information into pending_terminations
        INSERT INTO pending_terminations (id, email, payment_due) 
        VALUES (OLD.id, OLD.email, OLD.payment_due);
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

--Create the trigger
CREATE TRIGGER payment_check
BEFORE DELETE ON members
FOR EACH ROW
EXECUTE FUNCTION payment_check();






--create function
CREATE OR REPLACE FUNCTION check_cancellation(p_booking_id INT) RETURNS INT AS $$
DECLARE
    v_done INT;
    v_cancellation INT := 0;
    v_current_payment_status VARCHAR(255);
    cur CURSOR FOR
        SELECT payment_status FROM bookings WHERE member_id = (SELECT member_id FROM bookings WHERE id = p_booking_id) ORDER BY datetime_of_booking DESC;
BEGIN
    v_done := 0;
    OPEN cur;
    -- Loop begins here
    LOOP
        FETCH cur INTO v_current_payment_status;
        IF v_current_payment_status != 'Cancelled' OR v_done = 1 THEN
            EXIT; -- Exit the loop if conditions are met
        ELSE
            v_cancellation := v_cancellation + 1;
        END IF;
    END LOOP; -- End of loop
    CLOSE cur;
    RETURN v_cancellation;
END;
$$ LANGUAGE plpgsql;












