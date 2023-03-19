<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Exercício StoredProcedure</title>
</head>
<body>
	<div align="center" class="container">
		<form action="cliente" method="post">
			<p class="title">
				<b>Cliente</b>
			</p>
			<table>
				<tr>
					<td colspan="3">
						<input class="id_input_data" type="number" min="0"
							step="1" id="cpf" name="cpf" placeholder="CPF"
							value='<c:out value="${cliente.cpf }"></c:out>'>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input class="input_data" type="text" id="nome" name="nome"
							placeholder="Nome"
							value='<c:out value="${cliente.nome }"></c:out>'>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input class="input_data" type="email" id="email" name="email"
							placeholder="E-mail"
							value='<c:out value="${cliente.email }"></c:out>'>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input class="input_data" type="text" id="limite_credito" name="limite_credito"
							placeholder="Limite de Crédito"
							value='<c:out value="${cliente.limite_credito }"></c:out>'>
					</td>
				</tr>
				<tr>
					<td>
						<input type="date" id="dt_nascimento" name="dt_nascimento"
						placeholder="Data de Nascimento">
					</td>
				</tr>
				<tr>
					<td>
						<input type="submit" id="botao" name="botao" value="Inserir">
					</td>
					<td>
						<input type="submit" id="botao" name="botao" value="Atualizar">
					</td>
					<td>
						<input type="submit" id="botao" name="botao" value="Deletar">
					</td>
				</tr>
			</table>
		</form>		
	</div>
	<div align="center">
		<c:if test="${not empty erro }">
			<H2><c:out value="${erro }" /></H2>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty saida }">
			<H3><c:out value="${saida }" /></H3>
		</c:if>
	</div>
</body>
</html>