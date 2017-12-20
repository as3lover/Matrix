package uitiliti
{
import tables.Cell;
import tables.Pattern;

public class Utils
{
    public function Utils()
    {
    }

    public static function tracePattern(pattern:Pattern):void
    {
        pattern.print();
    }

    public static function searchPattern(small:Pattern, big:Pattern):Boolean
    {
        var points = small.points;
        var table = big.matrix;

        var maxCol = big.cols - small.cols;
        var maxRow = big.rows - small.rows ;

        var length = points.length;

        var r:uint;
        var c:uint;

        //trace("maxRow", maxRow, "maxCol", maxCol, "length", length)

        for(var row:int = 0; row < maxRow; row++)
        {
            for(var col:int = 0; col < maxCol; col++)
            {
                var value:int = -1;
                if (length)
                {
                    r = points[0][0];
                    c = points[0][1];
                    value = table[r+row][c+col]
                }
                for(var i:int = 1; i < length; i++)
                {
                    r = points[i][0];
                    c = points[i][1];

                    if(table[r+row][c+col] != value)
                    {
                        break
                    }
                    else if(i == length -1)
                    {
                        //trace("Found:", row, col);
                        var n = Pattern.random(big.rows, big.cols, 0, 0);

                        for(i = 0; i<length; i++)
                        {
                            r = points[i][0];
                            c = points[i][1];
                            n.setValue(value, r+row, c+col);
                        }
                        //big.print();
                        //n.print();
                        //return new Cell(0,row,col)
                        return true
                    }
                }
            }
        }

        return false
    }
}
}
