/******************************************************************************/
/****         Generated by IBExpert 2011.04.03 16/10/2013 20:16:56         ****/
/******************************************************************************/

SET SQL DIALECT 3;

SET NAMES NONE;

CREATE DATABASE 'localhost:C:\Personal\Workspaces\Financa\Financa\db\base.fdb'
USER 'SYSDBA' PASSWORD 'masterkey'
PAGE_SIZE 16384
DEFAULT CHARACTER SET NONE COLLATION NONE;



/******************************************************************************/
/****                               Domains                                ****/
/******************************************************************************/

CREATE DOMAIN CHAVE AS
INTEGER
NOT NULL;

CREATE DOMAIN CHAVE_NULL AS
INTEGER;

CREATE DOMAIN DATA AS
TIMESTAMP;

CREATE DOMAIN DECISAO AS
CHAR(1)
CHECK (UPPER(VALUE) IN ('S', 'N'));

CREATE DOMAIN DESCRICAO AS
VARCHAR(100);

CREATE DOMAIN ENDERECO AS
VARCHAR(100);

CREATE DOMAIN MOEDA AS
DOUBLE PRECISION
NOT NULL;

CREATE DOMAIN NOME AS
VARCHAR(100);

CREATE DOMAIN SITUACAO AS
CHAR(1)
NOT NULL
CHECK (UPPER(VALUE) IN ('A', 'C'));

CREATE DOMAIN SITUACAO_PARCELA AS
CHAR(1)
NOT NULL
CHECK (UPPER(VALUE) IN ('A', 'C', 'Q'));

CREATE DOMAIN TIPO_MOVIMENTO AS
INTEGER
NOT NULL
CHECK (UPPER(VALUE) IN (1, 2, 3, 4, 5, 6));

CREATE DOMAIN TIPO_PARCELA AS
INTEGER
NOT NULL
CHECK (UPPER(VALUE) IN (3, 4));



/******************************************************************************/
/****                              Generators                              ****/
/******************************************************************************/

CREATE GENERATOR CCUSTO_GEN;
SET GENERATOR CCUSTO_GEN TO 1;

CREATE GENERATOR CONTA_GEN;
SET GENERATOR CONTA_GEN TO 1;

CREATE GENERATOR DESPESA_FIXA_GEN;
SET GENERATOR DESPESA_FIXA_GEN TO 0;

CREATE GENERATOR MOVIMENTO_GEN;
SET GENERATOR MOVIMENTO_GEN TO 782;

CREATE GENERATOR PARCELA_GEN;
SET GENERATOR PARCELA_GEN TO 5;

CREATE GENERATOR USUARIO_GEN;
SET GENERATOR USUARIO_GEN TO 0;



SET TERM ^ ; 



/******************************************************************************/
/****                          Stored Procedures                           ****/
/******************************************************************************/

CREATE PROCEDURE SP_AJUSTA_QUITACAO (
    IDMOVIMENTO_QUITACAO_PARCELA INTEGER,
    IDCCUSTO_PARCELA INTEGER,
    IDCONTA_PARCELA INTEGER,
    TIPO_PARCELA_P INTEGER,
    DESCRICAO_PARCELA VARCHAR(100),
    DATA_QUITACAO_PARCELA TIMESTAMP,
    VALOR_PARCELA DOUBLE PRECISION,
    ST_PARCELA CHAR(1))
AS
BEGIN
  EXIT;
END^





CREATE PROCEDURE SP_AJUSTA_SALDO (
    STATE CHAR(1),
    IDCONTA_LANCAMENTO INTEGER,
    VALOR_LANCAMENTO DOUBLE PRECISION,
    VALOR_LANCAMENTO_ANTERIOR DOUBLE PRECISION,
    TIPO INTEGER)
AS
BEGIN
  EXIT;
END^





CREATE PROCEDURE SP_EXTRATO_CONTA (
    IDCONTA_EXTRATO INTEGER,
    IDCCUSTO_EXTRATO INTEGER,
    DATA_INICIO_EXTRATO TIMESTAMP,
    DATA_FIM_EXTRATO TIMESTAMP)
RETURNS (
    IDCONTA INTEGER,
    IDCCUSTO INTEGER,
    DESCRICAO VARCHAR(100),
    DATA_MOVIMENTO TIMESTAMP,
    TIPO_MOVIMENTO CHAR(1),
    VALOR DOUBLE PRECISION,
    SALDO_MOVIMENTO DOUBLE PRECISION)
