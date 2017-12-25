package view
{
import Model.Config;
import Model.Matrix;

import flash.display.Sprite;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import Model.Cell;
import Model.Pattern;
import utilities.pattern.PatternUtils;

public class Table extends Sprite
{
    public static const colors:Vector.<int> = new <int>[0xff0000, 0xfff600, 0x00c0ff, 0x00ff1e, 0x4800ff, 0xf08aff, 0x3c241b];
    public static const colorNum:int = colors.length;

    private var _pattern:Matrix;
    private var _objList:Vector.<Vector.<Candy>>;
    private var moving:Boolean;
    private var _timeOut:int;
    private var _creating:Boolean;
    private var _patternList:Vector.<Pattern>;
    private var _rows:int;
    private var _cols:int;

    public function Table(patternList:Vector.<Pattern>)
    {
        super();

        _patternList = patternList
    }

    public function start(tablePattern:Matrix):void
    {
        if(_creating)
        {
            return;
        }
        else if(moving)
        {
            clearTimeout(_timeOut);
            _timeOut = setTimeout(start, 10, tablePattern);
            return;
        }

        moving = true;

        _rows = tablePattern.rows;
        _cols = tablePattern.cols;

        if(_objList)
        {
            for(var r:int=0; r < _rows; r++)
            {
                for(var c:int=0; c < _cols; c++)
                {
                    var object:Candy = obj(r,c);
                    if(object)
                    {
                        var time:Number = (r * _cols + c)/900;
                        object.hide({delay:time});
                    }

                }
            }

            _pattern.dispose();

            _creating = true;
            clearTimeout(_timeOut);
            _timeOut = setTimeout(create, (time+1)*1000, tablePattern)

        }
        else
        {
            _creating = true;

            clearTimeout(_timeOut);
            _timeOut = setTimeout(create, 0, tablePattern)
        }
    }

    private function create(matrix:Matrix):void
    {
        matrix.print();

        x = y = 25;

        _pattern = matrix;

        while(numChildren)
            removeChildAt(0);

        graphics.clear();

        graphics.lineStyle(0);
        var w:int = Config.CELL_WIDTH;
        var h:int = Config.CELL_HEIGHT;

        for(var r:int=0; r<matrix.rows; r++)
        {
            for(var c:int=0; c<matrix.cols; c++)
            {
                graphics.drawRect(-w/2 + c*w, -h/2 + r*h, w, h);
            }
        }

        draw();
    }

    private function draw():void
    {
        var w:int = Config.CELL_WIDTH;
        var h:int = Config.CELL_HEIGHT;
        var rows:int =  pattern.rows;
        var cols:int =  pattern.cols;

        _objList = new <Vector.<Candy>>[];

        for(var r:int=0; r<rows; r++)
        {
            var row:Vector.<Candy>= new Vector.<Candy>();
            _objList.push(row);
            for(var c:int=0; c<cols; c++)
            {
                var value:int = pattern.getValue(r,c);
                if(value > 0)
                {
                    var obj:Candy = Candy.fromPool(w,h,getColor(value-1));
                    obj.x = c * w;
                    obj.y = r * h;
                    row.push(obj);
                    addChild(obj);
                }
                else
                {
                    row.push(null);
                }
            }
        }

        setTimeout(falseMoving, 1000)
    }

    private function falseMoving():void
    {
        moving = false;
        _creating = false;

        if(!search(false))
        {
            var pattern:Pattern = Pattern.randomValue(_rows, _cols, 0, 6);
            start(pattern);
            return;
        }
    }

    private static function getColor(index:int):int
    {
        if(index >= colorNum || index < 0)
        {
            trace("Error: COLOR INDEX");
            return 0xffffff
        }

        return colors[index]
    }

    public function get pattern():Matrix
    {
        return _pattern;
    }

    public function exist(pat:Pattern, remove:Boolean):Boolean
    {
        var place:Object = PatternUtils.searchPatternInTable(this, pat);

        if(place)
        {
            if(remove)
                this.remove(place, pat);
            return true;
        }

        return false
    }

    private function remove(place:Object, pat:Pattern):void
    {
        moving = true;
        _creating = true;

        trace(place.row, place.col, pat.rotation, pat.name, getTimer() - Main.time);

        var points:Vector.<Cell> = pat.points;
        var len:int = points.length;

        for(var i:int=0; i<len; i++)
        {
            var r:int = place.row + points[i].row;
            var c:int = place.col + points[i].col;

            pattern.setValue(0, r, c);
            if(pattern.getValue(r,c) != 0)
                trace("Error", r, c);

            var obj:Candy = this.obj(r,c);
            if(obj)
            {
                this._objList[r][c] = null;
                obj.hide();
            }
            else
            {
                trace("Error: No obj")
            }
        }

        setTimeout(falseMoving, 1000)

    }

    private function obj(row:int, col:int):Candy
    {
        if(row < _objList.length && col<_objList[0].length)
        {
            return _objList[row][col];
        }

        trace("ERROR get obj index");
        return null;
    }

    public function get creating():Boolean
    {
        return _creating;
    }

    public function click():Boolean
    {
        if(creating)
            return false;

        if(search(true))
        {
            trace("Matched")
            return true;
        }
        else
        {
            trace("Not Match");
            _creating = true;
            return false
        }
    }

    private function search(remove:Boolean):Boolean
    {
        var len:int = _patternList.length;

        for (var i:int = 0; i < len; i++)
        {
            if(exist(_patternList[i], remove))
            {
                return true;
            }
        }

        return false
    }
}
}
