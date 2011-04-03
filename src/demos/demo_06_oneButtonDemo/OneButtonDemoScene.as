package demos.demo_06_oneButtonDemo
{
    import com.pblabs.PBUtil;
    import com.pblabs.core.PBGroup;
    import com.pblabs.input.KeyboardKey;
    import com.pblabs.input.KeyboardManager;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    
    public class OneButtonDemoScene extends PBGroup implements ITicked
    {
        [Inject]
        public var stage:Stage;
        
        [Inject]
        public var timeManager:TimeManager;
        
        [Inject]
        public var keyboardManager:KeyboardManager;
        
        public var state:Boolean;
        
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
            state = keyboardManager.isKeyDown(KeyboardKey.A.keyCode);
            
            redrawCircle();
        }
        
        public function redrawCircle():void
        {
            circleSprite.graphics.clear();
            circleSprite.graphics.beginFill(state ? 0x00FF00 : 0xFF0000);
            circleSprite.graphics.drawCircle(
                stage.stageWidth / 2, 
                stage.stageHeight / 2, 
                Math.min(stage.stageHeight, stage.stageWidth) / 3.5);
            circleSprite.graphics.endFill();
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            stage.removeChild(circleSprite);
            
            super.destroy();
        }
    }
}