AS
BEGIN
  SUSPEND;
END^






SET TERM ; ^



/******************************************************************************/
/****                                Tables                                ****/
/******************************************************************************/



CREATE TABLE CCUSTO (
    IDCCUSTO   CHAVE NOT NULL,
    DESCRICAO  DESCRICAO,
    ST         SITUACAO
);

CREATE TABLE CONTA (
    IDCONTA           CHAVE NOT NULL,
    DESCRICAO         DESCRICAO,
    TIPO              CHAR(1),
    AGENCIA           VARCHAR(30),
    DIGITO_AGENCIA    CHAR(1),
    CONTA             VARCHAR(30),
    DIGITO_CONTA      CHAR(1),
    ENDERECO_AGENCIA  ENDERECO,
    SALDO             MOEDA,
    ST                SITUACAO
);

CREATE TABLE DESPESA_FIXA (
    IDDESPESA_FIXA  CHAVE NOT NULL,
    DESCRICAO       DESCRICAO,
    VALOR           MOEDA,
    ST              SITUACAO
);

CREATE TABLE MOVIMENTO (
    IDMOVIMENTO      CHAVE NOT NULL,
    IDCCUSTO         CHAVE,
    IDCONTA          CHAVE,
    TIPO             TIPO_MOVIMENTO,
    DESCRICAO        DESCRICAO,
    DATA_LANCAMENTO  DATA,
    VALOR            MOEDA,
    PARCELADO        DECISAO,
    ST               SITUACAO
);

CREATE TABLE PARCELA (
    IDPARCELA             CHAVE NOT NULL,
    IDMOVIMENTO           CHAVE_NULL,
    IDCCUSTO              CHAVE,
    IDCONTA               CHAVE,
    IDMOVIMENTO_QUITACAO  CHAVE_NULL,
    TIPO                  TIPO_PARCELA NOT NULL,
    DESCRICAO             DESCRICAO,
    DATA_LANCAMENTO       DATA,
    DATA_VENCIMENTO       DATA,
    DATA_QUITACAO         DATA,
    VALOR                 MOEDA,
    NUMERO_PARCELA        INTEGER,
    TOTAL_PARCELA         INTEGER,
    ST                    SITUACAO_PARCELA
);

CREATE TABLE USUARIO (
    IDUSUARIO  CHAVE NOT NULL,
    NOME       NOME,
    LOGIN      VARCHAR(10),
    SENHA      VARCHAR(10),
    ST         SITUACAO
);



/******************************************************************************/
/****                                Views                                 ****/
/******************************************************************************/


/* View: V_SALDO_CONTA */
CREATE VIEW V_SALDO_CONTA(
    CODIGO,
    DESCRICAO,
    SALDO)
AS
SELECT CONTA.IDCONTA, CONTA.DESCRICAO, CONTA.SALDO
FROM CONTA
;




/******************************************************************************/
/****                             Primary Keys                             ****/
/******************************************************************************/

ALTER TABLE CCUSTO ADD CONSTRAINT PK_CCUSTO PRIMARY KEY (IDCCUSTO);
ALTER TABLE CONTA ADD CONSTRAINT PK_CONTA PRIMARY KEY (IDCONTA);
ALTER TABLE DESPESA_FIXA ADD CONSTRAINT PK_DESPESA_FIXA PRIMARY KEY (IDDESPESA_FIXA);
ALTER TABLE MOVIMENTO ADD CONSTRAINT PK_MOVIMENTO PRIMARY KEY (IDMOVIMENTO);
ALTER TABLE PARCELA ADD CONSTRAINT PK_PARCELA PRIMARY KEY (IDPARCELA);
ALTER TABLE USUARIO ADD CONSTRAINT PK_USUARIO PRIMARY KEY (IDUSUARIO);


/******************************************************************************/
/****                             Foreign Keys                             ****/
/******************************************************************************/

