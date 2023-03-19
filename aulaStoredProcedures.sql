CREATE DATABASE aula04
GO
USE aula04
GO
CREATE TABLE cliente(
cpf               CHAR(11)          NOT NULL,
nome              VARCHAR(100)      NOT NULL, 
email             VARCHAR(200)      NOT NULL,
limite_credito    DECIMAL(7,2)      NOT NULL,
dt_nascimento     DATE              NOT NULL
PRIMARY KEY(cpf)
)
GO

--Verifica o primeiro digito
CREATE PROCEDURE sp_cpf_primeiro_verificador (@cpf VARCHAR(11), @ver1 INT OUTPUT)
AS
	DECLARE @loop INT, @digitos INT, @soma INT, @digito INT, @aux INT
	SET @loop = 1 SET @digitos = 10 SET @soma = 0 SET @ver1 = 0 

	WHILE(@loop < 10) BEGIN
		SET @digito = CAST(SUBSTRING(@cpf, @loop, 1) AS INT)
		SET @soma = @soma + (@digitos * @digito)
		SET @digitos = @digitos - 1
		SET @loop = @loop + 1 
	END 
	SET @aux = @soma % 11
	IF (@aux < 2) BEGIN
		SET @ver1 = 0
	END
	ELSE BEGIN
		SET @ver1 = 11 - @aux
	END
GO

--Verifica o segundo digito
CREATE PROCEDURE sp_cpf_segundo_verificador (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @loop INT, @digitos INT, @soma INT, @digito INT, @aux INT, @ver1 INT, @ver2 INT, @ver VARCHAR(10)
	SET @loop = 1 SET @digitos = 11 SET @soma = 0 SET @ver2 = 0 

	EXEC sp_cpf_primeiro_verificador @cpf, @ver1 OUTPUT

	WHILE(@loop < 10) BEGIN
		SET @digito = CAST(SUBSTRING(@cpf, @loop, 1) AS INT)
		SET @soma = @soma + (@digitos * @digito)
		SET @digitos = @digitos - 1
		SET @loop = @loop + 1 
	END
	SET @soma = @soma + (2 * @ver1)
	SET @aux = @soma % 11

	IF (@aux < 2) BEGIN
		SET @ver2 = 0
	END
	ELSE BEGIN
		SET @ver2 = 11 - @aux
	END

	SET @ver = CAST(@ver1 AS VARCHAR(1)) + CAST(@ver2 AS VARCHAR(1))
	IF (@ver = SUBSTRING(@cpf, 10, 2)) BEGIN
		SET @valido = 1
	END
	ELSE BEGIN
		SET @valido = 0
	END
GO

--Valida numeros iguais
CREATE PROCEDURE sp_cpf_numero_iguais (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @loop INT, @aux VARCHAR(10)
	SET @loop = 1 SET @aux = SUBSTRING(@cpf, 1, 1) SET @valido = 0 
	
	WHILE(@loop < 12) BEGIN
		IF(@aux != SUBSTRING(@cpf, @loop, 1)) BEGIN
			SET @valido = 1
		END
		SET @loop = @loop + 1
	END
GO

--validaCPF
CREATE PROCEDURE sp_valida_cpf (@cpf VARCHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @valida1 BIT, @valida2 BIT

	EXEC sp_cpf_segundo_verificador @cpf, @valida1 OUTPUT
	EXEC sp_cpf_numero_iguais @cpf, @valida2 OUTPUT

	IF(@valida1 = 0 OR @valida2 = 0) BEGIN
		SET @valido = 0
	END ELSE BEGIN
		SET @valido = 1
	END

--Teste StoredProcedures validaCPF
DECLARE @cpf_valido BIT
EXEC sp_valida_cpf '38990019826', @cpf_valido OUTPUT
PRINT @cpf_valido
GO

--StoredProcedures cliente
CREATE PROCEDURE sp_cliente(@opcao CHAR(1), @cpf CHAR(11), @nome VARCHAR(100),
		@email VARCHAR(200), @limite_credito DECIMAL(7,2), @dt_nascimento DATE, @saida VARCHAR(200) OUTPUT)
AS
    DECLARE @valido_cpf BIT

    IF (UPPER(@opcao) = 'D')
    BEGIN
        IF (@cpf IS NULL)
        BEGIN
            RAISERROR('Não é possível excluir sem CPF', 16, 1)
        END
        ELSE
        BEGIN
            DELETE FROM cliente WHERE cpf = @cpf
            SET @saida = 'Cliente ' + @cpf + ' excluído'
        END
    END
    ELSE IF (UPPER(@opcao) = 'I')
    BEGIN
        IF (@cpf IS NULL OR @nome IS NULL OR @email IS NULL OR @limite_credito IS NULL OR @dt_nascimento IS NULL)
        BEGIN
            RAISERROR('Campos obrigatórios não informados', 16, 1)
        END
        ELSE
        BEGIN
            EXEC sp_valida_cpf @cpf, @valido_cpf OUTPUT

            IF (@valido_cpf = 0)
            BEGIN
                RAISERROR('CPF inválido', 16, 1)
            END
            ELSE
            BEGIN
                INSERT INTO cliente (cpf, nome, email, limite_credito, dt_nascimento)
                VALUES (@cpf, @nome, @email, @limite_credito, @dt_nascimento)

                SET @saida = 'Cliente ' + @cpf + ' inserido'
            END
        END
    END
    ELSE IF (UPPER(@opcao) = 'U')
    BEGIN
        IF (@cpf IS NULL)
        BEGIN
            RAISERROR('CPF não informado', 16, 1)
        END
        ELSE
        BEGIN
            EXEC sp_valida_cpf @cpf, @valido_cpf OUTPUT

            IF (@valido_cpf = 0)
            BEGIN
                RAISERROR('CPF inválido', 16, 1)
            END
            ELSE
            BEGIN
                IF (@nome IS NOT NULL)
                BEGIN
                    UPDATE cliente SET nome = @nome WHERE cpf = @cpf
                END

                IF (@email IS NOT NULL)
                BEGIN
                    UPDATE cliente SET email = @email WHERE cpf = @cpf
                END

                IF (@limite_credito IS NOT NULL)
                BEGIN
                    UPDATE cliente SET limite_credito = @limite_credito WHERE cpf = @cpf
                END

                IF (@dt_nascimento IS NOT NULL)
                BEGIN
                    UPDATE cliente SET dt_nascimento = @dt_nascimento WHERE cpf = @cpf
                END

                SET @saida = 'Cliente ' + @cpf + ' atualizado'
            END
        END
    END
    ELSE
    BEGIN
        RAISERROR('Opção inválida', 16, 1)
    END
GO

--Teste StoredProcedures cliente
DECLARE @out VARCHAR(40)
EXEC sp_cliente 'i', '38990019826', 'Fran', 'fran@email.com', 9.5, '15/07/1998', @out OUTPUT
PRINT @out

SELECT*FROM cliente