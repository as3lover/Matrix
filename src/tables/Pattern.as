/*
کلاس پترن مشخص کننده ماتریس جدول و ماتریس پترن های تعریف شده در بازی است
این کلاس توابعی برای دسترسی و ویرایش و مقایسه پترن ها ارائه می دهد
 */
package tables
{
public class Pattern
{
    private var _matrix:Vector.<Vector.<int>>;
    private var _rows:uint;
    private var _cols:uint;
    private var _points:Vector.<Array>;
    private var _firstRowPoints:Vector.<Array>;

    //var matrix:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[1,2,3,4], new <int>[1,2,3,4]];

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
                /*
                if(Math.random() > 0.89)
                    row.push(1);
                else
                    row.push(0)
                 */
            }

            matrix.push(row);
        }

        return new Pattern(0,0,matrix);
    }

    public function Pattern(numOfRows:uint, numOfCols:uint, matrix:Vector.<Vector.<int>> = null)
    {
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
    }

    public function print():void
    {
        var line1:String = "";
        var line2:String = "";
        for (var i:int = 0; i<cols*2; i++)
        {
            line1 += "=";
            line2 += "-"
        }
        trace(line1);

        for(i = 0; i<rows; i++)
            trace(_matrix[i]);

        trace(line2);
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
        if(errorRow(row) || errorLength(rowVector))
            return;

        //_matrix[row] = rowVector;
        setSubRow(rowVector, row, 0, cols, 0);
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
        var matrix:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

        for(var r:int = 0; r< rows; r++)
        {
            var row:Vector.<int> = new Vector.<int>(cols);
            matrix.push(row);

            for(var c:int = 0; c < cols; c++)
            {
                matrix[r][c] = _matrix[r][c]
            }
        }

        return matrix;
    }

    public function setCell(cell:Cell, value:int = -9876543210):void
    {
        if(value = -9876543210)
                value = cell.value;

        setValue(value, cell.row, cell.col);
    }

    private function calculatePoints():void
    {
        var points:Vector.<Array> = new Vector.<Array>();

        for(var r:int = 0; r<rows; r++)
        {
            for(var c:int = 0; c<cols; c++)
            {
                var val:int = _matrix[r][c];
                if(val != 0)
                    points.push([r,c])
            }
        }

        _points = points;
    }

    public function get firstRowPoints():Vector.<Array>
    {
        if(_firstRowPoints == null)
        {
            _firstRowPoints = new Vector.<Array>();
            var list:Vector.<Array> = points;

            for(var i:int=0; i<cols; i++)
            {
                if(list[i][0] == 0)
                        _firstRowPoints.push(list[i])
            }
        }

        return _firstRowPoints
    }


    public function get points():Vector.<Array>
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
        _matrix = trimUp(_matrix);
        _matrix = trimDown(_matrix);
        _matrix = trimRight(_matrix);
        _matrix = trimLeft(_matrix);

        var r = rows;
        var c = cols
        _rows = _matrix.length;
        if(_rows)
            _cols = _matrix[0].length;
        else
            _cols = 0;

        if(r != rows || c != cols)
                return true;
        else
                return false
    }

    private function trimUp(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;

        for(var i:int = 0; i<m[0].length; i++)
        {
            if(m[0][i] != 0)
                return m;
            else if(i == m[0].length -1)
            {
                var m2 = new Vector.<Vector.<int>>();
                for(var r:int = 1; r<m.length; r++)
                {
                    m2.push(m[r])
                }
                return trimUp(m2)
            }
        }

        return m;
    }

    private function trimDown(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;

        for(var i:int = 0; i<m[0].length; i++)
        {
            if(m[m.length-1][i] != 0)
                return m;
            else if(i == m[0].length -1)
            {
                var m2 = new Vector.<Vector.<int>>();
                for(var r:int = 0; r<m.length-1; r++)
                {
                    m2.push(m[r])
                }
                return trimDown(m2)
            }
        }

        return m;
    }

    private function trimLeft(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;
        if(m[0].length == 0)
            return m;

        for(var i:int = 0; i<m.length; i++)
        {
            if(m[i][0] != 0)
                return m;
            else if(i == m.length -1)
            {
                var m2 = new Vector.<Vector.<int>>();
                for(var r:int = 0; r<m.length; r++)
                {
                    var row:Vector.<int> = new Vector.<int>();
                    for(var c:int = 1; c<m[0].length; c++)
                    {
                        row.push(m[r][c]);
                    }
                    m2.push(row)
                }
                return trimLeft(m2)
            }
        }

        return m;
    }

    private function trimRight(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;
        if(m[0].length == 0)
            return m;

        for(var i:int = 0; i<m.length; i++)
        {
            if(m[i][m[0].length-1] != 0)
                return m;
            else if(i == m.length -1)
            {
                var m2 = new Vector.<Vector.<int>>();
                for(var r:int = 0; r<m.length; r++)
                {
                    var row:Vector.<int> = new Vector.<int>();
                    for(var c:int = 0; c<m[0].length-1; c++)
                    {
                        row.push(m[r][c]);
                    }
                    m2.push(row)
                }
                return trimRight(m2);
            }
        }

        return m;
    }

}
}
