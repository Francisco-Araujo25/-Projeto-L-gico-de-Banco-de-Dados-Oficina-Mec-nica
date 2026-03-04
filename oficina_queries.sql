-- ============================================================
-- QUERIES - OFICINA MECÂNICA
-- ============================================================

USE oficina_mecanica;

-- ============================================================
-- 1. SELECT SIMPLES
-- ============================================================

-- Q1: Quais são todos os clientes cadastrados?
SELECT idCustomer, CPF, Contact, Address
FROM Customer;

-- Q2: Quais serviços foram registrados e seus valores?
SELECT idService, Service_Type, Deadline, Value
FROM Service
ORDER BY Value DESC;

-- Q3: Quais veículos estão cadastrados na oficina?
SELECT License_plate, Model, Year, Vehicle_condition
FROM Vehicle_OS
ORDER BY Year DESC;


-- ============================================================
-- 2. WHERE – Filtros
-- ============================================================

-- Q4: Quais serviços ainda não têm prazo definido (em aberto)?
SELECT s.idService, s.Service_Type, s.Value, o.Description AS ordemServico
FROM Service s
JOIN OS o ON o.idOS = s.OS_idOS
WHERE s.Deadline IS NULL;

-- Q5: Quais veículos estão em condição "Ruim" ou "Regular"?
SELECT v.License_plate, v.Model, v.Year, v.Vehicle_condition, c.CPF
FROM Vehicle_OS v
JOIN Customer c ON c.idCustomer = v.Customer_idCustomer
WHERE v.Vehicle_condition IN ('Ruim', 'Regular')
ORDER BY v.Vehicle_condition;

-- Q6: Quais pagamentos foram feitos via PIX ou Boleto?
SELECT p.idPayment, p.Pay_method, p.OS_idOS, c.CPF
FROM Payment p
JOIN Customer c ON c.idCustomer = p.Service_Customer_idCustomer
WHERE p.Pay_method IN ('PIX', 'Boleto');

-- Q7: Quais serviços são do tipo "Reparo" com valor acima de R$ 500?
SELECT idService, Service_Type, Value, Deadline
FROM Service
WHERE Service_Type = 'Reparo' AND Value > 500
ORDER BY Value DESC;


-- ============================================================
-- 3. ATRIBUTOS DERIVADOS
-- ============================================================

-- Q8: Quantos dias faltam (ou faltavam) para o prazo de cada serviço?
SELECT
    idService,
    Service_Type,
    Deadline,
    Value,
    DATEDIFF(Deadline, CURDATE()) AS diasParaPrazo   -- atributo derivado
FROM Service
WHERE Deadline IS NOT NULL
ORDER BY diasParaPrazo;

-- Q9: Qual o valor total de serviços por tipo, e a média por serviço?
SELECT
    Service_Type,
    COUNT(*)              AS qtdServicos,
    SUM(Value)            AS totalFaturado,        -- atributo derivado
    ROUND(AVG(Value), 2)  AS ticketMedio           -- atributo derivado
FROM Service
GROUP BY Service_Type
ORDER BY totalFaturado DESC;

-- Q10: Qual o valor total pago por cada cliente (via tabela Payment + Service)?
SELECT
    c.idCustomer,
    c.CPF,
    COUNT(p.idPayment)   AS qtdPagamentos,
    SUM(s.Value)         AS totalGasto            -- atributo derivado
FROM Customer c
JOIN Payment p  ON p.Service_Customer_idCustomer = c.idCustomer
JOIN Service s  ON s.idService = p.Service_idService
GROUP BY c.idCustomer, c.CPF
ORDER BY totalGasto DESC;


-- ============================================================
-- 4. ORDER BY – Ordenações
-- ============================================================

-- Q11: Ranking de serviços do mais caro ao mais barato
SELECT Service_Type, Value, Deadline
FROM Service
ORDER BY Value DESC;

