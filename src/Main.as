package {

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getTimer;

import net.hires.debug.Stats;

import tables.Pattern;
import uitiliti.PatternUtils;

import view.Table;

[SWF(width="400", height="400", backgroundColor="0xffffff", frameRate="60")]

public class Main extends Sprite
{
    private var _txt:TextField;
    private var _patterns:Vector.<Pattern>;
    private var _table:Table;
    private var status:Stats;

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

        start();

        var p:Array = [
            [1,0,0],
            [0,1,0],
            [0,0,1]
        ]
        addPattern(p,"مورب");


        _table = new Table();
        addChild(_table);

        reset();

        stage.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function reset():void
    {
        var pattern:Pattern = Pattern.random(15,15,0,6);
        _table.start(pattern);
    }

    private function onClick(event:MouseEvent):void
    {
        setChildIndex(_txt, numChildren-1);
        setChildIndex(status, numChildren-1);
        var time:int = getTimer();
        var len:int = _patterns.length;

        for (var i:int = 0; i < len; i++)
        {
            if(_table.exist(_patterns[i]))
            {
                _txt.text =_txt.text + "\t" + String(getTimer() - time);
                return
            }
        }

        var pattern:Pattern = Pattern.random(15,15,0,6);
        _table.start(pattern);
    }

    private function start():void
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

        _patterns = create(list, names);

        var length:int = _patterns.length;
        for(var i:int=0; i<length; i++)
        {
            //_patterns[i].print();
        }

    }

    public function addPattern(pattern:Array, name:String = null)
    {
        if(!truePattern(pattern))
        {
            trace("Error: Array can not convert to true pattern");
            return;
        }

        var pats:Vector.<Pattern> = create(new <Array>[pattern], new <String>[name]);

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

    private function create(list:Vector.<Array>, names:Vector.<String> = null):Vector.<Pattern>
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


    private function getPattern(p:Array, trim:Boolean = false, name:String = null):Pattern
    {
        var matrix:Vector.<Vector.<int>> = PatternUtils.arrayToVector(p);

        var pattern:Pattern = Pattern.byMatrix(matrix, name);
        if(trim)
            pattern.trim();
        return pattern;
    }

    private function patternTo4(p1:Pattern):Vector.<Pattern>
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
                if(PatternUtils.searchPattern(p[i],p[j]))
                {
                    var last = p.pop();
                    if(i < p.length)
                    {
                        p[i] = last
                    }
                    break;
                }
            }
        }

        return p;
    }

    private function rotatePattern(p:Pattern, rotation:int = 0):Pattern
    {
        var m:Vector.<Vector.<int>> = p.copyMatrix();
        var copy:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

        var cols:int = m[0].length;
        var rows:int = m.length;
        for(var c:int=0; c<cols; c++)
        {
            var row:Vector.<int> = new Vector.<int>();
            copy.push(row);

            for(var r:int=rows-1; r>-1; r--)
            {
                row.push(m[r][c]);
            }
        }

        var pattern:Pattern = Pattern.byMatrix(copy, p.name, rotation);
        return pattern;

    }


    private function get rand():uint
    {
        return  int(1 + Math.random() * 10.99);
    }
}
}
