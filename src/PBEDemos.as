package
{
    import com.greensock.OverwriteManager;
    import com.greensock.TweenMax;
    import com.pblabs.core.PBGameObject;
    import com.pblabs.core.PBGroup;
    import com.pblabs.debug.Console;
    import com.pblabs.debug.ConsoleCommandManager;
    import com.pblabs.debug.Logger;
    import com.pblabs.input.KeyboardManager;
    import com.pblabs.property.PropertyManager;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    import com.pblabs.time.TimeManager;
    import com.pblabs.util.TypeUtility;
    
    import demos.bindingDemo.BindingDemoScene;
    import demos.circlePickup.CirclePickupScene;
    import demos.circlePickupWithTimeManager.CirclePickupWithTimeManagerScene;
    import demos.molehill.MolehillScene;
    import demos.mouseFollower.MouseFollowScene;
    import demos.simplestRenderer.SimplestRendererScene;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    /**
     * Sweet PushButton Engine demo application.
     * https://github.com/PushButtonLabs/PushButtonEngine
     * 
     * This demo application cycles amongst multiple demo "scenes" to show off
     * various parts of the engine's capabilities. Use < and > to change the 
     * demo. Press ~ (tilde) to bring up the console. Type help to learn about
     * more commands.
     */
    [SWF(frameRate="32",wmode="direct")]
    public class PBEDemos extends Sprite
    {
        // Set up TweenMax plugins.
        OverwriteManager.init(OverwriteManager.AUTO);
        
        // Container for the active scene.
        public var rootGroup:PBGroup = new PBGroup();

        // List of the demo scenes we will cycle amongst.
        public var sceneList:Array = 
            [ SimplestRendererScene, BindingDemoScene, MouseFollowScene, 
                CirclePickupScene, CirclePickupWithTimeManagerScene, MolehillScene ];
        
        // Keep track of the current demo scene.
        public var currentSceneIndex:int = 0;
        public var currentScene:PBGroup;
        
        // UI Elements.
        public var sceneCaption:TextField = new TextField();
        
        public function PBEDemos()
        {
            // Set it so that the stage resizes properly.
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            // Set up the root group for the demo and register a few useful
            // managers.            
            rootGroup.initialize();
            rootGroup.name = "PBEDemoGroup";
            rootGroup.registerManager(Stage, stage);
            rootGroup.registerManager(PropertyManager, new PropertyManager());
            rootGroup.registerManager(ConsoleCommandManager, new ConsoleCommandManager());
            rootGroup.registerManager(TimeManager, new TimeManager());
            rootGroup.registerManager(KeyboardManager, new KeyboardManager());
            rootGroup.registerManager(Console, new Console());
            
            // Listen for keyboard events.
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            // Set up the scene caption.
            sceneCaption.autoSize = TextFieldAutoSize.LEFT;
            sceneCaption.text = "Loading..";
            sceneCaption.textColor = 0x0;
            sceneCaption.defaultTextFormat = new TextFormat(null, 48, 0x0, true);
            addChild(sceneCaption);
            
            // Make sure first scene is loaded.
            updateScene();
        }
        
        protected function updateScene():void
        {
            // Make sure the current index is valid.
            if(currentSceneIndex < 0)
                currentSceneIndex = sceneList.length - 1;
            else if(currentSceneIndex > sceneList.length - 1)
                currentSceneIndex = 0;
            
            // Note our change in state.
            Logger.print(this, "Changing scene to #" + currentSceneIndex + ": " + sceneList[currentSceneIndex]);
            
            // Destroy old scene and instantiate new scene.
            if(currentScene)
                currentScene.destroy();
            currentScene = new sceneList[currentSceneIndex];
            currentScene.owningGroup = rootGroup;
            currentScene.initialize();
            
            // Trigger UI.
            sceneCaption.text = TypeUtility.getObjectClassName(currentScene).split("::")[1];
            TweenMax.killTweensOf(sceneCaption);
            sceneCaption.alpha = 1;
            TweenMax.to(sceneCaption, 1.0, {alpha:0, delay: 2.0 }); 
        }
        
        /**
         * Global key handler to switch scenes.
         */
        protected function onKeyUp(ke:KeyboardEvent):void
        {
            // Handle keys.
            var keyAsString:String = String.fromCharCode(ke.charCode);
            var sceneChanged:Boolean = false;
            if(keyAsString == "<")
            {
                currentSceneIndex--;
                sceneChanged = true;
            }
            else if(keyAsString == ">")
            {
                currentSceneIndex++;
                sceneChanged = true;
            }
            
            if(sceneChanged)
            {
                updateScene();
            }
        }
    }
}