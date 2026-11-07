-- ============================================================================
-- Projeto: Banco de Dados Relacional - Plataforma de Cursos (TecnoCapacita DB)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS tecnocapacita_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tecnocapacita_db;

-- 1. Tabela de Instrutores
CREATE TABLE IF NOT EXISTS instrutores (
    id_instrutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    especialidade VARCHAR(100) NOT NULL,
    biografia TEXT,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Tabela de Cursos
CREATE TABLE IF NOT EXISTS cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_instrutor INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    categoria ENUM('Programação', 'Banco de Dados', 'IA & Automação', 'Front-End & Mobile') NOT NULL,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0),
    valor DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (valor >= 0),
    total_matriculados INT NOT NULL DEFAULT 0,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cursos_instrutor
        FOREIGN KEY (id_instrutor) REFERENCES instrutores(id_instrutor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_cursos_categoria (categoria)
) ENGINE=InnoDB;

-- 3. Tabela de Alunos
CREATE TABLE IF NOT EXISTS alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    status_conta ENUM('Ativo', 'Inativo', 'Bloqueado') NOT NULL DEFAULT 'Ativo',
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Tabela de Matrículas (Relacionamento N:N entre Alunos e Cursos)
CREATE TABLE IF NOT EXISTS matriculas (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_curso INT NOT NULL,
    data_matricula DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    progresso_percentual DECIMAL(5, 2) NOT NULL DEFAULT 0.00
        CHECK (progresso_percentual >= 0 AND progresso_percentual <= 100),
    status_matricula ENUM('Em Andamento', 'Concluido', 'Cancelado') NOT NULL DEFAULT 'Em Andamento',
    valor_pago DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    codigo_certificado VARCHAR(40) UNIQUE NULL,
    CONSTRAINT uq_aluno_curso UNIQUE (id_aluno, id_curso),
    CONSTRAINT fk_matriculas_aluno
        FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_matriculas_curso
        FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Tabela de Auditoria (alimentada automaticamente via Triggers)
CREATE TABLE IF NOT EXISTS logs_auditoria (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    tabela_afetada VARCHAR(60) NOT NULL,
    acao VARCHAR(30) NOT NULL,
    id_registro INT NOT NULL,
    detalhes VARCHAR(255) NOT NULL,
    data_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
