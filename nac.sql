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
INSERT INTO DOCUMENTOS
VALUES
(43643565224,456324574,49692306000145,4356870906);

INSERT INTO DOCUMENTOS
VALUES
(43643565224,501071635,49692306000145,4356870906);

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
                 v_sum := v_sum + ((i+1) * v_array_dv(i));
         END LOOP;
         IF(MOD(v_sum, 11) = 10 and v_array_dv(9) = 0) THEN
                v_text := 'CPF VÁLIDO';
            ELSIF(MOD(v_sum, 11) != v_array_dv(9)) THEN
             v_text := 'CPF INVÁLIDO';
         ELSE
            v_sum := 0;
             FOR i IN 0..9 LOOP
                     v_sum := v_sum + (i * v_array_dv(i));
            END LOOP;
            IF(MOD(v_sum, 11) = 10 and v_array_dv(10) = 0) THEN
                v_text := 'CPF VÁLIDO';
            ELSIF(MOD(v_sum, 11) != v_array_dv(10)) THEN
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

EXECUTE DBMS_OUTPUT.PUT_LINE(VERIFICA_CPF(38229094837));


create or replace function VERIFICA_CNPJ(cnpj documentos.cnpj%type)
RETURN VARCHAR2 IS
    v_text VARCHAR2(255) := 'CNPJ VÁLIDO';
    TYPE v_array_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
    v_aux number :=0;
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
            v_sum := v_sum + (v_aux * v_array_dv(i));
            v_aux := v_aux+ 1;
         END LOOP;
          IF(MOD(v_sum, 11) = 10 and v_array_dv(12) = 0) THEN
                v_text := 'CNPJ VÁLIDO';
            ELSIF(MOD(v_sum, 11) != v_array_dv(12)) THEN
             v_text := 'CNPJ INVÁLIDO';
         ELSE
            v_sum := 0;
            v_aux := 5;
             FOR i IN 0..12 LOOP
                IF(v_aux = 10) THEN
                    v_aux := 2;
                END IF;
                     v_sum := v_sum + (v_aux * v_array_dv(i));
                v_aux := v_aux+ 1;
            END LOOP;
            IF(MOD(v_sum, 11) = 10 and v_array_dv(13) = 0) THEN
                v_text := 'CNPJ VÁLIDO';
            ELSIF(MOD(v_sum, 11) != v_array_dv(13)) THEN
                v_text := 'CNPJ_INVÁLIDO';           
             END IF;
         END IF; 
    END IF;
    RETURN v_text;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'OCORREU ALGUMA EXCEÇÃO';
    
END VERIFICA_CNPJ;
/


SELECT CNPJ,
 VERIFICA_CNPJ(CNPJ)
FROM DOCUMENTOS;

EXECUTE DBMS_OUTPUT.PUT_LINE(VERIFICA_CNPJ(11319526000155));



create or replace function VERIFICA_TITULO(titulo documentos.titulo%type)
RETURN VARCHAR2 IS
    v_text VARCHAR2(255) := 'TITULO VÁLIDO';
    TYPE v_array_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
    v_aux number :=0;
BEGIN 
    IF (LENGTH(titulo) != 12) THEN
        v_text := 'NÚMERO DE TITULO INVÁLIDO. O TÍTULO DEVE CONTER 12 DÍGITOS';
    ELSE
        FOR i In 0..12 LOOP
            v_array_dv(i -1) := TO_NUMBER(SUBSTR(titulo, i, 1));
        END LOOP;
        v_aux := 2;
        FOR i IN 0..7 LOOP
            IF(v_aux = 10) THEN
                 v_aux := 2;
            END IF;
            IF ((v_aux * v_array_dv(i)) != 10) THEN 
                 v_sum := v_sum + (v_aux * v_array_dv(i));
            END IF;
            v_aux := v_aux + 1;
         END LOOP;
         IF((MOD(v_sum, 11) = 10) and (v_array_dv(8) = 0)) THEN
            RETURN  'TITULO VÁLIDO';
         ELSIF MOD(v_sum, 11) != v_array_dv(10) THEN
            RETURN 'TITULO INVÁLIDO' || MOD(v_sum, 11);
         END IF;
            v_sum := 0;
            v_aux := 7;
             FOR i IN 8..10 LOOP
                v_sum := v_sum + (v_aux * v_array_dv(i));
                v_aux := v_aux + 1;
            END LOOP;
             IF((MOD(v_sum, 11) = 10) and (v_array_dv(11) = 0)) THEN
                RETURN  'TITULO VÁLIDO';
            ELSIF MOD(v_sum, 11) != v_array_dv(11) THEN
                RETURN 'TITULO INVÁLIDO' || MOD(v_sum, 11) || 'AQ';
         END IF;
         END IF; 
    
    RETURN v_text;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'OCORREU ALGUMA EXCEÇÃO';
    --MOD(v_sum_nine, 11)
    
END VERIFICA_TITULO;
/

SELECT TITULO,
 VERIFICA_TITULO(TITULO)
FROM DOCUMENTOS;

EXECUTE DBMS_OUTPUT.PUT_LINE(VERIFICA_TITULO(445179690141));

create or replace function VERIFICA_RG(p_rg varchar)
RETURN VARCHAR2 IS
    rg VARCHAR2(10) := p_rg;
    v_text VARCHAR2(255) := 'RG VÁLIDO';
    TYPE v_array_type IS TABLE OF char(1) INDEX BY PLS_INTEGER; 
    v_array_dv v_array_type;
    v_sum number :=0;
    v_aux number :=0;
BEGIN 

   
    IF (LENGTH(rg) != 9) THEN
        v_text := 'RG INVÁLIDO';
    ELSE
        FOR i In 0..9 LOOP
            v_array_dv(i -1) := SUBSTR(rg, i, 1);
        END LOOP;
   
        v_aux := 9;
        FOR i IN 0..7 LOOP
            IF(v_aux = 1) THEN
                 v_aux := 9;
            END IF;
           
           v_sum := v_sum + (v_aux * TO_NUMBER(v_array_dv(i)));
           
            v_aux := v_aux - 1;
         END LOOP;
         IF MOD(v_sum, 11) = 10 and v_array_dv(8) = 'x' THEN
            RETURN  'RG VÁLIDO';
         ELSIF MOD(v_sum, 11) != TO_NUMBER(v_array_dv(8)) THEN
            RETURN 'RG INVÁLIDO';
         END IF;
    END IF; 
    
    RETURN v_text;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'OCORREU ALGUMA EXCEÇÃO';
    
END VERIFICA_RG;
/

SELECT RG,
 VERIFICA_RG(RG)
FROM DOCUMENTOS;

EXECUTE DBMS_OUTPUT.PUT_LINE(VERIFICA_RG('27064152x'));

