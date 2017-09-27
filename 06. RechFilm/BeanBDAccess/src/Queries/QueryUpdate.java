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
public class QueryUpdate 
{
    //<editor-fold defaultstate="collapsed" desc="Variables membres">
    private LinkedList<String> ListColumns;
    private LinkedList<String> ListValues;
    private LinkedList<String> ListWhere;
    private String Table;
    public static String AND = " AND ";
    public static String OR = " OR ";
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Constructeurs">
    public QueryUpdate() 
    {
        this.setTable("");
        this.setListColumns(new LinkedList());
        this.setListValues(new LinkedList());
        this.setListWhere(new LinkedList());
    }
    
    public QueryUpdate(String table) 
    {
        this();
        this.setTable(table);
    }
    
    public QueryUpdate(String table, String cols, String values) 
    {
        this(table);
        this.AddValue(cols, values);
    }
    
    public QueryUpdate(String table, String cols, String values, String where) 
    {
        this(table, cols, values);
        this.AddWhere(where);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes Add">
    public void AddValue(String col, String val)
    {
        if(col != null && val != null)
        {
            this.getListColumns().add(col);
            this.getListValues().add(val);
        }
    }
    
    public void AddWhere(String where)
    {
        this.AddWhere("", where);
    }
    
    public void AddWhere(String AND_OR, String where)
    {
        this.getListWhere().add(AND_OR + where);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes getValues/Where">
    public String getValues()
    {
        String ValueString = "";
        if(!this.getListValues().isEmpty())
        {
            for(int i = 0; i < this.getListValues().size(); i++)
            {
                ValueString += this.getListColumns().get(i) + " = " + this.getListValues().get(i);
                if(i + 1 != this.getListValues().size())
                    ValueString += ", ";
            }
        }
        return ValueString;
    }
    
    public String getWhere()
    {
        String WhereString = "";
        if(!this.getListWhere().isEmpty())
        {
            for(int i =0; i < this.getListWhere().size(); i++)
                WhereString += this.getListWhere().get(i);
        }
        return WhereString;
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Getters / Setters">
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