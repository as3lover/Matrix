package view
{
import Model.Config;

import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import tables.Cell;
import tables.Pattern;
import uitiliti.PatternUtils;

public class Table extends Sprite
{
    private var _pattern:Pattern;
    private var objs:Vector.<Vector.<Candy>>;
    public static const colors:Vector.<uint> = new <uint>[0xff0000, 0xfff600, 0x00c0ff, 0x00ff1e, 0x4800ff, 0xf08aff, 0x3c241b];
    public static const colorNum:int = colors.length;
    private var moving:Boolean;
    private var timeOut:uint;

    public function Table()
    {
    }

    public function start(pattern:Pattern)
    {

        if(moving == true)
        {
            clearTimeout(timeOut);
            timeOut = setTimeout(start, 10, pattern)
        }

        moving = true;

        if(objs)
        {
            var rows:int = this.pattern.rows;
            var cols:int = this.pattern.cols;

            trace(rows, cols);


            for(var r:int=0; r<rows; r++)
            {
                for(var c:int=0; c<cols; c++)
                {
                    var object = obj(r,c);
                    if(object)
                    {
                        var time:Number = (r*cols + c)/900;
                        trace(time)
                        object.hide({delay:time});
                    }

                }
            }

            clearTimeout(timeOut)
            timeOut = setTimeout(create, (time+1)*1000, pattern)

        }
        else
        {
            clearTimeout(timeOut);
            timeOut = setTimeout(create, 0, pattern)
        }
    }

    private function create(pattern:Pattern):void
    {
        pattern.print();

        x = y = 25;

        _pattern = pattern;

        while(numChildren)
            removeChildAt(0);

        graphics.clear();

        graphics.lineStyle(0);
        var w:int = Config.CELL_WIDTH;
        var h:int = Config.CELL_HEIGHT;

        for(var r:int=0; r<pattern.rows; r++)
        {
            for(var c:int=0; c<pattern.cols; c++)
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

        objs = new <Vector.<Candy>>[];

        for(var r:int=0; r<rows; r++)
        {
            var row:Vector.<Candy>= new Vector.<Candy>();
            objs.push(row);
            for(var c:int=0; c<cols; c++)
            {
                var value:int = pattern.getValue(r,c);
                if(value > 0)
                {
                    var obj:Candy = new Candy(w,h,getColor(value-1));
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

        moving = false;
    }

    private static function getColor(index:int):uint
    {
        if(index >= colorNum || index < 0)
        {
            trace("Error: COLOR INDEX");
            return 0xffffff
        }

        return colors[index]
    }

    public function get pattern():Pattern
    {
        return _pattern;
    }

    public function exist(pat:Pattern):Boolean
    {
        var table:Pattern = this.pattern;

        var place:Object = PatternUtils.searchPattern(table, pat);

        if(place)
        {
            trace(place.row, place.col, pat.rotation, pat.name);

            var points:Vector.<Cell> = pat.points;
            var len:int = points.length;

            for(var i:int=0; i<len; i++)
            {
                var r:uint = place.row + points[i].row;
                var c:uint = place.col + points[i].col;
                table.setValue(0, r, c);
                if(table.getValue(r,c) != 0)
                        trace("Error", r, c);

                var obj:Candy = this.obj(r,c);
                if(obj)
                {
                    this.objs[r][c] = null;
                    obj.hide();
                }
                else
                {
                    trace("Error: No obj")
                }
            }

           // _pattern.print()

            return true;
        }

        return false
    }

    private function obj(row:uint, col:uint):Candy
    {
        if(row < objs.length && col<objs[0].length)
        {
            return objs[row][col];
        }

        trace("ERROR get obj index");
        return null;
    }
}
}
