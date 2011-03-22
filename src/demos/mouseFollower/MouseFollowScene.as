package demos.mouseFollower
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    import demos.SimplestPartyGameObject;
    
    public class MouseFollowScene extends PBGroup
    {
        public override function initialize():void
        {
            super.initialize();
            
            // Create a party object.
            var go:SimplestPartyGameObject = new SimplestPartyGameObject();
            go.owningGroup = this;
            
            go.spatial = new SimplestSpatialComponent();
            
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            const mfc:SimplestMouseFollowComponent = new SimplestMouseFollowComponent();
            mfc.targetProperty = "@spatial.position";
            go.addComponent(mfc, "mouse");
            
            go.initialize();
        }
    }
}