ALTER TABLE MOVIMENTO ADD CONSTRAINT FK_MOVIMENTO_CCUSTO FOREIGN KEY (IDCCUSTO) REFERENCES CCUSTO (IDCCUSTO);
ALTER TABLE MOVIMENTO ADD CONSTRAINT FK_MOVIMENTO_CONTA FOREIGN KEY (IDCONTA) REFERENCES CONTA (IDCONTA);
ALTER TABLE PARCELA ADD CONSTRAINT FK_PARCELA_CCUSTO FOREIGN KEY (IDCCUSTO) REFERENCES CCUSTO (IDCCUSTO);
ALTER TABLE PARCELA ADD CONSTRAINT FK_PARCELA_CONTA FOREIGN KEY (IDCONTA) REFERENCES CONTA (IDCONTA);
ALTER TABLE PARCELA ADD CONSTRAINT FK_PARCELA_MOVIMENTO FOREIGN KEY (IDMOVIMENTO) REFERENCES MOVIMENTO (IDMOVIMENTO);


/******************************************************************************/
/****                               Triggers                               ****/
/******************************************************************************/


SET TERM ^ ;



/******************************************************************************/
/****                         Triggers for tables                          ****/
/******************************************************************************/



/* Trigger: CCUSTO_BI_CHAVE */
CREATE TRIGGER CCUSTO_BI_CHAVE FOR CCUSTO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDCCUSTO IS NULL) THEN
    NEW.IDCCUSTO = GEN_ID(CCUSTO_GEN, 1);
END
^

/* Trigger: CCUSTO_BI_SITUACAO */
CREATE TRIGGER CCUSTO_BI_SITUACAO FOR CCUSTO
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

/* Trigger: CONTA_BI_CHAVE */
CREATE TRIGGER CONTA_BI_CHAVE FOR CONTA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDCONTA IS NULL) THEN
    NEW.IDCONTA = GEN_ID(CONTA_GEN, 1);
END
^

/* Trigger: CONTA_BI_SITUACAO */
CREATE TRIGGER CONTA_BI_SITUACAO FOR CONTA
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

/* Trigger: DESPESA_FIXA_BI_CHAVE */
CREATE TRIGGER DESPESA_FIXA_BI_CHAVE FOR DESPESA_FIXA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDDESPESA_FIXA IS NULL) THEN
    NEW.IDDESPESA_FIXA = GEN_ID(DESPESA_FIXA_GEN, 1);
END
^

/* Trigger: DESPESA_FIXA_BI_SITUACAO */
CREATE TRIGGER DESPESA_FIXA_BI_SITUACAO FOR DESPESA_FIXA
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

/* Trigger: MOVIMENTO_AIUD_SALDO */
CREATE TRIGGER MOVIMENTO_AIUD_SALDO FOR MOVIMENTO
ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0
AS
BEGIN
/*  MOVIMENTO.TIPO
    1 - CREDITO A VISTA
    2 - DEBITO A VISTA
    (3 - CREDITO A PRAZO)
    (4 - DEBITO A PRAZO)
    5 - QUITACAO DE CREDITO
    6 - QUITACAO DE DEBITO
*/

    IF ( (NEW.TIPO IN (1, 2, 5, 6)) OR (OLD.TIPO IN (1, 2, 5, 6)) ) THEN
    BEGIN
        IF (INSERTING) THEN -- INSERINDO REGISTRO SALDO
        BEGIN
            EXECUTE PROCEDURE SP_AJUSTA_SALDO('I', NEW.IDCONTA, NEW.VALOR, 0, NEW.TIPO);
        END
        ELSE IF (UPDATING) THEN -- ATUALIZANDO REGISTRO SALDO
        BEGIN
            IF ( (OLD.ST = 'A') AND (NEW.ST = 'C') ) THEN -- CANCELOU REGISTRO DE MOVIMENTO
            BEGIN
                EXECUTE PROCEDURE SP_AJUSTA_SALDO('D', NEW.IDCONTA, NEW.VALOR, 0, NEW.TIPO);
            END
            ELSE IF ( (OLD.ST = 'C') AND (NEW.ST = 'A') ) THEN -- ATIVOU REGISTRO DE MOVIMENTO
            BEGIN
                EXECUTE PROCEDURE SP_AJUSTA_SALDO('I', NEW.IDCONTA, NEW.VALOR, 0, NEW.TIPO);
            END
            ELSE IF ( (OLD.IDCONTA <> NEW.IDCONTA) OR (OLD.TIPO <> NEW.TIPO)  ) THEN -- ALTEROU CONTA OU TIPO MOVIMENTO
            BEGIN
                EXECUTE PROCEDURE SP_AJUSTA_SALDO('D', OLD.IDCONTA, OLD.VALOR, 0, OLD.TIPO);
                EXECUTE PROCEDURE SP_AJUSTA_SALDO('I', NEW.IDCONTA, NEW.VALOR, 0, NEW.TIPO);
            END
            ELSE IF (OLD.VALOR <> NEW.VALOR) THEN -- ALTEROU VALOR
            BEGIN
                EXECUTE PROCEDURE SP_AJUSTA_SALDO('U', NEW.IDCONTA, NEW.VALOR, OLD.VALOR, NEW.TIPO);
            END
        END
        ELSE IF ( (DELETING) AND (OLD.ST <> 'C') ) THEN -- DELETANDO REGISTRO SALDO NAO CANCELADO
        BEGIN
            EXECUTE PROCEDURE SP_AJUSTA_SALDO('D', OLD.IDCONTA, OLD.VALOR, 0, OLD.TIPO);
        END
    END
