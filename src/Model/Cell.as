package tables
{
public class Cell
{
    private static var _pool:Vector.<Cell> = new <Cell>[];
    private static var len:int = 0;
    private static var _fromPool:Boolean = false;

    public var row:int;
    public var col:int;
    public var value:int;

    public function Cell(row:int = 0, col:int = 0, value:int = 0)
    {
        if (!_fromPool)
            throw new Error("For Create new Cell, use Cell.fromPool");

        this.row = row;
        this.col = col;
        this.value = value;

        _fromPool = false;
    }

    public function dispose():void
    {
        _pool[len] = this;
        len++;
    }

    public static function fromPool(row:int = 0, col:int = 0, value:int = 0):Cell
    {
        if(len)
        {
            len --;
            _pool[len].row = row;
            _pool[len].col = col;
            _pool[len].value = value;
            return _pool[len];
        }
        else
        {
            _fromPool = true;
            return new Cell(row, col, value);
        }
    }
}

}
