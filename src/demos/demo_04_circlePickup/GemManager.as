package demos.demo_04_circlePickup
{
    import com.pblabs.core.PBSet;
    
    import flash.geom.Point;
    import demos.SimplestDemoGameObject;

    /**
     * Simple manager class to kill objects in a set when another object
     * moves close to them.
     */
    public class GemManager
    {
        /**
         * Reference to the set holding the gems - the game objects we want
         * to pick up. 
         */
        public var gemSet:PBSet;
        
        /**
         * Reference to the game object that is gonna do the picking up. 
         */
        public var pickerUpper:SimplestDemoGameObject;
        
        /**
         * How close do we have to be to one of the gem game objects before we
         * pick it up? 
         */
        public var collisionRadius:Number = 35;
        
        /**
         * Called every frame by the CirclePickupScene to check if we should
         * pick something up.
         */
        public function process():void
        {
            // Find all circles within raius px of the pickerupper
            // and destroy() them.
            const pickerPos:Point = pickerUpper.spatial.position;
            
            // We could accelerate this with a more advanced data structure 
            // (like a loose quadtree) but for small numbers of objects this
            // works just fine.
            for(var i:int=0; i<gemSet.length; i++)
            {
                // See if it's in range...
                const circle:SimplestDemoGameObject = gemSet.getPBObjectAt(i) as SimplestDemoGameObject;
                if(Point.distance(circle.spatial.position, pickerPos) > collisionRadius)
                    continue;
                
                // Nuke it! And decrement i so we don't skip anything.
                circle.destroy();
                i--;
            }
        }
        
    }
}