END
^

/* Trigger: MOVIMENTO_BI_CHAVE */
CREATE TRIGGER MOVIMENTO_BI_CHAVE FOR MOVIMENTO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDMOVIMENTO IS NULL) THEN
    NEW.IDMOVIMENTO = GEN_ID(MOVIMENTO_GEN, 1);
END
^

/* Trigger: MOVIMENTO_BI_SITUACAO */
CREATE TRIGGER MOVIMENTO_BI_SITUACAO FOR MOVIMENTO
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

/* Trigger: PARCELA_AUD_PARCELA */
CREATE TRIGGER PARCELA_AUD_PARCELA FOR PARCELA
ACTIVE BEFORE UPDATE OR DELETE POSITION 0
AS
DECLARE VARIABLE NOVO_IDMOVIMENTO_QUITACAO INTEGER;
BEGIN
    IF (NEW.ST = 'Q') THEN -- QUITACAO DE PARCELA
    BEGIN
        -- BUSCA NOVO IDMOVIMENTO PELO MOVIMENTO_GEN
        NOVO_IDMOVIMENTO_QUITACAO = GEN_ID(MOVIMENTO_GEN, 1);

        EXECUTE PROCEDURE SP_AJUSTA_QUITACAO(:NOVO_IDMOVIMENTO_QUITACAO, NEW.IDCCUSTO, NEW.IDCONTA, NEW.TIPO, NEW.DESCRICAO, NEW.DATA_QUITACAO, NEW.VALOR, 'Q');

        -- SETA IDMOVIMENTO_QUITACAO
        NEW.IDMOVIMENTO_QUITACAO = :NOVO_IDMOVIMENTO_QUITACAO;
    END
    ELSE IF ( ((DELETING) OR (NEW.ST = 'C')) AND (OLD.ST = 'Q') ) THEN -- CANCELOU\DELETOU QUITACAO DE PARCELA
    BEGIN
        EXECUTE PROCEDURE SP_AJUSTA_QUITACAO(OLD.IDMOVIMENTO_QUITACAO, OLD.IDCCUSTO, OLD.IDCONTA, OLD.TIPO, OLD.DESCRICAO, OLD.DATA_QUITACAO, OLD.VALOR, 'C');
    END
    ELSE IF ((NEW.ST = 'A') AND (OLD.ST = 'C') ) THEN -- ZERA IDMOVIMENTO_QUITACAO PARA UMA NOVA QUITACAO
    BEGIN
        NEW.IDMOVIMENTO_QUITACAO = NULL;
    END
END
^

/* Trigger: PARCELA_BI_CHAVE */
CREATE TRIGGER PARCELA_BI_CHAVE FOR PARCELA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDPARCELA IS NULL) THEN
    NEW.IDPARCELA = GEN_ID(PARCELA_GEN, 1);
END
^

/* Trigger: PARCELA_BI_SITUACAO */
CREATE TRIGGER PARCELA_BI_SITUACAO FOR PARCELA
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

/* Trigger: USUARIO_BI_CHAVE */
CREATE TRIGGER USUARIO_BI_CHAVE FOR USUARIO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.IDUSUARIO IS NULL) THEN
    NEW.IDUSUARIO = GEN_ID(USUARIO_GEN, 1);
END
^

/* Trigger: USUARIO_BI_SITUACAO */
CREATE TRIGGER USUARIO_BI_SITUACAO FOR USUARIO
ACTIVE BEFORE INSERT POSITION 1
AS
BEGIN
  IF (NEW.ST IS NULL) THEN
  BEGIN
    NEW.ST = 'A';
  END
