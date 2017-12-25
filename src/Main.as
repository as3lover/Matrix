package {

import Model.Matrix;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getTimer;

import net.hires.debug.Stats;

import Model.Pattern;
import utilities.pattern.PatternUtils;

import view.Table;

[SWF(width="400", height="400", backgroundColor="0xffffff", frameRate="60")]

public class Main extends Sprite
{
    private var _txt:TextField;
    private var _patterns:Vector.<Pattern>;
    private var _table:Table;
    private var status:Stats;

    //Temp
    private static var _time:int;
    private static var sum:int = 0;
    private static var nums:int = 0;

    public function Main()
    {
        status = new Stats();
        addChild(status);

        _txt = new TextField();
        _txt.x = 200;
        _txt.multiline = true;
        _txt.wordWrap = true;
        _txt.width = _txt.height = 200;
        addChild(_txt);

        creatPatterns();

        _table = new Table(_patterns);
        addChild(_table);

        var pattern:Matrix = Matrix.randomMatrix(15,15,0,6);
        _table.start(pattern);

        stage.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(event:MouseEvent):void
    {
        setChildIndex(_txt, numChildren-1);
        setChildIndex(status, numChildren-1);

        _time = getTimer();

        if(_table.click())
        {
            var t:int = getTimer() - time;
            _txt.text =_txt.text + "\t" + String(t);

            sum += t;
            nums++;

            trace("Avrage:", sum/nums);
        }

    }

    private function creatPatterns():void
    {
        var list:Vector.<Array> = new Vector.<Array>();

        //صلیبی هفت تایی
        list.push([
            [1,1,1,1,1],
            [0,0,1,0,0],
            [0,0,1,0,0]
        ]);
        //صلیبی شش تایی
        list.push([
            [1,1,1,1,1],
            [0,0,1,0,0]
        ]);

        // پنج تایی
        list.push([
            [1,1,1,1,1]
        ]);

        //چهارتایی
        list.push([
            [1,1,1,1]
        ]);

        //مربعی
        list.push([
            [1,1],
            [1,1]
        ]);

        //زاویه ای
        list.push([
            [1,1,1],
            [1,0,0],
            [1,0,0]
        ]);

        //تی شکل
        list.push([
            [1,1,1],
            [0,1,0],
            [0,1,0]
        ]);

        //سه تایی
        list.push([
            [1,1,1]
        ]);

        var names:Vector.<String> = new <String>[
            "صلیبی هفت تایی",
            "صلیبی شش تایی",
            "پنج تایی",
            "چهارتایی",
            "مربعی",
            "زاویه ای",
            "تی شکل",
            "سه تایی"
        ];

        _patterns = PatternUtils.createFrom2DArrays(list, names);
/*
        var p:Pattern = _patterns[0];
        p.updateMatrix(p.rows, p.cols, p.vector);

        var p2:Array = [
            [1,0,0],
            [0,1,0],
            [0,0,1]
        ];
        addPattern(p2,"مورب");

        var p3:Array = [
            [1,1],
            [1,0]
        ];
        addPattern(p3,"سه گوش");
*/
        /*
        var length:int = _patterns.length;
        for(var i:int=0; i<length; i++)
        {
            _patterns[i].print();
        }
        */


    }

    public function addPattern(pattern:Array, name:String = null)
    {
        if(!truePattern(pattern))
        {
            trace("Error: Array can not convert to true pattern");
            return;
        }

        var pats:Vector.<Pattern> = PatternUtils.createFrom2DArrays(new <Array>[pattern], new <String>[name]);

        var length:int = pats.length;
        for(var i:int=0; i<length; i++)
        {
            //pats[i].print();
        }

        _patterns = _patterns.concat(pats);
    }

    private function truePattern(pattern:Array):Boolean
    {
        if(!pattern || !pattern.length || !(pattern[0] is Array) || !(pattern[0].length))
        {
            trace("TruePattern Error: 1");
            return false;
        }

        var len:int = pattern.length;
        for(var r:int = 0; r <len; r++)
        {
            if(!(pattern[r] is Array) || !pattern[r].length)
            {
                trace("TruePattern Error: 2");
                return false;
            }

            var len2:int = pattern[r].length;
            for(var c:int = 0; c <len2; c++)
            {
                var value:Object = pattern[r][c];
                if(!(value is int || value is uint))
                {
                    trace("TruePattern Error: 3");
                    return false
                }
            }
        }

        return true;
    }


    private function get rand():int
    {
        return  int(1 + Math.random() * 10.99);
    }

    public static function get time():int
    {
        return _time;
    }
}
}
