package demos.circlePickupWithTimeManager
{
    import com.pblabs.core.PBGameObject;
    import com.pblabs.core.PBGroup;
    import com.pblabs.core.PBSet;
    import com.pblabs.simpler.MouseFollowComponent;
    import com.pblabs.simpler.SimpleSpriteRenderer;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.geom.Point;
    import demos.SimplePartyGameObject;
    
    public class CirclePickupWithTimeManagerScene extends PBGroup implements ITicked
    {
        public var circleSet:PBSet;
        public var pickerUpper:SimplePartyGameObject;
        public const collisionRadius:Number = 35;
        
        [Inject]
        public var stage:Stage;
        
        public var timeManager:TimeManager = new TimeManager();
        
        public override function initialize():void
        {
            super.initialize();
            
            registerManager(TimeManager, timeManager);
            
            // Set up the PBSet for the gems.
            circleSet = new PBSet();
            circleSet.owningGroup = this;
            circleSet.initialize();
            
            // Make the guy that follows the mouse.
            pickerUpper = makeMouseFollower();
            
            // Make the gems.
            for(var i:int=0; i<20; i++)
                makeGem(new Point(stage.stageWidth * Math.random(), stage.stageHeight * Math.random()));
            
            timeManager.addTickedObject(this);
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            super.destroy();
        }
        
        public function onTick():void
        {
            // Find all circles within 20px of the pickerupper
            // and destroy() them.
            const pickerPos:Point = pickerUpper.spatial.position;
            
            for(var i:int=0; i<circleSet.length; i++)
            {
                // See if it's in range.
                const circle:SimplePartyGameObject = circleSet.getPBObjectAt(i) as SimplePartyGameObject;
                if(Point.distance(circle.spatial.position, pickerPos) > collisionRadius)
                    continue;
                
                // Nuke it! And decrement i so we don't skip any.
                circle.destroy();
                i--;
            }
        }        
        public function makeMouseFollower():SimplePartyGameObject
        {
            // Create the mouse follower.
            var go:SimplePartyGameObject = new SimplePartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            
            go.render = new SimpleSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            const mfc:MouseFollowComponent = new MouseFollowComponent();
            mfc.targetProperty = "@spatial.position";
            go.addComponent(mfc, "mouse");
            
            go.initialize();
            
            return go;
        }
        
        public function makeGem(pos:Point):SimplePartyGameObject
        {
            // Create the mouse follower.
            var go:SimplePartyGameObject = new SimplePartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            go.spatial.position = pos.clone();
            
            go.render = new SimpleSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            go.initialize(); 
            
            circleSet.add(go);
            
            return go;
        }
    }
}