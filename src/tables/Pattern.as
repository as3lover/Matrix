/*
کلاس پترن مشخص کننده ماتریس جدول و ماتریس پترن های تعریف شده در بازی است
این کلاس توابعی برای دسترسی و ویرایش و مقایسه پترن ها ارائه می دهد
 */
package tables
{
import uitiliti.PatternUtils;

public class Pattern
{
    private var _matrix:Vector.<Vector.<int>>;
    private var _rows:uint;
    private var _cols:uint;
    private var _points:Vector.<Cell>;
    private var _firstRowPoints:Vector.<Cell>;
    private var _id:uint;
    private static var _lastId:uint = 0;
    private var _name:String;
    private var _rotation:int;

    public static function random(numOfRows:uint, numOfCols:uint, rangeFrom:int = 0, rangeTo:int = 9):Pattern
    {
        var matrix:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

        var range:int = rangeTo - rangeFrom;

        for(var r:int = 0; r< numOfRows; r++)
        {
            var row:Vector.<int> = new Vector.<int>();
            for(var c:int = 0; c < numOfCols; c++)
            {
                var val:int = rangeFrom + int(Math.random() * (range+0.99999));
                row.push(val);
            }

            matrix.push(row);
        }

        return byMatrix(matrix);
    }

    public static function byMatrix(matrix:Vector.<Vector.<int>>, name:String = null, rotation:int = 0):Pattern
    {
        return new Pattern(0,0,matrix, name, rotation);
    }

    public function Pattern(numOfRows:uint, numOfCols:uint, matrix:Vector.<Vector.<int>> = null, name:String = null, rotation:int = 0)
    {
        _lastId++;
        _id = _lastId;
        _name = name;
        _rotation = rotation;

        if(matrix != null && matrix.length && matrix[0].length)
        {
            _matrix = matrix;
            _rows = _matrix.length;
            _cols = _matrix[0].length;
            return;
        }

        _matrix = new Vector.<Vector.<int>>();
        for(var r:int = 0; r< numOfRows; r++)
        {
            var row:Vector.<int> = new Vector.<int>();
            for(var c:int = 0; c < numOfCols; c++)
            {
                row.push(0);
            }

            _matrix.push(row);
        }

        _rows = numOfRows;
        _cols = numOfCols;

        //temp
        if(_cols = 999999)
        {
            if(setRow == null || duplicate == null || setCell == null || firstRowPoints == null || getCell == null)
                    trace("Null");
        }
    }

    public function print():void
    {
        PatternUtils.tracePattern(this);
    }

    public function get rows():uint
    {
        return _rows;
    }

    public function get cols():uint
    {
        return _cols;
    }

    public function setRow(rowVector:Vector.<int>, row:uint):void
    {
        if(nullRow(rowVector) || errorRow(row) || errorLength(rowVector))
            return;

        //_matrix[row] = rowVector;
        setSubRow(rowVector, row, 0, cols, 0);
    }

    private static function nullRow(row:Vector.<int>):Boolean
    {
        if(row == null)
        {
            trace("Error: nullRow");
            return true;
        }

        return false;
    }

    /*
       یک ردیف را در ماتریس با ردیف جدید جایگزین میکند
    row نشان دهنده اندیس ردیف است
    col نشان دهنده اندیس ستونی از ماتریس است که جایگذاری از آن نقطه شروع میشود
    Length مشخص کننده حداکثر تعداد آیتمی است که از ردیف جدید در ماتریس جایگذاری شود که در حالت صفر یعنی ماکسیمم
    startIndex  اندیس مشخص کننده درایه آغازین در ردیف جدید برای جایگذاری است که به صورت پیش فرض از اولین شروع می شود
    */
    public function setSubRow(rowVector:Vector.<int>, row:uint=0, col:uint=0, length:uint = 0, startIndex:uint = 0):void
    {
        if(errorRow(row) || errorCol(col))
            return;

        if(startIndex >= rowVector.length)
        {
            trace("Error: startIndex >= rowVector.length");
            return;
        }

        length = Math.max(length,rowVector.length);

        length += col;

        length = Math.min(length,cols);

        const vectorLength:uint =  rowVector.length;

        for(var i:int = col; i < length && i-col+startIndex < vectorLength; i++)
        {
            //_matrix[row][i] = rowVector[i-col+startIndex];
            setValue(rowVector[i-col+startIndex], row, i)
        }
    }

    public function setValue(value:int, row:int, col:int):void
    {
        if(errorRow(row) || errorCol(col))
                return;

        _matrix[row][col] = value;
        _points = null;
        _firstRowPoints = null;

        if(_matrix[row][col] != value)
                trace('can not update')
    }

    private function errorRow(row:uint):Boolean
    {
        if(row >= rows)
        {
            trace("Error: row > rows");
            return true;
        }

        return false;
    }

    private function errorCol(col:uint):Boolean
    {
        if(col >= cols)
        {
            trace("Error: col > cols");
            return true;
        }

        return false;
    }

    private function errorLength(row:Vector.<int>):Boolean
    {
        if(row.length != cols)
        {
            trace("Error: row.length != cols");
            return true;
        }

        return false;
    }

    public function duplicate():Pattern
    {
        //return new Pattern(0, 0, copyMatrix());
        var matrix:Vector.<Vector.<int>> = copyMatrix();
        var pattern:Pattern = new Pattern(rows, cols, matrix);
        return pattern;
    }

    public function copyMatrix():Vector.<Vector.<int>>
    {
        return PatternUtils.copyMatrix(_matrix);
    }

    public function setCell(cell:Cell, value:int = -9876543210):void
    {
        if(value = -9876543210)
                value = cell.value;

        setValue(value, cell.row, cell.col);
    }

    private function calculatePoints():void
    {
        var points:Vector.<Cell> = new Vector.<Cell>();

        for(var r:int = 0; r<rows; r++)
        {
            for(var c:int = 0; c<cols; c++)
            {
                var val:int = _matrix[r][c];
                if(val != 0)
                    points.push(new Cell(val, r, c));
            }
        }

        _points = points;
    }

    public function get firstRowPoints():Vector.<Cell>
    {
        if(_firstRowPoints == null)
        {
            _firstRowPoints = new Vector.<Cell>();
            var list:Vector.<Cell> = points;

            for(var i:int=0; i<cols; i++)
            {
                if(list[i].col == 0)
                        _firstRowPoints.push(list[i])
            }
        }

        return _firstRowPoints
    }


    public function get points():Vector.<Cell>
    {
        if(_points == null)
                calculatePoints();

        return _points;
    }

    public function get matrix():Vector.<Vector.<int>>
    {
        return _matrix;
    }

    public function trim():Boolean
    {
        return PatternUtils.trim(this);
    }

    public function get id():uint
    {
        return _id;
    }

    public function updateMatrix(matrix:Vector.<Vector.<int>>):Boolean
    {
        if(!matrix || !matrix.length || !matrix[0].length)
                return false;

        _matrix = matrix;
        _rows = _matrix.length;
        _cols = _matrix[0].length;
        _points = null;

        return true;
    }

    public function setName(name:String):void
    {
        _name = name;
    }

    public function get name():String
    {
        return _name;
    }

    public function get rotation():int
    {
        return _rotation;
    }

    public function getCell(r:int, c:int):Cell
    {
        return new Cell(getValue(r,c), r, c)
    }

    public function getValue(r:int, c:int):int
    {
        return _matrix[r][c]
    }
}
}
