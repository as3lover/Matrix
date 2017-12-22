package view
{
import com.greensock.TweenLite;
import com.greensock.easing.Back;

import flash.display.Sprite;

import uitiliti.Utils;

public class Candy extends Sprite
{
    public function Candy(width:int, height:int, color:uint)
    {
        Utils.drawRect(this, -(width-4)/2, -(height-4)/2, width-4, height-4, color);
    }

    public function hide(vars:Object = null):void
    {
        var delay:Number = 0;
        if(vars && vars.delay)
                delay = vars.delay;
        TweenLite.to(this, 1, {delay:delay, scaleX:0, scaleY:0, rotation:360, onComplete:remove});
    }

    private function remove():void
    {
        if(parent)
            parent.removeChild(this)
    }
}
}
