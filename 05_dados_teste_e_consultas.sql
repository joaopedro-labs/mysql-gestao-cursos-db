-- ============================================================================
-- Arquivo: 05_dados_teste_e_consultas.sql
-- Descrição: Carga inicial de dados (DML) e execução de testes das Procedures,
--            Triggers e Views.
-- ============================================================================

USE tecnocapacita_db;

-- 1. Inserindo Instrutores
INSERT INTO instrutores (nome, email, especialidade, biografia) VALUES
('João Pedro Araujo', 'joaopedroaraujo953@gmail.com', 'Full-Stack, Python & IA', 'Desenvolvedor Full-Stack Jr. com foco em automação e bancos de dados.'),
('Ana Beatriz Costa', 'ana.costa@tecnocapacita.com.br', 'Engenharia de Dados & SQL', 'Especialista em modelagem relacional e performance em MySQL.');

-- 2. Inserindo Cursos
INSERT INTO cursos (id_instrutor, titulo, categoria, carga_horaria, valor) VALUES
(1, 'Automação de Processos com Python e IA', 'IA & Automação', 40, 199.90),
(2, 'Modelagem Relacional Avançada com MySQL', 'Banco de Dados', 36, 249.00),
(1, 'Desenvolvimento Web Responsivo Full-Stack', 'Front-End & Mobile', 60, 299.00);

-- 3. Inserindo Alunos
INSERT INTO alunos (nome, email, cpf) VALUES
('Lucas Ferreira', 'lucas.ferreira@email.com', '12345678901'),
('Mariana Santos', 'mariana.santos@email.com', '98765432100'),
('Rafael Oliveira', 'rafael.oliveira@email.com', '45678912399');

-- 4. Realizando Matrículas via Stored Procedure (aciona Trigger de contagem + log)
CALL sp_realizar_matricula(1, 1, 10.00); -- Lucas no curso de Python com 10% de desconto
CALL sp_realizar_matricula(2, 1, 0.00);  -- Mariana no curso de Python (valor integral)
CALL sp_realizar_matricula(3, 2, 15.00); -- Rafael no curso de MySQL com 15% de desconto

-- 5. Atualizando Progresso (ao atingir 100%, a Trigger gera o código do certificado automaticamente)
CALL sp_atualizar_progresso(1, 100.00);
CALL sp_atualizar_progresso(2, 65.00);
CALL sp_atualizar_progresso(3, 100.00);

-- 6. Consultando as Views e a Tabela de Auditoria
SELECT * FROM vw_desempenho_cursos;
SELECT * FROM vw_painel_alunos;
SELECT * FROM logs_auditoria ORDER BY data_evento DESC;
