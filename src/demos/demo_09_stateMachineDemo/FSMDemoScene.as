package demos.demo_09_stateMachineDemo
{
    
    import com.pblabs.core.PBGroup;
    import com.pblabs.input.KeyboardKey;
    import com.pblabs.input.KeyboardManager;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    
    public class FSMDemoScene extends PBGroup implements ITicked
    {
        [Inject]
        public var stage:Stage;
        
        [Inject]
        public var timeManager:TimeManager;
        
        [Inject]
        public var keyboardManager:KeyboardManager;
        
        public var state:String = "Idle";
        public var stateEnterTime:int = 0;
        public var position:int = 0;
        
        public var circleSprite:Sprite = new Sprite();
        public var stateIndicator:TextField = new TextField();
        
        public override function initialize():void
        {
            super.initialize();
            
            stage.addChild(circleSprite);
            stage.addChild(stateIndicator);
            
            stateIndicator.y = stage.stageHeight - 64;
            stateIndicator.autoSize = TextFieldAutoSize.LEFT;
            stateIndicator.mouseEnabled = false;
            stateIndicator.textColor = 0x0;
            stateIndicator.defaultTextFormat = new TextFormat(null, 48, 0x0, true);
            
            redrawCircle();
            
            timeManager.addTickedObject(this);
        }
        
        public function gotoState(name:String):void 
        {
            state = name;
            stateEnterTime = timeManager.virtualTime;
        }
        
        public function advanceState():void
        {
            switch(state)
            {
                case "Idle":
                    if(keyboardManager.isKeyDown(KeyboardKey.A.keyCode))
                    {
                        gotoState("StartLeft");
                        return;
                    }
                    
                    if(keyboardManager.isKeyDown(KeyboardKey.S.keyCode))
                    {
                        gotoState("StartRight");
                        return;
                    }
                    break;
                
                case "StartLeft":
                    if(timeManager.virtualTime - stateEnterTime > 100)
                    {
                        gotoState("Left");
                        return;
                    }
                    break;
                
                case "StartRight":
                    if(timeManager.virtualTime - stateEnterTime > 100)
                    {
                        gotoState("Right");
                        return;
                    }
                    break;
                
                case "Left":
                    position -= 1;
                    if(keyboardManager.isKeyDown(KeyboardKey.S.keyCode))
                    {
                        gotoState("StopLeft");
                        return;
                    }
                    break;
                
                case "Right":
                    position += 1;
                    if(keyboardManager.isKeyDown(KeyboardKey.A.keyCode))
                    {
                        gotoState("StopRight");
                        return;
                    }
                    break;
                
                case "StopLeft":
                    if(timeManager.virtualTime - stateEnterTime > 250)
                    {
                        gotoState("Idle");
                        return;
                    }
                    break;
                
                case "StopRight":
                    if(timeManager.virtualTime - stateEnterTime > 250)
                    {
                        gotoState("Idle");
                        return;
                    }
                    break;
            }    
        }
        
        public function onTick():void
        {
            advanceState();
            
            redrawCircle();
            
            stateIndicator.text = state;
        }
        
        public function redrawCircle():void
        {
            circleSprite.graphics.clear();
            circleSprite.graphics.beginFill(state == "Idle" ? 0x00FF00 : 0xFF0000);
            circleSprite.graphics.drawCircle(100 + position * 4, 100, 50);            
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            stage.removeChild(stateIndicator);
            stage.removeChild(circleSprite);
            
            super.destroy();
        }
    }
}