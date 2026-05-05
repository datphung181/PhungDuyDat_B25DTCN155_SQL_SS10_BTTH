CREATE DATABASE BTTH;
USE BTTH;

CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(10),
    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

INSERT INTO Patients (Patient_ID, Full_Name)
VALUES
('BN001', 'Nguyen Van A'),
('BN002', 'Tran Thi B'),
('BN003', 'Le Van C'),
('BN004', 'Pham Thi D');


INSERT INTO Vitals_Logs (Patient_ID, Heart_Rate, Blood_Pressure, Record_Time)
VALUES
('BN001', 80, '120/80', '2026-05-05 08:00:00'),
('BN001', 130, '140/90', '2026-05-05 09:00:00'),
('BN002', 70, '110/70', '2026-05-05 08:30:00'),
('BN003', 45, '100/60', '2026-05-05 07:50:00');
-- BN004 không có dữ liệu để test Pending

CREATE INDEX idx_patient_time
ON Vitals_Logs (Patient_ID, Record_Time DESC);

CREATE VIEW ER_Dashboard_View AS 
	SELECT p.Patient_ID, p.Full_Name, IFNULL(v.Heart_Rate, 'Pending') AS Heart_Rate, v.Blood_Pressure, v.Record_Time,
        CASE 
			WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
			WHEN v.Heart_Rate IS NULL THEN 'Pending'
			ELSE 'STABLE'
		END AS Urgency_Level
	FROM Patients p
	LEFT JOIN Vitals_Logs v 
		ON p.Patient_ID = v.Patient_ID
		AND v.Record_Time = (
			SELECT MAX(v2.Record_Time)
			FROM Vitals_Logs v2
			WHERE v2.Patient_ID = p.Patient_ID
		);
        
UPDATE ER_Dashboard_View
SET Heart_Rate = 90
WHERE Patient_ID = 'BN001';

    