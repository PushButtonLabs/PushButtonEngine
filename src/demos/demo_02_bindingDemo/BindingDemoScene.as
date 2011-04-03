package demos.demo_02_bindingDemo
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    import demos.SimplestDemoGameObject;
    
    /**
     * Very simple demo showing how to use the component data binding system. 
     * 
     * Read on for details...
     */
    public class BindingDemoScene extends PBGroup
    {
        public override function initialize():void
        {
            super.initialize();
            
            // Create a party object.
            var go:SimplestDemoGameObject = new SimplestDemoGameObject();
            go.owningGroup = this;
            
            // Set up the spatial.
            go.spatial = new SimplestSpatialComponent();
            go.spatial.position.x = 100;
            go.spatial.position.y = 100;
            
            // Set up the renderer, and...
            go.render = new SimplestSpriteRenderer();
            
            // Use component data binding to map the position field on the renderer
            // to the position field on the spatial component. Now, every time
            // applyBindings() is called, the value on the spatial will be copied
            // over. If you look in SimplestSpriteRenderer, you'll see this is
            // done every frame.
            go.render.addBinding("position", "@spatial.position");
            
            // And tell the object it's good to go!
            go.initialize();
            
            // Now you will see the renderer's circle appearing at the location
            // specified on the spatial.
            
            // Onto MouseFollowerScene to see this in action!
        }
    }
}