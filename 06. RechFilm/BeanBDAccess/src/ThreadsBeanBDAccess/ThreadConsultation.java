/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ThreadsBeanBDAccess;

import AccessBD.BeanBDAccess;
import Queries.QuerySelect;
import Utils.Convert;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JTextArea;

/**
 *
 * @author Julien
 */
public class ThreadConsultation extends Thread
{
    private QuerySelect Query;
    JTextArea TA;
    private BeanBDAccess Bean;
    
    public ThreadConsultation(JTextArea T, BeanBDAccess Bean)
    {
        this.Bean = Bean;
        TA = T;
    }
    
    @Override
    public void run()
    {
        try
        {
            ResultSet rs = Bean.Select(getQuery());
            
            ResultSetMetaData RSMD = rs.getMetaData();
            int i;
            TA.setText(TA.getText() + "\n");
            while (rs.next())
            {
                i = 1;
                while (i <= RSMD.getColumnCount())
                {
                    TA.setText(TA.getText() + RSMD.getColumnName(i) + " : " + rs.getString(RSMD.getColumnName(i))+ "    ");
                    i++;
                }
                TA.setText(TA.getText() + "\n");
            }
        }
        catch (SQLException ex)
        {
            System.err.println("Erreur dans le ThreadConsultation");
            Logger.getLogger(ThreadConsultation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * @return the Query
     */
    public QuerySelect getQuery() {
        return Query;
    }

    /**
     * @param Query the Query to set
     */
    public void setQuery(QuerySelect Query) {
        this.Query = Query;
    }

    /**
     * @return the Bean
     */
    public BeanBDAccess getBean() {
        return Bean;
    }

    /**
     * @param Bean the Bean to set
     */
    public void setBean(BeanBDAccess Bean) {
        this.Bean = Bean;
    }
}