END
^

SET TERM ; ^



/******************************************************************************/
/****                          Stored Procedures                           ****/
/******************************************************************************/


SET TERM ^ ;

ALTER PROCEDURE SP_AJUSTA_QUITACAO (
    IDMOVIMENTO_QUITACAO_PARCELA INTEGER,
    IDCCUSTO_PARCELA INTEGER,
    IDCONTA_PARCELA INTEGER,
    TIPO_PARCELA_P INTEGER,
    DESCRICAO_PARCELA VARCHAR(100),
    DATA_QUITACAO_PARCELA TIMESTAMP,
    VALOR_PARCELA DOUBLE PRECISION,
    ST_PARCELA CHAR(1))
AS
DECLARE VARIABLE NOVO_TIPO_MOVIMENTO INTEGER;
DECLARE VARIABLE NOVO_DESCRICAO VARCHAR(110);
BEGIN
/*  MOVIMENTO.TIPO
    1 - CREDITO A VISTA
    2 - DEBITO A VISTA
    (3 - CREDITO A PRAZO)
    (4 - DEBITO A PRAZO)
    5 - QUITACAO DE CREDITO
    6 - QUITACAO DE DEBITO
*/
    
    IF (ST_PARCELA = 'Q') THEN -- INSERE QUITACAO
    BEGIN
        IF (TIPO_PARCELA_P = 3) THEN -- CREDITO A PRAZO
        BEGIN
            NOVO_TIPO_MOVIMENTO = 1; -- CREDITO A VISTA
            NOVO_DESCRICAO = 'QC - ' || :DESCRICAO_PARCELA;
        END
        ELSE IF (TIPO_PARCELA_P = 4) THEN -- DEBITO A PRAZO
        BEGIN
            NOVO_TIPO_MOVIMENTO = 2; -- DEBITO A VISTA
            NOVO_DESCRICAO = 'QD - ' || :DESCRICAO_PARCELA;
        END
        
        -- INSERE QUITACAO
        INSERT INTO MOVIMENTO (MOVIMENTO.IDMOVIMENTO, MOVIMENTO.IDCCUSTO, MOVIMENTO.IDCONTA, MOVIMENTO.TIPO, MOVIMENTO.DESCRICAO, MOVIMENTO.DATA_LANCAMENTO, MOVIMENTO.VALOR)
                       VALUES (:IDMOVIMENTO_QUITACAO_PARCELA, :IDCCUSTO_PARCELA, :IDCONTA_PARCELA, :NOVO_TIPO_MOVIMENTO, :NOVO_DESCRICAO, :DATA_QUITACAO_PARCELA, :VALOR_PARCELA);
    END
    ELSE IF (ST_PARCELA = 'C') THEN -- CANCELA QUITACAO
    BEGIN
        UPDATE MOVIMENTO SET MOVIMENTO.ST = 'C'
         WHERE MOVIMENTO.IDMOVIMENTO = :IDMOVIMENTO_QUITACAO_PARCELA;
    END    
END^


ALTER PROCEDURE SP_AJUSTA_SALDO (
    STATE CHAR(1),
    IDCONTA_LANCAMENTO INTEGER,
    VALOR_LANCAMENTO DOUBLE PRECISION,
    VALOR_LANCAMENTO_ANTERIOR DOUBLE PRECISION,
    TIPO INTEGER)
