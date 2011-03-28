package demos.molehill
{
    import com.pblabs.time.AnimatedComponent;
    
    import flash.geom.Point;
    
    public class QuadRenderer extends AnimatedComponent
    {
        [Inject]
        public var scene:QuadScene;

        public var texture:String;
        public var position:Point;
        public var rotation:Number;
        public var size:Point;
        
        public override function onFrame():void
        {
            super.onFrame();
            
            scene.addQuad(texture, position.x position.y, size.x, size.y, rotation);
        }
        
    }
}