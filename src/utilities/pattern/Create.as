package utilities.pattern
{
import Model.MatrixVector;
import Model.Pattern;

internal class Create
{
    /////////////////////////////// INTERNAL ////////////////////////
    internal static function createFrom2DArrays(list:Vector.<Array>, names:Vector.<String> = null):Vector.<Pattern>
    {
        var length:int = list.length;
        var allPatterns:Vector.<Pattern> = new Vector.<Pattern>();

        if(!names && names.length < length)
            names = null;

        var name:String;

        for(var i:int=0; i<length; i++)
        {
            if(names)
                name = names[i];

            var pat:Pattern = getPattern(list[i], true, name);

            var pats:Vector.<Pattern> = patternTo4(pat);
            allPatterns = allPatterns.concat(pats);
        }

        return allPatterns;
    }

    /////////////////////////////// private ////////////////////////
    private static function getPattern(p:Array, trim:Boolean = false, name:String = null, rotation:int = 0):Pattern
    {
        var mv:MatrixVector = Convert2dArrayToVector(p);

        var pattern:Pattern = Pattern.fromPool(mv.rows, mv.cols, mv.vector, name, rotation);
        if(trim)
            pattern.trim();
        return pattern;
    }

    private static function Convert2dArrayToVector(pattern:Array):MatrixVector
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

        var len:int = maxCols * rows;

        var vector:Vector.<int> = new Vector.<int>(len);

        try
        {
            for(var r:int = 0; r<rows; r++)
            {
                cols = pattern[r].length;
                for(var c:int=0; c<cols; c++)
                {
                    vector[r*maxCols + c] = pattern[r][c];
                }
            }

            var matrixVector:MatrixVector = new MatrixVector(vector, rows, maxCols);
            return matrixVector
        }
        catch (e:Error)
        {
            throw(e);
        }

    }

    private static function patternTo4(p1:Pattern):Vector.<Pattern>
    {

        var p:Vector.<Pattern> = new Vector.<Pattern>();
        p.push(p1);

        var p2:Pattern = rotatePattern(p1, 90);
        p.push(p2);

        var p3:Pattern = rotatePattern(p2, 180);
        p.push(p3);

        var p4:Pattern = rotatePattern(p3, 270);
        p.push(p4);


        for(var i:int=3; i>-1; i--)
        {
            for(var j:int=i-1; j>-1; j--)
            {
                if(PatternUtils.comparePatterns(p[i],p[j]))
                {
                    var last:Pattern = p.pop();
                    if(i < p.length)
                    {
                        p[i].dispose();
                        p[i] = last
                    }
                    else
                    {
                        last.dispose();
                    }
                    break;
                }
            }
        }

        return p;
    }

    private static function rotatePattern(p:Pattern, rotation:int = 0):Pattern
    {
        var copy:Vector.<int> = new Vector.<int>(p.length);

        var i:int = 0;
        for(var c:int=0; c < p.cols; c++)
        {
            for(var r:int = p.rows-1; r>-1; r--)
            {
                copy[i] = p.getValue(r, c);
                i++;
            }
        }


        return Pattern.fromPool(p.cols, p.rows, copy, p.name, rotation);
    }

}
}