AS
DECLARE VARIABLE SALDO_ATUAL DOUBLE PRECISION;
BEGIN
/*  MOVIMENTO.TIPO
    1 - CREDITO A VISTA
    2 - DEBITO A VISTA
    (3 - CREDITO A PRAZO)
    (4 - DEBITO A PRAZO)
    5 - QUITACAO DE CREDITO
    6 - QUITACAO DE DEBITO
*/

  -- SALDO ATUAL
  SELECT CONTA.SALDO FROM CONTA WHERE CONTA.IDCONTA = :IDCONTA_LANCAMENTO INTO :SALDO_ATUAL;

  IF (STATE IN ('I', 'U')) THEN
  BEGIN
    IF (TIPO IN (1, 5)) THEN -- SOMA CREDITOS
    BEGIN
        SALDO_ATUAL = ((SALDO_ATUAL - VALOR_LANCAMENTO_ANTERIOR) + VALOR_LANCAMENTO);
    END
    ELSE IF (TIPO IN (2, 6)) THEN -- SOMA DEBITOS
    BEGIN
        SALDO_ATUAL = ((SALDO_ATUAL + VALOR_LANCAMENTO_ANTERIOR) - VALOR_LANCAMENTO);
    END
  END
  ELSE IF (STATE = 'D') THEN
  BEGIN
    IF (TIPO IN (1, 5)) THEN -- DESFAZ SOMA CREDITOS
    BEGIN
        SALDO_ATUAL = (SALDO_ATUAL - VALOR_LANCAMENTO);
    END
    ELSE IF (TIPO IN (2, 6)) THEN -- DESFAZ SOMA DEBITOS
    BEGIN
        SALDO_ATUAL = (SALDO_ATUAL + VALOR_LANCAMENTO);
    END
  END

  UPDATE CONTA SET CONTA.SALDO = :SALDO_ATUAL WHERE CONTA.IDCONTA = :IDCONTA_LANCAMENTO;

  SUSPEND;
END^


ALTER PROCEDURE SP_EXTRATO_CONTA (
    IDCONTA_EXTRATO INTEGER,
    IDCCUSTO_EXTRATO INTEGER,
    DATA_INICIO_EXTRATO TIMESTAMP,
    DATA_FIM_EXTRATO TIMESTAMP)
RETURNS (
    IDCONTA INTEGER,
    IDCCUSTO INTEGER,
    DESCRICAO VARCHAR(100),
    DATA_MOVIMENTO TIMESTAMP,
    TIPO_MOVIMENTO CHAR(1),
    VALOR DOUBLE PRECISION,
    SALDO_MOVIMENTO DOUBLE PRECISION)
