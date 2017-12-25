package utilities.display
{

public class Utils
{
    public static function drawRect(obj:Object, x:int, y:int, width:int, height:int, color:int = 0x333333, lineWidth:Number = 0, lineColor:int = 0x0, backAlpha:Number = 1, lineAlpha:Number = 1):void
    {
        //var obj:Sprite = obj as Sprite;

        if(lineWidth)
            obj.graphics.lineStyle(lineWidth, lineColor, lineAlpha);
        if(color == -1)
            obj.graphics.endFill();
        else
            obj.graphics.beginFill(color, backAlpha);
        obj.graphics.drawRect(x, y, width, height);
        obj.graphics.endFill();
    }
}
}
