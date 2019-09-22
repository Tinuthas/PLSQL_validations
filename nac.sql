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
INSERT INTO DOCUMENTOS
VALUES
(12356621363,120300013,34534555000155,435687090612);
commit;

SELECT CPF,
 RG,
 CNPJ,
 TITULO
FROM DOCUMENTOS;



SET SERVEROUTPUT ON


create or replace function VERIFICA_CPF(cpf documentos.cpf%type)
RETURN VARCHAR2 IS
    v_text VARCHAR2(255) := 'CPF VÁLIDO';
    TYPE v_array_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
BEGIN 
    IF (LENGTH(cpf) != 11) THEN
        v_text := 'CPF INVÁLIDO';
    ELSE
         FOR i In 0..11 LOOP
            v_array_dv(i -1) := TO_NUMBER(SUBSTR(cpf, i, 1));
        END LOOP;
        FOR i IN 0..8 LOOP
            IF (((i+1) * v_array_dv(i)) != 10) THEN 
                 v_sum := v_sum + ((i+1) * v_array_dv(i));
            END IF;
         END LOOP;
         IF(MOD(v_sum, 11) != v_array_dv(9)) THEN
             v_text := 'CPF INVÁLIDO';
         ELSE
            v_sum := 0;
             FOR i IN 0..9 LOOP
                IF ((i * v_array_dv(i)) != 10) THEN 
                     v_sum := v_sum + (i * v_array_dv(i));
                END IF;
            END LOOP;
            IF(MOD(v_sum, 11) != v_array_dv(10)) THEN
                v_text := 'CPF_INVÁLIDO';
             END IF;
         END IF; 
    END IF;
    RETURN v_text;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'OCORREU ALGUMA EXCEÇÃO';
    --MOD(v_sum_nine, 11)
    
END VERIFICA_CPF;
/

SELECT CPF,
 VERIFICA_CPF(CPF)
FROM DOCUMENTOS;



create or replace function VERIFICA_CNPJ(cnpj documentos.cnpj%type)
RETURN VARCHAR2 IS
    v_text VARCHAR2(255) := 'CNPJ VÁLIDO';
    TYPE v_array_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
    v_aux number := 0;
BEGIN 
    IF (LENGTH(cnpj) != 14) THEN
        v_text := 'CNPJ INVÁLIDO';
    ELSE
         FOR i In 0..14 LOOP
            v_array_dv(i -1) := TO_NUMBER(SUBSTR(cnpj, i, 1));
        END LOOP;
        v_aux := 6;
        FOR i IN 0..11 LOOP
            IF(v_aux = 10) THEN
                v_aux := 2;
            END IF;
            IF ((v_aux * v_array_dv(i)) != 10) THEN 
                 v_sum := v_sum + (v_aux * v_array_dv(i));
            END IF;
            v_aux := v_aux+ 1;
         END LOOP;
         IF(MOD(v_sum, 11) != v_array_dv(12)) THEN
             v_text := 'CNPJ INVÁLIDO';
         ELSE
            v_sum := 0;
            v_aux := 5;
             FOR i IN 0..12 LOOP
                IF(v_aux = 10) THEN
                    v_aux := 2;
                END IF;
                IF ((v_aux * v_array_dv(i)) != 10) THEN 
                     v_sum := v_sum + (v_aux * v_array_dv(i));
                END IF;
                v_aux := v_aux+ 1;
            END LOOP;
            IF(MOD(v_sum, 11) != v_array_dv(13)) THEN
                v_text := 'CNPJ_INVÁLIDO';           
             END IF;
         END IF; 
    END IF;
    RETURN v_text;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'OCORREU ALGUMA EXCEÇÃO';
    --MOD(v_sum_nine, 11)
    
END VERIFICA_CNPJ;
/


SELECT CNPJ,
 VERIFICA_CNPJ(CNPJ)
FROM DOCUMENTOS;

