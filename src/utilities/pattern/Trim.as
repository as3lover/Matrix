package utilities.pattern
{
import Model.Pattern;

internal class Trim
{
    internal static function trim(p:Pattern):Boolean
    {
        return false
        /*
        var matrix:Vector.<Vector.<int>> = p.copyMatrix();

        matrix = trimUp(matrix);
        matrix = trimDown(matrix);
        matrix = trimRight(matrix);
        matrix = trimLeft(matrix);

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
        */
    }

    private static function trimUp(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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

    private static function trimDown(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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

    private static function trimLeft(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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

    private static function trimRight(m:Vector.<Vector.<int>>):Vector.<Vector.<int>>
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
}
}
