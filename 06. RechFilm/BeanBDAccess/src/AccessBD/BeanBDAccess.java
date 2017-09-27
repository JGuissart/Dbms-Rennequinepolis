/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package AccessBD;

import Queries.QueryDelete;
import Queries.QueryInsert;
import Queries.QuerySelect;
import Queries.QueryUpdate;
import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.logging.Level;
import java.util.logging.Logger;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;

/**
 *
 * @author Julien
 */
public abstract class BeanBDAccess implements Serializable
{
    protected String DEFAULT_SELECT = "*";
    protected String DEFAULT_FROM = "dual";
    protected String DEFAULT_WHERE = "";
    protected String CONNECT = "";
    protected String DRIVER = "";
    protected String LIMIT_ONE = "";
    private Connection _Connection;
    private CallableStatement _CallableStatement;
    
    public boolean Connect() throws SQLException
    {
        try 
        {
            System.out.println("Bean = " + System.getProperty("user.dir"));
            Class.forName(DRIVER).newInstance();
            System.out.println("Driver charge !");
            this.setConnection(DriverManager.getConnection(CONNECT));
            System.out.println("Driver connecte !");
            this.getConnection().setAutoCommit(true);
            
            return true;
        }
        catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex)
        {
            System.err.println("Erreur BeanBDAccess");
            Logger.getLogger(BeanBDAccess.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public boolean Connect(String Connect) throws SQLException
    {
        try 
        {
            Class.forName(DRIVER).newInstance();
            System.out.println("Driver charge !");
            this.setConnection(DriverManager.getConnection(CONNECT + Connect, "", ""));
            this.getConnection().setAutoCommit(false);
            
            return true;
        }
        catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex)
        {
            System.err.println("Erreur BeanBDAccess");
            Logger.getLogger(BeanBDAccess.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public boolean Connect(String Connect, String Login, String Password) throws SQLException
    {
        try 
        {
            Class.forName(DRIVER).newInstance();
            System.out.println("Driver charge !");
            this.setConnection(DriverManager.getConnection(CONNECT + Connect, Login, Password));
            this.getConnection().setAutoCommit(false);
            
            return true;
        }
        catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex)
        {
            System.err.println("Erreur BeanBDAccess");
            Logger.getLogger(BeanBDAccess.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public synchronized ResultSet Select(QuerySelect query) throws SQLException
    {
        String select, from, where;
        
        if(query.getSelect().isEmpty())
            select = "SELECT " + this.DEFAULT_SELECT;
        else
            select = "SELECT " + query.getSelect();
        
        if(query.getFrom().isEmpty())
            from = "FROM " + this.DEFAULT_FROM;
        else
            from = "FROM " + query.getFrom();
        
        if(query.getWhere().isEmpty())
            where = this.DEFAULT_WHERE;
        else
            where = "WHERE " + query.getWhere();
        
        String QueryString = select + " " + from + " " + where;
        
        // PreparedStatement pour setInt, setString, ...
        Statement stmt = this.getConnection().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        System.out.println("Query Select : " + QueryString);

        return stmt.executeQuery(QueryString);
    }
    
    public ResultSet Select(String select, String from, String where) throws SQLException
    {
        return this.Select(new QuerySelect(select, from, where));
    }
    
    public synchronized int Insert(QueryInsert query) throws SQLException
    {
        String QueryString = "INSERT INTO " + query.getTable() + " (" + query.getCols() + ") VALUES(" + query.getValues() + ")";
        
        // PreparedStatement pour setInt, setString, ...
        Statement stmt = this.getConnection().createStatement();
        System.out.println("Query Insert : " + QueryString);
        
        return stmt.executeUpdate(QueryString);
    }
    
    public int Insert(String table, String cols, String values) throws SQLException
    {
        return this.Insert(new QueryInsert(table, cols, values));
    }
    
    public synchronized int Update(QueryUpdate query) throws SQLException
    {
        String QueryString;
        
        if(!query.getWhere().equals("")) 
            QueryString = "UPDATE " + query.getTable() + " SET " + query.getValues() + " WHERE " + query.getWhere();
        else
            QueryString = "UPDATE " + query.getTable() + " SET " + query.getValues();
        
        System.out.println("Query Update : " + QueryString);
        
        // PreparedStatement pour setInt, setString, ...
        Statement stmt = this.getConnection().createStatement();
        
        return stmt.executeUpdate(QueryString);
    }
    
    public int Update(String table, String cols, String values) throws SQLException
    {
        return this.Update(new QueryUpdate(table, cols, values));
    }
    
    public int Update(String table, String cols, String values, String where) throws SQLException
    {
        return this.Update(new QueryUpdate(table, cols, values, where));
    }
    
    public synchronized int Delete(QueryDelete query) throws SQLException
    {
        String QueryString;
        
        if(!query.getWhere().equals("")) 
            QueryString = "DELETE FROM " + query.getTable() + " WHERE " + query.getWhere();
        else
            QueryString = "DELETE FROM " + query.getTable();
        
        System.out.println("Query Delete : " + QueryString);
        
        // PreparedStatement pour setInt, setString, ...
        Statement stmt = this.getConnection().createStatement();
        
        return stmt.executeUpdate(QueryString);
    }
    
    public int Delete(String table) throws SQLException
    {
        return this.Delete(new QueryDelete(table));
    }
    
    public int Delete(String table, String where) throws SQLException
    {
        return this.Delete(new QueryDelete(table, where));
    }
    
    public void ProcedureStockee(String nomPackage, String nomMethode, int numberOfParameters) throws SQLException
    {
        String parameters = "(";
        for(int i = 0; i < numberOfParameters; i++)
        {
            if(i == numberOfParameters - 1)
                parameters += "?";
            else
                parameters += "?,";
        }
            
        parameters += ")";
        String procedureToCall = null;
        if(!nomPackage.isEmpty())
            procedureToCall =  "{call " + nomPackage + "." + nomMethode + parameters + "}";
        else
            procedureToCall = "{call " + nomMethode + parameters + "}";
        
        System.out.println("procedureToCall = " + procedureToCall);
           
        _CallableStatement = this.getConnection().prepareCall(procedureToCall, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    }
    
    public void ProcedureStockee(String nomPackage, String nomMethode, String namedParameters) throws SQLException
    {
        String procedureToCall = null;
        if(!nomPackage.isEmpty())
            procedureToCall =  "{call " + nomPackage + "." + nomMethode + namedParameters + "}";
        else
            procedureToCall = "{call " + nomMethode + namedParameters + "}";
        
        System.out.println("procedureToCall = " + procedureToCall);
           
        _CallableStatement = this.getConnection().prepareCall(procedureToCall, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    }
    
    public void FonctionStockee(String nomPackage, String nomMethode, int numberOfParameters) throws SQLException
    {
        String parameters = "(";
        for(int i = 0; i < numberOfParameters; i++)
        {
            if(i == numberOfParameters - 1)
                parameters += "?";
            else
                parameters += "?,";
        }
            
        parameters += ")";
        String procedureToCall = null;
        if(!nomPackage.isEmpty())
            procedureToCall =  "{? = call " + nomPackage + "." + nomMethode + parameters + "}";
        else
            procedureToCall = "{? = call " + nomMethode + parameters + "}";
        
        System.out.println("procedureToCall = " + procedureToCall);
        
        _CallableStatement = this.getConnection().prepareCall(procedureToCall, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    }
    
    public void FonctionStockee(String nomPackage, String nomMethode, String namedParameters) throws SQLException
    {
        String procedureToCall = null;
        if(!nomPackage.isEmpty())
            procedureToCall =  "{? = call " + nomPackage + "." + nomMethode + namedParameters + "}";
        else
            procedureToCall = "{? = call " + nomMethode + namedParameters + "}";
        
        System.out.println("procedureToCall = " + procedureToCall);
        
        _CallableStatement = this.getConnection().prepareCall(procedureToCall, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    }
    
    public void csSetNull(String parameterIndex, int value) throws SQLException
    {
        _CallableStatement.setNull(parameterIndex, value);
    }
    
    public void csSetNull(int parameterIndex, int value) throws SQLException
    {
        _CallableStatement.setNull(parameterIndex, value);
    }
    
    public void csSetArrayNull(int parameterIndex, String arrayName) throws SQLException
    {
        _CallableStatement.setNull(parameterIndex, Types.ARRAY, arrayName);
    }
    
    public void csSetInt(String parameterIndex, int value) throws SQLException
    {
        _CallableStatement.setInt(parameterIndex, value);
    }
    
    public void csSetInt(int parameterIndex, int value) throws SQLException
    {
        _CallableStatement.setInt(parameterIndex, value);
    }
    
    public void csSetString(String parameterIndex, String value) throws SQLException
    {
        _CallableStatement.setString(parameterIndex, value);
    }
    
    public void csSetString(int parameterIndex, String value) throws SQLException
    {
        _CallableStatement.setString(parameterIndex, value);
    }
    
    public void csSetArray(int parameterIndex, ARRAY value) throws SQLException
    {
        _CallableStatement.setArray(parameterIndex, value);
    }
    
    public void csSetDate(int parameterIndex, Date value) throws SQLException
    {
        _CallableStatement.setDate(parameterIndex, value);
    }
    
    public void csRegisterOutParameter(String parameterIndex, int type) throws SQLException
    {
        _CallableStatement.registerOutParameter(parameterIndex, type);
    }
    
    public void csRegisterOutParameter(int parameterIndex, int type) throws SQLException
    {
        _CallableStatement.registerOutParameter(parameterIndex, type);
    }
    
    public void csProcedureExecute() throws SQLException
    {
        _CallableStatement.execute();
    }
    
    public ResultSet csFonctionExecute() throws SQLException
    {
        _CallableStatement.execute();
        return (ResultSet)_CallableStatement.getObject(1);
    }
    
    public void Disconnect() throws SQLException
    {
        if(this.getConnection() != null)
            this.getConnection().close();
        this.setConnection(null);
    }
    
    public synchronized void Commit() throws SQLException
    {
        if(this.getConnection() != null) 
            this.getConnection().commit();
    }
    
    public synchronized void Rollback() throws SQLException
    {
        if(this.getConnection() != null) 
            this.getConnection().rollback();
    }
    
    public void setAutoCommit(boolean autocommit) throws SQLException
    {
        if(this.getConnection() != null) 
            this.getConnection().setAutoCommit(autocommit);
    }

    /**
     * @return the _Connection
     */
    public Connection getConnection() {
        return _Connection;
    }

    /**
     * @param _Connection the _Connection to set
     */
    public void setConnection(Connection _Connection) {
        this._Connection = _Connection;
    }
}
