package demos.molehill
{
    import com.pblabs.core.PBComponent;
    
    import flash.geom.Point;
    
    public class RandomMover extends PBComponent
    {
        protected var _position:Point = new Point();
        public function get position():Point
        {
            _position.x = Math.random() * 1024;
            _position.y = Math.random() * 1024;
            
            return _position;
        }
    }
}