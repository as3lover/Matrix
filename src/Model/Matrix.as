package Model
{
import flash.events.Event;
import flash.events.EventDispatcher;

import Model.Cell;

public class Matrix extends EventDispatcher
{
    public static const UPDATED:String = 'updateEvent';
    public static const UPDATE_EVENT:Event = new Event(UPDATED);

    private var _vector:Vector.<int>;
    private var _length:int = -1;
    private var _rows:int;
    private var _cols:int;

    private static var _pool:Vector.<Matrix> = new <Matrix>[];
    private static var _fromPool:Boolean = false;
    private static var len:int = 0;

    private static var _numbers:int = 0;

    //=================== Constructor
    public function Matrix(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null, notPool:Boolean = false)
    {
        if (!_fromPool && !notPool)
            throw new Error("For Create new Matrix, use Matrix.fromPool");

        _numbers++;
        trace('new matrix',_numbers);
        updateMatrix(numOfRows, numOfCols, vector2D);

        _fromPool = false;
    }

    //=================== Update
    public function updateMatrix(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null):void
    {
        _rows = numOfRows;
        _cols = numOfCols;
        _length = _rows * _cols;

        var requiredLength:int = numOfCols * numOfRows;

        if(vector2D == null)
        {
            _vector = new Vector.<int>(requiredLength);
            return;
        }

        vector2D = vector2D.concat();

        var vectorLength:int = vector2D.length;

        if(vectorLength < requiredLength)
        {
            for(var i:int = vectorLength; i<requiredLength; i++)
            {
                vector2D.push(0);
            }
        }
        else if(vectorLength > requiredLength)
        {
            vector2D = vector2D.slice(0,requiredLength)
        }

        _vector = vector2D;

        dispatchEvent(UPDATE_EVENT);
    }

    //=================== Pooling
    public static function fromPool(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null):Matrix
    {
        if(len)
        {
            len--;
            _pool[len].updateMatrix(numOfRows, numOfCols, vector2D);
            return _pool[len];
        }
        else
        {
            _fromPool = true;
            return new Matrix(numOfRows, numOfCols, vector2D);
        }
    }

    public function dispose():void
    {
        _pool[len] = this;
        len++;
    }

    ////////////////////////////////////////////////////
    ///////////////////// STATIC ///////////////////////
    ////////////////////////////////////////////////////

    //=================== Create Matrix By An Array
    public static function fromArray(array:Array, numOfRows:int, numOfCols:int):Matrix
    {
        var requiredLength:int = numOfCols * numOfRows;
        var arryLength:int = array.length;

        var vector:Vector.<int> = new Vector.<int>(requiredLength);

        for(var i:int =0; i<arryLength; i++)
        {
            if(array[i] != int)
            {
                trace("Error: Array element is not integer. index:", i, 'value', array[i]);
            }
            else
            {
                vector[i] = int(array[i]);
            }
        }

        return fromPool(numOfRows, numOfCols, vector);
    }

    //=================== Create Matrix or Vector and fill by random value
    public static function randomMatrix(numOfRows:int, numOfCols:int, rangeFrom:int = 0, rangeTo:int = 9):Matrix
    {
        return fromPool(numOfRows, numOfCols, randomVector(numOfRows, numOfCols, rangeFrom, rangeTo));
    }

    public static function randomVector(numOfRows:int, numOfCols:int, rangeFrom:int = 0, rangeTo:int = 9):Vector.<int>
    {
        var length:int = numOfCols * numOfRows;

        var vector:Vector.<int> = new Vector.<int>(length);

        var range:int = rangeTo - rangeFrom;

        for(var i:int = 0; i<length; i++)
        {
            var value:int = rangeFrom + int(Math.random() * (range+0.99999));
            vector[i] = value;
        }

        return vector;
    }

    //=================== Duplicate Matrix
    public static function duplicate(matrix:Matrix):Matrix
    {
        if(matrix == null)
        {
            trace("Error Matrix Duplicate: matrix is null");
            return null;
        }

        return fromPool(matrix.rows, matrix.cols, matrix.vector);
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////


    //=================== Print Matrix
    public function print():void
    {
        for(var r:int = 0; r<_rows; r++)
        {
            trace(_vector.slice(r * _cols, (r+1)*_cols))
        }
    }

    //=================== Matrix Row
    public function setRow(vector:Vector.<int>, rowIndex:int, startCol:int = 0, endCol:int = -1):Boolean
    {
        if(
                !checkVector(vector, 'setRow') ||
                !checkRow(rowIndex, 'setRow') ||
                !checkCol(startCol, 'setRow')
        )
            return false;

        if(endCol >= _cols)
            trace("setRow: out of range. _cols:", _cols, ", endCol:", endCol);


        if(endCol == -1 || endCol >= _cols)
        {
            endCol = _cols;
        }
        else if(endCol < startCol)
        {
            trace("Error setRow: out of range. startCol:", startCol, ", endCol:", endCol);
            return false;
        }
        else
        {
            endCol++;
        }

        var len:int = Math.min(vector.length, endCol);

        var startIndex:int = rowIndex * _cols;
        for(var i:int = 0; i<len; i++)
        {
            _vector[startIndex + i] = vector[i];
        }

        return true;
    }

    public function getRow(rowIndex:int):Vector.<int>
    {
        if(!checkRow(rowIndex, 'getRow'))
                return null;

        var startIndex:int = rowIndex * _cols;
        return vector.slice(startIndex, startIndex + _cols);
    }

    //=================== Matrix Value
    public function setValue(value:int, row:int, col:int):Boolean
    {
        if(
                !checkRow(row, 'setValue') ||
                !checkCol(col, 'setValue')
        )
            return false;

        _vector[row * _cols + col] = value;

        return true;
    }

    public function getValue(row:int, col:int):int
    {
        /*
        if(
                !checkRow(row, 'getValue') ||
                !checkCol(col, 'getValue')
        )
            throw new Error("Out of range: " + " rows: " + rows + " cols: " + cols + " row: " + row + " col: " + col);
*/
        return _vector[row * _cols + col];
    }

    //=================== Matrix Value by Cell
    public function setCell(value:int, cell:Cell):Boolean
    {
        if(cell == null)
        {
            trace("Error setCell: cell is null");
            return false;
        }
        return setValue(value, cell.row, cell.col)
    }

    public function getCellValue(cell:Cell):int
    {
        if(cell == null)
        {
            trace("Error getCell: cell is null");
            return int.MIN_VALUE;
        }
        return getValue(cell.row, cell.col)
    }

    public function getCell(row:int, col:int):Cell
    {
        var value:int = getValue(row, col);
        return Cell.fromPool(row, col, value)
    }

    ////////////////////////////////////////////////////
    ///////////////////// private ///////////////////////
    ////////////////////////////////////////////////////

    //=================== Checking for errors
    private function checkRow(row:int, func:String = ''):Boolean
    {
        if(row >= _rows || row < 0)
        {
            trace("Error checkRow (", func, ") :out of range. _rows:", _rows, ", row:", row);
            return false;
        }

        return true
    }

    private function checkCol(col:int, func:String = ''):Boolean
    {
        if(col >= _cols || col < 0)
        {
            trace("Error checkCol (", func, ") :out of range. _cols:", _cols, ", col:", col);
            return false;
        }

        return true
    }

    private static function checkVector(vector:Vector.<int>, func:String = ''):Boolean
    {
        if(vector == null)
        {
            trace("Error checkVector (", func, ") : vector is null");
            return false;
        }
        else if(vector.length == 0)
        {
            trace("Error checkVector: vector is empty");
            return false;
        }

        return true
    }

    ////////////////////////////////////////////////////
    ///////////////////// Fields ///////////////////////
    ////////////////////////////////////////////////////

    public function get rows():int
    {
        return _rows;
    }

    public function get cols():int
    {
        return _cols;
    }

    public function get vector():Vector.<int>
    {
        return _vector.concat();
    }

    public function set vector(vector:Vector.<int>):void
    {
        if(!checkVector(vector, 'set vector'))
            return;

        if(vector.length != _vector.length)
        {
            trace("Error set vector: length not match. _length:", _vector.length, 'length:', vector.length);
            return
        }

        _vector = _vector.concat();
        dispatchEvent(UPDATE_EVENT);
    }

    public function get length():int
    {
        return _length;
    }
}
}
