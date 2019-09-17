drop table documentos;

CREATE TABLE DOCUMENTOS
(CPF NUMBER(11),
RG NUMBER(9),
CNPJ NUMBER(14),
TITULO NUMBER(12));
INSERT INTO DOCUMENTOS
VALUES
(12356621369,120300013,34534555000155,435687090612);
INSERT INTO DOCUMENTOS
VALUES
(12356621375,120300028,34534555000135,342534212712);
INSERT INTO DOCUMENTOS
VALUES
(43643565224,456324574,49692306000145,4356870943);
INSERT INTO DOCUMENTOS
VALUES
(95643234701,345323567,43353453000186,3425342133);
commit;

SELECT CPF,
 RG,
 CNPJ,
 TITULO
FROM DOCUMENTOS;



SET SERVEROUTPUT ON

create or replace function VERIFICA_CPF(cpf documentos.cpf%type)
RETURN VARCHAR2 AS
    TYPE v_array_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
BEGIN 
    IF (LENGTH(cpf) != 11) THEN
        RETURN 'CPF INVÁLIDO';
    END IF;
    FOR i In 0..10 LOOP
        v_array_dv(i -1) := TO_NUMBER(SUBSTR(cpf, i, 1));
    END LOOP;
    FOR i IN 0..9 LOOP
    --((i+1) * v_array_dv(i))
        v_sum := v_sum + ((i+1) *v_array_dv(i));
        IF (i = 8 ) THEN
            IF(MOD(v_sum, 11) != v_array_dv(9)) THEN
                RETURN 'CPF INVÁLIDO';
            END IF;
        ELSIF (i = 9) THEN
            IF(MOD(v_sum, 11) != v_array_dv(10)) THEN
                RETURN 'CPF SINVÁLIDO';
            END IF;
        END IF;
    END LOOP;

    RETURN 'CPF ';
    
    --MOD(v_sum_nine, 11)
    
END VERIFICA_CPF;
/

SELECT CPF,
 VERIFICA_CPF(CPF)
FROM DOCUMENTOS;