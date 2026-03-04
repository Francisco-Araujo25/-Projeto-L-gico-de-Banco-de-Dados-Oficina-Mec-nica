-- ============================================================
-- DADOS DE TESTE - OFICINA MECÂNICA
-- ============================================================

USE oficina_mecanica;

-- Clientes
INSERT INTO Customer (CPF, Contact, Address) VALUES
('11122233344', '(43)99101-2030', 'Rua das Flores, 10 - Londrina/PR'),
('22233344455', '(43)99202-3141', 'Av. Brasil, 250 - Londrina/PR'),
('33344455566', '(43)99303-4252', 'Rua Paraná, 88 - Cambé/PR'),
('44455566677', '(43)99404-5363', 'Rua Minas, 5 - Londrina/PR'),
('55566677788', '(43)99505-6474', 'Av. Higienópolis, 300 - Londrina/PR'),
('66677788899', '(43)99606-7585', 'Rua Bahia, 42 - Ibiporã/PR'),
('77788899900', '(43)99707-8696', 'Rua Ceará, 77 - Londrina/PR');

-- Veículos
INSERT INTO Vehicle_OS (Model, License_plate, Year, Vehicle_condition, Customer_idCustomer) VALUES
('Chevrolet Onix',    'ABC1D23', 2020, 'Bom',     1),
('Volkswagen Gol',    'DEF2E34', 2018, 'Regular', 2),
('Ford Ka',           'GHI3F45', 2019, 'Bom',     3),
('Hyundai HB20',      'JKL4G56', 2021, 'Ótimo',   4),
('Toyota Corolla',    'MNO5H67', 2022, 'Ótimo',   5),
('Honda Civic',       'PQR6I78', 2017, 'Regular', 6),
('Fiat Argo',         'STU7J89', 2020, 'Bom',     7),
('Chevrolet Cruze',   'VWX8K90', 2016, 'Ruim',    1);

-- Ordens de Serviço
INSERT INTO OS (Description) VALUES
('Manutenção preventiva'),
('Problema na suspensão'),
('Troca de óleo e revisão'),
('Freios com ruído'),
('Diagnóstico eletrônico'),
('Troca de embreagem'),
('Revisão geral 50.000km'),
('Veículo sem partida'),
('Troca de correia dentada'),
('Revisão solicitada e cancelada');

-- Serviços
INSERT INTO Service (Service_Type, Deadline, Value, Customer_idCustomer, OS_idOS) VALUES
('Revisão',   '2024-01-11', 620.00,  1, 1),
('Reparo',    '2024-01-17', 760.00,  2, 2),
('Revisão',   '2024-02-06', 260.00,  3, 3),
('Reparo',    '2024-02-22', 482.00,  4, 4),
('Elétrica',  '2024-03-09', 290.00,  5, 5),
('Reparo',    NULL,         1050.00, 6, 6),
('Revisão',   '2024-04-03', 1080.00, 7, 7),
('Elétrica',  NULL,         90.00,   1, 8),
('Reparo',    '2024-04-15', 605.00,  1, 9),
('Revisão',   NULL,         180.00,  3, 10);

-- Equipes de mecânicos
INSERT INTO Mechannic_team (Mec_speciality, Address, Service_idService, Service_Customer_idCustomer) VALUES
('Motor e Câmbio',       'Rua A, 1 - Londrina/PR', 1, 1),
('Suspensão e Freios',   'Rua B, 2 - Londrina/PR', 2, 2),
('Motor e Câmbio',       'Rua A, 1 - Londrina/PR', 3, 3),
('Suspensão e Freios',   'Rua B, 2 - Londrina/PR', 4, 4),
('Elétrica e Injeção',   'Rua C, 3 - Londrina/PR', 5, 5),
('Motor e Câmbio',       'Rua A, 1 - Londrina/PR', 6, 6),
('Motor e Câmbio',       'Rua A, 1 - Londrina/PR', 7, 7),
('Elétrica e Injeção',   'Rua C, 3 - Londrina/PR', 8, 1),
('Motor e Câmbio',       'Rua A, 1 - Londrina/PR', 9, 1),
('Suspensão e Freios',   'Rua B, 2 - Londrina/PR', 10, 3);

-- Pagamentos (apenas OS com deadline concluído)
INSERT INTO Payment (Pay_method, idCustomer, OS_idOS, Service_idService, Service_Customer_idCustomer) VALUES
('PIX',            1, 1, 1, 1),
('Cartão Crédito', 2, 2, 2, 2),
('Dinheiro',       3, 3, 3, 3),
('Cartão Débito',  4, 4, 4, 4),
('PIX',            5, 5, 5, 5),
('Boleto',         7, 7, 7, 7),
('Cartão Crédito', 1, 9, 9, 1);