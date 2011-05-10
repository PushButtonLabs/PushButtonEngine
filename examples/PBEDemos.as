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
    
    import demos.demo_01_simplestRenderer.SimplestRendererScene;
    import demos.demo_02_bindingDemo.BindingDemoScene;
    import demos.demo_03_mouseFollower.MouseFollowerScene;
    import demos.demo_04_circlePickup.CirclePickupScene;
    import demos.demo_05_circlePickupWithTimeManager.CirclePickupWithTimeManagerScene;
    import demos.demo_06_oneButtonDemo.OneButtonDemoScene;
    import demos.demo_07_twoButtonDemo.TwoButtonDemoScene;
    import demos.demo_08_carDemo.CarDemoScene;
    import demos.demo_09_stateMachineDemo.FSMDemoScene;
    import demos.molehill.MolehillScene;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
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
     * 
     * The demo scenes are all implemented in their own classes that live in 
     * the demo package. A great way to learn the engine is to read through
     * each demo, in order, and look at the demo app at the same time. 
     */
    [SWF(frameRate="32",wmode="direct")]
    public class PBEDemos extends Sprite
    {
        // Set up TweenMax plugins.
        OverwriteManager.init(OverwriteManager.AUTO);
        
        // Container for the active scene.
        public var rootGroup:PBGroup = new PBGroup();

        // List of the demo scenes we will cycle amongst.
        // The molehill demo requires a molehill enabled dev environment.
        public var sceneList:Array = 
            [ SimplestRendererScene, BindingDemoScene, MouseFollowerScene, 
                CirclePickupScene, CirclePickupWithTimeManagerScene, 
                OneButtonDemoScene, TwoButtonDemoScene, CarDemoScene,
                FSMDemoScene
            /*, MolehillScene*/ ];
        
        // Keep track of the current demo scene.
        public var currentSceneIndex:int = 0;
        public var currentScene:PBGroup;
        
        // UI Elements.
        public var sceneCaption:TextField = new TextField();
        public var usageCaption:TextField = new TextField();
        public var pauseCaption:TextField = new TextField();
        
        /**
         * Initialize the demo and show the first scene.
         */
        public function PBEDemos()
        {
            // Set it so that the stage resizes properly.
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            // Set up the root group for the demo and register a few useful
            // managers. Managers are available via dependency injection to the
            // demo scenes and objects.
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
            
            // Detect when the app gains or loses focus; we will display a 
            // pause caption in this case and pause the TimeManager.
            stage.addEventListener(Event.DEACTIVATE, onDeactivate);
            stage.addEventListener(Event.ACTIVATE, onActivate);

            // Set up the scene caption.
            sceneCaption.autoSize = TextFieldAutoSize.LEFT;
            sceneCaption.text = "Loading..";
            sceneCaption.mouseEnabled = false;
            sceneCaption.textColor = 0x0;
            sceneCaption.defaultTextFormat = new TextFormat(null, 48, 0x0, true);
            addChild(sceneCaption);
            
            // Set up the usage caption.
            usageCaption.autoSize = TextFieldAutoSize.CENTER;
            usageCaption.y = stage.stageHeight - 32;
            usageCaption.x = 0;
            usageCaption.mouseEnabled = false;
            usageCaption.width = stage.stageWidth;
            usageCaption.defaultTextFormat = new TextFormat(null, 24, 0x0, true);
            usageCaption.text = "~ for console, < for previous demo, > for next demo.";
            usageCaption.textColor = 0x0;
            addChild(usageCaption);
            
            // Set up the paused caption.
            pauseCaption.autoSize = TextFieldAutoSize.CENTER;
            pauseCaption.y = stage.stageHeight/2 - 64;
            pauseCaption.x = 0;
            pauseCaption.mouseEnabled = false;
            pauseCaption.width = stage.stageWidth;
            pauseCaption.defaultTextFormat = new TextFormat(null, 48, 0xFF0000, true);
            pauseCaption.text = "Paused!";
            pauseCaption.textColor = 0x0;
            addChild(pauseCaption);
            
            // Make sure first scene is loaded.
            updateScene();
        }
        
        /**
         * Called when we lose focus; we fade in the pause caption and set
         * the TimeManager timeScale to zero to pause our game. Note this only
         * affects things that use the TimeManager, not components that directly
         * listen for Event.ENTER_FRAME! 
         */
        protected function onDeactivate(e:Event):void
        {
            TweenMax.to(pauseCaption, 1.0, {alpha: 1});
            (rootGroup.getManager(TimeManager) as TimeManager).timeScale = 0;
        }

        /**
         * Called when we gain focus; we fade out the pause caption and set
         * the TimeManager timeScale to one to resume our game. Note this only
         * affects things that use the TimeManager, not components that directly
         * listen for Event.ENTER_FRAME! 
         */
        protected function onActivate(e:Event):void
        {
            TweenMax.to(pauseCaption, 1.0, {alpha: 0});
            (rootGroup.getManager(TimeManager) as TimeManager).timeScale = 1;
        }

        /**
         * Called when the scene index is changed, to make sure the index is
         * valid, then to destroy the old demo scene, create the new demo scene,
         * and to update the UI.
         */
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
            // Handle keys. We do this directly for simplicity.
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