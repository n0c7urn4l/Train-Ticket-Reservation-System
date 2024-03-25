CREATE DATABASE train_management;

CREATE TABLE ROLE(
    roleId INTEGER NOT NULL,
    roleName VARCHAR(20) NOT NULL,
    priority INTEGER NOT NULL,
    PRIMARY KEY (roleId)
);

CREATE TABLE LOGIN(
    loginId INTEGER NOT NULL,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL,
    PRIMARY KEY (loginId)
);

CREATE TABLE STAFF(
    staffId INTEGER NOT NULL,
    roleId INTEGER NOT NULL,
    loginId INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    nic VARCHAR(12) NOT NULL,
    address VARCHAR(100) NOT NULL,
    birthday DATE NOT NULL,
    PRIMARY KEY (staffId),
    FOREIGN KEY (roleId) REFERENCES ROLE(roleId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (loginId) REFERENCES LOGIN(loginId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CUSTOMER(
    nic VARCHAR(12) NOT NULL,
    loginId INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    phoneNumber VARCHAR(10) NOT NULL,
    email VARCHAR(50),
    birthday DATE NOT NULL,
    PRIMARY KEY (nic),
    FOREIGN KEY (loginId) REFERENCES LOGIN(loginId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EMERGENCY(
    alertId INTEGER NOT NULL,
    time DATETIME NOT NULL,
    level INTEGER NOT NULL,
    status BOOLEAN NOT NULL,
    delayTime VARCHAR(20) NOT NULL,
    PRIMARY KEY (alertId)
);

CREATE TABLE STATION(
    stationId INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    province VARCHAR(20) NOT NULL,
    district VARCHAR(20) NOT NULL,
    town VARCHAR(20) NOT NULL,
    distanceFromMainStation INTEGER NOT NULL,
    isLeftFromMain BOOLEAN NOT NULL,
    PRIMARY KEY (stationId)
);

CREATE TABLE TRAIN(
    trainId INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL,
    totalCapacity INTEGER NOT NULL,
    alertId INTEGER ,
    startingStation INTEGER NOT NULL,
    endingStation INTEGER NOT NULL,
    firstClsCapacity INTEGER NOT NULL,
    secondClsCapacity INTEGER NOT NULL,
    economyClsCapacity INTEGER NOT NULL,
    PRIMARY KEY (trainId),
    FOREIGN KEY (alertId) REFERENCES EMERGENCY(alertId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (startingStation) REFERENCES STATION(stationId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (endingStation) REFERENCES STATION(stationId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SCHEDULE(
    scheduleId INTEGER NOT NULL,
    stationId INTEGER NOT NULL,
    departureTime TIME NOT NULL,
    arrivalTime TIME NOT NULL,
    weekday VARCHAR(10) NOT NULL,
    PRIMARY KEY (scheduleId),
    FOREIGN KEY (stationId) REFERENCES STATION(stationId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BOOKING(
    bookingId INTEGER NOT NULL,
    nic VARCHAR(12) NOT NULL,
    trainId INTEGER NOT NULL,
    time DATETIME NOT NULL,
    departureStation INTEGER NOT NULL,
    arrivalStation INTEGER NOT NULL,
    class VARCHAR(20) NOT NULL,
    seatNumber INTEGER NOT NULL,
    PRIMARY KEY (bookingId),
    FOREIGN KEY (trainId) REFERENCES TRAIN(trainId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (departureStation) REFERENCES STATION(stationId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (arrivalStation) REFERENCES STATION(stationId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nic) REFERENCES CUSTOMER(nic) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PAYMENT(
    payId INTEGER NOT NULL,
    bookingId INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    date DATETIME NOT NULL,
    PRIMARY KEY (payId),
    FOREIGN KEY (bookingId) REFERENCES BOOKING(bookingId) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE SCHEDULE
ADD COLUMN trainId INTEGER NOT NULL,
ADD FOREIGN KEY (trainId) REFERENCES TRAIN(trainId) ON DELETE CASCADE ON UPDATE CASCADE;

--insertion of data

INSERT INTO ROLE (roleId, roleName, priority) VALUES
(1, 'Administrator', 1),
(2, 'Station Master', 2),
(3, 'Ticket Clerk', 3);

INSERT INTO LOGIN (loginId, username, password) VALUES
(1, 'admin', 'admin123'),
(3, 'ticketclerk1', 'ticket123'),
(2, 'stationMaster1', 'stationMaster123'),
(4, 'customer1', 'ticket123'),
(5, 'customer2', 'stationMaster123');

INSERT INTO STAFF (staffId, roleId, loginId, name, nic, address, birthday) VALUES
(1, 1, 1, 'Achintha Pallegedara', '200121803157', '123 Main St, Anytown', '2001-08-05'),
(2, 2, 2, 'Gethma Pasqual', '200177302205', '456 Elm St, Othertown', '2001-09-29'),
(3, 3, 3, 'Shanuka Chathuranga', '200033201954', '789 Oak St, Anothertown', '2000-03-25');

INSERT INTO CUSTOMER (nic, loginId, name, phoneNumber, email, birthday) VALUES
('200086202642', 4, 'Janani Samindya', '0715698347', 'kata@example.com', '2000-07-12'),
('200083452642', 5, 'Damn Siripala', '0772123987', 'damn@example.com', '2000-04-01');

INSERT INTO EMERGENCY (alertId, time, level, status, delayTime) VALUES
(1, '2024-03-24 08:00:00', 1, true, '30 minutes'),
(2, '2024-02-20 13:30:00', 2, false, '45 minutes');

INSERT INTO STATION (stationId, name, province, district, town, distanceFromMainStation, isLeftFromMain) VALUES
(1, 'Colombo Fort', 'Western', 'Colombo', 'Colombo', 0, false),
(2, 'Maradana', 'Western', 'Colombo', 'Maradana', 10, true),
(3, 'Panadura', 'Western', 'Colombo', 'Panadura', 15, false),
(4, 'Kurunagala', 'North Western', 'Kurunagala', 'Kurunagala', 40, true),
(5, 'Polonnaruwa', 'North Central', 'Polonnaruwa', 'Polonnaruwa', 75, true);

INSERT INTO TRAIN (trainId, name, type, totalCapacity, startingStation, endingStation, firstClsCapacity, secondClsCapacity, economyClsCapacity) VALUES
(1, 'Yaldevi', 'Intercity', 500, 2, 3, 100, 150, 250),
(2, 'Udayadevi', 'Express', 280, 2, 3, 80, 100, 100),
(3, 'Darakula', 'Local', 100, 1, 4, 20, 30, 50),
(4, 'Pulathisi', 'Local', 350, 4, 5, 50, 140, 160),
(5, 'Badulu Kumari', 'Night Mail', 250, 1, 5, 30, 70, 150);

INSERT INTO SCHEDULE (scheduleId, stationId, arrivalTime, departureTime, weekday, trainId) VALUES
(1, 1, '06:00:00', '06:05:00', 'Monday', 1),
(2, 1, '06:25:00', '06:30:00', 'Monday', 2),
(3, 1, '05:40:00', '05:50:00', 'Wednesday', 3),
(4, 2, '05:45:00', '05:50:00', 'Monday', 1),
(5, 2, '06:20:00', '06:30:00', 'Monday', 2),
(6, 2, '06:10:00', '06:15:00', 'Wednesday', 3),
(7, 3, '06:35:00', '06:40:00', 'Monday', 1),
(8, 3, '07:24:00', '07:29:00', 'Monday', 2),
(9, 4, '08:05:00', '08:09:00', 'Wednesday', 3),
(10, 4, '16:50:00', '16:55:00', 'Saturday', 4),
(11, 5, '20:30:00', '20:33:00', 'Saturday', 4);

INSERT INTO BOOKING (bookingId, nic, trainId, time, departureStation, arrivalStation, class, seatNumber) VALUES
(1, '200086202642', 1, '2024-03-24 07:30:00', 1, 3, 'First Class', 25),
(2, '200083452642', 3, '2024-03-24 10:30:00', 1, 4, 'Economy Class', 42);

INSERT INTO PAYMENT (payId, bookingId, amount, date) VALUES
(1, 1, 130.00, '2024-03-23 08:00:00'),
(2, 2, 220.00, '2024-03-20 11:00:00');

-- Delete a train ID

DELETE FROM TRAIN
	WHERE trainId = 3;





