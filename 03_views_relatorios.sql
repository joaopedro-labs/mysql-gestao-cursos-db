-- ============================================================================
-- Arquivo: 03_views_relatorios.sql
-- Descrição: Views analíticas para relatórios gerenciais e acompanhamento de alunos.
-- ============================================================================

USE tecnocapacita_db;

-- View 1: Relatório de Desempenho e Faturamento por Curso
CREATE OR REPLACE VIEW vw_desempenho_cursos AS
SELECT
    c.id_curso,
    c.titulo AS curso,
    c.categoria,
    i.nome AS instrutor,
    c.carga_horaria,
    c.total_matriculados,
    COUNT(m.id_matricula) AS matriculas_registradas,
    SUM(CASE WHEN m.status_matricula = 'Concluido' THEN 1 ELSE 0 END) AS total_concluintes,
    ROUND(COALESCE(AVG(m.progresso_percentual), 0), 2) AS media_progresso_pct,
    COALESCE(SUM(m.valor_pago), 0.00) AS receita_total_brl
FROM cursos c
INNER JOIN instrutores i ON i.id_instrutor = c.id_instrutor
LEFT JOIN matriculas m ON m.id_curso = c.id_curso AND m.status_matricula <> 'Cancelado'
GROUP BY c.id_curso, c.titulo, c.categoria, i.nome, c.carga_horaria, c.total_matriculados;

-- View 2: Painel de Progresso e Certificados dos Alunos
CREATE OR REPLACE VIEW vw_painel_alunos AS
SELECT
    a.id_aluno,
    a.nome AS aluno,
    a.email,
    c.titulo AS curso,
    c.categoria,
    m.progresso_percentual,
    m.status_matricula,
    m.codigo_certificado,
    m.data_matricula
FROM matriculas m
INNER JOIN alunos a ON a.id_aluno = m.id_aluno
INNER JOIN cursos c ON c.id_curso = m.id_curso;
