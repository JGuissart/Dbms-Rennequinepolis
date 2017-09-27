/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Julien
 */
public class Convert
{
    public static String CHAR_ROW = "_&";
    public static String CHAR_COL = "_!";
    
    public static String ResultSetToString(ResultSet rs, String RowSep, String ColSep) throws SQLException
    {
        if(rs != null)
        {
            String strResult = "";
            try 
            {               
                ResultSetMetaData rsmd = rs.getMetaData();
                int iNombreColonnes = rsmd.getColumnCount();
                
                /* Récupération du nom des colonnes */
                for(int i = 1; i <= iNombreColonnes; i++)
                {
                    String column = rsmd.getColumnLabel(i); 
                    strResult += column + ColSep;
                }

                strResult += RowSep;
                rs.first();
                
                do
                {
                    for(int i = 1; i <= iNombreColonnes; i++)
                        strResult += rs.getString(i) + ColSep;

                    strResult += RowSep;
                }
                while(rs.next());
                
                return strResult;
            }
            catch (SQLException ex) 
            {
                System.err.println("Je suis dans SQLException");
                return null;
            }
        }
        else
            return null;
    }
    
    public static String ResultSetToString(ResultSet rs) throws SQLException
    {
        return ResultSetToString(rs, CHAR_ROW, CHAR_COL);
    }
    
    public static DataSet StringToDataSet(String Result, String RowSep, String ColSep)
    {
        String[] arrayStringRows = Result.split(RowSep);
        Object[] arrayObjectColumnNames = null;
        Object[][] arrayObjectData = null;
        int j;
        
        for(int i = 0; i < arrayStringRows.length ; i++)
        {
            String[] cols = arrayStringRows[i].split(ColSep);
            
            if(i == 0)
            {
                arrayObjectData = new String[arrayStringRows.length - 1][cols.length];
                arrayObjectColumnNames= new String[cols.length];
                j = 0;
                for(String str : cols)
                {                    
                    arrayObjectColumnNames[j] = str;
                    j++;
                }
            }
            else
            {
                j = 0;
                for(String str : cols)
                {
                    arrayObjectData[i - 1][j] = str;
                    j++;
                }
            }
        }
        
        return new DataSet(arrayObjectColumnNames, arrayObjectData);
    }
    
    public static DataSet StringToDataSet(String Result)
    {
        return StringToDataSet(Result, CHAR_ROW, CHAR_COL);
    }
    
    public static DataSet ResultSetToDataSet(ResultSet rs) throws SQLException
    {
        String strResult = ResultSetToString(rs);
        return StringToDataSet(strResult);
    }
    
    public static DataSet ResultSetToDataSet(ResultSet rs, String RowSep, String ColSep) throws SQLException
    {
        String strResult = ResultSetToString(rs, RowSep, ColSep);
        return StringToDataSet(strResult);
    }
    
    public static void DisplayResult(JTable Table, String Result)
    {
        DefaultTableModel dtm = (DefaultTableModel)Table.getModel();
        DataSet ds = StringToDataSet(Result);        
        dtm.setDataVector(ds.getData(), ds.getColumnNames());
    }
    
    public static void DisplayResult(JTable Table, ResultSet rs) throws SQLException
    {
        DefaultTableModel dtm = (DefaultTableModel)Table.getModel();
        DataSet ds = ResultSetToDataSet(rs);
        dtm.setDataVector(ds.getData(), ds.getColumnNames());
    }
}
