/*
کلاس پترن مشخص کننده ماتریس جدول و ماتریس پترن های تعریف شده در بازی است
این کلاس توابعی برای دسترسی و ویرایش و مقایسه پترن ها ارائه می دهد
 */
package tables
{
import Model.Matrix;

import flash.events.Event;

import utilities.pattern.PatternUtils;

public class Pattern extends Matrix
{
    private static var _lastId:int = 0;

    private var _id:int;
    private var _name:String;
    private var _rotation:int;
    private var _points:Vector.<Cell>;
    private var _firstRowPoints:Vector.<Cell>;

    private static var _pool:Vector.<Pattern> = new <Pattern>[];
    private static var _len:int = 0;
    private static var _fromPool:Boolean = false;

    private static var _numbers:int = 0;

    //=================== Constructor
    public function Pattern(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null, name:String = null, rotation:int = 0)
    {
        _numbers++;
        trace("new Pattern", _numbers);
        super(numOfRows, numOfCols, vector2D, _fromPool);

        if (!_fromPool)
            throw new Error("For Create new Pattern, use Pattern.fromPool");

        /*
        if (!_fromPool)
            throw new Error("For Create new Pattern, use Pattern.fromPool");

        super(numOfRows, numOfCols, vector2D, true);
        */

        _lastId++;
        _id = _lastId;
        _name = name;
        _rotation = rotation;

        this.addEventListener(Matrix.UPDATED, onUpdate)
    }

    private function onUpdate(event:Event):void
    {
        removePoints();
        _firstRowPoints = null;
    }

    private function removePoints():void
    {
        if(_points == null)
                return;

        var len:int = _points.length;

        while (len)
        {
            _points.pop().dispose();
            len--
        }

        _points = null;
    }

    public static function randomValue(numOfRows:int, numOfCols:int, rangeFrom:int = 0, rangeTo:int = 9, name:String = null, rotation:int = 0):Pattern
    {
        var vector:Vector.<int> = Matrix.randomVector(numOfRows, numOfCols, rangeFrom, rangeTo);
        return fromPool(numOfRows, numOfCols, vector, name, rotation)
    }

    public function copy():Pattern
    {
        return fromPool(rows, cols, vector, name, rotation)
    }

    ///////////////////// Pooling ///////////////////////
    public override function dispose():void
    {
        removePoints()
        _firstRowPoints = null;

        _pool[_len] = this;
        _len++;

        this.removeEventListener(Matrix.UPDATED, onUpdate)
    }

    public static function fromPool(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null, name:String = null, rotation:int = 0):Pattern
    {
        if(_len)
        {
            _len --;
            _pool[_len].update(numOfRows, numOfCols, vector2D, name, rotation);
            _pool[_len].addEventListener(Matrix.UPDATED, _pool[_len].onUpdate);
            return _pool[_len];
        }
        else
        {
            _fromPool = true;
            return new Pattern(numOfRows, numOfCols, vector2D, name, rotation);
        }
    }


    //=============== update
    public function update(numOfRows:int, numOfCols:int, vector2D:Vector.<int> = null, name:String = null, rotation:int = 0):void
    {
        updateMatrix(numOfRows, numOfCols, vector2D);
        _name = name;
        _rotation = rotation;
    }

    //=============== print
    public override function print():void
    {
        trace("pattern name:", name, "rotation:", rotation, "id:", id);
        super.print();
        trace("-----------------");
    }

    //=================== Filled Cells(Points)
    //All Points
    public function get points():Vector.<Cell>
    {
        if(_points == null)
        {
            _points = new Vector.<Cell>();

            for(var r:int = 0; r<rows; r++)
            {
                for(var c:int = 0; c<cols; c++)
                {
                    var val:int = getValue(r, c);
                    if(val != 0)
                        _points.push(Cell.fromPool(r, c, val));
                }
            }

        }

        return _points;
    }

    //All Points in First Row
    public function get firstRowCells():Vector.<Cell>
    {
        if(_firstRowPoints == null)
        {
            _firstRowPoints = new Vector.<Cell>();

            for(var i:int=0; i<cols; i++)
            {
                if(points[i].col == 0)
                    _firstRowPoints.push(points[i])
            }
        }

        return _firstRowPoints
    }

    //=================== remove zero rows and cols from sides
    public function trim():Boolean
    {
        return PatternUtils.trim(this);
    }

    ////////////////////////////////////// Getter / Setter
    public function get name():String
    {
        return _name;
    }

    public function get rotation():int
    {
        return _rotation;
    }

    public function get id():int
    {
        return _id;
    }
}
}
