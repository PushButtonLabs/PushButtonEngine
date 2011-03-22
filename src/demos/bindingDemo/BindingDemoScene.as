package demos.bindingDemo
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    import demos.SimplestPartyGameObject;
    
    public class BindingDemoScene extends PBGroup
    {
        public override function initialize():void
        {
            super.initialize();
            
            // Create a party object.
            var go:SimplestPartyGameObject = new SimplestPartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            go.spatial.position.x = 100;
            go.spatial.position.y = 100;
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            go.initialize();
        }
    }
}