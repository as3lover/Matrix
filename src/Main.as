package {

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import tables.Cell;


import tables.Pattern;

import uitiliti.Utils;

public class Main extends Sprite
{
    private var _pattern:Pattern;
    private var _txt:TextField;

    public function Main()
    {
        _txt = new TextField();
        _txt.width = _txt.height = 200;
        _txt.x = 20;
        addChild(_txt)
        stage.addEventListener(MouseEvent.CLICK, click);
        setTimeout(click,2000)

        scaleX = scaleY = 2;
    }

    private function click(event:MouseEvent = null):void
    {
        _txt.text = "...";
        setTimeout(f,100)
    }

    private function f():void
    {
        var table = Pattern.random(20,20);
        table.print();



        var patterns:Vector.<Pattern> = new Vector.<Pattern>();
        for(var i:int = 0; i<1000;)
        {
            var p:Pattern = Pattern.random(rand,rand,0,1);
            p.trim();
            if(p.rows && p.cols)
            {
                //p.print()
                patterns.push(p);
                i = patterns.length
            }

            //Utils.searchPattern(p, table);
        }


        var time:uint = getTimer();
        var found:int = 0;
        var length:int = patterns.length;
        for(i = 0; i<length; i++)
        {
            if(Utils.searchPattern(patterns[i], table))
            {
                found++;
            }
        }

        time = getTimer() - time;

        trace("all:", length);
        trace("found:", found);
        trace("time:", time);

        _txt.text = ""
        _txt.text += String(length) +  " pattern \n"
        _txt.text += String(found) +  " match \n"
        _txt.text += String(time) +  " miliseconds  \n"
        _txt.text += String((time/length)) +  " miliseconds per pattern \n"

    }

    private function get rand():uint
    {
        return  int(1 + Math.random() * 6.99);
    }
}
}
