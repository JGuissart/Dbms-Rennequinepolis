/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Queries;

import java.util.LinkedList;

/**
 *
 * @author Julien
 */
public class QueryDelete
{
    //<editor-fold defaultstate="collapsed" desc="Variables membres">
    private LinkedList<String> ListWhere;
    private String Table;
    public static String AND = " AND ";
    public static String OR = " OR ";
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Constructeurs">
    public QueryDelete() 
    {
        this.setTable("");
        this.setListWhere(new LinkedList());
    }
    
    public QueryDelete(String table) 
    {
        this();
        this.setTable(table);
    }
    
    public QueryDelete(String table, String where) 
    {
        this(table);
        this.AddWhere(where);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes Add">
    public void AddWhere(String where)
    {
        this.AddWhere("", where);
    }
    
    public void AddWhere(String AND_OR, String where)
    {
        this.getListWhere().add(AND_OR + where);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes getWhere">
    public String getWhere()
    {
        String WhererString = "";

        if(!this.getListWhere().isEmpty())
        {
            for(int i = 0; i < this.getListWhere().size(); i++)
                WhererString += this.getListWhere().get(i);
        }
        return WhererString;
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Getters / Setters">
    /**
     * @return the ListWhere
     */
    public LinkedList<String> getListWhere() {
        return ListWhere;
    }

    /**
     * @param ListWhere the ListWhere to set
     */
    public void setListWhere(LinkedList<String> ListWhere) {
        this.ListWhere = ListWhere;
    }

    /**
     * @return the Table
     */
    public String getTable() {
        return Table;
    }

    /**
     * @param Table the Table to set
     */
    public void setTable(String Table) {
        this.Table = Table;
    }
    //</editor-fold>
}
