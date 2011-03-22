package demos.circlePickup
{
    import com.pblabs.core.PBSet;
    
    import flash.geom.Point;
    import demos.SimplestPartyGameObject;

    public class CircleManager
    {
        public var circleSet:PBSet;
        public var pickerUpper:SimplestPartyGameObject;
        public var collisionRadius:Number = 35;
        
        public function process():void
        {
            // Find all circles within 20px of the pickerupper
            // and destroy() them.
            const pickerPos:Point = pickerUpper.spatial.position;
            
            for(var i:int=0; i<circleSet.length; i++)
            {
                // See if it's in range.
                const circle:SimplestPartyGameObject = circleSet.getPBObjectAt(i) as SimplestPartyGameObject;
                if(Point.distance(circle.spatial.position, pickerPos) > collisionRadius)
                    continue;
                
                // Nuke it! And decrement i so we don't skip any.
                circle.destroy();
                i--;
            }
        }
        
    }
}