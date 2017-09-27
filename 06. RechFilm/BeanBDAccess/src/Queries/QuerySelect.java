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
public class QuerySelect
{
    //<editor-fold defaultstate="collapsed" desc="Variables membres">
    private LinkedList<String> ListSelect;
    private LinkedList<String> ListFrom;
    private LinkedList<String> ListWhere;
    public static String AND = " AND ";
    public static String OR = " OR ";
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Constructeurs">
    public QuerySelect()
    {
        this.setListSelect(new LinkedList());
        this.setListFrom(new LinkedList());
        this.setListWhere(new LinkedList());
    }    
    
    public QuerySelect(String from) 
    {
        this();
        this.AddFrom(from);
    }
    
    public QuerySelect(String select, String from) 
    {
        this(from);
        this.AddSelect(select);
    }
    
    public QuerySelect(String select, String from, String where) 
    {
        this(select, from);
        this.AddWhere(where);
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes Add">
    public void AddSelect(String select)
    {
        this.getListSelect().add(select);
    }
    
    public void AddFrom(String from)
    {
        this.getListFrom().add(from);
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
    
    //<editor-fold defaultstate="collapsed" desc="Méthodes GetSelect/From/Where">    
    public String getSelect()
    {
        String SelectString = "";
        if(!this.getListSelect().isEmpty())
        {
            for(int i = 0; i < this.getListSelect().size();i++)
            {
                SelectString += this.getListSelect().get(i);
                if(i + 1 != this.getListSelect().size())
                    SelectString += ", ";
            }
        }
        return SelectString;
    }
    
    public String getFrom()
    {
        String FromString = "";
        if(!this.getListFrom().isEmpty())
        {
            for(int i = 0; i < this.getListFrom().size();i++)
            {
                FromString += this.getListFrom().get(i);
                if(i + 1 != this.getListFrom().size())
                    FromString += ", ";
            }
        }
        return FromString;
    }
    
    public String getWhere()
    {
        String WhereString = "";
        if(!this.getListWhere().isEmpty())
        {
            for(int i = 0; i < this.getListWhere().size(); i++)
            {
                WhereString += this.getListWhere().get(i);
                if(i + 1 != this.getListWhere().size())
                    WhereString += " ";
            }
        }
        return WhereString;
    }
    //</editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="Getters / Setters">
    /**
     * @return the ListSelect
     */
    public LinkedList<String> getListSelect() {
        return ListSelect;
    }

    /**
     * @param ListSelect the ListSelect to set
     */
    public void setListSelect(LinkedList<String> ListSelect) {
        this.ListSelect = ListSelect;
    }

    /**
     * @return the ListFrom
     */
    public LinkedList<String> getListFrom() {
        return ListFrom;
    }

    /**
     * @param ListFrom the ListFrom to set
     */
    public void setListFrom(LinkedList<String> ListFrom) {
        this.ListFrom = ListFrom;
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
    //</editor-fold>
}
