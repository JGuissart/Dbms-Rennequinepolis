/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Others;

import java.util.logging.Level;
import java.util.logging.Logger;
import rechevalfilm.MainForm;

/**
 *
 * @author Julien
 */
public class ThreadCheckDatabase extends Thread
{
    private MainForm Caller;
    
    public ThreadCheckDatabase(MainForm Caller)
    {
        this.Caller = Caller;
    }
    
    @Override
    public void run()
    {
        while(true)
        {
            try
            {
                if(Caller.getCurrentDatabase() == null || Caller.getCurrentDatabase().equals("CB")) // On vérifie la connexion uniquement si la connexion courante est CB !
                    Caller.DatabaseConnection();
                
                Thread.sleep(1000);
            }
            catch (InterruptedException ex)
            {
                Logger.getLogger(ThreadCheckDatabase.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
