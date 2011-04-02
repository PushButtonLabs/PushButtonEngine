package
{
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
    
    [SWF(frameRate="32",wmode="direct")]
    public class PBEDemos extends Sprite
    {
        public var rootGroup:PBGroup = new PBGroup();
        
        public var sceneList:Array = 
            [ SimplestRendererScene, BindingDemoScene, MouseFollowScene, 
                CirclePickupScene, CirclePickupWithTimeManagerScene, MolehillScene ];
        
        public var currentSceneIndex:int = 0;
        public var currentScene:PBGroup;
        
        public function PBEDemos()
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            rootGroup.initialize();
            rootGroup.name = "RootGroup";
            rootGroup.registerManager(Stage, stage);
            rootGroup.registerManager(PropertyManager, new PropertyManager());
            rootGroup.registerManager(ConsoleCommandManager, new ConsoleCommandManager());
            rootGroup.registerManager(TimeManager, new TimeManager());
            rootGroup.registerManager(KeyboardManager, new KeyboardManager());
            rootGroup.registerManager(Console, new Console());
            
            // Listen for keyboard events.
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            // Make sure first scene is loaded.
            updateScene();
        }
        
        protected function updateScene():void
        {
            // Wrap the index.
            if(currentSceneIndex < 0)
                currentSceneIndex = sceneList.length - 1;
            else if(currentSceneIndex > sceneList.length - 1)
                currentSceneIndex = 0;
            
            Logger.print(this, "Changing scene to #" + currentSceneIndex + ": " + sceneList[currentSceneIndex]);
            
            // Destroy old scene and make new scene.
            if(currentScene)
                currentScene.destroy();
            currentScene = new sceneList[currentSceneIndex];
            currentScene.owningGroup = rootGroup;
            currentScene.initialize();
        }
        
        
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