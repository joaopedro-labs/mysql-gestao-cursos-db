USE tecnocapacita_db;

DELIMITER $$

-- Trigger 1: Após nova matrícula, incrementa contador no curso e grava auditoria
CREATE TRIGGER trg_after_insert_matricula
AFTER INSERT ON matriculas
FOR EACH ROW
BEGIN
    UPDATE cursos
       SET total_matriculados = total_matriculados + 1
     WHERE id_curso = NEW.id_curso;

    INSERT INTO logs_auditoria (tabela_afetada, acao, id_registro, detalhes)
    VALUES (
        'matriculas',
        'INSERT',
        NEW.id_matricula,
        CONCAT('Aluno ID ', NEW.id_aluno, ' matriculado no Curso ID ', NEW.id_curso)
    );
END$$

-- Trigger 2: Antes de atualizar matrícula, se progresso chegar a 100%, conclui e gera certificado
CREATE TRIGGER trg_before_update_progresso
BEFORE UPDATE ON matriculas
FOR EACH ROW
BEGIN
    IF NEW.progresso_percentual = 100.00 AND OLD.progresso_percentual < 100.00 THEN
        SET NEW.status_matricula = 'Concluido';
        IF NEW.codigo_certificado IS NULL THEN
            SET NEW.codigo_certificado = CONCAT('TC-', NEW.id_curso, '-', NEW.id_aluno, '-', DATE_FORMAT(NOW(), '%Y%m%d'));
        END IF;
    END IF;
END$$

-- Trigger 3: Registra auditoria sempre que o preço de um curso for alterado
CREATE TRIGGER trg_after_update_preco_curso
AFTER UPDATE ON cursos
FOR EACH ROW
BEGIN
    IF OLD.valor <> NEW.valor THEN
        INSERT INTO logs_auditoria (tabela_afetada, acao, id_registro, detalhes)
        VALUES (
            'cursos',
            'UPDATE_VALOR',
            NEW.id_curso,
            CONCAT('Valor alterado de R$ ', OLD.valor, ' para R$ ', NEW.valor)
        );
    END IF;
END$$

DELIMITER ;