AS
DECLARE VARIABLE SQL_WHERE VARCHAR(5000);
DECLARE VARIABLE SQL_TXT VARCHAR(5000);
DECLARE VARIABLE TIPO INTEGER;
DECLARE VARIABLE SALDO_ATUAL DOUBLE PRECISION;
DECLARE VARIABLE SALDO_ANTERIOR_CREDITO DOUBLE PRECISION;
DECLARE VARIABLE SALDO_ANTERIOR_DEBITO DOUBLE PRECISION;
BEGIN
/*  MOVIMENTO.TIPO
    1 - CREDITO A VISTA
    2 - DEBITO A VISTA
    (3 - CREDITO A PRAZO)
    (4 - DEBITO A PRAZO)
    5 - QUITACAO DE CREDITO
    6 - QUITACAO DE DEBITO
*/

  -- INICIALIZA VARIAVEIS
  SQL_WHERE = '';
  SQL_TXT = '';
  SALDO_ATUAL = 0;
  SALDO_ANTERIOR_CREDITO = 0;
  SALDO_ANTERIOR_DEBITO = 0;

  -- SALDO ATUAL DA TABELA CONTA
  SELECT CONTA.SALDO FROM CONTA
   WHERE CONTA.IDCONTA = :IDCONTA_EXTRATO
    INTO :SALDO_ATUAL;

  -- WHERES
  IF (IDCONTA_EXTRATO > 0) THEN
  BEGIN
    SQL_WHERE = SQL_WHERE || ' AND MOVIMENTO.IDCONTA = ' || :IDCONTA_EXTRATO;
  END

  IF (IDCCUSTO_EXTRATO > 0) THEN
  BEGIN
    SQL_WHERE = SQL_WHERE || ' AND MOVIMENTO.IDCONTA = ' || :IDCCUSTO_EXTRATO;
  END

  SQL_WHERE = SQL_WHERE || ' AND MOVIMENTO.ST = ''A'' ';

  -- TOTAL DE CREDITOS ANTERIORES
  SQL_TXT = 'SELECT COALESCE(SUM(MOVIMENTO.VALOR), 0) ' ||
              'FROM MOVIMENTO ' ||
             'WHERE 1 = 1 ' ||
               'AND MOVIMENTO.TIPO IN (1, 5) ' ||
               'AND MOVIMENTO.DATA_LANCAMENTO < ''' || DATA_INICIO_EXTRATO || ''' ' ||
            SQL_WHERE;
  EXECUTE STATEMENT :SQL_TXT INTO :SALDO_ANTERIOR_CREDITO;

  -- TOTAL DE DEBITOS ANTERIORES
  SQL_TXT = 'SELECT COALESCE(SUM(MOVIMENTO.VALOR), 0) ' ||
              'FROM MOVIMENTO ' ||
             'WHERE 1 = 1 ' ||
               'AND MOVIMENTO.TIPO IN (2, 6) ' ||
               'AND MOVIMENTO.DATA_LANCAMENTO < ''' || DATA_INICIO_EXTRATO || ''' ' ||
            SQL_WHERE;
  EXECUTE STATEMENT :SQL_TXT INTO :SALDO_ANTERIOR_DEBITO;

  -- SELECT MOVIMENTOS DO PERIODO
  SQL_TXT = 'SELECT MOVIMENTO.IDCONTA, MOVIMENTO.IDCCUSTO, MOVIMENTO.DESCRICAO, MOVIMENTO.DATA_LANCAMENTO, MOVIMENTO.TIPO, MOVIMENTO.VALOR ' ||
              'FROM MOVIMENTO ' ||
             'WHERE 1 = 1 ' ||
               'AND MOVIMENTO.TIPO IN (1, 2, 5, 6) ' ||
               'AND MOVIMENTO.DATA_LANCAMENTO BETWEEN ''' || DATA_INICIO_EXTRATO || ''' AND ''' || DATA_FIM_EXTRATO || ''' ' ||
               SQL_WHERE ||
             'ORDER BY MOVIMENTO.DATA_LANCAMENTO, MOVIMENTO.IDMOVIMENTO ';

  -- INICIALIZA SALDO ATUAL COM INFORMACOES DE DATA ANTERIORES
  SALDO_ATUAL = ( SALDO_ATUAL + (SALDO_ANTERIOR_CREDITO - SALDO_ANTERIOR_DEBITO) );

  -- PERCORRE MOVIMENTOS
  FOR
    EXECUTE STATEMENT :SQL_TXT
    INTO :IDCONTA, :IDCCUSTO, :DESCRICAO, :DATA_MOVIMENTO, :TIPO, :VALOR
  DO
  BEGIN
    -- TIPO MOVIMENTO
    IF (TIPO IN (1, 5)) THEN -- CREDITO
    BEGIN
        TIPO_MOVIMENTO = 'C';
        SALDO_ATUAL = SALDO_ATUAL + VALOR;
    END
    ELSE IF (TIPO IN (2, 6)) THEN -- DEBITO
    BEGIN
        TIPO_MOVIMENTO = 'D';
        SALDO_ATUAL = SALDO_ATUAL - VALOR;
    END

    SALDO_MOVIMENTO = SALDO_ATUAL;

    SUSPEND;
  END
END^



SET TERM ; ^


/******************************************************************************/
/****                             Descriptions                             ****/
/******************************************************************************/

DESCRIBE DOMAIN DECISAO
'S - SIM
N - NAO';

DESCRIBE DOMAIN SITUACAO
'A - ATIVO
C - CANCELADO';

DESCRIBE DOMAIN SITUACAO_PARCELA
'A - ATIVO
C - CANCELADO
Q - QUITADO';

DESCRIBE DOMAIN TIPO_MOVIMENTO
'1 - CREDITO A VISTA
2 - DEBITO A VISTA
3 - CREDITO A PRAZO
4 - DEBITO A PRAZO
5 - QUITACAO DE CREDITO
6 - QUITACAO DE DEBITO';

DESCRIBE DOMAIN TIPO_PARCELA
'3 - CREDITO A PRAZO
4 - DEBITO A PRAZO';



/******************************************************************************/
/****                         Fields descriptions                          ****/
/******************************************************************************/

DESCRIBE FIELD TIPO TABLE CONTA
'C - CAIXA
B - BANCO
A - APLICACAO';

DESCRIBE FIELD TIPO TABLE MOVIMENTO
'1 - CREDITO A VISTA
2 - DEBITO A VISTA
3 - CREDITO A PRAZO
4 - DEBITO A PRAZO
5 - QUITACAO DE CREDITO
6 - QUITACAO DE DEBITO';

DESCRIBE FIELD PARCELADO TABLE MOVIMENTO
'S - SIM
N - NAO';

DESCRIBE FIELD ST TABLE MOVIMENTO
'A - ATIVO
C - CANCELADO';

DESCRIBE FIELD ST TABLE USUARIO
'A - ATIVO
C - CANCELADO';
