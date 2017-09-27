/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils;

/**
 *
 * @author Julien
 */
public class DataSet
{
    private Object[] _ColumnNames;
    private Object[][] _Data;
    private int ColumnLength = 0;
    private int dataCols = 0;
    private int dataRows = 0;
    
    public DataSet()
    {
        this.setColumnNames(null);
        this.setData(null);
    }
    
    public DataSet(Object[] ColumnNames, Object[][] Data)
    {
        this.setColumnNames(ColumnNames);
        this.setData(Data);
    }

    /**
     * @return the _ColumnNames
     */
    public Object[] getColumnNames() {
        return _ColumnNames;
    }

    /**
     * @param _ColumnNames the _ColumnNames to set
     */
    public void setColumnNames(Object[] _ColumnNames) {
        this._ColumnNames = _ColumnNames;
    }

    /**
     * @return the _Data
     */
    public Object[][] getData() {
        return _Data;
    }

    /**
     * @param _Data the _Data to set
     */
    public void setData(Object[][] _Data) {
        this._Data = _Data;
    }

    /**
     * @return the ColumnLength
     */
    public int getColumnLength() {
        return ColumnLength;
    }

    /**
     * @param ColumnLength the ColumnLength to set
     */
    public void setColumnLength(int ColumnLength) {
        this.ColumnLength = ColumnLength;
    }

    /**
     * @return the dataCols
     */
    public int getDataCols() {
        return dataCols;
    }

    /**
     * @param dataCols the dataCols to set
     */
    public void setDataCols(int dataCols) {
        this.dataCols = dataCols;
    }

    /**
     * @return the dataRows
     */
    public int getDataRows() {
        return dataRows;
    }

    /**
     * @param dataRows the dataRows to set
     */
    public void setDataRows(int dataRows) {
        this.dataRows = dataRows;
    }
}
