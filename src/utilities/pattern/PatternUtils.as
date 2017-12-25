package uitiliti
{
import tables.Cell;
import tables.Pattern;

public class PatternUtils
{

    public static function trim(p:Pattern):Boolean
    {
        var matrix:Vector.<Vector.<int>> = p.copyMatrix();

        matrix = PatternUtils.trimUp(matrix);
        matrix = PatternUtils.trimDown(matrix);
        matrix = PatternUtils.trimRight(matrix);
        matrix = PatternUtils.trimLeft(matrix);

        var r:int = p.rows;
        var c:int = p.cols;

        var rows:int = matrix.length;
        var cols:int = matrix.length;

        if(rows)
            cols = matrix[0].length;
        else
            cols = 0;

        var trimmed:Boolean = (r != rows || c != cols);
        if(trimmed)
            return p.updateMatrix(matrix);

        return trimmed;
    }

    public static function trimUp(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;

        for(var i:int = 0; i<m[0].length; i++)
        {
            if(m[0][i] != 0)
                return m;
            else if(i == m[0].length -1)
            {
                var m2:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
                for(var r:int = 1; r<m.length; r++)
                {
                    m2.push(m[r])
                }
                return trimUp(m2)
            }
        }

        return m;
    }

    public static function trimDown(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(m.length == 0)
            return m;

        for(var i:int = 0; i<m[0].length; i++)
        {
            if(m[m.length-1][i] != 0)
                return m;
            else if(i == m[0].length -1)
            {
                var m2:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
                for(var r:int = 0; r<m.length-1; r++)
                {
                    m2.push(m[r])
                }
                return trimDown(m2)
            }
        }

        return m;
    }

    public static function trimLeft(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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
                var m2:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
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

    public static function trimRight(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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
                var m2:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
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

    public static function copyMatrix(matrix:Vector.<Vector.<int>>):Vector.<Vector.<int>>
    {
        if(!matrix || !matrix.length || !matrix[0].length)
                return null;

        var rows:int = matrix.length;
        var cols:int = matrix[0].length;

        var copy:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

        for(var r:int = 0; r < rows; r++)
        {
            var row:Vector.<int> = new Vector.<int>(cols);
            copy.push(row);

            for(var c:int = 0; c < cols; c++)
            {
                copy[r][c] = matrix[r][c]
            }
        }

        return copy;
    }

    public static function tracePattern(pattern:Pattern):void
    {
        var line1:String = "";
        var line2:String = "";
        for (var i:int = 0; i<pattern.cols*2; i++)
        {
            line1 += "-";
            line2 += "-"
        }

        if(pattern.name)
            trace("--", pattern.name, "--");
        else
            trace(line1);

        trace("rotation:", pattern.rotation);
        trace("id:", pattern.id);

        for(i = 0; i<pattern.rows; i++)
            trace(pattern.matrix[i]);

        trace(line2);
    }

    public static function searchPatterns(big:Pattern, small:Vector.<Pattern>, startCell:Cell = null, endCell:Cell = null):Object
    {
        var startR:int;
        var startC:int;

        var endR:int;
        var endC:int;

        if(startCell)
        {
            startR = startCell.row;
            startC = startCell.col;
        }
        else
        {
            startR = 0;
            startC = 0;
        }

        if(endCell)
        {
            endR = endCell.row;
            endC = endCell.col;
        }
        else
        {
            endR = big.rows;
            endC = big.cols;
        }

        var length:uint = small.length;
        for(var i:int = 0; i<length; i++)
        {
            //trace(i);
            var cell:Cell = searchSinglePattern(big, small[i], startR, startC, endR, endC);
            if(cell != null)
            {
                return({pattern:small[i], row:cell.row, col:cell.col})
            }
        }

        return null
    }

    public static function searchPattern(big:Pattern, small:Pattern, startCell:Cell = null, endCell:Cell = null):Object
    {
        var startR:int;
        var startC:int;

        var endR:int;
        var endC:int;

        if(startCell)
        {
            startR = startCell.row;
            startC = startCell.col;
        }
        else
        {
            startR = 0;
            startC = 0;
        }

        if(endCell)
        {
            endR = endCell.row;
            endC = endCell.col;
        }
        else
        {
            endR = big.rows;
            endC = big.cols;
        }


        var cell:Cell = searchSinglePattern(big, small, startR, startC, endR, endC);
        if(cell != null)
        {
            return({pattern:small, row:cell.row, col:cell.col})
        }

        return null
    }

    private static function searchSinglePattern(big:Pattern, small:Pattern, firstRow:uint, firstCol:uint, lastRow:uint, lastCol:uint):Cell
    {
        ////trace('start');
        //big.print();
        //small.print();

        var points = small.points;
        var table = big.matrix;

        var maxCol = big.cols - small.cols;
        var maxRow = big.rows - small.rows ;

        var length = points.length;

        if(!length)
        {
            trace("Error: Pattern no point");
            return null
        }

        var r:uint;
        var c:uint;

        //trace("maxRow", maxRow, "maxCol", maxCol, "length", length, small.name)

        for(var row:int = 0; row <= maxRow; row++)
        {
            //trace('row', row)
            for(var col:int = 0; col <= maxCol; col++)
            {
                //trace('col', col)
                var value:int = -1;

                r = points[0].row;
                c = points[0].col;
                value = table[r+row][c+col];

                if(value == 0)
                {
                    //trace('table[r+row][c+col == 0', 'r', r,'c', c,'col', col, 'row', row, 'r+row', r+row, 'r+col', r+col);
                    continue;
                }

                //trace("start value", value);

                for(var i:int = 0; i < length; i++)
                {
                    r = points[i].row;
                    c = points[i].col;

                    //trace(r+row , c+col, table[r+row][c+col]);


                    if(table[r+row][c+col] != value)
                    {
                        //trace("خروج از حلقه داخلی");
                        break
                    }

                    else if(i == length -1)
                    {
                        //trace("Found:", row, col);
                        var n = Pattern.random(big.rows, big.cols, 0, 0);

                        for(var j:int = 0; j<length; j++)
                        {
                            r = points[j].row;
                            c = points[j].col;
                            n.setValue(value, r+row, c+col);
                        }
                        //big.print();
                        //n.print();
                        ////trace('ok')
                        return new Cell(0,row,col)
                        //return true
                    }
                }
            }
        }

        ////trace('no')
        return null
    }

    public static function arrayToVector(pattern:Array):Vector.<Vector.<int>>
    {
        if(!pattern || !pattern.length || !pattern[0].length)
            return null;

        var rows:int = pattern.length;
        var cols:int ;
        var maxCols:int = 0;

        for(var i:int=0; i<rows; i++)
        {
            maxCols = Math.max(pattern[i].length,maxCols);
        }

        var matrix:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(rows);

        try
        {
            for(var r:int = 0; r<rows; r++)
            {
                cols = pattern[r].length;
                var row:Vector.<int> = new Vector.<int>(cols);
                matrix[r] = row;
                for(var c:int=0; c<maxCols; c++)
                {
                    if(c<cols)
                        row[c] = pattern[r][c];
                    else
                        row[c] = 0;
                }
            }

            return matrix
        }
        catch (e)
        {
            //trace(e);
        }

        return  new Vector.<Vector.<int>>[new Vector.<int>()];
    }
}
}
