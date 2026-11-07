USE tecnocapacita_db;

DELIMITER $$

-- Procedure 1: Realiza matrícula validando status do curso e aplicando cupom de desconto (%)
CREATE PROCEDURE sp_realizar_matricula(
    IN p_id_aluno INT,
    IN p_id_curso INT,
    IN p_desconto_pct DECIMAL(5,2)
)
BEGIN
    DECLARE v_valor_base DECIMAL(10,2);
    DECLARE v_ativo BOOLEAN;
    DECLARE v_valor_final DECIMAL(10,2);

    SELECT valor, ativo
      INTO v_valor_base, v_ativo
      FROM cursos
     WHERE id_curso = p_id_curso;

    IF v_ativo IS NULL OR v_ativo = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: Curso inexistente ou inativo para novas matrículas.';
    END IF;

    SET v_valor_final = v_valor_base * (1 - (COALESCE(p_desconto_pct, 0) / 100));

    INSERT INTO matriculas (id_aluno, id_curso, valor_pago)
    VALUES (p_id_aluno, p_id_curso, ROUND(v_valor_final, 2));
END$$

-- Procedure 2: Atualiza o percentual de progresso do aluno no curso
CREATE PROCEDURE sp_atualizar_progresso(
    IN p_id_matricula INT,
    IN p_novo_progresso DECIMAL(5,2)
)
BEGIN
    IF p_novo_progresso < 0 OR p_novo_progresso > 100 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: O progresso deve estar entre 0 e 100%.';
    END IF;

    UPDATE matriculas
       SET progresso_percentual = p_novo_progresso
     WHERE id_matricula = p_id_matricula;
END$$

DELIMITER ;
