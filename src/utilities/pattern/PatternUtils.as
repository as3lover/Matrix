package utilities.pattern
{
import Model.Cell;
import Model.MatrixVector;
import Model.Pattern;

import view.Table;

public class PatternUtils
{

    public static function trim(p:Pattern):Boolean
    {
        return Trim.trim(p);
    }

    public static function searchPatternInTable(table:Table, pattern:Pattern, startCell:Cell = null, endCell:Cell = null):Object
    {
        return Compare.searchPatternInTable(table, pattern, startCell, endCell);
    }

    public static function comparePatterns(big:Pattern, small:Pattern):Object
    {
        return Compare.compareTowPatterns(big, small);
    }

    public static function createFrom2DArrays(list:Vector.<Array>, names:Vector.<String> = null):Vector.<Pattern>
    {
        return Create.createFrom2DArrays(list, names)
    }




}
}
