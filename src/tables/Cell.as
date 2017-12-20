package tables
{
public class Cell
{
    public var value:int;
    public var row:uint;
    public var col:uint;

    public function Cell(value:int = 0, row:uint = 0, col:uint = 0)
    {
        this.value = value;
        this.row = row;
        this.col = col;
    }
}
}
