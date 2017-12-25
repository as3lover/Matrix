package utilities.pattern
{
import Model.Matrix;
import Model.Cell;
import Model.Pattern;
import view.Table;

internal class Compare
{
    public function Compare()
    {
    }

    //////////////////////// INTERNAL ////////////////////////////
     internal static function searchPatternInTable(table:Table, pattern:Pattern, startCell:Cell = null, endCell:Cell = null):Object
    {
        return searchSmallPatternInBiggerPattern(table.pattern, pattern, startCell, endCell);
    }

    internal static function compareTowPatterns(big:Pattern, small:Pattern):Object
    {
        if (big.rows < small.rows || big.cols < small.cols)
        {
            return searchSmallPatternInBiggerPattern(small, big);
        }
        else
        {
            return searchSmallPatternInBiggerPattern(big, small);
        }
    }

    //////////////////////// PRIVATE ////////////////////////////
    private static function searchSmallPatternInBiggerPattern(big:Matrix, pattern:Pattern, startCell:Cell = null, endCell:Cell = null):Object
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

        var cell:Cell = searchSinglePattern(big, pattern, startR, startC, endR, endC);

        if(cell != null)
        {
            var obj:Object = {pattern:pattern, row:cell.row, col:cell.col};
            cell.dispose();
            return(obj)
        }

        return null
    }

    private static function searchSinglePattern(big:Matrix, small:Pattern, firstRow:int, firstCol:int, lastRow:int, lastCol:int):Cell
    {
        ////trace('start');
        //big.print();
        //small.print();

        if(big.rows < small.rows || big.cols < small.cols)
            return null;

        var points:Vector.<Cell> = small.points;

        var maxCol:int = big.cols - small.cols;
        var maxRow:int = big.rows - small.rows ;

        var length:int = points.length;

        if(!length)
        {
            trace("Error: Pattern no point");
            return null
        }

        var r:int;
        var c:int;

        //trace("maxRow", maxRow, "maxCol", maxCol, "length", length, small.name)

        maxCol = Math.min(maxCol, lastCol);
        maxRow = Math.min(maxRow, lastRow);

        for(var row:int = firstRow; row <= maxRow; row++)
        {
            //trace('row', row)
            for(var col:int = firstCol; col <= maxCol; col++)
            {
                //trace('col', col);
                var value:int = int.MIN_VALUE;

                r = points[0].row;
                c = points[0].col;

                value = big.getValue(r+row, c+col);

                if(value == 0)
                {
                    //trace('table[r+row][c+col == 0', 'r', r,'c', c,'col', col, 'row', row, 'r+row', r+row, 'r+col', r+col);
                    continue;
                }

                for(var i:int = 0; i < length; i++)
                {
                    r = points[i].row;
                    c = points[i].col;

                    if(big.getValue(r+row, c+col) != value)
                    {
                        //trace("خروج از حلقه داخلی");
                        break
                    }
                    else if(i == length -1)
                    {
                        return Cell.fromPool(row,col)
                    }

                }
            }
        }

        return null
    }


    /*
    internal static function searchPatterns(big:Pattern, small:Vector.<Pattern>, startCell:Cell, endCell:Cell):Object
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

        var length:int = small.length;
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
*/
}
}
