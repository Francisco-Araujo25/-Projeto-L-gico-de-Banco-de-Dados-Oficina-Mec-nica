-- ============================================================
-- PROJETO LÓGICO DE BANCO DE DADOS - OFICINA MECÂNICA
-- Baseado no diagrama ER do autor
-- ============================================================

CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- ------------------------------------------------------------
-- Clientes
-- ------------------------------------------------------------
CREATE TABLE Customer (
    idCustomer  INT         AUTO_INCREMENT PRIMARY KEY,
    CPF         CHAR(11)    NOT NULL UNIQUE,
    Contact     VARCHAR(15),
    Address     VARCHAR(150)
);

-- ------------------------------------------------------------
-- Veículos (associados a um cliente)
-- ------------------------------------------------------------
CREATE TABLE Vehicle_OS (
    idVehicle_OS        INT          AUTO_INCREMENT PRIMARY KEY,
    Model               VARCHAR(80)  NOT NULL,
    License_plate       VARCHAR(25)  NOT NULL UNIQUE,
    Year                YEAR         NOT NULL,
    Vehicle_condition   VARCHAR(100),
    Customer_idCustomer INT          NOT NULL,
    CONSTRAINT fk_vehicle_customer
        FOREIGN KEY (Customer_idCustomer) REFERENCES Customer(idCustomer)
);

-- ------------------------------------------------------------
-- Ordens de Serviço
-- ------------------------------------------------------------
CREATE TABLE OS (
    idOS        INT          AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(100)
);

-- ------------------------------------------------------------
-- Serviços (vinculados a cliente e OS)
-- ------------------------------------------------------------
CREATE TABLE Service (
    idService           INT           AUTO_INCREMENT PRIMARY KEY,
    Service_Type        ENUM('Revisão','Reparo','Elétrica','Funilaria','Outro') NOT NULL,
    Deadline            DATE,
    Value               DECIMAL(10,2) NOT NULL,
    Customer_idCustomer INT           NOT NULL,
    OS_idOS             INT,
    CONSTRAINT fk_service_customer
        FOREIGN KEY (Customer_idCustomer) REFERENCES Customer(idCustomer),
    CONSTRAINT fk_service_os
        FOREIGN KEY (OS_idOS) REFERENCES OS(idOS)
);

-- ------------------------------------------------------------
-- Equipe de Mecânicos (vinculada a serviço e cliente)
-- ------------------------------------------------------------
CREATE TABLE Mechannic_team (
    idMechannic_team            INT         AUTO_INCREMENT PRIMARY KEY,
    Mec_speciality              VARCHAR(50),
    Address                     VARCHAR(45),
    Service_idService           INT         NOT NULL,
    Service_Customer_idCustomer INT         NOT NULL,
    CONSTRAINT fk_team_service
        FOREIGN KEY (Service_idService) REFERENCES Service(idService),
    CONSTRAINT fk_team_customer
        FOREIGN KEY (Service_Customer_idCustomer) REFERENCES Customer(idCustomer)
);

-- ------------------------------------------------------------
-- Pagamentos (vinculados a OS, serviço e cliente)
-- ------------------------------------------------------------
CREATE TABLE Payment (
    idPayment                   INT         AUTO_INCREMENT PRIMARY KEY,
    Pay_method                  ENUM('Dinheiro','Cartão Crédito','Cartão Débito','PIX','Boleto') NOT NULL,
    idCustomer                  INT,
    OS_idOS                     INT         NOT NULL,
    Service_idService           INT         NOT NULL,
    Service_Customer_idCustomer INT         NOT NULL,
    CONSTRAINT fk_payment_os
        FOREIGN KEY (OS_idOS) REFERENCES OS(idOS),
    CONSTRAINT fk_payment_service
        FOREIGN KEY (Service_idService) REFERENCES Service(idService),
    CONSTRAINT fk_payment_customer
        FOREIGN KEY (Service_Customer_idCustomer) REFERENCES Customer(idCustomer)
);