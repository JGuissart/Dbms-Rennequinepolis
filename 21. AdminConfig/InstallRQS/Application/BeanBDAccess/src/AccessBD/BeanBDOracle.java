/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package AccessBD;

import java.sql.SQLException;

/**
 *
 * @author Julien
 */
public class BeanBDOracle extends BeanBDAccess
{
    public BeanBDOracle()
    {
        this.DEFAULT_SELECT = "*";
        this.DEFAULT_FROM = "all_tables";
        this.DEFAULT_WHERE = "";
        this.CONNECT = "jdbc:oracle:thin:@";
        this.DRIVER = "oracle.jdbc.driver.OracleDriver";
    }
    
    public BeanBDOracle(String AdresseIp, String Port, String SID, String Schema, String Password) throws SQLException
    {
        this();
        String Connect = AdresseIp + ":" + Port + ":" + SID;
        this.Connect(Connect, Schema, Password);
    }
}
