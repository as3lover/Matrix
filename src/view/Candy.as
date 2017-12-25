package view
{
import com.greensock.TweenLite;
import com.greensock.easing.Back;

import flash.display.Sprite;

import utilities.display.Utils;

public class Candy extends Sprite
{
    private static var _pool:Vector.<Candy> = new <Candy>[];
    private static var _len:int = 0;
    private static var _fromPool:Boolean = false;

    public function Candy(width:int, height:int, color:int)
    {
        if (!_fromPool)
            throw new Error("For Create new Candy, use Candy.fromPool");

        draw(width, height, color);
    }

    private function draw(width:int, height:int, color:int):void
    {
        Utils.drawRect(this, -(width-4)/2, -(height-4)/2, width-4, height-4, color);
    }

    public function dispose():void
    {
        TweenLite.killTweensOf(this);

        if(parent)
            parent.removeChild(this);

        graphics.clear();
        scaleX = scaleY = 1;
        _pool[_len] = this;
        _len++;
    }

    public static function fromPool(width:int, height:int, color:int):Candy
    {
        if(_len)
        {
            _len --;
            _pool[_len].draw(width, height, color);
            return _pool[_len];
        }
        else
        {
            _fromPool = true;
            return new Candy(width, height, color);
        }
    }

    public function hide(vars:Object = null):void
    {
        var delay:Number = 0;
        if(vars && vars.delay)
                delay = vars.delay;
        TweenLite.to(this, 1, {delay:delay, scaleX:0, scaleY:0, rotation:360, onComplete:dispose});
    }

}
}
