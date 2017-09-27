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
public class QueryInsert 
{
    //<editor-fold defaultstate="collapsed" desc="Variables membres">
    private LinkedList<String> ListColumns;
    private LinkedList<String> ListValues;
    private String Table;
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Constructeurs">
    public QueryInsert() 
    {
        this.setTable("");
        this.setListColumns(new LinkedList());
        this.setListValues(new LinkedList());
    }
    
    public QueryInsert(String table) 
    {
        this();
        this.setTable(table);
    }
    
    public QueryInsert(String table, String cols, String values) 
    {
        this(table);
        this.AddValue(cols, values);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthode Add">
    public void AddValue(String col, String val)
    {
        if(col != null && val != null)
        {
            this.getListColumns().add(col);
            this.getListValues().add(val);
        }
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes getCols/Values">
    public String getCols()
    {
        String ColumnsString = "";
        if(!this.getListColumns().isEmpty())
        {
            for(int i = 0; i < this.getListColumns().size(); i++)
            {
                ColumnsString += this.getListColumns().get(i);
                if(i + 1 != this.getListColumns().size())
                    ColumnsString += ", ";
            }
        }
        return ColumnsString;
    }
    
    public String getValues()
    {
        String ValuesString = "";
        if(!this.getListValues().isEmpty())
        {
            for(int i = 0; i < this.getListValues().size(); i++)
            {
                ValuesString += this.getListValues().get(i);
                if(i + 1 != this.getListValues().size())
                    ValuesString += ", ";
            }
        }
        return ValuesString;
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Getters/Setters">
    /**
     * @return the ListColumns
     */
    public LinkedList<String> getListColumns() {
        return ListColumns;
    }

    /**
     * @param ListColumns the ListColumns to set
     */
    public void setListColumns(LinkedList<String> ListColumns) {
        this.ListColumns = ListColumns;
    }

    /**
     * @return the ListValues
     */
    public LinkedList<String> getListValues() {
        return ListValues;
    }

    /**
     * @param ListValues the ListValues to set
     */
    public void setListValues(LinkedList<String> ListValues) {
        this.ListValues = ListValues;
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