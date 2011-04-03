package demos.demo_07_twoButtonDemo
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.input.KeyboardKey;
    import com.pblabs.input.KeyboardManager;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    
    public class TwoButtonDemoScene extends PBGroup implements ITicked
    {
        [Inject]
        public var stage:Stage;
        
        [Inject]
        public var timeManager:TimeManager;
        
        [Inject]
        public var keyboardManager:KeyboardManager;
        
        public var truthTable:Array = 
            [
                [ false, false, false, false, false  ],
                [ false, true, true, true, false ],
                [ true, false, false, false, true ],
                [ true, true, true, true, false]
            ];
        
        public var state:Array = [ false, false, false, false, false ];
        
        public var circleSprite:Sprite = new Sprite();
        
        public override function initialize():void
        {
            super.initialize();
            
            stage.addChild(circleSprite);
            
            redrawCircle();
            
            timeManager.addTickedObject(this);
        }
        
        public function onTick():void
        {
            var brake:Boolean = keyboardManager.isKeyDown(KeyboardKey.S.keyCode);
            var gas:Boolean = keyboardManager.isKeyDown(KeyboardKey.A.keyCode);
            var idx:int = (brake ? 1 : 0) + (gas ? 2 : 0);
            state = truthTable[idx];
            
            redrawCircle();
        }
        
        public function redrawCircle():void
        {
            circleSprite.graphics.clear();
            
            for(var i:int=0; i<5; i++)
            {
                circleSprite.graphics.beginFill(state[i] ? 0x00FF00 : 0xFF0000);
                circleSprite.graphics.drawCircle(50 + 100 * i, 100, 50);                
            }
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            stage.removeChild(circleSprite);
            
            super.destroy();
        }
    }
}