package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import model.Cliente;

public class ClienteDao implements IClienteDao{

	private GenericDao gDao;

	public ClienteDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String iudCliente(String op, Cliente cli) throws SQLException, ClassNotFoundException {
		
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_cliente(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, op);
		cs.setString(2, cli.getCpf());
		cs.setString(3, cli.getNome());
		cs.setString(4, cli.getEmail());
		cs.setFloat(5, cli.getLimiteCredito());
		cs.setString(6, cli.getDtNascimento().toString());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		c.close();

		return saida;	
	}

}
