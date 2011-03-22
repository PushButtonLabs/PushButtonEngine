package demos.circlePickup
{
    import com.pblabs.core.PBGameObject;
    import com.pblabs.core.PBGroup;
    import com.pblabs.core.PBSet;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.geom.Point;
    import demos.SimplestPartyGameObject;
    
    public class CirclePickupScene extends PBGroup
    {
        public var gemSet:PBSet;
        
        public var circleManager:CircleManager = new CircleManager();
        
        [Inject]
        public var stage:Stage;
        
        public override function initialize():void
        {
            super.initialize();
            
            // Set up the PBSet for the gems.
            gemSet = new PBSet();
            gemSet.owningGroup = this;
            gemSet.initialize();
            
            circleManager.circleSet = gemSet;
            
            // Make the guy that follows the mouse.
            circleManager.pickerUpper = makeMouseFollower();
            
            // Make the gems.
            for(var i:int=0; i<20; i++)
                makeGem(new Point(stage.stageWidth * Math.random(), stage.stageHeight * Math.random()));
            
            stage.addEventListener(Event.ENTER_FRAME, onFrame);
        }
        
        public override function destroy():void
        {
            stage.removeEventListener(Event.ENTER_FRAME, onFrame);

            super.destroy();
        }
        
        protected function onFrame(e:Event):void
        {
            circleManager.process();
        }
        
        public function makeMouseFollower():SimplestPartyGameObject
        {
            // Create the mouse follower.
            var go:SimplestPartyGameObject = new SimplestPartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            const mfc:SimplestMouseFollowComponent = new SimplestMouseFollowComponent();
            mfc.targetProperty = "@spatial.position";
            go.addComponent(mfc, "mouse");
            
            go.initialize();
            
            return go;
        }
        
        public function makeGem(pos:Point):SimplestPartyGameObject
        {
            // Create the mouse follower.
            var go:SimplestPartyGameObject = new SimplestPartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            go.spatial.position = pos.clone();
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            go.initialize(); 
            
            gemSet.add(go);
            
            return go;
        }
    }
}