/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ThreadsBeanBDAccess;

import AccessBD.BeanBDAccess;
import Queries.QueryInsert;
import Queries.QueryUpdate;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Julien
 */
public class ThreadUpdate extends Thread
{
    private BeanBDAccess Bean;
    private QueryInsert Insert;
    private QueryUpdate Update;
    
    public ThreadUpdate(BeanBDAccess Bean)
    {
        this.Bean = Bean;
    }
    
    @Override
    public void run()
    {
        try
        {
            System.out.println("Je vais demarrer Update");
            getBean().Update(getUpdate());
            System.out.println("J'ai fini Update et je vais demarrer Insert");
            getBean().Insert(getInsert());
            System.out.println("J'ai fini Insert !!!!!!");
            getBean().Commit();
        }
        catch (SQLException ex)
        {
            System.err.println("Erreur dans le ThreadUpdate");
            Logger.getLogger(ThreadUpdate.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * @return the Insert
     */
    public QueryInsert getInsert() {
        return Insert;
    }

    /**
     * @param Insert the Insert to set
     */
    public void setInsert(QueryInsert Insert) {
        this.Insert = Insert;
    }

    /**
     * @return the Update
     */
    public QueryUpdate getUpdate() {
        return Update;
    }

    /**
     * @param Update the Update to set
     */
    public void setUpdate(QueryUpdate Update) {
        this.Update = Update;
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
