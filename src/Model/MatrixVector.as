package Model
{
public class MatrixVector
{
    public var vector:Vector.<int>;
    public var rows:int;
    public var cols:int;

    public function MatrixVector(vector:Vector.<int>, rows:int, cols:int)
    {
        this.vector = vector;
        this.rows = rows;
        this.cols = cols;
    }
}
}
