package demos.simplestRenderer
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    
    import flash.geom.Point;
    import demos.SimplestPartyGameObject;
    
    public class SimplestRendererScene extends PBGroup
    {
        public override function initialize():void
        {
            super.initialize();
            
            // Create a party object.
            var go:SimplestPartyGameObject = new SimplestPartyGameObject();
            go.owningGroup = this;
            
            go.render = new SimplestSpriteRenderer();
            go.render.position = new Point(100, 150);

            go.initialize();
        }
    }
}