-- Q12: Veículos ordenados do mais antigo ao mais novo
SELECT Model, License_plate, Year, Vehicle_condition
FROM Vehicle_OS
ORDER BY Year ASC;

-- Q13: Clientes ordenados pelo número de veículos cadastrados
SELECT
    c.idCustomer,
    c.CPF,
    COUNT(v.idVehicle_OS) AS qtdVeiculos
FROM Customer c
LEFT JOIN Vehicle_OS v ON v.Customer_idCustomer = c.idCustomer
GROUP BY c.idCustomer, c.CPF
ORDER BY qtdVeiculos DESC;


-- ============================================================
-- 5. HAVING – Filtro sobre grupos
-- ============================================================

-- Q14: Quais clientes têm mais de 1 serviço registrado?
SELECT
    c.CPF,
    COUNT(s.idService) AS totalServicos
FROM Customer c
JOIN Service s ON s.Customer_idCustomer = c.idCustomer
GROUP BY c.idCustomer, c.CPF
HAVING COUNT(s.idService) > 1
ORDER BY totalServicos DESC;

-- Q15: Quais tipos de serviço geraram mais de R$ 500 no total?
SELECT
    Service_Type,
    SUM(Value) AS totalFaturado
FROM Service
GROUP BY Service_Type
HAVING SUM(Value) > 500
ORDER BY totalFaturado DESC;

-- Q16: Quais especialidades de equipe atenderam mais de 1 serviço?
SELECT
    Mec_speciality,
    COUNT(*) AS totalAtendimentos
FROM Mechannic_team
GROUP BY Mec_speciality
HAVING COUNT(*) > 1
ORDER BY totalAtendimentos DESC;


-- ============================================================
-- 6. JOINS – Perspectivas combinadas
-- ============================================================

-- Q17: Visão completa: cliente → veículo → OS → serviço → equipe
SELECT
    c.CPF                       AS cliente,
    v.Model                     AS veiculo,
    v.License_plate             AS placa,
    v.Vehicle_condition         AS condicao,
    o.Description               AS ordemServico,
    s.Service_Type              AS tipoServico,
    s.Value                     AS valorServico,
    s.Deadline                  AS prazo,
    mt.Mec_speciality           AS equipe
FROM Customer c
JOIN Vehicle_OS v       ON v.Customer_idCustomer = c.idCustomer
JOIN Service s          ON s.Customer_idCustomer = c.idCustomer
JOIN OS o               ON o.idOS = s.OS_idOS
LEFT JOIN Mechannic_team mt ON mt.Service_idService = s.idService
ORDER BY c.idCustomer, s.idService;

-- Q18: Histórico de pagamentos com detalhes do serviço e OS
SELECT
    p.idPayment,
    p.Pay_method,
    c.CPF               AS cliente,
    o.Description       AS ordemServico,
    s.Service_Type,
    s.Value             AS valorServico
FROM Payment p
JOIN Customer c ON c.idCustomer = p.Service_Customer_idCustomer
JOIN OS o       ON o.idOS       = p.OS_idOS
JOIN Service s  ON s.idService  = p.Service_idService
ORDER BY p.idPayment;

-- Q19: Serviços SEM pagamento registrado (OS pendentes de quitação)
SELECT
    s.idService,
    s.Service_Type,
    s.Value,
    s.Deadline,
    c.CPF AS cliente
FROM Service s
JOIN Customer c ON c.idCustomer = s.Customer_idCustomer
LEFT JOIN Payment p ON p.Service_idService = s.idService
WHERE p.idPayment IS NULL
ORDER BY s.Value DESC;

-- Q20: Faturamento por método de pagamento
SELECT
    p.Pay_method,
    COUNT(p.idPayment)  AS qtdTransacoes,
    SUM(s.Value)        AS totalArrecadado
FROM Payment p
JOIN Service s ON s.idService = p.Service_idService
GROUP BY p.Pay_method
HAVING SUM(s.Value) > 0
ORDER BY totalArrecadado DESC;